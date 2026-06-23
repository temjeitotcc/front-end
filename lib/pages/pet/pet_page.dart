import 'package:flutter/material.dart';

import '../../widgets/main_tab_header.dart';
import '../../widgets/pet_widget.dart';

class PetPage extends StatelessWidget {
  const PetPage({super.key});

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final fundo = tema.scaffoldBackgroundColor;
    final corTema = tema.colorScheme.primary;
    final escuro = tema.brightness == Brightness.dark;
    final cardColor = escuro ? const Color(0xFF2A2527) : Colors.white;
    final textoPrincipal = escuro ? Colors.white : Colors.black87;
    final textoSecundario = escuro ? Colors.white60 : Colors.black54;

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
                        color: cardColor,
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(color: corTema.withAlpha(105)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(escuro ? 45 : 18),
                            blurRadius: 18,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            top: 30,
                            left: 30,
                            child: Icon(
                              Icons.pets,
                              color: corTema.withAlpha(24),
                              size: 40,
                            ),
                          ),
                          Positioned(
                            top: 60,
                            right: 40,
                            child: Icon(
                              Icons.pets,
                              color: corTema.withAlpha(24),
                              size: 35,
                            ),
                          ),
                          Positioned(
                            bottom: 80,
                            left: 50,
                            child: Icon(
                              Icons.pets,
                              color: corTema.withAlpha(24),
                              size: 35,
                            ),
                          ),
                          Positioned(
                            bottom: 50,
                            right: 50,
                            child: Icon(
                              Icons.pets,
                              color: corTema.withAlpha(24),
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
                                    PetWidget(
                                      cor: 'Vermelha',
                                      estado: 'Base',
                                      coleira: 'Vermelha',
                                      oculos: true,
                                      coroa: true,
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 10),

                                Text(
                                  'Gratidão',
                                  style: TextStyle(
                                    color: textoPrincipal,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                const SizedBox(height: 4),

                                Text(
                                  'Seu companheiro diário',
                                  style: TextStyle(
                                    color: textoSecundario,
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
    final esquema = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: esquema.primary,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: esquema.primary.withAlpha(185)),
        boxShadow: [
          BoxShadow(
            color: esquema.primary.withAlpha(38),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: esquema.onPrimary, size: 28),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
              color: esquema.onPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
