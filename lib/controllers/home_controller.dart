import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/routes/route_names.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart' as m;
import 'package:mailer/smtp_server.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:permission_handler/permission_handler.dart';

class Task {
  final String id;
  final String title;
  final String description;
  final DateTime dateTime;
  final String reciptant;
  bool completed;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.dateTime,
    required this.reciptant,
    this.completed = false,
  });
}

class HomeController extends GetxController {
  var priority = 2.0.obs;
  var selectedTime = TimeOfDay(hour: 9, minute: 0).obs;
  var selectedDate = DateTime.now().obs;
  var upcomingTasks = <Task>[].obs;
  var completedTasks = <Task>[].obs; // New list for completed tasks
  var loading = false.obs;

  //for email
  final String emailSender = 'tasktrack123@gmail.com';
  final String emailPassword = 'iolbtunkfitqzpgy';
  final String smtpServerAddress = 'smtp.gmail.com';
  final int smtpPort = 587;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  Rxn<User?> firebaseUser = Rxn<User?>();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  var todayTasks = <Task>[].obs; // List to store today's tasks

  // Notification plugin
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  void onInit() {
    super.onInit();
    firebaseUser.bindStream(_auth.authStateChanges());
    firebaseUser.listen((user) {
      _setInitialScreen(user);
    });

    _initializeNotifications();
    _startTaskScheduler();
    _fetchTasks();
  }

  void _setInitialScreen(User? user) {
    if (user == null) {
      Get.offAllNamed(RouteNames.login);
    } else {
      Get.offAllNamed(RouteNames.home);
      _fetchTasks();
    }
  }

  // Initialize local notifications
  void _initializeNotifications() async {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    // Check if notification permission is granted
    PermissionStatus status = await Permission.notification.status;

    if (status.isGranted) {
      print('Notification permission is granted');
      // Continue with the notification setup
    } else if (status.isDenied) {
      print('Notification permission is denied');
      // Request permission if denied
      await Permission.notification.request();
    } else if (status.isPermanentlyDenied) {
      print('Notification permission is permanently denied');
      // Optionally, direct the user to the app settings
      openAppSettings();
    }
  }

  void _scheduleNotification(Task task) {
    // Convert the scheduled date to TZDateTime
    final tz.TZDateTime scheduledDate = tz.TZDateTime.from(
      task.dateTime,
      tz.local,
    );

    // Check if the scheduled date is in the future
    if (scheduledDate.isBefore(tz.TZDateTime.now(tz.local))) {
      print("Scheduled time is in the past. Not scheduling notification.");
      return; // Don't schedule if it's in the past
    }

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'channel_id',
      'Task Notifications',
      channelDescription: 'Notifications for scheduled tasks',
      importance: Importance.max,
      priority: Priority.high,
    );

    final NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    // Schedule the notification using zonedSchedule
    flutterLocalNotificationsPlugin.zonedSchedule(
      task.id.hashCode, // Unique ID for the notification
      'Task Reminder',
      "Your task '${task.title}' is scheduled now.",
      scheduledDate, // Use TZDateTime
      platformChannelSpecifics,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  // Schedule all notifications for today's tasks
  void _scheduleAllNotifications() {
    for (var task in todayTasks) {
      if (!task.completed) {
        _scheduleNotification(task);
      }
    }
    print("hello this is notification");
  }

  // Start task scheduler to monitor and send notifications/emails
  void _startTaskScheduler() {
    final Set<String> emailedTasks = {};

    Timer.periodic(Duration(minutes: 1), (timer) async {
      DateTime now = DateTime.now();
      final allTasks = [...todayTasks, ...upcomingTasks];

      for (var task in allTasks) {
        if (!emailedTasks.contains(task.id) &&
            (task.dateTime.isAtSameMomentAs(now) ||
                task.dateTime.isBefore(now))) {
          // Check if the task is an email task
          if (task.reciptant != null &&
              task.reciptant.trim().isNotEmpty &&
              task.reciptant != "null") {
            print('Sending email for task: ${task.title}');
            print("hello this is from the email");
            print(task.reciptant.runtimeType); // Check if it's String or null
            print(task.reciptant);
            await _sendEmailTaskNotification(task);
            _showNotification(task);
          } else {
            print('Sending notification for task: ${task.title}');
            print("hello from the task");
            await _sendTaskNotification(task);
            _showNotification(task);
          }

          emailedTasks.add(task.id); // Mark the task as processed
        }
      }
    });
  }

  void _showNotification(Task task) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'channel_id',
      'Task Notifications',
      channelDescription: 'Notifications for tasks',
      importance: Importance.max,
      priority: Priority.high,
    );

