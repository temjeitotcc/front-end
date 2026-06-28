import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppThemeOption {
  final String id;
  final String nome;
  final Color primary;
  final Color secondary;
  final int preco;

  const AppThemeOption({
    required this.id,
    required this.nome,
    required this.primary,
    required this.secondary,
    required this.preco,
  });
}

class AppThemeService {
  static const String _temaAtualKey = 'tema_cores_atual';
  static const String _temaCompradoPrefix = 'tema_comprado_';
  static const String temaPadrao = 'preto_amarelo';

  static const List<AppThemeOption> temas = [
    AppThemeOption(
      id: temaPadrao,
      nome: 'Preto e amarelo',
      primary: Color(0xFFFED23E),
      secondary: Color(0xFFFFE58A),
      preco: 0,
    ),
    AppThemeOption(
      id: 'preto_azul',
      nome: 'Preto e azul',
      primary: Color(0xFF38BDF8),
      secondary: Color(0xFF7DD3FC),
      preco: 180,
    ),
    AppThemeOption(
      id: 'preto_vermelho',
      nome: 'Preto e vermelho',
      primary: Color(0xFFEF4444),
      secondary: Color(0xFFFCA5A5),
      preco: 180,
    ),
    AppThemeOption(
      id: 'preto_roxo',
      nome: 'Preto e roxo',
      primary: Color(0xFFA855F7),
      secondary: Color(0xFFD8B4FE),
      preco: 180,
    ),
  ];

  static final ValueNotifier<AppThemeOption> temaAtual =
      ValueNotifier<AppThemeOption>(temaPorId(temaPadrao));

  static AppThemeOption temaPorId(String id) {
    return temas.firstWhere(
      (tema) => tema.id == id,
      orElse: () => temas.first,
    );
  }

  static Future<void> carregarTema() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getString(_temaAtualKey) ?? temaPadrao;
    temaAtual.value = temaPorId(id);
  }

  static Future<bool> temaComprado(String id) async {
    if (id == temaPadrao) return true;

    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('$_temaCompradoPrefix$id') ?? false;
  }

  static Future<Set<String>> idsTemasComprados() async {
    final comprados = <String>{temaPadrao};

    for (final tema in temas) {
      if (await temaComprado(tema.id)) {
        comprados.add(tema.id);
      }
    }

    return comprados;
  }

  static Future<List<AppThemeOption>> temasComprados() async {
    final ids = await idsTemasComprados();
    return temas.where((tema) => ids.contains(tema.id)).toList();
  }

  static Future<void> marcarComoComprado(String id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('$_temaCompradoPrefix$id', true);
  }

  static Future<void> selecionarTema(String id) async {
    if (!await temaComprado(id)) return;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_temaAtualKey, id);
    temaAtual.value = temaPorId(id);
  }
}
