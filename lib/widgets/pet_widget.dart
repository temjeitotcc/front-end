import 'package:flutter/material.dart';

class PetWidget extends StatelessWidget {
  final String cor;
  final String estado;
  final String? coleira;
  final String? oculos;
  final bool coroa;

  const PetWidget({
    super.key,
    required this.cor,
    required this.estado,
    this.coleira,
    this.oculos,
    this.coroa = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220,
      height: 220,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Base
          Image.asset(
            'assets/pet/base/$cor$estado.png',
            width: 220,
            height: 220,
            fit: BoxFit.contain,
          ),

          // Coleira
          if (coleira != null)
            Image.asset(
              'assets/pet/acessorios/coleira$coleira.png',
              width: 220,
              height: 220,
              fit: BoxFit.contain,
            ),

          // Óculos
          if (oculos == 'normal')
            Image.asset(
              'assets/pet/acessorios/Oculos.png',
              width: 220,
              height: 220,
              fit: BoxFit.contain,
            ),

          if (oculos == 'estrela')
            Image.asset(
              'assets/pet/acessorios/OculosEstrela.png',
              width: 220,
              height: 220,
              fit: BoxFit.contain,
            ),

          // Coroa
          if (coroa)
            Image.asset(
              'assets/pet/acessorios/coroa.png',
              width: 220,
              height: 220,
              fit: BoxFit.contain,
            ),
        ],
      ),
    );
  }
}