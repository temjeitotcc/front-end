import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'regras_fases.dart';

class FasesService {
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  Future<void> prepararRegrasAtuais(int totalFases) async {
    // Mantido para preservar o contrato usado pela Home. A origem dos dados
    // agora e o Firestore, entao nao ha estado local para migrar.
  }

  Future<List<DateTime?>> carregarFases(int totalFases) async {
    final user = _auth.currentUser;
    final fases = List<DateTime?>.filled(totalFases, null);

    if (user == null) return fases;

    final usuarioRef = _db.collection('usuarios').doc(user.uid);
    final snapshots = await Future.wait([
      usuarioRef.collection('desafios').get(),
      usuarioRef.collection('reflexoes').get(),
    ]);

    for (final snapshot in snapshots) {
      for (final doc in snapshot.docs) {
        final dia = _diaDoDocumento(doc.id);
        if (dia == null || dia < 1 || dia > totalFases) continue;

        fases[dia - 1] = _dataConclusao(doc.data());
      }
    }

    return fases;
  }

  Future<List<bool>> carregarDesafiosConcluidos(int totalFases) async {
    final fases = await carregarFases(totalFases);
    return fases.map((dataConclusao) => dataConclusao != null).toList();
  }

  Future<DateTime?> carregarDataConclusao(int dia) async {
    final user = _auth.currentUser;
    if (user == null) return null;

    final colecao = _ehMissaoEspecial(dia) ? 'reflexoes' : 'desafios';
    final usuarioRef = _db.collection('usuarios').doc(user.uid);
    final id = dia.toString().padLeft(2, '0');

    var doc = await usuarioRef.collection(colecao).doc(id).get();
    if (!doc.exists) {
      doc = await usuarioRef.collection(colecao).doc('$dia').get();
    }

    final data = doc.data();
    return data == null ? null : _dataConclusao(data);
  }

  bool faseLiberada(List<DateTime?> fasesConcluidas, int index) {
    return RegrasFases.faseLiberada(fasesConcluidas, index);
  }

  String mensagemFaseBloqueada(List<DateTime?> fasesConcluidas, int index) {
    return RegrasFases.mensagemFaseBloqueada(fasesConcluidas, index);
  }

  Future<List<DateTime?>> corrigirSequenciaDeFases(
    List<DateTime?> fasesConcluidas,
  ) async {
    return fasesConcluidas;
  }

  int? _diaDoDocumento(String id) {
    return int.tryParse(id.trim()) ??
        int.tryParse(RegExp(r'\d+').firstMatch(id)?.group(0) ?? '');
  }

  DateTime _dataConclusao(Map<String, dynamic> data) {
    final timestampRaw =
        data['RespondidoEm'] ?? data['Respondido Em'] ?? data['Respondido em'];

    if (timestampRaw is Timestamp) return timestampRaw.toDate();
    if (timestampRaw is DateTime) return timestampRaw;

    return DateTime.now();
  }

  bool _ehMissaoEspecial(int dia) {
    return dia == 7 || dia == 14 || dia == 21 || dia == 28;
  }
}
