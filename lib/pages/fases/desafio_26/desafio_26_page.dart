import 'package:flutter/material.dart';

import '../../../services/auth_service.dart';
import '../../../services/conteudos_service.dart';

class Desafio26Page extends StatefulWidget {
  const Desafio26Page({super.key});

  @override
  State<Desafio26Page> createState() => _Desafio26PageState();
}

class _Desafio26PageState extends State<Desafio26Page> {
  final TextEditingController reflexaoController = TextEditingController();
  final List<_SonhoControllers> sonhos = List.generate(
    6,
    (_) => _SonhoControllers(),
  );

  String nomeUsuario = 'você';
  int etapaAtual = 0;

  @override
  void initState() {
    super.initState();
    _carregarNome();
  }

  @override
  void dispose() {
    for (final sonho in sonhos) {
      sonho.dispose();
    }
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
                          'Dia 26 - Mural dos Sonhos',
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
                      1 => _conteudoSonhos(textoPrincipal, textoSecundario),
                      _ => _conteudoReflexao(textoPrincipal, textoSecundario),
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
      0 => 'Visualize o futuro',
      1 => 'Liste seus sonhos',
      _ => 'Sua decisão',
    };
  }

  List<Widget> _conteudoTexto(Color textoPrincipal, Color textoSecundario) {
    return [
      Expanded(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _DreamBadge(cor: Theme.of(context).colorScheme.primary),
              const SizedBox(height: 16),
              Text(
                'Oii $nomeUsuario, pronto para iniciar a segunda semana da sua transformação?',
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
                    'Agora que você já compreende que é capaz de aprender, evoluir e desenvolver novas habilidades, chegou o momento de olhar para o futuro e sonhar sem limites.',
                color: textoSecundario,
              ),
              _ParagraphText(
                text:
                    'Lembre-se: você é o CEO da sua própria vida. Assim como uma empresa possui diferentes setores para administrar, sua vida também possui áreas que precisam de atenção, planejamento e crescimento.',
                color: textoSecundario,
              ),
              _ParagraphText(
                text:
                    'Sua missão é listar de 6 a 10 sonhos que deseja realizar, escolhendo objetivos de diferentes áreas, como família, relacionamentos, estudos, carreira, saúde, espiritualidade, finanças e lazer.',
                color: textoSecundario,
              ),
              _ParagraphText(
                text:
                    'Ao lado de cada sonho, escreva quais sentimentos e resultados ele proporcionará quando for conquistado.',
                color: textoSecundario,
              ),
              _ParagraphText(
                text:
                    'Depois, procure imagens que representem esses sonhos. Escolha fotos que simbolizam o futuro que deseja construir: uma formatura, uma casa, uma viagem, uma família feliz, uma carreira de sucesso, momentos de saúde, paz ou realização pessoal.',
                color: textoSecundario,
              ),
              _ParagraphText(
                text:
                    'Evite fotos suas, pois o objetivo é visualizar o futuro, não o passado.',
                color: textoSecundario,
              ),
              _ParagraphText(
                text:
                    'Com essas imagens, monte um Mural dos Sonhos, seja no celular, no computador ou em um mural físico. Deixe-o em um lugar visível e reserve alguns minutos diariamente para visualizar cada objetivo já realizado, sentindo a emoção de conquistá-lo.',
                color: textoSecundario,
              ),
              _ParagraphText(
                text:
                    'Quando você transforma um sonho em algo visível, define metas e cria um plano de ação, ele deixa de ser apenas um desejo e passa a se tornar um projeto de vida.',
                color: textoSecundario,
              ),
              _ParagraphText(
                text:
                    'Visualize, acredite, planeje e aja. O futuro começa a ser construído pelas escolhas que você faz hoje.',
                color: textoSecundario,
              ),
            ],
          ),
        ),
      ),
    ];
  }

  List<Widget> _conteudoSonhos(Color textoPrincipal, Color textoSecundario) {
    final corTema = Theme.of(context).colorScheme.primary;

    return [
      Row(
        children: [
          Expanded(
            child: Text(
              'Lista dos Sonhos',
              style: TextStyle(
                color: textoPrincipal,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      const SizedBox(height: 8),
      Text(
        'Preencha pelo menos 6 sonhos. Você pode adicionar até 10.',
        style: TextStyle(color: textoSecundario, fontSize: 14, height: 1.35),
      ),
      const SizedBox(height: 14),
      Expanded(
        child: ListView.separated(
          padding: const EdgeInsets.only(bottom: 14),
          itemCount: sonhos.length,
          separatorBuilder: (_, _) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            return _DreamFormCard(
              numero: index + 1,
              sonho: sonhos[index],
              podeRemover: sonhos.length > 6,
              onRemove: () {
                setState(() {
                  final removido = sonhos.removeAt(index);
                  removido.dispose();
                });
              },
            );
          },
        ),
      ),
      const SizedBox(height: 12),
      Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: corTema,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 13),
              ),
              onPressed: sonhos.length >= 10
                  ? null
                  : () {
                      setState(() => sonhos.add(_SonhoControllers()));
                    },
              icon: const Icon(Icons.add_rounded),
              label: Text(
                sonhos.length >= 10
                    ? 'Limite de 10 sonhos'
                    : 'Adicionar sonho',
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                foregroundColor: textoPrincipal,
                side: BorderSide(color: corTema),
                padding: const EdgeInsets.symmetric(vertical: 13),
              ),
              onPressed: sonhos.length <= 6
                  ? null
                  : () {
                      setState(() {
                        final removido = sonhos.removeLast();
                        removido.dispose();
                      });
                    },
              icon: const Icon(Icons.remove_rounded),
              label: Text(
                sonhos.length <= 6 ? 'Mínimo 6' : 'Remover último',
              ),
            ),
          ),
        ],
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
        'Mediante tudo o que aprendeu e entendeu até agora, qual decisão você toma para construir o futuro que deseja?',
        style: TextStyle(
          color: corTema,
          fontSize: 17,
          height: 1.35,
          fontWeight: FontWeight.w900,
        ),
      ),
      const SizedBox(height: 12),
      Text(
        'Escreva uma decisão prática: algo que você pode começar a fazer hoje para aproximar seus sonhos da realidade.',
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
            hintText: 'Para construir o futuro que desejo, eu escolho...',
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
    if (etapaAtual == 1 && !_sonhosValidos()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Preencha os campos principais dos seus sonhos.'),
        ),
      );
      return;
    }
    setState(() => etapaAtual++);
  }

  bool _sonhosValidos() {
    return sonhos.every((sonho) {
      return sonho.sonho.text.trim().isNotEmpty &&
          sonho.area.text.trim().isNotEmpty &&
          sonho.proporcionara.text.trim().isNotEmpty &&
          sonho.sentirei.text.trim().isNotEmpty;
    });
  }

  Future<void> _concluir() async {
    final resposta = reflexaoController.text.trim();
    if (resposta.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Escreva sua decisão antes de concluir.'),
        ),
      );
      return;
    }

    final itens = <ConteudoItem>[
      for (int i = 0; i < sonhos.length; i++)
        ConteudoItem(
          titulo: 'Sonho ${i + 1} - ${sonhos[i].sonho.text.trim()}',
          texto:
              'Área da vida: ${sonhos[i].area.text.trim()}\n'
              'O que esse sonho me proporcionará: ${sonhos[i].proporcionara.text.trim()}\n'
              'Como me sentirei ao conquistá-lo: ${sonhos[i].sentirei.text.trim()}',
        ),
      ConteudoItem(
        titulo: 'Decisão para construir o futuro',
        texto: resposta,
        reflexao: true,
      ),
    ];

    await ConteudosService().salvarConteudosDoDesafio(
      desafio: 26,
      itens: itens,
    );

    if (!mounted) return;
    Navigator.of(context).pop(true);
  }
}

