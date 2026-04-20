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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFFFED23E),
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: const Color.fromARGB(255, 255, 255, 255),
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      home: HomePage(), // chama a home
    );
  }
}
