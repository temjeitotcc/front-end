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

      final timestamp = data['Respondido Em'] as Timestamp?;

      List<ConteudoItem> itens = [];
      ConteudoItem _buildBloco17(Map<String, dynamic> data, String key) {
        final bloco = data[key] as Map<String, dynamic>?;

        if (bloco == null) {
          return ConteudoItem(titulo: key, texto: '', reflexao: false);
        }

        return ConteudoItem(
          titulo: key.replaceAll('_', ' → '),
          texto:
              'Situação: ${bloco['Situacao'] ?? ''}\n'
              'Nova Perspectiva: ${bloco['NovaPerspectiva'] ?? ''}',
          reflexao: true,
        );
      }

      List<ConteudoItem> buildCamposSimples(
        Map<String, dynamic> data,
        List<String> campos,
      ) {
        return [
          for (final campo in campos)
            ConteudoItem(
              titulo: campo,
              texto: (data[campo] ?? '').toString(),
              reflexao: campo.toLowerCase().contains('reflexao'),
            ),
        ];
      }

      List<ConteudoItem> buildQuiz(Map<String, dynamic> data) {
        return [
          ConteudoItem(
            titulo: 'Acertos',
            texto: (data['Acertos'] ?? '').toString(),
            reflexao: false,
          ),
          ConteudoItem(
            titulo: 'Total de Questões',
            texto: (data['TotalQuestoes'] ?? '').toString(),
            reflexao: false,
          ),
        ];
      }

      List<ConteudoItem> buildRespostaNome(Map<String, dynamic> data) {
        return [
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
      }

      switch (dia) {
        // =========================
        // DIA 1 (único mesmo)
        // =========================
        case 1:
          itens = buildCamposSimples(data, [
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
          break;

        // =========================
        // PADRÃO: Resposta + Nome
        // =========================
        case 4:
        case 5:
        case 8:
        case 10:
        case 12:
        case 15:
          itens = buildRespostaNome(data);
          break;

        // =========================
        // PADRÃO: QUIZ
        // =========================
        case 9:
        case 11:
        case 13:
        case 16:
        case 18:
        case 19:
        case 20:
        case 25:
          itens = [
            ...buildQuiz(data),
            if (data.containsKey('Respostas'))
              ConteudoItem(
                titulo: 'Respostas',
                texto: (data['Respostas'] ?? '').toString(),
                reflexao: false,
              ),
            if (data.containsKey('Reflexao'))
              ConteudoItem(
                titulo: 'Reflexão',
                texto: data['Reflexao'] ?? '',
                reflexao: true,
              ),
            if (data.containsKey('ReflexaoFinal'))
              ConteudoItem(
                titulo: 'Reflexão Final',
                texto: data['ReflexaoFinal'] ?? '',
                reflexao: true,
              ),
          ];
          break;

        // =========================
        // DIA 6 (único estruturado)
        // =========================
        case 6:
          itens = buildCamposSimples(data, [
            'Carta 1 - Acusação e Consequências',
            'Carta 2 - Pedido de Perdão',
            'Carta 3 - Superação',
            'Decisão a partir de hoje',
            'Nome',
          ]);
          break;

        // =========================
        // DIA 17 (complexo)
        // =========================
        case 17:
          itens = [
            _buildBloco17(data, 'Medo_Aventura'),
            _buildBloco17(data, 'Inveja_Inspiracao'),
            _buildBloco17(data, 'Odio_AmorPerdao'),
            _buildBloco17(data, 'Raiva_Tolerancia'),
          ];
          break;

        // =========================
        // DIA 22
        // =========================
        case 22:
          itens = buildCamposSimples(data, [
            'MinhaHistoriaEPadroes',
            'MinhaFormaDeServir',
            'QuemEscolhoSerEMeuLegado',
          ]);
          break;

        // =========================
        // DIA 23–24
        // =========================
        case 23:
        case 24:
          itens = buildCamposSimples(data, data.keys.toList());
          break;

        // =========================
        // DIA 26 (complexo)
        // =========================
        case 26:
          itens = [
            for (int i = 0; i < (data['Sonhos'] as List? ?? []).length; i++)
              ConteudoItem(
                titulo: 'Sonho ${i + 1}',
                texto: '...',
                reflexao: false,
              ),
            ConteudoItem(
              titulo: 'Decisão para construir o futuro',
              texto: data['DecisaoParaConstruirOFuturo'] ?? '',
              reflexao: true,
            ),
          ];
          break;

        // =========================
        // DIA 27
        // =========================
        case 27:
          itens = buildCamposSimples(data, [
            'CartaDoFuturo',
            'DecisaoParaConstruirOFuturo',
          ]);
          break;

        // =========================
        // DEFAULT
        // =========================
        default:
          itens = data.entries
              .where((e) => !e.key.toLowerCase().contains('respondido'))
              .map(
                (e) => ConteudoItem(
                  titulo: e.key,
                  texto: e.value?.toString() ?? '',
                  reflexao: e.key.toLowerCase().contains('reflexao'),
                ),
              )
              .toList();
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
