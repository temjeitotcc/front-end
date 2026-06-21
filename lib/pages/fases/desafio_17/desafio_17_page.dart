import 'package:flutter/material.dart';

import '../../../widgets/challenge_header_surface.dart';

import '../../../services/auth_service.dart';
import '../../../services/conteudos_service.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Desafio17Page extends StatefulWidget {
  const Desafio17Page({super.key});

  @override
  State<Desafio17Page> createState() => _Desafio17PageState();
}

class _Desafio17PageState extends State<Desafio17Page> {
  final List<_LensPair> pares = [
    _LensPair(
      antiga: 'MEDO',
      nova: 'AVENTURA',
      perguntaAntiga: 'Lembre-se de um momento em que sentiu medo.',
      perguntaNova:
          'Hoje, olhando para essa situação, como ela pode representar coragem, crescimento ou descoberta?',
    ),
    _LensPair(
      antiga: 'INVEJA',
      nova: 'INSPIRAÇÃO',
      perguntaAntiga: 'Lembre-se de um momento em que sentiu inveja.',
      perguntaNova:
          'O que essa situação revela sobre algo que você também deseja conquistar ou desenvolver?',
    ),
    _LensPair(
      antiga: 'ÓDIO',
      nova: 'AMOR E PERDÃO',
      perguntaAntiga:
          'Lembre-se de um momento em que sentiu ódio ou ressentimento.',
      perguntaNova:
          'Como essa experiência pode se transformar em compreensão, compaixão ou perdão?',
    ),
    _LensPair(
      antiga: 'RAIVA',
      nova: 'TOLERÂNCIA',
      perguntaAntiga: 'Lembre-se de um momento em que sentiu raiva.',
      perguntaNova:
          'O que essa situação pode ensinar sobre paciência, equilíbrio emocional e tolerância?',
    ),
  ];

  String nomeUsuario = 'você';
  int etapaAtual = 0;

  @override
  void initState() {
    super.initState();
    _carregarNome();
  }

