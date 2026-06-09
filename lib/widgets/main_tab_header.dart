import 'package:flutter/material.dart';

class MainTabHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData? icon;
  final String? asset;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onLeadingTap;
  final GestureDragEndCallback? onLeadingHorizontalDragEnd;
  final bool showLeadingBackground;

  const MainTabHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.icon,
    this.asset,
    this.leading,
    this.trailing,
    this.onLeadingTap,
    this.onLeadingHorizontalDragEnd,
    this.showLeadingBackground = true,
  }) : assert(icon != null || asset != null || leading != null);

  @override
  Widget build(BuildContext context) {
    final corTema = Theme.of(context).colorScheme.primary;

    return Container(
      width: double.infinity,
      height: 104,
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
      decoration: BoxDecoration(
        color: corTema,
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(28),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(45),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          GestureDetector(
            onHorizontalDragEnd: onLeadingHorizontalDragEnd,
            child: Material(
              color: showLeadingBackground
                  ? Colors.white.withAlpha(35)
                  : Colors.transparent,
              shape: const CircleBorder(),
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: onLeadingTap,
                child: SizedBox(
                  width: 58,
                  height: 58,
                  child: Center(child: _buildLeading()),
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white.withAlpha(195),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          if (trailing != null) ...[
            const SizedBox(width: 10),
            trailing!,
          ],
        ],
      ),
    );
  }

  Widget _buildLeading() {
    if (leading != null) return leading!;
    if (asset != null) {
      return Image.asset(asset!, width: 34, height: 34, fit: BoxFit.contain);
    }
    return Icon(icon, color: Colors.white, size: 30);
  }
}
