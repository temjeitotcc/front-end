import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
<<<<<<< HEAD
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
=======
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'mainscreen.dart';
import 'pages/auth/auth_page.dart';
import 'services/app_theme_service.dart';
import 'services/notificacao_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.manual,
    overlays: [SystemUiOverlay.bottom],
>>>>>>> 389b1eacbab482f0d0e9afc27ecece2c796c0ffc
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

<<<<<<< HEAD
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

=======
>>>>>>> 389b1eacbab482f0d0e9afc27ecece2c796c0ffc
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool modoEscuro = true;
<<<<<<< HEAD
  bool carregandoLogin = true;
  bool usuarioLogado = false;
=======
>>>>>>> 389b1eacbab482f0d0e9afc27ecece2c796c0ffc

  @override
  void initState() {
    super.initState();
    carregarTema();
    AppThemeService.carregarTema();
<<<<<<< HEAD
    carregarLogin();
=======
>>>>>>> 389b1eacbab482f0d0e9afc27ecece2c796c0ffc
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

<<<<<<< HEAD
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

=======
>>>>>>> 389b1eacbab482f0d0e9afc27ecece2c796c0ffc
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
<<<<<<< HEAD
            appBarTheme: AppBarTheme(
              backgroundColor: temaCores.primary,
              centerTitle: true,
              titleTextStyle: TextStyle(
                color: Colors.black,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
=======
>>>>>>> 389b1eacbab482f0d0e9afc27ecece2c796c0ffc
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
<<<<<<< HEAD
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
=======
          ),

          home: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(
                      color: temaCores.primary,
                    ),
                  ),
                );
              }

              if (snapshot.hasData) {
                return const MainScreen();
              } else {
                return const AuthPage();
              }
            },
          ),
>>>>>>> 389b1eacbab482f0d0e9afc27ecece2c796c0ffc
        );
      },
    );
  }
<<<<<<< HEAD
}
=======
}
>>>>>>> 389b1eacbab482f0d0e9afc27ecece2c796c0ffc
