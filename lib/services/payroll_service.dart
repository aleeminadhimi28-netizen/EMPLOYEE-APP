import 'package:supabase_flutter/supabase_flutter.dart';

class PayrollService {
  final _supabase = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> getMyPayroll(String userId) async {
    final response = await _supabase
        .from('payroll')
        .select('*')
        .eq('user_id', userId)
        .order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(response);
  }

  // Admin function to calculate monthly payroll
  Future<void> runMonthlyPayroll(String month) async {
    // 1. Fetch all employees
    // 2. Fetch all attendance logs for the month
    // 3. Calculate base salary - deductions (late) + overtime
    // 4. Insert into 'payroll' table
    
    // This is a simplified logic placeholder
    final employees = await _supabase.from('profiles').select('id, full_name');
    
    for (var emp in employees) {
      // Dummy calculation logic
      double base = 3000.0;
      double overtime = 150.0;
      double deductions = 50.0;
      double total = base + overtime - deductions;

      await _supabase.from('payroll').insert({
        'user_id': emp['id'],
        'month': month,
        'base_salary': base,
        'overtime_hours': 10, // Example
        'deductions': deductions,
        'total_payout': total,
        'status': 'pending',
      });
    }
  }
}
