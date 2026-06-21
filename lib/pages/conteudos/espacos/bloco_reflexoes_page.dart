import 'package:flutter/material.dart';

import '../../../services/conteudos_service.dart';
import '../../../widgets/main_tab_header.dart';

class BlocosReflexaoPage extends StatefulWidget {
  const BlocosReflexaoPage({super.key});

  @override
  State<BlocosReflexaoPage> createState() => _BlocosReflexaoPageState();
}

class _BlocosReflexaoPageState extends State<BlocosReflexaoPage> {
  final ConteudosService service = ConteudosService();
  List<BlocoReflexao> blocos = [];

  @override
  void initState() {
    super.initState();
    carregarBlocos();
  }

  Future<void> carregarBlocos() async {
    final dados = await service.carregarBlocosReflexao();
    if (!mounted) return;

    setState(() {
      blocos = dados;
    });
  }

  @override
  Widget build(BuildContext context) {
    final fundo = Theme.of(context).scaffoldBackgroundColor;
    final corTema = Theme.of(context).colorScheme.primary;
    final escuro = Theme.of(context).brightness == Brightness.dark;
    final textoPrincipal = escuro ? Colors.white : Colors.black;
    final textoSecundario = escuro ? Colors.white70 : Colors.black54;

    return Scaffold(
      backgroundColor: fundo,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: corTema,
        foregroundColor: Colors.black,
        onPressed: () => abrirEditor(),
        icon: const Icon(Icons.add_rounded),
        label: const Text(
          'Criar bloco',
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
      ),
      body: Column(
        children: [
          MainTabHeader(
            title: 'Bloco de reflexões',
            subtitle: 'Um espaço livre para guardar seus pensamentos',
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
                Icons.edit_note_rounded,
                color: Colors.white,
                size: 25,
              ),
            ),
          ),
          Expanded(
            child: blocos.isEmpty
                ? _BlocoVazio(
                    cor: corTema,
                    textoPrincipal: textoPrincipal,
                    textoSecundario: textoSecundario,
                    onCriar: () => abrirEditor(),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(14, 18, 14, 96),
                    itemCount: blocos.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final bloco = blocos[index];

                      return _BlocoReflexaoCard(
                        bloco: bloco,
                        index: index,
                        onTap: () => abrirEditor(bloco: bloco),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Future<void> abrirEditor({BlocoReflexao? bloco}) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EditorBlocoReflexaoPage(bloco: bloco),
      ),
    );

    carregarBlocos();
  }
}

class _BlocoVazio extends StatelessWidget {
  final Color cor;
  final Color textoPrincipal;
  final Color textoSecundario;
  final VoidCallback onCriar;

  const _BlocoVazio({
    required this.cor,
    required this.textoPrincipal,
    required this.textoSecundario,
    required this.onCriar,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 86,
              height: 86,
              decoration: BoxDecoration(
                color: cor.withAlpha(30),
                shape: BoxShape.circle,
                border: Border.all(color: cor.withAlpha(90)),
              ),
              child: Icon(Icons.edit_note_rounded, color: cor, size: 42),
            ),
            const SizedBox(height: 18),
            Text(
              'Seu bloco ainda está em branco',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: textoPrincipal,
                fontSize: 19,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Crie um espaço livre para guardar ideias, sentimentos e reflexões que não precisam caber em nenhum desafio.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: textoSecundario,
                fontSize: 14,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 18),
            ElevatedButton.icon(
              onPressed: onCriar,
              icon: const Icon(Icons.add_rounded),
              label: const Text('CRIAR PRIMEIRO BLOCO'),
              style: ElevatedButton.styleFrom(
                backgroundColor: cor,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 13,
                ),
                textStyle: const TextStyle(fontWeight: FontWeight.w900),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BlocoReflexaoCard extends StatelessWidget {
  final BlocoReflexao bloco;
  final int index;
  final VoidCallback onTap;

  const _BlocoReflexaoCard({
    required this.bloco,
    required this.index,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final escuro = Theme.of(context).brightness == Brightness.dark;
    final corTema = Theme.of(context).colorScheme.primary;
    final textoPrincipal = escuro ? Colors.white : Colors.black;
    final textoSecundario = escuro ? Colors.white60 : Colors.black54;
    final cardColor = escuro ? const Color(0xFF2A2527) : Colors.white;
    final preview = bloco.texto.trim().isEmpty
        ? 'Sem texto ainda. Toque para continuar escrevendo.'
        : bloco.texto.trim();

    return Material(
      color: cardColor,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: corTema.withAlpha(115)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(24),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 54,
                height: 68,
                decoration: BoxDecoration(
                  color: corTema.withAlpha(34 + (index % 3) * 12),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: corTema.withAlpha(80)),
                ),
                child: Icon(Icons.notes_rounded, color: corTema, size: 28),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            bloco.tema,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: textoPrincipal,
                              fontSize: 17,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          Icons.chevron_right_rounded,
                          color: corTema,
                          size: 26,
                        ),
                      ],
                    ),
                    const SizedBox(height: 7),
                    Text(
                      preview,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: textoSecundario,
                        fontSize: 13,
                        height: 1.35,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(
                          Icons.schedule_rounded,
                          color: textoSecundario,
                          size: 14,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          'Atualizado em ${_formatarDataBloco(bloco.atualizadoEm)}',
                          style: TextStyle(
                            color: textoSecundario,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatarDataBloco(DateTime data) {
    return '${data.day.toString().padLeft(2, '0')}/'
        '${data.month.toString().padLeft(2, '0')}/'
        '${data.year}';
  }
}

class EditorBlocoReflexaoPage extends StatefulWidget {
  final BlocoReflexao? bloco;

  const EditorBlocoReflexaoPage({super.key, this.bloco});

  @override
  State<EditorBlocoReflexaoPage> createState() =>
      _EditorBlocoReflexaoPageState();
}

class _EditorBlocoReflexaoPageState extends State<EditorBlocoReflexaoPage> {
  final ConteudosService service = ConteudosService();
  late final TextEditingController temaController;
  late final TextEditingController textoController;

  @override
  void initState() {
    super.initState();
    temaController = TextEditingController(text: widget.bloco?.tema ?? '');
    textoController = TextEditingController(text: widget.bloco?.texto ?? '');
  }

  @override
  void dispose() {
    temaController.dispose();
    textoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fundo = Theme.of(context).scaffoldBackgroundColor;
    final corTema = Theme.of(context).colorScheme.primary;
    final escuro = Theme.of(context).brightness == Brightness.dark;
    final textoPrincipal = escuro ? Colors.white : Colors.black;
    final textoSecundario = escuro ? Colors.white70 : Colors.black54;
    final cardColor = escuro ? const Color(0xFF2A2527) : Colors.white;

    return Scaffold(
      backgroundColor: fundo,
      body: Column(
        children: [
          MainTabHeader(
            title: widget.bloco == null ? 'Novo bloco' : 'Editar bloco',
            subtitle: 'Guarde uma reflexão livre da sua jornada',
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
                Icons.edit_note_rounded,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
              children: [
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: corTema.withAlpha(120)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(26),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: corTema.withAlpha(38),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Icon(
                              Icons.psychology_alt_rounded,
                              color: corTema,
                              size: 26,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Bloco pessoal',
                                  style: TextStyle(
                                    color: textoPrincipal,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  'Escreva sem pressa, do seu jeito.',
                                  style: TextStyle(
                                    color: textoSecundario,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      TextField(
                        controller: temaController,
                        textInputAction: TextInputAction.next,
                        textCapitalization: TextCapitalization.sentences,
                        style: TextStyle(
                          color: textoPrincipal,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                        decoration: _decoracaoBloco(
                          context,
                          label: 'Tema da reflexão',
                          hint: 'Ex.: O que eu percebi hoje',
                          icon: Icons.bookmark_outline_rounded,
                        ),
                      ),
                      const SizedBox(height: 14),
                      SizedBox(
                        height: MediaQuery.sizeOf(context).height * 0.42,
                        child: TextField(
                          controller: textoController,
                          expands: true,
                          maxLines: null,
                          minLines: null,
                          textAlignVertical: TextAlignVertical.top,
                          textCapitalization: TextCapitalization.sentences,
                          style: TextStyle(
                            color: textoPrincipal,
                            fontSize: 16,
                            height: 1.38,
                          ),
                          decoration: _decoracaoBloco(
                            context,
                            hint: 'Escreva sua reflexão livremente...',
                            alignLabelTop: true,
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      Container(
                        padding: const EdgeInsets.all(13),
                        decoration: BoxDecoration(
                          color: corTema.withAlpha(26),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: corTema.withAlpha(80)),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.lock_outline_rounded,
                              color: corTema,
                              size: 20,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'Esse bloco fica salvo apenas neste aparelho.',
                                style: TextStyle(
                                  color: textoSecundario,
                                  fontSize: 13,
                                  height: 1.3,
                                  fontWeight: FontWeight.w600,
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
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: corTema,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    textStyle: const TextStyle(fontWeight: FontWeight.w900),
                  ),
                  onPressed: salvar,
                  icon: const Icon(Icons.save_rounded),
                  label: const Text('SALVAR BLOCO'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _decoracaoBloco(
    BuildContext context, {
    String? label,
    required String hint,
    IconData? icon,
    bool alignLabelTop = false,
  }) {
    final corTema = Theme.of(context).colorScheme.primary;
    final escuro = Theme.of(context).brightness == Brightness.dark;
    final textoSecundario = escuro ? Colors.white60 : Colors.black45;

    return InputDecoration(
      labelText: label,
      hintText: hint,
      alignLabelWithHint: alignLabelTop,
      labelStyle: TextStyle(color: textoSecundario),
      hintStyle: TextStyle(color: textoSecundario.withAlpha(150)),
      prefixIcon: icon == null ? null : Icon(icon, color: corTema),
      filled: true,
      fillColor: escuro ? const Color(0xFF171315) : const Color(0xFFF6F1E7),
      contentPadding: const EdgeInsets.all(16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: corTema, width: 2),
      ),
    );
  }

  Future<void> salvar() async {
    final tema = temaController.text.trim();
    final texto = textoController.text.trim();

    if (tema.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Coloque um tema para a reflexão.')),
      );
      return;
    }

    await service.salvarBlocoReflexao(
      id: widget.bloco?.id,
      tema: tema,
      texto: texto,
    );

    if (!mounted) return;
    Navigator.of(context).pop();
  }
}
