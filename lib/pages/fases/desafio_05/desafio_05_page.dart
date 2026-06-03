import 'package:flutter/material.dart';

import '../../../services/auth_service.dart';
import '../../../services/conteudos_service.dart';

class Desafio5Page extends StatefulWidget {
  const Desafio5Page({super.key});

  @override
  State<Desafio5Page> createState() => _Desafio5PageState();
}

class _Desafio5PageState extends State<Desafio5Page> {
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
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Dia 5 - Quem sou eu?',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: textoPrincipal,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          etapaAtual == 0 ? 'Meu pântano, meu jardim' : 'Reflexão',
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
                    icon: Icon(Icons.close_rounded),
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
                    children: etapaAtual == 0
                        ? _conteudoTexto(textoPrincipal, textoSecundario)
                        : _conteudoReflexao(textoPrincipal, textoSecundario),
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
                      icon: Icon(Icons.arrow_back_rounded),
                      label: Text('Voltar'),
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
                      onPressed: etapaAtual == 0 ? _proximo : _concluir,
                      icon: Icon(
                        etapaAtual == 0
                            ? Icons.arrow_forward_rounded
                            : Icons.check_rounded,
                      ),
                      label: Text(etapaAtual == 0 ? 'Próximo' : 'Concluir'),
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
              Text(
                'Oii $nomeUsuario, vamos para mais um dia para construir a vida que você quer!!!',
                style: TextStyle(
                  color: textoPrincipal,
                  fontSize: 18,
                  height: 1.35,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 14),
              _FocusAgreementCard(cor: Theme.of(context).colorScheme.primary),
              const SizedBox(height: 12),
              _FlowerDecoration(
                cor: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 16),
              _ParagraphText(
                text:
                    'No desafio de hoje, prometa a si mesmo dedicar atenção total a este momento de autoconhecimento. A atividade deve ser feita até o final, com cerca de 30 minutos de foco. Durante o exercício, você não deve ser interrompido e precisa estar em um ambiente calmo e silencioso, com o celular no silencioso.',
                color: textoSecundario,
              ),
              _ParagraphText(
                text:
                    'Coloque uma música instrumental relaxante para ajudar na conexão consigo mesmo e procure estar verdadeiramente concentrado e aberto ao processo.',
                color: textoSecundario,
              ),
              _ParagraphText(
                text:
                    'Respire profundamente e procure relaxar, imaginando um jardim tranquilo, cheio de flores e lembranças felizes da sua vida. Relembre momentos de alegria, conquistas e sonhos sinceros, sentindo paz e bem-estar.',
                color: textoSecundario,
              ),
              _ParagraphText(
                text:
                    'Depois, imagine um pântano escuro, representando dores, tristezas e situações difíceis que marcaram sua história. Identifique cada pedra desse lugar, dando nome aos sentimentos, mágoas e experiências que ainda machucam você.',
                color: textoSecundario,
              ),
              _ParagraphText(
                text:
                    'Em seguida, volte ao jardim e reconheça as flores, ou seja, os momentos de felicidade, superação e sentimentos positivos que fazem parte da sua vida. Observe, de forma racional e imparcial, se você tem alimentado mais seu jardim ou seu pântano.',
                color: textoSecundario,
              ),
              _ParagraphText(
                text:
                    'Pense em quais sentimentos deseja cultivar a partir de agora e em como pode evitar permanecer preso às dores do passado.',
                color: textoSecundario,
              ),
              _ParagraphText(
                text:
                    'Por fim, simbolicamente feche as portas do pântano com cadeados e sinais de alerta, escolhendo caminhar mais pelo seu jardim. Leve consigo os sentimentos bons, fortalecendo aquilo que traz paz, crescimento e sentido para sua vida.',
                color: textoSecundario,
              ),
              _ParagraphText(
                text:
                    'Pense sobre o seu pântano, aquele sentimento que não deseja mais visitar, aquelas memórias que não quer reviver. Guarde tudo isso no pântano, sem revisitar mais. E cultive o seu jardim repleto de memórias lindas, felizes e cheia de amor sempre que puder.',
                color: textoSecundario,
              ),
              _LilyPadDecoration(cor: Theme.of(context).colorScheme.primary),
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
        'Sua reflexão',
        style: TextStyle(
          color: textoPrincipal,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 10),
      Text(
        'Agora reflita sobre o que você achou do desafio de hoje. Nossos desafios dessa semana estão chegando ao fim, estamos muito orgulhosos do seu empenho.',
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
          style: TextStyle(
            color: textoPrincipal,
            fontSize: 16,
            height: 1.35,
          ),
          decoration: InputDecoration(
            hintText: 'O que eu percebi sobre meu pântano e meu jardim...',
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
        const SnackBar(content: Text('Escreva sua reflexão antes de concluir.')),
      );
      return;
    }

    await ConteudosService().salvarConteudosDoDesafio(
      desafio: 5,
      itens: [
        ConteudoItem(
          titulo: 'Meu pântano e meu jardim',
          texto: resposta,
        ),
      ],
    );

    if (!mounted) return;
    Navigator.of(context).pop(true);
  }
}

class _FocusAgreementCard extends StatelessWidget {
  final Color cor;