  @override
  void dispose() {
    for (final par in pares) {
      par.situacaoController.dispose();
      par.ressignificacaoController.dispose();
    }
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
                                'Dia 17 - Trocando de Óculos',
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
                      1 => _conteudoOculos(
                        titulo: 'Óculos antigos',
                        subtitulo:
                            'Toque em cada sentimento e escreva uma ocasião em que ele apareceu.',
                        positivo: false,
                        textoPrincipal: textoPrincipal,
                        textoSecundario: textoSecundario,
                      ),
                      _ => _conteudoOculos(
                        titulo: 'Óculos novos',
                        subtitulo:
                            'Agora toque em cada nova lente e dê um significado mais consciente para a história.',
                        positivo: true,
                        textoPrincipal: textoPrincipal,
                        textoSecundario: textoSecundario,
                      ),
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
      0 => 'Ressignificando experiências',
      1 => 'Medo, inveja, ódio e raiva',
      _ => 'Aventura, inspiração, amor e tolerância',
    };
  }

  List<Widget> _conteudoTexto(Color textoPrincipal, Color textoSecundario) {
    final corTema = Theme.of(context).colorScheme.primary;

    return [
      Expanded(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _GlassesBadge(cor: corTema),
              const SizedBox(height: 16),
              Text(
                'Oii $nomeUsuario, vamos com toda energia iniciar a terceira semana de desafio!!!',
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
                    'Ao longo desta jornada, aprendemos que a forma como interpretamos os acontecimentos da vida influencia diretamente nossos sentimentos, comportamentos e resultados.',
                color: textoSecundario,
              ),
              _ParagraphText(
                text:
                    'Muitas vezes, enxergamos situações através dos óculos do medo, da raiva, da inveja ou do ódio. Mas e se pudéssemos trocar essas lentes por uma nova perspectiva?',
                color: textoSecundario,
              ),
              _ParagraphText(
                text:
                    'Nesta atividade, você vai praticar a ressignificação. Pense em situações da sua vida em que esses sentimentos estiveram presentes e procure dar um novo significado a cada uma delas.',
                color: textoSecundario,
              ),
              for (final par in pares)
                _TransformCard(
                  from: par.antiga,
                  to: par.nova,
                  text: par.perguntaNova,
                ),
            ],
          ),
        ),
      ),
    ];
  }

  List<Widget> _conteudoOculos({
    required String titulo,
    required String subtitulo,
    required bool positivo,
    required Color textoPrincipal,
    required Color textoSecundario,
  }) {
    final corTema = Theme.of(context).colorScheme.primary;

    return [
      Text(
        titulo,
        style: TextStyle(
          color: textoPrincipal,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 8),
      Text(
        subtitulo,
        style: TextStyle(color: textoSecundario, fontSize: 14, height: 1.35),
      ),
      const SizedBox(height: 16),
      Expanded(
        child: Column(
          children: [
            Expanded(
              child: _GlassesCanvas(
                pares: pares,
                positivo: positivo,
                cor: corTema,
                onTap: (par) => _abrirEditor(par: par, positivo: positivo),
              ),
            ),
            const SizedBox(height: 12),
            _HintCard(
              text: positivo
                  ? 'A mesma história pode ganhar uma lente mais madura, consciente e construtiva.'
                  : 'Não precisa escrever um texto enorme. Conte uma situação real, com sinceridade e calma.',
              cor: corTema,
            ),
          ],
        ),
      ),
    ];
  }

  Future<void> _abrirEditor({
    required _LensPair par,
    required bool positivo,
  }) async {
    final controller = positivo
        ? par.ressignificacaoController
        : par.situacaoController;
    final label = positivo ? par.nova : par.antiga;
    final pergunta = positivo ? par.perguntaNova : par.perguntaAntiga;
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
              height: MediaQuery.of(context).size.height * 0.66,
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
                        child: Icon(
                          positivo
                              ? Icons.lightbulb_outline_rounded
                              : Icons.visibility_off_outlined,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          label,
                          style: TextStyle(
                            color: textoPrincipal,
                            fontSize: 20,
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
                    pergunta,
                    style: TextStyle(
                      color: textoSecundario,
                      fontSize: 14,
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Expanded(
                    child: TextField(
                      controller: controller,
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
                        hintText: positivo
                            ? 'Hoje eu consigo enxergar isso como...'
                            : 'Aconteceu quando...',
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
                    label: const Text('Guardar'),
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
    setState(() => etapaAtual--);
  }

  void _proximo() {
    if (etapaAtual == 1 && !_preenchido(positivo: false)) {
      _mostrarPendencia('Preencha todos os óculos antigos.');
      return;
    }
    setState(() => etapaAtual++);
  }

  bool _preenchido({required bool positivo}) {
    return pares.every((par) {
      final controller = positivo
          ? par.ressignificacaoController
          : par.situacaoController;
      return controller.text.trim().isNotEmpty;
    });
  }

  Future<void> _concluir() async {
    if (!_preenchido(positivo: true)) {
      _mostrarPendencia('Preencha todas as novas lentes.');
      return;
    }

    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return;

    final firestore = FirebaseFirestore.instance;

    // Salvar/atualizar dados do usuário
    await firestore.collection('usuarios').doc(user.uid).set({
      'nome': user.displayName ?? 'Usuário',
      'email': user.email,
    }, SetOptions(merge: true));

    // Salvar resultado do desafio
    // Salvar resultado do desafio
    await firestore
        .collection('usuarios')
        .doc(user.uid)
        .collection('desafios')
        .doc('17')
        .set({
          'Medo_Aventura': {
            'Situacao': pares[0].situacaoController.text.trim(),
            'NovaPerspectiva': pares[0].ressignificacaoController.text.trim(),
          },
          'Inveja_Inspiracao': {
            'Situacao': pares[1].situacaoController.text.trim(),
            'NovaPerspectiva': pares[1].ressignificacaoController.text.trim(),
          },
          'Odio_AmorPerdao': {
            'Situacao': pares[2].situacaoController.text.trim(),
            'NovaPerspectiva': pares[2].ressignificacaoController.text.trim(),
          },
          'Raiva_Tolerancia': {
            'Situacao': pares[3].situacaoController.text.trim(),
            'NovaPerspectiva': pares[3].ressignificacaoController.text.trim(),
          },
          'RespondidoEm': FieldValue.serverTimestamp(),
        });

    // Mantém seu sistema atual
    await ConteudosService().salvarConteudosDoDesafio(
      desafio: 17,
      itens: [
        for (final par in pares)
          ConteudoItem(
            titulo: '${par.antiga} -> ${par.nova}',
            texto:
                'Situação: ${par.situacaoController.text.trim()}\n\n'
                'Nova perspectiva: ${par.ressignificacaoController.text.trim()}',
            reflexao: true,
          ),
      ],
    );

    if (!mounted) return;

    Navigator.of(context).pop(true);
  }

  void _mostrarPendencia(String mensagem) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(mensagem)));
  }
}

class _LensPair {
  final String antiga;
  final String nova;
  final String perguntaAntiga;
  final String perguntaNova;
  final TextEditingController situacaoController = TextEditingController();
  final TextEditingController ressignificacaoController =
      TextEditingController();

  _LensPair({
    required this.antiga,
    required this.nova,
    required this.perguntaAntiga,
    required this.perguntaNova,
  });
}

class _GlassesCanvas extends StatelessWidget {
  final List<_LensPair> pares;
  final bool positivo;
  final Color cor;
  final ValueChanged<_LensPair> onTap;

  const _GlassesCanvas({
    required this.pares,
    required this.positivo,
    required this.cor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = constraints.maxHeight;
        final positions = [
          _ChipPosition(top: height * 0.04, left: width * 0.05),
          _ChipPosition(top: height * 0.04, right: width * 0.05),
          _ChipPosition(bottom: height * 0.05, left: width * 0.05),
          _ChipPosition(bottom: height * 0.05, right: width * 0.05),
        ];

        return Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned.fill(
              child: CustomPaint(
                painter: _GlassesPainter(cor: cor, positivo: positivo),
              ),
            ),
            for (int i = 0; i < pares.length; i++)
              _LensLabel(
                label: positivo ? pares[i].nova : pares[i].antiga,
                position: positions[i],
                filled:
                    (positivo
                            ? pares[i].ressignificacaoController
                            : pares[i].situacaoController)
                        .text
                        .trim()
                        .isNotEmpty,
                cor: cor,
                onTap: () => onTap(pares[i]),
              ),
          ],
        );
      },
    );
  }
}

