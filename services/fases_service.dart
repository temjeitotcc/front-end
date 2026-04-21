import 'package:shared_preferences/shared_preferences.dart';

// Serviço responsável pela lógica das fases
class FasesService {
  Future<List<DateTime?>> carregarFases() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? datas = prefs.getStringList('fases');

    if (datas != null) {
      return datas.map((d) {
        return d.isEmpty ? null : DateTime.parse(d);
      }).toList();
    }

    return [null, null, null, null, null, null];
  }

  Future<void> salvarFases(List<DateTime?> fases) async {
    final prefs = await SharedPreferences.getInstance();

    List<String> datas = fases.map((data) {
      return data?.toIso8601String() ?? '';
    }).toList();

    await prefs.setStringList('fases', datas);
  }

  bool faseLiberada(List<DateTime?> fases, int index) {
    if (index == 0) return true;

    DateTime? anterior = fases[index - 1];
    if (anterior == null) return false;

    DateTime meiaNoite = DateTime(
      anterior.year,
      anterior.month,
      anterior.day + 1,
    );

    return DateTime.now().isAfter(meiaNoite);
  }
}
