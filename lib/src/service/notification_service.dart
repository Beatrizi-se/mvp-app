import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await _plugin.initialize(settings: initializationSettings);
  }

  Future<void> testarLembrete() async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'lembretes_tdah', 
      'Lembretes',
      importance: Importance.max,
      priority: Priority.high,
      enableVibration: true, 
    );

    const NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
    );

    await _plugin.show(
      id: 0, 
      title: 'Tarefa registrada! 🔔', 
      body: 'Que tal dar o primeiro passo agora?', 
      notificationDetails: platformDetails,
    );
  }
}