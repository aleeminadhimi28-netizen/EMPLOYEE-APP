import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../core/theme.dart';

class FaceRegistrationScreen extends StatefulWidget {
  const FaceRegistrationScreen({super.key});

  @override
  State<FaceRegistrationScreen> createState() => _FaceRegistrationScreenState();
}

class _FaceRegistrationScreenState extends State<FaceRegistrationScreen> {
  CameraController? _controller;
  bool _isInitializing = true;
  bool _isCapturing = false;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    final cameras = await availableCameras();
    if (cameras.isEmpty) return;
    
    // Use front camera
    final front = cameras.firstWhere((c) => c.lensDirection == CameraLensDirection.front);
    
    _controller = CameraController(front, ResolutionPreset.medium);
    await _controller!.initialize();
    
    if (mounted) setState(() => _isInitializing = false);
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _captureFace() async {
    if (_controller == null || !_controller!.value.isInitialized) return;
    
    setState(() => _isCapturing = true);
    try {
      final image = await _controller!.takePicture();
      // Logic to upload 'image.path' to Supabase Storage
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Face Profile Registered Successfully!'), backgroundColor: Colors.green),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      setState(() => _isCapturing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Face Registration')),
      body: Column(
        children: [
          const SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              'Position your face within the circle to register your profile.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppTheme.textSecondary),
            ),
          ),
          const SizedBox(height: 40),
          Expanded(
            child: Center(
              child: Container(
                width: 280,
                height: 280,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppTheme.primary, width: 4),
                ),
                child: ClipOval(
                  child: _isInitializing 
                    ? const Center(child: CircularProgressIndicator())
                    : CameraPreview(_controller!),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(40.0),
            child: ElevatedButton(
              onPressed: _isInitializing || _isCapturing ? null : _captureFace,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 60),
              ),
              child: _isCapturing 
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text('Capture & Register', style: TextStyle(fontSize: 18)),
            ),
          ),
        ],
      ),
    );
  }
}
