import 'package:flutter/material.dart';

import '../../services/conteudos_service.dart';

class ConteudosPage extends StatefulWidget {
  final int refreshKey;

  const ConteudosPage({
    super.key,
    required this.refreshKey,
  });

  @override
  State<ConteudosPage> createState() => _ConteudosPageState();
}

class _ConteudosPageState extends State<ConteudosPage> {
  final ConteudosService service = ConteudosService();
  static const List<int> missoesEspeciais = [7, 14, 21, 28];
  Map<int, ConteudoDesafio> conteudos = {};

  @override
  void initState() {
    super.initState();
    carregarConteudos();
  }

  @override
  void didUpdateWidget(covariant ConteudosPage oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.refreshKey != widget.refreshKey) {
      carregarConteudos();
    }
  }

  Future<void> carregarConteudos() async {
    final dados = await service.carregarConteudos();
    if (!mounted) return;

    setState(() {
      conteudos = dados;
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
    final desafiosSalvos = conteudos.keys
        .where((numero) => !missoesEspeciais.contains(numero))
        .length;
    final especiaisSalvas = conteudos.keys
        .where((numero) => missoesEspeciais.contains(numero))
        .length;

    return Scaffold(
      backgroundColor: fundo,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 22),
              decoration: const BoxDecoration(
                color: Color(0xFFFED23E),
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(28),
                ),
              ),
              child: Row(
                children: [
                  Image.asset('assets/icon2.png', height: 42),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Conteudos',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14, 18, 14, 18),
                child: GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1.06,
                  children: [
                    _ConteudoCard(
                      titulo: 'Desafios feitos',
                      subtitulo: '$desafiosSalvos salvos',
                      icon: Icons.menu_book_rounded,
                      onTap: () async {
                        await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => DesafiosFeitosPage(
                              conteudos: conteudos,
                            ),
                          ),
                        );
                        carregarConteudos();
                      },
                    ),
                    _ConteudoCard(
                      titulo: 'Reflexão da semana',
                      subtitulo: '$especiaisSalvas salvas',
                      icon: Icons.auto_awesome_rounded,
                      onTap: () async {
                        await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => MissoesEspeciaisPage(
                              conteudos: conteudos,
                            ),
                          ),
                        );
                        carregarConteudos();
                      },
                    ),
                    for (int i = 3; i <= 6; i++)
                      _ConteudoCard(
                        titulo: 'Espaco $i',
                        subtitulo: 'Em breve',
                        icon: Icons.bookmark_rounded,
                        onTap: () {},
                        apagado: true,
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ConteudoCard extends StatelessWidget {
  final String titulo;
  final String subtitulo;
  final IconData icon;
  final VoidCallback onTap;
  final bool apagado;

  const _ConteudoCard({
    required this.titulo,
    required this.subtitulo,
    required this.icon,
    required this.onTap,
    this.apagado = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: apagado ? const Color(0xFF3A3436) : const Color(0xFF2A2527),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: apagado
                ? Colors.white.withAlpha(24)
                : const Color(0xFFFED23E).withAlpha(170),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(35),
              blurRadius: 10,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: const BoxDecoration(
                color: Color(0xFFFED23E),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.black),
            ),
            const Spacer(),
            Text(
              titulo,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitulo,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.white60, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}

class DesafiosFeitosPage extends StatelessWidget {
  final Map<int, ConteudoDesafio> conteudos;
  static const List<int> missoesEspeciais = [7, 14, 21, 28];

  const DesafiosFeitosPage({
    super.key,
    required this.conteudos,
  });

  @override
  Widget build(BuildContext context) {
    final fundo = Theme.of(context).scaffoldBackgroundColor;

    return Scaffold(
      backgroundColor: fundo,
      appBar: AppBar(
        backgroundColor: const Color(0xFFFED23E),
        foregroundColor: Colors.black,
        title: const Text('Desafios feitos'),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.fromLTRB(14, 16, 14, 24),
        itemCount: 24,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          final numeros = [
            for (int numero = 1; numero <= 28; numero++)
              if (!missoesEspeciais.contains(numero)) numero,
          ];
          final numero = numeros[index];
          final conteudo = conteudos[numero];
          final temConteudo = conteudo != null && conteudo.itens.isNotEmpty;

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
                    ? const Color(0xFFFED23E)
                    : Colors.white.withAlpha(20),
              ),
            ),
            tileColor:
                temConteudo ? const Color(0xFF2A2527) : const Color(0xFF211D1F),
            leading: CircleAvatar(
              backgroundColor:
                  temConteudo ? const Color(0xFFFED23E) : Colors.white24,
              foregroundColor: temConteudo ? Colors.black : Colors.white60,
              child: Text('$numero'),
            ),
            title: Text(
              'Desafio $numero',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              temConteudo
                  ? '${conteudo.itens.length} lembranca(s) salva(s)'
                  : 'Nada escrito ainda',
              style: const TextStyle(color: Colors.white60),
            ),
            trailing: Icon(
              temConteudo
                  ? Icons.chevron_right_rounded
                  : Icons.lock_outline_rounded,
              color: temConteudo ? const Color(0xFFFED23E) : Colors.white38,
            ),
          );
        },
      ),
    );
  }
}

