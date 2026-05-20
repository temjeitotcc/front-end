class RegrasFases {
  // Para testar o app, deixe true: o proximo desafio libera na hora.
  // Para voltar ao comportamento real, troque para false.
  static const bool liberarImediatamenteParaTeste = true;

  static bool faseLiberada(List<DateTime?> fasesConcluidas, int index) {
    if (index == 0) return true;

    final dataConclusaoAnterior = fasesConcluidas[index - 1];
    if (dataConclusaoAnterior == null) return false;

    if (liberarImediatamenteParaTeste) return true;

    return !DateTime.now().isBefore(dataLiberacao(index, fasesConcluidas));
  }

  static DateTime dataLiberacao(
    int index,
    List<DateTime?> fasesConcluidas,
  ) {
    final dataConclusaoAnterior = fasesConcluidas[index - 1];

    if (dataConclusaoAnterior == null) {
      return DateTime.now();
    }

    return DateTime(
      dataConclusaoAnterior.year,
      dataConclusaoAnterior.month,
      dataConclusaoAnterior.day + 1,
    );
  }

  static String mensagemFaseBloqueada(
    List<DateTime?> fasesConcluidas,
    int index,
  ) {
    final dataConclusaoAnterior = fasesConcluidas[index - 1];

    if (dataConclusaoAnterior == null) {
      return 'Complete o desafio anterior primeiro!';
    }

    if (liberarImediatamenteParaTeste) {
      return 'Complete o desafio anterior para liberar este.';
    }

    return 'Este desafio libera a partir da meia-noite do dia seguinte.';
  }
}
