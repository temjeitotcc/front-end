import 'package:flutter/material.dart';

// Tela de desafio/fase
class FasePage extends StatelessWidget {
  final String numero;

  const FasePage({super.key, required this.numero});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B1819),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFED23E),

        centerTitle: true,
        title: Text('Fase $numero'),
      ),
      body: Center(
        child: Text(
          'Desafio $numero',
          style: const TextStyle(color: Colors.white, fontSize: 24),
        ),
      ),
    );
  }
}
