import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:temjeito/services/conteudos_service.dart';

class FirebaseDesafiosService {
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  Future<Map<int, ConteudoDesafio>> carregarConteudos() async {
    final user = _auth.currentUser;
    if (user == null) return {};

    final snapshot = await _db
        .collection('usuarios')
        .doc(user.uid)
        .collection('desafios')
        .get();

    final resultado = <int, ConteudoDesafio>{};

    for (final doc in snapshot.docs) {
      final dia = int.tryParse(doc.id) ??
          int.tryParse(RegExp(r'\d+').firstMatch(doc.id)?.group(0) ?? '');
      if (dia == null) continue;

      final data = doc.data();
      final timestampRaw = data['RespondidoEm'] ?? data['Respondido Em'];
      final timestamp = timestampRaw is Timestamp ? timestampRaw.toDate() : null;
      final itens = _itensDoDia(dia, data);

      if (itens.isEmpty) continue;

      resultado[dia] = ConteudoDesafio(
        desafio: dia,
        concluido: true,
        atualizadoEm: timestamp ?? DateTime.now(),
        itens: itens,
      );
    }

    return resultado;
  }

  List<ConteudoItem> _itensDoDia(int dia, Map<String, dynamic> data) {
    switch (dia) {
      case 1:
        return _campos(data, const [
          'Familiar',
          'Relacional',
          'Social',
          'Saude',
          'Intelectual',
          'Profissional',
          'Emocional',
          'Solidariedade',
          'Futuro',
          'ReflexaoFinal',
        ]);
      case 2:
        return _campos(data, const [
          'Futuro',
          'Espiritual',
          'Emocional',
          'Solidariedade',
          'Intelectual',
          'Profissional',
          'Social',
          'Saude',
          'Familiar',
          'Relacional',
        ]);
      case 3:
        return _campos(data, const ['Reflexao']);
      case 4:
      case 5:
      case 8:
      case 10:
      case 12:
      case 15:
        return _respostaComoReflexao(data);
      case 6:
        return _campos(data, const [
          'Carta 1 - Acusação e Consequências',
          'Carta 2 - Pedido de Perdão',
          'Carta 3 - Superação',
          'Decisão a partir de hoje',
        ]);
      case 9:
      case 11:
      case 13:
      case 16:
      case 18:
      case 19:
      case 20:
      case 25:
        return _quiz(data);
      case 17:
        return [
          _bloco17(data, 'Medo_Aventura'),
          _bloco17(data, 'Inveja_Inspiracao'),
          _bloco17(data, 'Odio_AmorPerdao'),
          _bloco17(data, 'Raiva_Tolerancia'),
        ].where((item) => item.texto.trim().isNotEmpty).toList();
      case 22:
        return _campos(data, const [
          'MinhaHistoriaEPadroes',
          'MinhaFormaDeServir',
          'QuemEscolhoSerEMeuLegado',
        ]);
      case 26:
        return _sonhos(data);
      case 27:
        return _campos(data, const [
          'CartaDoFuturo',
          'DecisaoParaConstruirOFuturo',
        ]);
      default:
        return data.entries
            .where((entry) => !_campoInterno(entry.key))
            .map(
              (entry) => ConteudoItem(
                titulo: entry.key,
                texto: _texto(entry.value),
                reflexao: _pareceReflexao(entry.key),
              ),
            )
            .where((item) => item.texto.trim().isNotEmpty)
            .toList();
    }
  }

  List<ConteudoItem> _campos(
    Map<String, dynamic> data,
    List<String> campos,
  ) {
    return [
      for (final campo in campos)
        if (_texto(data[campo]).trim().isNotEmpty)
          ConteudoItem(
            titulo: campo,
            texto: _texto(data[campo]),
            reflexao: _pareceReflexao(campo),
          ),
    ];
  }

  List<ConteudoItem> _respostaComoReflexao(Map<String, dynamic> data) {
    final resposta = _texto(data['Resposta'] ?? data['resposta']);
    if (resposta.trim().isEmpty) return [];

    return [
      ConteudoItem(titulo: 'Reflexão', texto: resposta, reflexao: true),
    ];
  }

  List<ConteudoItem> _quiz(Map<String, dynamic> data) {
    final itens = <ConteudoItem>[
      ConteudoItem(
        titulo: 'Acertos',
        texto: _texto(data['Acertos']),
        reflexao: false,
      ),
      ConteudoItem(
        titulo: 'Total de Questões',
        texto: _texto(data['TotalQuestoes']),
        reflexao: false,
      ),
      if (data.containsKey('Respostas'))
        ConteudoItem(
          titulo: 'Respostas',
          texto: _texto(data['Respostas']),
          reflexao: false,
        ),
      if (data.containsKey('Reflexao'))
        ConteudoItem(
          titulo: 'Reflexão',
          texto: _texto(data['Reflexao']),
          reflexao: true,
        ),
      if (data.containsKey('ReflexaoFinal'))
        ConteudoItem(
          titulo: 'Reflexão Final',
          texto: _texto(data['ReflexaoFinal']),
          reflexao: true,
        ),
    ];

    return itens.where((item) => item.texto.trim().isNotEmpty).toList();
  }

  ConteudoItem _bloco17(Map<String, dynamic> data, String key) {
    final bloco = data[key];
    if (bloco is! Map) {
      return ConteudoItem(titulo: key, texto: '', reflexao: true);
    }

    return ConteudoItem(
      titulo: key.replaceAll('_', ' -> '),
      texto:
          'Situação: ${_texto(bloco['Situacao'])}\n'
          'Nova perspectiva: ${_texto(bloco['NovaPerspectiva'])}',
      reflexao: true,
    );
  }

  List<ConteudoItem> _sonhos(Map<String, dynamic> data) {
    final sonhos = data['Sonhos'];

    return [
      if (sonhos is List)
        for (int i = 0; i < sonhos.length; i++)
          if (sonhos[i] is Map)
            ConteudoItem(
              titulo: 'Sonho ${i + 1} - ${_texto(sonhos[i]['Sonho'])}',
              texto:
                  'Área da vida: ${_texto(sonhos[i]['AreaDaVida'])}\n'
                  'O que esse sonho me proporcionará: ${_texto(sonhos[i]['OQueProporcionara'])}\n'
                  'Como me sentirei ao conquistá-lo: ${_texto(sonhos[i]['ComoMeSentirei'])}',
              reflexao: false,
            ),
      if (_texto(data['DecisaoParaConstruirOFuturo']).trim().isNotEmpty)
        ConteudoItem(
          titulo: 'Decisão para construir o futuro',
          texto: _texto(data['DecisaoParaConstruirOFuturo']),
          reflexao: true,
        ),
    ];
  }

  bool _campoInterno(String key) {
    final normalizado = key.toLowerCase().replaceAll(' ', '');
    return normalizado == 'respondidoem' || normalizado == 'nome';
  }

  bool _pareceReflexao(String key) {
    final normalizado = key.toLowerCase();
    const termos = [
      'reflex',
      'decis',
      'carta',
      'historia',
      'história',
      'servir',
      'legado',
      'perspectiva',
    ];
    return termos.any(normalizado.contains);
  }

  String _texto(dynamic valor) {
    if (valor == null || valor is Timestamp) return '';
    if (valor is List) {
      return valor.map(_texto).where((item) => item.trim().isNotEmpty).join('\n');
    }
    if (valor is Map) {
      return valor.entries
          .map((entry) => '${entry.key}: ${_texto(entry.value)}')
          .where((item) => item.trim().isNotEmpty)
          .join('\n');
    }
    return valor.toString();
  }
}
