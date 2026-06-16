import 'package:flutter/material.dart';

import '../../widgets/main_tab_header.dart';
import '../../widgets/pet_widget.dart';

class PetPage extends StatelessWidget {
  const PetPage({super.key});

  @override
  Widget build(BuildContext context) {
    final fundo = Theme.of(context).scaffoldBackgroundColor;

    return Scaffold(
      backgroundColor: fundo,
      body: Column(
        children: [
          MainTabHeader(
            title: 'Gratidão',
            subtitle: 'Seu companheiro nesta jornada',
            showLeadingBackground: false,
            leading: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                const Icon(Icons.pets_rounded, color: Colors.white, size: 32),
                Positioned(
                  top: 5,
                  right: 7,
                  child: Icon(
                    Icons.favorite_rounded,
                    color: Colors.white.withAlpha(210),
                    size: 13,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Center(
              child: PetWidget(cor: 'Vermelha', estado: 'Base'),
            ),
          ),
        ],
      ),
    );
  }
}
