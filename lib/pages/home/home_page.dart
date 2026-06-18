import 'package:flutter/material.dart';
import '../../widgets/circulo_fase.dart';
import '../../services/auth_service.dart';
import '../../services/conteudos_service.dart';
import '../../services/fases_service.dart';
import '../../services/pontos_service.dart';
import '../../widgets/main_tab_header.dart';
import '../fases/fase_page.dart';

class HomePage extends StatefulWidget {
  final int scrollSignal;

  const HomePage({super.key, required this.scrollSignal});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final int totalFases = 28;
  static const double _alturaGrupo = 760;
  static const double _tamanhoCirculoFase = 76;
  final ScrollController _jornadaController = ScrollController();
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

  @override
  void didUpdateWidget(covariant HomePage oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.scrollSignal != widget.scrollSignal) {
      _rolarJornadaParaBaixo();
    }
  }

  @override
  void dispose() {
    _jornadaController.dispose();
    super.dispose();
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
              controller: _jornadaController,
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

  void _rolarJornadaParaBaixo() {
    if (!_jornadaController.hasClients) return;

    _jornadaController.animateTo(
      _jornadaController.position.minScrollExtent,
      duration: const Duration(milliseconds: 650),
      curve: Curves.easeInOutCubic,
    );
  }

  void _abrirPainelPersonagem() {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Fechar',
      barrierColor: Colors.black.withAlpha(125),
      transitionDuration: const Duration(milliseconds: 280),
      pageBuilder: (context, animation, secondaryAnimation) {
        final modoEscuro = Theme.of(context).brightness == Brightness.dark;
        final corTema = Theme.of(context).colorScheme.primary;
        final fundoPainel =
            modoEscuro ? const Color(0xFF211D1F) : const Color(0xFFF8F7F3);
        final fundoCard =
            modoEscuro ? const Color(0xFF2A2527) : Colors.white;
        final textoPrincipal = modoEscuro ? Colors.white : Colors.black;
        final textoSecundario = modoEscuro ? Colors.white60 : Colors.black54;
        final concluidos =
            fasesConcluidas.where((data) => data != null).length;
        final progresso = concluidos / totalFases;
        final largura = MediaQuery.of(context).size.width;

        return Align(
          alignment: Alignment.centerLeft,
          child: SafeArea(
            child: Material(
              color: Colors.transparent,
              child: Container(
                width: (largura * 0.82).clamp(300.0, 380.0),
                margin: const EdgeInsets.only(right: 18),
                decoration: BoxDecoration(
                  color: fundoPainel,
                  borderRadius: const BorderRadius.horizontal(
                    right: Radius.circular(28),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(115),
                      blurRadius: 32,
                      offset: const Offset(12, 0),
                    ),
                  ],
                ),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      color: corTema,
                      padding: const EdgeInsets.fromLTRB(18, 18, 12, 18),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 66,
                            height: 66,
                            decoration: BoxDecoration(
                              color: Colors.white.withAlpha(38),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white.withAlpha(90),
                              ),
                            ),
                            padding: const EdgeInsets.all(5),
                            child: Image.asset(
                              'assets/imagem_esquerda.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                          const SizedBox(width: 13),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  nomeUsuario,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 19,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  jornadaConcluida
                                      ? 'Jornada concluída'
                                      : 'Sua jornada continua',
                                  style: TextStyle(
                                    color: Colors.white.withAlpha(205),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            tooltip: 'Fechar',
                            style: IconButton.styleFrom(
                              backgroundColor: Colors.white.withAlpha(35),
                              foregroundColor: Colors.white,
                              minimumSize: const Size(40, 40),
                              maximumSize: const Size(40, 40),
                              padding: EdgeInsets.zero,
                            ),
                            onPressed: () => Navigator.of(context).pop(),
                            icon: const Icon(Icons.close_rounded, size: 22),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: _ResumoJornadaCard(
                                  icon: Icons.calendar_today_rounded,
                                  rotulo: 'DIA ATUAL',
                                  valor: jornadaConcluida ? '28' : '$diaAtual',
                                  cor: corTema,
                                  fundo: fundoCard,
                                  textoPrincipal: textoPrincipal,
                                  textoSecundario: textoSecundario,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: ValueListenableBuilder<int>(
                                  valueListenable: PontosService.pontos,
                                  builder: (context, pontos, _) {
                                    return _ResumoJornadaCard(
                                      icon: Icons.star_rounded,
                                      rotulo: 'PONTOS',
                                      valor: '$pontos',
                                      cor: corTema,
                                      fundo: fundoCard,
                                      textoPrincipal: textoPrincipal,
                                      textoSecundario: textoSecundario,
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: fundoCard,
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(
                                color: corTema.withAlpha(75),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 38,
                                      height: 38,
                                      decoration: BoxDecoration(
                                        color: corTema.withAlpha(35),
                                        borderRadius:
                                            BorderRadius.circular(11),
                                      ),
                                      child: Icon(
                                        jornadaConcluida
                                            ? Icons.emoji_events_rounded
                                            : Icons.route_rounded,
                                        color: corTema,
                                        size: 22,
                                      ),
                                    ),
                                    const SizedBox(width: 11),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            jornadaConcluida
                                                ? 'Caminho completo'
                                                : 'Progresso da jornada',
                                            style: TextStyle(
                                              color: textoPrincipal,
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            '$concluidos de $totalFases desafios',
                                            style: TextStyle(
                                              color: textoSecundario,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      '${(progresso * 100).round()}%',
                                      style: TextStyle(
                                        color: corTema,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 14),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(999),
                                  child: LinearProgressIndicator(
                                    value: progresso,
                                    minHeight: 8,
                                    backgroundColor: corTema.withAlpha(28),
                                    valueColor:
                                        AlwaysStoppedAnimation(corTema),
                                  ),
                                ),
                                const SizedBox(height: 13),
                                Text(
                                  jornadaConcluida
                                      ? 'Você concluiu todos os desafios desta jornada.'
                                      : 'Próximo passo: concluir o Dia $diaAtual.',
                                  style: TextStyle(
                                    color: textoSecundario,
                                    fontSize: 13,
                                    height: 1.35,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
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
                    concluido: fasesConcluidas[inicio + i] != null,
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
                  concluido: fasesConcluidas[indexEspecial] != null,
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
    if (fasesConcluidas[index] != null) {
      final numero = index + 1;
      if (await _precisaRecuperarConteudo(numero)) {
        if (!mounted) return;
        await _abrirFaseParaRecuperarConteudo(index);
        return;
      }

      _mostrarMensagemFaseConcluida(index);
      return;
    }

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

  Future<bool> _precisaRecuperarConteudo(int numero) async {
    if (numero != 2) return false;

    final conteudos = await ConteudosService().carregarConteudos();
    final conteudo = conteudos[numero];
    if (conteudo == null) return true;

    return conteudo.itens.length < 10 ||
        conteudo.itens.any((item) => item.texto.trim().isEmpty);
  }

  Future<void> _abrirFaseParaRecuperarConteudo(int index) async {
    final concluida = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (context) => FasePage(numero: '${index + 1}')),
    );

    if (concluida != true || !mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Respostas recuperadas. O Dia 2 já está disponível em Desafios feitos.',
        ),
      ),
    );
  }

  void _mostrarMensagemFaseConcluida(int index) {
    final corTema = Theme.of(context).colorScheme.primary;
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
                color: Color.lerp(corTema, Colors.black, 0.42),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white.withAlpha(75)),
              ),
              child: const Icon(
                Icons.done_all_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Dia ${index + 1} concluído. Essa etapa já faz parte da sua jornada.',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
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

class _ResumoJornadaCard extends StatelessWidget {
  final IconData icon;
  final String rotulo;
  final String valor;
  final Color cor;
  final Color fundo;
  final Color textoPrincipal;
  final Color textoSecundario;

  const _ResumoJornadaCard({
    required this.icon,
    required this.rotulo,
    required this.valor,
    required this.cor,
    required this.fundo,
    required this.textoPrincipal,
    required this.textoSecundario,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 94),
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: fundo,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cor.withAlpha(70)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: cor, size: 21),
          const SizedBox(height: 12),
          Text(
            rotulo,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: textoSecundario,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            valor,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: textoPrincipal,
              fontSize: 22,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
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
