import 'package:flutter/material.dart';

import '../../../widgets/challenge_header_surface.dart';

import '../../../services/conteudos_service.dart';
import '../../../widgets/challenge_intro_decoration.dart';

class Desafio1Page extends StatefulWidget {
  const Desafio1Page({super.key});

  @override
  State<Desafio1Page> createState() => _Desafio1PageState();
}

class _Desafio1PageState extends State<Desafio1Page> {
  List<String> get perguntas => const [
    'Familiar',
    'Relacional',
    'Social',
    'Saude',
    'Intelectual',
    'Profissional',
    'Emocional',
    'Solidariedade',
    'Futuro',
  ];

  List<String> get subtitulos => const [
    'Como está sua relação com sua família? Você tem proximidade com seus pais? (ou responsáveis) E com seus filhos, se tiver? Vocês passam tempo juntos? Conversam de verdade? Existe apoio, empatia, parceria? Tem gratidão entre vocês?',
    'Você está em um relacionamento? Se sim, você se sente feliz nele? Essa pessoa soma na sua vida? Vocês têm planos em comum? Se não: isso te incomoda ou tá tudo bem pra você?',
    'Você tem amigos? Tá satisfeito com a quantidade e qualidade dessas amizades? Vocês realmente se fazem presentes na vida um do outro? Compartilham momentos, conquistas e dificuldades?',
    'Como está sua alimentação? Você cuida do que come? Faz exercício? E seu sono, como anda? Dorme bem ou vive cansado(a)?',
    'Você estuda de verdade ou só “vai levando”? Tem rotina de estudos? Lê livros? Faz cursos? Busca evoluir ou tá meio parado(a)?',
    'Você trabalha com algo que gosta? Se dedica de verdade? Ou vive reclamando? Busca crescer, aprender coisas novas, se desenvolver? Se ainda não trabalha: você já sabe com o que quer trabalhar? Tá fazendo algo pra chegar lá?',
    'Você sabe lidar com suas emoções ou vive agindo no impulso? Se estressa fácil? Se arrepende das suas atitudes? Como está sua ansiedade, seu cansaço, sua energia? Seus relacionamentos são tranquilos ou cheios de conflito?',
    'Você ajuda alguém? Pode ser com tempo, atenção ou recursos. Você se sente bem fazendo isso? Ou nem pensa muito sobre?',
    'Você tem planos claros para o seu futuro? Ou tá vivendo no automático? Define metas? Se organiza? Pensa nos próximos passos da sua vida?',
  ];

  List<String> get instrucoes => const [
    'Vamos dividir sua vida em 9 areas: família, relacionamentos, vida social, saúde, intelectual, profissional, emocional, solidariedade e futuro. Para cada uma delas, você vai dar uma nota de 0 a 10 com base em como enxerga sua vida hoje.\n\nAntes de responder, imagine como seria cada área funcionando no seu melhor nível possivel, essa será sua "nota 10". Depois, compare com sua realidade atual e de notas sinceras, sem se cobrar demais.\n\nAreas que te causam ansiedade, estresse ou desconforto provavelmente terao notas mais baixas. Já as que estao indo bem podem ficar entre 6 e 9, mesmo ainda podendo melhorar.\n\nPara ajudar na reflexão, haverá perguntas especificas sobre cada área.',
  ];

  late final List<int?> respostas;
  late final TextEditingController reflexaoController;
  int instrucaoAtual = 0;
  int perguntaAtual = 0;
  bool mostrandoReflexao = false;

