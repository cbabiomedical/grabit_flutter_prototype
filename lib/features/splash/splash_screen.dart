import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../app/app_routes.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // --------------------------
    // DO NOT TOUCH LOGIC
    // --------------------------
    Future.microtask(() async {
      final auth = context.read<AuthProvider>();
      await auth.init();

      if (auth.isLoggedIn) {
        Navigator.pushReplacementNamed(context, AppRoutes.home);
      } else {
        Navigator.pushReplacementNamed(context, AppRoutes.login);
      }
    });

    // --------------------------
    // UI ONLY
    // --------------------------
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF0F9D9A), // Dark teal
              Color(0xFF56C596), // Light teal
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // --------------------------
              // APP ICON / LOGO
              // --------------------------
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.local_convenience_store,
                  size: 64,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 24),

              // --------------------------
              // APP NAME
              // --------------------------
              const Text(
                "GrabIt",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.2,
                ),
              ),

              const SizedBox(height: 8),

              // --------------------------
              // TAGLINE
              // --------------------------
              const Text(
                "Smart vending, made simple",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),

              const SizedBox(height: 48),

              // --------------------------
              // LOADING INDICATOR
              // --------------------------
              const SizedBox(
                width: 36,
                height: 36,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),

              const SizedBox(height: 16),

              const Text(
                "Initializing...",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../providers/auth_provider.dart';
// import '../../app/app_routes.dart';
//
// class SplashScreen extends StatelessWidget {
//   const SplashScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     Future.microtask(() async {
//       final auth = context.read<AuthProvider>();
//       await auth.init();
//
//       if (auth.isLoggedIn) {
//         Navigator.pushReplacementNamed(context, AppRoutes.home);
//       } else {
//         Navigator.pushReplacementNamed(context, AppRoutes.login);
//       }
//     });
//
//     return const Scaffold(
//       body: Center(child: CircularProgressIndicator()),
//     );
//   }
// }
