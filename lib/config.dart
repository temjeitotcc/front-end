import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'pages/login/conta_page.dart';
import 'pages/auth/auth_page.dart';
import 'services/app_theme_service.dart';
import 'services/notificacao_service.dart';
import 'widgets/main_tab_header.dart';

class ConfigPage extends StatefulWidget {
  final VoidCallback? onAbrirTutorial;

  const ConfigPage({super.key, this.onAbrirTutorial});

  @override
  State<ConfigPage> createState() => _ConfigPageState();
}

class _ConfigPageState extends State<ConfigPage> {
  bool notificacoes = true;
  bool som = true;
  bool vibracao = true;
  String temaCoresAtual = AppThemeService.temaPadrao;
  List<AppThemeOption> temasComprados = [AppThemeService.temas.first];

  @override
  void initState() {
    super.initState();
    carregarConfiguracoes();
  }

  Future<void> carregarConfiguracoes() async {
    final prefs = await SharedPreferences.getInstance();
    final comprados = await AppThemeService.temasComprados();
    final temaAtual = AppThemeService.temaAtual.value;
    final temasDisponiveis = [...comprados];

    if (!temasDisponiveis.any(
      (tema) => tema.id == AppThemeService.temaPadrao,
    )) {
      temasDisponiveis.insert(0, AppThemeService.temas.first);
    }

    if (!temasDisponiveis.any((tema) => tema.id == temaAtual.id)) {
      temasDisponiveis.add(temaAtual);
    }

    if (!mounted) return;

    setState(() {
      notificacoes = prefs.getBool('notificações') ?? true;
      som = prefs.getBool('som') ?? true;
      vibracao = prefs.getBool('vibracao') ?? true;
      temasComprados = temasDisponiveis;
      temaCoresAtual = temaAtual.id;
    });
  }

