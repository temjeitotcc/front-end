import 'package:flutter/material.dart';

// Widget reutilizável do círculo das fases
class CirculoFase extends StatelessWidget {
  final String numero;
  final bool liberado;
  final bool especial;
  final VoidCallback onTap;

  const CirculoFase({
    super.key,
    required this.numero,
    required this.liberado,
    required this.onTap,
    this.especial = false,
  });

  @override
  Widget build(BuildContext context) {
    final corTema = Theme.of(context).colorScheme.primary;
    final corTemaSuave = Theme.of(context).colorScheme.secondary;

    return GestureDetector(
      onTap: liberado ? onTap : null,
      child: Container(
        width: 76,
        height: 76,
        padding: const EdgeInsets.all(7),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: liberado
              ? especial
                  ? corTema
                  : corTemaSuave
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
                ? especial
                    ? const Color(0xFF2A2527)
                    : corTema
                : const Color(0xFF94A3B8),
            border: especial && liberado
                ? Border.all(color: corTema, width: 3)
                : null,
          ),
          alignment: Alignment.center,
          child: liberado
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (especial)
                      const Icon(
                        Icons.auto_awesome_rounded,
                        color: Colors.white,
                        size: 18,
                      ),
                    Text(
                      numero,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: especial ? 18 : 21,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
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
