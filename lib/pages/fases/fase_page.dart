import 'package:flutter/material.dart';

class FasePage extends StatefulWidget {
  final String numero;

  const FasePage({super.key, required this.numero});

  @override
  State<FasePage> createState() => _FasePageState();
}

class _FasePageState extends State<FasePage> {
  List<String> get perguntas => const [
    'Familiar',
    'Relacional',
    'Social',
    'Saúde',
    'Intelectual',
    'Profissional',
    'Emocional',
    'Solidariedade',
    'Futuro',
  ];

  List<String> get subtitulos => const [
    'Como está sua relação com sua família?',
    'Você está em um relacionamento? Se sim, você se sente feliz nele?',
    'Você tem amigos? Tá satisfeito com a quantidade e qualidade dessas amizades?',
    'Como está sua alimentação? Você cuida do que come? Faz exercício? Dorme bem?',
    'Você estuda de verdade ou só “vai levando”? Tem rotina de estudos? Lê livros?',
    'Você trabalha com algo que gosta? Se dedica de verdade? Ou vive reclamando?',
    'Você sabe lidar com suas emoções ou vive agindo no impulso? Se estressa fácil? Se arrepende das suas atitudes?',
    'Você ajuda alguém? Você se sente bem fazendo isso? Ou nem pensa muito sobre?',
    ' Você tem planos claros para o seu futuro? Ou tá vivendo no automático? ',
  ];

  late final List<int?> respostas;
  int instrucaoAtual = 0;
  int perguntaAtual = 0;

  bool get faseComQuestionario => widget.numero == '1';

  @override
  void initState() {
    super.initState();
    respostas = List<int?>.filled(perguntas.length, null);
  }

  @override
  Widget build(BuildContext context) {
    if (!faseComQuestionario) {
      return _faseSimples(context);
    }

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
    final mostrandoInstrucoes = instrucaoAtual < instrucoes.length;

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
                          'Desafio 1',
                          style: TextStyle(
                            color: textoPrincipal,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          mostrandoInstrucoes
                              ? 'Instrucoes ${instrucaoAtual + 1} de ${instrucoes.length}'
                              : 'Pergunta ${perguntaAtual + 1} de ${perguntas.length}',
                          style: TextStyle(color: textoSecundario),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    tooltip: 'Sair',
                    style: IconButton.styleFrom(
                      backgroundColor: const Color(0xFFFED23E),
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
                  value: mostrandoInstrucoes
                      ? (instrucaoAtual + 1) /
                            (instrucoes.length + perguntas.length)
                      : (instrucoes.length + perguntaAtual + 1) /
                            (instrucoes.length + perguntas.length),
                  minHeight: 10,
                  backgroundColor: Colors.white12,
                  valueColor: const AlwaysStoppedAnimation(Color(0xFFFED23E)),
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
                      color: const Color(0xFFFED23E).withAlpha(110),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: mostrandoInstrucoes
                        ? _conteudoInstrucao(
                            textoPrincipal,
                            textoSecundario,
                            instrucaoAtual,
                          )
                        : _conteudoPergunta(textoPrincipal, textoSecundario),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: perguntaAtual == 0
                            ? textoSecundario
                            : textoPrincipal,
                        side: const BorderSide(color: Color(0xFFFED23E)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: _voltarEtapa,
                      icon: const Icon(Icons.arrow_back_rounded),
                      label: const Text('Voltar'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFED23E),
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: _proximaPergunta,
                      icon: Icon(
                        !mostrandoInstrucoes &&
                                perguntaAtual == perguntas.length - 1
                            ? Icons.check_rounded
                            : Icons.arrow_forward_rounded,
                      ),
                      label: Text(
                        !mostrandoInstrucoes &&
                                perguntaAtual == perguntas.length - 1
                            ? 'Concluir'
                            : 'Proximo',
                      ),
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

  List<String> get instrucoes => const [
    'Agora a gente vai dividir a sua vida em 9 areas, tipo uma empresa mesmo: familiar, relacionamentos, social, saude, intelectual, profissional, emocional, solidariedade e futuro.\n\nA ideia e voce dar uma nota de 0 a 10 para cada uma dessas areas, de acordo com como voce enxerga sua realidade hoje. Mas antes, leia todas as perguntas e orientacoes com calma, para responder da forma mais consciente possivel, beleza?',
    'Agora imagina cada area da sua vida funcionando MUITO bem, tipo no seu melhor nivel mesmo. Essa versao que voce imaginou e o seu "nota 10".\n\nCom isso em mente, compara com a sua realidade de hoje e da uma nota sincera para cada area. Sem se iludir, mas tambem sem se julgar demais, e so um retrato do agora.\n\nAs areas que estao mais baguncadas, que te geram ansiedade, estresse ou desconforto, provavelmente vao ficar abaixo de 5. Ja aquelas que estao fluindo melhor, mesmo que ainda tenham espaco para melhorar, podem ficar entre 6 e 9.\n\nE um detalhe importante: evite colocar 10 em alguma area, mesmo que esteja tudo otimo. Quando voce faz isso, seu cerebro entende que nao precisa mais evoluir ali e a ideia aqui e sempre crescer mais.\n\nPra te ajudar nisso, vou te guiar com algumas perguntas em cada area, para voce refletir de verdade.',
  ];

  List<Widget> _conteudoInstrucao(
    Color textoPrincipal,
    Color textoSecundario,
    int index,
  ) {
    final destaque = index == 1;

    return [
      Text(
        'Instrucoes do Desafio 1',
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
            instrucoes[index],
            style: TextStyle(
              color: textoSecundario,
              fontSize: 16,
              height: 1.35,
            ),
          ),
        ),
      ),
      if (destaque) ...[
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFFED23E).withAlpha(38),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFFED23E)),
          ),
          child: const Text(
            'Evite colocar 10 em alguma area: a ideia aqui e sempre crescer mais.',
            style: TextStyle(
              color: Color(0xFFFED23E),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    ];
  }

  List<Widget> _conteudoPergunta(Color textoPrincipal, Color textoSecundario) {
    return [
      Text(
        perguntas[perguntaAtual],
        style: TextStyle(
          color: textoPrincipal,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 10),
      Text(
        subtitulos[perguntaAtual],
        style: TextStyle(color: textoSecundario, fontSize: 15),
      ),
      const SizedBox(height: 10),
      Text(
        'Escolha uma nota de 1 a 10.',
        style: TextStyle(color: textoSecundario, fontSize: 14),
      ),
      const SizedBox(height: 24),
      Wrap(
        spacing: 10,
        runSpacing: 10,
        alignment: WrapAlignment.center,
        children: [
          for (int nota = 1; nota <= 10; nota++)
            _BotaoNota(
              nota: nota,
              selecionado: respostas[perguntaAtual] == nota,
              onTap: () {
                setState(() {
                  respostas[perguntaAtual] = nota;
                });
              },
            ),
        ],
      ),
    ];
  }

  Widget _faseSimples(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: const Color(0xFFFED23E),
        centerTitle: true,
        title: Text('Fase ${widget.numero}'),
      ),
      body: Center(
        child: Text(
          'Desafio ${widget.numero}',
          style: TextStyle(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : Colors.black,
            fontSize: 24,
          ),
        ),
      ),
    );
  }

