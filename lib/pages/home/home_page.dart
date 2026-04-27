import 'package:flutter/material.dart';
import '../../widgets/circulo_fase.dart';
import '../../services/fases_service.dart';
import '../fases/fase_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final int totalFases = 24;

  late List<DateTime?> fasesConcluidas;
  final service = FasesService();

  @override
  void initState() {
    super.initState();
    fasesConcluidas = List.generate(totalFases, (_) => null);
    carregarFases();
  }

  Future<void> carregarFases() async {
    fasesConcluidas = await service.carregarFases(totalFases);
    setState(() {});
  }

  Future<void> salvarFases() async {
    await service.salvarFases(fasesConcluidas);
  }

  bool faseLiberada(int index) {
    if (index == 0) return true;

    final grupoAtual = index ~/ 6;
    final inicioGrupoAtual = grupoAtual * 6;

    if (index == inicioGrupoAtual) {
      final inicioGrupoAnterior = inicioGrupoAtual - 6;
      final fimGrupoAnterior = inicioGrupoAtual;

      for (int i = inicioGrupoAnterior; i < fimGrupoAnterior; i++) {
        if (fasesConcluidas[i] == null) return false;
      }

      return true;
    }

    return fasesConcluidas[index - 1] != null;
  }

  @override
  Widget build(BuildContext context) {
    final fundo = Theme.of(context).scaffoldBackgroundColor;

    return Scaffold(
      backgroundColor: fundo,
      body: Column(
        children: [
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

          Expanded(
            child: ListView(
              reverse: true,
              padding: const EdgeInsets.only(bottom: 70),
              children: [
                _grupoFases(0),
                _grupoFases(1),
                _grupoFases(2),
                _grupoFases(3),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _grupoFases(int grupo) {
    final inicio = grupo * 6;

    return SizedBox(
      height: 430,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CirculoFase(
              numero: '${inicio + 6}',
              liberado: faseLiberada(inicio),
              onTap: () => abrirFase(inicio),
            ),

            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CirculoFase(
                  numero: '${inicio + 5}',
                  liberado: faseLiberada(inicio + 5),
                  onTap: () => abrirFase(inicio + 5),
                ),
                const SizedBox(width: 150),
                CirculoFase(
                  numero: '${inicio + 4}',
                  liberado: faseLiberada(inicio + 1),
                  onTap: () => abrirFase(inicio + 1),
                ),
              ],
            ),

            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CirculoFase(
                  numero: '${inicio + 3}',
                  liberado: faseLiberada(inicio + 4),
                  onTap: () => abrirFase(inicio + 4),
                ),
                const SizedBox(width: 150),
                CirculoFase(
                  numero: '${inicio + 2}',
                  liberado: faseLiberada(inicio + 2),
                  onTap: () => abrirFase(inicio + 2),
                ),
              ],
            ),

            const SizedBox(height: 20),

            CirculoFase(
              numero: '${inicio + 1}',
              liberado: faseLiberada(inicio + 3),
              onTap: () => abrirFase(inicio + 3),
            ),
          ],
        ),
      ),
    );
  }

  void abrirFase(int index) {
    if (!faseLiberada(index)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Complete as fases anteriores primeiro!'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    setState(() {
      fasesConcluidas[index] = DateTime.now();
    });

    salvarFases();

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FasePage(numero: '${index + 1}')),
    );
  }
}
