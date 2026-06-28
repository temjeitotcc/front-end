import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PetColorOption {
  final String id;
  final String name;
  final int price;
  final String baseAsset;
  final String collarAsset;

  const PetColorOption({
    required this.id,
    required this.name,
    required this.price,
    required this.baseAsset,
    required this.collarAsset,
  });
}

class PetAccessoryOption {
  final String id;
  final String name;
  final int price;
  final String asset;

  const PetAccessoryOption({
    required this.id,
    required this.name,
    required this.price,
    required this.asset,
  });
}

class PetCustomizationService {
  static const String defaultColor = 'Vermelha';
  static const String _equippedColorKey = 'pet_cor_equipada';
  static const String _colorPurchasedPrefix = 'pet_cor_comprada_';
  static const String _accessoryPurchasedPrefix = 'pet_acessorio_comprado_';

  static final ValueNotifier<String> equippedColor =
      ValueNotifier<String>(defaultColor);

  static const List<PetColorOption> colors = [
    PetColorOption(
      id: 'Vermelha',
      name: 'Coleira Vermelha',
      price: 0,
      baseAsset: 'assets/pet/base/VermelhaBase.png',
      collarAsset: 'assets/pet/acessorios/coleiraVermelha.png',
    ),
    PetColorOption(
      id: 'Azul',
      name: 'Coleira Azul',
      price: 80,
      baseAsset: 'assets/pet/base/AzulBase.png',
      collarAsset: 'assets/pet/acessorios/coleiraAzul.png',
    ),
    PetColorOption(
      id: 'Verde',
      name: 'Coleira Verde',
      price: 80,
      baseAsset: 'assets/pet/base/VerdeBase.png',
      collarAsset: 'assets/pet/acessorios/coleiraVerde.png',
    ),
    PetColorOption(
      id: 'Amarela',
      name: 'Coleira Amarela',
      price: 80,
      baseAsset: 'assets/pet/base/AmarelaBase.png',
      collarAsset: 'assets/pet/acessorios/coleiraAmarela.png',
    ),
    PetColorOption(
      id: 'Rainbow',
      name: 'Coleira Rainbow',
      price: 140,
      baseAsset: 'assets/pet/base/RainbowBase.png',
      collarAsset: 'assets/pet/acessorios/coleiraRainbow.png',
    ),
  ];

  static const List<PetAccessoryOption> accessories = [
    PetAccessoryOption(
      id: 'oculos',
      name: 'Oculos',
      price: 65,
      asset: 'assets/pet/acessorios/Oculos.png',
    ),
    PetAccessoryOption(
      id: 'oculos_estrela',
      name: 'Oculos estrela',
      price: 110,
      asset: 'assets/pet/acessorios/OculosEstrela.png',
    ),
    PetAccessoryOption(
      id: 'coroa',
      name: 'Coroa',
      price: 150,
      asset: 'assets/pet/acessorios/coroa.png',
    ),
  ];

  static Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('$_colorPurchasedPrefix$defaultColor', true);
    final savedColor = prefs.getString(_equippedColorKey) ?? defaultColor;
    equippedColor.value = _validColor(savedColor) ? savedColor : defaultColor;
  }

  static Future<bool> isColorPurchased(String colorId) async {
    if (colorId == defaultColor) return true;
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('$_colorPurchasedPrefix$colorId') ?? false;
  }

  static Future<bool> isAccessoryPurchased(String accessoryId) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('$_accessoryPurchasedPrefix$accessoryId') ?? false;
  }

  static Future<void> purchaseColor(String colorId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('$_colorPurchasedPrefix$colorId', true);
  }

  static Future<void> purchaseAccessory(String accessoryId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('$_accessoryPurchasedPrefix$accessoryId', true);
  }

  static Future<void> equipColor(String colorId) async {
    if (!_validColor(colorId)) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_equippedColorKey, colorId);
    equippedColor.value = colorId;
  }

  static PetColorOption colorById(String colorId) {
    return colors.firstWhere(
      (option) => option.id == colorId,
      orElse: () => colors.first,
    );
  }

  static bool _validColor(String colorId) {
    return colors.any((option) => option.id == colorId);
  }
}
