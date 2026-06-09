import 'package:flutter/material.dart';

import '../../../services/auth_service.dart';
import '../../../services/conteudos_service.dart';

class Desafio20Page extends StatefulWidget {
  const Desafio20Page({super.key});

  @override
  State<Desafio20Page> createState() => _Desafio20PageState();
}

class _Desafio20PageState extends State<Desafio20Page> {
  String nomeUsuario = 'você';
  int etapaAtual = 0;
  int? resposta1;
  final List<bool?> respostas2 = [null, null, null];

  static const int respostaCorreta1 = 1;
  static const List<bool> respostasCorretas2 = [true, false, true];

  @override
  void initState() {
    super.initState();
    _carregarNome();
  }

  Future<void> _carregarNome() async {
    final nome = await AuthService.nomeUsuarioAtual();
    if (!mounted) return;
    setState(() => nomeUsuario = nome);
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final corTema = tema.colorScheme.primary;
    final textoPrincipal =
        tema.brightness == Brightness.dark ? Colors.white : Colors.black;
    final textoSecundario = tema.brightness == Brightness.dark
        ? Colors.white70
        : Colors.black54;
    final cardColor = tema.brightness == Brightness.dark
        ? const Color(0xFF2A2527)
        : Colors.white;

    return Scaffold(
      backgroundColor: tema.scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 18, 18, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Dia 20 - Identidade e Pertencimento',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: textoPrincipal,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          _subtitulo(),
                          style: TextStyle(color: textoSecundario),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    tooltip: 'Sair',
                    style: IconButton.styleFrom(
                      backgroundColor: corTema,
                      foregroundColor: Colors.black,
                    ),
                    onPressed: () => Navigator.of(context).pop(false),
                    icon: const Icon(Icons.close_rounded),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: LinearProgressIndicator(
                  value: (etapaAtual + 1) / 3,
                  minHeight: 10,
                  backgroundColor: Colors.white12,
                  valueColor: AlwaysStoppedAnimation(corTema),
                ),
              ),
              const SizedBox(height: 22),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: corTema.withAlpha(120)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: switch (etapaAtual) {
                      0 => _introducao(textoPrincipal, textoSecundario),
                      1 => _multiplaEscolha(textoPrincipal, textoSecundario),
                      _ => _verdadeiroFalso(textoPrincipal, textoSecundario),
                    },
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: textoPrincipal,
                        side: BorderSide(color: corTema),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: _voltar,
                      icon: const Icon(Icons.arrow_back_rounded),
                      label: const Text('Voltar'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: corTema,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: etapaAtual < 2 ? _proximo : _concluir,
                      icon: Icon(
                        etapaAtual < 2
                            ? Icons.arrow_forward_rounded
                            : Icons.check_rounded,
                      ),
                      label: Text(etapaAtual < 2 ? 'Próximo' : 'Concluir'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _subtitulo() {
    return switch (etapaAtual) {
      0 => 'Identidade, utilidade e propósito',
      1 => 'Questão 1 de 2',
      _ => 'Questão 2 de 2',
    };
  }

  List<Widget> _introducao(Color textoPrincipal, Color textoSecundario) {
    final corTema = Theme.of(context).colorScheme.primary;
    return [
      Expanded(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _IdentityBanner(cor: corTema),
              const SizedBox(height: 16),
              Text(
                'Olá, $nomeUsuario! Chegamos a mais um dia da nossa jornada de autoconhecimento e transformação.',
                style: TextStyle(
                  color: textoPrincipal,
                  fontSize: 18,
                  height: 1.35,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 14),
              _Paragraph(
                text:
                    'Ao longo deste projeto, aprendemos que nossas escolhas, pensamentos e atitudes moldam quem nos tornamos. Hoje vamos refletir sobre dois temas fundamentais para uma vida com propósito: identidade e utilidade.',
                color: textoSecundario,
              ),
              _Paragraph(
                text:
                    'Muitas pessoas passam a vida tentando se encaixar em grupos, opiniões ou expectativas dos outros e, nesse processo, acabam se afastando da própria essência.',
                color: textoSecundario,
              ),
              _Paragraph(
                text:
                    'O livro nos lembra que cada ser humano possui um valor único e que servir, contribuir e reconhecer a própria identidade são caminhos importantes para encontrar sentido e perseverança.',
                color: textoSecundario,
              ),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: corTema.withAlpha(28),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: corTema.withAlpha(110)),
                ),
                child: Text(
                  'Responda com atenção e sinceridade. Mais do que acertar, o importante é reconhecer quem você é e como pode contribuir sem abandonar sua essência.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: corTema,
                    fontSize: 14,
                    height: 1.35,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ];
  }

  List<Widget> _multiplaEscolha(
    Color textoPrincipal,
    Color textoSecundario,
  ) {
    const alternativas = [
      'Impede a pessoa de se relacionar profissionalmente.',
      'Corrompe a identidade do indivíduo, pois é justamente o sentimento de utilidade, de servir, que faz o ser humano perseverar.',
      'Gera dependência química e comportamental.',
      'Leva inevitavelmente ao suicídio físico.',
      'É um problema exclusivo de adolescentes sem estrutura familiar.',
    ];

    return [
      Text(
        'Questão 1  [ Múltipla Escolha ]',
        style: TextStyle(
          color: textoPrincipal,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 10),
      Text(
        'Segundo o livro, o sentimento de inutilidade é destrutivo porque:',
        style: TextStyle(
          color: textoSecundario,
          fontSize: 15,
          height: 1.35,
        ),
      ),
      const SizedBox(height: 14),
      Expanded(
        child: ListView.separated(
          itemCount: alternativas.length,
          separatorBuilder: (_, _) => const SizedBox(height: 10),
          itemBuilder: (context, index) => _AlternativeTile(
            letra: String.fromCharCode(65 + index),
            texto: alternativas[index],
            selecionada: resposta1 == index,
            onTap: () => setState(() => resposta1 = index),
          ),
        ),
      ),
    ];
  }

  List<Widget> _verdadeiroFalso(
    Color textoPrincipal,
    Color textoSecundario,
  ) {
    const afirmacoes = [
      'Quando a pessoa não sabe quem é, tende a participar de tribos e grupos que outros definem para ela, perdendo sua identidade.',
      'A autora defende que a criação de grupos e minorias fortalece a identidade individual de cada ser humano.',
      'Ser você mesmo, na sua singularidade, é a minoria mais absoluta e poderosa que existe.',
    ];

    return [
      Text(
        'Questão 2  [ V ou F ]',
        style: TextStyle(
          color: textoPrincipal,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 10),
      Text(
        'Sobre o conceito de identidade e pertencimento abordado no livro:',
        style: TextStyle(
          color: textoSecundario,
          fontSize: 15,
          height: 1.35,
        ),
      ),
      const SizedBox(height: 14),
      Expanded(
        child: ListView.separated(
          itemCount: afirmacoes.length,
          separatorBuilder: (_, _) => const SizedBox(height: 12),
          itemBuilder: (context, index) => _TrueFalseTile(
            letra: String.fromCharCode(97 + index),
            texto: afirmacoes[index],
            valor: respostas2[index],
            onChanged: (valor) => setState(() => respostas2[index] = valor),
          ),
        ),
      ),
    ];
  }

  void _voltar() {
    if (etapaAtual == 0) {
      Navigator.of(context).pop(false);
      return;
    }
    setState(() => etapaAtual--);
  }

  void _proximo() {
    if (etapaAtual == 1 && resposta1 == null) {
      _pendencia('Escolha uma alternativa antes de avançar.');
      return;
    }
    setState(() => etapaAtual++);
  }

  Future<void> _concluir() async {
    if (respostas2.any((resposta) => resposta == null)) {
      _pendencia('Marque verdadeiro ou falso em todos os itens.');
      return;
    }

    final acertos = _contarAcertos();
    await ConteudosService().salvarConteudosDoDesafio(
      desafio: 20,
      itens: [
        ConteudoItem(
          titulo: 'Resultado da atividade',
          texto: '$acertos de 4 acertos',
        ),
      ],
    );

    if (!mounted) return;
    await _mostrarResultado(acertos);
    if (!mounted) return;
    Navigator.of(context).pop(true);
  }

  int _contarAcertos() {
    var acertos = resposta1 == respostaCorreta1 ? 1 : 0;
    for (int i = 0; i < respostas2.length; i++) {
      if (respostas2[i] == respostasCorretas2[i]) acertos++;
    }
    return acertos;
  }

  void _pendencia(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensagem)),
    );
  }

  Future<void> _mostrarResultado(int acertos) async {
    final corTema = Theme.of(context).colorScheme.primary;
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFF2A2527)
            : Colors.white,
        title: Row(
          children: [
            Icon(Icons.fingerprint_rounded, color: corTema),
            const SizedBox(width: 8),
            const Expanded(child: Text('Sua essência importa')),
          ],
        ),
        content: Text(
          'Você acertou $acertos de 4. Reconheça seu valor, use suas capacidades para servir e avance sem precisar se moldar às expectativas dos outros.\n\nTem jeito e vale a pena.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Continuar'),
          ),
        ],
      ),
    );
  }
}

