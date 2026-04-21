import 'package:flutter/material.dart';
import '../../widgets/circulo_fase.dart';
import '../../services/fases_service.dart';
import '../fases/fase_page.dart';

// Tela principal do app
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
            child: Padding(
              padding: const EdgeInsets.only(bottom: 40),
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
          ),
          // NAVBAR
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
  }
}