class _ChipPosition {
  final double? top;
  final double? bottom;
  final double? left;
  final double? right;

  const _ChipPosition({this.top, this.bottom, this.left, this.right});
}

class _GlassesPainter extends CustomPainter {
  final Color cor;
  final bool positivo;

  const _GlassesPainter({required this.cor, required this.positivo});

  @override
  void paint(Canvas canvas, Size size) {
    final centerY = size.height * 0.50;
    final lensWidth = size.width * 0.30;
    final lensHeight = size.height * 0.24;
    final leftLens = Rect.fromCenter(
      center: Offset(size.width * 0.32, centerY),
      width: lensWidth,
      height: lensHeight,
    );
    final rightLens = Rect.fromCenter(
      center: Offset(size.width * 0.68, centerY),
      width: lensWidth,
      height: lensHeight,
    );
    final radius = Radius.circular(lensHeight * 0.28);
    final frame = Paint()
      ..color = cor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    final lensFill = Paint()
      ..color = positivo ? cor.withAlpha(42) : Colors.black.withAlpha(30)
      ..style = PaintingStyle.fill;
    final shine = Paint()
      ..color = Colors.white.withAlpha(positivo ? 70 : 35)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    canvas.drawRRect(RRect.fromRectAndRadius(leftLens, radius), lensFill);
    canvas.drawRRect(RRect.fromRectAndRadius(rightLens, radius), lensFill);
    canvas.drawRRect(RRect.fromRectAndRadius(leftLens, radius), frame);
    canvas.drawRRect(RRect.fromRectAndRadius(rightLens, radius), frame);

    final bridge = Path()
      ..moveTo(leftLens.right, centerY)
      ..quadraticBezierTo(
        size.width * 0.50,
        centerY - size.height * 0.06,
        rightLens.left,
        centerY,
      );
    canvas.drawPath(bridge, frame);

    final leftArm = Path()
      ..moveTo(leftLens.left, centerY - lensHeight * 0.12)
      ..lineTo(size.width * 0.12, centerY - lensHeight * 0.32)
      ..lineTo(size.width * 0.07, centerY + lensHeight * 0.05);
    final rightArm = Path()
      ..moveTo(rightLens.right, centerY - lensHeight * 0.12)
      ..lineTo(size.width * 0.88, centerY - lensHeight * 0.32)
      ..lineTo(size.width * 0.93, centerY + lensHeight * 0.05);
    canvas.drawPath(leftArm, frame);
    canvas.drawPath(rightArm, frame);

    canvas.drawLine(
      Offset(
        leftLens.left + lensWidth * 0.22,
        leftLens.top + lensHeight * 0.22,
      ),
      Offset(
        leftLens.left + lensWidth * 0.45,
        leftLens.top + lensHeight * 0.12,
      ),
      shine,
    );
    canvas.drawLine(
      Offset(
        rightLens.left + lensWidth * 0.22,
        rightLens.top + lensHeight * 0.22,
      ),
      Offset(
        rightLens.left + lensWidth * 0.45,
        rightLens.top + lensHeight * 0.12,
      ),
      shine,
    );
  }

