import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/promotion_provider.dart';
import '../../providers/auth_provider.dart';

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

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //
  //   final provider = context.read<PromotionProvider>();
  //   final auth = context.read<AuthProvider>();
  //
  //   if (auth.isLoggedIn && provider.promotions.isEmpty && !provider.isLoading) {
  //     provider.fetchPromotions();
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PromotionProvider>();

    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.error != null) {
      return Center(child: Text(provider.error!));
    }

    if (provider.promotions.isEmpty) {
      return const Center(child: Text("No active promotions"));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: provider.promotions.length,
      itemBuilder: (context, index) {
        final p = provider.promotions[index];

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            title: Text(p.product.name),
            subtitle: Text(
              "${p.discountType} • ${p.discountValue}% OFF",
            ),
            trailing: Text(
              "Expires\n${p.expiresAt.toLocal().toString().split(' ').first}",
              textAlign: TextAlign.right,
              style: const TextStyle(fontSize: 12),
            ),
          ),
        );
      },
    );
  }
}
