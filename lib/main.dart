import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'mainscreen.dart';
import 'pages/auth/auth_page.dart';
import 'services/app_theme_service.dart';
import 'services/auth_service.dart';
import 'services/notificacao_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  static _MyAppState of(BuildContext context) {
    final state = maybeOf(context);
    if (state == null) {
      throw FlutterError('MyApp.of() called with a context that has no MyApp.');
    }
    return state;
  }

  static _MyAppState? maybeOf(BuildContext context) {
    return context.findAncestorStateOfType<_MyAppState>();
  }

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool modoEscuro = true;
  bool carregandoLogin = true;
  bool usuarioLogado = false;

  @override
  void initState() {
    super.initState();
    carregarTema();
    AppThemeService.carregarTema();
    carregarLogin();
    configurarNotificacoes();
  }

  Future<void> configurarNotificacoes() async {
    await NotificacaoService.inicializar();
    await NotificacaoService.configurarPeloPreferencias();
  }

  Future<void> carregarTema() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      modoEscuro = prefs.getBool('modoEscuro') ?? true;
    });
  }

  Future<void> carregarLogin() async {
    final logado = await AuthService.estaLogado();

    setState(() {
      usuarioLogado = logado;
      carregandoLogin = false;
    });
  }

  Future<void> atualizarLogin() async {
    final logado = await AuthService.estaLogado();

    setState(() {
      usuarioLogado = logado;
      carregandoLogin = false;
    });
  }

  Future<void> sairDaConta() async {
    await AuthService.sair();

    setState(() {
      usuarioLogado = false;
    });
  }

  Future<void> trocarTema(bool valor) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('modoEscuro', valor);

    setState(() {
      modoEscuro = valor;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppThemeOption>(
      valueListenable: AppThemeService.temaAtual,
      builder: (context, temaCores, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,

          themeMode: modoEscuro ? ThemeMode.dark : ThemeMode.light,

          theme: ThemeData(
            brightness: Brightness.light,
            scaffoldBackgroundColor: const Color(0xFFF7F4EA),
            colorScheme: ColorScheme.fromSeed(
              seedColor: temaCores.primary,
              brightness: Brightness.light,
              primary: temaCores.primary,
              secondary: temaCores.secondary,
            ),
            appBarTheme: AppBarTheme(
              backgroundColor: temaCores.primary,
              centerTitle: true,
              titleTextStyle: TextStyle(
                color: Colors.black,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          darkTheme: ThemeData(
            brightness: Brightness.dark,
            scaffoldBackgroundColor: const Color(0xFF1B1819),
            colorScheme: ColorScheme.fromSeed(
              seedColor: temaCores.primary,
              brightness: Brightness.dark,
              primary: temaCores.primary,
              secondary: temaCores.secondary,
            ),
            appBarTheme: AppBarTheme(
              backgroundColor: temaCores.primary,
              centerTitle: true,
              titleTextStyle: TextStyle(
                color: Colors.black,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          home: carregandoLogin
              ? Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(color: temaCores.primary),
                  ),
                )
              : usuarioLogado
              ? const MainScreen()
              : const AuthPage(),
        );
      },
    );
  }
}
