import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../core/theme.dart';
import '../../services/company_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SetupCompanyScreen extends StatefulWidget {
  const SetupCompanyScreen({super.key});

  @override
  State<SetupCompanyScreen> createState() => _SetupCompanyScreenState();
}

class _SetupCompanyScreenState extends State<SetupCompanyScreen> {
  final _nameController = TextEditingController();
  final _domainController = TextEditingController();
  final _service = CompanyService();
  bool _isLoading = false;

  Future<void> _setup() async {
    if (_nameController.text.isEmpty) return;
    
    setState(() => _isLoading = true);
    try {
      final userId = Supabase.instance.client.auth.currentUser?.id;
      if (userId == null) throw 'User not authenticated';

      final companyId = await _service.createCompany(
        _nameController.text,
        _domainController.text,
      );

      await _service.linkUserToCompany(userId, companyId, 'admin');

      if (mounted) {
        Navigator.pushReplacementNamed(context, '/dashboard');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(LucideIcons.building2, size: 64, color: AppTheme.primary),
              const SizedBox(height: 24),
              const Text(
                'Register Your Company',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 32),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Company Name'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _domainController,
                decoration: const InputDecoration(labelText: 'Business Domain (e.g. acme.com)'),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _isLoading ? null : _setup,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 56),
                ),
                child: _isLoading 
                  ? const CircularProgressIndicator()
                  : const Text('Create Organization'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
