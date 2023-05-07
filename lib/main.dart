import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:home_mate/views/createPanel.dart';
import 'package:home_mate/views/resetPassword.dart';
import 'package:home_mate/views/welcome.dart';
import 'package:home_mate/views/join.dart';
import 'package:home_mate/views/login.dart';
import 'package:home_mate/views/notifications.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: 'AIzaSyDO75reBOeDxFZbtckZoTpQcbYd2Zrq4iY',
          appId: '1:963528077159:android:e55bfdea6292790bcb09c2',
          messagingSenderId: '963528077159',
          projectId: 'home-mate-33d2b'));
  runApp(MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.black,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const Welcome(),
        '/join':(context) => const Join(),
        '/login':(context) => const Login(),
        '/create_panel':(context) => const CreatePanel(),
        '/notifications':(context) => const Notifications(),
        '/reset_password': (context)=> const Reset()
        },
         
      // rename Login to Join or Welcome to open other views
      ));
}