  Future<void> salvarBool(String chave, bool valor) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(chave, valor);
  }

  Future<void> abrirSeletorDeTema() async {
    final comprados = await AppThemeService.temasComprados();
    if (!mounted) return;

    setState(() {
      temasComprados = comprados.isEmpty
          ? [AppThemeService.temas.first]
          : comprados;
      temaCoresAtual = AppThemeService.temaAtual.value.id;
    });

    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final modoEscuroAtual = Theme.of(context).brightness == Brightness.dark;
        final fundoSheet = modoEscuroAtual
            ? const Color(0xFF2A2527)
            : const Color(0xFFFFFBF0);
        final textoPrincipal = modoEscuroAtual ? Colors.white : Colors.black;
        final textoSecundario = modoEscuroAtual
            ? Colors.white70
            : Colors.black54;

        return SafeArea(
          child: Container(
            margin: const EdgeInsets.all(14),
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
            decoration: BoxDecoration(
              color: fundoSheet,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Tema do aplicativo',
                  style: TextStyle(
                    color: textoPrincipal,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                for (final tema in temasComprados)
                  _ThemeOptionTile(
                    tema: tema,
                    selecionado: tema.id == AppThemeService.temaAtual.value.id,
                    textoPrincipal: textoPrincipal,
                    textoSecundario: textoSecundario,
                    onTap: () async {
                      Navigator.of(context).pop();
                      await AppThemeService.selecionarTema(tema.id);
                      if (!mounted) return;
                      setState(() => temaCoresAtual = tema.id);
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> sairDaConta() async {
    await FirebaseAuth.instance.signOut();

    if (!mounted) return;

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const AuthPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final fundo = Theme.of(context).scaffoldBackgroundColor;
    final textoPrincipal = Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : Colors.black;
    final textoSecundario = Theme.of(context).brightness == Brightness.dark
        ? Colors.white70
        : Colors.black54;
    final cardColor = Theme.of(context).brightness == Brightness.dark
        ? const Color(0xFF2A2527)
        : Colors.white;
    final corTema = Theme.of(context).colorScheme.primary;

    return Scaffold(
      backgroundColor: fundo,
      body: Column(
        children: [
          const MainTabHeader(
            title: 'Configurações',
            subtitle: 'Personalize sua experiência',
            icon: Icons.settings_rounded,
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 18, 16, 20),
              children: [
                const _SectionTitle('Conta'),
                _ActionTile(
                  icon: Icons.person_outline_rounded,
                  titulo: 'Conta',
                  subtitulo: 'Informações do usuário',
                  cardColor: cardColor,
                  textoPrincipal: textoPrincipal,
                  textoSecundario: textoSecundario,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ContaPage()),
                    );
                  },
                ),
                _ActionTile(
                  icon: Icons.info_outline_rounded,
                  titulo: 'Sobre',
                  subtitulo: 'Informações do aplicativo',
                  cardColor: cardColor,
                  textoPrincipal: textoPrincipal,
                  textoSecundario: textoSecundario,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const SobrePage()),
                    );
                  },
                ),
                const SizedBox(height: 18),
                const _SectionTitle('Preferências'),
                _ThemePickerTile(
                  tema: AppThemeService.temaPorId(temaCoresAtual),
                  cardColor: cardColor,
                  textoPrincipal: textoPrincipal,
                  textoSecundario: textoSecundario,
                  onTap: abrirSeletorDeTema,
                ),
                _SwitchTile(
                  icon: Icons.notifications_none_rounded,
                  titulo: 'Notificações',
                  subtitulo: 'Receber avisos do aplicativo',
                  valor: notificacoes,
                  cardColor: cardColor,
                  textoPrincipal: textoPrincipal,
                  textoSecundario: textoSecundario,
                  onChanged: (valor) async {
                    setState(() => notificacoes = valor);
                    await salvarBool('notificações', valor);

                    if (valor) {
                      final ativado =
                          await NotificacaoService.ativarLembretes();

                      if (!context.mounted) return;

                      if (!ativado) {
                        setState(() => notificacoes = false);
                        await salvarBool('notificações', false);

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Permissão de notificação negada.'),
                          ),
                        );
                      }
                    } else {
                      await NotificacaoService.desativarLembretes();
                    }
                  },
                ),
                _ActionTile(
                  icon: Icons.notification_add_outlined,
                  titulo: 'Testar notificação',
                  subtitulo: 'Enviar uma notificação agora',
                  cardColor: cardColor,
                  textoPrincipal: textoPrincipal,
                  textoSecundario: textoSecundario,
                  onTap: () async {
                    if (!notificacoes) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Ative as notificações para enviar um teste.',
                          ),
                        ),
                      );
                      return;
                    }

                    final enviado = await NotificacaoService.mostrarTeste();

                    if (!context.mounted) return;

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          enviado
                              ? 'Notificação de teste enviada.'
                              : 'Permissão de notificação negada.',
                        ),
                      ),
                    );
                  },
                ),
                _SwitchTile(
                  icon: Icons.vibration_rounded,
                  titulo: 'Vibração',
                  subtitulo: 'Feedback tátil ao interagir',
                  valor: vibracao,
                  cardColor: cardColor,
                  textoPrincipal: textoPrincipal,
                  textoSecundario: textoSecundario,
                  onChanged: (valor) async {
                    setState(() => vibracao = valor);
                    await salvarBool('vibracao', valor);
                  },
                ),
                const SizedBox(height: 18),
                const _SectionTitle('Suporte'),
                _ActionTile(
                  icon: Icons.explore_outlined,
                  titulo: 'Ver tutorial',
                  subtitulo: 'Rever a apresentação do aplicativo',
                  cardColor: cardColor,
                  textoPrincipal: textoPrincipal,
                  textoSecundario: textoSecundario,
                  onTap: widget.onAbrirTutorial ?? () {},
                ),
                _ActionTile(
                  icon: Icons.help_outline_rounded,
                  titulo: 'Ajuda',
                  subtitulo: 'Dúvidas frequentes',
                  cardColor: cardColor,
                  textoPrincipal: textoPrincipal,
                  textoSecundario: textoSecundario,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const AjudaPage()),
                    );
                  },
                ),
                _ActionTile(
                  icon: Icons.logout_rounded,
                  titulo: 'Sair da conta',
                  subtitulo: 'Voltar para a tela de login',
                  cardColor: cardColor,
                  textoPrincipal: Colors.redAccent,
                  textoSecundario: textoSecundario,
                  onTap: sairDaConta,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String texto;

  const _SectionTitle(this.texto);

  @override
  Widget build(BuildContext context) {
    final corTema = Theme.of(context).colorScheme.primary;

    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 10),
      child: Text(
        texto,
        style: TextStyle(
          color: corTema,
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _ThemePickerTile extends StatelessWidget {
  final AppThemeOption tema;
  final VoidCallback onTap;
  final Color cardColor;
  final Color textoPrincipal;
  final Color textoSecundario;

  const _ThemePickerTile({
    required this.tema,
    required this.onTap,
    required this.cardColor,
    required this.textoPrincipal,
    required this.textoSecundario,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: cardColor,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            child: Row(
              children: [
                _ThemeSwatch(tema: tema),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tema do aplicativo',
                        style: TextStyle(
                          color: textoPrincipal,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        tema.nome,
                        style: TextStyle(color: textoSecundario, fontSize: 13),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: textoSecundario,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ThemeOptionTile extends StatelessWidget {
  final AppThemeOption tema;
  final bool selecionado;
  final Color textoPrincipal;
  final Color textoSecundario;
  final VoidCallback onTap;

  const _ThemeOptionTile({
    required this.tema,
    required this.selecionado,
    required this.textoPrincipal,
    required this.textoSecundario,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: selecionado ? tema.primary.withAlpha(42) : Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                _ThemeSwatch(tema: tema),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    tema.nome,
                    style: TextStyle(
                      color: textoPrincipal,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                if (selecionado)
                  Icon(Icons.check_circle_rounded, color: tema.primary)
                else
                  Text(
                    'Disponível',
                    style: TextStyle(color: textoSecundario, fontSize: 12),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ThemeSwatch extends StatelessWidget {
  final AppThemeOption tema;

  const _ThemeSwatch({required this.tema});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 46,
      height: 46,
      decoration: BoxDecoration(
        color: const Color(0xFF171315),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: tema.primary, width: 2),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(11),
        child: Row(
          children: [
            Expanded(child: ColoredBox(color: tema.primary)),
            const Expanded(child: ColoredBox(color: Color(0xFF171315))),
          ],
        ),
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String titulo;
  final String subtitulo;
  final VoidCallback onTap;
  final Color cardColor;
  final Color textoPrincipal;
  final Color textoSecundario;

  const _ActionTile({
    required this.icon,
    required this.titulo,
    required this.subtitulo,
    required this.onTap,
    required this.cardColor,
    required this.textoPrincipal,
    required this.textoSecundario,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: cardColor,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            child: Row(
              children: [
                _LeadingIcon(icon: icon),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        titulo,
                        style: TextStyle(
                          color: textoPrincipal,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitulo,
                        style: TextStyle(color: textoSecundario, fontSize: 13),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: textoSecundario,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SwitchTile extends StatelessWidget {
  final IconData icon;
  final String titulo;
  final String subtitulo;
  final bool valor;
  final ValueChanged<bool> onChanged;
  final Color cardColor;
  final Color textoPrincipal;
  final Color textoSecundario;

  const _SwitchTile({
    required this.icon,
    required this.titulo,
    required this.subtitulo,
    required this.valor,
    required this.onChanged,
    required this.cardColor,
    required this.textoPrincipal,
    required this.textoSecundario,
  });

  @override
  Widget build(BuildContext context) {
    final corTema = Theme.of(context).colorScheme.primary;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            _LeadingIcon(icon: icon),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titulo,
                    style: TextStyle(
                      color: textoPrincipal,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitulo,
                    style: TextStyle(color: textoSecundario, fontSize: 13),
                  ),
                ],
              ),
            ),
            Switch(
              value: valor,
              onChanged: onChanged,
              activeThumbColor: Colors.black,
              activeTrackColor: corTema,
              inactiveThumbColor: Colors.white70,
              inactiveTrackColor: textoSecundario.withAlpha(60),
            ),
          ],
        ),
      ),
    );
  }
}

class _LeadingIcon extends StatelessWidget {
  final IconData icon;

  const _LeadingIcon({required this.icon});

  @override
  Widget build(BuildContext context) {
    final corTema = Theme.of(context).colorScheme.primary;

    return Container(
      width: 46,
      height: 46,
      decoration: BoxDecoration(
        color: corTema.withAlpha(46),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Icon(icon, color: corTema, size: 24),
    );
  }
}

class SobrePage extends StatelessWidget {
  const SobrePage({super.key});

  @override
  Widget build(BuildContext context) {
    final fundo = Theme.of(context).scaffoldBackgroundColor;
    final textoPrincipal = Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : Colors.black;
    final textoSecundario = Theme.of(context).brightness == Brightness.dark
        ? Colors.white70
        : Colors.black54;
    final cardColor = Theme.of(context).brightness == Brightness.dark
        ? const Color(0xFF2A2527)
        : Colors.white;
    final corTema = Theme.of(context).colorScheme.primary;

    return Scaffold(
      backgroundColor: fundo,
      body: Column(
        children: [
          MainTabHeader(
            title: 'Sobre',
            subtitle: 'Conheça melhor o projeto',
            leading: const Icon(
              Icons.arrow_back_rounded,
              color: Colors.white,
              size: 30,
            ),
            onLeadingTap: () => Navigator.of(context).pop(),
            trailing: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(35),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.info_outline_rounded,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 22, 16, 24),
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: corTema.withAlpha(110)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.auto_awesome_rounded,
                        color: corTema,
                        size: 30,
                      ),
                      const SizedBox(height: 14),
                      Text(
                        'Tem Jeito e Vale a Pena',
                        style: TextStyle(
                          color: textoPrincipal,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Um projeto de autoconhecimento, reflexão e '
                        'transformação construído como Trabalho de Conclusão '
                        'de Curso.',
                        style: TextStyle(
                          color: textoSecundario,
                          fontSize: 15,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 18),
                      Divider(color: corTema.withAlpha(80)),
                      const SizedBox(height: 10),
                      Text(
                        'Versão 1.0',
                        style: TextStyle(
                          color: corTema,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AjudaPage extends StatelessWidget {
  const AjudaPage({super.key});

  @override
  Widget build(BuildContext context) {
    final fundo = Theme.of(context).scaffoldBackgroundColor;
    final textoPrincipal = Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : Colors.black;
    final textoSecundario = Theme.of(context).brightness == Brightness.dark
        ? Colors.white70
        : Colors.black54;
    final cardColor = Theme.of(context).brightness == Brightness.dark
        ? const Color(0xFF2A2527)
        : Colors.white;
    final corTema = Theme.of(context).colorScheme.primary;

    return Scaffold(
      backgroundColor: fundo,
      body: Column(
        children: [
          MainTabHeader(
            title: 'Ajuda',
            subtitle: 'Orientações para seguir sua jornada',
            leading: const Icon(
              Icons.arrow_back_rounded,
              color: Colors.white,
              size: 30,
            ),
            onLeadingTap: () => Navigator.of(context).pop(),
            trailing: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(35),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.help_outline_rounded,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 22, 16, 24),
              children: [
                _HelpCard(
                  icon: Icons.flag_outlined,
                  title: 'Como avançar',
                  text:
                      'Conclua cada desafio com atenção. Suas respostas e '
                      'reflexões ficam disponíveis na aba de conteúdos.',
                  cardColor: cardColor,
                  color: corTema,
                  textColor: textoPrincipal,
                  secondaryTextColor: textoSecundario,
                ),
                const SizedBox(height: 12),
                _HelpCard(
                  icon: Icons.palette_outlined,
                  title: 'Temas do aplicativo',
                  text:
                      'Os temas adquiridos na loja podem ser escolhidos nas '
                      'configurações e aplicados ao aplicativo.',
                  cardColor: cardColor,
                  color: corTema,
                  textColor: textoPrincipal,
                  secondaryTextColor: textoSecundario,
                ),
                const SizedBox(height: 12),
                _HelpCard(
                  icon: Icons.support_agent_rounded,
                  title: 'Precisa de suporte?',
                  text:
                      'Caso encontre um problema, anote o desafio e a ação '
                      'realizada para facilitar a identificação.',
                  cardColor: cardColor,
                  color: corTema,
                  textColor: textoPrincipal,
                  secondaryTextColor: textoSecundario,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HelpCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String text;
  final Color cardColor;
  final Color color;
  final Color textColor;
  final Color secondaryTextColor;

  const _HelpCard({
    required this.icon,
    required this.title,
    required this.text,
    required this.cardColor,
    required this.color,
    required this.textColor,
    required this.secondaryTextColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color.withAlpha(100)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: color.withAlpha(38),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 23),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  text,
                  style: TextStyle(
                    color: secondaryTextColor,
                    fontSize: 14,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
