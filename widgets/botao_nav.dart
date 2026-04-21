import 'package:flutter/material.dart';

// Botão da barra inferior
class BotaoNav extends StatelessWidget {
  final String imagem;
  final bool ativo;
  final VoidCallback onTap;

  const BotaoNav({
    super.key,
    required this.imagem,
    required this.ativo,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
        transform: Matrix4.identity()
          ..translate(0.0, ativo ? -15.0 : 0.0)
          ..scale(ativo ? 1.1 : 1.0),
        width: ativo ? 100 : 70,
        height: ativo ? 67 : 50,
        decoration: BoxDecoration(
          color: const Color(0xFFD1AA23),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(ativo ? 0.45 : 0.25),
              offset: Offset(0, ativo ? 10 : 6),
              blurRadius: ativo ? 20 : 12,
            ),
          ],
        ),
        child: Center(child: Image.asset(imagem, height: ativo ? 60 : 40)),
      ),
    );
  }
}
