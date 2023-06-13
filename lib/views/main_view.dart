import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:home_mate/control/localProvider.dart';
import 'package:home_mate/views/localNotes.dart';
import 'package:home_mate/views/notes.dart';
import 'package:home_mate/views/notifications.dart';
import 'package:home_mate/views/settings.dart';
import 'package:home_mate/views/weather.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../appLocalization';
import '../control/themeProvider.dart';

// final jsonString = '[{"id": "1", "name": "John Doe", "age": 30}, {"id": "2", "name": "Jane Smith", "age": 25}]';
// final jsonData = json.decode(jsonString);
// final userList = List<User>.from(jsonData.map((json) => User.fromJson(json)));
class Main_View extends StatefulWidget {
  const Main_View({super.key});

  @override
  State<Main_View> createState() => _Main_ViewState();
}

class _Main_ViewState extends State<Main_View> {
  int _selectedIndex = 2;
  bool _weather_state = false;

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return LocalNotes();

      case 1:
        return Weather();

      case 2:
        return Notes();

      case 3:
        return Notifications();

      case 4:
        return SettingsView();

      default:
        return Main_View();
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _buildBody();
      if (index == 1) {
        setState(() {
          _weather_state = true;
        });
      } else {
        _weather_state = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);
    final currentLocale = localeProvider.locale;
    final themeProvider = Provider.of<ThemeProvider>(context);
    themeProvider.fetchTheme();
    
    final appTranslations = AppTranslations
        .translations['${currentLocale}']!;
    final ButtonStyle style =
        ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20));
    final adaptive_size = MediaQuery.of(context).size;
    Future<bool> _onClickBack() {
 
    SystemNavigator.pop();


    return Future.value(true);
  }

  return Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
      final theme = themeProvider.theme;
    return Container(
        decoration: _weather_state
            ? const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/background.png"),
                    fit: BoxFit.fill,
                    colorFilter: ColorFilter.mode(
                        Color.fromARGB(255, 149, 152, 229), BlendMode.overlay)),
              )
            :  BoxDecoration(
                color: theme == 'dark'
                ? Colors.black
                : theme == 'light'
                    ? Color.fromARGB(255, 225, 220, 220)
                    : Color.fromARGB(255, 149, 152, 229),
              ),
        child: OverflowBox(
          minHeight: 0,
          child: WillPopScope(onWillPop: _onClickBack, child: 
          Scaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor: Colors.transparent,
              appBar: PreferredSize(
                preferredSize:
                    Size.fromHeight(MediaQuery.of(context).padding.top),
                child: SizedBox(
                  height: MediaQuery.of(context).padding.top,
                ),
              ),
              body: _buildBody(),
              bottomNavigationBar: Container(
                child: BottomNavigationBar(
                  items: <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                      icon: Icon(Icons.description),
                      label: Intl.message(appTranslations['my_notes']),
                      backgroundColor: 
                      theme == 'dark'
                ? Color.fromARGB(255, 36, 36, 36)
                : theme == 'light'
                    ? Color.fromARGB(255, 225, 220, 220)
                    : Color.fromARGB(255, 104, 57, 223),
                    ),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.wb_sunny),
                        label: Intl.message(appTranslations['weather']),
                        backgroundColor: theme == 'dark'
                ? Color.fromARGB(255, 36, 36, 36)
                : theme == 'light'
                    ? Color.fromRGBO(162, 131, 242, 0.6)
                    : Color.fromRGBO(162, 131, 242, 0.6),
                        ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.event),
                      label: Intl.message(appTranslations['notes']),
                      backgroundColor: theme == 'dark'
                ? Color.fromARGB(255, 36, 36, 36)
                : theme == 'light'
                    ? Color.fromARGB(255, 225, 220, 220)
                    : Color.fromARGB(255, 104, 57, 223),
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.notifications),
                      label: Intl.message(appTranslations['notifications']),
                      backgroundColor: theme == 'dark'
                ? Color.fromARGB(255, 36, 36, 36)
                : theme == 'light'
                    ? Color.fromARGB(255, 225, 220, 220)
                    : Color.fromARGB(255, 104, 57, 223),
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.settings),
                      label: Intl.message(appTranslations['settings']),
                      backgroundColor: theme == 'dark'
                ? Color.fromARGB(255, 36, 36, 36)
                : theme == 'light'
                    ? Color.fromARGB(255, 225, 220, 220)
                    : Color.fromARGB(255, 104, 57, 223),
                    ),
                  ],
                  currentIndex: _selectedIndex,
                  selectedItemColor: theme == 'dark'
                ? Colors.white
                : theme == 'light'
                    ? Colors.white
                    : Colors.white,
                  unselectedItemColor:  theme == 'dark'
                ? Colors.white
                : theme == 'light'
                    ? Colors.black
                    : Color.fromARGB(255, 225, 220, 220),
                  onTap: _onItemTapped,
                ),
              ))
              )
        ));
  });
  }
}
