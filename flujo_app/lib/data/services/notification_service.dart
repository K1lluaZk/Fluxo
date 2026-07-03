import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import '../models/note.dart';
import 'package:flutter_timezone/flutter_timezone.dart';

class NotificationService {
  NotificationService._();

  static final NotificationService instance = NotificationService._();

  final FlutterLocalNotificationsPlugin notifications =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    tz.initializeTimeZones();

      final String currentTimeZone =
      await FlutterTimezone.getLocalTimezone();

    tz.setLocalLocation(
      tz.getLocation(currentTimeZone),
    );

    const android = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const settings = InitializationSettings(
      android: android,
    );

    await notifications.initialize(settings);
  }

  /// Solicita permisos para notificaciones en Android
  Future<void> requestPermission() async {
    await notifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  Future<void> show({
    required String title,
    required String body,
  }) async {
    await notifications.show(
      0,
      title,
      body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'fluxo_channel',
          'Fluxo',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
    );
  }

  Future<void> scheduleNoteReminder(
  Note note,
) async {
  if (!note.recordar) return;
  if (note.fechaVencimiento == null) return;

  final fechaNotificacion = note.fechaVencimiento!.subtract(
    Duration(days: note.diasAntes),
  );

  if (fechaNotificacion.isBefore(DateTime.now())) {
    return;
  }

  await notifications.zonedSchedule(
    note.id.hashCode,
    "Recordatorio de Fluxo",
    "La nota '${note.titulo}' vence ${note.diasAntes == 0 ? "hoy" : "en ${note.diasAntes} día(s)"}",
    tz.TZDateTime.from(
      fechaNotificacion,
      tz.local,
    ),
    const NotificationDetails(
      android: AndroidNotificationDetails(
        'fluxo_channel',
        'Fluxo',
        channelDescription: 'Recordatorios de notas',
        importance: Importance.max,
        priority: Priority.high,
      ),
    ),
    androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    matchDateTimeComponents: null,
  );
}

  Future<void> cancelReminder(
    Note note,
  ) async {
    await notifications.cancel(
      note.id.hashCode,
    );
  }

  Future<void> cancelAll() async {
    await notifications.cancelAll();
  }
}