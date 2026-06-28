import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PontosService {
  static const String _pontosKey = 'moedas_usuario';
  static const String _recompensaPrefix = 'recompensa_desafio_';
  static const int moedasIniciais = 1000;
  static const int recompensaPadrao = 40;
  static const int recompensaSemanal = 65;

  static final ValueNotifier<int> pontos = ValueNotifier<int>(moedasIniciais);

  static Future<void> carregarPontos() async {
    final prefs = await SharedPreferences.getInstance();

    pontos.value = prefs.getInt(_pontosKey) ?? moedasIniciais;
  }

  static Future<void> salvarPontos(int novoValor) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setInt(_pontosKey, novoValor);
    pontos.value = novoValor;
  }

  static int recompensaPorDesafio(int dia) {
    return dia % 7 == 0 ? recompensaSemanal : recompensaPadrao;
  }

  static Future<int> creditarConclusaoDesafio(int dia) async {
    final prefs = await SharedPreferences.getInstance();
    final key = '$_recompensaPrefix$dia';
    final jaCreditado = prefs.getBool(key) ?? false;
    if (jaCreditado) return 0;

    final recompensa = recompensaPorDesafio(dia);
    await prefs.setBool(key, true);
    await salvarPontos(pontos.value + recompensa);
    return recompensa;
  }

  static Future<bool> gastar(int valor) async {
    if (pontos.value < valor) return false;

    await salvarPontos(pontos.value - valor);
    return true;
  }
}
