import 'package:flutter/material.dart';

class ChallengeIntroDecoration extends StatelessWidget {
  final IconData mainIcon;
  final IconData leftIcon;
  final IconData rightIcon;
  final String title;
  final String subtitle;

  const ChallengeIntroDecoration({
    super.key,
    required this.mainIcon,
    required this.leftIcon,
    required this.rightIcon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final cor = Theme.of(context).colorScheme.primary;
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 15, 14, 13),
      decoration: BoxDecoration(
        color: cor.withAlpha(28),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: cor.withAlpha(145)),
      ),
      child: Column(
        children: [
          SizedBox(
            height: 64,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                  left: 28,
                  child: _SmallSymbol(icon: leftIcon, cor: cor),
                ),
                Positioned(
                  right: 28,
                  child: _SmallSymbol(icon: rightIcon, cor: cor),
                ),
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: cor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: cor.withAlpha(65),
                        blurRadius: 16,
                        offset: const Offset(0, 7),
                      ),
                    ],
                  ),
                  child: Icon(mainIcon, color: Colors.black, size: 31),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: cor,
              fontSize: 16,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white60
                  : Colors.black54,
              fontSize: 12,
              height: 1.25,
            ),
          ),
        ],
      ),
    );
  }
}

class _SmallSymbol extends StatelessWidget {
  final IconData icon;
  final Color cor;

  const _SmallSymbol({required this.icon, required this.cor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        color: cor.withAlpha(38),
        shape: BoxShape.circle,
        border: Border.all(color: cor.withAlpha(110)),
      ),
      child: Icon(icon, color: cor, size: 20),
    );
  }
}
