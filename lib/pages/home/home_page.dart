import 'package:flutter/material.dart';
import '../../widgets/circulo_fase.dart';
import '../../widgets/botao_nav.dart';
import '../../services/fases_service.dart';
import '../fases/fase_page.dart';
import 'package:temjeito/pages/menu/loja.dart';

// Tela principal do app
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int botaoSelecionado = -1;

  // Lista de datas das fases concluídas
  List<DateTime?> fasesConcluidas = [null, null, null, null, null, null];

  final service = FasesService();

  @override
  void initState() {
    super.initState();
    carregarFases();
  }

  // Carrega dados salvos
  Future<void> carregarFases() async {
    fasesConcluidas = await service.carregarFases();
    setState(() {});
  }

  // Salva progresso
  Future<void> salvarFases() async {
    await service.salvarFases(fasesConcluidas);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B1819),
      body: Column(
        children: [
          //  BARRA SUPERIOR
          Container(
            width: double.infinity,
            height: 60,
            color: const Color(0xFFFED23E),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset('assets/imagem_esquerda.png', height: 50),
                Image.asset('assets/imagem_direita.png', height: 70),
              ],
            ),
          ),

          // ÁREA CENTRAL (FASES)
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CirculoFase(
                    numero: '1',
                    liberado: service.faseLiberada(fasesConcluidas, 0),
                    onTap: () => abrirFase(0, '1'),
                  ),

                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CirculoFase(
                        numero: '6',
                        liberado: service.faseLiberada(fasesConcluidas, 5),
                        onTap: () => abrirFase(5, '6'),
                      ),
                      const SizedBox(width: 150),
                      CirculoFase(
                        numero: '2',
                        liberado: service.faseLiberada(fasesConcluidas, 1),
                        onTap: () => abrirFase(1, '2'),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CirculoFase(
                        numero: '5',
                        liberado: service.faseLiberada(fasesConcluidas, 4),
                        onTap: () => abrirFase(4, '5'),
                      ),
                      const SizedBox(width: 150),
                      CirculoFase(
                        numero: '3',
                        liberado: service.faseLiberada(fasesConcluidas, 2),
                        onTap: () => abrirFase(2, '3'),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  CirculoFase(
                    numero: '4',
                    liberado: service.faseLiberada(fasesConcluidas, 3),
                    onTap: () => abrirFase(3, '4'),
                  ),
                ],
              ),
            ),
          ),

          // NAVBAR
          Container(
            width: double.infinity,
            height: 100,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Container(height: 80, color: const Color(0xFFFED23E)),

                Positioned(
                  bottom: 15,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      BotaoNav(
                        imagem: 'assets/icon1.png',
                        ativo: botaoSelecionado == 0,
                        onTap: () => setState(() => botaoSelecionado = 0),
                      ),
                      BotaoNav(
                        imagem: 'assets/icon2.png',
                        ativo: botaoSelecionado == 1,
                        onTap: () => setState(() => botaoSelecionado = 1),
                      ),
                      BotaoNav(
                        imagem: 'assets/icon3.png',
                        ativo: botaoSelecionado == 2,
                        onTap: () => setState(() => botaoSelecionado = 2),
                      ),
                      BotaoNav(
                        imagem: 'assets/icon4.png',
                        ativo: botaoSelecionado == 3,
                        onTap: () => setState(() => botaoSelecionado = 3),
                      ),
                      BotaoNav(
                        imagem: 'assets/icon5.png',
                        ativo: botaoSelecionado == 4,
                        onTap: () => setState(() => botaoSelecionado = 4),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // abre fase
  void abrirFase(int index, String numero) {
    setState(() {
      fasesConcluidas[index] = DateTime.now();
    });

    salvarFases();

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FasePage(numero: numero)),
    );
  }
}
