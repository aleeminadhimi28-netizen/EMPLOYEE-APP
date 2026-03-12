import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import { createClient } from "https://esm.sh/@supabase/supabase-js@2"

serve(async (req) => {
  try {
    const { month } = await req.json() // e.g., "2026-03"

    const supabase = createClient(
      Deno.env.get('SUPABASE_URL') ?? '',
      Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? ''
    )

    // 1. Fetch all active employees
    const { data: employees } = await supabase.from('profiles').select('id, full_name')

    for (const emp of employees ?? []) {
      // 2. Fetch attendance logs for the month
      const { data: logs } = await supabase
        .from('attendance')
        .select('status, check_in')
        .eq('user_id', emp.id)
        .gte('check_in', `${month}-01`)
        .lte('check_in', `${month}-31`)

      // 3. Calculation Logic
      const presentCount = logs?.filter(l => l.status === 'present').length ?? 0
      const lateCount = logs?.filter(l => l.status === 'late').length ?? 0
      
      const baseSalary = 3000 // In a real app, fetch from employee profile
      const lateDeduction = lateCount * 50
      const totalPayout = baseSalary - lateDeduction

      // 4. Update Payroll Ledger
      await supabase.from('payroll').insert({
        user_id: emp.id,
        month: month,
        base_salary: baseSalary,
        deductions: lateDeduction,
        total_payout: totalPayout,
        status: 'pending'
      })
    }

    return new Response(JSON.stringify({ success: true, processed: employees?.length }), {
      headers: { "Content-Type": "application/json" },
    })
  } catch (error) {
    return new Response(JSON.stringify({ error: error.message }), {
      status: 500,
      headers: { "Content-Type": "application/json" },
    })
  }
})
