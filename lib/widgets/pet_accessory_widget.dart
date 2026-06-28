import 'package:flutter/material.dart';

class PetAccessory {
  final String id;
  final String name;
  final String assetPath;
  final IconData icon;
  final String slot;
  final double scale;
  final Offset offset;
  final bool unlocked;
  final String unlockDescription;

  const PetAccessory({
    required this.id,
    required this.name,
    required this.assetPath,
    required this.icon,
    required this.slot,
    required this.scale,
    required this.offset,
    this.unlocked = true,
    this.unlockDescription = '',
  });
}

class PetAccessoryWidget extends StatelessWidget {
  final PetAccessory accessory;
  final double size;

  const PetAccessoryWidget({
    super.key,
    required this.accessory,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Transform.translate(
        offset: accessory.offset * size,
        child: Center(
          child: Transform.scale(
            scale: accessory.scale,
            child: Image.asset(
              accessory.assetPath,
              width: size,
              height: size,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}
