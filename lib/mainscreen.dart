import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'config.dart';
import 'pages/conteudos/conteudos_page.dart';
import 'pages/home/home_page.dart';
import 'pages/menu/loja.dart';
import 'pages/pet/pet_page.dart';
import 'services/auth_service.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  static const String _introInicialKey = 'intro_app_tour_v3_visto';

  int currentIndex = 2;
  int conteudosRefreshKey = 0;
  int homeScrollSignal = 0;
  bool _introChecada = false;
  final PageController _controller = PageController(initialPage: 2);

  @override
  void initState() {
    super.initState();
  }

  Future<void> _verificarIntroducaoInicial() async {
    final prefs = await SharedPreferences.getInstance();
    final jaViu = prefs.getBool(_introInicialKey) ?? false;
    if (jaViu || !mounted) return;

    await _mostrarTutorial();
  }

  Future<void> _mostrarTutorial() async {
    final nome = await AuthService.nomeUsuarioAtual();
    if (!mounted) return;

    final prefs = await SharedPreferences.getInstance();
    await showGeneralDialog<void>(
      context: context,
      barrierDismissible: false,
      barrierLabel: 'Introdução do aplicativo',
      barrierColor: Colors.black.withAlpha(145),
      transitionDuration: const Duration(milliseconds: 320),
      pageBuilder: (context, animation, secondaryAnimation) {
        return _IntroAppDialog(
          nomeUsuario: nome,
          onTrocarAba: _trocarAbaIntroducao,
          onFinalizar: () async {
            _trocarAbaIntroducao(2);
            await prefs.setBool(_introInicialKey, true);
            if (context.mounted) Navigator.of(context).pop();
          },
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final curva = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
        );
        return FadeTransition(
          opacity: curva,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.94, end: 1).animate(curva),
            child: child,
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _trocarAbaIntroducao(int index) {
    setState(() {
      currentIndex = index;
      if (index == 1) {
        conteudosRefreshKey++;
      }
    });

    _controller.animateToPage(
      index,
      duration: const Duration(milliseconds: 380),
      curve: Curves.easeOutCubic,
    );
  }

  void _abrirTutorialManual() {
    _mostrarTutorial();
  }

  void mudarPagina(int index) {
    if (index == currentIndex) {
      if (index == 2) {
        setState(() => homeScrollSignal++);
      }
      return;
    }

    setState(() {
      currentIndex = index;
      if (index == 1) {
        conteudosRefreshKey++;
      }
    });

    _controller.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_introChecada) {
      _introChecada = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _verificarIntroducaoInicial();
      });
    }

    final fundo = Theme.of(context).scaffoldBackgroundColor;
    final corTema = Theme.of(context).colorScheme.primary;

    return Scaffold(
      backgroundColor: fundo,
      body: PageView(
        controller: _controller,
        onPageChanged: (index) {
          setState(() {
            currentIndex = index;
            if (index == 1) {
              conteudosRefreshKey++;
            }
          });
        },
        children: [
          const Page1(),
          ConteudosPage(refreshKey: conteudosRefreshKey),
          HomePage(scrollSignal: homeScrollSignal),
          const PetPage(),
          ConfigPage(onAbrirTutorial: _abrirTutorialManual),
        ],
      ),
      bottomNavigationBar: Container(
        height: 90,
        decoration: BoxDecoration(
          color: corTema,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _botaoNav(0, 'assets/icon1.png'),
            _botaoNav(1, 'assets/icon2.png'),
            _botaoCentral(2, 'assets/icon3.png', corTema),
            _botaoNav(3, 'assets/icon4.png'),
            _botaoNav(4, 'assets/icon5.png'),
          ],
        ),
      ),
    );
  }

  Widget _botaoNav(int index, String imagem) {
    final ativo = currentIndex == index;

    return GestureDetector(
      onTap: () => mudarPagina(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        width: 60,
        height: 60,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: ativo ? Colors.white.withOpacity(0.15) : Colors.transparent,
          boxShadow: ativo
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ]
              : [],
        ),
        child: AnimatedScale(
          duration: const Duration(milliseconds: 200),
          scale: ativo ? 1.15 : 1.0,
          child: Image.asset(
            imagem,
            height: 28,
            color: Colors.black.withAlpha(220),
            colorBlendMode: BlendMode.srcIn,
          ),
        ),
      ),
    );
  }

  Widget _botaoCentral(int index, String imagem, Color corTema) {
    final ativo = currentIndex == index;

    return GestureDetector(
      onTap: () => mudarPagina(index),
      child: Transform.translate(
        offset: const Offset(0, -20),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          width: 75,
          height: 75,
          decoration: BoxDecoration(
            color: corTema,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.4),
                blurRadius: 15,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: AnimatedScale(
            duration: const Duration(milliseconds: 200),
            scale: ativo ? 1.1 : 1.0,
            child: Center(
              child: Image.asset(
                imagem,
                height: 35,
                color: Colors.black.withAlpha(230),
                colorBlendMode: BlendMode.srcIn,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _IntroAppDialog extends StatefulWidget {
  final String nomeUsuario;
  final ValueChanged<int> onTrocarAba;
  final Future<void> Function() onFinalizar;

  const _IntroAppDialog({
    required this.nomeUsuario,
    required this.onTrocarAba,
    required this.onFinalizar,
  });

  @override
  State<_IntroAppDialog> createState() => _IntroAppDialogState();
}

class _IntroAppDialogState extends State<_IntroAppDialog> {
  int passoAtual = 0;

  static const List<_IntroPasso> _passos = [
    _IntroPasso(
      aba: 2,
      icone: Icons.pets_rounded,
      titulo: '',
      subtitulo: 'Seu companheiro de jornada está chegando.',
      destaque:
          'Durante 30 dias você vai receber um desafio focado em desenvolver a sua INTELIGÊNCIA EMOCIONAL.',
      pergunta: 'Se tudo é um treinamento, o que você anda treinando?',
      corpo: [
        'Que linda escolha, nós estamos muito felizes pela sua decisão em mudar seu futuro.',
        'Estamos aqui para ajudar você a refletir sobre suas escolhas e sobre o que você anda treinando.',
        'Para aprender a andar de bicicleta, ficamos treinando, certo?',
        'E se eu te falasse que raiva, tristeza e mágoa podem estar sendo treinadas no seu subconsciente sem você perceber?',
      ],
      fechamento:
          'Vamos juntos treinar boas energias, alegria, gratidão e amor?',
      botao: 'AVANÇAR',
    ),
    _IntroPasso(
      aba: 1,
      icone: Icons.menu_book_rounded,
      titulo: 'Conteúdos',
      subtitulo: 'Tudo que sustenta sua caminhada fica guardado aqui.',
      destaque:
          'Nesta área você encontra seus desafios feitos, reflexões, podcasts, livro, notificações e materiais importantes.',
      pergunta: 'Quando quiser revisitar um aprendizado, volte por aqui.',
      corpo: [
        'A aba de conteúdos funciona como a biblioteca da sua jornada.',
        'Ela reúne o que você constrói no aplicativo para que suas respostas, reflexões e aprendizados não fiquem perdidos pelo caminho.',
      ],
      fechamento:
          'É o seu espaço para lembrar, reler e perceber o quanto você já avançou.',
      botao: 'CONHECER LOJA',
    ),
    _IntroPasso(
      aba: 0,
      icone: Icons.storefront_rounded,
      titulo: 'Loja',
      subtitulo: 'Um cantinho para personalizar sua experiência.',
      destaque:
          'Aqui você poderá mudar o visual do aplicativo e, futuramente, escolher roupinhas e itens para o pet.',
      pergunta: 'O app também pode ter a sua cara.',
      corpo: [
        'A lojinha foi pensada para deixar a jornada mais leve e divertida.',
        'Conforme você avança, ganha pontos e pode trocar por temas, detalhes visuais e personalizações especiais.',
      ],
      fechamento:
          'É uma recompensa bonita para quem está treinando constância.',
      botao: 'VER PET',
    ),
    _IntroPasso(
      aba: 3,
      icone: Icons.favorite_rounded,
      titulo: 'Gratidão',
      subtitulo: 'Seu pet vai caminhar com você.',
      destaque:
          'O pet Gratidão será um símbolo da sua evolução, do cuidado diário e das escolhas que fortalecem sua jornada.',
      pergunta: 'Quanto mais você avança, mais essa companhia ganha sentido.',
      corpo: [
        'Esta área será dedicada ao seu pet dentro do aplicativo.',
        'A ideia é que ele acompanhe seu progresso, receba carinho visual e ajude a tornar o processo mais acolhedor.',
      ],
      fechamento:
          'Por enquanto ele está chegando aos poucos, mas já faz parte da história.',
      botao: 'IR PARA CONFIG',
    ),
    _IntroPasso(
      aba: 4,
      icone: Icons.tune_rounded,
      titulo: 'Configurações',
      subtitulo: 'O controle do aplicativo fica aqui.',
      destaque:
          'Nesta aba você pode ajustar dados da conta, acessar ajuda, ver informações do projeto e sair com segurança.',
      pergunta: 'Use quando precisar deixar o app mais confortável para você.',
      corpo: [
        'As configurações são o lugar dos ajustes gerais.',
        'Sempre que quiser revisar sua conta, procurar suporte ou entender melhor o aplicativo, venha para esta aba.',
      ],
      fechamento: 'Agora sim: a jornada está pronta para começar.',
      botao: 'COMEÇAR JORNADA',
    ),
  ];

  void _avancar() {
    if (passoAtual == _passos.length - 1) {
      widget.onFinalizar();
      return;
    }

    final proximo = passoAtual + 1;
    setState(() => passoAtual = proximo);
    widget.onTrocarAba(_passos[proximo].aba);
  }

  void _voltar() {
    if (passoAtual == 0) return;

    final anterior = passoAtual - 1;
    setState(() => passoAtual = anterior);
    widget.onTrocarAba(_passos[anterior].aba);
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final corTema = tema.colorScheme.primary;
    final largura = MediaQuery.sizeOf(context).width;
    final larguraCard = (largura - 36).clamp(300.0, 390.0).toDouble();
    final textoPrincipal =
        tema.brightness == Brightness.dark ? Colors.white : Colors.black;
    final textoSecundario =
        tema.brightness == Brightness.dark ? Colors.white70 : Colors.black54;
    final passo = _passos[passoAtual];
    final titulo =
        passoAtual == 0 ? 'Oii, ${widget.nomeUsuario}!!!!!' : passo.titulo;

    return SafeArea(
      child: Align(
        alignment:
            largura > 430 ? Alignment.centerRight : const Alignment(0.25, 0),
        child: Material(
          color: Colors.transparent,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 260),
            switchInCurve: Curves.easeOutCubic,
            switchOutCurve: Curves.easeInCubic,
            transitionBuilder: (child, animation) {
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0.04, 0),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                ),
              );
            },
            child: Container(
              key: ValueKey(passoAtual),
              width: larguraCard,
              constraints: const BoxConstraints(maxWidth: 390),
              margin: const EdgeInsets.fromLTRB(18, 18, 28, 18),
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xFF2A2527),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: corTema.withAlpha(135)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(120),
                    blurRadius: 28,
                    offset: const Offset(0, 14),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            color: corTema.withAlpha(42),
                            shape: BoxShape.circle,
                            border: Border.all(color: corTema.withAlpha(115)),
                          ),
                          child: Icon(
                            passo.icone,
                            color: corTema,
                            size: 34,
                          ),
                        ),
                        const SizedBox(width: 13),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                titulo,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: textoPrincipal,
                                  fontSize: 20,
                                  height: 1.15,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                passo.subtitulo,
                                style: TextStyle(
                                  color: textoSecundario,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    for (final texto in passo.corpo)
                      _IntroTexto(
                        texto: texto,
                        cor: texto == passo.corpo.first
                            ? textoPrincipal
                            : textoSecundario,
                        peso: texto == passo.corpo.first
                            ? FontWeight.w700
                            : FontWeight.w500,
                      ),
                    _IntroDestaque(cor: corTema, texto: passo.destaque),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: corTema.withAlpha(32),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: corTema.withAlpha(105)),
                      ),
                      child: Text(
                        passo.pergunta,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: corTema,
                          fontSize: 17,
                          height: 1.25,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      passo.fechamento,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: textoPrincipal,
                        fontSize: 16,
                        height: 1.35,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        _passos.length,
                        (index) => AnimatedContainer(
                          duration: const Duration(milliseconds: 220),
                          width: index == passoAtual ? 22 : 7,
                          height: 7,
                          margin: const EdgeInsets.symmetric(horizontal: 3),
                          decoration: BoxDecoration(
                            color: index == passoAtual
                                ? corTema
                                : Colors.white.withAlpha(70),
                            borderRadius: BorderRadius.circular(99),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        if (passoAtual > 0) ...[
                          Expanded(
                            child: SizedBox(
                              height: 50,
                              child: OutlinedButton.icon(
                                onPressed: _voltar,
                                icon: const Icon(Icons.arrow_back_rounded),
                                label: const Text('VOLTAR'),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: textoPrincipal,
                                  side: BorderSide(
                                    color: Colors.white.withAlpha(90),
                                  ),
                                  textStyle: const TextStyle(
                                    fontWeight: FontWeight.w900,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                        ],
                        Expanded(
                          child: SizedBox(
                            height: 50,
                            child: ElevatedButton.icon(
                              onPressed: _avancar,
                              icon: Icon(
                                passoAtual == _passos.length - 1
                                    ? Icons.check_rounded
                                    : Icons.arrow_forward_rounded,
                              ),
                              label: Text(passo.botao),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: corTema,
                                foregroundColor: Colors.black,
                                textStyle: const TextStyle(
                                  fontWeight: FontWeight.w900,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _IntroPasso {
  final int aba;
  final IconData icone;
  final String titulo;
  final String subtitulo;
  final List<String> corpo;
  final String destaque;
  final String pergunta;
  final String fechamento;
  final String botao;

  const _IntroPasso({
    required this.aba,
    required this.icone,
    required this.titulo,
    required this.subtitulo,
    required this.corpo,
    required this.destaque,
    required this.pergunta,
    required this.fechamento,
    required this.botao,
  });
}

class _IntroTexto extends StatelessWidget {
  final String texto;
  final Color cor;
  final FontWeight peso;

  const _IntroTexto({
    required this.texto,
    required this.cor,
    this.peso = FontWeight.w500,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 11),
      child: Text(
        texto,
        style: TextStyle(
          color: cor,
          fontSize: 14,
          height: 1.42,
          fontWeight: peso,
        ),
      ),
    );
  }
}

class _IntroDestaque extends StatelessWidget {
  final Color cor;
  final String texto;

  const _IntroDestaque({required this.cor, required this.texto});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cor.withAlpha(34),
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: cor.withAlpha(110)),
      ),
      child: Text(
        texto,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: cor,
          fontSize: 15,
          height: 1.32,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}
