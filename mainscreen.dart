import 'package:flutter/material.dart';
import 'package:temjeito/pages/config.dart';
import 'package:temjeito/pages/home/home_page.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentIndex = 0;
  final PageController _controller = PageController();

  void mudarPagina(int index) {
    setState(() {
      currentIndex = index;
    });

    _controller.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B1819),

      body: PageView(
        controller: _controller,
        onPageChanged: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        children: const [
          Center(child: Text("Lojinha")),
          Center(child: Text("Conteudo")),
          HomePage(),
          Center(child: Text("É o pet")),
          ConfigPage(),
        ],
      ),

      // 🔥 NAVBAR NOVA
      bottomNavigationBar: Container(
        height: 90,
        decoration: const BoxDecoration(
          color: Color(0xFFFED23E),
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _botaoNav(0, 'assets/icon1.png'),
            _botaoNav(1, 'assets/icon2.png'),
            _botaoCentral(2, 'assets/icon3.png'), // 🔥 destaque
            _botaoNav(3, 'assets/icon4.png'),
            _botaoNav(4, 'assets/icon5.png'),
          ],
        ),
      ),
    );
  }

  // 🔥 BOTÕES NORMAIS
  Widget _botaoNav(int index, String imagem) {
    final ativo = currentIndex == index;

    return GestureDetector(
      onTap: () => mudarPagina(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        width: 60,
        height: 60,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: ativo ? Colors.white.withOpacity(0.15) : Colors.transparent,
          boxShadow: ativo
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: AnimatedScale(
          duration: const Duration(milliseconds: 200),
          scale: ativo ? 1.15 : 1.0,
          child: Image.asset(imagem, height: 28),
        ),
      ),
    );
  }

  // 💣 BOTÃO CENTRAL (ESTILO JOGO)
  Widget _botaoCentral(int index, String imagem) {
    final ativo = currentIndex == index;

    return GestureDetector(
      onTap: () => mudarPagina(index),
      child: Transform.translate(
        offset: const Offset(0, -20),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          width: 75,
          height: 75,
          decoration: BoxDecoration(
            color: const Color(0xFFFFC107),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.4),
                blurRadius: 15,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: AnimatedScale(
            duration: const Duration(milliseconds: 200),
            scale: ativo ? 1.1 : 1.0,
            child: Center(child: Image.asset(imagem, height: 35)),
          ),
        ),
      ),
    );
  }
}
