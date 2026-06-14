import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FeedbackMensagem {
  final String id;
  final String titulo;
  final String mensagem;
  final String profissional;
  final String referencia;
  final DateTime? enviadoEm;
  final bool lido;

  const FeedbackMensagem({
    required this.id,
    required this.titulo,
    required this.mensagem,
    required this.profissional,
    required this.referencia,
    required this.enviadoEm,
    required this.lido,
  });

  factory FeedbackMensagem.fromFirestore(
    QueryDocumentSnapshot<Map<String, dynamic>> documento,
  ) {
    final dados = documento.data();

    return FeedbackMensagem(
      id: documento.id,
      titulo: _texto(dados, const ['Titulo', 'Título', 'titulo']) ??
          'Novo feedback',
      mensagem:
          _texto(dados, const ['Mensagem', 'mensagem', 'Feedback', 'feedback']) ??
              '',
      profissional: _texto(
            dados,
            const ['Profissional', 'profissional', 'Enviado por', 'enviadoPor'],
          ) ??
          'Equipe Tem Jeito',
      referencia: _texto(
            dados,
            const ['Referencia', 'Referência', 'referencia', 'desafio'],
          ) ??
          '',
      enviadoEm: _data(
        dados['Enviado em'] ??
            dados['EnviadoEm'] ??
            dados['enviadoEm'] ??
            dados['data'],
      ),
      lido: dados['Lido'] as bool? ?? dados['lido'] as bool? ?? false,
    );
  }

  static String? _texto(
    Map<String, dynamic> dados,
    List<String> chaves,
  ) {
    for (final chave in chaves) {
      final valor = dados[chave]?.toString().trim();
      if (valor != null && valor.isNotEmpty) return valor;
    }
    return null;
  }

  static DateTime? _data(dynamic valor) {
    if (valor is Timestamp) return valor.toDate();
    if (valor is DateTime) return valor;
    if (valor is String) return DateTime.tryParse(valor);
    return null;
  }
}

class FeedbackService {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  FeedbackService({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  CollectionReference<Map<String, dynamic>>? get _colecao {
    final email = _auth.currentUser?.email?.trim();
    if (email == null || email.isEmpty) return null;

    return _firestore
        .collection('Usuários')
        .doc(email)
        .collection('Notificações');
  }

  Stream<List<FeedbackMensagem>> observarFeedbacks() {
    final colecao = _colecao;
    if (colecao == null) return const Stream.empty();

    return colecao.snapshots().map((snapshot) {
      final mensagens =
          snapshot.docs.map(FeedbackMensagem.fromFirestore).toList();
      mensagens.sort((a, b) {
        final dataA = a.enviadoEm ?? DateTime.fromMillisecondsSinceEpoch(0);
        final dataB = b.enviadoEm ?? DateTime.fromMillisecondsSinceEpoch(0);
        return dataB.compareTo(dataA);
      });
      return mensagens;
    });
  }

  Future<void> marcarComoLido(String id) async {
    final colecao = _colecao;
    if (colecao == null) return;

    await colecao.doc(id).set({
      'Lido': true,
      'Lido em': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }
}
