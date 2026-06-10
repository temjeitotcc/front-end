import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../services/auth_service.dart';
import '../../../services/conteudos_service.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Desafio28Page extends StatefulWidget {
  const Desafio28Page({super.key});

  @override
  State<Desafio28Page> createState() => _Desafio28PageState();
}

class _Desafio28PageState extends State<Desafio28Page> {
  final TextEditingController aprendizadosController = TextEditingController();
  final TextEditingController marcouController = TextEditingController();
  final TextEditingController mudancaController = TextEditingController();

  String nomeUsuario = 'você';
  int etapaAtual = 0;

  @override
  void initState() {
    super.initState();
    _carregarNome();
  }

  @override
  void dispose() {
    aprendizadosController.dispose();
    marcouController.dispose();
    mudancaController.dispose();
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
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Dia 28 - Encerramento',
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
                  value: (etapaAtual + 1) / 4,
                  minHeight: 10,
                  backgroundColor: Colors.white12,
                  valueColor: AlwaysStoppedAnimation(corTema),
                ),
              ),
              const SizedBox(height: 22),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: corTema.withAlpha(135)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: switch (etapaAtual) {
                      0 => _conteudoAbertura(textoPrincipal, textoSecundario),
                      1 => _conteudoRetrospectiva(
                        textoPrincipal,
                        textoSecundario,
                      ),
                      2 => _conteudoReflexao(textoPrincipal, textoSecundario),
                      _ => _conteudoCelebracao(textoPrincipal, textoSecundario),
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
                      onPressed: etapaAtual < 3 ? _proximo : _concluir,
                      icon: Icon(
                        etapaAtual < 3
                            ? Icons.arrow_forward_rounded
                            : Icons.check_rounded,
                      ),
                      label: Text(etapaAtual < 3 ? 'Próximo' : 'Finalizar'),
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
      0 => 'Último desafio da jornada',
      1 => 'Tudo que você viveu',
      2 => 'Sua reflexão final',
      _ => 'Tem jeito e vale a pena',
    };
  }

  List<Widget> _conteudoAbertura(Color textoPrincipal, Color textoSecundario) {
    return [
      Expanded(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _CelebrationScene(cor: Theme.of(context).colorScheme.primary),
              const SizedBox(height: 16),
              Text(
                'Oii, $nomeUsuario! Hoje chegamos ao último desafio da nossa jornada.',
                style: TextStyle(
                  color: textoPrincipal,
                  fontSize: 19,
                  height: 1.35,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 14),
              _ParagraphText(
                text:
                    'Antes de nos despedirmos, que tal relembrar tudo o que vivemos e aprendemos ao longo desses dias?',
                color: textoSecundario,
              ),
              _HighlightCard(
                icon: Icons.flag_rounded,
                title: 'Você chegou até aqui',
                text:
                    'Cada reflexão, atividade e escolha fez parte de um processo de autoconhecimento, coragem e crescimento.',
                cor: Theme.of(context).colorScheme.primary,
              ),
            ],
          ),
        ),
      ),
    ];
  }

  List<Widget> _conteudoRetrospectiva(
    Color textoPrincipal,
    Color textoSecundario,
  ) {
    final corTema = Theme.of(context).colorScheme.primary;
    return [
      Expanded(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Retrospectiva da jornada',
                style: TextStyle(
                  color: textoPrincipal,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 14),
              _JourneyItem(
                icon: Icons.account_tree_rounded,
                title: 'Áreas da vida',
                text:
                    'Você refletiu sobre escolhas, decisões e a responsabilidade pelo rumo da sua história.',
                cor: corTema,
              ),
              _JourneyItem(
                icon: Icons.spa_rounded,
                title: 'Pântano e jardim',
                text:
                    'Você percebeu que todos os dias escolhe quais pensamentos, sentimentos e comportamentos cultivar.',
                cor: corTema,
              ),
              _JourneyItem(
                icon: Icons.healing_rounded,
                title: 'Coraferidovírus e Benzetacil',
                text:
                    'Você entendeu que feridas emocionais impactam relações, e que o autoconhecimento cura mesmo quando desconforta.',
                cor: corTema,
              ),
              _JourneyItem(
                icon: Icons.favorite_border_rounded,
                title: 'Perdão e inteligência emocional',
                text:
                    'Você trabalhou gratidão, perdão, propósito, autorresponsabilidade e a coragem de mudar.',
                cor: corTema,
              ),
              _JourneyItem(
                icon: Icons.visibility_rounded,
                title: 'Novas lentes e futuro',
                text:
                    'Você aprendeu a trocar os óculos, construir um Mural dos Sonhos e visualizar um futuro com planejamento e ação.',
                cor: corTema,
              ),
              const SizedBox(height: 6),
              Text(
                'Sonhos se tornam metas quando são acompanhados de planejamento e ação.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: textoSecundario,
                  fontSize: 15,
                  height: 1.35,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    ];
  }

  List<Widget> _conteudoReflexao(Color textoPrincipal, Color textoSecundario) {
    return [
      Text(
        'Agora queremos saber',
        style: TextStyle(
          color: textoPrincipal,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 10),
      Expanded(
        child: ListView(
          children: [
            _ReflectionField(
              controller: aprendizadosController,
              label: 'Principais aprendizados',
              question:
                  'Quais foram os principais aprendizados que você leva desta experiência?',
            ),
            const SizedBox(height: 12),
            _ReflectionField(
              controller: marcouController,
              label: 'O que marcou você',
              question: 'O que mais marcou você durante essa jornada?',
            ),
            const SizedBox(height: 12),
            _ReflectionField(
              controller: mudancaController,
              label: 'Mudança para continuar',
              question:
                  'Qual mudança pretende continuar aplicando na sua vida daqui para frente?',
            ),
          ],
        ),
      ),
    ];
  }

  List<Widget> _conteudoCelebracao(
    Color textoPrincipal,
    Color textoSecundario,
  ) {
    final corTema = Theme.of(context).colorScheme.primary;
    return [
      Expanded(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(child: _StarWheel(cor: corTema)),
              const SizedBox(height: 16),
              _FinalMessageCard(
                text:
                    'Agradecemos pela sua confiança e por permitir que fizéssemos parte deste processo.',
                cor: corTema,
              ),
              const SizedBox(height: 12),
              _ParagraphText(
                text:
                    'Esperamos que cada reflexão, atividade e desafio tenha contribuído para o seu crescimento. Continue acompanhando nosso projeto pelas plataformas digitais e mantenha viva a busca pelo seu desenvolvimento.',
                color: textoSecundario,
                align: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                'Parabéns pela sua perseverança, dedicação e coragem de chegar até aqui!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: textoPrincipal,
                  fontSize: 18,
                  height: 1.35,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: corTema,
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [
                    BoxShadow(
                      color: corTema.withAlpha(70),
                      blurRadius: 18,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Text(
                  'TEM JEITO E VALE A PENA.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    height: 1.2,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                'Nos vemos na próxima jornada!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: corTema,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
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

  void _proximo() {
    if (etapaAtual == 2 && !_reflexoesPreenchidas()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Responda as três reflexões antes de avançar.'),
        ),
      );
      return;
    }
    setState(() => etapaAtual++);
  }

  bool _reflexoesPreenchidas() {
    return aprendizadosController.text.trim().isNotEmpty &&
        marcouController.text.trim().isNotEmpty &&
        mudancaController.text.trim().isNotEmpty;
  }

  Future<void> _concluir() async {
    final user = FirebaseAuth.instance.currentUser;

    final aprendizados = aprendizadosController.text.trim();
    final marcou = marcouController.text.trim();
    final mudanca = mudancaController.text.trim();

    if (user == null) return;

    // TODOS obrigatórios
    if (aprendizados.isEmpty || marcou.isEmpty || mudanca.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Preencha todos os campos antes de concluir.'),
        ),
      );
      return;
    }

    final firestore = FirebaseFirestore.instance;
    // 1. Salvar/atualizar dados do usuário
    await firestore.collection('Usuários').doc(user.email).set({
      'Nome': user.displayName ?? 'Usuários',
      'ID': user.uid,
    }, SetOptions(merge: true));

    // 2. Salvar reflexão
    await firestore
        .collection('Usuários')
        .doc(user.email)
        .collection('Desafios')
        .doc('Dia 28')
        .collection('Respostas')
        .add({
          'Principais Aprendizados': aprendizados,
          'O que marcou': marcou,
          'Mudanca para Continuar': mudanca,
          'nome': user.displayName ?? 'Usuário',
          'Respondido em': FieldValue.serverTimestamp(),
        });

    if (!mounted) return;
    Navigator.of(context).pop(true);
  }
}

class _CelebrationScene extends StatelessWidget {
  final Color cor;

  const _CelebrationScene({required this.cor});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 190,
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFF171315)
            : const Color(0xFFF6F1E7),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: cor.withAlpha(125)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(23),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned.fill(
              child: CustomPaint(painter: _CelebrationPainter(cor: cor)),
            ),
            Container(
              width: 94,
              height: 94,
              decoration: BoxDecoration(
                color: cor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: cor.withAlpha(70),
                    blurRadius: 22,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: const Icon(
                Icons.emoji_events_rounded,
                color: Colors.black,
                size: 50,
              ),
            ),
            Positioned(
              bottom: 16,
              left: 18,
              right: 18,
              child: Text(
                '28 dias de coragem, reflexão e escolha',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: cor,
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CelebrationPainter extends CustomPainter {
  final Color cor;

  const _CelebrationPainter({required this.cor});

  @override
  void paint(Canvas canvas, Size size) {
    final ring = Paint()
      ..color = cor.withAlpha(55)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawCircle(size.center(Offset.zero), 70, ring);
    canvas.drawCircle(size.center(Offset.zero), 48, ring);

    final dot = Paint()
      ..color = cor.withAlpha(165)
      ..style = PaintingStyle.fill;
    for (int i = 0; i < 18; i++) {
      final angle = (math.pi * 2 / 18) * i;
      final radius = i.isEven ? 78.0 : 58.0;
      final point = Offset(
        size.width / 2 + math.cos(angle) * radius,
        size.height / 2 + math.sin(angle) * radius,
      );
      canvas.drawCircle(point, i.isEven ? 3.5 : 2.5, dot);
    }
  }

  @override
  bool shouldRepaint(covariant _CelebrationPainter oldDelegate) {
    return oldDelegate.cor != cor;
  }
}

class _HighlightCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String text;
  final Color cor;

  const _HighlightCard({
    required this.icon,
    required this.title,
    required this.text,
    required this.cor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cor.withAlpha(34),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: cor.withAlpha(150)),
      ),
      child: Row(
        children: [
          Icon(icon, color: cor, size: 30),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: cor,
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  text,
                  style: TextStyle(color: cor, fontSize: 13, height: 1.3),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _JourneyItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String text;
  final Color cor;

  const _JourneyItem({
    required this.icon,
    required this.title,
    required this.text,
    required this.cor,
  });

  @override
  Widget build(BuildContext context) {
    final textoPrincipal = Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : Colors.black;
    final textoSecundario = Theme.of(context).brightness == Brightness.dark
        ? Colors.white70
        : Colors.black54;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cor.withAlpha(24),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: cor.withAlpha(95)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: cor.withAlpha(40),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: cor, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: textoPrincipal,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  text,
                  style: TextStyle(
                    color: textoSecundario,
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

class _ReflectionField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String question;

  const _ReflectionField({
    required this.controller,
    required this.label,
    required this.question,
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

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFF171315)
            : const Color(0xFFF6F1E7),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: corTema.withAlpha(105)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            question,
            style: TextStyle(
              color: corTema,
              fontSize: 15,
              height: 1.35,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: controller,
            minLines: 4,
            maxLines: 6,
            style: TextStyle(color: textoPrincipal, fontSize: 15, height: 1.35),
            decoration: InputDecoration(
              labelText: label,
              labelStyle: TextStyle(color: corTema),
              hintText: 'Escreva aqui...',
              hintStyle: TextStyle(color: textoSecundario.withAlpha(140)),
              filled: true,
              fillColor: Theme.of(context).brightness == Brightness.dark
                  ? const Color(0xFF211D1F)
                  : Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: corTema, width: 2),
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

class _FinalMessageCard extends StatelessWidget {
  final String text;
  final Color cor;

  const _FinalMessageCard({required this.text, required this.cor});

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
          fontSize: 16,
          height: 1.35,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _ParagraphText extends StatelessWidget {
  final String text;
  final Color color;
  final TextAlign align;

  const _ParagraphText({
    required this.text,
    required this.color,
    this.align = TextAlign.start,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Text(
        text,
        textAlign: align,
        style: TextStyle(color: color, fontSize: 16, height: 1.35),
      ),
    );
  }
}
