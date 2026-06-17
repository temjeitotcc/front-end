import 'package:flutter/material.dart';

import '../../../widgets/challenge_header_surface.dart';

import '../../../services/auth_service.dart';
import '../../../services/conteudos_service.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Desafio6Page extends StatefulWidget {
  const Desafio6Page({super.key});

  @override
  State<Desafio6Page> createState() => _Desafio6PageState();
}

class _Desafio6PageState extends State<Desafio6Page> {
  final TextEditingController carta1Controller = TextEditingController();
  final TextEditingController carta2Controller = TextEditingController();
  final TextEditingController carta3Controller = TextEditingController();
  final TextEditingController reflexaoController = TextEditingController();

  String nomeUsuario = 'você';
  int etapaAtual = 0;

  List<_CartaInfo> get cartas => [
    _CartaInfo(
      numero: 1,
      titulo: 'Acusação e Consequências',
      subtitulo: 'Escreva sua dor e o que ela causou.',
      orientacao:
          'Escreva para a pessoa ou pessoas que mais o magoaram. Expresse sua dor, conte o que aconteceu e descreva as consequências que essas situações tiveram em sua vida.',
      controller: carta1Controller,
      icon: Icons.mail_outline_rounded,
    ),
    _CartaInfo(
      numero: 2,
      titulo: 'Pedido de Perdão',
      subtitulo: 'Imagine essa pessoa pedindo perdão.',
      orientacao:
          'Agora escreva como se essa pessoa estivesse lhe pedindo perdão. Tente compreender sua história, suas dificuldades e os motivos que podem ter influenciado suas atitudes, sem justificar os erros cometidos.',
      controller: carta2Controller,
      icon: Icons.mark_email_read_outlined,
    ),
    _CartaInfo(
      numero: 3,
      titulo: 'Superação',
      subtitulo: 'Escreva para si mesmo.',
      orientacao:
          'Escreva para si mesmo. Perdoe-se pelos erros, limitações e escolhas do passado. Reconheça sua força, seu crescimento e tudo o que aprendeu ao longo da vida. Ao final, escreva pelo menos 3 motivos pelos quais é grato e 5 motivos pelos quais se ama.',
      controller: carta3Controller,
      icon: Icons.local_florist_outlined,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _carregarNome();
  }

  @override
  void dispose() {
    carta1Controller.dispose();
    carta2Controller.dispose();
    carta3Controller.dispose();
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
                                'Dia 6 - Exercitando a Sabedoria',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: textoPrincipal,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                _subtituloEtapa(),
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
                      0 => _conteudoInicial(textoPrincipal, textoSecundario),
                      1 => _conteudoCartas(textoPrincipal, textoSecundario),
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

  String _subtituloEtapa() {
    return switch (etapaAtual) {
      0 => 'Praticando a gratidão',
      1 => 'Escreva suas três cartas',
      _ => 'Decisão para hoje',
    };
  }

  List<Widget> _conteudoInicial(Color textoPrincipal, Color textoSecundario) {
    return [
      Expanded(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _WisdomBadge(cor: Theme.of(context).colorScheme.primary),
              const SizedBox(height: 16),
              Text(
                'Oii $nomeUsuario, estamos chegando no fim dessa semana, vamos lá?!',
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
                    'Então chegamos ao momento de praticar a gratidão. O objetivo deste exercício é ajudá-lo a reconhecer sua trajetória, valorizar suas conquistas e enxergar com mais clareza tudo o que já existe de bom dentro de você.',
                color: textoSecundario,
              ),
              _ParagraphText(
                text:
                    'Prepare um ambiente tranquilo, coloque uma música instrumental que lhe transmita paz e reserve um momento apenas para si.',
                color: textoSecundario,
              ),
              _ParagraphText(
                text:
                    'Faça este exercício com sinceridade, sem interrupções e respeitando cada etapa do processo.',
                color: textoSecundario,
              ),
              _ParagraphText(
                text:
                    'Você escreverá três cartas. Toque em cada carta na próxima página, leia a orientação e escreva com calma.',
                color: textoSecundario,
              ),
            ],
          ),
        ),
      ),
    ];
  }

  List<Widget> _conteudoCartas(Color textoPrincipal, Color textoSecundario) {
    return [
      Text(
        'Suas cartas',
        style: TextStyle(
          color: textoPrincipal,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 8),
      Text(
        'Toque em uma carta para abrir o campo de escrita.',
        style: TextStyle(color: textoSecundario, fontSize: 14, height: 1.35),
      ),
      const SizedBox(height: 16),
      Expanded(
        child: ListView.separated(
          itemCount: cartas.length,
          separatorBuilder: (_, _) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final carta = cartas[index];
            return _LetterCard(
              carta: carta,
              preenchida: carta.controller.text.trim().isNotEmpty,
              onTap: () => _abrirCarta(carta),
            );
          },
        ),
      ),
    ];
  }

  List<Widget> _conteudoReflexao(Color textoPrincipal, Color textoSecundario) {
    final corTema = Theme.of(context).colorScheme.primary;

    return [
      Text(
        'Reflexão final',
        style: TextStyle(
          color: textoPrincipal,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 10),
      Text(
        'Após concluir as três cartas, reflita sobre tudo o que aprendeu e responda:',
        style: TextStyle(color: textoSecundario, fontSize: 15, height: 1.35),
      ),
      const SizedBox(height: 10),
      Text(
        'Qual decisão você escolhe tomar para sua vida a partir de hoje?',
        style: TextStyle(
          color: corTema,
          fontSize: 18,
          height: 1.3,
          fontWeight: FontWeight.w900,
        ),
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
            hintText: 'A partir de hoje eu escolho...',
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

  Future<void> _abrirCarta(_CartaInfo carta) async {
    final textoPrincipal = Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : Colors.black;
    final textoSecundario = Theme.of(context).brightness == Brightness.dark
        ? Colors.white70
        : Colors.black54;
    final fundo = Theme.of(context).brightness == Brightness.dark
        ? const Color(0xFF2A2527)
        : const Color(0xFFFFFBF0);
    final campo = Theme.of(context).brightness == Brightness.dark
        ? const Color(0xFF171315)
        : const Color(0xFFF6F1E7);
    final corTema = Theme.of(context).colorScheme.primary;

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
              left: 14,
              right: 14,
              bottom: MediaQuery.of(context).viewInsets.bottom + 14,
            ),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.82,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: fundo,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: corTema.withAlpha(140)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: corTema,
                        foregroundColor: Colors.black,
                        child: Text('${carta.numero}'),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          carta.titulo,
                          style: TextStyle(
                            color: textoPrincipal,
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        tooltip: 'Fechar',
                        style: IconButton.styleFrom(
                          backgroundColor: corTema,
                          foregroundColor: Colors.black,
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close_rounded),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    carta.orientacao,
                    style: TextStyle(
                      color: textoSecundario,
                      fontSize: 14,
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Expanded(
                    child: TextField(
                      controller: carta.controller,
                      expands: true,
                      maxLines: null,
                      minLines: null,
                      textAlignVertical: TextAlignVertical.top,
                      style: TextStyle(
                        color: textoPrincipal,
                        fontSize: 16,
                        height: 1.35,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Escreva sua carta aqui...',
                        hintStyle: TextStyle(
                          color: textoSecundario.withAlpha(140),
                        ),
                        filled: true,
                        fillColor: campo,
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
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: corTema,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: () {
                      setState(() {});
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.check_rounded),
                    label: const Text('Guardar carta'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );

    if (mounted) setState(() {});
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
    if (etapaAtual == 1 && !_todasCartasPreenchidas()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Escreva as três cartas antes de avançar.'),
        ),
      );
      return;
    }

    setState(() {
      etapaAtual++;
    });
  }

  bool _todasCartasPreenchidas() {
    return cartas.every((carta) => carta.controller.text.trim().isNotEmpty);
  }

  Future<void> _concluir() async {
    final resposta = reflexaoController.text.trim();

    if (resposta.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Escreva sua decisão antes de concluir.')),
      );
      return;
    }

    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return;

    final firestore = FirebaseFirestore.instance;

    // 1. Salvar/atualizar dados do usuário
    await firestore.collection('Usuários').doc(user.uid).set({
      'Nome': user.displayName ?? 'Usuário',
      'Email': user.email,
    }, SetOptions(merge: true));

    // 2. Salvar respostas do desafio
    await firestore
        .collection('Usuários')
        .doc(user.uid)
        .collection('Desafios')
        .doc('Dia 06')
        .collection('Respostas')
        .doc('Respostas')
        .set({
          'Carta 1 - Acusação e Consequências': carta1Controller.text.trim(),
          'Carta 2 - Pedido de Perdão': carta2Controller.text.trim(),
          'Carta 3 - Superação': carta3Controller.text.trim(),
          'Decisão a partir de hoje': resposta,
          'Nome': user.displayName ?? 'Usuário',
          'Respondido em': FieldValue.serverTimestamp(),
        });

    // 3. Manter salvamento atual do app
    await ConteudosService().salvarConteudosDoDesafio(
      desafio: 6,
      itens: [
        ConteudoItem(
          titulo: 'Carta 1 - Acusação e Consequências',
          texto: carta1Controller.text.trim(),
        ),
        ConteudoItem(
          titulo: 'Carta 2 - Pedido de Perdão',
          texto: carta2Controller.text.trim(),
        ),
        ConteudoItem(
          titulo: 'Carta 3 - Superação',
          texto: carta3Controller.text.trim(),
        ),
        ConteudoItem(
          titulo: 'Decisão a partir de hoje',
          texto: resposta,
          reflexao: true,
        ),
      ],
    );

    if (!mounted) return;
    Navigator.of(context).pop(true);
  }
}

class _CartaInfo {
  final int numero;
  final String titulo;
  final String subtitulo;
  final String orientacao;
  final TextEditingController controller;
  final IconData icon;

  const _CartaInfo({
    required this.numero,
    required this.titulo,
    required this.subtitulo,
    required this.orientacao,
    required this.controller,
    required this.icon,
  });
}

class _LetterCard extends StatelessWidget {
  final _CartaInfo carta;
  final bool preenchida;
  final VoidCallback onTap;

  const _LetterCard({
    required this.carta,
    required this.preenchida,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final corTema = Theme.of(context).colorScheme.primary;
    final textoPrincipal = Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : Colors.black;
    final textoSecundario = Theme.of(context).brightness == Brightness.dark
        ? Colors.white70
        : Colors.black54;

    return Material(
      color: Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF171315)
          : const Color(0xFFF6F1E7),
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: preenchida ? corTema : corTema.withAlpha(95),
              width: preenchida ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 58,
                height: 70,
                decoration: BoxDecoration(
                  color: corTema.withAlpha(38),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: corTema.withAlpha(170)),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Icon(carta.icon, color: corTema, size: 30),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Text(
                        '${carta.numero}',
                        style: TextStyle(
                          color: corTema,
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Carta ${carta.numero}',
                      style: TextStyle(
                        color: corTema,
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      carta.titulo,
                      style: TextStyle(
                        color: textoPrincipal,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      carta.subtitulo,
                      style: TextStyle(
                        color: textoSecundario,
                        fontSize: 13,
                        height: 1.25,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Icon(
                preenchida
                    ? Icons.check_circle_rounded
                    : Icons.edit_note_rounded,
                color: preenchida ? corTema : textoSecundario,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WisdomBadge extends StatelessWidget {
  final Color cor;

  const _WisdomBadge({required this.cor});

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
          Icon(Icons.auto_stories_rounded, color: cor, size: 30),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Um exercício para reconhecer sua história e praticar gratidão.',
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
