import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PontosService {
  static const String _pontosKey = 'pontos_usuario';
  static const bool creditoInfinitoParaTeste = true;
  static const int pontosTeste = 999999;

  static final ValueNotifier<int> pontos = ValueNotifier<int>(pontosTeste);

  static Future<void> carregarPontos() async {
    final prefs = await SharedPreferences.getInstance();
    if (creditoInfinitoParaTeste) {
      await prefs.setInt(_pontosKey, pontosTeste);
      pontos.value = pontosTeste;
      return;
    }

    pontos.value = prefs.getInt(_pontosKey) ?? 100;
  }

  static Future<void> salvarPontos(int novoValor) async {
    final prefs = await SharedPreferences.getInstance();
    if (creditoInfinitoParaTeste) {
      await prefs.setInt(_pontosKey, pontosTeste);
      pontos.value = pontosTeste;
      return;
    }

    await prefs.setInt(_pontosKey, novoValor);
    pontos.value = novoValor;
  }
}
