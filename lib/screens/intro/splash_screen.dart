import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme.dart';

class SplashScreen extends StatefulWidget {
  final String? initError;
  const SplashScreen({super.key, this.initError});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNext();
  }

  _navigateToNext() async {
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;
    
    if (widget.initError != null) {
      // Stay on splash to show error
      return;
    }
    
    Navigator.pushReplacementNamed(context, '/onboarding');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image
          Image.asset(
            'assets/images/splash_bg.png',
            fit: BoxFit.cover,
          ).animate().fadeIn(duration: 800.ms),
          
          // Overlay for readability
          Container(
            color: Colors.black.withOpacity(0.4),
          ),
          
          // Logo and Branding
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Image.asset('assets/images/logo.png'),
                  ),
                ).animate()
                  .scale(begin: const Offset(0.8, 0.8), duration: 1000.ms, curve: Curves.easeOutBack)
                  .fadeIn(duration: 1000.ms),
                  
                const SizedBox(height: 48),
                
                Text(
                  'PROJECT XYZ',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -2,
                  ),
                ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.5),
                
                const SizedBox(height: 8),
                
                Text(
                  'WORKFORCE MANAGEMENT',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    letterSpacing: 2,
                    fontSize: 12,
                    fontWeight: FontWeight.w300,
                  ),
                ).animate().fadeIn(delay: 800.ms),
              ],
            ),
          ),
          
          // Loading Indicator at bottom
          Positioned(
            bottom: 60,
            left: 24,
            right: 24,
            child: Column(
              children: [
                if (widget.initError != null) ...[
                  Text(
                    'Setup Error',
                    style: TextStyle(color: Colors.red.shade400, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.initError!,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 12),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () => Navigator.pushReplacementNamed(context, '/onboarding'),
                    child: const Text('Continue anyway (Offline Mode)', style: TextStyle(color: AppTheme.primary)),
                  ),
                ] else
                  SizedBox(
                    width: 40,
                    height: 2,
                    child: LinearProgressIndicator(
                      backgroundColor: Colors.white.withOpacity(0.1),
                      color: AppTheme.primary,
                    ),
                  ),
              ],
            ),
          ).animate().fadeIn(delay: 1.seconds),
        ],
      ),
    );
  }
}
