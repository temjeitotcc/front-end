import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main.dart';

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

  @override
  void initState() {
    super.initState();
    carregarConfiguracoes();
  }

  Future<void> carregarConfiguracoes() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      notificacoes = prefs.getBool('notificacoes') ?? true;
      som = prefs.getBool('som') ?? true;
      vibracao = prefs.getBool('vibracao') ?? true;
      modoEscuro = prefs.getBool('modoEscuro') ?? true;
    });
  }

  Future<void> salvarBool(String chave, bool valor) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(chave, valor);
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

    return Scaffold(
      backgroundColor: fundo,
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 20, bottom: 24),
            decoration: const BoxDecoration(
              color: Color(0xFFFED23E),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
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
                    await salvarBool('notificacoes', valor);
                  },
                ),
                _SwitchTile(
                  icon: Icons.volume_up_outlined,
                  titulo: 'Som',
                  subtitulo: 'Efeitos sonoros do app',
                  valor: som,
                  cardColor: cardColor,
                  textoPrincipal: textoPrincipal,
                  textoSecundario: textoSecundario,
                  onChanged: (valor) async {
                    setState(() => som = valor);
                    await salvarBool('som', valor);
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
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 10),
      child: Text(
        texto,
        style: const TextStyle(
          color: Color(0xFFFED23E),
          fontSize: 15,
          fontWeight: FontWeight.bold,
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
                const Icon(
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
              activeColor: Colors.black,
              activeTrackColor: const Color(0xFFFED23E),
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
    return Container(
      width: 46,
      height: 46,
      decoration: BoxDecoration(
        color: const Color(0xFFFED23E).withOpacity(0.18),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Icon(icon, color: const Color(0xFFFED23E), size: 24),
    );
  }
}

class ContaPage extends StatelessWidget {
  const ContaPage({super.key});

  @override
  Widget build(BuildContext context) {
    final fundo = Theme.of(context).scaffoldBackgroundColor;
    final texto = Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : Colors.black;

    return Scaffold(
      backgroundColor: fundo,
      appBar: AppBar(
        backgroundColor: const Color(0xFFFED23E),
        title: const Text(
          'Conta',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Text(
          'Aqui você pode mostrar informações do usuário, nome, email e outras opções de conta.',
          style: TextStyle(color: texto, fontSize: 16),
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
        backgroundColor: const Color(0xFFFED23E),
        title: const Text(
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
        backgroundColor: const Color(0xFFFED23E),
        title: const Text(
          'Ajuda',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Text(
          'Aqui você pode colocar dúvidas frequentes, instruções de uso e contato de suporte.',
          style: TextStyle(color: texto, fontSize: 16),
        ),
      ),
    );
  }
}
