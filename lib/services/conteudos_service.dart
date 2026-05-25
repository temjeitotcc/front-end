import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class ConteudoDesafio {
  final int desafio;
  final DateTime atualizadoEm;
  final List<ConteudoItem> itens;

  const ConteudoDesafio({
    required this.desafio,
    required this.atualizadoEm,
    required this.itens,
  });

  Map<String, dynamic> toJson() {
    return {
      'desafio': desafio,
      'atualizadoEm': atualizadoEm.toIso8601String(),
      'itens': itens.map((item) => item.toJson()).toList(),
    };
  }

  factory ConteudoDesafio.fromJson(Map<String, dynamic> json) {
    final itensJson = json['itens'];

    return ConteudoDesafio(
      desafio: json['desafio'] as int? ?? 0,
      atualizadoEm:
          DateTime.tryParse(json['atualizadoEm'] as String? ?? '') ??
              DateTime.now(),
      itens: itensJson is List
          ? itensJson
              .whereType<Map>()
              .map((item) => ConteudoItem.fromJson(Map<String, dynamic>.from(item)))
              .toList()
          : const [],
    );
  }
}

class ConteudoItem {
  final String titulo;
  final String texto;

  const ConteudoItem({
    required this.titulo,
    required this.texto,
  });

  Map<String, dynamic> toJson() {
    return {
      'titulo': titulo,
      'texto': texto,
    };
  }

  factory ConteudoItem.fromJson(Map<String, dynamic> json) {
    return ConteudoItem(
      titulo: json['titulo'] as String? ?? '',
      texto: json['texto'] as String? ?? '',
    );
  }
}

class BlocoReflexao {
  final String id;
  final String tema;
  final String texto;
  final DateTime atualizadoEm;

  const BlocoReflexao({
    required this.id,
    required this.tema,
    required this.texto,
    required this.atualizadoEm,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tema': tema,
      'texto': texto,
      'atualizadoEm': atualizadoEm.toIso8601String(),
    };
  }

  factory BlocoReflexao.fromJson(Map<String, dynamic> json) {
    return BlocoReflexao(
      id: json['id'] as String? ?? '',
      tema: json['tema'] as String? ?? '',
      texto: json['texto'] as String? ?? '',
      atualizadoEm:
          DateTime.tryParse(json['atualizadoEm'] as String? ?? '') ??
              DateTime.now(),
    );
  }
}

class ConteudosService {
  static const String _key = 'conteudos_desafios';
  static const String _blocosReflexaoKey = 'blocos_reflexao';

  Future<void> salvarConteudosDoDesafio({
    required int desafio,
    required List<ConteudoItem> itens,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final conteudos = await carregarConteudos();

    conteudos[desafio] = ConteudoDesafio(
      desafio: desafio,
      atualizadoEm: DateTime.now(),
      itens: itens.where((item) => item.texto.trim().isNotEmpty).toList(),
    );

    final jsonString = jsonEncode(
      conteudos.map((key, value) => MapEntry('$key', value.toJson())),
    );

    await prefs.setString(_key, jsonString);
  }

  Future<Map<int, ConteudoDesafio>> carregarConteudos() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_key);

    if (jsonString == null || jsonString.isEmpty) return {};

    final decoded = jsonDecode(jsonString);
    if (decoded is! Map) return {};

    return decoded.map((key, value) {
      return MapEntry(
        int.tryParse('$key') ?? 0,
        ConteudoDesafio.fromJson(Map<String, dynamic>.from(value as Map)),
      );
    });
  }

  Future<List<BlocoReflexao>> carregarBlocosReflexao() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_blocosReflexaoKey);

    if (jsonString == null || jsonString.isEmpty) return [];

    final decoded = jsonDecode(jsonString);
    if (decoded is! List) return [];

    final blocos = decoded
        .whereType<Map>()
        .map((item) => BlocoReflexao.fromJson(Map<String, dynamic>.from(item)))
        .toList();

    blocos.sort((a, b) => b.atualizadoEm.compareTo(a.atualizadoEm));
    return blocos;
  }

  Future<void> salvarBlocoReflexao({
    String? id,
    required String tema,
    required String texto,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final blocos = await carregarBlocosReflexao();
    final blocoId = id ?? DateTime.now().microsecondsSinceEpoch.toString();
    final atualizado = BlocoReflexao(
      id: blocoId,
      tema: tema.trim(),
      texto: texto.trim(),
      atualizadoEm: DateTime.now(),
    );
    final index = blocos.indexWhere((bloco) => bloco.id == blocoId);

    if (index >= 0) {
      blocos[index] = atualizado;
    } else {
      blocos.add(atualizado);
    }

    await prefs.setString(
      _blocosReflexaoKey,
      jsonEncode(blocos.map((bloco) => bloco.toJson()).toList()),
    );
  }
}
