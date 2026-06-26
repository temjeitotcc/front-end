import 'package:flutter/material.dart';

import '../../../services/firebase_desafios_service.dart';
import '../../../widgets/main_tab_header.dart';
import '../conteudos_utils.dart';
import '../../../services/conteudos_service.dart';

class DesafiosFeitosPage extends StatefulWidget {
  static const List<int> missoesEspeciais = [7, 14, 21, 28];
  static const Set<int> desafiosComAtividadeSalva = {2, 22, 26};

  const DesafiosFeitosPage({super.key});

  @override
  State<DesafiosFeitosPage> createState() => _DesafiosFeitosPageState();
}

class _DesafiosFeitosPageState extends State<DesafiosFeitosPage> {
  Map<int, ConteudoDesafio> conteudos = {};
  bool carregando = true;

  @override
  void initState() {
    super.initState();
    carregarConteudos();
  }

  Future<void> carregarConteudos() async {
    final dados = await FirebaseDesafiosService().carregarConteudos();

    if (!mounted) return;

    setState(() {
      conteudos = dados;
      carregando = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final fundo = Theme.of(context).scaffoldBackgroundColor;
    final numeros = visualizarTodosDesafiosFeitos
        ? [
            for (int numero = 1; numero <= 28; numero++)
              if (!DesafiosFeitosPage.missoesEspeciais.contains(numero))
                numero,
          ]
        : (conteudos.entries
              .where(
                (entry) =>
                    !DesafiosFeitosPage.missoesEspeciais.contains(entry.key) &&
                    conteudoDisponivelParaExibicao(entry.key, entry.value),
              )
              .map((entry) => entry.key)
              .toList()
            ..sort());

    return Scaffold(
      backgroundColor: fundo,
      body: Column(
        children: [
          MainTabHeader(
            title: 'Desafios feitos',
            subtitle: 'Relembre respostas, escolhas e aprendizados',
            leading: const Icon(
              Icons.arrow_back_rounded,
              color: Colors.white,
              size: 30,
            ),
            onLeadingTap: () => Navigator.of(context).pop(),
            trailing: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(35),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.auto_stories_rounded,
                color: Colors.white,
                size: 23,
              ),
            ),
          ),
          Expanded(
            child: carregando
                ? Center(
                    child: CircularProgressIndicator(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  )
                : numeros.isEmpty
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: Text(
                        'Suas reflexões dos desafios aparecerão aqui.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white60, fontSize: 16),
                      ),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(14, 18, 14, 24),
                    itemCount: numeros.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final numero = numeros[index];
                      final conteudoCompleto = conteudos[numero];
                      final conteudo = conteudoCompleto;
                      final temConteudo =
                          conteudoCompleto != null &&
                          conteudoDisponivelParaExibicao(
                            numero,
                            conteudoCompleto,
                          ) &&
                          conteudo != null &&
                          conteudo.itens.isNotEmpty;

                      return ListTile(
                        onTap: temConteudo
                            ? () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => ConteudoDesafioPage(
                                      conteudo: conteudo,
                                    ),
                                  ),
                                );
                              }
                            : null,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(
                            color: temConteudo
                                ? Theme.of(context).colorScheme.primary
                                : Colors.white.withAlpha(26),
                          ),
                        ),
                        tileColor: temConteudo
                            ? const Color(0xFF2A2527)
                            : const Color(0xFF211D1F),
                        leading: CircleAvatar(
                          backgroundColor: temConteudo
                              ? Theme.of(context).colorScheme.primary
                              : Colors.white12,
                          foregroundColor: temConteudo
                              ? Colors.black
                              : Colors.white54,
                          child: Text('$numero'),
                        ),
                        title: Text(
                          temConteudo ? tituloDesafio(numero) : 'Dia $numero',
                          style: TextStyle(
                            color: temConteudo ? Colors.white : Colors.white54,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: temConteudo
                            ? Text(
                                '${conteudo.itens.length} resposta(s) salva(s)',
                                style: const TextStyle(color: Colors.white60),
                              )
                            : null,
                        trailing: Icon(
                          temConteudo
                              ? Icons.chevron_right_rounded
                              : Icons.visibility_outlined,
                          color: temConteudo
                              ? Theme.of(context).colorScheme.primary
                              : Colors.white38,
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class ConteudoDesafioPage extends StatelessWidget {
  final ConteudoDesafio conteudo;

  const ConteudoDesafioPage({super.key, required this.conteudo});

  @override
  Widget build(BuildContext context) {
    if (conteudo.desafio == 2) {
      return ConteudoDesafio2Page(conteudo: conteudo);
    }

    final fundo = Theme.of(context).scaffoldBackgroundColor;

    return Scaffold(
      backgroundColor: fundo,
      body: Column(
        children: [
          MainTabHeader(
            title: 'Dia ${conteudo.desafio}',
            subtitle: temaDesafio(conteudo.desafio),
            leading: const Icon(
              Icons.arrow_back_rounded,
              color: Colors.white,
              size: 30,
            ),
            onLeadingTap: () => Navigator.of(context).pop(),
            trailing: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(35),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.bookmark_added_rounded,
                color: Colors.white,
                size: 23,
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 18, 16, 26),
              itemCount: conteudo.itens.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final item = conteudo.itens[index];

                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2A2527),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withAlpha(120),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.titulo,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        item.texto,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          height: 1.35,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Row(
                        children: [
                          Icon(
                            Icons.lock_rounded,
                            color: Colors.white38,
                            size: 15,
                          ),
                          SizedBox(width: 6),
                          Text(
                            'Lembrança salva',
                            style: TextStyle(
                              color: Colors.white38,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ConteudoDesafio2Page extends StatelessWidget {
  final ConteudoDesafio conteudo;

  const ConteudoDesafio2Page({super.key, required this.conteudo});

  List<String> get areasPredio => const [
    'Futuro',
    'Espiritual',
    'Emocional',
    'Solidariedade',
    'Intelectual',
    'Profissional',
    'Social',
    'Saude',
    'Familiar',
    'Relacional',
  ];

  @override
  Widget build(BuildContext context) {
    final fundo = Theme.of(context).scaffoldBackgroundColor;
    final textos = {for (final item in conteudo.itens) item.titulo: item.texto};

    return Scaffold(
      backgroundColor: fundo,
      body: Column(
        children: [
          MainTabHeader(
            title: 'Dia 2',
            subtitle: temaDesafio(2),
            leading: const Icon(
              Icons.arrow_back_rounded,
              color: Colors.white,
              size: 30,
            ),
            onLeadingTap: () => Navigator.of(context).pop(),
            trailing: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(35),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.apartment_rounded,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 18, 16, 22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Prédio da vida',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Toque em uma janela para rever a lembrança salva.',
                    style: TextStyle(color: Colors.white60, fontSize: 14),
                  ),
                  const SizedBox(height: 14),
                  Expanded(
                    child: Center(
                      child: _PredioConteudo(
                        areas: areasPredio,
                        textos: textos,
                        onJanelaTap: (area) {
                          _abrirLeitura(context, area, textos[area] ?? '');
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _abrirLeitura(BuildContext context, String titulo, String texto) {
    showDialog<void>(
      context: context,
      barrierColor: Colors.black.withAlpha(130),
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 18),
          child: Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xFF2A2527),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: Theme.of(context).colorScheme.primary,
                width: 2,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        titulo,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      tooltip: 'Fechar',
                      style: IconButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Colors.black,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                      icon: Icon(Icons.close_rounded),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  constraints: const BoxConstraints(maxHeight: 330),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFF171315),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: SingleChildScrollView(
                    child: Text(
                      texto.trim().isEmpty
                          ? 'Nenhuma lembrança foi escrita nessa janela.'
                          : texto,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        height: 1.35,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const Row(
                  children: [
                    Icon(Icons.lock_rounded, color: Colors.white38, size: 15),
                    SizedBox(width: 6),
                    Text(
                      'Somente leitura',
                      style: TextStyle(color: Colors.white38, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _PredioConteudo extends StatelessWidget {
  final List<String> areas;
  final Map<String, String> textos;
  final ValueChanged<String> onJanelaTap;

  const _PredioConteudo({
    required this.areas,
    required this.textos,
    required this.onJanelaTap,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 0.74,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final largura = constraints.maxWidth;
          final altura = constraints.maxHeight;
          final predioLargura = largura * 0.50;
          final predioEsquerda = (largura - predioLargura) / 2;
          final andarAltura = altura * 0.16;
          final topo = altura * 0.07;
          final janela = largura * 0.145;
          final espacamentoJanela = largura * 0.055;
          final corpoAltura = andarAltura * 5 + altura * 0.16;

          return Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF3C4),
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
              ),
              Positioned(
                left: predioEsquerda,
                top: topo + altura * 0.02,
                width: predioLargura,
                height: corpoAltura,
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xFF263238),
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(18),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: predioEsquerda + predioLargura * 0.10,
                top: topo - altura * 0.02,
                width: predioLargura * 0.80,
                height: altura * 0.055,
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xFF263238),
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(12),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: predioEsquerda + predioLargura * 0.33,
                bottom: 0,
                width: predioLargura * 0.34,
                height: altura * 0.18,
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF6D4C41),
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.primary,
                      width: 2,
                    ),
                  ),
                  child: Align(
                    alignment: const Alignment(0.55, -0.10),
                    child: Container(
                      width: 7,
                      height: 7,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: largura * 0.02,
                right: largura * 0.02,
                bottom: 0,
                height: 3,
                child: Container(color: const Color(0xFF263238)),
              ),
              for (int andar = 0; andar < 5; andar++) ...[
                _AreaConteudoLabel(
                  text: areas[andar * 2],
                  left: 0,
                  top: topo + andar * andarAltura + janela * 0.22,
                  alignRight: true,
                  width: predioEsquerda - 10,
                ),
                _AreaConteudoLabel(
                  text: areas[andar * 2 + 1],
                  left: predioEsquerda + predioLargura + 10,
                  top: topo + andar * andarAltura + janela * 0.22,
                  alignRight: false,
                  width: predioEsquerda - 10,
                ),
                for (int coluna = 0; coluna < 2; coluna++)
                  Positioned(
                    left:
                        predioEsquerda +
                        (predioLargura - (janela * 2 + espacamentoJanela)) / 2 +
                        coluna * (janela + espacamentoJanela),
                    top: topo + andar * andarAltura,
                    width: janela,
                    height: janela,
                    child: _JanelaConteudo(
                      preenchida:
                          (textos[areas[andar * 2 + coluna]] ?? '').isNotEmpty,
                      onTap: () => onJanelaTap(areas[andar * 2 + coluna]),
                    ),
                  ),
              ],
            ],
          );
        },
      ),
    );
  }
}

class _AreaConteudoLabel extends StatelessWidget {
  final String text;
  final double left;
  final double top;
  final double width;
  final bool alignRight;

  const _AreaConteudoLabel({
    required this.text,
    required this.left,
    required this.top,
    required this.width,
    required this.alignRight,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: left,
      top: top,
      width: width,
      child: Text(
        text.toUpperCase(),
        textAlign: alignRight ? TextAlign.right : TextAlign.left,
        maxLines: 2,
        softWrap: true,
        style: TextStyle(
          color: Color(0xFF263238),
          fontSize: 10,
          height: 1.05,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _JanelaConteudo extends StatelessWidget {
  final bool preenchida;
  final VoidCallback onTap;

  const _JanelaConteudo({required this.preenchida, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: preenchida
              ? Theme.of(context).colorScheme.secondary
              : Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: preenchida ? Colors.white : Colors.transparent,
            width: 3,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(55),
              blurRadius: 7,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Icon(
          preenchida ? Icons.visibility_rounded : Icons.remove_red_eye_outlined,
          color: const Color(0xFF263238),
          size: 22,
        ),
      ),
    );
  }
}
