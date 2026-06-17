import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../widgets/challenge_header_surface.dart';

import '../../../services/auth_service.dart';
import '../../../services/conteudos_service.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Desafio7Page extends StatefulWidget {
  const Desafio7Page({super.key});

  @override
  State<Desafio7Page> createState() => _Desafio7PageState();
}

class _Desafio7PageState extends State<Desafio7Page> {
  final TextEditingController reflexaoController = TextEditingController();
  String nomeUsuario = 'você';
  int etapaAtual = 0;

  @override
  void initState() {
    super.initState();
    _carregarNome();
  }

  Future<void> _carregarNome() async {
    final nome = await AuthService.nomeUsuarioAtual();
    if (!mounted) return;

    setState(() {
      nomeUsuario = nome;
    });
  }

  @override
  void dispose() {
    reflexaoController.dispose();
    super.dispose();
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
                                'Dia 7 - Reflexão Semanal',
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
                      0 => _conteudoPrimeiraPagina(
                        textoPrincipal,
                        textoSecundario,
                      ),
                      1 => _conteudoFinal(textoPrincipal, textoSecundario),
                      _ => _conteudoEscrita(textoPrincipal, textoSecundario),
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
      0 => 'Fechamento da primeira semana',
      1 => 'Sua escolha daqui em diante',
      _ => 'Escreva sua reflexão',
    };
  }

  List<Widget> _conteudoPrimeiraPagina(
    Color textoPrincipal,
    Color textoSecundario,
  ) {
    return [
      Expanded(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _WeeklyBadge(cor: Theme.of(context).colorScheme.primary),
              const SizedBox(height: 16),
              Text(
                'Oii, $nomeUsuario! Chegamos ao final da nossa primeira semana. Uhuuuuu!',
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
                    'Que jornada incrível até aqui! Que tal reservar alguns minutos para refletir sobre tudo o que aprendemos?',
                color: textoSecundario,
              ),
              _ParagraphText(
                text:
                    'Nesta semana, olhamos para as diferentes áreas da nossa vida e identificamos onde estamos e onde queremos chegar. Refletimos sobre nossas escolhas, decisões e a responsabilidade que temos sobre o rumo da nossa história.',
                color: textoSecundario,
              ),
              _ParagraphText(
                text:
                    'Também aprendemos sobre o pântano e o jardim. Entendemos que todos nós fazemos escolhas diariamente: alimentar pensamentos, hábitos e comportamentos que nos mantêm presos no pântano, ou cultivar atitudes que fazem florescer o nosso jardim.',
                color: textoSecundario,
              ),
              _ParagraphText(
                text:
                    'Falamos sobre o coraferidovírus, compreendendo como feridas emocionais podem influenciar nossas ações e relacionamentos.',
                color: textoSecundario,
              ),
              _ParagraphText(
                text:
                    'E descobrimos que o autoconhecimento, a inteligência emocional e o perdão são ferramentas fundamentais para interromper ciclos de dor e construir uma vida mais saudável.',
                color: textoSecundario,
              ),
              _ParagraphText(
                text:
                    'Além disso, trabalhamos o perdão em sua essência: perdoar quem nos feriu, perdoar a nós mesmos e seguir em frente mais leves, conscientes e preparados para crescer.',
                color: textoSecundario,
              ),
            ],
          ),
        ),
      ),
    ];
  }

  List<Widget> _conteudoFinal(Color textoPrincipal, Color textoSecundario) {
    final corTema = Theme.of(context).colorScheme.primary;

    return [
      Expanded(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(child: _StarWheel(cor: corTema)),
              const SizedBox(height: 18),
              Text(
                'Agora é hora de olhar para tudo o que viveu nesta primeira semana.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: textoPrincipal,
                  fontSize: 20,
                  height: 1.3,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              _FinalReflectionCard(
                text:
                    'Você vai continuar alimentando o pântano ou escolher cultivar o seu jardim?',
                cor: corTema,
              ),
              const SizedBox(height: 12),
              _FinalReflectionCard(
                text:
                    'Mediante tudo o que aprendeu e entendeu até agora, qual decisão você toma para a sua vida?',
                cor: corTema,
              ),
              const SizedBox(height: 16),
              Text(
                'Respire, acolha sua caminhada e leve essa escolha com você.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: textoSecundario,
                  fontSize: 15,
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
      ),
    ];
  }

  List<Widget> _conteudoEscrita(Color textoPrincipal, Color textoSecundario) {
    final corTema = Theme.of(context).colorScheme.primary;

    return [
      Text(
        'Sua reflexão semanal',
        style: TextStyle(
          color: textoPrincipal,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 10),
      Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: corTema.withAlpha(34),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: corTema.withAlpha(150)),
        ),
        child: Row(
          children: [
            Icon(Icons.emoji_events_rounded, color: corTema, size: 30),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Você atravessou a primeira semana. Agora escreva com carinho o que escolhe levar daqui para frente.',
                style: TextStyle(
                  color: corTema,
                  fontSize: 15,
                  height: 1.3,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 14),
      Text(
        'Coloque em palavras a decisão que nasceu dessa semana. Não precisa ser perfeita, só precisa ser verdadeira.',
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
            hintText: 'Minha decisão para a próxima fase da minha vida...',
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
        .collection('Reflexões')
        .doc('Dia 07')
        .collection('Respostas')
        .doc('Respostas')
        .set({
          'Resposta': resposta,
          'Nome': user.displayName ?? 'Usuário',
          'Respondido em': FieldValue.serverTimestamp(),
        });

    await ConteudosService().salvarConteudosDoDesafio(
      desafio: 7,
      itens: [
        ConteudoItem(
          titulo: 'Reflexão da semana 1',
          texto: resposta,
          reflexao: true,
        ),
      ],
    );

    if (!mounted) return;
    Navigator.of(context).pop(true);
  }
}

class _WeeklyBadge extends StatelessWidget {
  final Color cor;

  const _WeeklyBadge({required this.cor});

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
          Icon(Icons.auto_awesome_rounded, color: cor, size: 30),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Uma pausa para reconhecer sua primeira semana.',
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

class _StarWheel extends StatelessWidget {
  final Color cor;

  const _StarWheel({required this.cor});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 154,
      height: 154,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 112,
            height: 112,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: cor.withAlpha(32),
              border: Border.all(color: cor.withAlpha(120), width: 2),
            ),
          ),
          for (int i = 0; i < 12; i++)
            Transform.rotate(
              angle: (math.pi * 2 / 12) * i,
              child: Align(
                alignment: const Alignment(0, -1),
                child: Icon(
                  i.isEven ? Icons.star_rounded : Icons.auto_awesome_rounded,
                  color: i.isEven ? cor : cor.withAlpha(170),
                  size: i.isEven ? 20 : 16,
                ),
              ),
            ),
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: cor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: cor.withAlpha(70),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: const Icon(
              Icons.favorite_rounded,
              color: Colors.black,
              size: 34,
            ),
          ),
        ],
      ),
    );
  }
}

class _FinalReflectionCard extends StatelessWidget {
  final String text;
  final Color cor;

  const _FinalReflectionCard({required this.text, required this.cor});

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
        text,
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
