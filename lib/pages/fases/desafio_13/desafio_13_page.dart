import 'package:flutter/material.dart';

import '../../../widgets/challenge_header_surface.dart';

import '../../../services/auth_service.dart';
import '../../../services/conteudos_service.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Desafio13Page extends StatefulWidget {
  const Desafio13Page({super.key});

  @override
  State<Desafio13Page> createState() => _Desafio13PageState();
}

class _Desafio13PageState extends State<Desafio13Page> {
  final TextEditingController reflexaoController = TextEditingController();
  String nomeUsuario = 'você';
  int etapaAtual = 0;
  int? resposta1;
  int? resposta2;
  final List<bool?> respostasVf3 = [null, null, null];
  final List<bool?> respostasVf4 = [null, null, null];

  static const int respostaCorreta1 = 1;
  static const int respostaCorreta2 = 1;
  static const List<bool> respostasCorretasVf3 = [true, false, true];
  static const List<bool> respostasCorretasVf4 = [true, false, true];

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
                                'Dia 13 - Atividade',
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
                        value: (etapaAtual + 1) / 6,
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
                      0 => _conteudoIntroducao(textoPrincipal, textoSecundario),
                      1 => _conteudoMultiplaEscolha1(),
                      2 => _conteudoMultiplaEscolha2(),
                      3 => _conteudoVerdadeiroFalso(
                        titulo: "Questão 3  [ V ou F ]",
                        intro:
                            "Sobre a atividade 'Trocando os Óculos', avalie:",
                        respostas: respostasVf3,
                        afirmacoes: const [
                          'A atividade propõe que o leitor relembre momentos de raiva, medo, inveja e ódio para ressignificá-los com um novo significado positivo.',
                          'Trocar os óculos significa apagar o passado e fingir que experiências negativas nunca existiram.',
                          'Os óculos da gratidão permitem enxergar o que realmente importa e reconhecer a própria jornada de sobrevivente.',
                        ],
                      ),
                      4 => _conteudoVerdadeiroFalso(
                        titulo: "Questão 4  [ V ou F ]",
                        intro:
                            'Julgue as afirmações sobre a Visualização Positiva de Futuro:',
                        respostas: respostasVf4,
                        afirmacoes: const [
                          'A visualização positiva consiste em imaginar o futuro desejado e usar esse recurso para alinhar pensamentos, sentimentos e comportamentos ao propósito.',
                          'O Mural dos Sonhos deve conter fotos pessoais antigas do leitor para relembrar quem ele foi.',
                          'Quando um sonho recebe uma data e um plano de ação, ele se transforma em meta.',
                        ],
                      ),
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
                      onPressed: etapaAtual < 5 ? _proximo : _concluir,
                      icon: Icon(
                        etapaAtual < 5
                            ? Icons.arrow_forward_rounded
                            : Icons.check_rounded,
                      ),
                      label: Text(etapaAtual < 5 ? 'Próximo' : 'Concluir'),
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
      0 => 'Troca de óculos e futuro',
      1 => 'Questão 1 de 4',
      2 => 'Questão 2 de 4',
      3 => 'Questão 3 de 4',
      4 => 'Questão 4 de 4',
      _ => 'Reflexão final',
    };
  }

  List<Widget> _conteudoIntroducao(
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
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: corTema.withAlpha(34),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: corTema.withAlpha(160)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.visibility_rounded, color: corTema, size: 30),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Revise o podcast e pense em como aplicar esses conceitos.',
                        style: TextStyle(
                          color: corTema,
                          fontSize: 15,
                          height: 1.3,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Oieee, $nomeUsuario! Estamos nos aproximando do fim de mais uma semana. Animado(a)?',
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
                    'Ontem você ouviu o podcast sobre a Troca de Óculos e a Visualização Positiva do Futuro.',
                color: textoSecundario,
              ),
              _ParagraphText(
                text:
                    'Agora é o momento de revisar os principais conceitos e refletir sobre como eles podem ser aplicados na sua vida.',
                color: textoSecundario,
              ),
            ],
          ),
        ),
      ),
    ];
  }

  List<Widget> _conteudoMultiplaEscolha1() {
    return _conteudoQuestaoMultiplaEscolha(
      titulo: 'Questão 1',
      pergunta:
          "A técnica de 'Visualização Positiva de Futuro', descrita no livro, consiste em:",
      selecionada: resposta1,
      onChanged: (valor) => setState(() => resposta1 = valor),
      alternativas: const [
        'Fingir que os problemas não existem para se sentir mais feliz.',
        'Criar imagens mentais e visuais de sonhos futuros, colocando-os no papel com datas e plano de ação para transformá-los em metas.',
        'Assistir a vídeos motivacionais todos os dias ao acordar.',
        'Meditar por pelo menos uma hora diária em silêncio absoluto.',
        'Eliminar qualquer pensamento negativo do cotidiano por meio de repetição de mantras.',
      ],
    );
  }

  List<Widget> _conteudoMultiplaEscolha2() {
    return _conteudoQuestaoMultiplaEscolha(
      titulo: 'Questão 2',
      pergunta:
          "Quando a autora fala em 'trocar os óculos', ela propõe que o leitor:",
      selecionada: resposta2,
      onChanged: (valor) => setState(() => resposta2 = valor),
      alternativas: const [
        'Busque uma nova perspectiva de vida através de viagens e novas experiências externas.',
        'Substitua sua forma de enxergar situações passadas, trocando os óculos do medo, da raiva e da dor pelos da gratidão e do propósito.',
        'Ignore completamente o passado e foque somente no futuro.',
        'Adote uma filosofia religiosa específica para enxergar o mundo de forma positiva.',
        'Consulte um especialista para redirecionar sua visão de mundo.',
      ],
    );
  }

  List<Widget> _conteudoQuestaoMultiplaEscolha({
    required String titulo,
    required String pergunta,
    required int? selecionada,
    required ValueChanged<int> onChanged,
    required List<String> alternativas,
  }) {
    final textoPrincipal = Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : Colors.black;
    final textoSecundario = Theme.of(context).brightness == Brightness.dark
        ? Colors.white70
        : Colors.black54;

    return [
      Text(
        '$titulo  [ Múltipla Escolha ]',
        style: TextStyle(
          color: textoPrincipal,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 10),
      Text(
        pergunta,
        style: TextStyle(color: textoSecundario, fontSize: 15, height: 1.35),
      ),
      const SizedBox(height: 14),
      Expanded(
        child: ListView.separated(
          itemCount: alternativas.length,
          separatorBuilder: (_, _) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            return _AlternativeTile(
              letra: String.fromCharCode(65 + index),
              texto: alternativas[index],
              selecionada: selecionada == index,
              onTap: () => onChanged(index),
            );
          },
        ),
      ),
    ];
  }

  List<Widget> _conteudoVerdadeiroFalso({
    required String titulo,
    required String intro,
    required List<bool?> respostas,
    required List<String> afirmacoes,
  }) {
    final textoPrincipal = Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : Colors.black;
    final textoSecundario = Theme.of(context).brightness == Brightness.dark
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
        intro,
        style: TextStyle(color: textoSecundario, fontSize: 15, height: 1.35),
      ),
      const SizedBox(height: 14),
      Expanded(
        child: ListView.separated(
          itemCount: afirmacoes.length,
          separatorBuilder: (_, _) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            return _TrueFalseTile(
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

  List<Widget> _conteudoReflexao(Color textoPrincipal, Color textoSecundario) {
    final corTema = Theme.of(context).colorScheme.primary;
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
        'Pare por alguns instantes e pense:',
        style: TextStyle(color: textoSecundario, fontSize: 15, height: 1.35),
      ),
      const SizedBox(height: 10),
      Text(
        'Quais "óculos" você tem usado para enxergar sua vida hoje: os da dor, do medo e da escassez ou os da gratidão, do aprendizado e das possibilidades?',
        style: TextStyle(
          color: corTema,
          fontSize: 16,
          height: 1.35,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 10),
      Text(
        'Qual futuro você deseja construir e qual pequeno passo pode dar hoje para se aproximar dele?',
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
            hintText: 'Hoje eu escolho enxergar minha vida...',
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
    if (etapaAtual == 1 && resposta1 == null) {
      _mostrarPendencia('Escolha uma alternativa antes de avançar.');
      return;
    }
    if (etapaAtual == 2 && resposta2 == null) {
      _mostrarPendencia('Escolha uma alternativa antes de avançar.');
      return;
    }
    if (etapaAtual == 3 && respostasVf3.any((resposta) => resposta == null)) {
      _mostrarPendencia('Marque verdadeiro ou falso em todos os itens.');
      return;
    }
    if (etapaAtual == 4 && respostasVf4.any((resposta) => resposta == null)) {
      _mostrarPendencia('Marque verdadeiro ou falso em todos os itens.');
      return;
    }
    setState(() => etapaAtual++);
  }

  Future<void> _concluir() async {
    final reflexao = reflexaoController.text.trim();

    if (reflexao.isEmpty) {
      _mostrarPendencia('Escreva sua reflexão antes de concluir.');
      return;
    }

    final acertos = _contarAcertos();

    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return;

    final firestore = FirebaseFirestore.instance;

    // Salvar/atualizar dados do usuário
    await firestore.collection('Usuários').doc(user.uid).set({
      'Nome': user.displayName ?? 'Usuário',
      'Email': user.email,
    }, SetOptions(merge: true));

    // Salvar resultado do desafio
    await firestore
        .collection('Usuários')
        .doc(user.uid)
        .collection('Desafios')
        .doc('Dia 13')
        .set({
          'Acertos': acertos,
          'TotalQuestoes': 8,
          'Reflexao': reflexao,
          'RespondidoEm': FieldValue.serverTimestamp(),
        });

    // Mantém seu sistema atual
    await ConteudosService().salvarConteudosDoDesafio(
      desafio: 13,
      itens: [
        ConteudoItem(
          titulo: 'Resultado da atividade',
          texto: '$acertos de 8 acertos',
        ),
        ConteudoItem(
          titulo: 'Óculos e futuro',
          texto: reflexao,
          reflexao: true,
        ),
      ],
    );

    if (!mounted) return;

    await _mostrarResultado(acertos);

    if (!mounted) return;

    Navigator.of(context).pop(true);
  }

  int _contarAcertos() {
    var acertos = 0;
    if (resposta1 == respostaCorreta1) acertos++;
    if (resposta2 == respostaCorreta2) acertos++;
    for (int i = 0; i < respostasVf3.length; i++) {
      if (respostasVf3[i] == respostasCorretasVf3[i]) acertos++;
    }
    for (int i = 0; i < respostasVf4.length; i++) {
      if (respostasVf4[i] == respostasCorretasVf4[i]) acertos++;
    }
    return acertos;
  }

  void _mostrarPendencia(String mensagem) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(mensagem)));
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
              Icon(Icons.emoji_events_rounded, color: corTema),
              const SizedBox(width: 8),
              const Text('Resultado'),
            ],
          ),
          content: Text(
            'Você acertou $acertos de 8. Nos vemos amanhã para mais um desafio!',
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

class _AlternativeTile extends StatelessWidget {
  final String letra;
  final String texto;
  final bool selecionada;
  final VoidCallback onTap;

  const _AlternativeTile({
    required this.letra,
    required this.texto,
    required this.selecionada,
    required this.onTap,
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
    return Material(
      color: selecionada ? corTema.withAlpha(42) : Colors.transparent,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: selecionada ? corTema : textoSecundario.withAlpha(65),
            ),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 17,
                backgroundColor: selecionada ? corTema : corTema.withAlpha(32),
                foregroundColor: selecionada ? Colors.black : corTema,
                child: Text(
                  letra,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  texto,
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
  }
}

class _TrueFalseTile extends StatelessWidget {
  final String letra;
  final String texto;
  final bool? valor;
  final ValueChanged<bool> onChanged;

  const _TrueFalseTile({
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
                child: _VfButton(
                  label: 'VERDADEIRO',
                  selecionado: valor == true,
                  cor: corTema,
                  onTap: () => onChanged(true),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _VfButton(
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

class _VfButton extends StatelessWidget {
  final String label;
  final bool selecionado;
  final Color cor;
  final VoidCallback onTap;

  const _VfButton({
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
