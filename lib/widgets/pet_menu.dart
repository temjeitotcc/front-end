import 'package:flutter/material.dart';

enum PetMenuSection { accessories, hats, achievements }

class PetMenu extends StatelessWidget {
  final PetMenuSection selectedSection;
  final ValueChanged<PetMenuSection> onSectionSelected;

  const PetMenu({
    super.key,
    required this.selectedSection,
    required this.onSectionSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _PetMenuButton(
          icon: Icons.checkroom_rounded,
          label: 'Acessórios',
          selected: selectedSection == PetMenuSection.accessories,
          onTap: () => onSectionSelected(PetMenuSection.accessories),
        ),
        const SizedBox(height: 14),
        _PetMenuButton(
          icon: Icons.workspace_premium_rounded,
          label: 'Chapéus',
          selected: selectedSection == PetMenuSection.hats,
          onTap: () => onSectionSelected(PetMenuSection.hats),
        ),
        const SizedBox(height: 14),
        _PetMenuButton(
          icon: Icons.emoji_events_rounded,
          label: 'Conquistas',
          selected: selectedSection == PetMenuSection.achievements,
          onTap: () => onSectionSelected(PetMenuSection.achievements),
        ),
      ],
    );
  }
}

class _PetMenuButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _PetMenuButton({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final esquema = Theme.of(context).colorScheme;
    final foreground = esquema.onPrimary;

    return Material(
      color: selected ? esquema.primary : esquema.primary.withAlpha(220),
      borderRadius: BorderRadius.circular(18),
      elevation: selected ? 7 : 2,
      shadowColor: esquema.primary.withAlpha(80),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: selected ? foreground.withAlpha(95) : esquema.primary,
            ),
          ),
          child: Column(
            children: [
              Icon(icon, color: foreground, size: 28),
              const SizedBox(height: 6),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: foreground,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
