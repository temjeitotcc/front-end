import 'package:flutter/material.dart';
import 'pages/home/home_page.dart'; // importa a tela principal

void main() {
  runApp(const MyApp());
}

// Widget raiz do app
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(), // chama a home
    );
  }
}
