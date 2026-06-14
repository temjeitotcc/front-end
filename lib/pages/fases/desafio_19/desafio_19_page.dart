import 'package:flutter/material.dart';

import '../../../widgets/challenge_header_surface.dart';

import '../../../services/auth_service.dart';
import '../../../services/conteudos_service.dart';

class Desafio19Page extends StatefulWidget {
  const Desafio19Page({super.key});

  @override
  State<Desafio19Page> createState() => _Desafio19PageState();
}

class _Desafio19PageState extends State<Desafio19Page> {
  String nomeUsuario = 'você';
  int etapaAtual = 0;
  final List<bool?> respostasQuestao19 = [null, null, null];
  int? respostaQuestao6;
  final List<bool?> respostasQuestao17 = [null, null, null];

  static const List<bool> gabaritoQuestao19 = [true, false, true];
  static const int gabaritoQuestao6 = 1;
  static const List<bool> gabaritoQuestao17 = [true, false, true];

  @override
  void initState() {
    super.initState();
    _carregarNome();
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
    final textoPrincipal =
        tema.brightness == Brightness.dark ? Colors.white : Colors.black;
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
                              'Dia 19 - Minha Empresa, Minha Vida',
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
                      0 => _introducao(textoPrincipal, textoSecundario),
                      1 => _verdadeiroFalso(
                          titulo: 'Questão 19  [ V ou F ]',
                          introducao:
                              'Sobre o processo de treinamento proposto no livro, avalie as afirmações:',
                          respostas: respostasQuestao19,
                          afirmacoes: const [
                            'Assim como aprendemos a andar e a falar por repetição e treino, podemos reprogramar nossos padrões mentais e emocionais.',
                            'O treinamento emocional proposto pela autora requer anos de dedicação exclusiva antes de produzir qualquer resultado.',
                            'A fórmula do treinamento eficaz apresentada no livro é: Conhecimento + Estratégia + Prática = Treinamento Eficaz.',
                          ],
                        ),
                      2 => _multiplaEscolha(),
                      _ => _verdadeiroFalso(
                          titulo: 'Questão 17  [ V ou F ]',
                          introducao:
                              'Sobre os 10 Departamentos da Vida, avalie:',
                          respostas: respostasQuestao17,
                          afirmacoes: const [
                            'Os 10 departamentos incluem: Familiar, Relacional, Social, Saúde, Intelectual, Profissional, Emocional, Solidariedade, Futuro e Espiritual.',
                            'Colocar nota máxima (10) em um departamento é recomendado para celebrar as conquistas nessa área.',
                            'O objetivo da atividade é conduzir o leitor à tomada de consciência sobre sua realidade atual e definir ações concretas para cada área.',
                          ],
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
                      onPressed: etapaAtual < 3 ? _proximo : _concluir,
                      icon: Icon(
                        etapaAtual < 3
                            ? Icons.arrow_forward_rounded
                            : Icons.check_rounded,
                      ),
                      label: Text(etapaAtual < 3 ? 'Próximo' : 'Concluir'),
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
      0 => 'Revisitando sua caminhada',
      1 => 'Questão 1 de 3',
      2 => 'Questão 2 de 3',
      _ => 'Questão 3 de 3',
    };
  }

