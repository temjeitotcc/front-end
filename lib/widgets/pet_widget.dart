import 'package:flutter/material.dart';

class PetWidget extends StatelessWidget {
  final String cor;
  final String estado;
  final String? coleira;
  final bool oculos;
  final bool oculosEstrela;
  final bool coroa;

  const PetWidget({
    super.key,
    required this.cor,
    required this.estado,
    this.coleira,
    this.oculos = false,
    this.oculosEstrela = false,
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
          Image.asset(
            'pet/base/$cor$estado.png',
            width: 220,
            height: 220,
            fit: BoxFit.contain,
          ),

          if (coleira != null)
            Image.asset(
              'pet/acessorios/coleira$coleira.png',
              width: 220,
              height: 220,
              fit: BoxFit.contain,
            ),

          if (oculos)
            Image.asset(
              'pet/acessorios/Oculos.png',
              width: 220,
              height: 220,
              fit: BoxFit.contain,
            ),

          if (oculosEstrela)
            Image.asset(
              'pet/acessorios/OculosEstrela.png',
              width: 220,
              height: 220,
              fit: BoxFit.contain,
            ),

          if (coroa)
            Image.asset(
              'pet/acessorios/coroa.png.png',
              width: 220,
              height: 220,
              fit: BoxFit.contain,
            ),
        ],
      ),
    );
  }
}
