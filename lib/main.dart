import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'firebase_options.dart';
import 'mainscreen.dart';
import 'pages/auth/auth_page.dart';
import 'services/app_theme_service.dart';
import 'services/notificacao_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.manual,
    overlays: [SystemUiOverlay.bottom],
  );

  await AppThemeService.carregarTema();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    configurarNotificacoes();
  }

  Future<void> configurarNotificacoes() async {
    await NotificacaoService.inicializar();
    await NotificacaoService.configurarPeloPreferencias();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppThemeOption>(
      valueListenable: AppThemeService.temaAtual,
      builder: (context, temaCores, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          themeMode: ThemeMode.dark,
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
              titleTextStyle: const TextStyle(
                color: Colors.black,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
              iconTheme: const IconThemeData(color: Colors.black),
            ),
            snackBarTheme: SnackBarThemeData(
              behavior: SnackBarBehavior.floating,
              backgroundColor: const Color(0xFF2A2527),
              elevation: 10,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(
                  color: temaCores.primary.withAlpha(150),
                  width: 1.5,
                ),
              ),
              contentTextStyle: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                height: 1.3,
                fontWeight: FontWeight.w600,
              ),
              actionTextColor: temaCores.primary,
              disabledActionTextColor: Colors.white38,
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
              titleTextStyle: const TextStyle(
                color: Colors.black,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
              iconTheme: const IconThemeData(color: Colors.black),
            ),
            snackBarTheme: SnackBarThemeData(
              behavior: SnackBarBehavior.floating,
              backgroundColor: const Color(0xFF2A2527),
              elevation: 10,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(
                  color: temaCores.primary.withAlpha(150),
                  width: 1.5,
                ),
              ),
              contentTextStyle: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                height: 1.3,
                fontWeight: FontWeight.w600,
              ),
              actionTextColor: temaCores.primary,
              disabledActionTextColor: Colors.white38,
            ),
          ),
          home: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(color: temaCores.primary),
                  ),
                );
              }

              return snapshot.hasData ? const MainScreen() : const AuthPage();
            },
          ),
        );
      },
    );
  }
}
