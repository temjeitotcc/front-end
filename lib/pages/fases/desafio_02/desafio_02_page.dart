import 'package:flutter/material.dart';

import '../../../services/conteudos_service.dart';

import '../../../widgets/challenge_intro_decoration.dart';

class Desafio2Page extends StatefulWidget {
  const Desafio2Page({super.key});

  @override
  State<Desafio2Page> createState() => _Desafio2PageState();
}

class _Desafio2PageState extends State<Desafio2Page> {
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

  List<String> get imagensPredio => const [
    'assets/janelas/futuro.png',
    'assets/janelas/espiritual.png',
    'assets/janelas/emocional.png',
    'assets/janelas/solidariedade.png',
    'assets/janelas/intelectual.png',
    'assets/janelas/profissional.png',
    'assets/janelas/social.png',
    'assets/janelas/saúde.png',
    'assets/janelas/famíliar.png',
    'assets/janelas/relacional.png',
  ];

  late final List<String> respostasPredio;
  int etapaAtual = 0;

  @override
  void initState() {
    super.initState();
    respostasPredio = List<String>.filled(areasPredio.length, '');
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
                          'Dia 2 - Minha empresa, minha vida',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: textoPrincipal,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          etapaAtual == 0 ? 'Instruções' : 'Prédio da vida',
                          style: TextStyle(color: textoSecundario),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    tooltip: 'Sair',
                    style: IconButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
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
                  valueColor: AlwaysStoppedAnimation(Theme.of(context).colorScheme.primary),
                ),
              ),
              const SizedBox(height: 22),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.primary.withAlpha(110),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: etapaAtual == 0
                        ? _conteudoInstrucao(textoPrincipal, textoSecundario)
                        : _conteudoPredio(textoPrincipal, textoSecundario),
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
                        side: BorderSide(color: Theme.of(context).colorScheme.primary),
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
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: _proximo,
                      icon: Icon(
                        etapaAtual == 1
                            ? Icons.check_rounded
                            : Icons.arrow_forward_rounded,
                      ),
                      label: Text(etapaAtual == 1 ? 'Concluir' : 'Próximo'),
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

  List<Widget> _conteudoInstrucao(
    Color textoPrincipal,
    Color textoSecundario,
  ) {
    return [
      const ChallengeIntroDecoration(
        mainIcon: Icons.apartment_rounded,
        leftIcon: Icons.business_center_rounded,
        rightIcon: Icons.insights_rounded,
        title: 'Você é o CEO da sua vida',
        subtitle: 'Cada departamento merece atenção, cuidado e direção.',
      ),
      const SizedBox(height: 14),
      Text(
        'Dia 2 - Minha empresa, minha vida',
        style: TextStyle(
          color: textoPrincipal,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 14),
      Expanded(
        child: SingleChildScrollView(
          child: Text(
            'Texto introdutorio do Dia 2.\n\nNa próxima pagina você vai preencher as janelas do prédio da sua vida.',
            style: TextStyle(
              color: textoSecundario,
              fontSize: 16,
              height: 1.35,
            ),
          ),
        ),
      ),
      const SizedBox(height: 14),
      Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary.withAlpha(38),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Theme.of(context).colorScheme.primary),
        ),
        child: Text(
          'Clique em cada janela para escrever sua reflexão.',
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ];
  }

  List<Widget> _conteudoPredio(Color textoPrincipal, Color textoSecundario) {
    return [
      Text(
        'Prédio da vida',
        style: TextStyle(
          color: textoPrincipal,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 8),
      Text(
        'Toque em uma janela para preencher uma área.',
        style: TextStyle(color: textoSecundario, fontSize: 14),
      ),
      const SizedBox(height: 12),
      Expanded(
        child: Center(
          child: _PredioVida(
            areas: areasPredio,
            imagens: imagensPredio,
            respostas: respostasPredio,
            onJanelaTap: _abrirJanelaPredio,
          ),
        ),
      ),
    ];
  }

  Future<void> _abrirJanelaPredio(int index) async {
    final resposta = await showDialog<String>(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withAlpha(120),
      builder: (context) => _JanelaTextoDialog(
        titulo: areasPredio[index],
        valorInicial: respostasPredio[index],
      ),
    );

    if (resposta == null) return;

    setState(() {
      respostasPredio[index] = resposta.trim();
    });
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

  Future<void> _proximo() async {
    if (etapaAtual == 0) {
      setState(() {
        etapaAtual++;
      });
      return;
    }

    await ConteudosService().salvarConteudosDoDesafio(
      desafio: 2,
      itens: [
        for (int i = 0; i < areasPredio.length; i++)
          ConteudoItem(
            titulo: areasPredio[i],
            texto: respostasPredio[i].trim(),
          ),
      ],
    );

    if (!mounted) return;
    Navigator.of(context).pop(true);
  }
}

class _JanelaTextoDialog extends StatefulWidget {
  final String titulo;
  final String valorInicial;

  const _JanelaTextoDialog({
    required this.titulo,
    required this.valorInicial,
  });

  @override
  State<_JanelaTextoDialog> createState() => _JanelaTextoDialogState();
}

class _JanelaTextoDialogState extends State<_JanelaTextoDialog> {
  late final TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.valorInicial);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _fechar() {
    Navigator.of(context).pop();
  }

  void _salvar() {
    Navigator.of(context).pop(controller.text);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _fechar,
      child: Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 28),
        backgroundColor: Colors.transparent,
        child: GestureDetector(
          onTap: () {},
          child: Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xFF2A2527),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Theme.of(context).colorScheme.primary, width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(90),
                  blurRadius: 24,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.titulo,
                        style: TextStyle(
                          color: Colors.white,
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
                      onPressed: _fechar,
                      icon: Icon(Icons.close_rounded),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: controller,
                  autofocus: true,
                  maxLines: 7,
                  minLines: 5,
                  textInputAction: TextInputAction.newline,
                  enableInteractiveSelection: false,
                  style: TextStyle(color: Colors.white, fontSize: 16),
                  decoration: InputDecoration(
                    hintText: 'Escreva sua reflexão aqui...',
                    hintStyle: TextStyle(color: Colors.white38),
                    filled: true,
                    fillColor: const Color(0xFF171315),
                    contentPadding: const EdgeInsets.all(16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.primary,
                        width: 2,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: _salvar,
                  icon: Icon(Icons.check_rounded),
                  label: Text('Salvar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PredioVida extends StatelessWidget {
  final List<String> areas;
  final List<String> imagens;
  final List<String> respostas;
  final ValueChanged<int> onJanelaTap;

  const _PredioVida({
    required this.areas,
    required this.imagens,
    required this.respostas,
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
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF1B1718),
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(16),
                          ),
                          border: Border.all(
                            color: Theme.of(context).colorScheme.primary,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: predioLargura * 0.045,
                      right: predioLargura * 0.045,
                      top: altura * 0.018,
                      bottom: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0xFF6D4C41),
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      right: predioLargura * 0.075,
                      top: altura * 0.09,
                      child: Container(
                        width: 7,
                        height: 7,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    Positioned(
                      left: predioLargura * 0.16,
                      top: altura * 0.04,
                      bottom: altura * 0.025,
                      child: Container(
                        width: 2,
                        color: Colors.white24,
                      ),
                    ),
                  ],
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
                _AreaLabel(
                  text: areas[andar * 2],
                  left: 0,
                  top: topo + andar * andarAltura + janela * 0.22,
                  alignRight: true,
                  width: predioEsquerda - 10,
                ),
                _AreaLabel(
                  text: areas[andar * 2 + 1],
                  left: predioEsquerda + predioLargura + 10,
                  top: topo + andar * andarAltura + janela * 0.22,
                  alignRight: false,
                  width: predioEsquerda - 10,
                ),
                for (int coluna = 0; coluna < 2; coluna++)
                  Positioned(
                    left: predioEsquerda +
                        (predioLargura -
                                (janela * 2 + espacamentoJanela)) /
                            2 +
                        coluna * (janela + espacamentoJanela),
                    top: topo + andar * andarAltura,
                    width: janela,
                    height: janela,
                    child: _JanelaPredio(
                      preenchida:
                          respostas[andar * 2 + coluna].trim().isNotEmpty,
                      imagemAsset: imagens[andar * 2 + coluna],
                      onTap: () => onJanelaTap(andar * 2 + coluna),
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

class _AreaLabel extends StatelessWidget {
  final String text;
  final double left;
  final double top;
  final double width;
  final bool alignRight;

  const _AreaLabel({
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

class _JanelaPredio extends StatelessWidget {
  final bool preenchida;
  final String imagemAsset;
  final VoidCallback onTap;

  const _JanelaPredio({
    required this.preenchida,
    required this.imagemAsset,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
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
        child: preenchida
            ? Stack(
                children: [
                  _DecoracaoJanela(imagemAsset: imagemAsset),
                  Center(
                    child: Icon(
                      Icons.check_rounded,
                      color: Color(0xFF263238),
                      size: 28,
                    ),
                  ),
                ],
              )
            : _DecoracaoJanela(imagemAsset: imagemAsset),
      ),
    );
  }
}

class _DecoracaoJanela extends StatelessWidget {
  final String imagemAsset;

  const _DecoracaoJanela({required this.imagemAsset});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          left: 8,
          right: 8,
          bottom: 7,
          height: 5,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: const Color(0xFF6D4C41),
              borderRadius: BorderRadius.circular(999),
            ),
          ),
        ),
        Positioned(
          left: 13,
          bottom: 11,
          width: 16,
          height: 8,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: const Color(0xFF8D6E63),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
        Positioned(
          top: 6,
          right: 6,
          width: 20,
          height: 20,
          child: Image.asset(
            imagemAsset,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(145),
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(
                    color: const Color(0xFF263238).withAlpha(90),
                  ),
                ),
                child: Text(
                  'PNG',
                  style: TextStyle(
                    color: Color(0xFF263238),
                    fontSize: 6,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
