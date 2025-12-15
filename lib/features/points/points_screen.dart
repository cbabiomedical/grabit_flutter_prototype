import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/points_provider.dart';

class PointsScreen extends StatefulWidget {
  const PointsScreen({super.key});

  @override
  State<PointsScreen> createState() => _PointsScreenState();
}

class _PointsScreenState extends State<PointsScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<PointsProvider>().loadPoints();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PointsProvider>();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Points"),
        backgroundColor: Colors.teal,
        elevation: 1,
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0F9D9A), Color(0xFF56C596)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: provider.isLoading
            ? const Center(
          child: CircularProgressIndicator(color: Colors.white),
        )
            : _buildContent(provider, theme),
      ),
    );
  }

  // --------------------------
  // MAIN CONTENT
  // --------------------------
  Widget _buildContent(PointsProvider provider, ThemeData theme) {
    final points = provider.points?.loyaltyPoints ?? 0;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // HEADER
          const SizedBox(height: 16),
          const Text(
            "Your Loyalty Points",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Earn points every time you purchase from GrabIt",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white70),
          ),

          const SizedBox(height: 32),

          // POINTS CARD
          _PointsBalanceCard(points: points),

          const SizedBox(height: 24),

          // INFO CARDS
          Row(
            children: const [
              Expanded(
                child: _InfoCard(
                  icon: Icons.local_offer_outlined,
                  title: "Redeem",
                  subtitle: "Use points for discounts",
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: _InfoCard(
                  icon: Icons.qr_code_scanner,
                  title: "Scan",
                  subtitle: "Scan QR to earn more",
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // FOOTER MESSAGE
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: const [
                  Icon(Icons.info_outline, color: Colors.teal),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      "Points will be automatically added after each successful session.",
                      style: TextStyle(fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ======================================================
// POINTS BALANCE CARD
// ======================================================
class _PointsBalanceCard extends StatelessWidget {
  final int points;

  const _PointsBalanceCard({required this.points});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [Colors.teal.shade400, Colors.teal.shade600],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            const Icon(
              Icons.stars_rounded,
              color: Colors.white,
              size: 48,
            ),
            const SizedBox(height: 12),
            const Text(
              "TOTAL POINTS",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              points.toString(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 42,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ======================================================
// SMALL INFO CARD
// ======================================================
class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _InfoCard({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: Colors.teal, size: 32),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../providers/points_provider.dart';
//
// class PointsScreen extends StatefulWidget {
//   const PointsScreen({super.key});
//
//   @override
//   State<PointsScreen> createState() => _PointsScreenState();
// }
//
// class _PointsScreenState extends State<PointsScreen> {
//   @override
//   void initState() {
//     super.initState();
//     context.read<PointsProvider>().loadPoints();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final provider = context.watch<PointsProvider>();
//
//     if (provider.isLoading) {
//       return const Center(child: CircularProgressIndicator());
//     }
//
//     final points = provider.points?.totalPoints ?? 0;
//
//     return Center(
//       child: Card(
//         margin: const EdgeInsets.all(24),
//         elevation: 4,
//         child: Padding(
//           padding: const EdgeInsets.all(24),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               const Text('Your Loyalty Points',
//                   style: TextStyle(fontSize: 18)),
//               const SizedBox(height: 12),
//               Text(
//                 points.toString(),
//                 style: const TextStyle(
//                     fontSize: 36,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.green),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
