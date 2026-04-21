import 'package:flutter/material.dart';

class Page1 extends StatelessWidget {
  const Page1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B1819),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFED23E),
        centerTitle: true,
        title: const Text('Loja'),
      ),
      body: const Center(
        child: Text(
          'Loja',
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
      ),
    );
  }
}
