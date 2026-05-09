import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificacaoConfig {
  static const Duration intervalo = Duration(seconds: 4);
  static const String titulo = 'Tem Jeito';

  static const List<String> mensagens = [
    'Venha concluir suas missoes de hoje.',
    'Sua saude melhora um passo de cada vez.',
    'Que tal continuar sua jornada agora?',
    'Volte para cuidar de voce mais um pouco.',
  ];
}

class NotificacaoService {
  static const int _notificacaoMotivacionalId = 1001;
  static const String _canalId = 'lembretes_motivacionais';
  static const String _canalNome = 'Lembretes motivacionais';
  static const String _canalDescricao =
      'Notificacoes para incentivar o uso do aplicativo.';

  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static bool _inicializado = false;

  static Future<void> inicializar() async {
    if (_inicializado) return;

    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const settings = InitializationSettings(android: android, iOS: ios);

    await _plugin.initialize(settings: settings);
    _inicializado = true;
  }

  static Future<void> configurarPeloPreferencias() async {
    final prefs = await SharedPreferences.getInstance();
    final notificacoesAtivas = prefs.getBool('notificacoes') ?? true;

    if (notificacoesAtivas) {
      await ativarLembretes();
    } else {
      await desativarLembretes();
    }
  }

  static Future<void> ativarLembretes() async {
    await inicializar();

    final permitido = await _pedirPermissao();
    if (!permitido) return;

    await _plugin.cancel(id: _notificacaoMotivacionalId);

    await _plugin.periodicallyShowWithDuration(
      id: _notificacaoMotivacionalId,
      title: NotificacaoConfig.titulo,
      body: _mensagemAtual(),
      repeatDurationInterval: NotificacaoConfig.intervalo,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          _canalId,
          _canalNome,
          channelDescription: _canalDescricao,
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      payload: 'lembrete_motivacional',
    );
  }

  static Future<void> desativarLembretes() async {
    await inicializar();
    await _plugin.cancel(id: _notificacaoMotivacionalId);
  }

  static Future<bool> _pedirPermissao() async {
    final android = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    final permissaoAndroid = await android?.requestNotificationsPermission();
    if (permissaoAndroid == false) return false;

    final ios = _plugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >();

    final permissaoIos = await ios?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );

    return permissaoIos ?? true;
  }

  static String _mensagemAtual() {
    final mensagens = NotificacaoConfig.mensagens;
    if (mensagens.isEmpty) return 'Volte para continuar sua jornada.';

    final agora = DateTime.now();
    final indice = (agora.day + agora.hour) % mensagens.length;
    return mensagens[indice];
  }
}
