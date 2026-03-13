import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'core/theme.dart';
import 'screens/intro/splash_screen.dart';
import 'screens/intro/onboarding_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/home/dashboard_screen.dart';
import 'screens/attendance/attendance_screen.dart';
import 'screens/tasks/tasks_screen.dart';
import 'screens/admin/admin_portal.dart';
import 'screens/auth/face_registration_screen.dart';
import 'screens/payroll/payroll_screen.dart';
import 'screens/admin/analytics_dashboard.dart';
import 'services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await dotenv.load(fileName: ".env");

  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL'] ?? '',
    anonKey: dotenv.env['SUPABASE_ANON_KEY'] ?? '',
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
      ],
      child: const ProjectXYZ(),
    ),
  );
}

class ProjectXYZ extends StatelessWidget {
  const ProjectXYZ({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Project XYZ',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/onboarding': (context) => const OnboardingScreen(),
        '/login': (context) => const LoginScreen(),
        '/dashboard': (context) => const DashboardScreen(),
        '/attendance': (context) => const AttendanceScreen(),
        '/tasks': (context) => const TasksScreen(),
        '/admin': (context) => const AdminPortal(),
        '/register-face': (context) => const FaceRegistrationScreen(),
        '/payroll': (context) => const PayrollScreen(),
        '/analytics': (context) => const AnalyticsDashboard(),
      },
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final session = Supabase.instance.client.auth.currentSession;
    
    if (session != null) {
      return const DashboardScreen();
    } else {
      return const LoginScreen();
    }
  }
}
