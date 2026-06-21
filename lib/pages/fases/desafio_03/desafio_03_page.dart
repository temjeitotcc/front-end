import 'package:flutter/material.dart';

import '../../../widgets/challenge_header_surface.dart';

import '../../../services/auth_service.dart';
import '../../../services/conteudos_service.dart';

import '../../../widgets/challenge_intro_decoration.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Desafio3Page extends StatefulWidget {
  const Desafio3Page({super.key});

  @override
  State<Desafio3Page> createState() => _Desafio3PageState();
}

class _Desafio3PageState extends State<Desafio3Page> {
  static const String _texto =
      'Oii {nome}, que bom ter você aqui mais um dia!!!\n\n'
      'Refletiu sobre nossas últimas atividades? Quais decisões você quer tomar?\n\n'
      'Você vai continuar vivendo do jeito que ta ou vai buscar o conhecimento que te deixa mais seguro(a) e confiante nas suas escolhas?\n\n'
      'Estamos aqui para te mostrar que seu medo não pode decidir seu futuro por você. Você podé continuar vivendo da mesma forma ou escolher o conhecimento que te torna mais seguro, consciente e assertivo nas suas decisões.\n\n'
      'Pode deixar o medo decidir por você ou finalmente enfrentá-lo para construir uma nova realidade.\n\n'
      'Toda mudança comeca quando você assume suas escolhas, aprende com o passado e decide parar de alimentar ciclos que te prendem no mesmo lugar.\n\n'
      'Se existe uma oportunidade de evoluir, crescer e transformar sua vida, por qué continuar limitado pelas próprias certezas?\n\n'
      'Faça uma reflexão sobre duas decisões e quais comportamentos você precisa mudar.\n\n'
      'O primeiro passo para mudar o seu mundo e decidir que você merece algo maior.\n\n'
      '"Quando você decide mudar o seu mundo, você muda O mundo!"\n\n'
      'Pense sobre isso e nos vemos amanhã!!!';

  final TextEditingController reflexaoController = TextEditingController();
  String nomeUsuario = 'você';
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
                                'Dia 3 - Eu escolho',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: textoPrincipal,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                etapaAtual == 0 ? 'Texto inicial' : 'Reflexão',
                                style: TextStyle(color: textoSecundario),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          tooltip: 'Sair',
                          style: IconButton.styleFrom(
                            backgroundColor: Theme.of(
                              context,
                            ).colorScheme.primary,
                            foregroundColor: Colors.black,
                          ),
                          onPressed: () => Navigator.of(context).pop(false),
                          icon: Icon(Icons.close_rounded),
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
                        valueColor: AlwaysStoppedAnimation(
                          Theme.of(context).colorScheme.primary,
                        ),
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
                    border: Border.all(
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withAlpha(110),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: etapaAtual == 0
                        ? _conteudoTexto(textoSecundario)
                        : _conteudoReflexao(textoPrincipal, textoSecundario),
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
                        side: BorderSide(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: _voltar,
                      icon: Icon(Icons.arrow_back_rounded),
                      label: Text('Voltar'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: etapaAtual == 0 ? _proximo : _concluir,
                      icon: Icon(
                        etapaAtual == 0
                            ? Icons.arrow_forward_rounded
                            : Icons.check_rounded,
                      ),
                      label: Text(etapaAtual == 0 ? 'Próximo' : 'Concluir'),
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

  List<Widget> _conteudoTexto(Color textoSecundario) {
    return [
      Expanded(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const ChallengeIntroDecoration(
                mainIcon: Icons.alt_route_rounded,
                leftIcon: Icons.balance_rounded,
                rightIcon: Icons.check_circle_outline_rounded,
                title: 'Toda escolha cria um caminho',
                subtitle:
                    'Reconheça seu poder de decisão e assuma sua direção.',
              ),
              const SizedBox(height: 16),
              Text(
                _texto.replaceAll('{nome}', nomeUsuario),
                style: TextStyle(
                  color: textoSecundario,
                  fontSize: 16,
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
      ),
    ];
  }

  List<Widget> _conteudoReflexao(Color textoPrincipal, Color textoSecundario) {
    return [
      Text(
        'Sua reflexão',
        style: TextStyle(
          color: textoPrincipal,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 12),
      Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary.withAlpha(38),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Theme.of(context).colorScheme.primary),
        ),
        child: Text(
          '"Quando você decide mudar o seu mundo, você muda O mundo!"',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontSize: 16,
            height: 1.3,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      const SizedBox(height: 16),
      Text(
        'Escreva sobre duas decisões e quais comportamentos você precisa mudar.',
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
                'Escreva sobre duas decisões e os comportamentos que você precisa mudar...',
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
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.primary,
                width: 2,
              ),
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

    setState(() {
      etapaAtual--;
    });
  }

  void _proximo() {
    setState(() {
      etapaAtual++;
    });
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

    // Salva/atualiza dados do usuário
    await firestore.collection('usuarios').doc(user.uid).set({
      'nome': user.displayName ?? 'Usuário',
      'email': user.email,
    }, SetOptions(merge: true));

    // Salva o desafio
    await firestore
        .collection('usuarios')
        .doc(user.uid)
        .collection('desafios')
        .doc('03')
        .set({
          'Reflexao': reflexao,
          'RespondidoEm': FieldValue.serverTimestamp(),
        });

    if (!mounted) return;
    Navigator.of(context).pop(true);
  }
}
