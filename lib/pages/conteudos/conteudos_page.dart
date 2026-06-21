import 'package:flutter/material.dart';
import 'package:temjeito/pages/conteudos/espacos/bloco_reflexoes_page.dart';
import 'package:temjeito/pages/conteudos/espacos/desafios_feitos_page.dart';
import 'package:temjeito/pages/conteudos/espacos/reflexoes_semanais_page.dart';

import '../../services/conteudos_service.dart';
import '../../services/feedback_service.dart';
import '../../widgets/main_tab_header.dart';
import 'conteudos_utils.dart';
import 'espacos/livro_page.dart';
import 'espacos/notificacoes_page.dart';
import 'espacos/podcasts_page.dart';

class ConteudosPage extends StatefulWidget {
  final int refreshKey;

  const ConteudosPage({super.key, required this.refreshKey});

  @override
  State<ConteudosPage> createState() => _ConteudosPageState();
}

class _ConteudosPageState extends State<ConteudosPage> {
  final ConteudosService service = ConteudosService();
  static const List<int> missoesEspeciais = [7, 14, 21, 28];
  static const Set<int> desafiosComAtividadeSalva = {2, 22, 26};
  Map<int, ConteudoDesafio> conteudos = {};
  List<BlocoReflexao> blocosReflexao = [];

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
    final blocos = await service.carregarBlocosReflexao();
    if (!mounted) return;

    setState(() {
      conteudos = dados;
      blocosReflexao = blocos;
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
    final desafiosSalvos = conteudos.entries
        .where(
          (entry) =>
              !missoesEspeciais.contains(entry.key) &&
              !questionariosDePodcast.contains(entry.key) &&
              conteudoDisponivelParaExibicao(entry.key, entry.value),
        )
        .length;
    final especiaisSalvas = conteudos.entries
        .where(
          (entry) =>
              missoesEspeciais.contains(entry.key) &&
              entry.value.temReflexao,
        )
        .length;

    return Scaffold(
      backgroundColor: fundo,
      body: Column(
        children: [
          const MainTabHeader(
            title: 'Conteúdos',
            subtitle: 'Releia suas respostas e reflexões',
            icon: Icons.menu_book_rounded,
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
                      await carregarConteudos();
                      if (!context.mounted) return;
                      await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              const DesafiosFeitosPage(),
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
                          builder: (context) =>
                              ReflexoesSemanaisPage(conteudos: conteudos),
                        ),
                      );
                      carregarConteudos();
                    },
                  ),
                  _ConteudoCard(
                    titulo: 'Bloco de reflexões',
                    subtitulo: '${blocosReflexao.length} bloco(s)',
                    icon: Icons.edit_note_rounded,
                    onTap: () async {
                      await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const BlocosReflexaoPage(),
                        ),
                      );
                      carregarConteudos();
                    },
                  ),
                  _ConteudoCard(
                    titulo: 'Podcasts',
                    subtitulo: '5 episódios',
                    icon: Icons.headphones_rounded,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const PodcastsConteudoPage(),
                        ),
                      );
                    },
                  ),
                  _ConteudoCard(
                    titulo: 'Livro',
                    subtitulo: 'Leia ou baixe o PDF',
                    icon: Icons.auto_stories_rounded,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const LivroConteudoPage(),
                        ),
                      );
                    },
                  ),
                  StreamBuilder<List<FeedbackMensagem>>(
                    stream: FeedbackService().observarFeedbacks(),
                    builder: (context, snapshot) {
                      final naoLidas = (snapshot.data ?? const [])
                          .where((feedback) => !feedback.lido)
                          .length;

                      return _ConteudoCard(
                        titulo: 'Notificações',
                        subtitulo: naoLidas == 0
                            ? 'Nenhuma mensagem nova'
                            : naoLidas == 1
                                ? '1 mensagem nova'
                                : '$naoLidas mensagens novas',
                        icon: naoLidas > 0
                            ? Icons.mark_email_unread_rounded
                            : Icons.mail_outline_rounded,
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const NotificacoesPage(),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
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
                : Theme.of(context).colorScheme.primary.withAlpha(170),
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
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.black),
            ),
            const Spacer(),
            Text(
              titulo,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
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
              style: TextStyle(color: Colors.white60, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
