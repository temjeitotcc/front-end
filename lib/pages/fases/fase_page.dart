import 'package:flutter/material.dart';
import '../../services/conteudos_service.dart';
import 'desafio_01/desafio_01_page.dart';
import 'desafio_02/desafio_02_page.dart';
import 'desafio_03/desafio_03_page.dart';
import 'desafio_04/desafio_04_page.dart';
import 'desafio_05/desafio_05_page.dart';
import 'desafio_06/desafio_06_page.dart';
import 'desafio_07/desafio_07_page.dart';
import 'desafio_08/desafio_08_page.dart';
import 'desafio_09/desafio_09_page.dart';
import 'desafio_10/desafio_10_page.dart';
import 'desafio_11/desafio_11_page.dart';
import 'desafio_12/desafio_12_page.dart';
import 'desafio_13/desafio_13_page.dart';
import 'desafio_14/desafio_14_page.dart';

class FasePage extends StatelessWidget {
  final String numero;

  const FasePage({super.key, required this.numero});

  @override
  Widget build(BuildContext context) {
    final numeroInt = int.tryParse(numero) ?? 0;
    if (_missaoEspecial(numeroInt)) {
      return MissaoEspecialPage(numero: numeroInt);
    }

    return switch (numero) {
      '1' => const Desafio1Page(),
      '2' => const Desafio2Page(),
      '3' => const Desafio3Page(),
      '4' => const Desafio4Page(),
      '5' => const Desafio5Page(),
      '6' => const Desafio6Page(),
      '7' => const Desafio7Page(),
      '8' => const Desafio8Page(),
      '9' => const Desafio9Page(),
      '10' => const Desafio10Page(),
      '11' => const Desafio11Page(),
      '12' => const Desafio12Page(),
      '13' => const Desafio13Page(),
      '14' => const Desafio14Page(),
      _ => _DesafioPlaceholderPage(numero: numero),
    };
  }

  bool _missaoEspecial(int numero) {
    return numero == 21 || numero == 28;
  }
}

class MissaoEspecialPage extends StatefulWidget {
  final int numero;

  const MissaoEspecialPage({super.key, required this.numero});

  @override
  State<MissaoEspecialPage> createState() => _MissaoEspecialPageState();
}

class _MissaoEspecialPageState extends State<MissaoEspecialPage> {
  late final TextEditingController controller;

  int get reflexaoSemanaNumero {
    return switch (widget.numero) {
      7 => 1,
      14 => 2,
      21 => 3,
      28 => 4,
      _ => widget.numero,
    };
  }

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
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

    return Scaffold(
      backgroundColor: fundo,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 18, 18, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Reflexão da semana $reflexaoSemanaNumero',
                          style: TextStyle(
                            color: textoPrincipal,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Uma lembrança da sua semana',
                          style: TextStyle(color: textoSecundario),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    tooltip: 'Sair',
                    style: IconButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
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
                  value: 1,
                  minHeight: 10,
                  backgroundColor: Colors.white12,
                  valueColor: AlwaysStoppedAnimation(Theme.of(context).colorScheme.primary),
                ),
              ),
              const SizedBox(height: 22),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? const Color(0xFF2A2527)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.primary.withAlpha(130),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Icon(
                        Icons.auto_awesome_rounded,
                        color: Theme.of(context).colorScheme.primary,
                        size: 42,
                      ),
                      const SizedBox(height: 14),
                      Text(
                        'Escreva uma reflexão da semana para guardar.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: textoPrincipal,
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Depois essa mensagem vai aparecer numa caixinha própria do livrinho.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: textoSecundario,
                          fontSize: 14,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 18),
                      Expanded(
                        child: TextField(
                          controller: controller,
                          expands: true,
                          maxLines: null,
                          minLines: null,
                          textAlignVertical: TextAlignVertical.top,
                          style: TextStyle(
                            color: textoPrincipal,
                            fontSize: 16,
                            height: 1.35,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Minha reflexão da semana...',
                            hintStyle: TextStyle(
                              color: textoSecundario.withAlpha(140),
                            ),
                            filled: true,
                            fillColor:
                                Theme.of(context).brightness == Brightness.dark
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
                    ],
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
                        side: BorderSide(color: Theme.of(context).colorScheme.primary),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: () => Navigator.of(context).pop(false),
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
                      onPressed: _concluir,
                      icon: Icon(Icons.check_rounded),
                      label: Text('Concluir'),
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

  Future<void> _concluir() async {
    if (controller.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Escreva sua lembrança antes de concluir.'),
        ),
      );
      return;
    }

    await ConteudosService().salvarConteudosDoDesafio(
      desafio: widget.numero,
      itens: [
        ConteudoItem(
          titulo: 'Reflexão da semana $reflexaoSemanaNumero',
          texto: controller.text.trim(),
        ),
      ],
    );

    if (!mounted) return;
    Navigator.of(context).pop(true);
  }
}

class _DesafioPlaceholderPage extends StatelessWidget {
  final String numero;

  const _DesafioPlaceholderPage({required this.numero});

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
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Desafio $numero',
                          style: TextStyle(
                            color: textoPrincipal,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Em construção',
                          style: TextStyle(color: textoSecundario),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    tooltip: 'Sair',
                    style: IconButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
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
                  value: 1,
                  minHeight: 10,
                  backgroundColor: Colors.white12,
                  valueColor: AlwaysStoppedAnimation(Theme.of(context).colorScheme.primary),
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
                      color: Theme.of(context).colorScheme.primary.withAlpha(110),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'A pasta deste desafio já pode receber o código próprio depois.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: textoSecundario,
                        fontSize: 16,
                        height: 1.35,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: textoPrincipal,
                  side: BorderSide(color: Theme.of(context).colorScheme.primary),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: () => Navigator.of(context).pop(false),
                icon: Icon(Icons.arrow_back_rounded),
                label: Text('Voltar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
