import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import '../../../widgets/challenge_header_surface.dart';

import '../../../services/auth_service.dart';
import '../../../services/conteudos_service.dart';
import '../../../widgets/podcast_volume_control.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Desafio15Page extends StatefulWidget {
  const Desafio15Page({super.key});

  @override
  State<Desafio15Page> createState() => _Desafio15PageState();
}

class _Desafio15PageState extends State<Desafio15Page> {
  static const String _audioAsset = 'podcast_desafio_15.m4a';

  final AudioPlayer _audioPlayer = AudioPlayer();
  final TextEditingController reflexaoController = TextEditingController();
  final List<StreamSubscription<dynamic>> _subscriptions = [];

  String nomeUsuario = 'você';
  int etapaAtual = 0;
  Duration posicao = Duration.zero;
  Duration duracao = Duration.zero;
  PlayerState playerState = PlayerState.stopped;
  bool carregandoAudio = false;
  bool audioPreparado = false;

  bool get tocando => playerState == PlayerState.playing;

  @override
  void initState() {
    super.initState();
    _carregarNome();
    _subscriptions.add(
      _audioPlayer.onDurationChanged.listen((novaDuracao) {
        if (!mounted) return;
        setState(() => duracao = novaDuracao);
      }),
    );
    _subscriptions.add(
      _audioPlayer.onPositionChanged.listen((novaPosicao) {
        if (!mounted) return;
        setState(() => posicao = novaPosicao);
      }),
    );
    _subscriptions.add(
      _audioPlayer.onPlayerStateChanged.listen((novoEstado) {
        if (!mounted) return;
        setState(() => playerState = novoEstado);
      }),
    );
  }

  @override
  void dispose() {
    for (final subscription in _subscriptions) {
      subscription.cancel();
    }
    _audioPlayer.dispose();
    reflexaoController.dispose();
    super.dispose();
  }

  Future<void> _carregarNome() async {
    final nome = await AuthService.nomeUsuarioAtual();
    if (!mounted) return;
    setState(() => nomeUsuario = nome);
  }

