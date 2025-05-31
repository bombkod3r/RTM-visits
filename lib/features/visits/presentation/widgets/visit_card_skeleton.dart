import 'package:flutter/material.dart';
import 'package:rtm_visits/core/theme/app_theme.dart';

class VisitCardSkeleton extends StatelessWidget {
  const VisitCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 200,
              height: 20,
              color: AppColors.primary[200],
            ),
            const SizedBox(height: 8),
            Container(
              width: 150,
              height: 16,
              color: AppColors.primary[200],
            ),
          ],
        ),
      ),
    );
  }
}