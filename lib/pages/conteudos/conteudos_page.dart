import 'package:flutter/material.dart';

import 'dart:async';

import 'package:audioplayers/audioplayers.dart';

import '../../services/conteudos_service.dart';
import '../../services/feedback_service.dart';
import '../../widgets/main_tab_header.dart';
import '../../widgets/podcast_volume_control.dart';
import 'feedbacks_page.dart';
import 'livro_page.dart';

// Desative antes de gerar a versão de lançamento.
const bool visualizarTodosDesafiosFeitos = true;
const Set<int> questionariosDePodcast = {9, 11, 13, 16};

bool conteudoDisponivelParaExibicao(
  int numero,
  ConteudoDesafio conteudo,
) {
  if (numero == 2) {
    return conteudo.itens.length >= 10 &&
        conteudo.itens.every((item) => item.texto.trim().isNotEmpty);
  }

  if (numero == 22) {
    return conteudo.itens.length >= 3;
  }

  if (numero == 26) {
    return conteudo.itens.length >= 7;
  }

  return conteudo.temReflexao;
}

String tituloDesafio(int numero) {
  return switch (numero) {
    1 => 'Dia 1 - Bem Vindo ao seu treinamento',
    2 => 'Dia 2 - Minha empresa, minha vida',
    3 => 'Dia 3 - Eu escolho',
    4 => 'Dia 4 - O que me move',
    5 => 'Dia 5 - Quem sou eu?',
    6 => 'Dia 6 - Exercitando a Sabedoria',
    7 => 'Dia 7 - Reflexão Semanal',
    8 => 'Dia 8 - Podcast',
    9 => 'Dia 9 - Coraferido Vírus',
    10 => 'Dia 10 - Podcast',
    11 => 'Dia 11 - Suicida Emocional',
    12 => 'Dia 12 - Podcast',
    13 => 'Dia 13 - Troca de Óculos',
    14 => 'Dia 14 - Reflexão Semanal',
    15 => 'Dia 15 - Podcast',
    16 => 'Dia 16 - 7 Passos',
    17 => 'Dia 17 - Trocando de Óculos',
    18 => 'Dia 18 - Nossa essência é servir',
    19 => 'Dia 19 - Revisitando Minha Empresa, Minha Vida',
    20 => 'Dia 20 - Identidade, Utilidade e Pertencimento',
    21 => 'Dia 21 - Reflexão Semanal',
    22 => 'Dia 22 - Responsabilidade e Propósito',
    23 => 'Dia 23 - Podcast',
    24 => 'Dia 24 - As 5 Linguagens do Amor',
    25 => 'Dia 25 - Revisitando os Aprendizados',
    26 => 'Dia 26 - Mural dos Sonhos',
    27 => 'Dia 27 - Visão Positiva do Futuro',
    28 => 'Dia 28 - Encerramento',
    _ => 'Desafio $numero',
  };
}

String temaDesafio(int numero) {
  final titulo = tituloDesafio(numero);
  final separador = titulo.indexOf(' - ');
  return separador >= 0 ? titulo.substring(separador + 3) : titulo;
}

class ConteudosPage extends StatefulWidget {
  final int refreshKey;

  const ConteudosPage({super.key, required this.refreshKey});

  @override
  State<ConteudosPage> createState() => _ConteudosPageState();
}

class _ConteudosPageState extends State<ConteudosPage> {
  final ConteudosService service = ConteudosService();
  static const List<int> missoesEspeciais = [7, 14, 21, 28];
  static const Set<int> desafiosComAtividadeSalva = {2, 22, 26};
  Map<int, ConteudoDesafio> conteudos = {};
  List<BlocoReflexao> blocosReflexao = [];

  @override
  void initState() {
    super.initState();
    carregarConteudos();
  }

