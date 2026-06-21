import 'package:flutter/material.dart';

import '../../../widgets/challenge_header_surface.dart';

import '../../../services/auth_service.dart';
import '../../../services/conteudos_service.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Desafio11Page extends StatefulWidget {
  const Desafio11Page({super.key});

  @override
  State<Desafio11Page> createState() => _Desafio11PageState();
}

class _Desafio11PageState extends State<Desafio11Page> {
  String nomeUsuario = 'você';
  int etapaAtual = 0;
  int? resposta1;
  int? resposta2;
  final List<bool?> respostasVf = [null, null, null, null];

  static const int respostaCorreta1 = 1;
  static const int respostaCorreta2 = 1;
  static const List<bool> respostasCorretasVf = [false, true, true, true];

  @override
  void initState() {
    super.initState();
    _carregarNome();
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
                                'Dia 11 - Atividade',
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
                      0 => _conteudoIntroducao(textoPrincipal, textoSecundario),
                      1 => _conteudoMultiplaEscolha1(),
                      2 => _conteudoMultiplaEscolha2(),
                      _ => _conteudoVerdadeiroFalso(
                        textoPrincipal,
                        textoSecundario,
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
      0 => 'Suicida e assassino emocional',
      1 => 'Questão 1 de 3',
      2 => 'Questão 2 de 3',
      _ => 'Verdadeiro ou falso',
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
                    Icon(Icons.quiz_rounded, color: corTema, size: 30),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Uma revisão rápida para fortalecer o que ficou do podcast.',
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
                'Olá, $nomeUsuario! Que bom ter você aqui para mais um dia, parabéns pela sua dedicação até aqui!',
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
                    'Ontem você ouviu o podcast sobre o Suicida Emocional e o Assassino Emocional.',
                color: textoSecundario,
              ),
              _ParagraphText(
                text:
                    'Agora é hora de revisar os conceitos e fortalecer os aprendizados.',
                color: textoSecundario,
              ),
              _ParagraphText(
                text: 'Nos vemos amanhã para mais um passo nessa jornada!',
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
      pergunta: "De acordo com a autora, o 'Suicida Emocional' é aquele que:",
      selecionada: resposta1,
      onChanged: (valor) => setState(() => resposta1 = valor),
      alternativas: const [
        'Pensa frequentemente em tirar a própria vida de forma literal.',
        'Mata a própria essência ao desistir de sonhos, aceitar humilhações e viver em comportamentos nocivos.',
        'Vive em isolamento social completo.',
        'Não consegue se relacionar profissionalmente.',
        'Depende exclusivamente de terceiros para tomar decisões.',
      ],
    );
  }

  List<Widget> _conteudoMultiplaEscolha2() {
    return _conteudoQuestaoMultiplaEscolha(
      titulo: 'Questão 2',
      pergunta:
          "Qual afirmação descreve corretamente o conceito de 'Assassino Emocional' abordado por Patrícia Estrela?",
      selecionada: resposta2,
      onChanged: (valor) => setState(() => resposta2 = valor),
      alternativas: const [
        'Aquele que deliberadamente manipula outras pessoas por ganho financeiro.',
        'Pessoas feridas que, inconscientemente, ferem os que estão ao seu redor, matando sonhos e autoestima alheios.',
        'Profissionais de saúde que tratam pacientes com frieza.',
        'Indivíduos que cometem bullying de forma intencional e consciente.',
        'Pessoas que foram criadas em ambientes abusivos e repetem esses padrões de forma consciente.',
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

  List<Widget> _conteudoVerdadeiroFalso(
    Color textoPrincipal,
    Color textoSecundario,
  ) {
    return [
      Text(
        'Questão 3  [ V ou F ]',
        style: TextStyle(
          color: textoPrincipal,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 10),
      Text(
        "Analise as afirmações a seguir sobre o conceito de 'Suicida Emocional':",
        style: TextStyle(color: textoSecundario, fontSize: 15, height: 1.35),
      ),
      const SizedBox(height: 14),
      Expanded(
        child: ListView(
          children: [
            _TrueFalseTile(
              letra: 'a',
              texto:
                  'O Suicida Emocional é apenas aquele que pensa em se matar fisicamente, segundo a autora.',
              valor: respostasVf[0],
              onChanged: (valor) => setState(() => respostasVf[0] = valor),
            ),
            const SizedBox(height: 12),
            _TrueFalseTile(
              letra: 'b',
              texto:
                  'Aceitar migalhas de amor e se submeter a humilhações são formas de suicídio emocional.',
              valor: respostasVf[1],
              onChanged: (valor) => setState(() => respostasVf[1] = valor),
            ),
            const SizedBox(height: 12),
            _TrueFalseTile(
              letra: 'c',
              texto:
                  'O suicídio emocional é contagioso: pessoas que se matam emocionalmente também afetam os que estão ao seu redor.',
              valor: respostasVf[2],
              onChanged: (valor) => setState(() => respostasVf[2] = valor),
            ),
            const SizedBox(height: 12),
            _TrueFalseTile(
              letra: 'd',
              texto:
                  'A autora afirma que fomos deliberadamente treinados ao longo da vida para nos tornarmos suicidas emocionais.',
              valor: respostasVf[3],
              onChanged: (valor) => setState(() => respostasVf[3] = valor),
            ),
          ],
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
    if (etapaAtual == 1 && resposta1 == null) {
      _mostrarPendencia('Escolha uma alternativa antes de avançar.');
      return;
    }
    if (etapaAtual == 2 && resposta2 == null) {
      _mostrarPendencia('Escolha uma alternativa antes de avançar.');
      return;
    }

    setState(() {
      etapaAtual++;
    });
  }

  Future<void> _concluir() async {
    if (respostasVf.any((resposta) => resposta == null)) {
      _mostrarPendencia('Marque verdadeiro ou falso em todos os itens.');
      return;
    }

    final acertos = _contarAcertos();

    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return;

    final firestore = FirebaseFirestore.instance;

    // Salvar/atualizar dados do usuário
    await firestore.collection('usuarios').doc(user.uid).set({
      'nome': user.displayName ?? 'Usuário',
      'email': user.email,
    }, SetOptions(merge: true));
    // Salvar resultado do desafio
    await firestore
        .collection('usuarios')
        .doc(user.uid)
        .collection('desafios')
        .doc('11')
        .set({
          'Acertos': acertos,
          'TotalQuestoes': respostasVf.length,
          'Respostas': respostasVf,
          'RespondidoEm': FieldValue.serverTimestamp(),
        });

    if (!mounted) return;

    await _mostrarResultado(acertos);

    if (!mounted) return;

    Navigator.of(context).pop(true);
  }

  int _contarAcertos() {
    var acertos = 0;
    if (resposta1 == respostaCorreta1) acertos++;
    if (resposta2 == respostaCorreta2) acertos++;

    for (int i = 0; i < respostasVf.length; i++) {
      if (respostasVf[i] == respostasCorretasVf[i]) acertos++;
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
            'Você acertou $acertos de 6. Parabéns por revisar e fortalecer seus aprendizados.',
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
    final textoSecundario = Theme.of(context).brightness == Brightness.dark
        ? Colors.white70
        : Colors.black54;

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
          if (valor == null) ...[
            const SizedBox(height: 8),
            Text(
              'Escolha uma opção.',
              style: TextStyle(color: textoSecundario, fontSize: 12),
            ),
          ],
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
