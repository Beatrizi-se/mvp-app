import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await _plugin.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        debugPrint('Notificação clicada: ${response.payload}');
      },
    );

    // Solicitar permissões para Android 13+
    if (Platform.isAndroid) {
      final androidImplementation = _plugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      await androidImplementation?.requestNotificationsPermission();
    }
  }

  Future<void> testarLembrete() async {
    try {
      const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
        'lembretes_tdah',
        'Lembretes',
        channelDescription: 'Canal para lembretes de tarefas',
        importance: Importance.max,
        priority: Priority.high,
        enableVibration: true,
        playSound: true,
      );

      const NotificationDetails platformDetails = NotificationDetails(
        android: androidDetails,
      );

      await _plugin.show(
        id: 0,
        title: 'Tarefa registrada! 🔔',
        body: 'Que tal dar o primeiro passo agora?',
        notificationDetails: platformDetails,
        payload: 'task_created',
      );
      debugPrint('Notificação enviada com sucesso');
    } catch (e) {
      debugPrint('Erro ao enviar notificação: $e');
    }
  }
}
