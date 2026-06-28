import 'package:flutter/material.dart';
import '../../services/app_theme_service.dart';
import '../../services/pet_customization_service.dart';
import '../../services/pontos_service.dart';
import '../../widgets/main_tab_header.dart';

class Page1 extends StatefulWidget {
  const Page1({super.key});

  @override
  State<Page1> createState() => _Page1State();
}

class _Page1State extends State<Page1> {
  Set<String> temasComprados = {AppThemeService.temaPadrao};
  Set<String> petColorsCompradas = {PetCustomizationService.defaultColor};
  Set<String> petAccessoriesComprados = {};
  String corPetEquipada = PetCustomizationService.defaultColor;

  @override
  void initState() {
    super.initState();
    PontosService.carregarPontos();
    PetCustomizationService.load();
    carregarTemasComprados();
    carregarItensPet();
  }

  Future<void> carregarTemasComprados() async {
    final comprados = await AppThemeService.idsTemasComprados();
    if (!mounted) return;

    setState(() => temasComprados = comprados);
  }

  Future<void> carregarItensPet() async {
    await PetCustomizationService.load();
    final colors = <String>{};
    for (final color in PetCustomizationService.colors) {
      if (await PetCustomizationService.isColorPurchased(color.id)) {
        colors.add(color.id);
      }
    }

    final accessories = <String>{};
    for (final accessory in PetCustomizationService.accessories) {
      if (await PetCustomizationService.isAccessoryPurchased(accessory.id)) {
        accessories.add(accessory.id);
      }
    }

    if (!mounted) return;
    setState(() {
      petColorsCompradas = colors;
      petAccessoriesComprados = accessories;
      corPetEquipada = PetCustomizationService.equippedColor.value;
    });
  }

  Future<void> comprarTema(AppThemeOption tema) async {
    if (temasComprados.contains(tema.id)) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('${tema.nome} já está comprado.')));
      return;
    }

    final pontos = PontosService.pontos.value;
    if (pontos < tema.preco) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pontos insuficientes para comprar.')),
      );
      return;
    }

    await PontosService.salvarPontos(pontos - tema.preco);
    await AppThemeService.marcarComoComprado(tema.id);
    await carregarTemasComprados();

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${tema.nome} comprado! Veja em Configuracoes.')),
    );
  }

  Future<void> comprarOuEquiparCor(PetColorOption color) async {
    final comprado = petColorsCompradas.contains(color.id);

    if (!comprado) {
      final pontos = PontosService.pontos.value;
      if (pontos < color.price) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pontos insuficientes para comprar.')),
        );
        return;
      }

      await PontosService.salvarPontos(pontos - color.price);
      await PetCustomizationService.purchaseColor(color.id);
    }

    await PetCustomizationService.equipColor(color.id);
    await carregarItensPet();

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${color.name} equipada no Gratidão!')),
    );
  }

  Future<void> comprarAcessorio(PetAccessoryOption accessory) async {
    if (petAccessoriesComprados.contains(accessory.id)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${accessory.name} ja esta comprado.')),
      );
      return;
    }

    final pontos = PontosService.pontos.value;
    if (pontos < accessory.price) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pontos insuficientes para comprar.')),
      );
      return;
    }

    await PontosService.salvarPontos(pontos - accessory.price);
    await PetCustomizationService.purchaseAccessory(accessory.id);
    await carregarItensPet();

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${accessory.name} comprado! Veja no Gratidão.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final fundo = Theme.of(context).scaffoldBackgroundColor;
    final corTema = Theme.of(context).colorScheme.primary;

    return Scaffold(
      backgroundColor: fundo,
      body: Column(
        children: [
          const MainTabHeader(
            title: 'Lojinha',
            subtitle: 'Faça sua jornada mais bela',
            asset: 'assets/iconloja.png',
          ),

          // CONTEÚDO
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 20),

                  // 💰 CARD DE PONTOS
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2A2526),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white24),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'PONTOS:',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 8),
                            ValueListenableBuilder<int>(
                              valueListenable: PontosService.pontos,
                              builder: (context, pontos, _) {
                                return Row(
                                  children: [
                                    Text(
                                      '$pontos',
                                      style: TextStyle(
                                        color: corTema,
                                        fontSize: 36,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Icon(Icons.star, color: corTema),
                                  ],
                                );
                              },
                            ),
                          ],
                        ),

                        // 🐱 imagem lateral
                        Image.asset('assets/icon4.png', height: 60),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // GRID DE ITENS
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: GridView.count(
                      crossAxisCount: 3,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      childAspectRatio: 0.75,
                      children: [
                        const ItemCard(
                          nome: "Cartola",
                          preco: 50,
                          imagem: "assets/loja1.png",
                        ),
                        const ItemCard(
                          nome: "Cachecol",
                          preco: 50,
                          imagem: "assets/loja2.png",
                        ),
                        const ItemCard(
                          nome: "Óculos",
                          preco: 65,
                          imagem: "assets/loja3.png",
                        ),
                        const ItemCard(
                          nome: "Touca",
                          preco: 50,
                          imagem: "assets/loja4.png",
                        ),
                        const ItemCard(
                          nome: "Casaco",
                          preco: 75,
                          imagem: "assets/loja5.png",
                        ),
                        const ItemCard(
                          nome: "Fundo",
                          preco: 150,
                          imagem: "assets/loja6.png",
                        ),
                        for (final color in PetCustomizationService.colors)
                          PetColorLojaCard(
                            color: color,
                            comprado: petColorsCompradas.contains(color.id),
                            equipado: corPetEquipada == color.id,
                            onTap: () => comprarOuEquiparCor(color),
                          ),
                        for (final accessory
                            in PetCustomizationService.accessories)
                          PetAccessoryLojaCard(
                            accessory: accessory,
                            comprado:
                                petAccessoriesComprados.contains(accessory.id),
                            onTap: () => comprarAcessorio(accessory),
                          ),
                        for (final tema in AppThemeService.temas.skip(1))
                          TemaLojaCard(
                            tema: tema,
                            comprado: temasComprados.contains(tema.id),
                            onComprar: () => comprarTema(tema),
                          ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// 🔥 CARD DOS ITENS
class ItemCard extends StatelessWidget {
  final String nome;
  final int preco;
  final String imagem;

  const ItemCard({
    super.key,
    required this.nome,
    required this.preco,
    required this.imagem,
  });

  @override
  Widget build(BuildContext context) {
    final corTema = Theme.of(context).colorScheme.primary;

    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2526),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Image.asset(imagem, fit: BoxFit.contain)),

          Text(nome, style: TextStyle(color: Colors.white)),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '$preco',
                style: TextStyle(color: corTema, fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 4),
              Icon(Icons.star, size: 16, color: corTema),
            ],
          ),
        ],
      ),
    );
  }
}

