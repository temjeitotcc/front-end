import 'package:flutter/material.dart';

// Widget reutilizável do círculo das fases
class CirculoFase extends StatelessWidget {
  final String numero;
  final bool liberado;
  final VoidCallback onTap;

  const CirculoFase({
    super.key,
    required this.numero,
    required this.liberado,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: liberado ? onTap : null,
      child: Container(
        width: 76,
        height: 76,
        padding: const EdgeInsets.all(7),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: liberado
              ? const Color(0xFFFFE58A)
              : const Color(0xFFE2E8F0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(36),
              blurRadius: 0,
              offset: const Offset(0, 7),
            ),
          ],
        ),
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: liberado
                ? const Color(0xFFFED23E)
                : const Color(0xFF94A3B8),
          ),
          alignment: Alignment.center,
          child: liberado
              ? Text(
                  numero,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                  ),
                )
              : const Icon(
                  Icons.lock_rounded,
                  color: Colors.white70,
                  size: 28,
                ),
        ),
      ),
    );
  }
}
