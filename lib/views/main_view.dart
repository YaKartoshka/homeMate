import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:home_mate/views/notes.dart';
import 'package:home_mate/views/notifications.dart';
import 'package:home_mate/views/settings.dart';
import 'package:home_mate/views/wardrobe.dart';
import 'package:home_mate/views/weather.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
        return Wardrobe();

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
     if(index==1){
      setState(() {
        _weather_state=true;
      });
     }else{
       _weather_state=false;
     }
    });
  }

  

  @override
  Widget build(BuildContext context) {
    final ButtonStyle style =
        ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20));
    final adaptive_size = MediaQuery.of(context).size;
    
    return Container(
      decoration: _weather_state ? const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/background.png"),
              fit: BoxFit.fill,
              colorFilter: ColorFilter.mode(
                  Color.fromARGB(255, 149, 152, 229), BlendMode.overlay)),
        ) : const BoxDecoration(
          color: Color.fromARGB(255, 104, 57, 223),
        ),
      child: Scaffold(
      backgroundColor: Colors.transparent,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(MediaQuery.of(context).padding.top),
        child: SizedBox(
          height: MediaQuery.of(context).padding.top,
        ),
      ),
      body: _buildBody(),
      
      bottomNavigationBar: Container(
       
        child: BottomNavigationBar(
        
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.checkroom),
            label: 'Wardrobe',
            backgroundColor: Color.fromARGB(255, 104, 57, 223),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.wb_sunny),
            label: 'Weather',
            backgroundColor: Color.fromRGBO(162, 131, 242, 0.6)
            
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event),
            label: 'Notes',
            backgroundColor: Color.fromARGB(255, 104, 57, 223),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
            backgroundColor: Color.fromARGB(255, 104, 57, 223),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
            backgroundColor: Color.fromARGB(255, 104, 57, 223),
          ),
        ],
       
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white,
        unselectedItemColor: const Color.fromARGB(255, 225, 220, 220),
        onTap: _onItemTapped,
      ),
      )
      
      
    ),
    );
  }
}
