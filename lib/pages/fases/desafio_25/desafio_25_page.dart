import 'package:flutter/material.dart';

import '../../../widgets/challenge_header_surface.dart';

import '../../../services/auth_service.dart';
import '../../../services/conteudos_service.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Desafio25Page extends StatefulWidget {
  const Desafio25Page({super.key});

  @override
  State<Desafio25Page> createState() => _Desafio25PageState();
}

class _Desafio25PageState extends State<Desafio25Page> {
  final TextEditingController reflexaoController = TextEditingController();

  String nomeUsuario = 'Usuário';
  int etapaAtual = 0;
  int? resposta1;
  int? resposta2;
  int? resposta3;

  static const List<int> respostasCorretas = [1, 1, 2];

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
    final escuro = Theme.of(context).brightness == Brightness.dark;
    final fundo = Theme.of(context).scaffoldBackgroundColor;
    final textoPrincipal = escuro ? Colors.white : Colors.black;
    final textoSecundario = escuro ? Colors.white70 : Colors.black54;
    final cardColor = escuro ? const Color(0xFF2A2527) : Colors.white;
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
                                'Dia 25 - Revisitando os Aprendizados',
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
                        value: (etapaAtual + 1) / 5,
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
                      1 => _questao1(),
                      2 => _questao2(),
                      3 => _questao3(),
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
                      onPressed: etapaAtual < 4 ? _proximo : _concluir,
                      icon: Icon(
                        etapaAtual < 4
                            ? Icons.arrow_forward_rounded
                            : Icons.check_rounded,
                      ),
                      label: Text(etapaAtual < 4 ? 'Próximo' : 'Concluir'),
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
      0 => 'Uma pausa para reconhecer sua evolução',
      1 => 'Questão 1 de 3',
      2 => 'Questão 2 de 3',
      3 => 'Questão 3 de 3',
      _ => 'O aprendizado que segue com você',
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
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: corTema.withAlpha(32),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: corTema.withAlpha(145)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.history_edu_rounded, color: corTema, size: 31),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Revisitar o caminho também é uma forma de perceber o quanto você cresceu.',
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
                'Olá, $nomeUsuario! Que bom ter você aqui para mais um dia da sua jornada!',
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
                    'Ao longo deste projeto, você foi convidado a olhar para dentro de si, refletir sobre sua história, seus sonhos, suas escolhas e seu propósito.',
                color: textoSecundario,
              ),
              _Paragraph(
                text:
                    'Aprendemos que a transformação acontece quando desenvolvemos consciência sobre quem somos, sobre os padrões que nos limitam e sobre as atitudes que nos aproximam da vida que desejamos construir.',
                color: textoSecundario,
              ),
              _Paragraph(
                text:
                    'Hoje vamos revisar a metáfora do jardim e do pântano, os 7 Passos da Sobrevivência e a importância de reconhecer que cada pessoa possui uma identidade única e um papel especial no mundo.',
                color: textoSecundario,
              ),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: corTema.withAlpha(22),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  'Responda com atenção e relembre os ensinamentos que trouxeram você até aqui.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: corTema,
                    fontWeight: FontWeight.bold,
                    height: 1.3,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ];
  }

  List<Widget> _questao1() {
    return _conteudoQuestao(
      titulo: 'Questão 1',
      pergunta:
          "Na atividade 'Quem Sou Eu?', a metáfora do jardim e do pântano representa respectivamente:",
      selecionada: resposta1,
      onChanged: (valor) => setState(() => resposta1 = valor),
      alternativas: const [
        'O futuro desejado e o presente vivido.',
        'As conquistas e alegrias da vida versus as dores, traumas e pedras que precisam ser reconhecidas e abandonadas.',
        'Os relacionamentos saudáveis e os relacionamentos tóxicos.',
        'Os sonhos realizados e os sonhos impossíveis.',
        'A mente consciente e a mente subconsciente, sem possibilidade de integração.',
      ],
    );
  }

  List<Widget> _questao2() {
    return _conteudoQuestao(
      titulo: 'Questão 2',
      pergunta:
          "Considerando os '7 Passos da Sobrevivência' e a fórmula 'Conhecimento + Estratégia + Prática = Treinamento Eficaz', qual sequência representa o caminho mais coerente para assumir o controle da própria vida?",
      selecionada: resposta2,
      onChanged: (valor) => setState(() => resposta2 = valor),
      alternativas: const [
        'Esperar as condições externas melhorarem, buscar conhecimento e agir eventualmente.',
        'Decidir ser feliz, acreditar na mudança, sair da autossabotagem, encher a caixa de ferramentas, viver na gratidão, estabelecer metas claras e inspirar pessoas com autorresponsabilidade.',
        'Primeiro eliminar todos os relacionamentos tóxicos, depois buscar autoconhecimento.',
        'Estudar o passado exaustivamente antes de tomar qualquer decisão sobre o futuro.',
        'Focar apenas no departamento profissional, pois é o que mais impacta os demais.',
      ],
    );
  }

  List<Widget> _questao3() {
    return _conteudoQuestao(
      titulo: 'Questão 3',
      pergunta:
          "A afirmação 'quando abandonas seus sonhos e começa a fazer escolhas equivocadas, toda a sociedade perde' está diretamente ligada a qual combinação de conceitos?",
      selecionada: resposta3,
      onChanged: (valor) => setState(() => resposta3 = valor),
      alternativas: const [
        'Inteligências Múltiplas e Mural dos Sonhos.',
        'Trocar os Óculos e Autoestima.',
        'Essência é Servir, Identidade Única e Impacto Coletivo do Propósito Individual.',
        'Autorresponsabilidade e Terapia Cognitiva Comportamental.',
        'Benzetacil, Gratidão e Relacionamentos.',
      ],
    );
  }

  List<Widget> _conteudoQuestao({
    required String titulo,
    required String pergunta,
    required int? selecionada,
    required ValueChanged<int> onChanged,
    required List<String> alternativas,
  }) {
    final escuro = Theme.of(context).brightness == Brightness.dark;
    final textoPrincipal = escuro ? Colors.white : Colors.black;
    final textoSecundario = escuro ? Colors.white70 : Colors.black54;

    return [
      Text(
        '$titulo  [ Múltipla Escolha ]',
        style: TextStyle(
          color: textoPrincipal,
          fontSize: 21,
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

  List<Widget> _conteudoReflexao(Color textoPrincipal, Color textoSecundario) {
    final corTema = Theme.of(context).colorScheme.primary;
    final campo = Theme.of(context).brightness == Brightness.dark
        ? const Color(0xFF171315)
        : const Color(0xFFF6F1E7);

    return [
      Text(
        'O que permanece com você?',
        style: TextStyle(
          color: textoPrincipal,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 10),
      Text(
        'Toda transformação começa quando você escolhe olhar para sua história de uma forma diferente, assume o protagonismo das suas decisões e acredita que pode evoluir todos os dias.',
        style: TextStyle(color: textoSecundario, fontSize: 15, height: 1.35),
      ),
      const SizedBox(height: 12),
      Text(
        'Qual ensinamento desta jornada teve o maior impacto na sua vida e como você pretende aplicá-lo daqui para frente?',
        style: TextStyle(
          color: corTema,
          fontSize: 16,
          height: 1.35,
          fontWeight: FontWeight.bold,
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
          style: TextStyle(color: textoPrincipal, fontSize: 16, height: 1.35),
          decoration: InputDecoration(
            hintText: 'O ensinamento que mais me marcou foi...',
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
    final respostaAtual = switch (etapaAtual) {
      1 => resposta1,
      2 => resposta2,
      3 => resposta3,
      _ => 0,
    };

    if (etapaAtual >= 1 && etapaAtual <= 3 && respostaAtual == null) {
      _mostrarPendencia('Escolha uma alternativa antes de avançar.');
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
        .doc('25')
        .set({
          'Acertos': acertos,
          'TotalQuestoes': 3,
          'ReflexaoFinal': reflexao,
          'RespondidoEm': FieldValue.serverTimestamp(),
        });

    if (!mounted) return;

    await _mostrarResultado(acertos);

    if (!mounted) return;

    Navigator.of(context).pop(true);
  }

  int _contarAcertos() {
    final respostas = [resposta1, resposta2, resposta3];
    var acertos = 0;
    for (int i = 0; i < respostas.length; i++) {
      if (respostas[i] == respostasCorretas[i]) acertos++;
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
              Icon(Icons.auto_awesome_rounded, color: corTema),
              const SizedBox(width: 8),
              const Text('Aprendizados revisitados'),
            ],
          ),
          content: Text(
            'Você acertou $acertos de 3. Mais importante que lembrar cada resposta é reconhecer o que essa jornada já transformou em você.',
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

    return Material(
      color: selecionada
          ? corTema.withAlpha(38)
          : Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF211D1F)
          : const Color(0xFFF6F1E7),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(13),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: selecionada ? corTema : Colors.transparent,
              width: 2,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: selecionada ? corTema : Colors.white12,
                foregroundColor: selecionada ? Colors.black : textoPrincipal,
                child: Text(
                  letra,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 11),
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
        style: TextStyle(color: color, fontSize: 16, height: 1.4),
      ),
    );
  }
}
