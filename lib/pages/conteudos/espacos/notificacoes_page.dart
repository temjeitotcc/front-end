import 'dart:async';

import 'package:flutter/material.dart';

import '../../../services/feedback_service.dart';
import '../../../widgets/main_tab_header.dart';

class NotificacoesPage extends StatefulWidget {
  const NotificacoesPage({super.key});

  @override
  State<NotificacoesPage> createState() => _NotificacoesPageState();
}

class _NotificacoesPageState extends State<NotificacoesPage> {
  final FeedbackService service = FeedbackService();

  @override
  Widget build(BuildContext context) {
    final fundo = Theme.of(context).scaffoldBackgroundColor;

    return Scaffold(
      backgroundColor: fundo,
      body: Column(
        children: [
          MainTabHeader(
            title: 'Notificações',
            subtitle: 'Mensagens preparadas especialmente para você',
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
                Icons.mark_email_unread_rounded,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<List<FeedbackMensagem>>(
              stream: service.observarFeedbacks(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return const _EstadoFeedback(
                    icon: Icons.cloud_off_rounded,
                    titulo: 'Não foi possível carregar suas mensagens',
                    descricao:
                        'Confira sua conexão e tente abrir esta página novamente.',
                  );
                }

                final mensagens = snapshot.data ?? const [];
                if (mensagens.isEmpty) {
                  return const _EstadoFeedback(
                    icon: Icons.mail_outline_rounded,
                    titulo: 'Nenhuma notificação por enquanto',
                    descricao:
                        'Quando a equipe enviar uma mensagem, ela aparecerá aqui.',
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(14, 20, 14, 30),
                  itemCount: mensagens.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final feedback = mensagens[index];
                    return _FeedbackCard(
                      feedback: feedback,
                      onTap: () => _abrirFeedback(feedback),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _abrirFeedback(FeedbackMensagem feedback) {
    if (!feedback.lido) {
      unawaited(service.marcarComoLido(feedback.id));
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => FeedbackDetalhePage(feedback: feedback),
      ),
    );
  }
}

class _FeedbackCard extends StatelessWidget {
  final FeedbackMensagem feedback;
  final VoidCallback onTap;

  const _FeedbackCard({
    required this.feedback,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final escuro = Theme.of(context).brightness == Brightness.dark;
    final corTema = Theme.of(context).colorScheme.primary;
    final textoPrincipal = escuro ? Colors.white : Colors.black87;
    final textoSecundario = escuro ? Colors.white60 : Colors.black54;
    final cardColor = escuro ? const Color(0xFF2A2527) : Colors.white;

    return Material(
      color: cardColor,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: feedback.lido
                  ? textoSecundario.withAlpha(38)
                  : corTema.withAlpha(175),
              width: feedback.lido ? 1 : 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(feedback.lido ? 18 : 32),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: corTema.withAlpha(feedback.lido ? 20 : 42),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  feedback.lido
                      ? Icons.drafts_rounded
                      : Icons.mark_email_unread_rounded,
                  color: feedback.lido ? textoSecundario : corTema,
                  size: 25,
                ),
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
                            feedback.titulo,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: textoPrincipal,
                              fontSize: 16,
                              height: 1.2,
                              fontWeight: feedback.lido
                                  ? FontWeight.w600
                                  : FontWeight.w900,
                            ),
                          ),
                        ),
                        if (!feedback.lido) ...[
                          const SizedBox(width: 8),
                          Container(
                            width: 9,
                            height: 9,
                            decoration: BoxDecoration(
                              color: corTema,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      feedback.mensagem,
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
                        Expanded(
                          child: Text(
                            feedback.profissional,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: corTema,
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        Text(
                          _formatarDataCurta(feedback.enviadoEm),
                          style: TextStyle(
                            color: textoSecundario,
                            fontSize: 11,
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
}

class FeedbackDetalhePage extends StatelessWidget {
  final FeedbackMensagem feedback;

  const FeedbackDetalhePage({
    super.key,
    required this.feedback,
  });

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
            title: 'Mensagem',
            subtitle: feedback.referencia.isEmpty
                ? 'Um cuidado preparado para você'
                : feedback.referencia,
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
                Icons.favorite_rounded,
                color: Colors.white,
                size: 23,
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 32),
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: corTema.withAlpha(125)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(28),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: corTema.withAlpha(38),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.format_quote_rounded,
                          color: corTema,
                          size: 28,
                        ),
                      ),
                      const SizedBox(height: 18),
                      Text(
                        feedback.titulo,
                        style: TextStyle(
                          color: textoPrincipal,
                          fontSize: 22,
                          height: 1.2,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${feedback.profissional} • '
                        '${_formatarDataCompleta(feedback.enviadoEm)}',
                        style: TextStyle(
                          color: textoSecundario,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        width: double.infinity,
                        height: 1,
                        color: corTema.withAlpha(55),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        feedback.mensagem,
                        style: TextStyle(
                          color: textoPrincipal,
                          fontSize: 16,
                          height: 1.55,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: corTema.withAlpha(24),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: corTema.withAlpha(75)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.lock_outline_rounded,
                        color: corTema,
                        size: 21,
                      ),
                      const SizedBox(width: 11),
                      Expanded(
                        child: Text(
                          'Esta notificação é pessoal e fica disponível apenas '
                          'na sua conta.',
                          style: TextStyle(
                            color: textoPrincipal,
                            fontSize: 13,
                            height: 1.35,
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
    );
  }
}

class _EstadoFeedback extends StatelessWidget {
  final IconData icon;
  final String titulo;
  final String descricao;

  const _EstadoFeedback({
    required this.icon,
    required this.titulo,
    required this.descricao,
  });

  @override
  Widget build(BuildContext context) {
    final escuro = Theme.of(context).brightness == Brightness.dark;
    final corTema = Theme.of(context).colorScheme.primary;
    final textoPrincipal = escuro ? Colors.white : Colors.black87;
    final textoSecundario = escuro ? Colors.white60 : Colors.black54;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 82,
              height: 82,
              decoration: BoxDecoration(
                color: corTema.withAlpha(30),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: corTema, size: 38),
            ),
            const SizedBox(height: 18),
            Text(
              titulo,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: textoPrincipal,
                fontSize: 18,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              descricao,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: textoSecundario,
                fontSize: 14,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String _formatarDataCurta(DateTime? data) {
  if (data == null) return 'Agora';
  final agora = DateTime.now();
  final mesmaData = data.year == agora.year &&
      data.month == agora.month &&
      data.day == agora.day;

  if (mesmaData) {
    return '${data.hour.toString().padLeft(2, '0')}:'
        '${data.minute.toString().padLeft(2, '0')}';
  }

  return '${data.day.toString().padLeft(2, '0')}/'
      '${data.month.toString().padLeft(2, '0')}';
}

String _formatarDataCompleta(DateTime? data) {
  if (data == null) return 'Enviado recentemente';

  return '${data.day.toString().padLeft(2, '0')}/'
      '${data.month.toString().padLeft(2, '0')}/${data.year} às '
      '${data.hour.toString().padLeft(2, '0')}:'
      '${data.minute.toString().padLeft(2, '0')}';
}
