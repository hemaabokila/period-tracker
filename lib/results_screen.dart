import 'package:flutter/material.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

class ResultsScreen extends StatelessWidget {
  final DateTime lastPeriodDate;
  final int cycleLength;
  final int periodDuration;
  final int notificationCount;
  ResultsScreen({
    required this.lastPeriodDate,
    required this.cycleLength,
    required this.periodDuration,
    this.notificationCount = 5,
  });

  @override
  Widget build(BuildContext context) {
    DateTime currentDate = DateTime.now();
    int daysDifference = currentDate.difference(lastPeriodDate).inDays;
    int fullCyclesPassed = (daysDifference / cycleLength).floor();

    DateTime nextPeriodDate = lastPeriodDate
        .add(Duration(days: fullCyclesPassed * cycleLength + cycleLength));

    DateTime ovulationStart =
        nextPeriodDate.add(Duration(days: cycleLength ~/ 2 - 2));
    DateTime ovulationEnd =
        nextPeriodDate.add(Duration(days: cycleLength ~/ 2 + 2));

    scheduleNotifications(nextPeriodDate, notificationCount);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Results'),
        backgroundColor: const Color.fromARGB(255, 235, 54, 244),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                elevation: 15,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                shadowColor: const Color.fromARGB(255, 235, 54, 244),
                child: Container(
                  width: 300,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Image.asset(
                      "assets/images/hema.webp",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Card(
                elevation: 10,
                color: const Color.fromARGB(255, 235, 54, 244),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                shadowColor: const Color.fromARGB(255, 235, 54, 244),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Next Period Date: ${formatDate(nextPeriodDate)}',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Card(
                elevation: 10,
                color: const Color.fromARGB(255, 235, 54, 244),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                shadowColor: const Color.fromARGB(255, 235, 54, 244),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Expected Period Duration: $periodDuration days',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Card(
                elevation: 10,
                color: const Color.fromARGB(255, 235, 54, 244),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                shadowColor: const Color.fromARGB(255, 235, 54, 244),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Ovulation Days: ${formatDate(ovulationStart)} - ${formatDate(ovulationEnd)}',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void scheduleNotifications(
      DateTime nextPeriodDate, int notificationCount) async {
    DateTime notificationStartDate = nextPeriodDate.subtract(Duration(days: 5));

    for (int i = 0; i < notificationCount; i++) {
      DateTime notificationTime = notificationStartDate.add(Duration(days: i));

      await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: i,
          channelKey: 'period_tracker_channel',
          title: 'Reminder',
          body: 'Your next period is approaching in ${5 - i} days!',
          notificationLayout: NotificationLayout.Default,
        ),
        schedule: NotificationCalendar(
          year: notificationTime.year,
          month: notificationTime.month,
          day: notificationTime.day,
          hour: 9,
          minute: 0,
          second: 0,
          millisecond: 0,
          preciseAlarm: true,
        ),
      );
    }
  }

  String formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
