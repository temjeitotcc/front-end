import 'package:flutter/material.dart';

import '../../../widgets/challenge_header_surface.dart';

import '../../../services/conteudos_service.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Desafio27Page extends StatefulWidget {
  const Desafio27Page({super.key});

  @override
  State<Desafio27Page> createState() => _Desafio27PageState();
}

class _Desafio27PageState extends State<Desafio27Page> {
  final TextEditingController cartaController = TextEditingController();
  final TextEditingController decisaoController = TextEditingController();
  int etapaAtual = 0;

  @override
  void dispose() {
    cartaController.dispose();
    decisaoController.dispose();
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
                                'Dia 27 - Visão Positiva do Futuro',
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
                      0 => _conteudoTexto(textoPrincipal, textoSecundario),
                      1 => _conteudoCarta(textoPrincipal, textoSecundario),
                      _ => _conteudoDecisao(textoPrincipal, textoSecundario),
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
      0 => 'Imagine sua melhor versão',
      1 => 'Carta do futuro',
      _ => 'Decisão para construir',
    };
  }

  List<Widget> _conteudoTexto(Color textoPrincipal, Color textoSecundario) {
    return [
      Expanded(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _FutureScene(cor: Theme.of(context).colorScheme.primary),
              const SizedBox(height: 16),
              Text(
                'Agora é hora de viajar para o futuro e imaginar a vida que você deseja construir.',
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
                    'Escreva uma carta como se fosse o seu eu do futuro conversando com você no presente. Nessa carta, conte sobre as conquistas que alcançou, os desafios que superou, as pessoas que conheceu, os sonhos que realizou e a pessoa que se tornou.',
                color: textoSecundario,
              ),
              _ParagraphText(
                text:
                    'Permita-se sonhar grande. Fale sobre sua carreira, sua família, seus relacionamentos, sua saúde, sua espiritualidade e tudo aquilo que deseja viver.',
                color: textoSecundario,
              ),
              _ParagraphText(
                text:
                    'Escreva com detalhes e emoção, como se tudo já tivesse acontecido.',
                color: textoSecundario,
              ),
              _ParagraphText(
                text:
                    'Imagine que seu eu do futuro está enviando uma mensagem de incentivo, mostrando que todo esforço valeu a pena e que continuar caminhando fez a diferença.',
                color: textoSecundario,
              ),
              _ParagraphText(
                text:
                    'Deixe sua imaginação guiar a escrita e permita-se visualizar a melhor versão de si mesmo.',
                color: textoSecundario,
              ),
            ],
          ),
        ),
      ),
    ];
  }

  List<Widget> _conteudoCarta(Color textoPrincipal, Color textoSecundario) {
    final corTema = Theme.of(context).colorScheme.primary;

    return [
      Text(
        'Carta do seu eu do futuro',
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
        child: Text(
          '"Olá! Estou escrevendo diretamente do seu futuro para te contar uma coisa: valeu a pena não desistir..."',
          style: TextStyle(
            color: corTema,
            fontSize: 15,
            height: 1.35,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      const SizedBox(height: 14),
      Expanded(
        child: TextField(
          controller: cartaController,
          expands: true,
          maxLines: null,
          minLines: null,
          textAlignVertical: TextAlignVertical.top,
          style: TextStyle(color: textoPrincipal, fontSize: 16, height: 1.35),
          decoration: InputDecoration(
            hintText:
                'Olá! Estou escrevendo diretamente do seu futuro para te contar...',
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

  List<Widget> _conteudoDecisao(Color textoPrincipal, Color textoSecundario) {
    final corTema = Theme.of(context).colorScheme.primary;

    return [
      Text(
        'Sua decisão',
        style: TextStyle(
          color: textoPrincipal,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 10),
      Text(
        'Ao finalizar a carta, reflita: após tudo o que aprendeu e entendeu, qual decisão você toma para construir o futuro que deseja viver?',
        style: TextStyle(
          color: corTema,
          fontSize: 17,
          height: 1.35,
          fontWeight: FontWeight.w900,
        ),
      ),
      const SizedBox(height: 14),
      Expanded(
        child: TextField(
          controller: decisaoController,
          expands: true,
          maxLines: null,
          minLines: null,
          textAlignVertical: TextAlignVertical.top,
          style: TextStyle(color: textoPrincipal, fontSize: 16, height: 1.35),
          decoration: InputDecoration(
            hintText: 'Para construir esse futuro, eu escolho...',
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

  void _proximo() {
    if (etapaAtual == 1 && cartaController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Escreva sua carta antes de avançar.')),
      );
      return;
    }
    setState(() => etapaAtual++);
  }

  Future<void> _concluir() async {
    final decisao = decisaoController.text.trim();

    if (decisao.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Escreva sua decisão antes de concluir.')),
      );
      return;
    }

    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return;

    final firestore = FirebaseFirestore.instance;

    // Salvar/atualizar usuário
    await firestore.collection('Usuários').doc(user.uid).set({
      'Nome': user.displayName ?? 'Usuário',
      'Email': user.email,
    }, SetOptions(merge: true));

    // Salvar desafio
    await firestore
        .collection('Usuários')
        .doc(user.uid)
        .collection('Desafios')
        .doc('Dia 27')
        .set({
          'CartaDoFuturo': cartaController.text.trim(),
          'DecisaoParaConstruirOFuturo': decisao,
          'RespondidoEm': FieldValue.serverTimestamp(),
        });

    // Mantém seu sistema atual
    await ConteudosService().salvarConteudosDoDesafio(
      desafio: 27,
      itens: [
        ConteudoItem(
          titulo: 'Carta do futuro',
          texto: cartaController.text.trim(),
          reflexao: true,
        ),
        ConteudoItem(
          titulo: 'Decisão para construir o futuro',
          texto: decisao,
          reflexao: true,
        ),
      ],
    );

    if (!mounted) return;

    Navigator.of(context).pop(true);
  }
}

class _FutureScene extends StatelessWidget {
  final Color cor;

  const _FutureScene({required this.cor});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 190,
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFF171315)
            : const Color(0xFFF6F1E7),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: cor.withAlpha(120)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(23),
        child: Stack(
          children: [
            Positioned.fill(
              child: CustomPaint(painter: _FuturePathPainter(cor: cor)),
            ),
            Positioned(
              left: 26,
              bottom: 18,
              child: _PersonFigure(size: 54, cor: cor, label: 'hoje'),
            ),
            Positioned(
              right: 24,
              bottom: 18,
              child: _PersonFigure(size: 82, cor: cor, label: 'futuro'),
            ),
            Positioned(
              top: 18,
              left: 18,
              child: Icon(Icons.star_rounded, color: cor, size: 22),
            ),
            Positioned(
              top: 28,
              right: 78,
              child: Icon(Icons.auto_awesome_rounded, color: cor, size: 18),
            ),
            Positioned(
              top: 18,
              right: 22,
              child: Icon(Icons.flag_rounded, color: cor, size: 28),
            ),
          ],
        ),
      ),
    );
  }
}

class _FuturePathPainter extends CustomPainter {
  final Color cor;

  const _FuturePathPainter({required this.cor});

  @override
  void paint(Canvas canvas, Size size) {
    final ground = Paint()
      ..color = cor.withAlpha(70)
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
      Offset(size.width * 0.10, size.height * 0.84),
      Offset(size.width * 0.90, size.height * 0.84),
      ground,
    );

    final path = Path()
      ..moveTo(size.width * 0.25, size.height * 0.66)
      ..quadraticBezierTo(
        size.width * 0.48,
        size.height * 0.30,
        size.width * 0.74,
        size.height * 0.56,
      );

    final paint = Paint()
      ..color = cor.withAlpha(120)
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(path, paint);

    final dotPaint = Paint()
      ..color = cor.withAlpha(170)
      ..style = PaintingStyle.fill;

    for (final point in [
      Offset(size.width * 0.36, size.height * 0.50),
      Offset(size.width * 0.50, size.height * 0.42),
      Offset(size.width * 0.64, size.height * 0.48),
    ]) {
      canvas.drawCircle(point, 4, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _FuturePathPainter oldDelegate) {
    return oldDelegate.cor != cor;
  }
}

class _PersonFigure extends StatelessWidget {
  final double size;
  final Color cor;
  final String label;

  const _PersonFigure({
    required this.size,
    required this.cor,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size * 0.72,
      height: size + 28,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Positioned(
            top: 0,
            child: Container(
              width: size * 0.32,
              height: size * 0.32,
              decoration: BoxDecoration(color: cor, shape: BoxShape.circle),
            ),
          ),
          Positioned(
            top: size * 0.36,
            child: Container(
              width: size * 0.44,
              height: size * 0.48,
              decoration: BoxDecoration(
                color: cor.withAlpha(210),
                borderRadius: BorderRadius.circular(size * 0.16),
              ),
            ),
          ),
          Positioned(
            top: size * 0.88,
            child: Text(
              label,
              style: TextStyle(
                color: cor,
                fontSize: 11,
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
