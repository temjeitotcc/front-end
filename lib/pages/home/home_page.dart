import 'package:flutter/material.dart';
import '../../widgets/circulo_fase.dart';
import '../../services/auth_service.dart';
import '../../services/fases_service.dart';
import '../../services/pontos_service.dart';
import '../../widgets/main_tab_header.dart';
import '../fases/fase_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final int totalFases = 28;
  static const double _alturaGrupo = 760;
  static const double _tamanhoCirculoFase = 76;

  late List<DateTime?> fasesConcluidas;
  final service = FasesService();
  String nomeUsuario = 'você';

  @override
  void initState() {
    super.initState();
    fasesConcluidas = List.generate(totalFases, (_) => null);
    carregarFases();
    carregarNomeUsuario();
    PontosService.carregarPontos();
  }

  Future<void> carregarNomeUsuario() async {
    final nome = await AuthService.nomeUsuarioAtual();
    if (!mounted) return;
    setState(() => nomeUsuario = nome);
  }

  Future<void> carregarFases() async {
    await service.prepararRegrasAtuais(totalFases);
    fasesConcluidas = await service.carregarFases(totalFases);
    fasesConcluidas = await service.corrigirSequenciaDeFases(fasesConcluidas);
    setState(() {});
  }

  Future<void> salvarFases() async {
    await service.salvarFases(fasesConcluidas);
  }

  bool faseLiberada(int index) {
    return service.faseLiberada(fasesConcluidas, index);
  }

  int get diaAtual {
    final primeiroPendente =
        fasesConcluidas.indexWhere((concluida) => concluida == null);
    return primeiroPendente < 0 ? totalFases : primeiroPendente + 1;
  }

  bool get jornadaConcluida =>
      fasesConcluidas.isNotEmpty &&
      fasesConcluidas.every((concluida) => concluida != null);

  @override
  Widget build(BuildContext context) {
    final fundo = Theme.of(context).scaffoldBackgroundColor;
    final corTema = Theme.of(context).colorScheme.primary;

    return Scaffold(
      backgroundColor: fundo,
      body: Column(
        children: [
          MainTabHeader(
            title: 'Jornada',
            subtitle: jornadaConcluida
                ? 'Todos os desafios concluídos'
                : 'Continue pelo Dia $diaAtual',
            onLeadingTap: _abrirPainelPersonagem,
            onLeadingHorizontalDragEnd: (details) {
              final velocidade = details.primaryVelocity ?? 0;
              if (velocidade > 120) {
                _abrirPainelPersonagem();
              }
            },
            leading: Image.asset(
              'assets/imagem_esquerda.png',
              height: 52,
              fit: BoxFit.contain,
            ),
            trailing: ValueListenableBuilder<int>(
              valueListenable: PontosService.pontos,
              builder: (context, pontos, _) {
                return Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 9, vertical: 7),
                  decoration: BoxDecoration(
                    color: Colors.black.withAlpha(28),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '$pontos',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 3),
                      const Icon(
                        Icons.star_rounded,
                        color: Colors.white,
                        size: 16,
                      ),
                    ],
                  ),
                );
              },
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
        final corTema = Theme.of(context).colorScheme.primary;

        return Align(
          alignment: Alignment.centerLeft,
          child: SafeArea(
            top: false,
            child: Material(
              color: Colors.transparent,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.72,
                height: MediaQuery.of(context).size.height * 0.55,
                margin: const EdgeInsets.only(left: 0),
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
                decoration: BoxDecoration(
                  color: modoEscuro
                      ? const Color(0xFF2A2527)
                      : const Color(0xFFFFFBF0),
                  borderRadius: const BorderRadius.horizontal(
                    right: Radius.circular(34),
                  ),
                  border: Border.all(
                    color: corTema,
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
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/imagem_esquerda.png',
                              height: 64,
                              fit: BoxFit.contain,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    nomeUsuario,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: modoEscuro
                                          ? Colors.white
                                          : Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 9,
                                      vertical: 5,
                                    ),
                                    decoration: BoxDecoration(
                                      color: corTema,
                                      borderRadius: BorderRadius.circular(999),
                                    ),
                                    child: Text(
                                      jornadaConcluida
                                          ? 'Dia 28 concluído'
                                          : 'Você está no Dia $diaAtual',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 6),
                            IconButton(
                              tooltip: 'Fechar',
                              style: IconButton.styleFrom(
                                backgroundColor: corTema,
                                foregroundColor: Colors.black,
                                minimumSize: const Size(38, 38),
                                maximumSize: const Size(38, 38),
                                padding: EdgeInsets.zero,
                              ),
                              onPressed: () => Navigator.of(context).pop(),
                              icon: const Icon(Icons.close_rounded, size: 21),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: corCardInterno,
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: ValueListenableBuilder<int>(
                            valueListenable: PontosService.pontos,
                            builder: (context, pontos, _) {
                              return Row(
                                children: [
                                  Container(
                                    width: 38,
                                    height: 38,
                                    decoration: BoxDecoration(
                                      color: corTema.withAlpha(40),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.star_rounded,
                                      color: corTema,
                                      size: 23,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'PONTOS',
                                          style: TextStyle(
                                            color: corTextoSuave,
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          '$pontos',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: corTema,
                                            fontSize: 24,
                                            fontWeight: FontWeight.w900,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    'usar na loja',
                                    style: TextStyle(
                                      color: corTextoSuave,
                                      fontSize: 10,
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 12),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: modoEscuro
                                  ? const Color(0xFF211D1F)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.flag_rounded,
                                  color: corTema,
                                  size: 34,
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  jornadaConcluida
                                      ? 'Jornada concluída'
                                      : 'Próximo passo: Dia $diaAtual',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: modoEscuro
                                        ? Colors.white
                                        : Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  jornadaConcluida
                                      ? 'Você completou todos os desafios.'
                                      : 'Continue avançando no seu ritmo.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: corTextoSuave,
                                    fontSize: 12,
                                    height: 1.3,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: corTema.withAlpha(24),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: corTema.withAlpha(80)),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.swipe_right_alt_rounded,
                                color: corTema,
                                size: 21,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Toque ou puxe o personagem para abrir.',
                                  style: TextStyle(
                                    color: corTextoSuave,
                                    fontSize: 11,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
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
    final inicio = grupo * 7;

    return SizedBox(
      height: _alturaGrupo,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final posicoes = _posicoesCaminho(
            constraints.maxWidth,
            _alturaGrupo,
          );
          final posicaoEspecial = Offset(
            constraints.maxWidth / 2,
            _alturaGrupo * 0.055,
          );
          final indexEspecial = inicio + 6;

          return Stack(
            children: [
              Positioned.fill(
                child: CustomPaint(
                  painter: _CaminhoFasesPainter(
                    posicoes,
                    Theme.of(context).colorScheme.secondary,
                  ),
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
              Positioned(
                left: posicaoEspecial.dx - (_tamanhoCirculoFase / 2),
                top: posicaoEspecial.dy - (_tamanhoCirculoFase / 2),
                width: _tamanhoCirculoFase,
                height: _tamanhoCirculoFase,
                child: CirculoFase(
                  numero: '${grupo + 1}',
                  especial: true,
                  liberado: faseLiberada(indexEspecial),
                  onTap: () => abrirFase(indexEspecial),
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
      Offset(centro + deslocamentoPequeno, altura * 0.76),
      Offset(centro + deslocamentoGrande, altura * 0.62),
      Offset(centro + deslocamentoPequeno, altura * 0.48),
      Offset(centro - deslocamentoPequeno, altura * 0.34),
      Offset(centro, altura * 0.20),
    ];
  }

  Future<void> abrirFase(int index) async {
    if (!faseLiberada(index)) {
      _mostrarMensagemFaseBloqueada(index);
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

  String _mensagemFaseBloqueada(int index) {
    return service.mensagemFaseBloqueada(fasesConcluidas, index);
  }

  void _mostrarMensagemFaseBloqueada(int index) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFF2A2527),
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        margin: const EdgeInsets.fromLTRB(18, 0, 18, 96),
        duration: const Duration(seconds: 3),
        content: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.lock_rounded,
                color: Colors.black,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                _mensagemFaseBloqueada(index),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CaminhoFasesPainter extends CustomPainter {
  final List<Offset> posicoes;
  final Color cor;

  const _CaminhoFasesPainter(this.posicoes, this.cor);

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
      ..color = cor.withAlpha(92)
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
    return oldDelegate.posicoes != posicoes || oldDelegate.cor != cor;
  }
}
