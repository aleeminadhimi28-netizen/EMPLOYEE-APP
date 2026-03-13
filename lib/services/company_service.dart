import 'package:supabase_flutter/supabase_flutter.dart';

class CompanyService {
  SupabaseClient get _supabase => Supabase.instance.client;

  Future<int> createCompany(String name, String domain) async {
    final response = await _supabase
        .from('companies')
        .insert({'name': name, 'domain': domain})
        .select()
        .single();
    return response['id'];
  }

  Future<void> linkUserToCompany(String userId, int companyId, String role) async {
    await _supabase
        .from('profiles')
        .update({'company_id': companyId, 'role': role})
        .eq('id', userId);
  }
}
