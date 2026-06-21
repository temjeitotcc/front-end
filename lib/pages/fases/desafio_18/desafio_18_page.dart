import 'package:flutter/material.dart';

import '../../../widgets/challenge_header_surface.dart';

import '../../../services/auth_service.dart';
import '../../../services/conteudos_service.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Desafio18Page extends StatefulWidget {
  const Desafio18Page({super.key});

  @override
  State<Desafio18Page> createState() => _Desafio18PageState();
}

class _Desafio18PageState extends State<Desafio18Page> {
  String nomeUsuario = 'você';
  int etapaAtual = 0;
  int? resposta1;
  final List<bool?> respostasVf = [null, null, null, null];
  final TextEditingController reflexaoController = TextEditingController();

  static const int respostaCorreta1 = 2;
  static const List<bool> respostasCorretasVf = [false, true, true, true];

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
                                'Dia 18 - Nossa essência é servir',
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
                      1 => _conteudoMultiplaEscolha(),
                      2 => _conteudoVerdadeiroFalso(),
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
      0 => 'Propósito em pequenos gestos',
      1 => 'Questão 1 de 2',
      2 => 'Questão 2 de 2',
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
              _ServeBadge(cor: corTema),
              const SizedBox(height: 16),
              Text(
                'Olá $nomeUsuario, hoje é mais um capítulo da sua evolução!',
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
                    'Já parou para pensar que cada ser humano tem a capacidade de impactar positivamente a vida de outras pessoas?',
                color: textoSecundario,
              ),
              _ParagraphText(
                text:
                    'Ao longo da nossa jornada, aprendemos sobre autoconhecimento, escolhas, propósito e crescimento. Mas existe algo que dá ainda mais significado a tudo isso: a capacidade de servir.',
                color: textoSecundario,
              ),
              _ParagraphText(
                text:
                    'Quando compartilhamos conhecimento, oferecemos apoio, praticamos a empatia ou contribuímos para o bem-estar de alguém, não transformamos apenas a vida do outro, também crescemos como seres humanos.',
                color: textoSecundario,
              ),
              _ParagraphText(
                text:
                    'Servir não significa fazer grandes feitos o tempo todo. Muitas vezes, está presente em pequenos gestos: ouvir alguém com atenção, oferecer ajuda, compartilhar uma palavra de incentivo ou utilizar nossos talentos para gerar algo positivo no mundo.',
                color: textoSecundario,
              ),
              const SizedBox(height: 2),
              _SmallFocusCard(
                icon: Icons.volunteer_activism_rounded,
                text:
                    'Quando usamos nossas capacidades para gerar valor na vida de outras pessoas, encontramos mais propósito, significado e realização.',
                cor: corTema,
              ),
            ],
          ),
        ),
      ),
    ];
  }

  List<Widget> _conteudoMultiplaEscolha() {
    return _conteudoQuestaoMultiplaEscolha(
      titulo: 'Questão 1',
      pergunta:
          'Segundo Patrícia Estrela, qual é o objetivo universal de todo ser humano, independentemente de raça, religião, idade ou classe social?',
      selecionada: resposta1,
      onChanged: (valor) => setState(() => resposta1 = valor),
      alternativas: const [
        'Alcançar sucesso financeiro e reconhecimento social.',
        'Desenvolver todas as Inteligências Múltiplas ao máximo.',
        'Servir ao próximo, esse é o conhecimento intrínseco a toda profissão e função.',
        'Superar traumas da infância por meio de terapia.',
        'Construir relacionamentos amorosos saudáveis.',
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

  List<Widget> _conteudoVerdadeiroFalso() {
    final textoPrincipal = Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : Colors.black;
    final textoSecundario = Theme.of(context).brightness == Brightness.dark
        ? Colors.white70
        : Colors.black54;

    return [
      Text(
        'Questão 2  [ Verdadeiro ou Falso ]',
        style: TextStyle(
          color: textoPrincipal,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 10),
      Text(
        "Avalie as afirmações sobre o propósito de 'Servir' segundo Patrícia Estrela:",
        style: TextStyle(color: textoSecundario, fontSize: 15, height: 1.35),
      ),
      const SizedBox(height: 14),
      Expanded(
        child: ListView.separated(
          itemCount: respostasVf.length,
          separatorBuilder: (_, _) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final afirmacoes = const [
              'Servir é uma obrigação apenas de quem trabalha em profissões de cuidado, como médicos e professores.',
              'Quando entendemos que nascemos para servir, encontramos a motivação para viver e nos tornamos livres.',
              'Quem não serve ao próximo não se sente útil, e a dor da inutilidade corrompe a identidade humana.',
              'O autoconhecimento é o caminho mais eficaz para a autorrealização e para compreender o propósito de servir.',
            ];

            return _TrueFalseTile(
              letra: String.fromCharCode(97 + index),
              texto: afirmacoes[index],
              valor: respostasVf[index],
              onChanged: (valor) => setState(() => respostasVf[index] = valor),
            );
          },
        ),
      ),
    ];
  }

  List<Widget> _conteudoReflexao(Color textoPrincipal, Color textoSecundario) {
    final corTema = Theme.of(context).colorScheme.primary;
    final campo = Theme.of(context).brightness == Brightness.dark
        ? const Color(0xFF171315)
        : const Color(0xFFF6F1E7);

    return [
      Text(
        'Como você pode servir hoje?',
        style: TextStyle(
          color: textoPrincipal,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 10),
      Text(
        'Reflita por alguns instantes: de que forma você tem contribuído para a vida das pessoas ao seu redor? Quais talentos, conhecimentos ou qualidades você possui que podem ajudar alguém?',
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
            hintText:
                'Mediante tudo o que aprendi, hoje eu posso fazer a diferença...',
            hintStyle: TextStyle(color: textoSecundario.withAlpha(140)),
            filled: true,
            fillColor: campo,
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
      const SizedBox(height: 12),
      _SmallFocusCard(
        icon: Icons.auto_awesome_rounded,
        text:
            'Pequenos gestos também contam: uma palavra, uma escuta, uma ajuda possível.',
        cor: corTema,
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
    if (etapaAtual == 2 && respostasVf.any((resposta) => resposta == null)) {
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
    await firestore.collection('usuarios').doc(user.uid).set({
      'nome': user.displayName ?? 'Usuário',
      'email': user.email,
    }, SetOptions(merge: true));

    // Salvar resultado do desafio
    await firestore
        .collection('usuarios')
        .doc(user.uid)
        .collection('desafios')
        .doc('18')
        .set({
          'Acertos': acertos,
          'TotalQuestoes': 5,
          'Reflexao': reflexao,
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
              Icon(Icons.volunteer_activism_rounded, color: corTema),
              const SizedBox(width: 8),
              const Text('Resultado'),
            ],
          ),
          content: Text(
            'Você acertou $acertos de 5. Servir também é transformar o que você tem de melhor em cuidado, presença e ação.',
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

class _ServeBadge extends StatelessWidget {
  final Color cor;

  const _ServeBadge({required this.cor});

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
          Icon(Icons.volunteer_activism_rounded, color: cor, size: 32),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Servir é transformar talentos, escuta e presença em algo bom para alguém.',
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

class _SmallFocusCard extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color cor;

  const _SmallFocusCard({
    required this.icon,
    required this.text,
    required this.cor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cor.withAlpha(26),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cor.withAlpha(105)),
      ),
      child: Row(
        children: [
          Icon(icon, color: cor, size: 24),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: cor,
                fontSize: 13,
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
