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
        // DIA 8
        // =========================
        case 8:
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
        // DIA 9 (quiz / VF)
        // =========================
        case 9:
          itens = [
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
            ConteudoItem(
              titulo: 'Respostas',
              texto: (data['Respostas'] ?? '').toString(),
              reflexao: false,
            ),
          ];
          break;

        // =========================
        // DIA 10
        // =========================
        case 10:
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
        // DIA 11 (quiz / VF)
        // =========================
        case 11:
          itens = [
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
            ConteudoItem(
              titulo: 'Respostas',
              texto: (data['Respostas'] ?? '').toString(),
              reflexao: false,
            ),
          ];
          break;

        // =========================
        // DIA 12
        // =========================
        case 12:
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
        // DIA 13 (reflexivo + quiz)
        // =========================
        case 13:
          itens = [
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
            ConteudoItem(
              titulo: 'Reflexão',
              texto: data['Reflexao'] ?? '',
              reflexao: true,
            ),
          ];
          break;
        // =========================
        // DIA 15
        // =========================
        case 15:
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
        // DIA 16 (quiz)
        // =========================
        case 16:
          itens = [
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
          break;

        // =========================
        // DIA 17 (estrutura aninhada forte)
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
        // DIA 18
        // =========================
        case 18:
          itens = [
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
            ConteudoItem(
              titulo: 'Reflexão',
              texto: data['Reflexao'] ?? '',
              reflexao: true,
            ),
          ];
          break;

        // =========================
        // DIA 19
        // =========================
        case 19:
          itens = [
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
          break;

        // =========================
        // DIA 20
        // =========================
        case 20:
          itens = [
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
            ConteudoItem(
              titulo: 'Respostas',
              texto: (data['Respostas'] ?? []).toString(),
              reflexao: false,
            ),
            ConteudoItem(
              titulo: 'Concluído',
              texto: (data['concluido'] ?? false).toString(),
              reflexao: false,
            ),
          ];
          break;
        // =========================
        // DIA 22
        // =========================
        case 22:
          itens = [
            ConteudoItem(
              titulo: 'Minha História e Padrões',
              texto: data['MinhaHistoriaEPadroes'] ?? '',
              reflexao: true,
            ),
            ConteudoItem(
              titulo: 'Minha Forma de Servir',
              texto: data['MinhaFormaDeServir'] ?? '',
              reflexao: true,
            ),
            ConteudoItem(
              titulo: 'Quem escolho ser e meu legado',
              texto: data['QuemEscolhoSerEMeuLegado'] ?? '',
              reflexao: true,
            ),
          ];
          break;

        // =========================
        // DIA 23
        // =========================
        case 23:
          itens = [
            ConteudoItem(
              titulo: 'Reflexão sobre Linguagens do Amor',
              texto: data['ReflexaoSobreLinguagensDoAmor'] ?? '',
              reflexao: true,
            ),
          ];
          break;

        // =========================
        // DIA 24
        // =========================
        case 24:
          itens = [
            ConteudoItem(
              titulo: 'Minha Linguagem do Amor',
              texto: data['ReflexaoSobreMinhaLinguagemDoAmor'] ?? '',
              reflexao: true,
            ),
          ];
          break;

        // =========================
        // DIA 25 (quiz + reflexão)
        // =========================
        case 25:
          itens = [
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
            ConteudoItem(
              titulo: 'Reflexão Final',
              texto: data['ReflexaoFinal'] ?? '',
              reflexao: true,
            ),
          ];
          break;

        // =========================
        // DIA 26 (LISTA COMPLEXA + FUTURO)
        // =========================
        case 26:
          itens = [
            for (int i = 0; i < (data['Sonhos'] as List? ?? []).length; i++)
              ConteudoItem(
                titulo: 'Sonho ${i + 1}',
                texto:
                    'Sonho: ${(data['Sonhos'][i]['Sonho'] ?? '')}\n'
                    'Área da vida: ${(data['Sonhos'][i]['AreaDaVida'] ?? '')}\n'
                    'O que proporcionará: ${(data['Sonhos'][i]['OQueProporcionara'] ?? '')}\n'
                    'Como me sentirei: ${(data['Sonhos'][i]['ComoMeSentirei'] ?? '')}',
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
          itens = [
            ConteudoItem(
              titulo: 'Carta do Futuro',
              texto: data['CartaDoFuturo'] ?? '',
              reflexao: true,
            ),
            ConteudoItem(
              titulo: 'Decisão para construir o futuro',
              texto: data['DecisaoParaConstruirOFuturo'] ?? '',
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
