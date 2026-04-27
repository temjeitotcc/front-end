import 'package:shared_preferences/shared_preferences.dart';

class FasesService {
  Future<List<DateTime?>> carregarFases(int totalFases) async {
    final prefs = await SharedPreferences.getInstance();

    return List.generate(totalFases, (index) {
      final dataSalva = prefs.getString('fase_$index');

      if (dataSalva == null) return null;

      return DateTime.tryParse(dataSalva);
    });
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
