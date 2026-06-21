import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../services/auth_service.dart';
import '../../../services/conteudos_service.dart';
import '../../../widgets/challenge_header_surface.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Desafio24Page extends StatefulWidget {
  const Desafio24Page({super.key});

  @override
  State<Desafio24Page> createState() => _Desafio24PageState();
}

class _Desafio24PageState extends State<Desafio24Page> {
  static final Uri _testeUrl = Uri.parse(
    'https://testelinguagensdeamor.lovable.app/',
  );

  final TextEditingController reflexaoController = TextEditingController();

  String nomeUsuario = 'Usuário';
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
    setState(() => nomeUsuario = nome);
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final corTema = tema.colorScheme.primary;
    final escuro = tema.brightness == Brightness.dark;
    final textoPrincipal = escuro ? Colors.white : Colors.black;
    final textoSecundario = escuro ? Colors.white70 : Colors.black54;
    final cardColor = escuro ? const Color(0xFF2A2527) : Colors.white;

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
                                'Dia 24',
                                style: TextStyle(
                                  color: textoSecundario,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Atividade: As 5 Linguagens do Amor',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: textoPrincipal,
                                  fontSize: 22,
                                  height: 1.08,
                                  fontWeight: FontWeight.w900,
                                ),
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
                        value: (etapaAtual + 1) / 2,
                        minHeight: 10,
                        backgroundColor: Colors.white12,
                        valueColor: AlwaysStoppedAnimation(corTema),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: corTema.withAlpha(120)),
                  ),
                  child: etapaAtual == 0
                      ? _paginaTeste(textoPrincipal, textoSecundario, corTema)
                      : _paginaReflexao(
                          textoPrincipal,
                          textoSecundario,
                          corTema,
                        ),
                ),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  if (etapaAtual > 0) ...[
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => setState(() => etapaAtual = 0),
                        icon: const Icon(Icons.arrow_back_rounded),
                        label: const Text('VOLTAR'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: textoPrincipal,
                          side: BorderSide(color: corTema),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                  ],
                  Expanded(
                    flex: etapaAtual == 0 ? 1 : 2,
                    child: ElevatedButton.icon(
                      onPressed: etapaAtual == 0
                          ? () => setState(() => etapaAtual = 1)
                          : _concluir,
                      icon: Icon(
                        etapaAtual == 0
                            ? Icons.arrow_forward_rounded
                            : Icons.check_rounded,
                      ),
                      label: Text(etapaAtual == 0 ? 'REFLETIR' : 'CONCLUIR'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: corTema,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        textStyle: const TextStyle(fontWeight: FontWeight.w900),
                      ),
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

  Widget _paginaTeste(
    Color textoPrincipal,
    Color textoSecundario,
    Color corTema,
  ) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _LoveLanguagesBanner(cor: corTema),
          const SizedBox(height: 18),
          Text(
            'Olá, $nomeUsuario! Estamos muito alegres com a sua evolução. Vamos para mais um dia?',
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
                'Ontem aprendemos sobre as 5 Linguagens do Amor e entendemos que cada pessoa possui uma forma única de demonstrar carinho, afeto e conexão.',
            color: textoSecundario,
          ),
          _Paragraph(
            text:
                'Muitas vezes os conflitos e desencontros nos relacionamentos acontecem não por falta de amor, mas porque cada um expressa e recebe amor de maneiras diferentes.',
            color: textoSecundario,
          ),
          _Paragraph(
            text:
                'Conhecer sua própria linguagem do amor é um passo importante para desenvolver relacionamentos mais saudáveis, fortalecer vínculos e melhorar a comunicação.',
            color: textoSecundario,
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: corTema.withAlpha(30),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: corTema.withAlpha(120)),
            ),
            child: Row(
              children: [
                Icon(Icons.link_rounded, color: corTema, size: 28),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Clique no botão abaixo e responda ao teste para descobrir sua principal linguagem do amor.',
                    style: TextStyle(
                      color: textoPrincipal,
                      fontSize: 14,
                      height: 1.35,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 54,
            child: ElevatedButton.icon(
              onPressed: _abrirTeste,
              icon: const Icon(Icons.open_in_new_rounded),
              label: const Text('ABRIR TESTE'),
              style: ElevatedButton.styleFrom(
                backgroundColor: corTema,
                foregroundColor: Colors.black,
                textStyle: const TextStyle(fontWeight: FontWeight.w900),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _paginaReflexao(
    Color textoPrincipal,
    Color textoSecundario,
    Color corTema,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Depois do resultado',
          style: TextStyle(
            color: textoPrincipal,
            fontSize: 22,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'Ao finalizar, reflita sobre o resultado:',
          style: TextStyle(color: textoSecundario, fontSize: 15, height: 1.35),
        ),
        const SizedBox(height: 12),
        _Question(text: 'Você se identificou com a linguagem apontada?'),
        _Question(text: 'Como ela aparece nos seus relacionamentos?'),
        _Question(
          text:
              'Existe alguém próximo que demonstra amor de uma forma diferente da sua?',
        ),
        const SizedBox(height: 12),
        Expanded(
          child: TextField(
            controller: reflexaoController,
            expands: true,
            maxLines: null,
            minLines: null,
            textAlignVertical: TextAlignVertical.top,
            textCapitalization: TextCapitalization.sentences,
            style: TextStyle(color: textoPrincipal, fontSize: 16, height: 1.35),
            decoration: InputDecoration(
              hintText: 'Minha reflexão sobre minha linguagem do amor...',
              hintStyle: TextStyle(color: textoSecundario.withAlpha(150)),
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
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.all(13),
          decoration: BoxDecoration(
            color: corTema.withAlpha(28),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: corTema.withAlpha(100)),
          ),
          child: Text(
            'Quando entendemos melhor a nós mesmos, também aprendemos a compreender e amar melhor as outras pessoas.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: textoPrincipal,
              fontSize: 14,
              height: 1.35,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _abrirTeste() async {
    final abriu = await launchUrl(
      _testeUrl,
      mode: LaunchMode.externalApplication,
    );

    if (!abriu && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Não foi possível abrir o link do teste.'),
        ),
      );
    }
  }

  Future<void> _concluir() async {
    final reflexao = reflexaoController.text.trim();

    if (reflexao.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Escreva sua reflexão antes de concluir.'),
        ),
      );
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final firestore = FirebaseFirestore.instance;

    // Salvar/atualizar usuário
    await firestore.collection('usuarios').doc(user.uid).set({
      'nome': user.displayName ?? 'Usuário',
      'email': user.email,
    }, SetOptions(merge: true));

    // Salvar no Firestore
    await firestore
        .collection('usuarios')
        .doc(user.uid)
        .collection('desafios')
        .doc('24')
        .set({
          'ReflexaoSobreMinhaLinguagemDoAmor': reflexao,
          'RespondidoEm': FieldValue.serverTimestamp(),
        });

    if (!mounted) return;
    Navigator.of(context).pop(true);
  }
}

class _LoveLanguagesBanner extends StatelessWidget {
  final Color cor;

  const _LoveLanguagesBanner({required this.cor});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 136,
      decoration: BoxDecoration(
        color: cor.withAlpha(28),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: cor.withAlpha(105)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: const [
          _LanguageIcon(icon: Icons.chat_bubble_outline_rounded),
          _LanguageIcon(icon: Icons.schedule_rounded),
          _LanguageIcon(icon: Icons.card_giftcard_rounded),
          _LanguageIcon(icon: Icons.volunteer_activism_rounded),
          _LanguageIcon(icon: Icons.favorite_rounded),
        ],
      ),
    );
  }
}

class _LanguageIcon extends StatelessWidget {
  final IconData icon;

  const _LanguageIcon({required this.icon});

  @override
  Widget build(BuildContext context) {
    final cor = Theme.of(context).colorScheme.primary;
    return Container(
      width: 46,
      height: 46,
      decoration: BoxDecoration(
        color: cor.withAlpha(45),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: cor, size: 24),
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
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        text,
        style: TextStyle(color: color, fontSize: 15, height: 1.45),
      ),
    );
  }
}

class _Question extends StatelessWidget {
  final String text;

  const _Question({required this.text});

  @override
  Widget build(BuildContext context) {
    final cor = Theme.of(context).colorScheme.primary;
    final texto = Theme.of(context).brightness == Brightness.dark
        ? Colors.white70
        : Colors.black54;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.arrow_right_rounded, color: cor, size: 21),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              text,
              style: TextStyle(color: texto, fontSize: 14, height: 1.32),
            ),
          ),
        ],
      ),
    );
  }
}
