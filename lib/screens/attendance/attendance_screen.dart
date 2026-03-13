import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:camera/camera.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/theme.dart';
import '../../services/attendance_service.dart';
import '../../services/auth_service.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  final _service = AttendanceService();
  CameraController? _cameraController;
  Map<String, dynamic>? _selectedSite;
  bool _isWithinRadius = false;
  bool _isLoading = true;
  bool _isVerifying = false;

  @override
  void initState() {
    super.initState();
    _checkStatus();
    _initCamera();
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  Future<void> _initCamera() async {
    final cameras = await availableCameras();
    if (cameras.isEmpty) return;
    final front = cameras.firstWhere((c) => c.lensDirection == CameraLensDirection.front);
    _cameraController = CameraController(front, ResolutionPreset.medium, enableAudio: false);
    await _cameraController!.initialize();
    if (mounted) setState(() {});
  }

  Future<void> _checkStatus() async {
    setState(() => _isLoading = true);
    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      final companyId = authService.currentCompany?['id'];
      
      if (companyId == null) throw 'Company information not found';

      final pos = await _service.getCurrentLocation();
      final sites = await _service.getAvailableSites(companyId);
      
      Map<String, dynamic>? nearestSite;
      bool found = false;

      for (var site in sites) {
        if (_service.isWithinSite(pos, site)) {
          nearestSite = site;
          found = true;
          break;
        }
      }

      setState(() {
        _selectedSite = nearestSite;
        _isWithinRadius = found;
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
          color: _isWithinRadius ? const Color(0xFF10B981).withOpacity(0.3) : Colors.redAccent.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            _isWithinRadius ? LucideIcons.mapPin : LucideIcons.mapPinOff,
            color: _isWithinRadius ? const Color(0xFF10B981) : Colors.redAccent,
          ).animate(onPlay: (controller) => controller.repeat())
           .shimmer(duration: const Duration(seconds: 2)),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _isWithinRadius ? 'Region Verified' : 'Checking GPS...',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                _isWithinRadius ? (_selectedSite?['name'] ?? 'Authorized Site') : 'Please enter authorized zone',
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
          Container(
            width: 260,
            height: 260,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppTheme.primary.withOpacity(0.1), width: 2),
            ),
          ).animate(onPlay: (controller) => controller.repeat())
           .scale(begin: const Offset(0.8, 0.8), end: const Offset(1.2, 1.2), duration: const Duration(seconds: 2))
           .fadeOut(),
          
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
            child: ClipOval(
              child: _cameraController != null && _cameraController!.value.isInitialized
                  ? CameraPreview(_cameraController!)
                  : const Icon(LucideIcons.user, size: 80, color: AppTheme.textSecondary),
            ),
          ).animate(onPlay: (controller) => controller.repeat())
           .rotate(duration: const Duration(seconds: 10)),

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
             .moveY(begin: 0, end: 100, duration: const Duration(milliseconds: 1500), curve: Curves.easeInOut)
             .then()
             .moveY(begin: 100, end: 0, duration: const Duration(milliseconds: 1500), curve: Curves.easeInOut),
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
        ).animate().fadeIn(delay: const Duration(milliseconds: 300)),
        const SizedBox(height: 8),
        const Text(
          'Ensure your face is clearly visible\nin the center of the frame.',
          textAlign: TextAlign.center,
          style: TextStyle(color: AppTheme.textSecondary),
        ).animate().fadeIn(delay: const Duration(milliseconds: 500)),
      ],
    );
  }

  Widget _buildActionButton() {
    return ElevatedButton(
      onPressed: (_isWithinRadius && !_isVerifying && _cameraController != null && _cameraController!.value.isInitialized)
          ? _performVerification
          : null,
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 64),
        backgroundColor: AppTheme.primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 10,
        shadowColor: AppTheme.primary.withOpacity(0.4),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _isVerifying 
            ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
            : const Icon(LucideIcons.shieldCheck),
          const SizedBox(width: 12),
          Text(_isVerifying ? 'Verifying Identity...' : 'Initiate Biometric Match', 
               style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      ),
    ).animate().fadeIn(delay: const Duration(milliseconds: 800)).slideY(begin: 0.2);
  }

  Future<void> _performVerification() async {
    setState(() => _isVerifying = true);
    try {
      final image = await _cameraController!.takePicture();
      final bytes = await image.readAsBytes();
      final userId = Supabase.instance.client.auth.currentUser?.id;

      if (userId == null) throw 'User not logged in';

      final success = await Provider.of<AuthService>(context, listen: false).verifyFace(userId, bytes);

      if (mounted) {
        if (success) {
          await _service.clockIn(userId, _selectedSite!['id']);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Attendance Marked Successfully!'), backgroundColor: Colors.green),
          );
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Face Verification Failed. Try again.'), backgroundColor: Colors.red),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Verification Error: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isVerifying = false);
    }
  }
}
