import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../core/theme.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SuperAdminPortal extends StatefulWidget {
  const SuperAdminPortal({super.key});

  @override
  State<SuperAdminPortal> createState() => _SuperAdminPortalState();
}

class _SuperAdminPortalState extends State<SuperAdminPortal> {
  final _supabase = Supabase.instance.client;
  bool _isLoading = true;
  int _totalCompanies = 0;
  int _totalUsers = 0;
  List<Map<String, dynamic>> _companies = [];

  @override
  void initState() {
    super.initState();
    _fetchStats();
  }

  Future<void> _fetchStats() async {
    try {
      final companies = await _supabase.from('companies').select();
      final users = await _supabase.from('profiles').select('id');
      
      setState(() {
        _companies = List<Map<String, dynamic>>.from(companies);
        _totalCompanies = _companies.length;
        _totalUsers = users.length;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Super Admin fetch error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('OVERALL CONTROL', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.5, fontSize: 16)),
        centerTitle: true,
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSystemOverview(),
                const SizedBox(height: 32),
                const Text('Registered Companies', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                _buildCompanyList(),
              ],
            ),
          ),
    );
  }

  Widget _buildSystemOverview() {
    return Row(
      children: [
        Expanded(child: _buildGlobalStat('Companiess', _totalCompanies.toString(), LucideIcons.building2, Colors.blue)),
        const SizedBox(width: 16),
        Expanded(child: _buildGlobalStat('Total Users', _totalUsers.toString(), LucideIcons.users, Colors.purple)),
      ],
    );
  }

  Widget _buildGlobalStat(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 12),
          Text(value, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          Text(label, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildCompanyList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _companies.length,
      itemBuilder: (context, index) {
        final company = _companies[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.circular(20),
          ),
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: CircleAvatar(
              backgroundColor: Colors.white.withOpacity(0.05),
              child: const Icon(LucideIcons.building, color: AppTheme.textSecondary),
            ),
            title: Text(company['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(company['domain'] ?? 'No domain set', style: const TextStyle(fontSize: 12)),
            trailing: IconButton(
              icon: const Icon(LucideIcons.moreVertical, size: 20),
              onPressed: () {},
            ),
          ),
        );
      },
    );
  }
}