  List<Widget> _introducao(Color textoPrincipal, Color textoSecundario) {
    final corTema = Theme.of(context).colorScheme.primary;

    return [
      Expanded(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _CompanyPanel(cor: corTema),
              const SizedBox(height: 16),
              Text(
                'Olá, $nomeUsuario! Vamos juntos para mais uma etapa da sua jornada.',
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
                    'Que tal relembrar uma das nossas primeiras atividades: "Minha Empresa, Minha Vida"?',
                color: textoSecundario,
              ),
              _Paragraph(
                text:
                    'No início deste projeto, você avaliou diferentes áreas da sua vida e refletiu sobre como estava gerenciando cada uma delas. Agora, depois de tantos aprendizados, desafios e reflexões, chegou o momento de revisitar essa atividade.',
                color: textoSecundario,
              ),
              _Paragraph(
                text:
                    'Se necessário, você pode voltar ao Dia 2. Para sabermos se você aprendeu mesmo, responda às questões a seguir.',
                color: textoSecundario,
              ),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: corTema.withAlpha(28),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: corTema.withAlpha(110)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.insights_rounded, color: corTema),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Assim como uma empresa acompanha seus resultados, nós também precisamos avaliar nossa caminhada para continuar evoluindo.',
                        style: TextStyle(
                          color: corTema,
                          fontSize: 14,
                          height: 1.35,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ];
  }

  List<Widget> _multiplaEscolha() {
    final tema = Theme.of(context);
    final corTema = tema.colorScheme.primary;
    final textoPrincipal =
        tema.brightness == Brightness.dark ? Colors.white : Colors.black;
    final textoSecundario = tema.brightness == Brightness.dark
        ? Colors.white70
        : Colors.black54;
    const alternativas = [
      'Comparar a produtividade pessoal com a de grandes executivos.',
      'Conduzir o leitor a identificar áreas da vida que precisam de atenção, tomando decisões conscientes como CEO da própria existência.',
      'Incentivar o leitor a priorizar apenas os departamentos profissional e financeiro.',
      'Substituir a necessidade de um psicólogo ou terapeuta.',
      'Criar metas apenas para o próximo mês.',
    ];

    return [
      Text(
        'Questão 6  [ Múltipla Escolha ]',
        style: TextStyle(
          color: textoPrincipal,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 10),
      Text(
        "Na atividade 'Minha Empresa, Minha Vida', a autora divide a vida em departamentos para:",
        style: TextStyle(
          color: textoSecundario,
          fontSize: 15,
          height: 1.35,
        ),
      ),
      const SizedBox(height: 14),
      Expanded(
        child: ListView.separated(
          itemCount: alternativas.length,
          separatorBuilder: (_, _) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            final selecionada = respostaQuestao6 == index;
            return Material(
              color: selecionada ? corTema.withAlpha(42) : Colors.transparent,
              borderRadius: BorderRadius.circular(18),
              child: InkWell(
                borderRadius: BorderRadius.circular(18),
                onTap: () => setState(() => respostaQuestao6 = index),
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: selecionada
                          ? corTema
                          : textoSecundario.withAlpha(65),
                    ),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 17,
                        backgroundColor:
                            selecionada ? corTema : corTema.withAlpha(32),
                        foregroundColor:
                            selecionada ? Colors.black : corTema,
                        child: Text(
                          String.fromCharCode(65 + index),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          alternativas[index],
                          style: TextStyle(
                            color: textoPrincipal,
                            fontSize: 14,
                            height: 1.3,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    ];
  }

  List<Widget> _verdadeiroFalso({
    required String titulo,
    required String introducao,
    required List<bool?> respostas,
    required List<String> afirmacoes,
  }) {
    final tema = Theme.of(context);
    final textoPrincipal =
        tema.brightness == Brightness.dark ? Colors.white : Colors.black;
    final textoSecundario = tema.brightness == Brightness.dark
        ? Colors.white70
        : Colors.black54;

    return [
      Text(
        titulo,
        style: TextStyle(
          color: textoPrincipal,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 10),
      Text(
        introducao,
        style: TextStyle(
          color: textoSecundario,
          fontSize: 15,
          height: 1.35,
        ),
      ),
      const SizedBox(height: 14),
      Expanded(
        child: ListView.separated(
          itemCount: afirmacoes.length,
          separatorBuilder: (_, _) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            return _TrueFalseCard(
              letra: String.fromCharCode(97 + index),
              texto: afirmacoes[index],
              valor: respostas[index],
              onChanged: (valor) => setState(() => respostas[index] = valor),
            );
          },
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
    if (etapaAtual == 1 &&
        respostasQuestao19.any((resposta) => resposta == null)) {
      _pendencia('Marque verdadeiro ou falso em todos os itens.');
      return;
    }
    if (etapaAtual == 2 && respostaQuestao6 == null) {
      _pendencia('Escolha uma alternativa antes de avançar.');
      return;
    }
    setState(() => etapaAtual++);
  }

  Future<void> _concluir() async {
    if (respostasQuestao17.any((resposta) => resposta == null)) {
      _pendencia('Marque verdadeiro ou falso em todos os itens.');
      return;
    }

    final acertos = _contarAcertos();
    await ConteudosService().salvarConteudosDoDesafio(
      desafio: 19,
      itens: [
        ConteudoItem(
          titulo: 'Resultado da atividade',
          texto: '$acertos de 7 acertos',
        ),
      ],
    );

    if (!mounted) return;
    await _mostrarResultado(acertos);
    if (!mounted) return;
    Navigator.of(context).pop(true);
  }

  int _contarAcertos() {
    var acertos = respostaQuestao6 == gabaritoQuestao6 ? 1 : 0;
    for (int i = 0; i < respostasQuestao19.length; i++) {
      if (respostasQuestao19[i] == gabaritoQuestao19[i]) acertos++;
    }
    for (int i = 0; i < respostasQuestao17.length; i++) {
      if (respostasQuestao17[i] == gabaritoQuestao17[i]) acertos++;
    }
    return acertos;
  }

  void _pendencia(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensagem)),
    );
  }

  Future<void> _mostrarResultado(int acertos) async {
    final corTema = Theme.of(context).colorScheme.primary;
    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).brightness == Brightness.dark
              ? const Color(0xFF2A2527)
              : Colors.white,
          title: Row(
            children: [
              Icon(Icons.business_center_rounded, color: corTema),
              const SizedBox(width: 8),
              const Expanded(child: Text('Sua empresa evoluiu')),
            ],
          ),
          content: Text(
            'Você acertou $acertos de 7. Continue acompanhando cada área da sua vida com consciência e autorresponsabilidade.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Continuar'),
            ),
          ],
        );
      },
    );
  }
}

class _CompanyPanel extends StatelessWidget {
  final Color cor;

