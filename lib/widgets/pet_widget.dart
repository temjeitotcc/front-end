import 'package:flutter/material.dart';

import 'pet_accessory_widget.dart';

class PetWidget extends StatelessWidget {
  final String cor;
  final String estado;
  final List<PetAccessory> accessories;
  final double size;

  const PetWidget({
    super.key,
    required this.cor,
    required this.estado,
    this.accessories = const [],
    this.size = 250,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Image.asset(
            'assets/pet/base/$cor$estado.png',
            width: size,
            height: size,
            fit: BoxFit.contain,
          ),
          for (final accessory in accessories)
            PetAccessoryWidget(accessory: accessory, size: size),
        ],
      ),
    );
  }
}
