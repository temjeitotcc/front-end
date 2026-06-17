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
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  SizedBox(
                    width: 140,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        _PetMenuButton(
                          icon: Icons.checkroom_rounded,
                          label: 'Acessórios',
                        ),
                        SizedBox(height: 14),
                        _PetMenuButton(
                          icon: Icons.pets_rounded,
                          label: 'Coleiras',
                        ),
                        SizedBox(height: 14),
                        _PetMenuButton(
                          icon: Icons.emoji_events_rounded,
                          label: 'Conquistas',
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 20),

                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(18),
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(color: Colors.white.withAlpha(35)),
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            top: 30,
                            left: 30,
                            child: Icon(
                              Icons.pets,
                              color: Colors.white.withAlpha(20),
                              size: 40,
                            ),
                          ),
                          Positioned(
                            top: 60,
                            right: 40,
                            child: Icon(
                              Icons.pets,
                              color: Colors.white.withAlpha(20),
                              size: 35,
                            ),
                          ),
                          Positioned(
                            bottom: 80,
                            left: 50,
                            child: Icon(
                              Icons.pets,
                              color: Colors.white.withAlpha(20),
                              size: 35,
                            ),
                          ),
                          Positioned(
                            bottom: 50,
                            right: 50,
                            child: Icon(
                              Icons.pets,
                              color: Colors.white.withAlpha(20),
                              size: 45,
                            ),
                          ),

                          Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Stack(
                                  alignment: Alignment.bottomCenter,
                                  children: [
                                    Positioned(
                                      bottom: 18,
                                      child: Container(
                                        width: 130,
                                        height: 22,
                                        decoration: BoxDecoration(
                                          color: Colors.black.withAlpha(45),
                                          borderRadius: BorderRadius.circular(
                                            999,
                                          ),
                                        ),
                                      ),
                                    ),
                                    PetWidget(cor: 'Vermelha', estado: 'Base'),
                                  ],
                                ),

                                const SizedBox(height: 10),

                                const Text(
                                  'Gratidão',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                const SizedBox(height: 4),

                                Text(
                                  'Seu companheiro diário',
                                  style: TextStyle(
                                    color: Colors.white.withAlpha(150),
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PetMenuButton extends StatelessWidget {
  final IconData icon;
  final String label;

  const _PetMenuButton({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFFED23E),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.black, size: 28),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
