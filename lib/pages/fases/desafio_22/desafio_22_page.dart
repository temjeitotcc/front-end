import 'package:flutter/material.dart';

import '../../../widgets/challenge_header_surface.dart';

import '../../../services/auth_service.dart';
import '../../../services/conteudos_service.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Desafio22Page extends StatefulWidget {
  const Desafio22Page({super.key});

  @override
  State<Desafio22Page> createState() => _Desafio22PageState();
}

class _Desafio22PageState extends State<Desafio22Page> {
  final TextEditingController padroesController = TextEditingController();
  final TextEditingController servirController = TextEditingController();
  final TextEditingController legadoController = TextEditingController();
  String nomeUsuario = 'você';
  int etapaAtual = 0;

  @override
  void initState() {
    super.initState();
    _carregarNome();
  }

  @override
  void dispose() {
    padroesController.dispose();
    servirController.dispose();
    legadoController.dispose();
    super.dispose();
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
    final textoPrincipal = tema.brightness == Brightness.dark
        ? Colors.white
        : Colors.black;
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
                                'Dia 22 - Responsabilidade e Propósito',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: textoPrincipal,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                _subtitulo(),
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
                      1 => _paginaEscrita(
                        titulo: 'Questão 1 - Minha história',
                        destaque:
                            '"Somos cegos conduzindo cegos" e fomos treinados para nos tornar suicidas emocionais sem perceber.',
                        perguntas: const [
                          'Em quais momentos você desistiu de sonhos, aceitou menos do que merecia ou limitou sua existência?',
                          'Quem ou quais situações treinaram esses padrões? Como você avalia a responsabilidade deles e a sua?',
                          'O que muda agora que você reconhece esses padrões?',
                        ],
                        controller: padroesController,
                        hint: 'Olho para a minha história e reconheço que...',
                        textoPrincipal: textoPrincipal,
                        textoSecundario: textoSecundario,
                      ),
                      2 => _paginaEscrita(
                        titulo: 'Questão 2 - Minha forma de servir',
                        destaque:
                            '"Nossa essência é servir, e servir com excelência é o que nos torna livres."',
                        perguntas: const [
                          'Como você serve hoje na família, nos estudos, no trabalho ou na comunidade?',
                          'Existe uma forma de servir que faz você se sentir mais vivo, útil e realizado?',
                          'Se sua forma de servir pudesse mudar a vida de alguém, o que faria diferente a partir de amanhã?',
                        ],
                        controller: servirController,
                        hint: 'Eu reconheço que minha forma de servir pode...',
                        textoPrincipal: textoPrincipal,
                        textoSecundario: textoSecundario,
                      ),
                      _ => _paginaFinal(textoPrincipal, textoSecundario),
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

  String _subtitulo() {
    return switch (etapaAtual) {
      0 => 'Coragem para enxergar e transformar',
      1 => 'Padrões e responsabilidade',
      2 => 'Servir com propósito',
      _ => 'Identidade e legado',
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
              _PurposeBanner(cor: corTema),
              const SizedBox(height: 16),
              Text(
                'Olá, $nomeUsuario! Estamos iniciando mais uma semana, que alegria!!!',
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
                    'Ao longo deste projeto, você refletiu sobre suas escolhas, suas feridas emocionais, seus sonhos, sua identidade e seu propósito.',
                color: textoSecundario,
              ),
              _Paragraph(
                text:
                    'Você compreendeu que muitas crenças, comportamentos e padrões foram construídos ao longo da vida sem que percebesse. Embora não sejamos responsáveis por tudo o que nos aconteceu, somos responsáveis pelo que escolhemos fazer a partir daquilo que aprendemos.',
                color: textoSecundario,
              ),
              _Paragraph(
                text:
                    'Hoje, o convite é para olhar sua história com sinceridade e sem julgamentos, compreendendo quais padrões precisam ser transformados e como sua vida pode gerar impacto positivo no mundo.',
                color: textoSecundario,
              ),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: corTema.withAlpha(30),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: corTema.withAlpha(120)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.self_improvement_rounded, color: corTema),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Reserve tempo e responda com profundidade. As respostas mais importantes são aquelas que revelam verdades para você.',
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

  List<Widget> _paginaEscrita({
    required String titulo,
    required String destaque,
    required List<String> perguntas,
    required TextEditingController controller,
    required String hint,
    required Color textoPrincipal,
    required Color textoSecundario,
  }) {
    final corTema = Theme.of(context).colorScheme.primary;
    return [
      Text(
        titulo,
        style: TextStyle(
          color: textoPrincipal,
          fontSize: 21,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 10),
      Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: corTema.withAlpha(30),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: corTema.withAlpha(120)),
        ),
        child: Text(
          destaque,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: corTema,
            fontSize: 14,
            height: 1.35,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      const SizedBox(height: 12),
      for (final pergunta in perguntas)
        Padding(
          padding: const EdgeInsets.only(bottom: 7),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.arrow_right_rounded, color: corTema, size: 20),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  pergunta,
                  style: TextStyle(
                    color: textoSecundario,
                    fontSize: 13,
                    height: 1.3,
                  ),
                ),
              ),
            ],
          ),
        ),
      const SizedBox(height: 6),
      Expanded(
        child: _ReflectionField(
          controller: controller,
          hint: hint,
          textoPrincipal: textoPrincipal,
          textoSecundario: textoSecundario,
          cor: corTema,
        ),
      ),
    ];
  }

  List<Widget> _paginaFinal(Color textoPrincipal, Color textoSecundario) {
    final corTema = Theme.of(context).colorScheme.primary;
    return [
      Text(
        'Quem você escolhe ser?',
        style: TextStyle(
          color: textoPrincipal,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 10),
      Text(
        'Reconhecer padrões não é motivo para culpa, mas uma oportunidade de crescimento. Descobrir formas de servir e contribuir dá mais significado à própria existência.',
        style: TextStyle(color: textoSecundario, fontSize: 15, height: 1.35),
      ),
      const SizedBox(height: 14),
      Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: corTema.withAlpha(34),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: corTema.withAlpha(150)),
        ),
        child: Text(
          'Mediante tudo o que aprendeu e entendeu até agora, quem você escolhe ser daqui para frente e qual legado deseja construir através da sua vida?',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: corTema,
            fontSize: 16,
            height: 1.35,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      const SizedBox(height: 14),
      Expanded(
        child: _ReflectionField(
          controller: legadoController,
          hint: 'Daqui para frente, eu escolho ser...',
          textoPrincipal: textoPrincipal,
          textoSecundario: textoSecundario,
          cor: corTema,
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
    if (etapaAtual == 1 && padroesController.text.trim().isEmpty) {
      _pendencia('Escreva sua reflexão sobre os padrões da sua história.');
      return;
    }
    if (etapaAtual == 2 && servirController.text.trim().isEmpty) {
      _pendencia('Escreva sua reflexão sobre sua forma de servir.');
      return;
    }
    setState(() => etapaAtual++);
  }

  Future<void> _concluir() async {
    if (legadoController.text.trim().isEmpty) {
      _pendencia(
        'Escreva quem você escolhe ser e o legado que deseja construir.',
      );
      return;
    }

    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return;

    final firestore = FirebaseFirestore.instance;

    // Salvar/atualizar dados do usuário
    await firestore.collection('usuarios').doc(user.uid).set({
      'nome': user.displayName ?? 'Usuário',
      'email': user.email,
    }, SetOptions(merge: true));

    // Salvar respostas do desafio
    await firestore
        .collection('usuarios')
        .doc(user.uid)
        .collection('desafios')
        .doc('22')
        .set({
          'MinhaHistoriaEPadroes': padroesController.text.trim(),
          'MinhaFormaDeServir': servirController.text.trim(),
          'QuemEscolhoSerEMeuLegado': legadoController.text.trim(),
          'RespondidoEm': FieldValue.serverTimestamp(),
        });

    if (!mounted) return;

    Navigator.of(context).pop(true);
  }

  void _pendencia(String mensagem) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(mensagem)));
  }
}

