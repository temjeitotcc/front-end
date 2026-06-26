import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../widgets/challenge_header_surface.dart';

import '../../../services/auth_service.dart';
import '../../../services/conteudos_service.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Desafio21Page extends StatefulWidget {
  const Desafio21Page({super.key});

  @override
  State<Desafio21Page> createState() => _Desafio21PageState();
}

class _Desafio21PageState extends State<Desafio21Page> {
  final TextEditingController reflexaoController = TextEditingController();
  String nomeUsuario = 'você';
  int etapaAtual = 0;

  @override
  void initState() {
    super.initState();
    _carregarNome();
  }

  @override
  void dispose() {
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
    final tema = Theme.of(context);
    final corTema = tema.colorScheme.primary;
    final textoPrincipal = tema.brightness == Brightness.dark
        ? Colors.white
        : Colors.black;
    final textoSecundario = tema.brightness == Brightness.dark
        ? Colors.white70
        : Colors.black54;
    final cardColor = tema.brightness == Brightness.dark
        ? const Color(0xFF2A2527)
        : Colors.white;

    return Scaffold(
      backgroundColor: tema.scaffoldBackgroundColor,
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
                                'Dia 21 - Reflexão Semanal',
                                style: TextStyle(
                                  color: textoPrincipal,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                _subtitulo(),
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
                      0 => _primeiraPagina(textoPrincipal, textoSecundario),
                      1 => _fechamento(textoPrincipal, textoSecundario),
                      _ => _escrita(textoPrincipal, textoSecundario),
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

  String _subtitulo() {
    return switch (etapaAtual) {
      0 => 'Fechamento da terceira semana',
      1 => 'Tudo o que você construiu',
      _ => 'Sua decisão daqui em diante',
    };
  }

  List<Widget> _primeiraPagina(Color textoPrincipal, Color textoSecundario) {
    final corTema = Theme.of(context).colorScheme.primary;
    return [
      Expanded(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _WeeklyBadge(cor: corTema),
              const SizedBox(height: 16),
              Text(
                'Oii, $nomeUsuario! Chegamos ao final de mais uma semana da nossa jornada. Uhuuuuu!',
                style: TextStyle(
                  color: textoPrincipal,
                  fontSize: 18,
                  height: 1.35,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 14),
              _Paragraph(
                text:
                    'Que tal reservar alguns minutos para refletir sobre tudo o que aprendemos nesses últimos dias?',
                color: textoSecundario,
              ),
              _Paragraph(
                text:
                    'Nesta semana, falamos sobre a importância de servir ao próximo e entendemos que cada ser humano possui talentos, habilidades e experiências que podem gerar impacto positivo na vida de outras pessoas.',
                color: textoSecundario,
              ),
              _Paragraph(
                text:
                    'Também revisitamos a atividade "Minha Empresa, Minha Vida", avaliando o quanto evoluímos, reconhecendo conquistas e fortalecendo nosso compromisso com o crescimento pessoal.',
                color: textoSecundario,
              ),
              _TopicCard(
                icon: Icons.volunteer_activism_rounded,
                title: 'Servir',
                text: 'Propósito, significado e impacto positivo.',
                cor: corTema,
              ),
              _TopicCard(
                icon: Icons.business_center_rounded,
                title: 'Minha Empresa, Minha Vida',
                text: 'Consciência sobre cada área da sua caminhada.',
                cor: corTema,
              ),
              _TopicCard(
                icon: Icons.visibility_rounded,
                title: 'Troca de Óculos',
                text: 'Uma nova perspectiva baseada em aprendizado e gratidão.',
                cor: corTema,
              ),
            ],
          ),
        ),
      ),
    ];
  }

  List<Widget> _fechamento(Color textoPrincipal, Color textoSecundario) {
    final corTema = Theme.of(context).colorScheme.primary;
    return [
      Expanded(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(child: _StarWheel(cor: corTema)),
              const SizedBox(height: 18),
              _Paragraph(
                text:
                    'Refletimos sobre os 7 Passos da Sobrevivência e entendemos que sobreviver é diferente de viver. Assumir a responsabilidade pela própria história é essencial para construir uma vida consciente e significativa.',
                color: textoSecundario,
              ),
              _Paragraph(
                text:
                    'Também aprofundamos nossa reflexão sobre identidade, pertencimento e utilidade, reconhecendo nosso valor sem depender da aprovação dos outros.',
                color: textoSecundario,
              ),
              Text(
                'Você olhou para dentro, questionou crenças e fortaleceu sua capacidade de construir o futuro que deseja.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: textoPrincipal,
                  fontSize: 19,
                  height: 1.35,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              _ReflectionCard(
                text:
                    'Mediante tudo o que aprendeu e entendeu até agora, qual decisão você toma para a sua vida?',
                cor: corTema,
              ),
              const SizedBox(height: 14),
              Text(
                'Parabéns por mais uma semana de dedicação, coragem e crescimento. Cada escolha feita hoje está construindo o seu amanhã.',
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

  List<Widget> _escrita(Color textoPrincipal, Color textoSecundario) {
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
            Icon(Icons.auto_awesome_rounded, color: corTema, size: 30),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Escreva uma decisão sincera que una propósito, identidade, novas perspectivas e autorresponsabilidade.',
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
      Expanded(
        child: TextField(
          controller: reflexaoController,
          expands: true,
          maxLines: null,
          minLines: null,
          textAlignVertical: TextAlignVertical.top,
          style: TextStyle(color: textoPrincipal, fontSize: 16, height: 1.35),
          decoration: InputDecoration(
            hintText: 'A decisão que tomo para a minha vida é...',
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
    setState(() => etapaAtual--);
  }

  void _proximo() => setState(() => etapaAtual++);

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
    await firestore.collection('usuarios').doc(user.uid).set({
      'nome': user.displayName ?? 'Usuário',
      'email': user.email,
    }, SetOptions(merge: true));

    // 2. Salvar reflexão
    await firestore
        .collection('usuarios')
        .doc(user.uid)
        .collection('reflexoes')
        .doc('21')
        .set({
          'Resposta': resposta,
          'Nome': user.displayName ?? 'Usuário',
          'RespondidoEm': FieldValue.serverTimestamp(),
        });

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
          Icon(Icons.celebration_rounded, color: cor, size: 30),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Uma pausa para celebrar e reconhecer sua terceira semana.',
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

class _TopicCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String text;
  final Color cor;

  const _TopicCard({
    required this.icon,
    required this.title,
    required this.text,
    required this.cor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cor.withAlpha(24),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cor.withAlpha(90)),
      ),
      child: Row(
        children: [
          Icon(icon, color: cor),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(color: cor, fontWeight: FontWeight.bold),
                ),
                Text(
                  text,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                    height: 1.3,
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

class _ReflectionCard extends StatelessWidget {
  final String text;
  final Color cor;

  const _ReflectionCard({required this.text, required this.cor});

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

class _Paragraph extends StatelessWidget {
  final String text;
  final Color color;

  const _Paragraph({required this.text, required this.color});

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
