import 'package:flutter/material.dart';

class Page1 extends StatelessWidget {
  const Page1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B1819),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFED23E),
        title: const Text('Página 1'),
      ),
      body: const Center(
        child: Text(
          'Tela 1',
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
      ),
    );
  }
}