class _IdentityBanner extends StatelessWidget {
  final Color cor;

  const _IdentityBanner({required this.cor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cor.withAlpha(30),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: cor.withAlpha(150)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _Symbol(icon: Icons.fingerprint_rounded, cor: cor),
              Container(width: 34, height: 2, color: cor.withAlpha(120)),
              _Symbol(icon: Icons.volunteer_activism_rounded, cor: cor),
              Container(width: 34, height: 2, color: cor.withAlpha(120)),
              _Symbol(icon: Icons.groups_rounded, cor: cor),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'IDENTIDADE  •  UTILIDADE  •  PERTENCIMENTO',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: cor,
              fontSize: 12,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _Symbol extends StatelessWidget {
  final IconData icon;
  final Color cor;

  const _Symbol({required this.icon, required this.cor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: cor,
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: Colors.black, size: 25),
    );
  }
}

class _AlternativeTile extends StatelessWidget {
  final String letra;
  final String texto;
  final bool selecionada;
  final VoidCallback onTap;

  const _AlternativeTile({
    required this.letra,
    required this.texto,
    required this.selecionada,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cor = Theme.of(context).colorScheme.primary;
    final textoPrincipal = Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : Colors.black;
    final textoSecundario = Theme.of(context).brightness == Brightness.dark
        ? Colors.white70
        : Colors.black54;
    return Material(
      color: selecionada ? cor.withAlpha(42) : Colors.transparent,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: selecionada ? cor : textoSecundario.withAlpha(65),
            ),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 17,
                backgroundColor: selecionada ? cor : cor.withAlpha(32),
                foregroundColor: selecionada ? Colors.black : cor,
                child: Text(
                  letra,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  texto,
                  style: TextStyle(
                    color: textoPrincipal,
                    fontSize: 14,
                    height: 1.3,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TrueFalseTile extends StatelessWidget {
  final String letra;
  final String texto;
  final bool? valor;
  final ValueChanged<bool> onChanged;

  const _TrueFalseTile({
    required this.letra,
    required this.texto,
    required this.valor,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final cor = Theme.of(context).colorScheme.primary;
    final textoPrincipal = Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : Colors.black;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cor.withAlpha(24),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: cor.withAlpha(95)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            '$letra. $texto',
            style: TextStyle(
              color: textoPrincipal,
              fontSize: 15,
              height: 1.35,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _VfButton(
                  label: 'VERDADEIRO',
                  selecionado: valor == true,
                  cor: cor,
                  onTap: () => onChanged(true),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _VfButton(
                  label: 'FALSO',
                  selecionado: valor == false,
                  cor: cor,
                  onTap: () => onChanged(false),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _VfButton extends StatelessWidget {
  final String label;
  final bool selecionado;
  final Color cor;
  final VoidCallback onTap;

  const _VfButton({
    required this.label,
    required this.selecionado,
    required this.cor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        backgroundColor: selecionado ? cor : Colors.transparent,
        foregroundColor: selecionado ? Colors.black : cor,
        side: BorderSide(color: cor),
        padding: const EdgeInsets.symmetric(vertical: 12),
      ),
      onPressed: onTap,
      child: Text(
        label,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _Paragraph extends StatelessWidget {
  final String text;
  final Color color;

  const _Paragraph({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Text(
        text,
        style: TextStyle(color: color, fontSize: 16, height: 1.35),
      ),
    );
  }
}
