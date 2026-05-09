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
  static const double _alturaGrupo = 640;
  static const double _tamanhoCirculoFase = 76;

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
      height: _alturaGrupo,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final posicoes = _posicoesCaminho(
            constraints.maxWidth,
            _alturaGrupo,
          );

          return Stack(
            children: [
              Positioned.fill(
                child: CustomPaint(
                  painter: _CaminhoFasesPainter(posicoes),
                ),
              ),
              for (int i = 0; i < posicoes.length; i++)
                Positioned(
                  left: posicoes[i].dx - (_tamanhoCirculoFase / 2),
                  top: posicoes[i].dy - (_tamanhoCirculoFase / 2),
                  width: _tamanhoCirculoFase,
                  height: _tamanhoCirculoFase,
                  child: CirculoFase(
                    numero: '${inicio + i + 1}',
                    liberado: faseLiberada(inicio + i),
                    onTap: () => abrirFase(inicio + i),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  List<Offset> _posicoesCaminho(double largura, double altura) {
    final larguraUtil = largura.clamp(260.0, 430.0);
    final centro = largura / 2;
    final deslocamentoPequeno = (larguraUtil * 0.18).clamp(46.0, 72.0);
    final deslocamentoGrande = (larguraUtil * 0.30).clamp(82.0, 126.0);

    return [
      Offset(centro - deslocamentoPequeno, altura * 0.90),
      Offset(centro + deslocamentoPequeno, altura * 0.74),
      Offset(centro + deslocamentoGrande, altura * 0.58),
      Offset(centro + deslocamentoPequeno, altura * 0.42),
      Offset(centro - deslocamentoPequeno, altura * 0.26),
      Offset(centro, altura * 0.10),
    ];
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

class _CaminhoFasesPainter extends CustomPainter {
  final List<Offset> posicoes;

  const _CaminhoFasesPainter(this.posicoes);

  @override
  void paint(Canvas canvas, Size size) {
    if (posicoes.length < 2) return;

    final sombra = Paint()
      ..color = Colors.black.withAlpha(12)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 18
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final caminho = Paint()
      ..color = const Color(0xFFFFE58A).withAlpha(92)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path()..moveTo(posicoes.first.dx, posicoes.first.dy);

    for (int i = 1; i < posicoes.length; i++) {
      final anterior = posicoes[i - 1];
      final atual = posicoes[i];
      final controle = Offset(
        (anterior.dx + atual.dx) / 2,
        (anterior.dy + atual.dy) / 2,
      );

      path.quadraticBezierTo(controle.dx, controle.dy, atual.dx, atual.dy);
    }

    canvas.drawPath(path, sombra);
    canvas.drawPath(path, caminho);
  }

  @override
  bool shouldRepaint(covariant _CaminhoFasesPainter oldDelegate) {
    return oldDelegate.posicoes != posicoes;
  }
}
