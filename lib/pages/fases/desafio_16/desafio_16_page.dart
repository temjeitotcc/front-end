import 'package:flutter/material.dart';

import '../../../widgets/challenge_header_surface.dart';

import '../../../services/auth_service.dart';
import '../../../services/conteudos_service.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Desafio16Page extends StatefulWidget {
  const Desafio16Page({super.key});

  @override
  State<Desafio16Page> createState() => _Desafio16PageState();
}

class _Desafio16PageState extends State<Desafio16Page> {
  String nomeUsuario = 'você';
  int etapaAtual = 0;
  int? resposta1;
  final List<bool?> respostasVf2 = [null, null, null, null];
  final List<bool?> respostasVf3 = [null, null, null, null];

  static const int respostaCorreta1 = 1;
  static const List<bool> respostasCorretasVf2 = [true, false, true, true];
  static const List<bool> respostasCorretasVf3 = [true, false, true, true];

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
                                'Dia 16 - 7 Passos',
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
                      2 => _conteudoVerdadeiroFalso(
                        titulo: 'Questão 2  [ Verdadeiro ou Falso ]',
                        intro: 'Sobre os 7 Passos da Sobrevivência, marque:',
                        respostas: respostasVf2,
                        afirmacoes: const [
                          'Recuperar o foco significa direcionar sua energia para aquilo que realmente depende de você.',
                          'A gratidão é importante apenas quando tudo está dando certo.',
                          'Estabelecer metas claras ajuda a transformar sonhos em objetivos concretos.',
                          'A autorresponsabilidade consiste em assumir o papel de protagonista da própria vida.',
                        ],
                      ),
                      _ => _conteudoVerdadeiroFalso(
                        titulo: 'Atividade 3  [ Verdadeiro ou Falso ]',
                        intro:
                            'Analise as afirmações abaixo sobre os 7 Passos da Sobrevivência:',
                        respostas: respostasVf3,
                        afirmacoes: const [
                          'Aceitar a mudança significa reconhecer que o crescimento exige adaptação e disposição para aprender coisas novas.',
                          'A autossabotagem acontece apenas quando uma pessoa desiste completamente de seus sonhos.',
                          'Encher a caixa de ferramentas significa desenvolver conhecimentos, habilidades e recursos que ajudem a enfrentar os desafios da vida.',
                          'Inspirar pessoas é uma consequência de viver com propósito, dando exemplo através das próprias atitudes.',
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
      0 => 'Atividade do podcast',
      1 => 'Questão 1 de 3',
      2 => 'Questão 2 de 3',
      _ => 'Atividade 3 de 3',
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
                    Icon(Icons.route_rounded, color: corTema, size: 30),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Transforme aprendizado em prática diária.',
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
                'Olá, $nomeUsuario! Chegou a hora de colocar em prática os aprendizados do podcast sobre os 7 Passos da Sobrevivência.',
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
                    'Responda às questões abaixo e reflita sobre como esses princípios podem ser aplicados na sua vida.',
                color: textoSecundario,
              ),
              _ParagraphText(
                text:
                    'Ao longo desta jornada, você aprendeu que pequenas escolhas feitas diariamente podem gerar grandes transformações ao longo do tempo.',
                color: textoSecundario,
              ),
              _ParagraphText(
                text: 'Até amanhã para mais uma atividade.',
                color: textoSecundario,
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
          "Considerando os '7 Passos da Sobrevivência' apresentados no livro e a fórmula 'Conhecimento + Estratégia + Prática = Treinamento Eficaz', qual sequência representa o caminho mais coerente para alguém que quer sair do modo sobrevivência e assumir o controle da própria vida?",
      selecionada: resposta1,
      onChanged: (valor) => setState(() => resposta1 = valor),
      alternativas: const [
        'Esperar que as condições externas melhorem, buscar conhecimento e agir eventualmente.',
        'Decidir ser feliz, acreditar na mudança, sair do ciclo de autossabotagem, encher a caixa de ferramentas, viver na gratidão, estabelecer metas claras e inspirar pessoas com autorresponsabilidade.',
        'Primeiro eliminar todos os relacionamentos tóxicos, depois buscar autoconhecimento.',
        'Estudar o passado exaustivamente antes de tomar qualquer decisão sobre o futuro.',
        'Focar apenas no departamento profissional, pois é o que mais impacta os demais.',
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
    if (etapaAtual == 2 && respostasVf2.any((resposta) => resposta == null)) {
      _mostrarPendencia('Marque verdadeiro ou falso em todos os itens.');
      return;
    }
    setState(() => etapaAtual++);
  }

  Future<void> _concluir() async {
    if (respostasVf3.any((resposta) => resposta == null)) {
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
        .doc('16')
        .set({
          'Acertos': acertos,
          'TotalQuestoes': 9,
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
    for (int i = 0; i < respostasVf2.length; i++) {
      if (respostasVf2[i] == respostasCorretasVf2[i]) acertos++;
    }
    for (int i = 0; i < respostasVf3.length; i++) {
      if (respostasVf3[i] == respostasCorretasVf3[i]) acertos++;
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
            'Você acertou $acertos de 9. Pequenas escolhas diárias constroem grandes transformações.',
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