  @override
  void didUpdateWidget(covariant ConteudosPage oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.refreshKey != widget.refreshKey) {
      carregarConteudos();
    }
  }

  Future<void> carregarConteudos() async {
    final dados = await service.carregarConteudos();
    final blocos = await service.carregarBlocosReflexao();
    if (!mounted) return;

    setState(() {
      conteudos = dados;
      blocosReflexao = blocos;
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
    final desafiosSalvos = conteudos.entries
        .where(
          (entry) =>
              !missoesEspeciais.contains(entry.key) &&
              !questionariosDePodcast.contains(entry.key) &&
              conteudoDisponivelParaExibicao(entry.key, entry.value),
        )
        .length;
    final especiaisSalvas = conteudos.entries
        .where(
          (entry) =>
              missoesEspeciais.contains(entry.key) &&
              entry.value.temReflexao,
        )
        .length;

    return Scaffold(
      backgroundColor: fundo,
      body: Column(
        children: [
          const MainTabHeader(
            title: 'Conteúdos',
            subtitle: 'Releia suas respostas e reflexões',
            icon: Icons.menu_book_rounded,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 18, 14, 18),
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.06,
                children: [
                  _ConteudoCard(
                    titulo: 'Desafios feitos',
                    subtitulo: '$desafiosSalvos salvos',
                    icon: Icons.menu_book_rounded,
                    onTap: () async {
                      await carregarConteudos();
                      if (!context.mounted) return;
                      await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              const DesafiosFeitosPage(),
                        ),
                      );
                      carregarConteudos();
                    },
                  ),
                  _ConteudoCard(
                    titulo: 'Reflexão da semana',
                    subtitulo: '$especiaisSalvas salvas',
                    icon: Icons.auto_awesome_rounded,
                    onTap: () async {
                      await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              MissoesEspeciaisPage(conteudos: conteudos),
                        ),
                      );
                      carregarConteudos();
                    },
                  ),
                  _ConteudoCard(
                    titulo: 'Bloco de reflexões',
                    subtitulo: '${blocosReflexao.length} bloco(s)',
                    icon: Icons.edit_note_rounded,
                    onTap: () async {
                      await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const BlocosReflexaoPage(),
                        ),
                      );
                      carregarConteudos();
                    },
                  ),
                  _ConteudoCard(
                    titulo: 'Podcasts',
                    subtitulo: '5 episódios',
                    icon: Icons.headphones_rounded,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const PodcastsConteudoPage(),
                        ),
                      );
                    },
                  ),
                  _ConteudoCard(
                    titulo: 'Livro',
                    subtitulo: 'Leia ou baixe o PDF',
                    icon: Icons.auto_stories_rounded,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const LivroConteudoPage(),
                        ),
                      );
                    },
                  ),
                  StreamBuilder<List<FeedbackMensagem>>(
                    stream: FeedbackService().observarFeedbacks(),
                    builder: (context, snapshot) {
                      final naoLidas = (snapshot.data ?? const [])
                          .where((feedback) => !feedback.lido)
                          .length;

                      return _ConteudoCard(
                        titulo: 'Notificações',
                        subtitulo: naoLidas == 0
                            ? 'Nenhuma mensagem nova'
                            : naoLidas == 1
                                ? '1 mensagem nova'
                                : '$naoLidas mensagens novas',
                        icon: naoLidas > 0
                            ? Icons.mark_email_unread_rounded
                            : Icons.mail_outline_rounded,
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const FeedbacksPage(),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

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
                        PodcastPlayerConteudoPage(podcast: podcast),
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

class PodcastPlayerConteudoPage extends StatefulWidget {
  final _PodcastInfo podcast;

  const PodcastPlayerConteudoPage({
    super.key,
    required this.podcast,
  });

  @override
  State<PodcastPlayerConteudoPage> createState() =>
      _PodcastPlayerConteudoPageState();
}

class _PodcastPlayerConteudoPageState
    extends State<PodcastPlayerConteudoPage> {
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

class _ConteudoCard extends StatelessWidget {
  final String titulo;
  final String subtitulo;
  final IconData icon;
  final VoidCallback onTap;
  final bool apagado;

  const _ConteudoCard({
    required this.titulo,
    required this.subtitulo,
    required this.icon,
    required this.onTap,
    this.apagado = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: apagado ? const Color(0xFF3A3436) : const Color(0xFF2A2527),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: apagado
                ? Colors.white.withAlpha(24)
                : Theme.of(context).colorScheme.primary.withAlpha(170),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(35),
              blurRadius: 10,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.black),
            ),
            const Spacer(),
            Text(
              titulo,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitulo,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.white60, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}

class BlocosReflexaoPage extends StatefulWidget {
  const BlocosReflexaoPage({super.key});

  @override
  State<BlocosReflexaoPage> createState() => _BlocosReflexaoPageState();
}

class _BlocosReflexaoPageState extends State<BlocosReflexaoPage> {
  final ConteudosService service = ConteudosService();
  List<BlocoReflexao> blocos = [];

  @override
  void initState() {
    super.initState();
    carregarBlocos();
  }

  Future<void> carregarBlocos() async {
    final dados = await service.carregarBlocosReflexao();
    if (!mounted) return;

    setState(() {
      blocos = dados;
    });
  }

  @override
  Widget build(BuildContext context) {
    final fundo = Theme.of(context).scaffoldBackgroundColor;
    final corTema = Theme.of(context).colorScheme.primary;
    final escuro = Theme.of(context).brightness == Brightness.dark;
    final textoPrincipal = escuro ? Colors.white : Colors.black;
    final textoSecundario = escuro ? Colors.white70 : Colors.black54;

    return Scaffold(
      backgroundColor: fundo,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: corTema,
        foregroundColor: Colors.black,
        onPressed: () => abrirEditor(),
        icon: const Icon(Icons.add_rounded),
        label: const Text(
          'Criar bloco',
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
      ),
      body: Column(
        children: [
          MainTabHeader(
            title: 'Bloco de reflexões',
            subtitle: 'Um espaço livre para guardar seus pensamentos',
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
                Icons.edit_note_rounded,
                color: Colors.white,
                size: 25,
              ),
            ),
          ),
          Expanded(
            child: blocos.isEmpty
                ? _BlocoVazio(
                    cor: corTema,
                    textoPrincipal: textoPrincipal,
                    textoSecundario: textoSecundario,
                    onCriar: () => abrirEditor(),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(14, 18, 14, 96),
                    itemCount: blocos.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final bloco = blocos[index];

                      return _BlocoReflexaoCard(
                        bloco: bloco,
                        index: index,
                        onTap: () => abrirEditor(bloco: bloco),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Future<void> abrirEditor({BlocoReflexao? bloco}) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EditorBlocoReflexaoPage(bloco: bloco),
      ),
    );

    carregarBlocos();
  }
}

class _BlocoVazio extends StatelessWidget {
  final Color cor;
  final Color textoPrincipal;
  final Color textoSecundario;
  final VoidCallback onCriar;

  const _BlocoVazio({
    required this.cor,
    required this.textoPrincipal,
    required this.textoSecundario,
    required this.onCriar,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 86,
              height: 86,
              decoration: BoxDecoration(
                color: cor.withAlpha(30),
                shape: BoxShape.circle,
                border: Border.all(color: cor.withAlpha(90)),
              ),
              child: Icon(Icons.edit_note_rounded, color: cor, size: 42),
            ),
            const SizedBox(height: 18),
            Text(
              'Seu bloco ainda está em branco',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: textoPrincipal,
                fontSize: 19,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Crie um espaço livre para guardar ideias, sentimentos e reflexões que não precisam caber em nenhum desafio.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: textoSecundario,
                fontSize: 14,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 18),
            ElevatedButton.icon(
              onPressed: onCriar,
              icon: const Icon(Icons.add_rounded),
              label: const Text('CRIAR PRIMEIRO BLOCO'),
              style: ElevatedButton.styleFrom(
                backgroundColor: cor,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 13,
                ),
                textStyle: const TextStyle(fontWeight: FontWeight.w900),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BlocoReflexaoCard extends StatelessWidget {
  final BlocoReflexao bloco;
  final int index;
  final VoidCallback onTap;

  const _BlocoReflexaoCard({
    required this.bloco,
    required this.index,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final escuro = Theme.of(context).brightness == Brightness.dark;
    final corTema = Theme.of(context).colorScheme.primary;
    final textoPrincipal = escuro ? Colors.white : Colors.black;
    final textoSecundario = escuro ? Colors.white60 : Colors.black54;
    final cardColor = escuro ? const Color(0xFF2A2527) : Colors.white;
    final preview = bloco.texto.trim().isEmpty
        ? 'Sem texto ainda. Toque para continuar escrevendo.'
        : bloco.texto.trim();

    return Material(
      color: cardColor,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: corTema.withAlpha(115)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(24),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 54,
                height: 68,
                decoration: BoxDecoration(
                  color: corTema.withAlpha(34 + (index % 3) * 12),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: corTema.withAlpha(80)),
                ),
                child: Icon(Icons.notes_rounded, color: corTema, size: 28),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            bloco.tema,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: textoPrincipal,
                              fontSize: 17,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          Icons.chevron_right_rounded,
                          color: corTema,
                          size: 26,
                        ),
                      ],
                    ),
                    const SizedBox(height: 7),
                    Text(
                      preview,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: textoSecundario,
                        fontSize: 13,
                        height: 1.35,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(
                          Icons.schedule_rounded,
                          color: textoSecundario,
                          size: 14,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          'Atualizado em ${_formatarDataBloco(bloco.atualizadoEm)}',
                          style: TextStyle(
                            color: textoSecundario,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
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

  String _formatarDataBloco(DateTime data) {
    return '${data.day.toString().padLeft(2, '0')}/'
        '${data.month.toString().padLeft(2, '0')}/'
        '${data.year}';
  }
}

class EditorBlocoReflexaoPage extends StatefulWidget {
  final BlocoReflexao? bloco;

  const EditorBlocoReflexaoPage({super.key, this.bloco});

  @override
  State<EditorBlocoReflexaoPage> createState() =>
      _EditorBlocoReflexaoPageState();
}

class _EditorBlocoReflexaoPageState extends State<EditorBlocoReflexaoPage> {
  final ConteudosService service = ConteudosService();
  late final TextEditingController temaController;
  late final TextEditingController textoController;

  @override
  void initState() {
    super.initState();
    temaController = TextEditingController(text: widget.bloco?.tema ?? '');
    textoController = TextEditingController(text: widget.bloco?.texto ?? '');
  }

  @override
  void dispose() {
    temaController.dispose();
    textoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fundo = Theme.of(context).scaffoldBackgroundColor;
    final corTema = Theme.of(context).colorScheme.primary;
    final escuro = Theme.of(context).brightness == Brightness.dark;
    final textoPrincipal = escuro ? Colors.white : Colors.black;
    final textoSecundario = escuro ? Colors.white70 : Colors.black54;
    final cardColor = escuro ? const Color(0xFF2A2527) : Colors.white;

    return Scaffold(
      backgroundColor: fundo,
      body: Column(
        children: [
          MainTabHeader(
            title: widget.bloco == null ? 'Novo bloco' : 'Editar bloco',
            subtitle: 'Guarde uma reflexão livre da sua jornada',
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
                Icons.edit_note_rounded,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
              children: [
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: corTema.withAlpha(120)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(26),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: corTema.withAlpha(38),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Icon(
                              Icons.psychology_alt_rounded,
                              color: corTema,
                              size: 26,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Bloco pessoal',
                                  style: TextStyle(
                                    color: textoPrincipal,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  'Escreva sem pressa, do seu jeito.',
                                  style: TextStyle(
                                    color: textoSecundario,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      TextField(
                        controller: temaController,
                        textInputAction: TextInputAction.next,
                        textCapitalization: TextCapitalization.sentences,
                        style: TextStyle(
                          color: textoPrincipal,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                        decoration: _decoracaoBloco(
                          context,
                          label: 'Tema da reflexão',
                          hint: 'Ex.: O que eu percebi hoje',
                          icon: Icons.bookmark_outline_rounded,
                        ),
                      ),
                      const SizedBox(height: 14),
                      SizedBox(
                        height: MediaQuery.sizeOf(context).height * 0.42,
                        child: TextField(
                          controller: textoController,
                          expands: true,
                          maxLines: null,
                          minLines: null,
                          textAlignVertical: TextAlignVertical.top,
                          textCapitalization: TextCapitalization.sentences,
                          style: TextStyle(
                            color: textoPrincipal,
                            fontSize: 16,
                            height: 1.38,
                          ),
                          decoration: _decoracaoBloco(
                            context,
                            hint: 'Escreva sua reflexão livremente...',
                            alignLabelTop: true,
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      Container(
                        padding: const EdgeInsets.all(13),
                        decoration: BoxDecoration(
                          color: corTema.withAlpha(26),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: corTema.withAlpha(80)),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.lock_outline_rounded,
                              color: corTema,
                              size: 20,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'Esse bloco fica salvo apenas neste aparelho.',
                                style: TextStyle(
                                  color: textoSecundario,
                                  fontSize: 13,
                                  height: 1.3,
                                  fontWeight: FontWeight.w600,
                                ),
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
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: corTema,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    textStyle: const TextStyle(fontWeight: FontWeight.w900),
                  ),
                  onPressed: salvar,
                  icon: const Icon(Icons.save_rounded),
                  label: const Text('SALVAR BLOCO'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _decoracaoBloco(
    BuildContext context, {
    String? label,
    required String hint,
    IconData? icon,
    bool alignLabelTop = false,
  }) {
    final corTema = Theme.of(context).colorScheme.primary;
    final escuro = Theme.of(context).brightness == Brightness.dark;
    final textoSecundario = escuro ? Colors.white60 : Colors.black45;

    return InputDecoration(
      labelText: label,
      hintText: hint,
      alignLabelWithHint: alignLabelTop,
      labelStyle: TextStyle(color: textoSecundario),
      hintStyle: TextStyle(color: textoSecundario.withAlpha(150)),
      prefixIcon: icon == null ? null : Icon(icon, color: corTema),
      filled: true,
      fillColor: escuro ? const Color(0xFF171315) : const Color(0xFFF6F1E7),
      contentPadding: const EdgeInsets.all(16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: corTema, width: 2),
      ),
    );
  }

  Future<void> salvar() async {
    final tema = temaController.text.trim();
    final texto = textoController.text.trim();

    if (tema.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Coloque um tema para a reflexão.')),
      );
      return;
    }

    await service.salvarBlocoReflexao(
      id: widget.bloco?.id,
      tema: tema,
      texto: texto,
    );

    if (!mounted) return;
    Navigator.of(context).pop();
  }
}

class DesafiosFeitosPage extends StatefulWidget {
  static const List<int> missoesEspeciais = [7, 14, 21, 28];
  static const Set<int> desafiosComAtividadeSalva = {2, 22, 26};

  const DesafiosFeitosPage({super.key});

  @override
  State<DesafiosFeitosPage> createState() => _DesafiosFeitosPageState();
}

class _DesafiosFeitosPageState extends State<DesafiosFeitosPage> {
  final ConteudosService service = ConteudosService();
  Map<int, ConteudoDesafio> conteudos = {};
  bool carregando = true;

  @override
  void initState() {
    super.initState();
    carregarConteudos();
  }

  Future<void> carregarConteudos() async {
    final dados = await service.carregarConteudos();
    if (!mounted) return;

    setState(() {
      conteudos = dados;
      carregando = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final fundo = Theme.of(context).scaffoldBackgroundColor;
    final numeros = visualizarTodosDesafiosFeitos
        ? [
            for (int numero = 1; numero <= 28; numero++)
              if (!DesafiosFeitosPage.missoesEspeciais.contains(numero) &&
                  !questionariosDePodcast.contains(numero))
                numero,
          ]
        : (conteudos.entries
              .where(
                (entry) =>
                    !DesafiosFeitosPage.missoesEspeciais.contains(entry.key) &&
                    !questionariosDePodcast.contains(entry.key) &&
                    conteudoDisponivelParaExibicao(entry.key, entry.value),
              )
              .map((entry) => entry.key)
              .toList()
          ..sort());

    return Scaffold(
      backgroundColor: fundo,
      body: Column(
        children: [
          MainTabHeader(
            title: 'Desafios feitos',
            subtitle: 'Relembre respostas, escolhas e aprendizados',
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
                Icons.auto_stories_rounded,
                color: Colors.white,
                size: 23,
              ),
            ),
          ),
          Expanded(
            child: carregando
                ? Center(
                    child: CircularProgressIndicator(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  )
                : numeros.isEmpty
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: Text(
                        'Suas reflexões dos desafios aparecerão aqui.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white60,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(14, 18, 14, 24),
                    itemCount: numeros.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final numero = numeros[index];
                      final conteudoCompleto = conteudos[numero];
                      final mostraAtividadeCompleta =
                          DesafiosFeitosPage.desafiosComAtividadeSalva
                              .contains(numero);
                      final conteudo = conteudoCompleto == null
                          ? null
                          : mostraAtividadeCompleta
                              ? conteudoCompleto
                              : conteudoCompleto.somenteReflexoes();
                      final temConteudo = conteudoCompleto != null &&
                          conteudoDisponivelParaExibicao(
                            numero,
                            conteudoCompleto,
                          ) &&
                          conteudo != null &&
                          conteudo.itens.isNotEmpty;

                      return ListTile(
                        onTap: temConteudo
                            ? () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ConteudoDesafioPage(
                                      conteudo: conteudo!,
                                    ),
                                  ),
                                );
                              }
                            : null,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(
                            color: temConteudo
                                ? Theme.of(context).colorScheme.primary
                                : Colors.white.withAlpha(26),
                          ),
                        ),
                        tileColor: temConteudo
                            ? const Color(0xFF2A2527)
                            : const Color(0xFF211D1F),
                        leading: CircleAvatar(
                          backgroundColor: temConteudo
                              ? Theme.of(context).colorScheme.primary
                              : Colors.white12,
                          foregroundColor:
                              temConteudo ? Colors.black : Colors.white54,
                          child: Text('$numero'),
                        ),
                        title: Text(
                          temConteudo ? tituloDesafio(numero) : 'Dia $numero',
                          style: TextStyle(
                            color:
                                temConteudo ? Colors.white : Colors.white54,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: temConteudo
                            ? Text(
                                mostraAtividadeCompleta
                                    ? '${conteudo.itens.length} resposta(s) salva(s)'
                                    : '${conteudo.itens.length} reflexão(ões) salva(s)',
                                style:
                                    const TextStyle(color: Colors.white60),
                              )
                            : null,
                        trailing: Icon(
                          temConteudo
                              ? Icons.chevron_right_rounded
                              : Icons.visibility_outlined,
                          color: temConteudo
                              ? Theme.of(context).colorScheme.primary
                              : Colors.white38,
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class MissoesEspeciaisPage extends StatelessWidget {
  final Map<int, ConteudoDesafio> conteudos;
  static const List<int> missoesEspeciais = [7, 14, 21, 28];

  const MissoesEspeciaisPage({super.key, required this.conteudos});

  @override
  Widget build(BuildContext context) {
    final fundo = Theme.of(context).scaffoldBackgroundColor;

    return Scaffold(
      backgroundColor: fundo,
      body: Column(
        children: [
          MainTabHeader(
            title: 'Reflexões da semana',
            subtitle: 'Revisite as decisões que marcaram sua jornada',
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
                Icons.auto_awesome_rounded,
                color: Colors.white,
                size: 23,
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(14, 18, 14, 24),
              itemCount: missoesEspeciais.length,
              separatorBuilder: (_, _) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final numero = missoesEspeciais[index];
                final numeroSemana = index + 1;
                final conteudo = conteudos[numero]?.somenteReflexoes();
                final temConteudo =
                    conteudo != null && conteudo.itens.isNotEmpty;

                return ListTile(
                  onTap: temConteudo
                      ? () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  ConteudoDesafioPage(conteudo: conteudo),
                            ),
                          );
                        }
                      : null,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(
                      color: temConteudo
                          ? Theme.of(context).colorScheme.primary
                          : Colors.white.withAlpha(20),
                    ),
                  ),
                  tileColor: temConteudo
                      ? const Color(0xFF2A2527)
                      : const Color(0xFF211D1F),
                  leading: CircleAvatar(
                    backgroundColor: temConteudo
                        ? Theme.of(context).colorScheme.primary
                        : Colors.white24,
                    foregroundColor: Colors.black,
                    child: const Icon(Icons.auto_awesome_rounded),
                  ),
                  title: Text(
                    'Reflexão da semana $numeroSemana',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    temConteudo ? 'Lembrança salva' : 'Nada escrito ainda',
                    style: const TextStyle(color: Colors.white60),
                  ),
                  trailing: Icon(
                    temConteudo
                        ? Icons.chevron_right_rounded
                        : Icons.lock_outline_rounded,
                    color: temConteudo
                        ? Theme.of(context).colorScheme.primary
                        : Colors.white38,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ConteudoDesafioPage extends StatelessWidget {
  final ConteudoDesafio conteudo;

  const ConteudoDesafioPage({super.key, required this.conteudo});

  @override
  Widget build(BuildContext context) {
    if (conteudo.desafio == 2) {
      return ConteudoDesafio2Page(conteudo: conteudo);
    }

    final fundo = Theme.of(context).scaffoldBackgroundColor;

    return Scaffold(
      backgroundColor: fundo,
      body: Column(
        children: [
          MainTabHeader(
            title: 'Dia ${conteudo.desafio}',
            subtitle: temaDesafio(conteudo.desafio),
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
                Icons.bookmark_added_rounded,
                color: Colors.white,
                size: 23,
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 18, 16, 26),
              itemCount: conteudo.itens.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final item = conteudo.itens[index];

                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2A2527),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withAlpha(120),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.titulo,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        item.texto,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          height: 1.35,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Row(
                        children: [
                          Icon(
                            Icons.lock_rounded,
                            color: Colors.white38,
                            size: 15,
                          ),
                          SizedBox(width: 6),
                          Text(
                            'Lembrança salva',
                            style: TextStyle(
                              color: Colors.white38,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ConteudoDesafio2Page extends StatelessWidget {
  final ConteudoDesafio conteudo;

  const ConteudoDesafio2Page({super.key, required this.conteudo});

  List<String> get areasPredio => const [
    'Futuro',
    'Espiritual',
    'Emocional',
    'Solidariedade',
    'Intelectual',
    'Profissional',
    'Social',
    'Saude',
    'Familiar',
    'Relacional',
  ];

  @override
  Widget build(BuildContext context) {
    final fundo = Theme.of(context).scaffoldBackgroundColor;
    final textos = {for (final item in conteudo.itens) item.titulo: item.texto};

    return Scaffold(
      backgroundColor: fundo,
      body: Column(
        children: [
          MainTabHeader(
            title: 'Dia 2',
            subtitle: temaDesafio(2),
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
                Icons.apartment_rounded,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 18, 16, 22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Prédio da vida',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Toque em uma janela para rever a lembrança salva.',
                    style: TextStyle(color: Colors.white60, fontSize: 14),
                  ),
                  const SizedBox(height: 14),
                  Expanded(
                    child: Center(
                      child: _PredioConteudo(
                        areas: areasPredio,
                        textos: textos,
                        onJanelaTap: (area) {
                          _abrirLeitura(
                            context,
                            area,
                            textos[area] ?? '',
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _abrirLeitura(BuildContext context, String titulo, String texto) {
    showDialog<void>(
      context: context,
      barrierColor: Colors.black.withAlpha(130),
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 18),
          child: Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xFF2A2527),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Theme.of(context).colorScheme.primary, width: 2),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        titulo,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      tooltip: 'Fechar',
                      style: IconButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Colors.black,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                      icon: Icon(Icons.close_rounded),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  constraints: const BoxConstraints(maxHeight: 330),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFF171315),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: SingleChildScrollView(
                    child: Text(
                      texto.trim().isEmpty
                          ? 'Nenhuma lembrança foi escrita nessa janela.'
                          : texto,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        height: 1.35,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const Row(
                  children: [
                    Icon(Icons.lock_rounded, color: Colors.white38, size: 15),
                    SizedBox(width: 6),
                    Text(
                      'Somente leitura',
                      style: TextStyle(color: Colors.white38, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _PredioConteudo extends StatelessWidget {
  final List<String> areas;
  final Map<String, String> textos;
  final ValueChanged<String> onJanelaTap;

  const _PredioConteudo({
    required this.areas,
    required this.textos,
    required this.onJanelaTap,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 0.74,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final largura = constraints.maxWidth;
          final altura = constraints.maxHeight;
          final predioLargura = largura * 0.50;
          final predioEsquerda = (largura - predioLargura) / 2;
          final andarAltura = altura * 0.16;
          final topo = altura * 0.07;
          final janela = largura * 0.145;
          final espacamentoJanela = largura * 0.055;
          final corpoAltura = andarAltura * 5 + altura * 0.16;

          return Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF3C4),
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
              ),
              Positioned(
                left: predioEsquerda,
                top: topo + altura * 0.02,
                width: predioLargura,
                height: corpoAltura,
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xFF263238),
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(18),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: predioEsquerda + predioLargura * 0.10,
                top: topo - altura * 0.02,
                width: predioLargura * 0.80,
                height: altura * 0.055,
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xFF263238),
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(12),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: predioEsquerda + predioLargura * 0.33,
                bottom: 0,
                width: predioLargura * 0.34,
                height: altura * 0.18,
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF6D4C41),
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.primary,
                      width: 2,
                    ),
                  ),
                  child: Align(
                    alignment: const Alignment(0.55, -0.10),
                    child: Container(
                      width: 7,
                      height: 7,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: largura * 0.02,
                right: largura * 0.02,
                bottom: 0,
                height: 3,
                child: Container(color: const Color(0xFF263238)),
              ),
              for (int andar = 0; andar < 5; andar++) ...[
                _AreaConteudoLabel(
                  text: areas[andar * 2],
                  left: 0,
                  top: topo + andar * andarAltura + janela * 0.22,
                  alignRight: true,
                  width: predioEsquerda - 10,
                ),
                _AreaConteudoLabel(
                  text: areas[andar * 2 + 1],
                  left: predioEsquerda + predioLargura + 10,
                  top: topo + andar * andarAltura + janela * 0.22,
                  alignRight: false,
                  width: predioEsquerda - 10,
                ),
                for (int coluna = 0; coluna < 2; coluna++)
                  Positioned(
                    left:
                        predioEsquerda +
                        (predioLargura - (janela * 2 + espacamentoJanela)) / 2 +
                        coluna * (janela + espacamentoJanela),
                    top: topo + andar * andarAltura,
                    width: janela,
                    height: janela,
                    child: _JanelaConteudo(
                      preenchida:
                          (textos[areas[andar * 2 + coluna]] ?? '').isNotEmpty,
                      onTap: () => onJanelaTap(areas[andar * 2 + coluna]),
                    ),
                  ),
              ],
            ],
          );
        },
      ),
    );
  }
}

class _AreaConteudoLabel extends StatelessWidget {
  final String text;
  final double left;
  final double top;
  final double width;
  final bool alignRight;

  const _AreaConteudoLabel({
    required this.text,
    required this.left,
    required this.top,
    required this.width,
    required this.alignRight,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: left,
      top: top,
      width: width,
      child: Text(
        text.toUpperCase(),
        textAlign: alignRight ? TextAlign.right : TextAlign.left,
        maxLines: 2,
        softWrap: true,
        style: TextStyle(
          color: Color(0xFF263238),
          fontSize: 10,
          height: 1.05,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _JanelaConteudo extends StatelessWidget {
  final bool preenchida;
  final VoidCallback onTap;

  const _JanelaConteudo({required this.preenchida, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: preenchida ? Theme.of(context).colorScheme.secondary : Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: preenchida ? Colors.white : Colors.transparent,
            width: 3,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(55),
              blurRadius: 7,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Icon(
          preenchida ? Icons.visibility_rounded : Icons.remove_red_eye_outlined,
          color: const Color(0xFF263238),
          size: 22,
        ),
      ),
    );
  }
}
