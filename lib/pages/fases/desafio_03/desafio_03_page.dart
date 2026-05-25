import 'package:flutter/material.dart';

import '../../../services/auth_service.dart';
import '../../../services/conteudos_service.dart';

class Desafio3Page extends StatefulWidget {
  const Desafio3Page({super.key});

  @override
  State<Desafio3Page> createState() => _Desafio3PageState();
}

class _Desafio3PageState extends State<Desafio3Page> {
  static const String _texto =
      'Oii {nome}, que bom ter voce aqui mais um dia!!!\n\n'
      'Refletiu sobre nossas ultimas atividades? Quais decisoes voce quer tomar?\n\n'
      'Voce vai continuar vivendo do jeito que ta ou vai buscar o conhecimento que te deixa mais seguro(a) e confiante nas suas escolhas?\n\n'
      'Estamos aqui para te mostrar que seu medo nao pode decidir seu futuro por voce. Voce pode continuar vivendo da mesma forma ou escolher o conhecimento que te torna mais seguro, consciente e assertivo nas suas decisoes.\n\n'
      'Pode deixar o medo decidir por voce ou finalmente enfrenta-lo para construir uma nova realidade.\n\n'
      'Toda mudanca comeca quando voce assume suas escolhas, aprende com o passado e decide parar de alimentar ciclos que te prendem no mesmo lugar.\n\n'
      'Se existe uma oportunidade de evoluir, crescer e transformar sua vida, por que continuar limitado pelas proprias certezas?\n\n'
      'Faca uma reflexao sobre duas decisoes e quais comportamentos voce precisa mudar.\n\n'
      'O primeiro passo para mudar o seu mundo e decidir que voce merece algo maior.\n\n'
      '"Quando voce decide mudar o seu mundo, voce muda O mundo!"\n\n'
      'Pense sobre isso e nos vemos amanha!!!';

  final TextEditingController reflexaoController = TextEditingController();
  String nomeUsuario = 'voce';
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
                          etapaAtual == 0 ? 'Texto inicial' : 'Reflexao',
                          style: TextStyle(color: textoSecundario),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    tooltip: 'Sair',
                    style: IconButton.styleFrom(
                      backgroundColor: const Color(0xFFFED23E),
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
                  valueColor: const AlwaysStoppedAnimation(Color(0xFFFED23E)),
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
                      color: const Color(0xFFFED23E).withAlpha(110),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: etapaAtual == 0
                        ? _conteudoTexto(textoSecundario)
                        : _conteudoReflexao(
                            textoPrincipal,
                            textoSecundario,
                          ),
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
                        side: const BorderSide(color: Color(0xFFFED23E)),
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
                        backgroundColor: const Color(0xFFFED23E),
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: etapaAtual == 0 ? _proximo : _concluir,
                      icon: Icon(
                        etapaAtual == 0
                            ? Icons.arrow_forward_rounded
                            : Icons.check_rounded,
                      ),
                      label: Text(etapaAtual == 0 ? 'Proximo' : 'Concluir'),
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
          child: Text(
            _texto.replaceAll('{nome}', nomeUsuario),
            style: TextStyle(
              color: textoSecundario,
              fontSize: 16,
              height: 1.35,
            ),
          ),
        ),
      ),
    ];
  }

  List<Widget> _conteudoReflexao(
    Color textoPrincipal,
    Color textoSecundario,
  ) {
    return [
      Text(
        'Sua reflexao',
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
          color: const Color(0xFFFED23E).withAlpha(38),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFFED23E)),
        ),
        child: const Text(
          '"Quando voce decide mudar o seu mundo, voce muda O mundo!"',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xFFFED23E),
            fontSize: 16,
            height: 1.3,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      const SizedBox(height: 16),
      Text(
        'Escreva sobre duas decisoes e quais comportamentos voce precisa mudar.',
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
          style: TextStyle(
            color: textoPrincipal,
            fontSize: 16,
            height: 1.35,
          ),
          decoration: InputDecoration(
            hintText:
                'Escreva sobre duas decisoes e os comportamentos que voce precisa mudar...',
            hintStyle: TextStyle(
              color: textoSecundario.withAlpha(140),
            ),
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
              borderSide: const BorderSide(
                color: Color(0xFFFED23E),
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
    if (reflexaoController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Escreva sua reflexao antes de concluir.')),
      );
      return;
    }

    await ConteudosService().salvarConteudosDoDesafio(
      desafio: 3,
      itens: [
        ConteudoItem(
          titulo: 'Reflexao sobre decisoes',
          texto: reflexaoController.text.trim(),
        ),
      ],
    );

    if (!mounted) return;
    Navigator.of(context).pop(true);
  }
}
