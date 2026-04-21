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
        child: SizedBox(
          width: 80,
          height: 60,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                bottom: 0,
                child: Container(
                  width: 80,
                  height: 50,
                  decoration: const BoxDecoration(
                    color: Color(0xFFD4A900),
                    borderRadius: BorderRadius.all(Radius.elliptical(40, 25)),
                  ),
                ),
              ),
              Positioned(
                top: 0,
                child: Container(
                  width: 80,
                  height: 50,
                  decoration: BoxDecoration(
                    color: liberado
                        ? const Color(0xFFFED23E)
                        : const Color.fromARGB(255, 231, 192, 61),
                    borderRadius: const BorderRadius.all(
                      Radius.elliptical(40, 25),
                    ),
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
            ],
          ),
        ),
      ),
    );
  }
}