  const _CompanyPanel({required this.cor});

  @override
  Widget build(BuildContext context) {
    const setores = [
      Icons.family_restroom_rounded,
      Icons.favorite_rounded,
      Icons.groups_rounded,
      Icons.health_and_safety_rounded,
      Icons.school_rounded,
      Icons.work_rounded,
      Icons.psychology_rounded,
      Icons.volunteer_activism_rounded,
      Icons.flag_rounded,
      Icons.auto_awesome_rounded,
    ];

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cor.withAlpha(30),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: cor.withAlpha(150)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.business_center_rounded, color: cor, size: 30),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Você é o CEO da sua própria vida',
                  style: TextStyle(
                    color: cor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final icon in setores)
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: cor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: Colors.black, size: 20),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TrueFalseCard extends StatelessWidget {
  final String letra;
  final String texto;
  final bool? valor;
  final ValueChanged<bool> onChanged;

  const _TrueFalseCard({
    required this.letra,
    required this.texto,
    required this.valor,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final corTema = Theme.of(context).colorScheme.primary;
    final textoPrincipal = Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : Colors.black;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: corTema.withAlpha(24),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: corTema.withAlpha(95)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            '$letra. $texto',
            style: TextStyle(
              color: textoPrincipal,
              fontSize: 15,
              height: 1.35,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _AnswerButton(
                  label: 'VERDADEIRO',
                  selecionado: valor == true,
                  cor: corTema,
                  onTap: () => onChanged(true),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _AnswerButton(
                  label: 'FALSO',
                  selecionado: valor == false,
                  cor: corTema,
                  onTap: () => onChanged(false),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AnswerButton extends StatelessWidget {
  final String label;
  final bool selecionado;
  final Color cor;
  final VoidCallback onTap;

  const _AnswerButton({
    required this.label,
    required this.selecionado,
    required this.cor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        backgroundColor: selecionado ? cor : Colors.transparent,
        foregroundColor: selecionado ? Colors.black : cor,
        side: BorderSide(color: cor),
        padding: const EdgeInsets.symmetric(vertical: 12),
      ),
      onPressed: onTap,
      child: Text(
        label,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
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
