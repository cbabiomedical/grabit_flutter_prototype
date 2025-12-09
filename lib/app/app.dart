import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Providers
import '../providers/auth_provider.dart';
import '../providers/promotion_provider.dart';
import '../providers/points_provider.dart';

// Services
import '../services/mock_api_service.dart';
import '../services/device_service.dart';

// Screens
import '../features/splash/splash_screen.dart';
import '../features/auth/login_screen.dart';
import '../features/auth/register_screen.dart';
import '../features/auth/verify_code_screen.dart';
import '../features/home/home_screen.dart';
import '../features/promotion/promotion_screen.dart';
import '../features/points/points_screen.dart';
import '../features/settings/settings_screen.dart';

// App Setup
import 'app_routes.dart';
import 'app_theme.dart';

class GrabItApp extends StatelessWidget {
  const GrabItApp({super.key});

  @override
  Widget build(BuildContext context) {
    final mockApi = MockApiService();
    final deviceService = DeviceService();

    return MultiProvider(
      providers: [
        // ✅ AUTH PROVIDER
        ChangeNotifierProvider(
          create: (_) => AuthProvider(
            mockApi,
            deviceService,
          ),
        ),

        // ✅ PROMOTION PROVIDER
        ChangeNotifierProvider(
          create: (_) => PromotionProvider(mockApi),
        ),

        // ✅ POINTS PROVIDER
        ChangeNotifierProvider(
          create: (_) => PointsProvider(mockApi),
        ),
      ],
      child: MaterialApp(
        title: 'GrabIt',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        initialRoute: AppRoutes.splash,
        routes: {
          AppRoutes.splash: (_) => const SplashScreen(),
          AppRoutes.login: (_) => const LoginScreen(),
          AppRoutes.register: (_) => const RegisterScreen(),
          AppRoutes.verify: (_) => const VerifyCodeScreen(),
          AppRoutes.home: (_) => const HomeScreen(),
          AppRoutes.promotions: (_) => const PromotionScreen(),
          AppRoutes.points: (_) => const PointsScreen(),
          AppRoutes.settings: (_) => const SettingsScreen(),
        },
      ),
    );
  }
}
