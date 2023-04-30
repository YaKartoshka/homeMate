import 'package:flutter/material.dart';
import 'package:home_mate/views/createPanel.dart';
import 'package:home_mate/views/welcome.dart';
import 'package:home_mate/views/join.dart';
import 'package:home_mate/views/login.dart';
import 'package:home_mate/views/notifications.dart';

void main() => runApp(MaterialApp(
  theme: ThemeData(
    primaryColor: Colors.black,
  ),
  home: const Notifications(), // rename Login to Join or Welcome to open other views
));