class _PurposeBanner extends StatelessWidget {
  final Color cor;

  const _PurposeBanner({required this.cor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cor.withAlpha(30),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: cor.withAlpha(150)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _BannerIcon(icon: Icons.history_edu_rounded, cor: cor),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Icon(Icons.arrow_forward_rounded, color: cor),
          ),
          _BannerIcon(icon: Icons.psychology_alt_rounded, cor: cor),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Icon(Icons.arrow_forward_rounded, color: cor),
          ),
          _BannerIcon(icon: Icons.flag_rounded, cor: cor),
        ],
      ),
    );
  }
}

class _BannerIcon extends StatelessWidget {
  final IconData icon;
  final Color cor;

  const _BannerIcon({required this.icon, required this.cor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(color: cor, shape: BoxShape.circle),
      child: Icon(icon, color: Colors.black, size: 27),
    );
  }
}

class _ReflectionField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final Color textoPrincipal;
  final Color textoSecundario;
  final Color cor;

  const _ReflectionField({
    required this.controller,
    required this.hint,
    required this.textoPrincipal,
    required this.textoSecundario,
    required this.cor,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      expands: true,
      maxLines: null,
      minLines: null,
      textAlignVertical: TextAlignVertical.top,
      style: TextStyle(color: textoPrincipal, fontSize: 16, height: 1.35),
      decoration: InputDecoration(
        hintText: hint,
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
          borderSide: BorderSide(color: cor, width: 2),
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
        style: TextStyle(color: color, fontSize: 16, height: 1.35),
      ),
    );
  }
}
