import 'package:flutter/material.dart';

const _resultAccent = Color(0xFFFED23E);

String getResultadoPet({
  required String cor,
  required double porcentagem,
}) {
  return porcentagem >= 60
      ? 'assets/desafiofeliz.png'
      : 'assets/desafiotriste.png';
}

class ActivityResultPage extends StatefulWidget {
  final int correctAnswers;
  final int totalQuestions;
  final int xpGained;
  final String petColor;

  const ActivityResultPage({
    super.key,
    required this.correctAnswers,
    required this.totalQuestions,
    required this.xpGained,
    this.petColor = 'Vermelha',
  });

  double get percentage {
    if (totalQuestions <= 0) return 0;
    return (correctAnswers / totalQuestions) * 100;
  }

  int get wrongAnswers {
    final wrong = totalQuestions - correctAnswers;
    return wrong < 0 ? 0 : wrong;
  }

  bool get didWell => percentage >= 60;

  @override
  State<ActivityResultPage> createState() => _ActivityResultPageState();
}

class _ActivityResultPageState extends State<ActivityResultPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..forward();
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _scale = Tween<double>(begin: 0.88, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final darkBackground = Theme.of(context).brightness == Brightness.dark
        ? Theme.of(context).scaffoldBackgroundColor
        : const Color(0xFF1E191B);
    final cardColor = const Color(0xFF2A2527);
    final title = widget.didWell ? 'Parabéns!' : 'Não desista!';
    final petMood = widget.didWell ? 'Gratidão Feliz' : 'Gratidão Triste';
    final message = widget.didWell
        ? 'O Gratidão ficou muito feliz com o seu desempenho!\n\nContinue assim para desbloquear novos acessórios e evoluir seu companheiro.'
        : 'O Gratidão acredita em você.\n\nContinue praticando e tente novamente.\nCada desafio ajuda você a evoluir.';

    return Scaffold(
      backgroundColor: darkBackground,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight > 38
                      ? constraints.maxHeight - 38
                      : 0,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FadeTransition(
                      opacity: _fade,
                      child: ScaleTransition(
                        scale: _scale,
                        child: Column(
                          children: [
                            Text(
                              petMood,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: _resultAccent,
                                fontSize: 13,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Image.asset(
                              getResultadoPet(
                                cor: widget.petColor,
                                porcentagem: widget.percentage,
                              ),
                              height: 230,
                              fit: BoxFit.contain,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 34,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      message,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white.withAlpha(205),
                        fontSize: 15,
                        height: 1.35,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _ResultStatsGrid(
                      cardColor: cardColor,
                      percentage: widget.percentage,
                      correctAnswers: widget.correctAnswers,
                      wrongAnswers: widget.wrongAnswers,
                      xpGained: widget.xpGained,
                    ),
                    const SizedBox(height: 22),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: FilledButton.styleFrom(
                          backgroundColor: _resultAccent,
                          foregroundColor: const Color(0xFF211D1F),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text(
                          'CONTINUAR',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _ResultStatsGrid extends StatelessWidget {
  final Color cardColor;
  final double percentage;
  final int correctAnswers;
  final int wrongAnswers;
  final int xpGained;

  const _ResultStatsGrid({
    required this.cardColor,
    required this.percentage,
    required this.correctAnswers,
    required this.wrongAnswers,
    required this.xpGained,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final spacing = 10.0;
        final availableWidth = constraints.maxWidth > spacing
            ? constraints.maxWidth - spacing
            : constraints.maxWidth;
        final width = availableWidth / 2;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: [
            _StatCard(
              width: width,
              cardColor: cardColor,
              value: '${percentage.round()}%',
              label: 'acertos',
              icon: Icons.percent_rounded,
            ),
            _StatCard(
              width: width,
              cardColor: cardColor,
              value: '$correctAnswers',
              label: 'acertos',
              icon: Icons.check_circle_rounded,
            ),
            _StatCard(
              width: width,
              cardColor: cardColor,
              value: '$wrongAnswers',
              label: wrongAnswers == 1 ? 'erro' : 'erros',
              icon: Icons.cancel_rounded,
            ),
            _StatCard(
              width: width,
              cardColor: cardColor,
              value: '+$xpGained XP',
              label: 'ganho',
              icon: Icons.bolt_rounded,
            ),
          ],
        );
      },
    );
  }
}

class _StatCard extends StatelessWidget {
  final double width;
  final Color cardColor;
  final String value;
  final String label;
  final IconData icon;

  const _StatCard({
    required this.width,
    required this.cardColor,
    required this.value,
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _resultAccent.withAlpha(90)),
      ),
      child: Row(
        children: [
          Icon(icon, color: _resultAccent, size: 24),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white.withAlpha(160),
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
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
