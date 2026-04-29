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
      child: Opacity(
        opacity: liberado ? 1.0 : 0.4,
        child: Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: liberado
                ? const Color(0xFFFED23E)
                : const Color.fromARGB(255, 231, 192, 61),
          ),
          alignment: Alignment.center,
          child: Text(
            numero,
            style: TextStyle(
              color: liberado ? Colors.white : Colors.white70,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
