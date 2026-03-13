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
import 'screens/admin/setup_company_screen.dart';
import 'screens/admin/super_admin_portal.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  String? initError;

  try {
    // Load environment variables
    await dotenv.load(fileName: ".env");

    final url = dotenv.env['SUPABASE_URL'];
    final anonKey = dotenv.env['SUPABASE_ANON_KEY'];

    if (url != null && url.isNotEmpty && url != 'YOUR_SUPABASE_URL' &&
        anonKey != null && anonKey.isNotEmpty && anonKey != 'YOUR_SUPABASE_ANON_KEY') {
      await Supabase.initialize(
        url: url,
        anonKey: anonKey,
      );
    } else {
      initError = "Supabase configuration missing or placeholder values used in .env";
    }
  } catch (e) {
    debugPrint("Initialization error: $e");
    initError = e.toString();
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
      ],
      child: ProjectXYZ(initError: initError),
    ),
  );
}

class ProjectXYZ extends StatelessWidget {
  final String? initError;
  const ProjectXYZ({super.key, this.initError});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Project XYZ',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const AuthWrapper(),
      routes: {
        '/splash': (context) => SplashScreen(initError: initError),
        '/onboarding': (context) => const OnboardingScreen(),
        '/login': (context) => const LoginScreen(),
        '/dashboard': (context) => const DashboardScreen(),
        '/attendance': (context) => const AttendanceScreen(),
        '/tasks': (context) => const TasksScreen(),
        '/admin': (context) => const AdminPortal(),
        '/register-face': (context) => const FaceRegistrationScreen(),
        '/payroll': (context) => const PayrollScreen(),
        '/analytics': (context) => const AnalyticsDashboard(),
        '/setup-company': (context) => const SetupCompanyScreen(),
        '/super-admin': (context) => const SuperAdminPortal(),
      },
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final session = Supabase.instance.client.auth.currentSession;
    
    if (session == null) {
      return const LoginScreen();
    }

    // Role-based Routing
    final userRole = authService.currentUserProfile?['role'];

    if (userRole == 'super_admin') {
      return const SuperAdminPortal();
    }

    if (authService.currentCompany == null) {
      return const SetupCompanyScreen();
    }

    return const DashboardScreen();
  }
}
