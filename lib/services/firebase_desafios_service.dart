import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../services/conteudos_service.dart';

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

    final Map<int, ConteudoDesafio> resultado = {};

    for (final doc in snapshot.docs) {
      final dia = int.tryParse(doc.id.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
      final data = doc.data();

      final timestamp = data['RespondidoEm'] as Timestamp?;

      List<ConteudoItem> itens = [];

      switch (dia) {
        // =========================
        // DIA 1
        // =========================
        case 1:
          itens = [
            ConteudoItem(
              titulo: 'Familiar',
              texto: data['Familiar'] ?? '',
              reflexao: false,
            ),
            ConteudoItem(
              titulo: 'Relacional',
              texto: data['Relacional'] ?? '',
              reflexao: false,
            ),
            ConteudoItem(
              titulo: 'Social',
              texto: data['Social'] ?? '',
              reflexao: false,
            ),
            ConteudoItem(
              titulo: 'Saúde',
              texto: data['Saude'] ?? '',
              reflexao: false,
            ),
            ConteudoItem(
              titulo: 'Intelectual',
              texto: data['Intelectual'] ?? '',
              reflexao: false,
            ),
            ConteudoItem(
              titulo: 'Profissional',
              texto: data['Profissional'] ?? '',
              reflexao: false,
            ),
            ConteudoItem(
              titulo: 'Emocional',
              texto: data['Emocional'] ?? '',
              reflexao: false,
            ),
            ConteudoItem(
              titulo: 'Solidariedade',
              texto: data['Solidariedade'] ?? '',
              reflexao: false,
            ),
            ConteudoItem(
              titulo: 'Futuro',
              texto: data['Futuro'] ?? '',
              reflexao: false,
            ),
            ConteudoItem(
              titulo: 'Reflexão Final',
              texto: data['ReflexaoFinal'] ?? '',
              reflexao: true,
            ),
          ];
          break;

        // =========================
        // DIA 2
        // =========================
        case 2:
          itens = data.entries
              .where((e) => e.key != 'RespondidoEm' && e.key != 'Respondido em')
              .map(
                (e) => ConteudoItem(
                  titulo: e.key,
                  texto: e.value?.toString() ?? '',
                  reflexao: false,
                ),
              )
              .toList();
          break;

        // =========================
        // DIA 3
        // =========================
        case 3:
          itens = [
            ConteudoItem(
              titulo: 'Reflexão',
              texto: data['Reflexao'] ?? '',
              reflexao: true,
            ),
          ];
          break;

        // =========================
        // DIA 4 e 5
        // =========================
        case 4:
        case 5:
          itens = [
            ConteudoItem(
              titulo: 'Resposta',
              texto: data['Resposta'] ?? '',
              reflexao: false,
            ),
            ConteudoItem(
              titulo: 'Nome',
              texto: data['Nome'] ?? '',
              reflexao: false,
            ),
          ];
          break;

        // =========================
        // DIA 6
        // =========================
        case 6:
          itens = [
            ConteudoItem(
              titulo: 'Carta 1 - Acusação e Consequências',
              texto: data['Carta 1 - Acusação e Consequências'] ?? '',
              reflexao: false,
            ),
            ConteudoItem(
              titulo: 'Carta 2 - Pedido de Perdão',
              texto: data['Carta 2 - Pedido de Perdão'] ?? '',
              reflexao: false,
            ),
            ConteudoItem(
              titulo: 'Carta 3 - Superação',
              texto: data['Carta 3 - Superação'] ?? '',
              reflexao: false,
            ),
            ConteudoItem(
              titulo: 'Decisão a partir de hoje',
              texto: data['Decisão a partir de hoje'] ?? '',
              reflexao: true,
            ),
            ConteudoItem(
              titulo: 'Nome',
              texto: data['Nome'] ?? '',
              reflexao: false,
            ),
          ];
          break;

        // =========================
        // DEFAULT
        // =========================
        default:
          data.forEach((key, value) {
            if (key.toLowerCase().contains('respondido')) return;

            if (value == null || value.toString().trim().isEmpty) return;

            itens.add(
              ConteudoItem(
                titulo: key,
                texto: value.toString(),
                reflexao: key.toLowerCase().contains('reflexao'),
              ),
            );
          });
      }

      resultado[dia] = ConteudoDesafio(
        desafio: dia,
        concluido: true,
        atualizadoEm: timestamp?.toDate() ?? DateTime.now(),
        itens: itens,
      );
    }

    return resultado;
  }
}
