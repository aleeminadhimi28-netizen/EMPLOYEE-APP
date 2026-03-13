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
    final employees = await _supabase.from('profiles').select('id, full_name, role');
    
    for (var emp in employees) {
      // 1. Fetch attendance for this employee in the specified month
      final logs = await _supabase
          .from('attendance')
          .select()
          .eq('user_id', emp['id'])
          .gte('check_in', '$month-01')
          .lte('check_in', '$month-31');

      // 2. Calculation logic
      double base = 3500.0; // In a real app, this would be in 'profiles.base_salary'
      int presentDays = logs.length;
      double overtime = 0;
      double deductions = (22 - presentDays) * 150.0; // Simple deduction for missed days (assuming 22 work days)
      
      if (deductions < 0) {
        overtime = (presentDays - 22) * 200.0; // Bonus for extra days
        deductions = 0;
      }

      double total = base + overtime - deductions;

      await _supabase.from('payroll').insert({
        'user_id': emp['id'],
        'month': month,
        'base_salary': base,
        'overtime_hours': overtime / 20.0, // Calculated back to hours for display
        'deductions': deductions,
        'total_payout': total,
        'status': 'pending',
      });
    }
  }
}
