import 'package:flutter/material.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'input_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _initializeNotifications();
  runApp(const PeriodTrackerApp());
}

Future<void> _initializeNotifications() async {
  AwesomeNotifications().initialize(
    null,
    [
      NotificationChannel(
        channelKey: 'period_tracker_channel',
        channelName: 'Period Tracker Notifications',
        channelDescription: 'Notifications for period tracker reminders',
        defaultColor: const Color(0xFF9D50DD),
        ledColor: Colors.white,
        importance: NotificationImportance.High,
      ),
    ],
  );
}

class PeriodTrackerApp extends StatelessWidget {
  const PeriodTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _requestNotificationPermissions(context);
    });

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Period Tracker',
      theme: ThemeData(primarySwatch: Colors.pink),
      home: InputScreen(),
    );
  }

  Future<void> _requestNotificationPermissions(BuildContext context) async {
    bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllowed) {
      bool granted =
          await AwesomeNotifications().requestPermissionToSendNotifications();
      if (!granted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Permissions Required'),
            content: const Text(
                'Notifications permission is required to send reminders.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    }
  }
}
