import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingData> _slides = [
    OnboardingData(
      title: 'Precision Locating',
      description: 'Advanced geofencing ensures attendance is only marked at authorized work sites.',
      icon: LucideIcons.mapPin,
      color: AppTheme.primary,
    ),
    OnboardingData(
      title: 'Face Verified',
      description: 'Liveness-detection AI confirms identity with zero-friction biometrics.',
      icon: LucideIcons.scanFace,
      color: AppTheme.luxuryGold,
    ),
    OnboardingData(
      title: 'Insightful Analytics',
      description: 'Real-time performance metrics and payroll transparency at your fingertips.',
      icon: LucideIcons.barChart3,
      color: AppTheme.secondary,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: (idx) => setState(() => _currentPage = idx),
            itemCount: _slides.length,
            itemBuilder: (context, index) => _buildSlide(_slides[index]),
          ),
          
          Positioned(
            bottom: 64,
            left: 24,
            right: 24,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: List.generate(
                    _slides.length,
                    (index) => Container(
                      margin: const EdgeInsets.only(right: 8),
                      height: 8,
                      width: _currentPage == index ? 24 : 8,
                      decoration: BoxDecoration(
                        color: _currentPage == index ? AppTheme.primary : AppTheme.textSecondary.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_currentPage < _slides.length - 1) {
                      _pageController.nextPage(duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
                    } else {
                      Navigator.pushReplacementNamed(context, '/login');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(20),
                  ),
                  child: Icon(
                    _currentPage == _slides.length - 1 ? LucideIcons.check : LucideIcons.arrowRight,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSlide(OnboardingData slide) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(40),
            decoration: BoxDecoration(
              color: slide.color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(slide.icon, size: 100, color: slide.color),
          ).animate().scale(duration: const Duration(milliseconds: 600)).fadeIn(),
          const SizedBox(height: 64),
          Text(
            slide.title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
          ).animate().fadeIn(delay: const Duration(milliseconds: 300)).slideY(begin: 0.2),
          const SizedBox(height: 16),
          Text(
            slide.description,
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppTheme.textSecondary, fontSize: 18),
          ).animate().fadeIn(delay: const Duration(milliseconds: 500)).slideY(begin: 0.2),
        ],
      ),
    );
  }
}

class OnboardingData {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  OnboardingData({required this.title, required this.description, required this.icon, required this.color});
}
