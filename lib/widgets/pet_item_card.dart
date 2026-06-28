import 'package:flutter/material.dart';

import 'pet_accessory_widget.dart';

class PetItemCard extends StatelessWidget {
  final PetAccessory? accessory;
  final String title;
  final String subtitle;
  final IconData icon;
  final bool selected;
  final bool locked;
  final VoidCallback? onTap;

  const PetItemCard({
    super.key,
    this.accessory,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.selected = false,
    this.locked = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final dark = theme.brightness == Brightness.dark;
    final foreground = locked
        ? (dark ? Colors.white38 : Colors.black38)
        : (dark ? Colors.white : Colors.black87);
    final background = locked
        ? (dark ? Colors.white.withAlpha(12) : Colors.black.withAlpha(12))
        : selected
            ? scheme.primary.withAlpha(45)
            : (dark ? Colors.white.withAlpha(16) : Colors.white);

    return Opacity(
      opacity: locked ? 0.72 : 1,
      child: Material(
        color: background,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: locked ? null : onTap,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            width: 132,
            height: 118,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: selected
                    ? scheme.primary.withAlpha(180)
                    : foreground.withAlpha(28),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _ItemIcon(
                      accessory: accessory,
                      icon: icon,
                      locked: locked,
                    ),
                    const Spacer(),
                    if (selected)
                      Icon(
                        Icons.check_circle_rounded,
                        color: scheme.primary,
                        size: 18,
                      )
                    else if (locked)
                      Icon(
                        Icons.lock_rounded,
                        color: foreground,
                        size: 17,
                      ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: foreground,
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 2),
                Expanded(
                  child: Text(
                    subtitle,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: foreground.withAlpha(165),
                      fontSize: 9,
                      height: 1.08,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ItemIcon extends StatelessWidget {
  final PetAccessory? accessory;
  final IconData icon;
  final bool locked;

  const _ItemIcon({
    required this.accessory,
    required this.icon,
    required this.locked,
  });

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;
    final child = accessory == null
        ? Icon(icon, color: color, size: 24)
        : Image.asset(
            accessory!.assetPath,
            width: 34,
            height: 34,
            fit: BoxFit.contain,
            color: locked ? Colors.grey : null,
            colorBlendMode: locked ? BlendMode.saturation : null,
          );

    return SizedBox(width: 36, height: 36, child: Center(child: child));
  }
}
