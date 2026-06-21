import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import '../../../widgets/main_tab_header.dart';
import '../../../widgets/podcast_volume_control.dart';

class _PodcastInfo {
  final int dia;
  final String titulo;
  final String descricao;
  final String asset;
  final IconData icon;
  final bool disponivel;

  const _PodcastInfo({
    required this.dia,
    required this.titulo,
    required this.descricao,
    required this.asset,
    required this.icon,
    this.disponivel = true,
  });
}

const List<_PodcastInfo> _podcastsDisponiveis = [
  _PodcastInfo(
    dia: 8,
    titulo: 'Coraferido Vírus e Injeção de Benzetacil',
    descricao: 'Feridas emocionais, autoconhecimento e transformação.',
    asset: 'podcast_desafio_08.m4a',
    icon: Icons.healing_rounded,
  ),
  _PodcastInfo(
    dia: 10,
    titulo: 'Suicida Emocional e Assassino Emocional',
    descricao: 'Reconheça padrões que ferem você e quem está ao seu redor.',
    asset: 'podcast_desafio_10.m4a',
    icon: Icons.favorite_rounded,
  ),
  _PodcastInfo(
    dia: 12,
    titulo: 'Troca de Óculos e Visualização Positiva',
    descricao: 'Novas perspectivas para enxergar sua história e seu futuro.',
    asset: 'podcast_desafio_12.m4a',
    icon: Icons.visibility_rounded,
  ),
  _PodcastInfo(
    dia: 15,
    titulo: '7 Passos da Sobrevivência',
    descricao: 'Conhecimento, estratégia e prática para transformar sua vida.',
    asset: 'podcast_desafio_15.m4a',
    icon: Icons.route_rounded,
  ),
  _PodcastInfo(
    dia: 23,
    titulo: 'As 5 Linguagens do Amor',
    descricao: 'Formas de expressar e receber amor com mais consciência.',
    asset: 'podcast_desafio_23.m4a',
    icon: Icons.volunteer_activism_rounded,
  ),
];

class PodcastsConteudoPage extends StatelessWidget {
  const PodcastsConteudoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final fundo = Theme.of(context).scaffoldBackgroundColor;

