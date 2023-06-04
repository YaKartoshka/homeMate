import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:home_mate/views/createPanel.dart';
import 'package:home_mate/views/main_view.dart';
import 'package:home_mate/views/note_list_view.dart';
import 'package:home_mate/views/resetPassword.dart';
import 'package:home_mate/views/wardrobe.dart';
import 'package:home_mate/views/weather.dart';
import 'package:home_mate/views/welcome.dart';
import 'package:home_mate/views/join.dart';
import 'package:home_mate/views/login.dart';
import 'package:home_mate/views/settings.dart';
import 'package:home_mate/views/notifications.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'control/localProvider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings(
          '@mipmap/ic_launcher'); // Replace 'app_icon' with the name of your app's launcher icon
  final InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: 'AIzaSyDO75reBOeDxFZbtckZoTpQcbYd2Zrq4iY',
          appId: '1:963528077159:android:e55bfdea6292790bcb09c2',
          messagingSenderId: '963528077159',
          projectId: 'home-mate-33d2b'));

  FirebaseMessagingService messagingService = FirebaseMessagingService();
  messagingService.initialize();
  final startRoute=prefs.getString('dashboard_id')!=null ? '/main_view' : '/';

  log('${prefs.getString('dashboard_id')}');
  runApp(ChangeNotifierProvider<LocaleProvider>(
      create: (_) => LocaleProvider(),
      child: MaterialApp(
        theme: ThemeData(
          primaryColor: Colors.black,
        ),
        supportedLocales: [
          Locale('en', 'US'), // English
          Locale('ru', 'RU'), // Russian
          Locale('kk', 'KZ'), // Kazakh
        ],
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        localeResolutionCallback: (locale, supportedLocales) {
          Locale? selectedLocale;
          for (var supportedLocale in supportedLocales) {
            if (supportedLocale.languageCode == locale!.languageCode &&
                supportedLocale.countryCode == locale.countryCode) {
              selectedLocale = supportedLocale;
              break;
            }
          }
        
          selectedLocale ??= supportedLocales.first;
          prefs.setString('language', '${selectedLocale.languageCode}');
          return selectedLocale;
        },
        
        initialRoute: '/main_view',
        routes: {
          '/': (context) => const Welcome(),
          '/join': (context) => const Join(),
          '/login': (context) => const Login(),
          '/create_panel': (context) => const CreatePanel(),
          '/notifications': (context) => const Notifications(),
          '/reset_password': (context) => const Reset(),
          '/main_view': (context) => const Main_View(),
          '/settings': (context) => const SettingsView(),
          '/weather': (context) => const Weather(),
          '/wardrobe': (context) => const Wardrobe(),
        },

        // rename Login to Join or Welcome to open other views
      )));
}



class FirebaseMessagingService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  Future<void> initialize() async {
    // Request permission for notifications (optional)
    await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // Handle incoming messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // Handle foreground messages
      log('Received message: ${message.notification?.title}');
      _showNotification(
          message.notification?.title, message.notification?.body);
    });

    // Handle when the app is in the background and opened from a notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // Handle background messages
      log('Opened app from notification: ${message.notification?.title}');
      _showNotification(
          message.notification?.title, message.notification?.body);
    });
  }

  void _showNotification(title, body) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      '123456',
      'Home Mate',
      channelDescription: "Notification",
      icon: 'ic_launcher',
      importance: Importance.max,
      priority: Priority.high,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      1, // Notification ID
      title,
      body,
      platformChannelSpecifics,
    );
  }
}
