import 'package:flutter/material.dart';

class ChallengeHeaderSurface extends StatelessWidget {
  final Widget child;

  const ChallengeHeaderSurface({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final escuro = Theme.of(context).brightness == Brightness.dark;
    final corTema = Theme.of(context).colorScheme.primary;

    return Container(
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: escuro ? const Color(0xFF2A2527) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: corTema.withAlpha(105)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(32),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(height: 5, color: corTema),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 14, 15),
            child: child,
          ),
        ],
      ),
    );
  }
}
