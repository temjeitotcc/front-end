import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../services/conteudos_service.dart';

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

      final timestamp = data['Respondido Em'] ?? data['Respondido em'];

      final itens = data.entries
          .where((e) => e.key.toLowerCase() != 'respondido em')
          .map((e) {
            return ConteudoItem(
              titulo: e.key,
              texto: e.value?.toString() ?? '',
              reflexao: e.key.toLowerCase().contains('reflexao'),
            );
          })
          .toList();

      resultado[dia] = ConteudoDesafio(
        desafio: dia,
        concluido: true,
        atualizadoEm: (timestamp as Timestamp?)?.toDate() ?? DateTime.now(),
        itens: itens,
      );
    }

    return resultado;
  }
}