  @override
  Widget build(BuildContext context) {
    final fundo = Theme.of(context).scaffoldBackgroundColor;
    final textoPrincipal = Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : Colors.black;
    final textoSecundario = Theme.of(context).brightness == Brightness.dark
        ? Colors.white70
        : Colors.black54;
    final cardColor = Theme.of(context).brightness == Brightness.dark
        ? const Color(0xFF2A2527)
        : Colors.white;
    final corTema = Theme.of(context).colorScheme.primary;

    return Scaffold(
      backgroundColor: fundo,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 18, 18, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ChallengeHeaderSurface(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Dia 15 - Podcast',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: textoPrincipal,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(switch (etapaAtual) {
                                0 => '7 Passos da Sobrevivência',
                                1 => 'Ouça e anote os passos',
                                _ => 'Escolha o seu próximo passo',
                              }, style: TextStyle(color: textoSecundario)),
                            ],
                          ),
                        ),
                        IconButton(
                          tooltip: 'Sair',
                          style: IconButton.styleFrom(
                            backgroundColor: corTema,
                            foregroundColor: Colors.black,
                          ),
                          onPressed: () => Navigator.of(context).pop(false),
                          icon: const Icon(Icons.close_rounded),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(999),
                      child: LinearProgressIndicator(
                        value: (etapaAtual + 1) / 3,
                        minHeight: 10,
                        backgroundColor: Colors.white12,
                        valueColor: AlwaysStoppedAnimation(corTema),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: corTema.withAlpha(120)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: switch (etapaAtual) {
                      0 => _conteudoTexto(textoPrincipal, textoSecundario),
                      1 => _conteudoPodcast(textoPrincipal, textoSecundario),
                      _ => _conteudoReflexao(textoPrincipal, textoSecundario),
                    },
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: textoPrincipal,
                        side: BorderSide(color: corTema),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: _voltar,
                      icon: const Icon(Icons.arrow_back_rounded),
                      label: const Text('Voltar'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: corTema,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: etapaAtual < 2 ? _proximo : _concluir,
                      icon: Icon(
                        etapaAtual < 2
                            ? Icons.arrow_forward_rounded
                            : Icons.check_rounded,
                      ),
                      label: Text(etapaAtual < 2 ? 'Próximo' : 'Concluir'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _conteudoTexto(Color textoPrincipal, Color textoSecundario) {
    return [
      Expanded(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _SurvivalHero(cor: Theme.of(context).colorScheme.primary),
              const SizedBox(height: 16),
              Text(
                'Oii, $nomeUsuario! Bem-Vindo(a) para mais um dia!',
                style: TextStyle(
                  color: textoPrincipal,
                  fontSize: 18,
                  height: 1.35,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 14),
              _ParagraphText(
                text:
                    'Hoje vamos ouvir um podcast sobre os 7 Passos da Sobrevivência, um conjunto de princípios que podem ajudar você a transformar conhecimento em ação e construir mudanças duradouras na sua vida.',
                color: textoSecundario,
              ),
              _ParagraphText(
                text:
                    'Ao longo desta jornada, você adquiriu novos aprendizados, refletiu sobre suas escolhas e tomou decisões importantes. Agora chegou o momento de colocar tudo isso em prática.',
                color: textoSecundario,
              ),
              _FormulaCard(cor: Theme.of(context).colorScheme.primary),
              const SizedBox(height: 14),
              _ParagraphText(
                text:
                    'Ou seja, não basta apenas aprender. É preciso aplicar, treinar e repetir até que os novos comportamentos façam parte da sua vida.',
                color: textoSecundario,
              ),
              _ParagraphText(
                text:
                    'Ouça o podcast com atenção e anote os 7 Passos da Sobrevivência.',
                color: textoSecundario,
              ),
              const SizedBox(height: 4),
              for (final passo in _passos)
                _StepMiniCard(
                  passo: passo,
                  cor: Theme.of(context).colorScheme.primary,
                ),
            ],
          ),
        ),
      ),
    ];
  }

  List<Widget> _conteudoPodcast(Color textoPrincipal, Color textoSecundario) {
    final corTema = Theme.of(context).colorScheme.primary;
    final sliderMax = duracao.inMilliseconds > 0
        ? duracao.inMilliseconds.toDouble()
        : 1.0;
    final sliderValue = posicao.inMilliseconds
        .clamp(0, duracao.inMilliseconds > 0 ? duracao.inMilliseconds : 1)
        .toDouble();

    return [
      Expanded(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? const Color(0xFF171315)
                      : const Color(0xFFF6F1E7),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: corTema.withAlpha(100)),
                ),
                child: Column(
                  children: [
                    Container(
                      width: 86,
                      height: 86,
                      decoration: BoxDecoration(
                        color: corTema,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: corTema.withAlpha(70),
                            blurRadius: 22,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.route_rounded,
                        color: Colors.black,
                        size: 42,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '7 Passos da Sobrevivência',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: textoPrincipal,
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 22),
                    Slider(
                      value: sliderValue,
                      min: 0,
                      max: sliderMax,
                      activeColor: corTema,
                      inactiveColor: textoSecundario.withAlpha(55),
                      onChanged: duracao.inMilliseconds == 0
                          ? null
                          : (valor) {
                              _audioPlayer.seek(
                                Duration(milliseconds: valor.round()),
                              );
                            },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _formatarDuracao(posicao),
                            style: TextStyle(color: textoSecundario),
                          ),
                          Text(
                            duracao == Duration.zero
                                ? '--:--'
                                : _formatarDuracao(duracao),
                            style: TextStyle(color: textoSecundario),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _AudioIconButton(
                          icon: Icons.replay_10_rounded,
                          tooltip: 'Voltar 10 segundos',
                          onTap: () => _pular(const Duration(seconds: -10)),
                        ),
                        const SizedBox(width: 14),
                        SizedBox(
                          width: 72,
                          height: 72,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: corTema,
                              foregroundColor: Colors.black,
                              shape: const CircleBorder(),
                              padding: EdgeInsets.zero,
                            ),
                            onPressed: carregandoAudio ? null : _alternarAudio,
                            child: carregandoAudio
                                ? const SizedBox(
                                    width: 26,
                                    height: 26,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.6,
                                      color: Colors.black,
                                    ),
                                  )
                                : Icon(
                                    tocando
                                        ? Icons.pause_rounded
                                        : Icons.play_arrow_rounded,
                                    size: 42,
                                  ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        _AudioIconButton(
                          icon: Icons.forward_30_rounded,
                          tooltip: 'Avançar 30 segundos',
                          onTap: () => _pular(const Duration(seconds: 30)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    PodcastVolumeControl(player: _audioPlayer),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _ClosingCard(cor: corTema),
            ],
          ),
        ),
      ),
    ];
  }

  List<Widget> _conteudoReflexao(Color textoPrincipal, Color textoSecundario) {
    final corTema = Theme.of(context).colorScheme.primary;

    return [
      Text(
        'Conhecimento que vira ação',
        style: TextStyle(
          color: textoPrincipal,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 10),
      Text(
        'Qual dos 7 Passos da Sobrevivência você mais precisa praticar agora, e qual ação concreta dará para começar?',
        style: TextStyle(color: textoSecundario, fontSize: 15, height: 1.35),
      ),
      const SizedBox(height: 14),
      Expanded(
        child: TextField(
          controller: reflexaoController,
          expands: true,
          maxLines: null,
          minLines: null,
          textAlignVertical: TextAlignVertical.top,
          style: TextStyle(color: textoPrincipal, fontSize: 16, height: 1.35),
          decoration: InputDecoration(
            hintText: 'Escreva sua reflexão...',
            hintStyle: TextStyle(color: textoSecundario.withAlpha(140)),
            filled: true,
            fillColor: Theme.of(context).brightness == Brightness.dark
                ? const Color(0xFF171315)
                : const Color(0xFFF6F1E7),
            contentPadding: const EdgeInsets.all(16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide(color: corTema, width: 2),
            ),
          ),
        ),
      ),
    ];
  }

  Future<void> _alternarAudio() async {
    if (tocando) {
      await _audioPlayer.pause();
      return;
    }

    setState(() => carregandoAudio = true);

    try {
      if (!audioPreparado) {
        await _audioPlayer.setSource(AssetSource(_audioAsset));
        audioPreparado = true;
      }

      await _audioPlayer.resume();
    } catch (_) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Coloque o arquivo do podcast em assets/podcast_desafio_15.m4a.',
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => carregandoAudio = false);
      }
    }
  }

  Future<void> _pular(Duration deslocamento) async {
    if (duracao == Duration.zero) return;

    final novaPosicao = posicao + deslocamento;
    final limiteInferior = Duration.zero;
    final limiteSuperior = duracao;

    await _audioPlayer.seek(
      novaPosicao < limiteInferior
          ? limiteInferior
          : novaPosicao > limiteSuperior
          ? limiteSuperior
          : novaPosicao,
    );
  }

  String _formatarDuracao(Duration duracao) {
    final minutos = duracao.inMinutes.remainder(60).toString().padLeft(2, '0');
    final segundos = duracao.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutos:$segundos';
  }

  void _voltar() {
    if (etapaAtual == 0) {
      Navigator.of(context).pop(false);
      return;
    }
    setState(() => etapaAtual--);
  }

  void _proximo() {
    setState(() => etapaAtual++);
  }

  Future<void> _concluir() async {
    final resposta = reflexaoController.text.trim();

    if (resposta.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Escreva sua reflexão antes de concluir.'),
        ),
      );
      return;
    }

    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return;

    final firestore = FirebaseFirestore.instance;

    // 1. Salvar/atualizar dados do usuário
    await firestore.collection('Usuários').doc(user.uid).set({
      'Nome': user.displayName ?? 'Usuários',
      'Email': user.email,
    }, SetOptions(merge: true));

    // 2. Salvar reflexão
    await firestore
        .collection('Usuários')
        .doc(user.uid)
        .collection('Desafios')
        .doc('Dia 15')
        .set({
          'Resposta': resposta,
          'Nome': user.displayName ?? 'Usuário',
          'Respondido em': FieldValue.serverTimestamp(),
        });

    await ConteudosService().salvarConteudosDoDesafio(
      desafio: 7,
      itens: [
        ConteudoItem(
          titulo: 'Reflexão sobre os 7 passos',
          texto: resposta,
          reflexao: true,
        ),
      ],
    );

    if (!mounted) return;
    Navigator.of(context).pop(true);
  }
}

