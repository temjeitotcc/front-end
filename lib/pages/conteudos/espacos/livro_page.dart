import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

import '../../../widgets/main_tab_header.dart';

const String _livroAsset = 'assets/livro_tem_jeito_e_vale_a_pena.pdf';
const String _livroTitulo = 'Tem Jeito e Vale a Pena';

class LivroConteudoPage extends StatefulWidget {
  const LivroConteudoPage({super.key});

  @override
  State<LivroConteudoPage> createState() => _LivroConteudoPageState();
}

class _LivroConteudoPageState extends State<LivroConteudoPage> {
  bool baixando = false;

  @override
  Widget build(BuildContext context) {
    final escuro = Theme.of(context).brightness == Brightness.dark;
    final fundo = Theme.of(context).scaffoldBackgroundColor;
    final corTema = Theme.of(context).colorScheme.primary;
    final textoPrincipal = escuro ? Colors.white : Colors.black87;
    final textoSecundario = escuro ? Colors.white60 : Colors.black54;
    final cardColor = escuro ? const Color(0xFF2A2527) : Colors.white;

    return Scaffold(
      backgroundColor: fundo,
      body: Column(
        children: [
          MainTabHeader(
            title: 'Livro',
            subtitle: 'A base desta jornada de transformação',
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
                size: 24,
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 22, 16, 30),
              children: [
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: corTema.withAlpha(135)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(30),
                        blurRadius: 14,
                        offset: const Offset(0, 7),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        constraints: const BoxConstraints(minHeight: 245),
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: corTema.withAlpha(32),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: corTema.withAlpha(85)),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 92,
                              height: 116,
                              decoration: BoxDecoration(
                                color: corTema,
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withAlpha(55),
                                    blurRadius: 12,
                                    offset: const Offset(0, 7),
                                  ),
                                ],
                              ),
                              child: Stack(
                                children: [
                                  Positioned(
                                    left: 9,
                                    top: 0,
                                    bottom: 0,
                                    child: Container(
                                      width: 2,
                                      color: Colors.white.withAlpha(95),
                                    ),
                                  ),
                                  const Center(
                                    child: Icon(
                                      Icons.menu_book_rounded,
                                      color: Colors.white,
                                      size: 45,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              _livroTitulo,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: textoPrincipal,
                                fontSize: 22,
                                height: 1.15,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            const SizedBox(height: 7),
                            Text(
                              'LIVRO COMPLETO • PDF',
                              style: TextStyle(
                                color: corTema,
                                fontSize: 11,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Aqui você encontra o livro no qual todo o aplicativo '
                        'foi baseado.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: textoPrincipal,
                          fontSize: 17,
                          height: 1.4,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Leia com calma, revisite os conceitos dos desafios e '
                        'guarde uma cópia para continuar sua jornada.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: textoSecundario,
                          fontSize: 14,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 22),
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const LeitorLivroPage(),
                              ),
                            );
                          },
                          icon: const Icon(Icons.chrome_reader_mode_rounded),
                          label: const Text('LER LIVRO'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: corTema,
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            textStyle: const TextStyle(
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: OutlinedButton.icon(
                          onPressed: baixando ? null : _baixarLivro,
                          icon: baixando
                              ? const SizedBox(
                                  width: 19,
                                  height: 19,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.4,
                                  ),
                                )
                              : const Icon(Icons.download_rounded),
                          label: Text(
                            baixando ? 'PREPARANDO PDF...' : 'BAIXAR PDF',
                          ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: corTema,
                            side: BorderSide(color: corTema.withAlpha(170)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            textStyle: const TextStyle(
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _baixarLivro() async {
    setState(() => baixando = true);

    try {
      final dados = await rootBundle.load(_livroAsset);
      await FileSaver.instance.saveAs(
        name: 'Livro Tem Jeito e Vale a Pena',
        bytes: dados.buffer.asUint8List(),
        fileExtension: 'pdf',
        mimeType: MimeType.pdf,
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('O livro foi preparado para ser salvo no aparelho.'),
        ),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Não foi possível baixar o livro. Tente novamente.'),
        ),
      );
    } finally {
      if (mounted) setState(() => baixando = false);
    }
  }
}

class LeitorLivroPage extends StatefulWidget {
  const LeitorLivroPage({super.key});

  @override
  State<LeitorLivroPage> createState() => _LeitorLivroPageState();
}

enum _ModoLeitura { vertical, horizontal }

class _LeitorLivroPageState extends State<LeitorLivroPage> {
  PDFViewController? pdfController;

  Uint8List? dadosPdf;
  String? erro;
  int paginaAtual = 0;
  int totalPaginas = 0;
  _ModoLeitura modoLeitura = _ModoLeitura.vertical;

  @override
  void initState() {
    super.initState();
    _carregarPdf();
  }

  Future<void> _carregarPdf() async {
    try {
      final dados = await rootBundle.load(_livroAsset);
      if (!mounted) return;
      setState(() => dadosPdf = dados.buffer.asUint8List());
    } catch (_) {
      if (!mounted) return;
      setState(() => erro = 'Não foi possível abrir o livro.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final corTema = tema.colorScheme.primary;
    final fundo = tema.scaffoldBackgroundColor;
    final escuro = tema.brightness == Brightness.dark;
    final painel = escuro ? const Color(0xFF211D1F) : Colors.white;
    final textoPrincipal = escuro ? Colors.white : Colors.black87;
    final textoSecundario = escuro ? Colors.white60 : Colors.black54;
    final pagina = totalPaginas == 0 ? 'Carregando...' : '${paginaAtual + 1}';

    return Scaffold(
      backgroundColor: fundo,
      body: Column(
        children: [
          MainTabHeader(
            title: _livroTitulo,
            subtitle: totalPaginas == 0
                ? 'Preparando o livro'
                : 'Página $pagina de $totalPaginas',
            leading: const Icon(
              Icons.arrow_back_rounded,
              color: Colors.white,
              size: 30,
            ),
            onLeadingTap: () => Navigator.of(context).pop(),
            trailing: PopupMenuButton<_ModoLeitura>(
              initialValue: modoLeitura,
              tooltip: 'Modo de leitura',
              onSelected: _alterarModoLeitura,
              itemBuilder: (context) => const [
                PopupMenuItem(
                  value: _ModoLeitura.vertical,
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(Icons.swap_vert_rounded),
                    title: Text('Rolar para baixo'),
                  ),
                ),
                PopupMenuItem(
                  value: _ModoLeitura.horizontal,
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(Icons.menu_book_rounded),
                    title: Text('Folhear para o lado'),
                  ),
                ),
              ],
              child: Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(35),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  modoLeitura == _ModoLeitura.horizontal
                      ? Icons.menu_book_rounded
                      : Icons.swap_vert_rounded,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
          ),
          Expanded(
            child: erro != null
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(28),
                      child: Text(
                        erro!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  )
                : dadosPdf == null
                    ? Center(
                        child: CircularProgressIndicator(color: corTema),
                      )
                    : PDFView(
                        key: ValueKey(modoLeitura),
                        pdfData: dadosPdf,
                        enableSwipe: true,
                        swipeHorizontal:
                            modoLeitura == _ModoLeitura.horizontal,
                        autoSpacing: true,
                        pageFling: modoLeitura == _ModoLeitura.horizontal,
                        pageSnap: modoLeitura == _ModoLeitura.horizontal,
                        defaultPage: paginaAtual,
                        fitPolicy: FitPolicy.WIDTH,
                        backgroundColor: escuro
                            ? const Color(0xFF353033)
                            : const Color(0xFFE9E7E2),
                        onViewCreated: (pdfController) {
                          this.pdfController = pdfController;
                          pdfController.setPage(paginaAtual);
                        },
                        onRender: (paginas) {
                          if (!mounted) return;
                          setState(() => totalPaginas = paginas ?? 0);
                        },
                        onPageChanged: (pagina, paginas) {
                          if (!mounted) return;
                          setState(() {
                            paginaAtual = pagina ?? 0;
                            totalPaginas = paginas ?? totalPaginas;
                          });
                        },
                        onError: (_) {
                          if (!mounted) return;
                          setState(
                            () => erro =
                                'Não foi possível exibir este livro agora.',
                          );
                        },
                      ),
          ),
          if (totalPaginas > 0)
            SafeArea(
              top: false,
              child: Container(
                constraints: const BoxConstraints(minHeight: 86),
                padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
                decoration: BoxDecoration(
                  color: painel,
                  border: Border(
                    top: BorderSide(color: corTema.withAlpha(105)),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(escuro ? 55 : 24),
                      blurRadius: 16,
                      offset: const Offset(0, -6),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    _ReaderPageButton(
                      tooltip: 'Página anterior',
                      icon: Icons.chevron_left_rounded,
                      cor: corTema,
                      habilitado: paginaAtual > 0,
                      onPressed: () => _irParaPagina(paginaAtual - 1),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.menu_book_rounded,
                                color: corTema,
                                size: 17,
                              ),
                              const SizedBox(width: 7),
                              Text(
                                'Página ${paginaAtual + 1}',
                                style: TextStyle(
                                  color: textoPrincipal,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              Text(
                                ' de $totalPaginas',
                                style: TextStyle(
                                  color: textoSecundario,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                          SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              trackHeight: 3,
                              activeTrackColor: corTema,
                              inactiveTrackColor: corTema.withAlpha(45),
                              thumbColor: corTema,
                              overlayColor: corTema.withAlpha(28),
                              thumbShape: const RoundSliderThumbShape(
                                enabledThumbRadius: 7,
                              ),
                              overlayShape: const RoundSliderOverlayShape(
                                overlayRadius: 15,
                              ),
                            ),
                            child: Slider(
                              value: paginaAtual.toDouble(),
                              min: 0,
                              max: (totalPaginas - 1).toDouble(),
                              onChanged: (valor) =>
                                  _irParaPagina(valor.round()),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    _ReaderPageButton(
                      tooltip: 'Próxima página',
                      icon: Icons.chevron_right_rounded,
                      cor: corTema,
                      habilitado: paginaAtual < totalPaginas - 1,
                      onPressed: () => _irParaPagina(paginaAtual + 1),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _irParaPagina(int pagina) async {
    await pdfController?.setPage(pagina);
  }

  void _alterarModoLeitura(_ModoLeitura novoModo) {
    if (novoModo == modoLeitura) return;
    setState(() {
      modoLeitura = novoModo;
      pdfController = null;
    });
  }
}

class _ReaderPageButton extends StatelessWidget {
  final String tooltip;
  final IconData icon;
  final Color cor;
  final bool habilitado;
  final VoidCallback onPressed;

  const _ReaderPageButton({
    required this.tooltip,
    required this.icon,
    required this.cor,
    required this.habilitado,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: habilitado ? cor : cor.withAlpha(24),
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: habilitado ? onPressed : null,
          child: SizedBox(
            width: 44,
            height: 44,
            child: Icon(
              icon,
              color: habilitado
                  ? Theme.of(context).colorScheme.onPrimary
                  : Theme.of(context).disabledColor,
              size: 28,
            ),
          ),
        ),
      ),
    );
  }
}
