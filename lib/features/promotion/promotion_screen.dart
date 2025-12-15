import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/promotion_provider.dart';

class PromotionScreen extends StatefulWidget {
  const PromotionScreen({super.key});

  @override
  State<PromotionScreen> createState() => _PromotionScreenState();
}

class _PromotionScreenState extends State<PromotionScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<PromotionProvider>().fetchPromotions();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PromotionProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Promotions"),
        backgroundColor: Colors.teal,
        elevation: 1,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0F9D9A), Color(0xFF56C596)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: _buildBody(provider),
      ),
    );
  }

  // --------------------------
  // BODY HANDLER
  // --------------------------
  Widget _buildBody(PromotionProvider provider) {
    if (provider.isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.white),
      );
    }

    if (provider.error != null) {
      return _buildError(provider.error!);
    }

    if (provider.promotions.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: provider.promotions.length,
      itemBuilder: (context, index) {
        final p = provider.promotions[index];
        return _PromotionCard(promo: p);
      },
    );
  }

  // --------------------------
  // EMPTY STATE
  // --------------------------
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.local_offer_outlined,
              size: 80, color: Colors.white70),
          SizedBox(height: 16),
          Text(
            "No Active Promotions",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8),
          Text(
            "Visit a GrabIt machine to unlock offers",
            style: TextStyle(color: Colors.white70),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // --------------------------
  // ERROR STATE
  // --------------------------
  Widget _buildError(String message) {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline,
                  size: 60, color: Colors.red),
              const SizedBox(height: 16),
              const Text(
                "Unable to load promotions",
                style: TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.black54),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  context.read<PromotionProvider>().fetchPromotions();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                ),
                child: const Text("Retry"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ======================================================
// PROMOTION CARD
// ======================================================
class _PromotionCard extends StatelessWidget {
  final dynamic promo;

  const _PromotionCard({required this.promo});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 14),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // DISCOUNT BADGE
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: Colors.teal.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  "${promo.discountValue}%",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                ),
              ),
            ),

            const SizedBox(width: 16),

            // DETAILS
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    promo.product.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    promo.discountType,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.schedule,
                          size: 14, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        "Expires ${promo.expiresAt.toLocal().toString().split(' ').first}",
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../providers/promotion_provider.dart';
// import '../../providers/auth_provider.dart';
//
// class PromotionScreen extends StatefulWidget {
//   const PromotionScreen({super.key});
//
//   @override
//   State<PromotionScreen> createState() => _PromotionScreenState();
// }
//
// class _PromotionScreenState extends State<PromotionScreen> {
//   @override
//   void initState() {
//     super.initState();
//     Future.microtask(() {
//       context.read<PromotionProvider>().fetchPromotions();
//     });
//   }
//
//   // @override
//   // void didChangeDependencies() {
//   //   super.didChangeDependencies();
//   //
//   //   final provider = context.read<PromotionProvider>();
//   //   final auth = context.read<AuthProvider>();
//   //
//   //   if (auth.isLoggedIn && provider.promotions.isEmpty && !provider.isLoading) {
//   //     provider.fetchPromotions();
//   //   }
//   // }
//
//   @override
//   Widget build(BuildContext context) {
//     final provider = context.watch<PromotionProvider>();
//
//     if (provider.isLoading) {
//       return const Center(child: CircularProgressIndicator());
//     }
//
//     if (provider.error != null) {
//       return Center(child: Text(provider.error!));
//     }
//
//     if (provider.promotions.isEmpty) {
//       return const Center(child: Text("No active promotions"));
//     }
//
//     return ListView.builder(
//       padding: const EdgeInsets.all(16),
//       itemCount: provider.promotions.length,
//       itemBuilder: (context, index) {
//         final p = provider.promotions[index];
//
//         return Card(
//           margin: const EdgeInsets.only(bottom: 12),
//           child: ListTile(
//             title: Text(p.product.name),
//             subtitle: Text(
//               "${p.discountType} • ${p.discountValue}% OFF",
//             ),
//             trailing: Text(
//               "Expires\n${p.expiresAt.toLocal().toString().split(' ').first}",
//               textAlign: TextAlign.right,
//               style: const TextStyle(fontSize: 12),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