class PetColorLojaCard extends StatelessWidget {
  final PetColorOption color;
  final bool comprado;
  final bool equipado;
  final VoidCallback onTap;

  const PetColorLojaCard({
    super.key,
    required this.color,
    required this.comprado,
    required this.equipado,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final corTema = Theme.of(context).colorScheme.primary;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color(0xFF2A2526),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: equipado ? corTema : Colors.white12,
            width: equipado ? 2 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Opacity(
                    opacity: 0.36,
                    child: Image.asset(color.baseAsset, fit: BoxFit.contain),
                  ),
                  Image.asset(color.collarAsset, fit: BoxFit.contain),
                ],
              ),
            ),
            const SizedBox(height: 6),
            Text(
              color.name,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
            Text(
              equipado
                  ? 'Equipado'
                  : comprado
                      ? 'Equipar'
                      : '${color.price}',
              style: TextStyle(
                color: corTema,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PetAccessoryLojaCard extends StatelessWidget {
  final PetAccessoryOption accessory;
  final bool comprado;
  final VoidCallback onTap;

  const PetAccessoryLojaCard({
    super.key,
    required this.accessory,
    required this.comprado,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final corTema = Theme.of(context).colorScheme.primary;

    return GestureDetector(
      onTap: comprado ? null : onTap,
      child: Container(
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color(0xFF2A2526),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: comprado ? corTema : Colors.white12,
            width: comprado ? 2 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: Image.asset(accessory.asset, fit: BoxFit.contain)),
            const SizedBox(height: 6),
            Text(
              accessory.name,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  comprado ? 'Comprado' : '${accessory.price}',
                  style: TextStyle(
                    color: corTema,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (!comprado) ...[
                  const SizedBox(width: 4),
                  Icon(Icons.star, size: 15, color: corTema),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class TemaLojaCard extends StatelessWidget {
  final AppThemeOption tema;
  final bool comprado;
  final VoidCallback onComprar;

  const TemaLojaCard({
    super.key,
    required this.tema,
    required this.comprado,
    required this.onComprar,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: comprado ? null : onComprar,
      child: Container(
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color(0xFF2A2526),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: comprado ? tema.primary : Colors.white12,
            width: comprado ? 2 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: _TemaPreview(tema: tema)),
            const SizedBox(height: 6),
            Text(
              tema.nome,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  comprado ? 'Comprado' : '${tema.preco}',
                  style: TextStyle(
                    color: tema.primary,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (!comprado) ...[
                  const SizedBox(width: 4),
                  Icon(Icons.star, size: 15, color: tema.primary),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TemaPreview extends StatelessWidget {
  final AppThemeOption tema;

  const _TemaPreview({required this.tema});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: tema.primary, width: 3),
        borderRadius: BorderRadius.circular(14),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(11),
        child: Column(
          children: [
            Expanded(child: ColoredBox(color: tema.primary)),
            const Expanded(child: ColoredBox(color: Colors.black)),
          ],
        ),
      ),
    );
  }
}