  @override
  bool shouldRepaint(covariant _GlassesPainter oldDelegate) {
    return oldDelegate.cor != cor || oldDelegate.positivo != positivo;
  }
}

class _LensLabel extends StatelessWidget {
  final String label;
  final _ChipPosition position;
  final bool filled;
  final Color cor;
  final VoidCallback onTap;

  const _LensLabel({
    required this.label,
    required this.position,
    required this.filled,
    required this.cor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: position.top,
      bottom: position.bottom,
      left: position.left,
      right: position.right,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(999),
        child: InkWell(
          borderRadius: BorderRadius.circular(999),
          onTap: onTap,
          child: Container(
            width: 128,
            height: 44,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: filled ? cor : cor.withAlpha(38),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: cor, width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(35),
                  blurRadius: 9,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  filled ? Icons.check_rounded : Icons.edit_rounded,
                  color: filled ? Colors.black : cor,
                  size: 15,
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      label,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      style: TextStyle(
                        color: filled ? Colors.black : cor,
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _GlassesBadge extends StatelessWidget {
  final Color cor;

  const _GlassesBadge({required this.cor});

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
              'Trocar os óculos é aprender a olhar a mesma história com uma lente mais consciente.',
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

class _TransformCard extends StatelessWidget {
  final String from;
  final String to;
  final String text;

  const _TransformCard({
    required this.from,
    required this.to,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    final cor = Theme.of(context).colorScheme.primary;
    final textoSecundario = Theme.of(context).brightness == Brightness.dark
        ? Colors.white70
        : Colors.black54;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cor.withAlpha(24),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cor.withAlpha(90)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$from -> $to',
            style: TextStyle(
              color: cor,
              fontSize: 15,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            text,
            style: TextStyle(color: textoSecundario, fontSize: 13, height: 1.3),
          ),
        ],
      ),
    );
  }
}

class _HintCard extends StatelessWidget {
  final String text;
  final Color cor;

  const _HintCard({required this.text, required this.cor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cor.withAlpha(34),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cor.withAlpha(120)),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: cor,
          fontSize: 13,
          height: 1.3,
          fontWeight: FontWeight.bold,
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