const List<_SurvivalStep> _passos = [
  _SurvivalStep(
    '1',
    'Recupere seu foco',
    'Direcione sua atenção para aquilo que realmente importa.',
  ),
  _SurvivalStep(
    '2',
    'Aceite a mudança',
    'Crescer exige adaptação e disposição para sair da zona de conforto.',
  ),
  _SurvivalStep(
    '3',
    'Saia da autossabotagem',
    'Identifique comportamentos que limitam seu potencial.',
  ),
  _SurvivalStep(
    '4',
    'Encha sua caixa de ferramentas',
    'Busque conhecimento, habilidades e recursos para a vida.',
  ),
  _SurvivalStep(
    '5',
    'Fique ligado na gratidão',
    'Valorize suas conquistas, aprendizados e oportunidades.',
  ),
  _SurvivalStep(
    '6',
    'Estabeleça metas',
    'Transforme sonhos em objetivos concretos e crie um plano.',
  ),
  _SurvivalStep(
    '7',
    'Pratique a auto-responsabilidade',
    'Assuma o protagonismo e inspire pessoas.',
  ),
];

class _SurvivalStep {
  final String numero;
  final String titulo;
  final String descricao;

  const _SurvivalStep(this.numero, this.titulo, this.descricao);
}

class _SurvivalHero extends StatelessWidget {
  final Color cor;