class MissoesEspeciaisPage extends StatelessWidget {
  final Map<int, ConteudoDesafio> conteudos;
  static const List<int> missoesEspeciais = [7, 14, 21, 28];

  const MissoesEspeciaisPage({
    super.key,
    required this.conteudos,
  });

  @override
  Widget build(BuildContext context) {
    final fundo = Theme.of(context).scaffoldBackgroundColor;

    return Scaffold(
      backgroundColor: fundo,
      appBar: AppBar(
        backgroundColor: const Color(0xFFFED23E),
        foregroundColor: Colors.black,
        title: const Text('Reflexões da semana'),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.fromLTRB(14, 16, 14, 24),
        itemCount: missoesEspeciais.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          final numero = missoesEspeciais[index];
          final numeroSemana = index + 1;
          final conteudo = conteudos[numero];
          final temConteudo = conteudo != null && conteudo.itens.isNotEmpty;

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
                    ? const Color(0xFFFED23E)
                    : Colors.white.withAlpha(20),
              ),
            ),
            tileColor:
                temConteudo ? const Color(0xFF2A2527) : const Color(0xFF211D1F),
            leading: CircleAvatar(
              backgroundColor:
                  temConteudo ? const Color(0xFFFED23E) : Colors.white24,
              foregroundColor: Colors.black,
              child: const Icon(Icons.auto_awesome_rounded),
            ),
            title: Text(
              'Reflexão da semana $numeroSemana',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              temConteudo ? 'Lembranca salva' : 'Nada escrito ainda',
              style: const TextStyle(color: Colors.white60),
            ),
            trailing: Icon(
              temConteudo
                  ? Icons.chevron_right_rounded
                  : Icons.lock_outline_rounded,
              color: temConteudo ? const Color(0xFFFED23E) : Colors.white38,
            ),
          );
        },
      ),
    );
  }
}

class ConteudoDesafioPage extends StatelessWidget {
  final ConteudoDesafio conteudo;

  const ConteudoDesafioPage({
    super.key,
    required this.conteudo,
  });

  @override
  Widget build(BuildContext context) {
    if (conteudo.desafio == 2) {
      return ConteudoDesafio2Page(conteudo: conteudo);
    }

    final fundo = Theme.of(context).scaffoldBackgroundColor;

    return Scaffold(
      backgroundColor: fundo,
      appBar: AppBar(
        backgroundColor: const Color(0xFFFED23E),
        foregroundColor: Colors.black,
        title: Text('Desafio ${conteudo.desafio}'),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 26),
        itemCount: conteudo.itens.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final item = conteudo.itens[index];

          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF2A2527),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: const Color(0xFFFED23E).withAlpha(120),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.titulo,
                  style: const TextStyle(
                    color: Color(0xFFFED23E),
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
                      'Lembranca salva',
                      style: TextStyle(color: Colors.white38, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class ConteudoDesafio2Page extends StatelessWidget {
  final ConteudoDesafio conteudo;

  const ConteudoDesafio2Page({
    super.key,
    required this.conteudo,
  });

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
    final textos = {
      for (final item in conteudo.itens) item.titulo: item.texto,
    };

    return Scaffold(
      backgroundColor: fundo,
      appBar: AppBar(
        backgroundColor: const Color(0xFFFED23E),
        foregroundColor: Colors.black,
        title: const Text('Desafio 2'),
      ),
      body: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 18, 16, 22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Predio da vida',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Toque em uma janela para rever a lembranca salva.',
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
              border: Border.all(color: const Color(0xFFFED23E), width: 2),
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
                        style: const TextStyle(
                          color: Color(0xFFFED23E),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      tooltip: 'Fechar',
                      style: IconButton.styleFrom(
                        backgroundColor: const Color(0xFFFED23E),
                        foregroundColor: Colors.black,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close_rounded),
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
                          ? 'Nenhuma lembranca foi escrita nessa janela.'
                          : texto,
                      style: const TextStyle(
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
                    Icon(
                      Icons.lock_rounded,
                      color: Colors.white38,
                      size: 15,
                    ),
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
                  decoration: const BoxDecoration(
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
                  decoration: const BoxDecoration(
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
                    border: Border.all(color: const Color(0xFFFED23E), width: 2),
                  ),
                  child: Align(
                    alignment: const Alignment(0.55, -0.10),
                    child: Container(
                      width: 7,
                      height: 7,
                      decoration: const BoxDecoration(
                        color: Color(0xFFFED23E),
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
                    left: predioEsquerda +
                        (predioLargura -
                                (janela * 2 + espacamentoJanela)) /
                            2 +
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
        style: const TextStyle(
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

  const _JanelaConteudo({
    required this.preenchida,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: preenchida ? const Color(0xFFFFE58A) : const Color(0xFFFED23E),
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
