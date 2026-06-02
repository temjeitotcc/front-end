import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool modoEscuro = true;

  @override
  void initState() {
    super.initState();
    carregarTema();
    AppThemeService.carregarTema();
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
        );
      },
    );
  }
}