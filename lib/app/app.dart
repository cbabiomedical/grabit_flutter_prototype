import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Providers
import '../providers/auth_provider.dart';
import '../providers/promotion_provider.dart';
import '../providers/points_provider.dart';
import '../providers/session_provider.dart';
import '../providers/beacon_provider.dart';
import '../providers/settings_provider.dart';

// Services
import '../services/mock_api_service.dart';
import '../services/real_api_service.dart';
import '../services/device_service.dart';
import '../services/beacon_service.dart';
import '../services/local_notification_service.dart';

// Screens
import '../features/splash/splash_screen.dart';
import '../features/auth/login_screen.dart';
import '../features/auth/register_screen.dart';
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
            RealApiService(),
            deviceService,
          )..init(),
        ),

        // ✅ POINTS PROVIDER
        // ChangeNotifierProvider(
        //   create: (_) => PointsProvider(mockApi),
        // ),

        ChangeNotifierProvider(
          create: (_) => SettingsProvider(),
        ),

        // ChangeNotifierProvider(
        //   create: (_) => BeaconProvider(BeaconService()),
        // ),

        // ---------------------------
        // BEACON PROVIDER (depends on Auth)
        // ---------------------------
        ChangeNotifierProxyProvider<AuthProvider, BeaconProvider>(
          create: (_) => BeaconProvider(
            beaconService: BeaconService(),
            api: RealApiService(),
            auth: null, // ← injected in update()
          ),
          update: (_, auth, beaconProvider) {
            beaconProvider!.auth = auth; // inject dependency
            return beaconProvider;
          },
        ),

        ChangeNotifierProxyProvider<AuthProvider, PromotionProvider>(
          create: (_) => PromotionProvider(api: RealApiService()),
          update: (_, auth, promoProvider) {
            promoProvider!.auth = auth;
            return promoProvider;
          },
        ),

        ChangeNotifierProxyProvider<AuthProvider, SessionProvider>(
          create: (_) => SessionProvider(api: RealApiService()),
          update: (_, auth, sessionProvider) {
            sessionProvider!.auth = auth;
            return sessionProvider;
          },
        ),

        ChangeNotifierProxyProvider<AuthProvider, PointsProvider>(
          create: (_) => PointsProvider(api: RealApiService()),
          update: (_, auth, provider) {
            provider!.auth = auth;
            return provider;
          },
        ),


      ],
      child: MaterialApp(
        navigatorKey: navigatorKey, //REQUIRED FOR NOTIFICATION TAP
        title: 'GrabIt',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        initialRoute: AppRoutes.splash,
        routes: {
          AppRoutes.splash: (_) => const SplashScreen(),
          AppRoutes.login: (_) => const LoginScreen(),
          AppRoutes.register: (_) => const RegisterScreen(),
          AppRoutes.home: (_) => const HomeScreen(),
          AppRoutes.promotions: (_) => const PromotionScreen(),
          AppRoutes.points: (_) => const PointsScreen(),
          AppRoutes.settings: (_) => const SettingsScreen(),
        },
      ),
    );
  }
}