  const _FocusAgreementCard({required this.cor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cor.withAlpha(34),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: cor.withAlpha(170), width: 1.5),
      ),
      child: Row(
        children: [
          Icon(Icons.spa_rounded, color: cor, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Temos um acordo? Separe um tempo calmo, silencioso e inteiro para você.',
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

class _FlowerDecoration extends StatelessWidget {
  final Color cor;

  const _FlowerDecoration({
    required this.cor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: const Color(0xFF243D2A),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: cor.withAlpha(120)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(23),
        child: Stack(
          children: [
            Positioned.fill(
              child: ColoredBox(color: const Color(0xFF243D2A)),
            ),
            Positioned(
              left: 0,
              right: 0,
              top: 0,
              bottom: 0,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: const Color(0xFF2E5A36).withAlpha(150),
                ),
              ),
            ),
            Positioned(
              left: 18,
              top: 16,
              child: _DecorFlower(size: 32, color: cor),
            ),
            Positioned(
              left: 88,
              top: 34,
              child: _DecorFlower(size: 24, color: Theme.of(context).colorScheme.secondary),
            ),
            Positioned(
              right: 24,
              top: 18,
              child: _DecorFlower(size: 36, color: const Color(0xFFFFC7D7)),
            ),
            Positioned(
              right: 102,
              top: 10,
              child: _DecorFlower(size: 20, color: const Color(0xFFE7B9FF)),
            ),
            Positioned(
              left: 152,
              bottom: 16,
              child: _DecorFlower(size: 28, color: const Color(0xFFFFFFFF)),
            ),
            Positioned(
              left: 36,
              bottom: 14,
              child: _DecorFlower(size: 22, color: Theme.of(context).colorScheme.secondary),
            ),
          ],
        ),
      ),
    );
  }
}

class _LilyPadDecoration extends StatelessWidget {
  final Color cor;

  const _LilyPadDecoration({required this.cor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 2, bottom: 14),
      child: Container(
        height: 112,
        decoration: BoxDecoration(
          color: const Color(0xFF173735),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: cor.withAlpha(110)),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(23),
          child: Stack(
            children: [
              Positioned.fill(
                child: ColoredBox(color: const Color(0xFF0E2F35)),
              ),
              Positioned(
                left: 20,
                bottom: 12,
                child: _LilyPad(size: 54, color: const Color(0xFF8FD6B4)),
              ),
              Positioned(
                left: 116,
                bottom: 26,
                child: _LilyPad(size: 36, color: const Color(0xFF6EBFA4)),
              ),
            Positioned(
              right: 26,
                bottom: 10,
              child: _LilyPad(size: 62, color: const Color(0xFF99E0C1)),
            ),
            Positioned(
              right: 122,
                bottom: 34,
              child: _LilyPad(size: 28, color: const Color(0xFF5EA88D)),
            ),
            Positioned(
              left: 14,
                top: 28,
              right: 14,
              child: Container(
                height: 1,
                  color: Colors.white.withAlpha(24),
              ),
            ),
          ],
        ),
        ),
      ),
    );
  }
}

class _DecorFlower extends StatelessWidget {
  final double size;
  final Color color;

  const _DecorFlower({
    required this.size,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          for (final offset in const [
            Offset(0, -0.28),
            Offset(0.28, 0),
            Offset(0, 0.28),
            Offset(-0.28, 0),
          ])
            Align(
              alignment: Alignment(offset.dx * 2.2, offset.dy * 2.2),
              child: Container(
                width: size * 0.42,
                height: size * 0.42,
                decoration: BoxDecoration(
                  color: color.withAlpha(220),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          Container(
            width: size * 0.28,
            height: size * 0.28,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
    );
  }
}

class _LilyPad extends StatelessWidget {
  final double size;
  final Color color;

  const _LilyPad({
    required this.size,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size * 0.72,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: _LilyPadPainter(
                color: color,
                waterColor: const Color(0xFF0E2F35),
              ),
            ),
          ),
          Positioned(
            right: size * 0.16,
            top: size * 0.08,
            child: _TinyWaterFlower(size: size * 0.22),
          ),
        ],
      ),
    );
  }
}

class _LilyPadPainter extends CustomPainter {
  final Color color;
  final Color waterColor;

  const _LilyPadPainter({
    required this.color,
    required this.waterColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final leaf = Paint()
      ..color = color.withAlpha(215)
      ..style = PaintingStyle.fill;
    final edge = Paint()
      ..color = Colors.white.withAlpha(42)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    final water = Paint()
      ..color = waterColor
      ..style = PaintingStyle.fill;
    final vein = Paint()
      ..color = const Color(0xFF1F6B58).withAlpha(150)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..strokeCap = StrokeCap.round;

    final rect = Rect.fromLTWH(0, size.height * 0.08, size.width, size.height * 0.78);
    canvas.drawOval(rect, leaf);
    canvas.drawOval(rect, edge);

    final center = Offset(size.width * 0.52, size.height * 0.48);
    final notch = Path()
      ..moveTo(center.dx, center.dy)
      ..lineTo(size.width * 0.98, size.height * 0.20)
      ..quadraticBezierTo(
        size.width * 0.82,
        size.height * 0.42,
        size.width,
        size.height * 0.56,
      )
      ..close();
    canvas.drawPath(notch, water);

    for (final end in [
      Offset(size.width * 0.22, size.height * 0.30),
      Offset(size.width * 0.22, size.height * 0.64),
      Offset(size.width * 0.58, size.height * 0.22),
      Offset(size.width * 0.70, size.height * 0.70),
    ]) {
      canvas.drawLine(center, end, vein);
    }
  }

  @override
  bool shouldRepaint(covariant _LilyPadPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.waterColor != waterColor;
  }
}

class _TinyWaterFlower extends StatelessWidget {
  final double size;

  const _TinyWaterFlower({required this.size});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          for (final alignment in const [
            Alignment.topCenter,
            Alignment.centerRight,
            Alignment.bottomCenter,
            Alignment.centerLeft,
          ])
            Align(
              alignment: alignment,
              child: Container(
                width: size * 0.42,
                height: size * 0.42,
                decoration: BoxDecoration(
                  color: Color(0xFFFFC7D7),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          Container(
            width: size * 0.24,
            height: size * 0.24,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              shape: BoxShape.circle,
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
