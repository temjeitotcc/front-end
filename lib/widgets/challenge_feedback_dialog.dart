import 'package:flutter/material.dart';

import '../pages/fases/activity_result_page.dart';

enum ChallengeFeedbackType { quizSuccess, quizEncouragement, reflection }

Future<void> showQuizFeedbackDialog(
  BuildContext context, {
  required int correctAnswers,
  required int totalQuestions,
  int? xpGained,
  String petColor = 'Vermelha',
}) {
  return Navigator.of(context).push<void>(
    PageRouteBuilder(
      opaque: true,
      transitionDuration: const Duration(milliseconds: 220),
      reverseTransitionDuration: const Duration(milliseconds: 180),
      pageBuilder: (context, animation, secondaryAnimation) {
        return ActivityResultPage(
          correctAnswers: correctAnswers,
          totalQuestions: totalQuestions,
          xpGained: xpGained ?? correctAnswers * 10,
          petColor: petColor,
        );
      },
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    ),
  );
}

Future<void> showReflectionFeedbackDialog(BuildContext context) {
  return Navigator.of(context).push<void>(
    PageRouteBuilder(
      opaque: true,
      transitionDuration: const Duration(milliseconds: 220),
      reverseTransitionDuration: const Duration(milliseconds: 180),
      pageBuilder: (context, animation, secondaryAnimation) {
        return const ActivityResultPage(
          correctAnswers: 1,
          totalQuestions: 1,
          xpGained: 50,
        );
      },
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    ),
  );
}

Future<void> _showChallengeFeedbackDialog(
  BuildContext context, {
  required ChallengeFeedbackType type,
  required String eyebrow,
  required String title,
  required String message,
}) {
  return showGeneralDialog<void>(
    context: context,
    barrierDismissible: false,
    barrierLabel: 'Feedback da atividade',
    barrierColor: Colors.black.withAlpha(185),
    transitionDuration: const Duration(milliseconds: 320),
    pageBuilder: (dialogContext, animation, secondaryAnimation) {
      return _ChallengeFeedbackCard(
        type: type,
        eyebrow: eyebrow,
        title: title,
        message: message,
      );
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      final curved = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutBack,
        reverseCurve: Curves.easeInCubic,
      );
      return FadeTransition(
        opacity: animation,
        child: ScaleTransition(scale: curved, child: child),
      );
    },
  );
}

class _ChallengeFeedbackCard extends StatelessWidget {
  final ChallengeFeedbackType type;
  final String eyebrow;
  final String title;
  final String message;

  const _ChallengeFeedbackCard({
    required this.type,
    required this.eyebrow,
    required this.title,
    required this.message,
  });

  IconData get icon => switch (type) {
        ChallengeFeedbackType.quizSuccess => Icons.workspace_premium_rounded,
        ChallengeFeedbackType.quizEncouragement =>
          Icons.psychology_alt_rounded,
        ChallengeFeedbackType.reflection => Icons.auto_awesome_rounded,
      };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = theme.colorScheme.primary;
    final isDark = theme.brightness == Brightness.dark;
    final cardColor = isDark ? const Color(0xFF211D1F) : Colors.white;
    final primaryText = isDark ? Colors.white : const Color(0xFF211D1F);
    final secondaryText = isDark ? Colors.white70 : Colors.black54;

    return SafeArea(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: double.infinity,
              constraints: const BoxConstraints(maxWidth: 430),
              padding: const EdgeInsets.fromLTRB(24, 26, 24, 22),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: accent.withAlpha(115)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(75),
                    blurRadius: 30,
                    offset: const Offset(0, 16),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 68,
                    height: 68,
                    decoration: BoxDecoration(
                      color: accent.withAlpha(isDark ? 55 : 34),
                      shape: BoxShape.circle,
                      border: Border.all(color: accent.withAlpha(180)),
                    ),
                    child: Icon(icon, color: accent, size: 34),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    eyebrow.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: accent,
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: primaryText,
                      fontSize: 23,
                      height: 1.15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: secondaryText,
                      fontSize: 15,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: () => Navigator.of(context).pop(),
                      style: FilledButton.styleFrom(
                        backgroundColor: accent,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      icon: const Icon(Icons.arrow_forward_rounded, size: 20),
                      label: const Text(
                        'Continuar minha jornada',
                        style: TextStyle(fontWeight: FontWeight.w800),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
