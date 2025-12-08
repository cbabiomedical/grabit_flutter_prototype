import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../services/mock_api_service.dart';
import '../services/device_service.dart';
import '../features/splash/splash_screen.dart';
import 'app_routes.dart';
import 'app_theme.dart';

class GrabItApp extends StatelessWidget {
  const GrabItApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(
            MockApiService(),
            DeviceService(),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'GrabIt',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        initialRoute: AppRoutes.splash,
        routes: {
          AppRoutes.splash: (_) => const SplashScreen(),
        },
      ),
    );
  }
}