  const _SurvivalHero({required this.cor});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 176,
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFF171315)
            : const Color(0xFFF6F1E7),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: cor.withAlpha(120)),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            child: CustomPaint(painter: _SurvivalPathPainter(cor: cor)),
          ),
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 54, 20, 42),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  for (int i = 0; i < 7; i++) ...[
                    Expanded(
                      child: Align(
                        alignment: Alignment(0, i.isEven ? -0.40 : 0.35),
                        child: CircleAvatar(
                          radius: 15,
                          backgroundColor: cor,
                          foregroundColor: Colors.black,
                          child: Text(
                            '${i + 1}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                    if (i < 6) const SizedBox(width: 5),
                  ],
                ],
              ),
            ),
          ),
          Positioned(
            top: 14,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.auto_awesome_rounded, color: cor, size: 18),
                const SizedBox(width: 8),
                Icon(Icons.flag_rounded, color: cor, size: 30),
                const SizedBox(width: 8),
                Icon(Icons.auto_awesome_rounded, color: cor, size: 18),
              ],
            ),
          ),
          Positioned(
            left: 20,
            right: 20,
            bottom: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
              decoration: BoxDecoration(
                color: cor.withAlpha(32),
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: cor.withAlpha(110)),
              ),
              child: Text(
                'sete passos para transformar conhecimento em ação',
                textAlign: TextAlign.center,
                maxLines: 2,
                style: TextStyle(
                  color: cor,
                  fontSize: 12,
                  height: 1.1,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SurvivalPathPainter extends CustomPainter {
  final Color cor;

  const _SurvivalPathPainter({required this.cor});

  @override
  void paint(Canvas canvas, Size size) {
    final base = Paint()
      ..color = cor.withAlpha(55)
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(size.width * 0.08, size.height * 0.72),
      Offset(size.width * 0.92, size.height * 0.72),
      base,
    );

    final paint = Paint()
      ..color = cor.withAlpha(85)
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final path = Path()
      ..moveTo(size.width * 0.10, size.height * 0.58)
      ..quadraticBezierTo(
        size.width * 0.45,
        size.height * 0.18,
        size.width * 0.90,
        size.height * 0.56,
      );
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _SurvivalPathPainter oldDelegate) {
    return oldDelegate.cor != cor;
  }
}

class _FormulaCard extends StatelessWidget {
  final Color cor;

  const _FormulaCard({required this.cor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cor.withAlpha(34),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: cor.withAlpha(150)),
      ),
      child: Text(
        'Conhecimento + Estratégia + Prática = Treinamento Eficaz',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: cor,
          fontSize: 17,
          height: 1.35,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _StepMiniCard extends StatelessWidget {
  final _SurvivalStep passo;
  final Color cor;

  const _StepMiniCard({required this.passo, required this.cor});

  @override
  Widget build(BuildContext context) {
    final textoPrincipal = Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : Colors.black;
    final textoSecundario = Theme.of(context).brightness == Brightness.dark
        ? Colors.white70
        : Colors.black54;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cor.withAlpha(24),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cor.withAlpha(85)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 15,
            backgroundColor: cor,
            foregroundColor: Colors.black,
            child: Text(
              passo.numero,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  passo.titulo,
                  style: TextStyle(
                    color: textoPrincipal,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  passo.descricao,
                  style: TextStyle(
                    color: textoSecundario,
                    fontSize: 13,
                    height: 1.25,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ClosingCard extends StatelessWidget {
  final Color cor;

  const _ClosingCard({required this.cor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cor.withAlpha(34),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: cor.withAlpha(150)),
      ),
      child: Text(
        'Repense sobre as ideias e entendimentos que adquiriu hoje e nós vemos amanhã.',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: cor,
          fontSize: 16,
          height: 1.35,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _AudioIconButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;

  const _AudioIconButton({
    required this.icon,
    required this.tooltip,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: tooltip,
      style: IconButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.primary.withAlpha(34),
        foregroundColor: Theme.of(context).colorScheme.primary,
        minimumSize: const Size(48, 48),
      ),
      onPressed: onTap,
      icon: Icon(icon, size: 28),
    );
  }
}

class _ParagraphText extends StatelessWidget {
  final String text;
  final Color color;

  const _ParagraphText({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Text(
        text,
        style: TextStyle(color: color, fontSize: 16, height: 1.35),
      ),
    );
  }
}
