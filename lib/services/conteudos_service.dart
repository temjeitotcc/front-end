import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class ConteudoDesafio {
  final int desafio;
  final bool concluido;
  final DateTime atualizadoEm;
  final List<ConteudoItem> itens;

  const ConteudoDesafio({
    required this.desafio,
    required this.concluido,
    required this.atualizadoEm,
    required this.itens,
  });

  List<ConteudoItem> get reflexoes =>
      itens.where((item) => item.reflexao).toList();

  bool get temReflexao => reflexoes.isNotEmpty;

  ConteudoDesafio somenteReflexoes() {
    return ConteudoDesafio(
      desafio: desafio,
      concluido: concluido,
      atualizadoEm: atualizadoEm,
      itens: reflexoes,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'desafio': desafio,
      'concluido': concluido,
      'atualizadoEm': atualizadoEm.toIso8601String(),
      'itens': itens.map((item) => item.toJson()).toList(),
    };
  }

  factory ConteudoDesafio.fromJson(Map<String, dynamic> json) {
    final itensJson = json['itens'];

    return ConteudoDesafio(
      desafio: json['desafio'] as int? ?? 0,
      concluido: json['concluido'] as bool? ?? true,
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
  final bool reflexao;

  const ConteudoItem({
    required this.titulo,
    required this.texto,
    this.reflexao = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'titulo': titulo,
      'texto': texto,
      'reflexao': reflexao,
    };
  }

  factory ConteudoItem.fromJson(Map<String, dynamic> json) {
    final titulo = json['titulo'] as String? ?? '';

    return ConteudoItem(
      titulo: titulo,
      texto: json['texto'] as String? ?? '',
      reflexao: json['reflexao'] as bool? ?? _eraReflexaoLegada(titulo),
    );
  }
}

bool _eraReflexaoLegada(String titulo) {
  final normalizado = titulo.toLowerCase();
  const termos = [
    'reflex',
    'decisão',
    'decisao',
    'aprendizados do podcast',
    'meu pântano e meu jardim',
    'meu pantano e meu jardim',
    'óculos e futuro',
    'oculos e futuro',
    'como posso fazer a diferença',
    'minha história e meus padrões',
    'minha historia e meus padroes',
    'minha forma de servir',
    'quem escolho ser',
    'carta do futuro',
    ' -> ',
  ];

  return termos.any(normalizado.contains);
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
  static const String _blocosReflexaoKey = 'blocos_reflexão';

  Future<void> salvarConteudosDoDesafio({
    required int desafio,
    required List<ConteudoItem> itens,
    bool concluido = true,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final conteudos = await carregarConteudos();

    conteudos[desafio] = ConteudoDesafio(
      desafio: desafio,
      concluido: concluido,
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
