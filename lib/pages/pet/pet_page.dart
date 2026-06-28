import 'package:flutter/material.dart';

import '../../services/pet_customization_service.dart';
import '../../widgets/main_tab_header.dart';
import '../../widgets/pet_accessory_widget.dart';
import '../../widgets/pet_item_card.dart';
import '../../widgets/pet_menu.dart';
import '../../widgets/pet_widget.dart';

const _petAccessories = [
  PetAccessory(
    id: 'oculos',
    name: 'Óculos',
    assetPath: 'assets/pet/acessorios/Oculos.png',
    icon: Icons.visibility_rounded,
    slot: 'eyes',
    scale: 1.04,
    offset: Offset(0.002, -0.018),
  ),
  PetAccessory(
    id: 'oculos_estrela',
    name: 'Óculos estrela',
    assetPath: 'assets/pet/acessorios/OculosEstrela.png',
    icon: Icons.star_rounded,
    slot: 'eyes',
    scale: 1.03,
    offset: Offset(0.004, -0.02),
    unlocked: false,
    unlockDescription: 'Complete 7 desafios para desbloquear.',
  ),
  PetAccessory(
    id: 'coroa',
    name: 'Coroa',
    assetPath: 'assets/pet/acessorios/coroa.png',
    icon: Icons.workspace_premium_rounded,
    slot: 'head',
    scale: 1.08,
    offset: Offset(0.0, -0.048),
  ),
];

class PetPage extends StatefulWidget {
  const PetPage({super.key});

  @override
  State<PetPage> createState() => _PetPageState();
}

class _PetPageState extends State<PetPage> {
  PetMenuSection _selectedSection = PetMenuSection.accessories;
  final Map<String, PetAccessory> _equippedBySlot = {};
  Set<String> _purchasedAccessories = {};

  List<PetAccessory> get _equippedAccessories => _equippedBySlot.values.toList();

  @override
  void initState() {
    super.initState();
    _loadPetState();
  }

  Future<void> _loadPetState() async {
    await PetCustomizationService.load();
    final purchased = <String>{};
    for (final accessory in PetCustomizationService.accessories) {
      if (await PetCustomizationService.isAccessoryPurchased(accessory.id)) {
        purchased.add(accessory.id);
      }
    }

    if (!mounted) return;
    setState(() {
      _purchasedAccessories = purchased;
      _equippedBySlot.removeWhere(
        (_, accessory) => !purchased.contains(accessory.id),
      );
    });
  }

