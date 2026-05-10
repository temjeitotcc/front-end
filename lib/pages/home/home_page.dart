import 'package:flutter/material.dart';
import '../../widgets/circulo_fase.dart';
import '../../services/fases_service.dart';
import '../../services/pontos_service.dart';
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
    PontosService.carregarPontos();
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
                GestureDetector(
                  onTap: _abrirPainelPersonagem,
                  onHorizontalDragEnd: (details) {
                    final velocidade = details.primaryVelocity ?? 0;
                    if (velocidade > 120) {
                      _abrirPainelPersonagem();
                    }
                  },
                  child: Image.asset('assets/imagem_esquerda.png', height: 50),
                ),
                Row(
                  children: [
                    ValueListenableBuilder<int>(
                      valueListenable: PontosService.pontos,
                      builder: (context, pontos, _) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withAlpha(28),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Row(
                            children: [
                              Text(
                                '$pontos',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Icon(
                                Icons.star,
                                color: Colors.white,
                                size: 18,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    const SizedBox(width: 8),
                    Image.asset('assets/imagem_direita.png', height: 70),
                  ],
                ),
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

  void _abrirPainelPersonagem() {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Fechar',
      barrierColor: Colors.black.withAlpha(90),
      transitionDuration: const Duration(milliseconds: 320),
      pageBuilder: (context, animation, secondaryAnimation) {
        final modoEscuro = Theme.of(context).brightness == Brightness.dark;
        final corTextoSuave = modoEscuro ? Colors.white70 : Colors.black54;
        final corCardInterno = modoEscuro
            ? Colors.black.withAlpha(24)
            : const Color(0xFFFFF2B8);

        return Align(
          alignment: Alignment.centerLeft,
          child: SafeArea(
            top: false,
            child: Material(
              color: Colors.transparent,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.62,
                height: MediaQuery.of(context).size.height * 0.55,
                margin: const EdgeInsets.only(left: 0),
                padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
                decoration: BoxDecoration(
                  color: modoEscuro
                      ? const Color(0xFF2A2527)
                      : const Color(0xFFFFFBF0),
                  borderRadius: const BorderRadius.horizontal(
                    right: Radius.circular(34),
                  ),
                  border: Border.all(
                    color: const Color(0xFFFED23E),
                    width: 3,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(100),
                      blurRadius: 30,
                      offset: const Offset(14, 0),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            Image.asset(
                              'assets/imagem_esquerda.png',
                              height: 72,
                              fit: BoxFit.contain,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFED23E),
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                child: const Text(
                                  'Personagem',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: corCardInterno,
                              borderRadius: BorderRadius.circular(22),
                            ),
                            child: ValueListenableBuilder<int>(
                              valueListenable: PontosService.pontos,
                              builder: (context, pontos, _) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'PONTOS',
                                      style: TextStyle(
                                        color: corTextoSuave,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Row(
                                        children: [
                                          Text(
                                            '$pontos',
                                            style: const TextStyle(
                                              color: Color(0xFFFED23E),
                                              fontSize: 52,
                                              fontWeight: FontWeight.w900,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          const Icon(
                                            Icons.star_rounded,
                                            color: Color(0xFFFED23E),
                                            size: 36,
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      'Use na lojinha para comprar itens.',
                                      style: TextStyle(
                                        color: corTextoSuave,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: modoEscuro
                                ? const Color(0xFF211D1F)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.swipe_right_alt_rounded,
                                color: Color(0xFFFED23E),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Puxe o personagem para abrir.',
                                  style: TextStyle(
                                    color: corTextoSuave,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: IconButton(
                        style: IconButton.styleFrom(
                          backgroundColor: const Color(0xFFFED23E),
                          foregroundColor: Colors.black,
                          minimumSize: const Size(36, 36),
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close_rounded, size: 20),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final deslocamento = Tween<Offset>(
          begin: const Offset(-1, 0),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
        );

        return FadeTransition(
          opacity: animation,
          child: SlideTransition(position: deslocamento, child: child),
        );
      },
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

  Future<void> abrirFase(int index) async {
    if (!faseLiberada(index)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Complete as fases anteriores primeiro!'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    final concluida = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (context) => FasePage(numero: '${index + 1}')),
    );

    if (concluida != true) return;

    setState(() {
      fasesConcluidas[index] = DateTime.now();
    });

    salvarFases();
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
