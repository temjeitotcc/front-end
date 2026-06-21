import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import '../../../services/auth_service.dart';
import '../../../services/conteudos_service.dart';
import '../../../widgets/challenge_header_surface.dart';
import '../../../widgets/podcast_volume_control.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Desafio23Page extends StatefulWidget {
  const Desafio23Page({super.key});

  @override
  State<Desafio23Page> createState() => _Desafio23PageState();
}

class _Desafio23PageState extends State<Desafio23Page> {
  static const String _audioAsset = 'podcast_desafio_23.m4a';

  final AudioPlayer _audioPlayer = AudioPlayer();
  final TextEditingController reflexaoController = TextEditingController();
  final List<StreamSubscription<dynamic>> _subscriptions = [];

  String nomeUsuario = 'Usuário';
  int etapaAtual = 0;
  Duration posicao = Duration.zero;
  Duration duracao = Duration.zero;
  PlayerState estado = PlayerState.stopped;
  bool carregandoAudio = false;
  bool audioPreparado = false;

  bool get tocando => estado == PlayerState.playing;

  @override
  void initState() {
    super.initState();
    _carregarNome();
    _subscriptions.add(
      _audioPlayer.onDurationChanged.listen((valor) {
        if (mounted) setState(() => duracao = valor);
      }),
    );
    _subscriptions.add(
      _audioPlayer.onPositionChanged.listen((valor) {
        if (mounted) setState(() => posicao = valor);
      }),
    );
    _subscriptions.add(
      _audioPlayer.onPlayerStateChanged.listen((valor) {
        if (mounted) setState(() => estado = valor);
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
    final corTema = Theme.of(context).colorScheme.primary;
    final escuro = Theme.of(context).brightness == Brightness.dark;
    final textoPrincipal = escuro ? Colors.white : Colors.black;
    final textoSecundario = escuro ? Colors.white70 : Colors.black54;

    return Scaffold(
      backgroundColor: fundo,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 0),
              child: ChallengeHeaderSurface(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Dia 23',
                                style: TextStyle(
                                  color: textoSecundario,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'As 5 Linguagens do Amor',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: textoPrincipal,
                                  fontSize: 23,
                                  height: 1.08,
                                  fontWeight: FontWeight.w900,
                                ),
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
                        value: (etapaAtual + 1) / 2,
                        minHeight: 10,
                        backgroundColor: Colors.white12,
                        valueColor: AlwaysStoppedAnimation(corTema),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: IndexedStack(
                index: etapaAtual,
                children: [
                  _paginaTexto(textoPrincipal, textoSecundario, corTema),
                  _paginaPodcast(textoPrincipal, textoSecundario, corTema),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 10, 18, 18),
              child: Row(
                children: [
                  if (etapaAtual > 0) ...[
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => setState(() => etapaAtual--),
                        icon: const Icon(Icons.arrow_back_rounded),
                        label: const Text('VOLTAR'),
                      ),
                    ),
                    const SizedBox(width: 12),
                  ],
                  Expanded(
                    flex: etapaAtual == 0 ? 1 : 2,
                    child: ElevatedButton.icon(
                      onPressed: etapaAtual == 0 ? _proximo : _concluir,
                      icon: Icon(
                        etapaAtual == 0
                            ? Icons.arrow_forward_rounded
                            : Icons.check_rounded,
                      ),
                      label: Text(etapaAtual == 0 ? 'OUVIR' : 'CONCLUIR'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: corTema,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        textStyle: const TextStyle(fontWeight: FontWeight.w900),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _paginaTexto(
    Color textoPrincipal,
    Color textoSecundario,
    Color corTema,
  ) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 0, 18, 12),
      children: [
        _DestaquePodcast(cor: corTema),
        const SizedBox(height: 16),
        _TextCard(
          children: [
            Text(
              'Oii, $nomeUsuario! Que bom ter você aqui para mais um dia da sua jornada!',
              style: TextStyle(
                color: textoPrincipal,
                fontSize: 17,
                height: 1.45,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 14),
            _Paragrafo(
              texto:
                  'Hoje você vai ouvir mais um podcast sobre um tema que pode transformar a forma como você se relaciona consigo mesmo e com as pessoas ao seu redor: As 5 Linguagens do Amor.',
              cor: textoPrincipal,
            ),
            _Paragrafo(
              texto:
                  'Nem todas as pessoas se sentem amadas da mesma forma. Muitas vezes demonstramos carinho de um jeito, mas o outro recebe amor de uma maneira completamente diferente.',
              cor: textoPrincipal,
            ),
            _Paragrafo(
              texto:
                  'As 5 Linguagens do Amor nos ajudam a compreender como expressamos e recebemos amor através de diferentes formas: Palavras de Afirmação, Tempo de Qualidade, Presentes, Atos de Serviço e Toque Físico.',
              cor: textoPrincipal,
            ),
            _Paragrafo(
              texto:
                  'Compreender essas linguagens é uma oportunidade de fortalecer relacionamentos, melhorar a comunicação e demonstrar amor de maneira mais intencional e significativa.',
              cor: textoPrincipal,
            ),
            const SizedBox(height: 6),
            Text(
              'Ouça com atenção e permita-se refletir sobre como você costuma demonstrar amor e de que forma gosta de se sentir amado(a).',
              style: TextStyle(
                color: textoSecundario,
                fontSize: 15,
                height: 1.45,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _paginaPodcast(
    Color textoPrincipal,
    Color textoSecundario,
    Color corTema,
  ) {
    final maximo = duracao.inMilliseconds > 0
        ? duracao.inMilliseconds.toDouble()
        : 1.0;
    final valor = posicao.inMilliseconds.clamp(0, maximo.toInt()).toDouble();

    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 0, 18, 12),
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark
                ? const Color(0xFF2A2527)
                : Colors.white,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: corTema.withAlpha(125)),
          ),
          child: Column(
            children: [
              Container(
                width: 92,
                height: 92,
                decoration: BoxDecoration(
                  color: corTema.withAlpha(38),
                  shape: BoxShape.circle,
                  border: Border.all(color: corTema.withAlpha(120)),
                ),
                child: Icon(Icons.favorite_rounded, color: corTema, size: 42),
              ),
              const SizedBox(height: 16),
              Text(
                'Podcast: As 5 Linguagens do Amor',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: textoPrincipal,
                  fontSize: 20,
                  height: 1.2,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 18),
              Slider(
                value: valor,
                min: 0,
                max: maximo,
                activeColor: corTema,
                inactiveColor: textoSecundario.withAlpha(50),
                onChanged: duracao == Duration.zero
                    ? null
                    : (novoValor) {
                        _audioPlayer.seek(
                          Duration(milliseconds: novoValor.round()),
                        );
                      },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(_formatarDuracao(posicao)),
                  Text(
                    duracao == Duration.zero
                        ? '--:--'
                        : _formatarDuracao(duracao),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    tooltip: 'Voltar 10 segundos',
                    onPressed: () => _pular(const Duration(seconds: -10)),
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
                      onPressed: carregandoAudio ? null : _alternarAudio,
                      child: carregandoAudio
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
                    onPressed: () => _pular(const Duration(seconds: 30)),
                    icon: const Icon(Icons.forward_30_rounded),
                    color: corTema,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              PodcastVolumeControl(player: _audioPlayer),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _TextCard(
          children: [
            Text(
              'Lembre-se: conhecer a si mesmo e compreender o outro é um dos caminhos mais poderosos para construir relacionamentos saudáveis e duradouros.',
              style: TextStyle(
                color: textoPrincipal,
                fontSize: 16,
                height: 1.45,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: reflexaoController,
              minLines: 5,
              maxLines: 8,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                hintText:
                    'Como você costuma demonstrar amor e como gosta de se sentir amado(a)?',
                filled: true,
                fillColor: Theme.of(context).brightness == Brightness.dark
                    ? const Color(0xFF171315)
                    : const Color(0xFFF6F1E7),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: corTema, width: 2),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _proximo() => setState(() => etapaAtual = 1);

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
            'Não foi possível tocar o podcast. Confira o arquivo em assets/podcast_desafio_23.m4a.',
          ),
        ),
      );
    } finally {
      if (mounted) setState(() => carregandoAudio = false);
    }
  }

  Future<void> _pular(Duration deslocamento) async {
    if (duracao == Duration.zero) return;
    final destino = posicao + deslocamento;
    await _audioPlayer.seek(
      destino < Duration.zero
          ? Duration.zero
          : destino > duracao
          ? duracao
          : destino,
    );
  }

  Future<void> _concluir() async {
    final reflexao = reflexaoController.text.trim();

    if (reflexao.isEmpty) {
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

    // Salvar/atualizar usuário
    await firestore.collection('usuarios').doc(user.uid).set({
      'nome': user.displayName ?? 'Usuário',
      'email': user.email,
    }, SetOptions(merge: true));

    // Salvar no Firestore
    await firestore
        .collection('usuarios')
        .doc(user.uid)
        .collection('desafios')
        .doc('23')
        .set({
          'ReflexaoSobreLinguagensDoAmor': reflexao,
          'RespondidoEm': FieldValue.serverTimestamp(),
        });

    if (!mounted) return;
    Navigator.of(context).pop(true);
  }

  String _formatarDuracao(Duration valor) {
    final minutos = valor.inMinutes.remainder(60).toString().padLeft(2, '0');
    final segundos = valor.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutos:$segundos';
  }
}

class _DestaquePodcast extends StatelessWidget {
  final Color cor;

  const _DestaquePodcast({required this.cor});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 132,
      decoration: BoxDecoration(
        color: cor.withAlpha(28),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: cor.withAlpha(100)),
      ),
      child: Stack(
        children: [
          Positioned(
            left: 22,
            top: 25,
            child: Icon(Icons.favorite_rounded, color: cor, size: 38),
          ),
          Positioned(
            right: 22,
            bottom: 24,
            child: Icon(Icons.volunteer_activism_rounded, color: cor, size: 42),
          ),
          Center(
            child: Container(
              width: 82,
              height: 82,
              decoration: BoxDecoration(
                color: cor.withAlpha(48),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.headphones_rounded, color: cor, size: 42),
            ),
          ),
        ],
      ),
    );
  }
}

class _TextCard extends StatelessWidget {
  final List<Widget> children;

  const _TextCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFF2A2527)
            : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withAlpha(95),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
}

class _Paragrafo extends StatelessWidget {
  final String texto;
  final Color cor;

  const _Paragrafo({required this.texto, required this.cor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        texto,
        style: TextStyle(color: cor, fontSize: 15, height: 1.45),
      ),
    );
  }
}
