import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:temjeito/services/conteudos_service.dart';

class FirebaseReflexoesService {
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  Future<Map<int, ConteudoDesafio>> carregarReflexoes() async {
    final user = _auth.currentUser;
    if (user == null) return {};

    final snapshot = await _db
        .collection('usuarios')
        .doc(user.uid)
        .collection('reflexoes')
        .get();

    final Map<int, ConteudoDesafio> resultado = {};

    for (final doc in snapshot.docs) {
      final dia = int.tryParse(doc.id.trim()) ?? 0;
      final data = doc.data();

      final timestampRaw =
          data['RespondidoEm'] ??
          data['Respondido Em'] ??
          data['Respondido em'];
      final timestamp = timestampRaw is Timestamp
          ? timestampRaw.toDate()
          : DateTime.now();

      final itens = data.entries
          .where((e) => !_campoInterno(e.key))
          .map((e) {
            return ConteudoItem(
              titulo: e.key,
              texto: e.value?.toString() ?? '',
              reflexao: true,
            );
          })
          .where((item) => item.texto.trim().isNotEmpty)
          .toList();

      resultado[dia] = ConteudoDesafio(
        desafio: dia,
        concluido: true,
        atualizadoEm: timestamp,
        itens: itens,
      );
    }

    return resultado;
  }

  bool _campoInterno(String key) {
    final normalizado = key.toLowerCase().replaceAll(' ', '');
    return normalizado == 'respondidoem' || normalizado == 'nome';
  }
}
