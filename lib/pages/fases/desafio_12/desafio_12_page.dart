import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import '../../../widgets/challenge_header_surface.dart';

import '../../../services/auth_service.dart';
import '../../../services/conteudos_service.dart';
import '../../../widgets/podcast_volume_control.dart';

class Desafio12Page extends StatefulWidget {
  const Desafio12Page({super.key});

  @override
  State<Desafio12Page> createState() => _Desafio12PageState();
}

class _Desafio12PageState extends State<Desafio12Page> {
  static const String _audioAsset = 'podcast_desafio_12.m4a';

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

    setState(() {
      nomeUsuario = nome;
    });
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
                              'Dia 12 - Podcast',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: textoPrincipal,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              switch (etapaAtual) {
                                0 => 'Troca de óculos e futuro',
                                1 => 'Visualização positiva',
                                _ => 'Escolha suas novas lentes',
                              },
                              style: TextStyle(color: textoSecundario),
                            ),
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
              _PodcastBadge(cor: Theme.of(context).colorScheme.primary),
              const SizedBox(height: 16),
              Text(
                'Oii, $nomeUsuario! Que bom ter você aqui para mais um dia!',
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
                    'Hoje você vai ouvir mais um podcast sobre dois temas muito importantes do livro: a Troca de Óculos e a Visualização Positiva do Futuro.',
                color: textoSecundario,
              ),
              _ParagraphText(
                text:
                    'Muitas vezes enxergamos nossa vida através dos óculos da dor, da mágoa, do medo ou da raiva.',
                color: textoSecundario,
              ),
              _ParagraphText(
                text:
                    'A proposta é trocar essas lentes por uma nova perspectiva, aprendendo a ressignificar o passado e o presente com mais gratidão, aprendizado e propósito.',
                color: textoSecundario,
              ),
              _ParagraphText(
                text:
                    'É a capacidade de imaginar, com clareza, o futuro que você deseja construir.',
                color: textoSecundario,
              ),
              _ParagraphText(
                text:
                    'Quando você direciona seus pensamentos, sentimentos e ações para esse futuro, seus sonhos começam a se transformar em metas e seus objetivos ganham um plano de ação.',
                color: textoSecundario,
              ),
              _ParagraphText(
                text: 'Agora é hora de ouvir o podcast!',
                color: textoSecundario,
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
                        Icons.visibility_rounded,
                        color: Colors.black,
                        size: 42,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Troca de Óculos e Visualização Positiva do Futuro',
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

  List<Widget> _conteudoReflexao(
    Color textoPrincipal,
    Color textoSecundario,
  ) {
    final corTema = Theme.of(context).colorScheme.primary;

    return [
      Text(
        'Uma nova forma de enxergar',
        style: TextStyle(
          color: textoPrincipal,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 10),
      Text(
        'Quais óculos você escolhe usar para enxergar sua história e qual futuro deseja começar a construir?',
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
            'Coloque o arquivo do podcast em assets/podcast_desafio_12.m4a.',
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

    setState(() {
      etapaAtual--;
    });
  }

  void _proximo() {
    setState(() {
      etapaAtual++;
    });
  }

  Future<void> _concluir() async {
    final resposta = reflexaoController.text.trim();
    if (resposta.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Escreva sua reflexão antes de concluir.')),
      );
      return;
    }

    await ConteudosService().salvarConteudosDoDesafio(
      desafio: 12,
      itens: [
        ConteudoItem(
          titulo: 'Reflexão sobre novas lentes e futuro',
          texto: resposta,
          reflexao: true,
        ),
      ],
    );

    if (!mounted) return;
    Navigator.of(context).pop(true);
  }
}

class _PodcastBadge extends StatelessWidget {
  final Color cor;

  const _PodcastBadge({required this.cor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cor.withAlpha(34),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: cor.withAlpha(160)),
      ),
      child: Row(
        children: [
          Icon(Icons.remove_red_eye_outlined, color: cor, size: 30),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Um podcast para trocar as lentes e visualizar um futuro novo.',
              style: TextStyle(
                color: cor,
                fontSize: 15,
                height: 1.3,
                fontWeight: FontWeight.bold,
              ),
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
        'Ouça com atenção e permita-se refletir sobre como você tem enxergado sua história e qual futuro deseja construir a partir de hoje.\n\nLembre-se: reconhecer padrões é o primeiro passo para transformá-los.\n\nReflita sobre esses ensinamentos e nos vemos amanhã para mais um desafio!',
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

  const _ParagraphText({
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 16,
          height: 1.35,
        ),
      ),
    );
  }
}
