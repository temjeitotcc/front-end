import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main.dart';
import 'services/app_theme_service.dart';
import 'services/auth_service.dart';
import 'services/notificacao_service.dart';

class ConfigPage extends StatefulWidget {
  const ConfigPage({super.key});

  @override
  State<ConfigPage> createState() => _ConfigPageState();
}

class _ConfigPageState extends State<ConfigPage> {
  bool notificacoes = true;
  bool som = true;
  bool vibracao = true;
  bool modoEscuro = true;
  String temaCoresAtual = AppThemeService.temaPadrao;
  List<AppThemeOption> temasComprados = [AppThemeService.temas.first];
  double volume = 50;

  @override
  void initState() {
    super.initState();
    carregarConfiguracoes();
  }

  Future<void> carregarConfiguracoes() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;

    setState(() {
      notificacoes = prefs.getBool('notificações') ?? true;
      som = prefs.getBool('som') ?? true;
      vibracao = prefs.getBool('vibracao') ?? true;
      modoEscuro = prefs.getBool('modoEscuro') ?? true;
      volume = prefs.getDouble('volume') ?? 50;
    });

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
        final modoEscuro = Theme.of(context).brightness == Brightness.dark;
        final fundoSheet =
            modoEscuro ? const Color(0xFF2A2527) : const Color(0xFFFFFBF0);
        final textoPrincipal = modoEscuro ? Colors.white : Colors.black;
        final textoSecundario = modoEscuro ? Colors.white70 : Colors.black54;

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
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 20, bottom: 24),
            decoration: BoxDecoration(
              color: corTema,
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(28),
              ),
            ),
            child: const Column(
              children: [
                Icon(Icons.settings_rounded, color: Colors.white, size: 34),
                SizedBox(height: 8),
                Text(
                  'Configurações',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
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
                Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const _LeadingIcon(icon: Icons.volume_up_outlined),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Text(
                              'Volume: ${volume.round()}%',
                              style: TextStyle(
                                color: textoPrincipal,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Slider(
                        value: volume,
                        min: 0,
                        max: 100,
                        divisions: 100,
                        activeColor: corTema,
                        inactiveColor: Colors.white24,
                        label: '${volume.round()}%',
                        onChanged: (valor) async {
                          setState(() {
                            volume = valor;
                          });

                          final prefs = await SharedPreferences.getInstance();
                          await prefs.setDouble('volume', valor);
                        },
                      ),
                    ],
                  ),
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
                _SwitchTile(
                  icon: Icons.dark_mode_outlined,
                  titulo: 'Modo escuro',
                  subtitulo: 'Tema visual do aplicativo',
                  valor: modoEscuro,
                  cardColor: cardColor,
                  textoPrincipal: textoPrincipal,
                  textoSecundario: textoSecundario,
                  onChanged: (valor) async {
                    setState(() => modoEscuro = valor);
                    await salvarBool('modoEscuro', valor);
                    await MyApp.of(context).trocarTema(valor);
                  },
                ),

                const SizedBox(height: 18),
                const _SectionTitle('Suporte'),
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
                        style: TextStyle(
                          color: textoSecundario,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.white54,
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
    final corTema = Theme.of(context).colorScheme.primary;

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
                  color: Colors.white54,
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
              inactiveTrackColor: Colors.white24,
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
        color: corTema.withOpacity(0.18),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Icon(icon, color: corTema, size: 24),
    );
  }
}

class ContaPage extends StatefulWidget {
  const ContaPage({super.key});

  @override
  State<ContaPage> createState() => _ContaPageState();
}

class _ContaPageState extends State<ContaPage> {
  String email = '';

  @override
  void initState() {
    super.initState();
    carregarEmail();
  }

  Future<void> carregarEmail() async {
    final emailAtual = await AuthService.emailAtual();

    setState(() {
      email = emailAtual ?? 'Email não encontrado';
    });
  }

  @override
  Widget build(BuildContext context) {
    final fundo = Theme.of(context).scaffoldBackgroundColor;
    final texto = Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : Colors.black;
    final cardColor = Theme.of(context).brightness == Brightness.dark
        ? const Color(0xFF2A2527)
        : Colors.white;

    return Scaffold(
      backgroundColor: fundo,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
          'Conta',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                children: [
                  const _LeadingIcon(icon: Icons.person_outline_rounded),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Email',
                          style: TextStyle(
                            color: texto,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          email,
                          style: TextStyle(
                            color: Colors.white60,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onPressed: () async {
                await MyApp.of(context).sairDaConta();

                if (!context.mounted) return;

                Navigator.of(context).pop();
              },
              icon: Icon(Icons.logout_rounded),
              label: Text(
                'Sair da conta',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SobrePage extends StatelessWidget {
  const SobrePage({super.key});

  @override
  Widget build(BuildContext context) {
    final fundo = Theme.of(context).scaffoldBackgroundColor;
    final texto = Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : Colors.black;

    return Scaffold(
      backgroundColor: fundo,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
          'Sobre',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Text(
          'Tem Jeito vale a pena\n\nVersão 1.0\n\nTCC',
          style: TextStyle(color: texto, fontSize: 16),
        ),
      ),
    );
  }
}

class AjudaPage extends StatelessWidget {
  const AjudaPage({super.key});

  @override
  Widget build(BuildContext context) {
    final fundo = Theme.of(context).scaffoldBackgroundColor;
    final texto = Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : Colors.black;

    return Scaffold(
      backgroundColor: fundo,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
          'Ajuda',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Text(
          'Aqui você pode colocar dúvidas frequentes, instrucoes de uso e contato de suporte.',
          style: TextStyle(color: texto, fontSize: 16),
        ),
      ),
    );
  }
}