    return Scaffold(
      backgroundColor: fundo,
      body: Column(
        children: [
          MainTabHeader(
            title: 'Podcasts',
            subtitle: 'Ouça novamente os episódios da sua jornada',
            leading: const Icon(
              Icons.arrow_back_rounded,
              color: Colors.white,
              size: 30,
            ),
            onLeadingTap: () => Navigator.of(context).pop(),
            trailing: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(35),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.podcasts_rounded,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(14, 20, 14, 28),
              itemCount: _podcastsDisponiveis.length,
              separatorBuilder: (_, _) => const SizedBox(height: 14),
              itemBuilder: (context, index) {
                final podcast = _podcastsDisponiveis[index];
                return _PodcastLibraryCard(podcast: podcast, index: index);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _PodcastLibraryCard extends StatelessWidget {
  final _PodcastInfo podcast;
  final int index;

  const _PodcastLibraryCard({
    required this.podcast,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final escuro = Theme.of(context).brightness == Brightness.dark;
    final corTema = Theme.of(context).colorScheme.primary;
    final textoPrincipal = escuro ? Colors.white : Colors.black;
    final textoSecundario = escuro ? Colors.white60 : Colors.black54;
    final cardColor = escuro ? const Color(0xFF2A2527) : Colors.white;

    return Material(
      color: cardColor,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: podcast.disponivel
            ? () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>
                        _PodcastPlayerConteudoPage(podcast: podcast),
                  ),
                );
              }
            : null,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          constraints: const BoxConstraints(minHeight: 154),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: podcast.disponivel
                  ? corTema.withAlpha(135)
                  : Colors.white.withAlpha(24),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(28),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 92,
                height: 122,
                decoration: BoxDecoration(
                  color: podcast.disponivel
                      ? corTema.withAlpha(34 + (index * 8))
                      : Colors.white.withAlpha(12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      podcast.icon,
                      color: podcast.disponivel ? corTema : Colors.white38,
                      size: 38,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'DIA ${podcast.dia}',
                      style: TextStyle(
                        color:
                            podcast.disponivel ? corTema : Colors.white38,
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            podcast.titulo,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: podcast.disponivel
                                  ? textoPrincipal
                                  : textoSecundario,
                              fontSize: 17,
                              height: 1.2,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          podcast.disponivel
                              ? Icons.play_circle_fill_rounded
                              : Icons.schedule_rounded,
                          color: podcast.disponivel ? corTema : Colors.white38,
                          size: 29,
                        ),
                      ],
                    ),
                    const SizedBox(height: 9),
                    Text(
                      podcast.descricao,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: textoSecundario,
                        fontSize: 13,
                        height: 1.35,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      podcast.disponivel ? 'OUVIR EPISÓDIO' : 'ÁUDIO EM BREVE',
                      style: TextStyle(
                        color: podcast.disponivel ? corTema : Colors.white38,
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PodcastPlayerConteudoPage extends StatefulWidget {
  final _PodcastInfo podcast;

  const _PodcastPlayerConteudoPage({
    required this.podcast,
  });

  @override
  State<_PodcastPlayerConteudoPage> createState() =>
      _PodcastPlayerConteudoPageState();
}

class _PodcastPlayerConteudoPageState
    extends State<_PodcastPlayerConteudoPage> {
  final AudioPlayer player = AudioPlayer();
  final List<StreamSubscription<dynamic>> subscriptions = [];

  Duration posicao = Duration.zero;
  Duration duracao = Duration.zero;
  PlayerState estado = PlayerState.stopped;
  bool carregando = false;
  bool preparado = false;

  bool get tocando => estado == PlayerState.playing;

  @override
  void initState() {
    super.initState();
    subscriptions.add(
      player.onDurationChanged.listen((valor) {
        if (mounted) setState(() => duracao = valor);
      }),
    );
    subscriptions.add(
      player.onPositionChanged.listen((valor) {
        if (mounted) setState(() => posicao = valor);
      }),
    );
    subscriptions.add(
      player.onPlayerStateChanged.listen((valor) {
        if (mounted) setState(() => estado = valor);
      }),
    );
  }

  @override
  void dispose() {
    for (final subscription in subscriptions) {
      subscription.cancel();
    }
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final escuro = Theme.of(context).brightness == Brightness.dark;
    final fundo = Theme.of(context).scaffoldBackgroundColor;
    final corTema = Theme.of(context).colorScheme.primary;
    final textoPrincipal = escuro ? Colors.white : Colors.black;
    final textoSecundario = escuro ? Colors.white60 : Colors.black54;
    final cardColor = escuro ? const Color(0xFF2A2527) : Colors.white;
    final maximo =
        duracao.inMilliseconds > 0 ? duracao.inMilliseconds.toDouble() : 1.0;
    final valor = posicao.inMilliseconds.clamp(0, maximo.toInt()).toDouble();

    return Scaffold(
      backgroundColor: fundo,
      body: Column(
        children: [
          MainTabHeader(
            title: 'Podcast do Dia ${widget.podcast.dia}',
            subtitle: widget.podcast.titulo,
            leading: const Icon(
              Icons.arrow_back_rounded,
              color: Colors.white,
              size: 30,
            ),
            onLeadingTap: () => Navigator.of(context).pop(),
            trailing: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(35),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.graphic_eq_rounded,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 28),
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: corTema.withAlpha(120)),
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: 94,
                        height: 94,
                        decoration: BoxDecoration(
                          color: corTema.withAlpha(38),
                          shape: BoxShape.circle,
                          border: Border.all(color: corTema.withAlpha(120)),
                        ),
                        child: Icon(
                          widget.podcast.icon,
                          color: corTema,
                          size: 44,
                        ),
                      ),
                      const SizedBox(height: 18),
                      Text(
                        widget.podcast.titulo,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: textoPrincipal,
                          fontSize: 21,
                          height: 1.2,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.podcast.descricao,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: textoSecundario,
                          fontSize: 14,
                          height: 1.35,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Slider(
                        value: valor,
                        min: 0,
                        max: maximo,
                        activeColor: corTema,
                        inactiveColor: textoSecundario.withAlpha(45),
                        onChanged: duracao == Duration.zero
                            ? null
                            : (novoValor) {
                                player.seek(
                                  Duration(milliseconds: novoValor.round()),
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
                          IconButton(
                            tooltip: 'Voltar 10 segundos',
                            onPressed: () =>
                                _pular(const Duration(seconds: -10)),
                            icon: const Icon(Icons.replay_10_rounded),
                            color: corTema,
                          ),
                          const SizedBox(width: 14),
                          SizedBox(
                            width: 70,
                            height: 70,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: corTema,
                                foregroundColor: Colors.black,
                                shape: const CircleBorder(),
                                padding: EdgeInsets.zero,
                              ),
                              onPressed: carregando ? null : _alternar,
                              child: carregando
                                  ? const SizedBox(
                                      width: 25,
                                      height: 25,
                                      child: CircularProgressIndicator(
                                        color: Colors.black,
                                        strokeWidth: 2.5,
                                      ),
                                    )
                                  : Icon(
                                      tocando
                                          ? Icons.pause_rounded
                                          : Icons.play_arrow_rounded,
                                      size: 40,
                                    ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          IconButton(
                            tooltip: 'Avançar 30 segundos',
                            onPressed: () =>
                                _pular(const Duration(seconds: 30)),
                            icon: const Icon(Icons.forward_30_rounded),
                            color: corTema,
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      PodcastVolumeControl(player: player),
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

  Future<void> _alternar() async {
    if (tocando) {
      await player.pause();
      return;
    }

    setState(() => carregando = true);
    try {
      if (!preparado) {
        await player.setSource(AssetSource(widget.podcast.asset));
        preparado = true;
      }
      await player.resume();
    } finally {
      if (mounted) setState(() => carregando = false);
    }
  }

  Future<void> _pular(Duration deslocamento) async {
    if (duracao == Duration.zero) return;
    final destino = posicao + deslocamento;
    await player.seek(
      destino < Duration.zero
          ? Duration.zero
          : destino > duracao
              ? duracao
              : destino,
    );
  }

  String _formatarDuracao(Duration valor) {
    final minutos = valor.inMinutes.remainder(60).toString().padLeft(2, '0');
    final segundos = valor.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutos:$segundos';
  }
}
