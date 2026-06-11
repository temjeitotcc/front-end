import 'package:flutter/material.dart';

// Widget reutilizável do círculo das fases
class CirculoFase extends StatelessWidget {
  final String numero;
  final bool liberado;
  final bool concluido;
  final bool especial;
  final VoidCallback onTap;

  const CirculoFase({
    super.key,
    required this.numero,
    required this.liberado,
    required this.concluido,
    required this.onTap,
    this.especial = false,
  });

  @override
  Widget build(BuildContext context) {
    final corTema = Theme.of(context).colorScheme.primary;
    final corTemaSuave = Theme.of(context).colorScheme.secondary;
    final corExterna = concluido
        ? Color.lerp(corTemaSuave, Colors.black, 0.58)!
        : liberado
            ? especial
                ? corTema
                : corTemaSuave
            : const Color(0xFFE2E8F0);
    final corInterna = concluido
        ? Color.lerp(corTema, const Color(0xFF171315), 0.72)!
        : liberado
            ? especial
                ? const Color(0xFF2A2527)
                : corTema
            : const Color(0xFF94A3B8);

    return GestureDetector(
      onTap: liberado || concluido ? onTap : null,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 76,
            height: 76,
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: corExterna,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(concluido ? 65 : 36),
                  blurRadius: concluido ? 8 : 0,
                  offset: const Offset(0, 7),
                ),
              ],
            ),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: corInterna,
                border: concluido
                    ? Border.all(color: Colors.white.withAlpha(75), width: 2)
                    : especial && liberado
                        ? Border.all(color: corTema, width: 3)
                        : null,
              ),
              alignment: Alignment.center,
              child: liberado || concluido
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (especial)
                          Icon(
                            concluido
                                ? Icons.auto_awesome_rounded
                                : Icons.auto_awesome_rounded,
                            color: Colors.white.withAlpha(
                              concluido ? 145 : 255,
                            ),
                            size: 18,
                          ),
                        Text(
                          numero,
                          style: TextStyle(
                            color: Colors.white.withAlpha(
                              concluido ? 175 : 255,
                            ),
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
          if (concluido)
            Positioned(
              right: -2,
              top: -3,
              child: Container(
                width: 25,
                height: 25,
                decoration: BoxDecoration(
                  color: const Color(0xFF2A2527),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withAlpha(120),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(70),
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.done_rounded,
                  color: Colors.white.withAlpha(210),
                  size: 16,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
