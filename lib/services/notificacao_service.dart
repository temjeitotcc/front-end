import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificacaoConfig {
  static const Duration intervalo = Duration(hours: 4);
  static const String titulo = 'Tem Jeito';

  static const List<String> mensagens = [
    'Venha concluir suas missões de hoje.',
    'Sua saúde melhora um passo de cada vez.',
    'Que tal continuar sua jornada agora?',
    'Volte para cuidar de você mais um pouco.',
  ];
}

class NotificacaoService {
  static const int _notificacaoMotivacionalId = 1001;
  static const int _notificacaoTesteId = 1002;
  static const String _canalId = 'lembretes_motivacionais';
  static const String _canalNome = 'Lembretes motivacionais';
  static const String _canalDescricao =
      'Notificações para incentivar o uso do aplicativo.';

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
    final notificacoesAtivas = prefs.getBool('notificações') ?? true;

    if (notificacoesAtivas) {
      await ativarLembretes(pedirPermissao: false);
    } else {
      await desativarLembretes();
    }
  }

  static Future<bool> ativarLembretes({bool pedirPermissao = true}) async {
    await inicializar();

    final permitido = pedirPermissao
        ? await _pedirPermissao()
        : await _temPermissao();
    if (!permitido) return false;

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

    return true;
  }

  static Future<void> desativarLembretes() async {
    await inicializar();
    await _plugin.cancel(id: _notificacaoMotivacionalId);
  }

  static Future<bool> mostrarTeste() async {
    await inicializar();

    final permitido = await _pedirPermissao();
    if (!permitido) return false;

    await _plugin.show(
      id: _notificacaoTesteId,
      title: NotificacaoConfig.titulo,
      body: _mensagemAtual(),
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
      payload: 'teste_notificação',
    );

    return true;
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

  static Future<bool> _temPermissao() async {
    final android = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    final permitidoAndroid = await android?.areNotificationsEnabled();
    if (permitidoAndroid == false) return false;

    return true;
  }

  static String _mensagemAtual() {
    final mensagens = NotificacaoConfig.mensagens;
    if (mensagens.isEmpty) return 'Volte para continuar sua jornada.';

    final agora = DateTime.now();
    final indice = (agora.day + agora.hour) % mensagens.length;
    return mensagens[indice];
  }
}
