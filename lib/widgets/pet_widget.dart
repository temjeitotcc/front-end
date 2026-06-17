import 'package:flutter/material.dart';

class PetWidget extends StatelessWidget {
  final String cor;
  final String estado;

  const PetWidget({
    super.key,
    required this.cor,
    required this.estado,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'pet/base/$cor$estado.png',
      width: 220,
      height: 220,
      fit: BoxFit.contain,
    );
  }
}