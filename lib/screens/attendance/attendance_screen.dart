import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme.dart';
import '../../services/attendance_service.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  final _service = AttendanceService();
  bool _isWithinRadius = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkStatus();
  }

  Future<void> _checkStatus() async {
    setState(() => _isLoading = true);
    await Future.delayed(1500.ms); // Add a premium delay feel
    try {
      final pos = await _service.getCurrentLocation();
      final within = _service.isWithinRadius(pos);
      setState(() {
        _isWithinRadius = within;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Biometric Entry', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
      ),
      body: Stack(
        children: [
          // Background Glow
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                color: AppTheme.primary.withOpacity(0.05),
                shape: BoxShape.circle,
              ),
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                _buildGeofenceIndicator(),
                const Spacer(),
                _buildScannerUI(),
                const Spacer(),
                _buildInstructions(),
                const SizedBox(height: 32),
                _buildActionButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGeofenceIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: _isWithinRadius ? Colors.emerald.withOpacity(0.3) : Colors.redAccent.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            _isWithinRadius ? LucideIcons.mapPin : LucideIcons.mapPinOff,
            color: _isWithinRadius ? Colors.emerald : Colors.redAccent,
          ).animate(onPlay: (controller) => controller.repeat())
           .shimmer(duration: 2.seconds),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _isWithinRadius ? 'Region Verified' : 'Checking GPS...',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                _isWithinRadius ? 'Downtown Business Hub' : 'Please wait for lock',
                style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
              ),
            ],
          ),
          const Spacer(),
          if (_isLoading) 
            const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)),
        ],
      ),
    ).animate().fadeIn().slideY(begin: -0.2);
  }

  Widget _buildScannerUI() {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer Pulse
          Container(
            width: 260,
            height: 260,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppTheme.primary.withOpacity(0.1), width: 2),
            ),
          ).animate(onPlay: (controller) => controller.repeat())
           .scale(begin: 0.8, end: 1.2, duration: 2.seconds)
           .fadeOut(),
          
          // Outer Ring
          Container(
            width: 220,
            height: 220,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppTheme.primary.withOpacity(0.3), width: 2),
            ),
          ).animate(onPlay: (controller) => controller.repeat())
           .rotate(duration: 10.seconds),

          // Core Scanner
          Container(
            width: 180,
            height: 180,
            decoration: BoxDecoration(
              color: AppTheme.surface,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primary.withOpacity(0.2),
                  blurRadius: 40,
                  spreadRadius: 10,
                )
              ],
            ),
            child: const Icon(LucideIcons.user, size: 80, color: AppTheme.textSecondary),
          ),

          // Scan Line
          Positioned(
            top: 40,
            child: Container(
              width: 140,
              height: 2,
              decoration: BoxDecoration(
                color: AppTheme.primary,
                boxShadow: [
                  BoxShadow(color: AppTheme.primary.withOpacity(0.5), blurRadius: 10, spreadRadius: 2)
                ],
              ),
            ).animate(onPlay: (controller) => controller.repeat())
             .moveY(begin: 0, end: 100, duration: 1.5.seconds, curve: Curves.easeInOut)
             .then()
             .moveY(begin: 100, end: 0, duration: 1.5.seconds, curve: Curves.easeInOut),
          ),
        ],
      ),
    );
  }

  Widget _buildInstructions() {
    return Column(
      children: [
        Text(
          'Identity Scan Required',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ).animate().fadeIn(delay: 300.ms),
        const SizedBox(height: 8),
        const Text(
          'Ensure your face is clearly visible\nin the center of the frame.',
          textAlign: TextAlign.center,
          style: TextStyle(color: AppTheme.textSecondary),
        ).animate().fadeIn(delay: 500.ms),
      ],
    );
  }

  Widget _buildActionButton() {
    return ElevatedButton(
      onPressed: _isWithinRadius ? () {} : null,
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 64),
        backgroundColor: AppTheme.primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 10,
        shadowColor: AppTheme.primary.withOpacity(0.4),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(LucideIcons.shieldCheck),
          SizedBox(width: 12),
          Text('Initiate Biometric Match', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      ),
    ).animate().fadeIn(delay: 800.ms).slideY(begin: 0.2);
  }
}