  void _voltarEtapa() {
    if (instrucaoAtual < instrucoes.length && instrucaoAtual > 0) {
      setState(() {
        instrucaoAtual--;
      });
      return;
    }

    if (instrucaoAtual < instrucoes.length && perguntaAtual == 0) {
      Navigator.of(context).pop(false);
      return;
    }

    if (perguntaAtual == 0) {
      setState(() {
        instrucaoAtual = instrucoes.length - 1;
      });
      return;
    }

    if (perguntaAtual > 0) {
      setState(() {
        perguntaAtual--;
      });
    }
  }

  void _proximaPergunta() {
    if (instrucaoAtual < instrucoes.length) {
      setState(() {
        instrucaoAtual++;
      });
      return;
    }

    if (respostas[perguntaAtual] == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Escolha uma nota antes de continuar.')),
      );
      return;
    }

    if (perguntaAtual < perguntas.length - 1) {
      setState(() {
        perguntaAtual++;
      });
      return;
    }

    Navigator.of(context).pop(true);
  }
}

class _BotaoNota extends StatelessWidget {
  final int nota;
  final bool selecionado;
  final VoidCallback onTap;

  const _BotaoNota({
    required this.nota,
    required this.selecionado,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cor = HSVColor.lerp(
      const HSVColor.fromAHSV(1, 0, 0.95, 0.95),
      const HSVColor.fromAHSV(1, 125, 0.98, 0.82),
      (nota - 1) / 9,
    )!.toColor();

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: 54,
        height: 54,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: cor,
          border: Border.all(
            color: selecionado ? Colors.white : Colors.transparent,
            width: 4,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(selecionado ? 95 : 35),
              blurRadius: selecionado ? 12 : 5,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Text(
          '$nota',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