  void _toggleAccessory(PetAccessory accessory) {
    if (!_purchasedAccessories.contains(accessory.id)) return;

    setState(() {
      final equipped = _equippedBySlot[accessory.slot]?.id == accessory.id;
      if (equipped) {
        _equippedBySlot.remove(accessory.slot);
      } else {
        _equippedBySlot[accessory.slot] = accessory;
      }
    });
  }

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
                    child: PetMenu(
                      selectedSection: _selectedSection,
                      onSectionSelected: (section) {
                        setState(() => _selectedSection = section);
                      },
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
                          _PetCardDecoration(color: corTema),
                          Positioned.fill(
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                return SingleChildScrollView(
                                  padding:
                                      const EdgeInsets.fromLTRB(18, 20, 18, 22),
                                  child: ConstrainedBox(
                                    constraints: BoxConstraints(
                                      minHeight: constraints.maxHeight > 42
                                          ? constraints.maxHeight - 42
                                          : 0,
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Stack(
                                          alignment: Alignment.bottomCenter,
                                          children: [
                                            Positioned(
                                              bottom: 17,
                                              child: Container(
                                                width: 168,
                                                height: 28,
                                                decoration: BoxDecoration(
                                                  color: Colors.black.withAlpha(
                                                    escuro ? 74 : 42,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(999),
                                                ),
                                              ),
                                            ),
                                            ValueListenableBuilder<String>(
                                              valueListenable:
                                                  PetCustomizationService
                                                      .equippedColor,
                                              builder: (context, color, _) {
                                                return PetWidget(
                                                  cor: color,
                                                  estado: 'Base',
                                                  accessories:
                                                      _equippedAccessories,
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          'Gratidão',
                                          style: TextStyle(
                                            color: textoPrincipal,
                                            fontSize: 23,
                                            fontWeight: FontWeight.w900,
                                          ),
                                        ),
                                        const SizedBox(height: 3),
                                        Text(
                                          _sectionSubtitle,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: textoSecundario,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(height: 12),
                                        _PetItemsPanel(
                                          section: _selectedSection,
                                          equippedBySlot: _equippedBySlot,
                                          purchasedAccessories:
                                              _purchasedAccessories,
                                          onAccessoryTap: _toggleAccessory,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
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

  String get _sectionSubtitle {
    switch (_selectedSection) {
      case PetMenuSection.accessories:
        return 'Escolha acessórios para vestir agora';
      case PetMenuSection.hats:
        return 'Chapéus e itens de cabeça';
      case PetMenuSection.achievements:
        return 'Itens especiais da sua jornada';
    }
  }
}

class _PetItemsPanel extends StatelessWidget {
  final PetMenuSection section;
  final Map<String, PetAccessory> equippedBySlot;
  final Set<String> purchasedAccessories;
  final ValueChanged<PetAccessory> onAccessoryTap;

  const _PetItemsPanel({
    required this.section,
    required this.equippedBySlot,
    required this.purchasedAccessories,
    required this.onAccessoryTap,
  });

  @override
  Widget build(BuildContext context) {
    final items = switch (section) {
      PetMenuSection.accessories =>
        _petAccessories
            .where((item) => purchasedAccessories.contains(item.id))
            .toList(),
      PetMenuSection.hats =>
        _petAccessories.where((item) => item.slot == 'head').toList(),
      PetMenuSection.achievements => _petAccessories,
    };

    return SizedBox(
      height: 118,
      width: double.infinity,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount:
            items.length + (section == PetMenuSection.accessories ? 1 : 0),
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          if (section == PetMenuSection.accessories && index == 0) {
            return PetItemCard(
              title: 'Remover',
              subtitle: 'Limpa o visual',
              icon: Icons.block_rounded,
              onTap: () {
                for (final item
                    in _petAccessories.where(
                      (item) => purchasedAccessories.contains(item.id),
                    )) {
                  if (equippedBySlot[item.slot] != null) onAccessoryTap(item);
                }
              },
            );
          }

          final offset = section == PetMenuSection.accessories ? 1 : 0;
          final item = items[index - offset];
          final selected = equippedBySlot[item.slot]?.id == item.id;
          final unlocked = purchasedAccessories.contains(item.id);

          return PetItemCard(
            accessory: item,
            title: item.name,
            subtitle: unlocked
                ? (selected ? 'Toque para remover' : 'Toque para equipar')
                : 'Compre este item na loja.',
            icon: item.icon,
            selected: selected,
            locked: !unlocked,
            onTap: () => onAccessoryTap(item),
          );
        },
      ),
    );
  }
}

class _PetCardDecoration extends StatelessWidget {
  final Color color;

  const _PetCardDecoration({required this.color});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _DecorativeIcon(
          top: 30,
          left: 30,
          icon: Icons.pets_rounded,
          color: color,
          size: 40,
        ),
        _DecorativeIcon(
          top: 58,
          right: 40,
          icon: Icons.pets_rounded,
          color: color,
          size: 35,
        ),
        _DecorativeIcon(
          bottom: 72,
          left: 50,
          icon: Icons.auto_awesome_rounded,
          color: color,
          size: 28,
        ),
        _DecorativeIcon(
          bottom: 50,
          right: 50,
          icon: Icons.pets_rounded,
          color: color,
          size: 45,
        ),
        _DecorativeIcon(
          top: 132,
          left: 82,
          icon: Icons.star_rounded,
          color: color,
          size: 18,
        ),
        _DecorativeIcon(
          bottom: 150,
          right: 92,
          icon: Icons.auto_awesome_rounded,
          color: color,
          size: 22,
        ),
      ],
    );
  }
}

class _DecorativeIcon extends StatelessWidget {
  final double? top;
  final double? right;
  final double? bottom;
  final double? left;
  final IconData icon;
  final Color color;
  final double size;

  const _DecorativeIcon({
    this.top,
    this.right,
    this.bottom,
    this.left,
    required this.icon,
    required this.color,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      right: right,
      bottom: bottom,
      left: left,
      child: Icon(
        icon,
        color: color.withAlpha(24),
        size: size,
      ),
    );
  }
}
