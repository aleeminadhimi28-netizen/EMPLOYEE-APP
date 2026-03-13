import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../core/theme.dart';
import '../../services/admin_service.dart';
import '../../services/auth_service.dart';
import 'package:provider/provider.dart';

class AdminPortal extends StatefulWidget {
  const AdminPortal({super.key});

  @override
  State<AdminPortal> createState() => _AdminPortalState();
}

class _AdminPortalState extends State<AdminPortal> with SingleTickerProviderStateMixin {
  final _service = AdminService();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final company = Provider.of<AuthService>(context).currentCompany;
    final companyId = company?['id'];

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Organizational Control', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            Text(company?['name'] ?? 'Loading...', style: const TextStyle(fontSize: 12, color: AppTheme.primary)),
          ],
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Overview', icon: Icon(LucideIcons.layoutGrid, size: 18)),
            Tab(text: 'Settings', icon: Icon(LucideIcons.settings, size: 18)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.download),
            onPressed: () => _service.generateAttendanceReport(),
            tooltip: 'Export PDF',
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: companyId == null 
        ? const Center(child: CircularProgressIndicator())
        : TabBarView(
            controller: _tabController,
            children: [
              _buildOverviewTab(companyId),
              _buildSettingsTab(company),
            ],
          ),
    );
  }

  Widget _buildOverviewTab(int companyId) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _service.getCompanyAttendance(companyId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final data = snapshot.data ?? [];

        return CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: _buildSummaryGrid(),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => _buildAttendanceTile(data[index]),
                  childCount: data.length,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSettingsTab(Map<String, dynamic>? company) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSettingSection('Company Details', [
            _buildSettingTile('Name', company?['name'] ?? 'N/A', LucideIcons.building, null),
            _buildSettingTile('Domain', company?['domain'] ?? 'Not set', LucideIcons.globe, null),
          ]),
          const SizedBox(height: 24),
          _buildSettingSection('Organization Controls', [
            _buildSettingTile('Work Sites', 'Manage geofences', LucideIcons.mapPin, null),
            _buildSettingTile('Team Directory', 'Manage employees', LucideIcons.users, null),
          ]),
          const SizedBox(height: 32),
          Center(
            child: TextButton.icon(
              onPressed: () {}, 
              icon: const Icon(LucideIcons.alertTriangle, color: Colors.red),
              label: const Text('Delete Organization Data', style: TextStyle(color: Colors.red)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.textSecondary, fontSize: 13)),
        const SizedBox(height: 12),
        ...children,
      ],
    );
  }

  Widget _buildSettingTile(String title, String value, IconData icon, VoidCallback? onTap) {
    return ListTile(
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, size: 20, color: AppTheme.primary),
      title: Text(title, style: const TextStyle(fontSize: 14)),
      subtitle: Text(value, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
      trailing: const Icon(LucideIcons.chevronRight, size: 16, color: AppTheme.textSecondary),
    );
  }

  Widget _buildSummaryGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.5,
      children: [
        _buildStatCard('Active Now', '24', LucideIcons.users, Colors.green, null),
        _buildStatCard('Late Today', '3', LucideIcons.clock, Colors.orange, null),
        _buildStatCard('View Analytics', 'Trends', LucideIcons.barChart3, AppTheme.primary, () => Navigator.pushNamed(context, '/analytics')),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color, VoidCallback? onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 8),
            Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Text(title, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _buildAttendanceTile(Map<String, dynamic> item) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppTheme.primary.withOpacity(0.1),
          child: const Icon(LucideIcons.user, color: AppTheme.primary, size: 20),
        ),
        title: Text(item['profiles']['full_name'] ?? 'Staff Member'),
        subtitle: Text(item['check_in'].toString().substring(0, 16)),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: item['status'] == 'present' ? Colors.green.withOpacity(0.1) : Colors.orange.withOpacity(0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            item['status'].toString().toUpperCase(),
            style: TextStyle(
              color: item['status'] == 'present' ? Colors.green : Colors.orange,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
