import 'package:flutter/material.dart';

import '../../../widgets/challenge_header_surface.dart';

import '../../../services/auth_service.dart';
import '../../../services/conteudos_service.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Desafio9Page extends StatefulWidget {
  const Desafio9Page({super.key});

  @override
  State<Desafio9Page> createState() => _Desafio9PageState();
}

class _Desafio9PageState extends State<Desafio9Page> {
  String nomeUsuario = 'você';
  int etapaAtual = 0;
  int? resposta1;
  int? resposta2;
  final List<bool?> respostasVf = [null, null, null];

  static const int respostaCorreta1 = 2;
  static const int respostaCorreta2 = 2;
  static const List<bool> respostasCorretasVf = [false, true, true];

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
                                'Dia 9 - Coraferido Vírus',
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
                      1 => _conteudoMultiplaEscolha1(textoPrincipal),
                      2 => _conteudoMultiplaEscolha2(textoPrincipal),
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
      0 => 'Atividade do podcast',
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
                    Icon(
                      Icons.psychology_alt_rounded,
                      color: corTema,
                      size: 30,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Vamos reforçar os pontos principais do podcast.',
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
                'Olá, $nomeUsuario! Que bom ter você aqui para mais um dia de aprendizado e reflexão!',
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
                    'Ontem você ouviu o podcast sobre o Coraferido Vírus e a Injeção de Benzetacil.',
                color: textoSecundario,
              ),
              _ParagraphText(
                text:
                    'Agora é hora de testar seus conhecimentos e reforçar os principais conceitos apresentados.',
                color: textoSecundario,
              ),
            ],
          ),
        ),
      ),
    ];
  }

  List<Widget> _conteudoMultiplaEscolha1(Color textoPrincipal) {
    return _conteudoQuestaoMultiplaEscolha(
      titulo: 'Questão 1',
      pergunta:
          "A metáfora da 'injeção de Benzetacil', utilizada no livro, representa:",
      selecionada: resposta1,
      onChanged: (valor) => setState(() => resposta1 = valor),
      alternativas: const [
        'Um processo indolor de transformação pessoal.',
        'A cura imediata proporcionada por medicamentos psiquiátricos.',
        'Um tratamento doloroso, porém necessário: enfrentar verdades que curam profundamente.',
        'A dependência de um mentor para superar traumas.',
        'O uso de afirmações positivas diárias para mudar o cérebro.',
      ],
    );
  }

  List<Widget> _conteudoMultiplaEscolha2(Color textoPrincipal) {
    return _conteudoQuestaoMultiplaEscolha(
      titulo: 'Questão 2',
      pergunta:
          "A expressão 'coraferido' representa, no livro, um vírus emocional que:",
      selecionada: resposta2,
      onChanged: (valor) => setState(() => resposta2 = valor),
      alternativas: const [
        'Afeta apenas pessoas com histórico de abuso físico.',
        'Se manifesta exclusivamente em adolescentes vulneráveis.',
        'É silencioso, altamente contagioso e se propaga de coração ferido para coração ferido, gerando uma pandemia emocional.',
        'Pode ser eliminado com apenas uma sessão de terapia.',
        'Só surge em pessoas que nunca frequentaram a igreja ou a espiritualidade.',
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
        "Sobre a metáfora da 'Injeção de Benzetacil', julgue as afirmações:",
        style: TextStyle(color: textoSecundario, fontSize: 15, height: 1.35),
      ),
      const SizedBox(height: 14),
      Expanded(
        child: ListView(
          children: [
            _TrueFalseTile(
              letra: 'a',
              texto:
                  'O livro-treinamento foi desenvolvido para ser uma experiência agradável e sem desconforto para o leitor.',
              valor: respostasVf[0],
              onChanged: (valor) => setState(() => respostasVf[0] = valor),
            ),
            const SizedBox(height: 12),
            _TrueFalseTile(
              letra: 'b',
              texto:
                  'A dor de encarar erros e limitações, assim como a dor da injeção, é necessária para que a cura aconteça.',
              valor: respostasVf[1],
              onChanged: (valor) => setState(() => respostasVf[1] = valor),
            ),
            const SizedBox(height: 12),
            _TrueFalseTile(
              letra: 'c',
              texto:
                  'Após a leitura do livro, continuar vivendo da mesma forma deixa de ser ignorância e se torna uma escolha consciente.',
              valor: respostasVf[2],
              onChanged: (valor) => setState(() => respostasVf[2] = valor),
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
    await firestore.collection('Usuários').doc(user.uid).set({
      'Nome': user.displayName ?? 'Usuário',
      'Email': user.email,
    }, SetOptions(merge: true));

    // Salvar resultado do desafio
    await firestore
        .collection('Usuários')
        .doc(user.uid)
        .collection('Desafios')
        .doc('Dia 09')
        .set({
          'Acertos': acertos,
          'TotalQuestoes': respostasVf.length,
          'Respostas': respostasVf,
          'RespondidoEm': FieldValue.serverTimestamp(),
        });

    // Mantém seu sistema atual
    await ConteudosService().salvarConteudosDoDesafio(
      desafio: 9,
      itens: [
        ConteudoItem(
          titulo: 'Resultado da atividade',
          texto: '$acertos de 5 acertos',
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
            'Você acertou $acertos de 5. O mais importante é reforçar o aprendizado e continuar escolhendo a cura.',
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
