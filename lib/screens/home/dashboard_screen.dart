import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../core/theme.dart';
import '../../services/auth_service.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          Provider.of<AuthService>(context).currentCompany?['name'] ?? 'Project XYZ',
          style: const TextStyle(fontWeight: FontWeight.w800, letterSpacing: -1),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.bell),
            onPressed: () {},
          ).animate().shake(delay: const Duration(seconds: 1)),
          const SizedBox(width: 8),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.topLeft,
            radius: 1.5,
            colors: [
              AppTheme.primary.withOpacity(0.15),
              AppTheme.background,
              AppTheme.secondary.withOpacity(0.1),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context),
                const SizedBox(height: 32),
                _buildProgressSection(context),
                const SizedBox(height: 32),
                Text(
                  'Operations',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ).animate().fadeIn(delay: const Duration(milliseconds: 400)).slideX(),
                const SizedBox(height: 16),
                _buildGridActions(context),
                const SizedBox(height: 32),
                _buildRecentActivity(context),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Good Morning,', style: TextStyle(color: AppTheme.textSecondary, fontSize: 16)),
            Text('Associate', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
          ],
        ).animate().fadeIn().slideX(),
        const CircleAvatar(
          radius: 28,
          backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=commander'),
        ).animate().scale(),
      ],
    );
  }

  Widget _buildProgressSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF334155), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Weekly Efficiency', style: TextStyle(fontWeight: FontWeight.w600)),
              Text('92%', style: TextStyle(color: AppTheme.primary, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: 0.92,
              minHeight: 8,
              backgroundColor: Colors.white.withOpacity(0.05),
              valueColor: const AlwaysStoppedAnimation(AppTheme.primary),
            ),
          ).animate().shimmer(duration: const Duration(seconds: 2)),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildMiniStat('14', 'Pending'),
              _buildMiniStat('08', 'Verified'),
              _buildMiniStat('02', 'Alerts'),
            ],
          )
        ],
      ),
    ).animate().fadeIn(delay: const Duration(milliseconds: 200)).slideY(begin: 0.2);
  }

  Widget _buildMiniStat(String value, String label) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
      ],
    );
  }

  Widget _buildGridActions(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.1,
      children: [
        _buildGlassAction(context, 'Attendance', LucideIcons.mapPin, AppTheme.primary, '/attendance'),
        _buildGlassAction(context, 'Task Hub', LucideIcons.layoutGrid, AppTheme.secondary, '/tasks'),
        _buildGlassAction(context, 'Payroll', LucideIcons.banknote, AppTheme.accent, '/payroll'),
        _buildGlassAction(context, 'Admin', LucideIcons.shield, Colors.amber, '/admin'),
      ],
    );
  }

  Widget _buildGlassAction(BuildContext context, String title, IconData icon, Color color, String route) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, route),
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: color.withOpacity(0.2), shape: BoxShape.circle),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(height: 12),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ],
        ),
      ),
    ).animate().scale(delay: const Duration(milliseconds: 500));
  }

  Widget _buildRecentActivity(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Recent Logs', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            TextButton(onPressed: () {}, child: const Text('See All')),
          ],
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 3,
          itemBuilder: (context, index) => Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.surface.withOpacity(0.3),
              borderRadius: BorderRadius.circular(20),
            ),
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: Colors.blue.withOpacity(0.1), shape: BoxShape.circle),
                child: const Icon(LucideIcons.checkCircle, color: Colors.blue, size: 20),
              ),
              title: const Text('Geofence Verified', style: TextStyle(fontWeight: FontWeight.w600)),
              subtitle: const Text('Downtown Construction Site'),
              trailing: const Text('08:45 AM', style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
            ),
          ),
        ).animate().fadeIn(delay: const Duration(milliseconds: 800)),
      ],
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(24),
      height: 70,
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(35),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10))],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(icon: const Icon(LucideIcons.home, color: AppTheme.primary), onPressed: () {}),
          IconButton(icon: const Icon(LucideIcons.calendar, color: AppTheme.textSecondary), onPressed: () {}),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(color: AppTheme.primary, shape: BoxShape.circle),
            child: const Icon(LucideIcons.plus, color: Colors.white),
          ),
          IconButton(icon: const Icon(LucideIcons.user, color: AppTheme.textSecondary), onPressed: () {}),
          IconButton(icon: const Icon(LucideIcons.settings, color: AppTheme.textSecondary), onPressed: () {}),
        ],
      ),
    ).animate().slideY(begin: 1, delay: const Duration(seconds: 1));
  }
}
