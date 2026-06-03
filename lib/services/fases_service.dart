import 'package:shared_preferences/shared_preferences.dart';
import 'regras_fases.dart';

class FasesService {
  static const String _versaoBloqueioKey = 'versao_bloqueio_fases';
  static const int _versaoBloqueioAtual = 2;

  Future<void> prepararRegrasAtuais(int totalFases) async {
    final prefs = await SharedPreferences.getInstance();
    final versaoSalva = prefs.getInt(_versaoBloqueioKey) ?? 0;

    if (versaoSalva >= _versaoBloqueioAtual) return;

    for (int i = 0; i < totalFases; i++) {
      await prefs.remove('fase_$i');
    }

    await prefs.setInt(_versaoBloqueioKey, _versaoBloqueioAtual);
  }

  Future<List<DateTime?>> carregarFases(int totalFases) async {
    final prefs = await SharedPreferences.getInstance();

    return List.generate(totalFases, (index) {
      final dataSalva = prefs.getString('fase_$index');

      if (dataSalva == null) return null;

      return DateTime.tryParse(dataSalva);
    });
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
    final corrigida = List<DateTime?>.from(fasesConcluidas);
    var alterou = false;

    for (int i = 1; i < corrigida.length; i++) {
      if (corrigida[i] != null && !RegrasFases.faseLiberada(corrigida, i)) {
        for (int j = i; j < corrigida.length; j++) {
          corrigida[j] = null;
        }
        alterou = true;
        break;
      }

      if (corrigida[i - 1] == null && corrigida[i] != null) {
        corrigida[i] = null;
        alterou = true;
      }
    }

    if (alterou) {
      await salvarFases(corrigida);
    }

    return corrigida;
  }

  Future<void> salvarFases(List<DateTime?> fasesConcluidas) async {
    final prefs = await SharedPreferences.getInstance();

    for (int i = 0; i < fasesConcluidas.length; i++) {
      final data = fasesConcluidas[i];

      if (data == null) {
        await prefs.remove('fase_$i');
      } else {
        await prefs.setString('fase_$i', data.toIso8601String());
      }
    }
  }
}
