import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/promotion_provider.dart';
import 'package:intl/intl.dart';

class PromotionScreen extends StatefulWidget {
  const PromotionScreen({super.key});

  @override
  State<PromotionScreen> createState() => _PromotionScreenState();
}

class _PromotionScreenState extends State<PromotionScreen> {
  @override
  void initState() {
    super.initState();
    context.read<PromotionProvider>().loadPromotions();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PromotionProvider>();

    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.promotions.isEmpty) {
      return const Center(child: Text('No active promotions.'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: provider.promotions.length,
      itemBuilder: (_, i) {
        final promo = provider.promotions[i];
        final expiry = DateFormat('hh:mm a').format(promo.expiresAt);

        return Card(
          elevation: 3,
          margin: const EdgeInsets.only(bottom: 16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(promo.productName,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                Text('Machine: ${promo.machineName}'),
                const SizedBox(height: 8),
                Text('Original: Rs ${promo.basePrice}'),
                Text('Discount: Rs ${promo.discountValue}'),
                Text(
                  'Now: Rs ${promo.discountedPrice}',
                  style: const TextStyle(
                      color: Colors.green, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                Text('Expires at $expiry'),
              ],
            ),
          ),
        );
      },
    );
  }
}