class _SonhoControllers {
  final TextEditingController sonho = TextEditingController();
  final TextEditingController area = TextEditingController();
  final TextEditingController proporcionara = TextEditingController();
  final TextEditingController sentirei = TextEditingController();

  void dispose() {
    sonho.dispose();
    area.dispose();
    proporcionara.dispose();
    sentirei.dispose();
  }
}

class _DreamFormCard extends StatelessWidget {
  final int numero;
  final _SonhoControllers sonho;
  final bool podeRemover;
  final VoidCallback onRemove;

  const _DreamFormCard({
    required this.numero,
    required this.sonho,
    required this.podeRemover,
    required this.onRemove,
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
    final fill = Theme.of(context).brightness == Brightness.dark
        ? const Color(0xFF171315)
        : const Color(0xFFF6F1E7);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: fill,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: corTema.withAlpha(100)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: corTema,
                foregroundColor: Colors.black,
                child: Text('$numero'),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Sonho $numero',
                  style: TextStyle(
                    color: textoPrincipal,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (podeRemover)
                IconButton(
                  tooltip: 'Remover sonho',
                  onPressed: onRemove,
                  icon: Icon(Icons.delete_outline_rounded, color: corTema),
                ),
            ],
          ),
          const SizedBox(height: 12),
          _DreamTextField(
            controller: sonho.sonho,
            label: 'Sonho',
            hint: 'Ex: concluir a faculdade',
            fill: Theme.of(context).brightness == Brightness.dark
                ? const Color(0xFF211D1F)
                : Colors.white,
          ),
          const SizedBox(height: 10),
          _DreamTextField(
            controller: sonho.area,
            label: 'Área da vida',
            hint: 'Família, carreira, saúde...',
            fill: Theme.of(context).brightness == Brightness.dark
                ? const Color(0xFF211D1F)
                : Colors.white,
          ),
          const SizedBox(height: 10),
          _DreamTextField(
            controller: sonho.proporcionara,
            label: 'O que esse sonho me proporcionará',
            hint: 'Resultados, mudanças, conquistas...',
            fill: Theme.of(context).brightness == Brightness.dark
                ? const Color(0xFF211D1F)
                : Colors.white,
            maxLines: 2,
          ),
          const SizedBox(height: 10),
          _DreamTextField(
            controller: sonho.sentirei,
            label: 'Como me sentirei ao conquistá-lo',
            hint: 'Paz, orgulho, liberdade...',
            fill: Theme.of(context).brightness == Brightness.dark
                ? const Color(0xFF211D1F)
                : Colors.white,
            maxLines: 2,
          ),
          const SizedBox(height: 8),
          Text(
            'Depois escolha uma imagem para representar esse sonho no seu mural.',
            style: TextStyle(color: textoSecundario, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _DreamTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final Color fill;
  final int maxLines;

  const _DreamTextField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.fill,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    final corTema = Theme.of(context).colorScheme.primary;
    final textoPrincipal = Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : Colors.black;
    final textoSecundario = Theme.of(context).brightness == Brightness.dark
        ? Colors.white60
        : Colors.black45;

    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: TextStyle(color: textoPrincipal, fontSize: 15, height: 1.3),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        labelStyle: TextStyle(color: corTema),
        hintStyle: TextStyle(color: textoSecundario),
        filled: true,
        fillColor: fill,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: corTema, width: 2),
        ),
      ),
    );
  }
}

class _DreamBadge extends StatelessWidget {
  final Color cor;

  const _DreamBadge({required this.cor});

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
          Icon(Icons.dashboard_customize_rounded, color: cor, size: 30),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Transforme sonhos em imagens, metas e projeto de vida.',
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
        style: TextStyle(color: color, fontSize: 16, height: 1.35),
      ),
    );
  }
}
