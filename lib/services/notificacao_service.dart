import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificacaoService {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> iniciar() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');

    const settings = InitializationSettings(android: android);

    await _plugin.initialize(settings);
  }

  static Future<void> mostrarNotificacao() async {
    const androidDetails = AndroidNotificationDetails(
      'canal_tcc',
      'Notificações do TCC',
      importance: Importance.max,
      priority: Priority.high,
    );

    const details = NotificationDetails(android: androidDetails);

    await _plugin.show(0, 'Tem Jeito', 'Notificação funcionando!', details);
  }
}
