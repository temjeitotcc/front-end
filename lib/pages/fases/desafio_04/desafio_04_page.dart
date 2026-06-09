import 'package:flutter/material.dart';

import '../../../services/auth_service.dart';
import '../../../services/conteudos_service.dart';

import '../../../widgets/challenge_intro_decoration.dart';

class Desafio4Page extends StatefulWidget {
  const Desafio4Page({super.key});

  @override
  State<Desafio4Page> createState() => _Desafio4PageState();
}

class _Desafio4PageState extends State<Desafio4Page> {
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
                          'Dia 4 - O que me move',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: textoPrincipal,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          etapaAtual == 0 ? 'Texto inicial' : 'Reflexão',
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
                        : _conteudoReflexao(
                            textoPrincipal,
                            textoSecundario,
                          ),
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
              const ChallengeIntroDecoration(
                mainIcon: Icons.favorite_rounded,
                leftIcon: Icons.bolt_rounded,
                rightIcon: Icons.track_changes_rounded,
                title: 'O que faz seu coração se mover?',
                subtitle:
                    'Motivações, hábitos e sonhos revelam muito sobre você.',
              ),
              const SizedBox(height: 16),
              Text(
                'Oii $nomeUsuario, seja bem-vindo(a) a mais uma etapa da sua jornada!!!',
                style: TextStyle(
                  color: textoPrincipal,
                  fontSize: 18,
                  height: 1.35,
                  fontWeight: FontWeight.bold,
                ),
              ),
              _ParagraphText(
                text:
                    'Hoje vamos refletir sobre suas motivações e vícios, e sim, eles têm algo em comum.',
                color: textoSecundario,
              ),
              _InlineVirusParagraph(
                textColor: textoSecundario,
                highlightColor: Theme.of(context).colorScheme.primary,
              ),
              _ParagraphText(
                text:
                    'É uma doença silenciosa, altamente perigosa e contagiosa, que está contaminando todos nós sem que saibamos. Pessoas magoam e são magoadas em virtude do coraferido vírus, onde um coração ferido fere outro coração.',
                color: textoSecundario,
              ),
              _ParagraphText(
                text:
                    'E o autoconhecimento é a sua benzetacil: se entender e entender o outro é a melhor maneira de se curar.',
                color: textoSecundario,
              ),
              _ParagraphText(
                text:
                    'Pare por um momento e reflita sobre quem você é hoje, quais hábitos tem alimentado, quais sonhos já realizou e quais ainda deseja conquistar. Observe seus comportamentos, aquilo que te fortalece e também o que te limita. Pense no que faz seu coração vibrar, no que você faz com prazer e nas marcas que deseja deixar no mundo.',
                color: textoSecundario,
              ),
              _ParagraphText(
                text:
                    'Relembre os desafios que já superou, reconheça suas qualidades e perceba que existe um propósito maior por trás da sua caminhada. Sua vida não impacta apenas você, mas também sua família, as pessoas que ama e todas aquelas que ainda serão alcançadas pela sua história.',
                color: textoSecundario,
              ),
              _ParagraphText(
                text:
                    'Talvez alguém esteja esperando exatamente pela sua coragem, pela sua mudança e pela sua decisão de não desistir. Porque sempre tem jeito e sempre vale a pena continuar.',
                color: textoSecundario,
              ),
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
        'Sua decisão',
        style: TextStyle(
          color: textoPrincipal,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 10),
      Text(
        'Agora, depois de tudo o que refletiu, responda:',
        style: TextStyle(color: textoSecundario, fontSize: 15, height: 1.35),
      ),
      const SizedBox(height: 10),
      Text(
        'Qual decisão você escolhe tomar para a sua vida a partir de hoje?',
        style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
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
          style: TextStyle(
            color: textoPrincipal,
            fontSize: 16,
            height: 1.35,
          ),
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
        const SnackBar(content: Text('Escreva sua decisão antes de concluir.')),
      );
      return;
    }

    await ConteudosService().salvarConteudosDoDesafio(
      desafio: 4,
      itens: [
        ConteudoItem(
          titulo: 'Decisão a partir de hoje',
          texto: resposta,
        ),
      ],
    );

    if (!mounted) return;
    Navigator.of(context).pop(true);
  }
}

class _InlineVirusParagraph extends StatelessWidget {
  final Color textColor;
  final Color highlightColor;

  const _InlineVirusParagraph({
    required this.textColor,
    required this.highlightColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: RichText(
        text: TextSpan(
          style: TextStyle(
            color: textColor,
            fontSize: 16,
            height: 1.35,
          ),
          children: [
            const TextSpan(text: 'Se eu te contasse que existe uma doença chamada '),
            WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 3),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: highlightColor.withAlpha(42),
                  borderRadius: BorderRadius.circular(9),
                  border: Border.all(
                    color: highlightColor.withAlpha(190),
                    width: 1,
                  ),
                ),
                child: Text(
                  'coraferido vírus',
                  style: TextStyle(
                    color: highlightColor,
                    fontSize: 15,
                    height: 1,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
            const TextSpan(text: '.'),
          ],
        ),
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
