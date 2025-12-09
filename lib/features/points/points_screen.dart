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
    context.read<PointsProvider>().loadPoints();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PointsProvider>();

    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final points = provider.points?.totalPoints ?? 0;

    return Center(
      child: Card(
        margin: const EdgeInsets.all(24),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Your Loyalty Points',
                  style: TextStyle(fontSize: 18)),
              const SizedBox(height: 12),
              Text(
                points.toString(),
                style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.green),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
