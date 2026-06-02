import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'main.dart';
import 'services/app_theme_service.dart';
import 'services/notificacao_service.dart';
import 'pages/auth/auth_page.dart';
import 'pages/conta_page.dart';

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

    if (!temasDisponiveis.any((t) => t.id == AppThemeService.temaPadrao)) {
      temasDisponiveis.insert(0, AppThemeService.temas.first);
    }

    if (!temasDisponiveis.any((t) => t.id == temaAtual.id)) {
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
      temasComprados =
          comprados.isEmpty ? [AppThemeService.temas.first] : comprados;
      temaCoresAtual = AppThemeService.temaAtual.value.id;
    });

    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;

        final fundo = isDark
            ? const Color(0xFF2A2527)
            : const Color(0xFFFFFBF0);

        final texto = isDark ? Colors.white : Colors.black;
        final textoSec = isDark ? Colors.white70 : Colors.black54;

        return SafeArea(
          child: Container(
            margin: const EdgeInsets.all(14),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: fundo,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Tema do aplicativo',
                  style: TextStyle(
                    color: texto,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),

                for (final tema in temasComprados)
                  ListTile(
                    title: Text(
                      tema.nome,
                      style: TextStyle(color: texto),
                    ),
                    subtitle: Text(
                      tema.id,
                      style: TextStyle(color: textoSec),
                    ),
                    trailing: tema.id == temaCoresAtual
                        ? Icon(Icons.check, color: tema.primary)
                        : null,
                    onTap: () async {
                      Navigator.pop(context);
                      await AppThemeService.selecionarTema(tema.id);

                      if (!mounted) return;

                      setState(() {
                        temaCoresAtual = tema.id;
                      });
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

    final texto = Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : Colors.black;

    final card = Theme.of(context).brightness == Brightness.dark
        ? const Color(0xFF2A2527)
        : Colors.white;

    final corTema = Theme.of(context).colorScheme.primary;

    return Scaffold(
      backgroundColor: fundo,
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 40, bottom: 24),
            decoration: BoxDecoration(
              color: corTema,
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(28),
              ),
            ),
            child: const Column(
              children: [
                Icon(Icons.settings, color: Colors.white, size: 34),
                SizedBox(height: 8),
                Text(
                  'Configurações',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const SizedBox(height: 10),

                ListTile(
                  tileColor: card,
                  leading: const Icon(Icons.person),
                  title: Text('Conta', style: TextStyle(color: texto)),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => ContaPage()),
                    );
                  },
                ),

                const SizedBox(height: 10),

                ListTile(
                  tileColor: card,
                  leading: const Icon(Icons.palette),
                  title: Text('Tema', style: TextStyle(color: texto)),
                  onTap: abrirSeletorDeTema,
                ),

                const SizedBox(height: 10),

                SwitchListTile(
                  tileColor: card,
                  value: notificacoes,
                  title: Text('Notificações', style: TextStyle(color: texto)),
                  onChanged: (v) async {
                    setState(() => notificacoes = v);
                    await salvarBool('notificações', v);

                    if (v) {
                      await NotificacaoService.ativarLembretes();
                    } else {
                      await NotificacaoService.desativarLembretes();
                    }
                  },
                ),

                SwitchListTile(
                  tileColor: card,
                  value: vibracao,
                  title: Text('Vibração', style: TextStyle(color: texto)),
                  onChanged: (v) async {
                    setState(() => vibracao = v);
                    await salvarBool('vibracao', v);
                  },
                ),

                SwitchListTile(
                  tileColor: card,
                  value: modoEscuro,
                  title: Text('Modo escuro', style: TextStyle(color: texto)),
                  onChanged: (v) async {
                    setState(() => modoEscuro = v);
                    await salvarBool('modoEscuro', v);
                  },
                ),

                const SizedBox(height: 20),

                ListTile(
                  tileColor: card,
                  leading: const Icon(Icons.logout, color: Colors.red),
                  title: const Text(
                    'Sair da conta',
                    style: TextStyle(color: Colors.red),
                  ),
                  onTap: () async {
                    await FirebaseAuth.instance.signOut();

                    if (!context.mounted) return;

                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (_) => const AuthPage(),
                      ),
                      (route) => false,
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