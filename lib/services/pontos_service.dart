import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PontosService {
  static const String _pontosKey = 'pontos_usuario';

  static final ValueNotifier<int> pontos = ValueNotifier<int>(100);

  static Future<void> carregarPontos() async {
    final prefs = await SharedPreferences.getInstance();
    pontos.value = prefs.getInt(_pontosKey) ?? 100;
  }

  static Future<void> salvarPontos(int novoValor) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_pontosKey, novoValor);
    pontos.value = novoValor;
  }
}