    final NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    if (task.reciptant != null &&
        task.reciptant.trim().isNotEmpty &&
        task.reciptant != "null") {
      await flutterLocalNotificationsPlugin.show(
        task.id.hashCode, // ID for the notification (can be any unique ID)
        "email", // Notification title
        "your email is sended!!", // Notification body
        platformChannelSpecifics,
      );
    } else {
      await flutterLocalNotificationsPlugin.show(
        task.id.hashCode, // ID for the notification (can be any unique ID)
        task.title, // Notification title
        "your task ${task.title} is scheduled do it now!!", // Notification body
        platformChannelSpecifics,
      );
    }
  }

  // Sending email task notification
  Future<void> _sendEmailTaskNotification(Task task) async {
    try {
      final smtpServer = SmtpServer(
        smtpServerAddress,
        username: emailSender,
        password: emailPassword,
        port: smtpPort,
      );

      final message = m.Message()
        ..from = m.Address(emailSender)
        ..recipients.add(task.reciptant)
        ..subject = task.title
        ..text = task.description;

      await m.send(message, smtpServer);

      Get.snackbar('Success', 'Email is sent',
          backgroundColor: Colors.green, colorText: Colors.white);

      // Mark task as complete
      await _firestore
          .collection('users')
          .doc(firebaseUser.value!.uid)
          .collection('tasks')
          .doc(task.id)
          .update({'completed': true});

      _fetchTasks();

      print("Email task sent to ${task.reciptant} and marked as complete.");
    } catch (e) {
      print("Failed to send email task: $e");
    }
  }

  //************************************mails ***********************/
  // Configure your email settings

  // Send email notification for normal tasks
  Future<void> _sendTaskNotification(Task task) async {
    try {
      final userEmail = firebaseUser.value?.email;

      if (userEmail != null) {
        final smtpServer = SmtpServer(
          smtpServerAddress,
          username: emailSender,
          password: emailPassword,
          port: smtpPort,
        );

        final message = m.Message()
          ..from = m.Address(emailSender)
          ..recipients.add(userEmail)
          ..subject = "Your task '${task.title}' is scheduled now"
          ..text = "Hello,\n\nYour task '${task.title}' is now scheduled.\n\n"
              "Task Details:\n"
              "Title: ${task.title}\n"
              "Description: ${task.description}\n"
              "Scheduled Time: ${task.dateTime}\n\n"
              "Best regards,\nTask Manager";

        await m.send(message, smtpServer);

        print("Task email notification sent to $userEmail");
      }
    } catch (e) {
      print("Failed to send task email notification: $e");
    }
  }
  // Send email for email tasks and mark as complete
  // **********************************mails************************88

  Future<void> signUp(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      Get.snackbar('Success', 'Account created successfully',
          backgroundColor: Colors.green, colorText: Colors.white);
    } catch (e) {
      Get.snackbar('Error', e.toString(),
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  void login(String email, String password) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      Get.offAllNamed(
          RouteNames.home); // Explicitly navigate to the dashboard/home
      _fetchTasks();
    } catch (e) {
      // Handle login errors
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  void updatePriority(double value) {
    priority.value = value;
  }

  void updateTime(TimeOfDay newTime) {
    selectedTime.value = newTime;
  }

  void updateDate(DateTime newDate) {
    selectedDate.value = newDate;
  }

  bool validateFields(String title, String description) {
    if (title.isEmpty || description.isEmpty) {
      Get.snackbar('Error', 'Title and Description cannot be empty');
      return false;
    }
    final DateTime selectedDateTime = DateTime(
      selectedDate.value.year,
      selectedDate.value.month,
      selectedDate.value.day,
      selectedTime.value.hour,
      selectedTime.value.minute,
    );

    if (selectedDateTime.isBefore(DateTime.now())) {
      Get.snackbar('Error', 'Please select a future date and time');
      return false;
    }
    return true;
  }

  bool validateFields2(String reci, String subject, String body) {
    if (reci.isEmpty || subject.isEmpty || body.isEmpty) {
      Get.snackbar('Error', 'Recipient, subject, and body cannot be empty');
      return false;
    }
    final DateTime selectedDateTime = DateTime(
      selectedDate.value.year,
      selectedDate.value.month,
      selectedDate.value.day,
      selectedTime.value.hour,
      selectedTime.value.minute,
    );

    if (selectedDateTime.isBefore(DateTime.now())) {
      Get.snackbar('Error', 'Please select a future date and time');
      return false;
    }
    return true;
  }

  Future<void> createTask(String title, String description) async {
    final DateTime taskDateTime = DateTime(
      selectedDate.value.year,
      selectedDate.value.month,
      selectedDate.value.day,
      selectedTime.value.hour,
      selectedTime.value.minute,
    );

    if (firebaseUser.value != null) {
      try {
        await _firestore
            .collection('users')
            .doc(firebaseUser.value!.uid)
            .collection('tasks')
            .add({
          'title': title,
          'description': description,
          'dateTime': taskDateTime,
          'recipient': "null",
          'completed': false, // Add completed field to Firestore
        });
        _fetchTasks(); // Refresh task list after adding new task
      } catch (e) {
        Get.snackbar('Error', e.toString(),
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    }
  }

  Future<void> createEmailTask(
      String recipient, String subject, String body) async {
    final DateTime taskDateTime = DateTime(
      selectedDate.value.year,
      selectedDate.value.month,
      selectedDate.value.day,
      selectedTime.value.hour,
      selectedTime.value.minute,
    );

    if (firebaseUser.value != null) {
      try {
        await _firestore
            .collection('users')
            .doc(firebaseUser.value!.uid)
            .collection('tasks')
            .add({
          'title': subject, // Subject as the task title
          'description': body, // Body as the task description
          'dateTime': taskDateTime,
          'recipient': recipient, // Recipient of the email
          'completed': false, // Default completed status
        });
        _fetchTasks(); // Refresh task list after adding new task
      } catch (e) {
        Get.snackbar('Error', 'Failed to create email task',
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    }
  }

  // Fetch Tasks from Firestore for the logged-in user
  void _fetchTasks() {
    if (firebaseUser.value != null) {
      loading.value = true;
      _firestore
          .collection('users')
          .doc(firebaseUser.value!.uid)
          .collection('tasks')
          .snapshots()
          .listen((querySnapshot) {
        upcomingTasks.clear();
        completedTasks.clear();
        todayTasks.clear(); // Clear today's tasks list

        for (var doc in querySnapshot.docs) {
          final data = doc.data();
          final task = Task(
            id: doc.id,
            title: data['title'] ?? '',
            description: data['description'] ?? '',
            dateTime: (data['dateTime'] as Timestamp).toDate(),
            reciptant: data['recipient'] ?? '',
            completed: data['completed'] ?? false,
          );

          if (task.completed) {
            completedTasks.add(task);
          } else {
            // Check if the task is for today
            final now = DateTime.now();
            if (task.dateTime.year == now.year &&
                task.dateTime.month == now.month &&
                task.dateTime.day == now.day) {
              todayTasks.add(task); // Add to today's tasks
            } else {
              upcomingTasks.add(task); // Add to upcoming tasks
            }
          }
        }

        // Sort the tasks by dateTime
        upcomingTasks.sort((a, b) => a.dateTime.compareTo(b.dateTime));
        todayTasks.sort((a, b) => a.dateTime.compareTo(b.dateTime));
        completedTasks.sort((a, b) => a.dateTime.compareTo(b.dateTime));
        loading.value = false;
      });
    }
  }

  Future<void> deleteTask(String taskId) async {
    if (firebaseUser.value != null) {
      try {
        await _firestore
            .collection('users')
            .doc(firebaseUser.value!.uid)
            .collection('tasks')
            .doc(taskId)
            .delete();
        upcomingTasks.removeWhere((task) => task.id == taskId);
        Get.snackbar('Success', 'Task is deleted',
            backgroundColor: Colors.green, colorText: Colors.white);
      } catch (e) {
        Get.snackbar('Error', 'Failed to delete task',
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    }
  }

  Future<void> markTaskAsComplete(Task task) async {
    if (firebaseUser.value != null) {
      try {
        await _firestore
            .collection('users')
            .doc(firebaseUser.value!.uid)
            .collection('tasks')
            .doc(task.id)
            .update({'completed': true});
        _fetchTasks(); // Refresh the task list to reflect the completion status
        Get.snackbar('Success', 'Task marked as complete',
            backgroundColor: Colors.green, colorText: Colors.white);
      } catch (e) {
        Get.snackbar('Error', 'Failed to mark task as complete',
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    }
  }
}
