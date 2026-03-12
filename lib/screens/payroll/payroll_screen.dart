import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/theme.dart';
import '../../services/payroll_service.dart';

class PayrollScreen extends StatelessWidget {
  const PayrollScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final service = PayrollService();
    final userId = Supabase.instance.client.auth.currentUser?.id;

    return Scaffold(
      appBar: AppBar(title: const Text('My Salary & Payouts')),
      body: userId == null 
        ? const Center(child: Text('Authentication Required'))
        : FutureBuilder<List<Map<String, dynamic>>>(
            future: service.getMyPayroll(userId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              final payrolls = snapshot.data ?? [];

              if (payrolls.isEmpty) {
                return _buildEmptyState();
              }

              return ListView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: payrolls.length,
                itemBuilder: (context, index) => _buildPayrollCard(payrolls[index]),
              );
            },
          ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(LucideIcons.banknote, size: 64, color: AppTheme.textSecondary.withOpacity(0.3)),
          const SizedBox(height: 16),
          const Text('No payroll records found', style: TextStyle(color: AppTheme.textSecondary)),
        ],
      ),
    );
  }

  Widget _buildPayrollCard(Map<String, dynamic> data) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(data['month'], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: data['status'] == 'paid' ? Colors.green.withOpacity(0.1) : Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    data['status'].toUpperCase(),
                    style: TextStyle(
                      color: data['status'] == 'paid' ? Colors.green : Colors.orange,
                      fontSize: 10, 
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: 32),
            _buildRow('Base Salary', '\$${data['base_salary']}'),
            _buildRow('Overtime', '+\$${data['overtime_hours'] * 15}'), // Simplified calc
            _buildRow('Deductions', '-\$${data['deductions']}', isNegative: true),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Total Payout', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Text(
                  '\$${data['total_payout']}', 
                  style: const TextStyle(color: AppTheme.primary, fontWeight: FontWeight.bold, fontSize: 20)
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(String label, String value, {bool isNegative = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AppTheme.textSecondary)),
          Text(value, style: TextStyle(color: isNegative ? Colors.redAccent : Colors.white)),
        ],
      ),
    );
  }
}
