import '../../services/conteudos_service.dart';

// Desative antes de gerar a versão de lançamento.
const bool visualizarTodosDesafiosFeitos = true;
const Set<int> questionariosDePodcast = {9, 11, 13, 16};

bool conteudoDisponivelParaExibicao(
  int numero,
  ConteudoDesafio conteudo,
) {
  if (numero == 2) {
    return conteudo.itens.length >= 10 &&
        conteudo.itens.every((item) => item.texto.trim().isNotEmpty);
  }

  if (numero == 22) return conteudo.itens.length >= 3;
  if (numero == 26) return conteudo.itens.length >= 7;

  return conteudo.temReflexao;
}

String tituloDesafio(int numero) {
  return switch (numero) {
    1 => 'Dia 1 - Bem Vindo ao seu treinamento',
    2 => 'Dia 2 - Minha empresa, minha vida',
    3 => 'Dia 3 - Eu escolho',
    4 => 'Dia 4 - O que me move',
    5 => 'Dia 5 - Quem sou eu?',
    6 => 'Dia 6 - Exercitando a Sabedoria',
    7 => 'Dia 7 - Reflexão Semanal',
    8 => 'Dia 8 - Podcast',
    9 => 'Dia 9 - Coraferido Vírus',
    10 => 'Dia 10 - Podcast',
    11 => 'Dia 11 - Suicida Emocional',
    12 => 'Dia 12 - Podcast',
    13 => 'Dia 13 - Troca de Óculos',
    14 => 'Dia 14 - Reflexão Semanal',
    15 => 'Dia 15 - Podcast',
    16 => 'Dia 16 - 7 Passos',
    17 => 'Dia 17 - Trocando de Óculos',
    18 => 'Dia 18 - Nossa essência é servir',
    19 => 'Dia 19 - Revisitando Minha Empresa, Minha Vida',
    20 => 'Dia 20 - Identidade, Utilidade e Pertencimento',
    21 => 'Dia 21 - Reflexão Semanal',
    22 => 'Dia 22 - Responsabilidade e Propósito',
    23 => 'Dia 23 - Podcast',
    24 => 'Dia 24 - As 5 Linguagens do Amor',
    25 => 'Dia 25 - Revisitando os Aprendizados',
    26 => 'Dia 26 - Mural dos Sonhos',
    27 => 'Dia 27 - Visão Positiva do Futuro',
    28 => 'Dia 28 - Encerramento',
    _ => 'Desafio $numero',
  };
}

String temaDesafio(int numero) {
  final titulo = tituloDesafio(numero);
  final separador = titulo.indexOf(' - ');
  return separador >= 0 ? titulo.substring(separador + 3) : titulo;
}
