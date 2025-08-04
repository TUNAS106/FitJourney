import 'package:flutter/material.dart';

/// Khung thẻ dùng chung cho mọi màn chi tiết Encyclopedia
class EncyclopediaContentCard extends StatelessWidget {
  final Widget child;
  const EncyclopediaContentCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.black.withOpacity(0.04)),
        boxShadow: [
          BoxShadow(
            blurRadius: 18,
            offset: const Offset(0, 8),
            color: Colors.black.withOpacity(0.06),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 14),
        child: child,
      ),
    );
  }
}