  @override
  void initState() {
    super.initState();
    respostas = List<int?>.filled(perguntas.length, null);
    reflexaoController = TextEditingController();
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
    final mostrandoInstrucoes = instrucaoAtual < instrucoes.length;
    final totalEtapas = instrucoes.length + perguntas.length + 1;
    final progresso = mostrandoInstrucoes
        ? (instrucaoAtual + 1) / totalEtapas
        : mostrandoReflexao
        ? 1.0
        : (instrucoes.length + perguntaAtual + 1) / totalEtapas;

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
                              'Desafio 1',
                              style: TextStyle(
                                color: textoPrincipal,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              mostrandoInstrucoes
                                  ? 'Instruções ${instrucaoAtual + 1} de ${instrucoes.length}'
                                  : mostrandoReflexao
                                  ? 'Reflexão final'
                                  : 'Pergunta ${perguntaAtual + 1} de ${perguntas.length}',
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
                      value: progresso,
                      minHeight: 10,
                      backgroundColor: Colors.white12,
                      valueColor: AlwaysStoppedAnimation(Theme.of(context).colorScheme.primary),
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
                    border: Border.all(
                      color: Theme.of(context).colorScheme.primary.withAlpha(110),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: mostrandoInstrucoes
                        ? _conteudoInstrucao(textoPrincipal, textoSecundario)
                        : mostrandoReflexao
                        ? _conteudoReflexao(textoPrincipal, textoSecundario)
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
                        foregroundColor: textoPrincipal,
                        side: BorderSide(color: Theme.of(context).colorScheme.primary),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: _voltarEtapa,
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
                      onPressed: _proximaEtapa,
                      icon: Icon(
                        mostrandoReflexao
                            ? Icons.check_rounded
                            : Icons.arrow_forward_rounded,
                      ),
                      label: Text(mostrandoReflexao ? 'Concluir' : 'Próximo'),
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

  List<Widget> _conteudoInstrucao(Color textoPrincipal, Color textoSecundario) {
    return [
      const ChallengeIntroDecoration(
        mainIcon: Icons.explore_rounded,
        leftIcon: Icons.flag_rounded,
        rightIcon: Icons.auto_awesome_rounded,
        title: 'O começo da sua jornada',
        subtitle: 'Observe sua vida com sinceridade e vontade de evoluir.',
      ),
      const SizedBox(height: 14),
      Text(
        'Instruções do Desafio 1',
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
            instrucoes[instrucaoAtual],
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
          'Evite colocar nota 10, porque a ideia é continuar evoluindo sempre.',
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
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

  List<Widget> _conteudoReflexao(Color textoPrincipal, Color textoSecundario) {
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
        'Mediante tudo que aprendeu e entendeu até agora, qual decisão você toma?',
        style: TextStyle(color: textoSecundario, fontSize: 15, height: 1.35),
      ),
      const SizedBox(height: 18),
      Expanded(
        child: TextField(
          controller: reflexaoController,
          expands: true,
          maxLines: null,
          minLines: null,
          textAlignVertical: TextAlignVertical.top,
          style: TextStyle(color: textoPrincipal, fontSize: 16, height: 1.35),
          decoration: InputDecoration(
            hintText: 'Minha reflexão...',
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
              borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2),
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
          'Nenhum problema é tão grave que não tenha solução, e nada é tão bom que não possa melhorar.',
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ];
  }

  void _voltarEtapa() {
    if (mostrandoReflexao) {
      setState(() {
        mostrandoReflexao = false;
        perguntaAtual = perguntas.length - 1;
      });
      return;
    }

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

    setState(() {
      perguntaAtual--;
    });
  }

  Future<void> _proximaEtapa() async {
    if (instrucaoAtual < instrucoes.length) {
      setState(() {
        instrucaoAtual++;
      });
      return;
    }

    if (mostrandoReflexao) {
      if (reflexaoController.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Escreva sua reflexão antes de concluir.'),
          ),
        );
        return;
      }

      await ConteudosService().salvarConteudosDoDesafio(
        desafio: 1,
        itens: [
          for (int i = 0; i < perguntas.length; i++)
            ConteudoItem(
              titulo: perguntas[i],
              texto: 'Nota: ${respostas[i]}',
            ),
          ConteudoItem(
            titulo: 'Reflexão final',
            texto: reflexaoController.text.trim(),
            reflexao: true,
          ),
        ],
      );

      if (!mounted) return;
      Navigator.of(context).pop(true);
      return;
    }

    if (respostas[perguntaAtual] == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Escolha uma nota antes dé continuar.')),
      );
      return;
    }

    if (perguntaAtual < perguntas.length - 1) {
      setState(() {
        perguntaAtual++;
      });
      return;
    }

    setState(() {
      mostrandoReflexao = true;
    });
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
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
