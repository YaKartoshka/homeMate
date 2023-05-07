import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Notifications extends StatefulWidget {
  const Notifications({super.key});
  
  @override
  State<Notifications> createState() => _NotificationsState();
}

class Notification{
  String? title;
  String? description;

  Notification(this.title, this.description);
}

class _NotificationsState extends State<Notifications> {
  int _selectedIndex = 0;
  SharedPreferences? prefs;
  final _title_controller = TextEditingController();
  final _description_controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  
 
  List<Notification> notifications = [
    Notification('Let\' s eat', "Dinner"),
    Notification('Go to gym', "Dinner"),
  ];
  
  Future<void> _initPrefs() async {
      prefs = await SharedPreferences.getInstance();
  }
  @override
  void initState() {
    super.initState();
    _initPrefs();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      String? userId = prefs?.getString('userId');
      log(userId!);
    });
  }

  void createNotification(){
    setState(() {
      String? newTitle=_title_controller.text.trim();
      String? newDescription= _description_controller.text.trim();
      notifications.add(Notification(newTitle,newDescription ));
     
    });
  }

  @override
  Widget build(BuildContext context) {
    final ButtonStyle style =
        ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20));
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 149, 152, 229),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(MediaQuery.of(context).padding.top),
        child: SizedBox(
          height: MediaQuery.of(context).padding.top,
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(),
        child: Column(children: [
          const SizedBox(
            height: 30,
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Notifications",
                style: TextStyle(
                    fontSize: 40, fontFamily: 'Poppins', color: Colors.white),
              )
            ],
          ),
          SizedBox(
            height: 500,
            child: Expanded(
              child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 5),
              itemCount: notifications.length, 
              itemBuilder: (BuildContext context, int index) { 
                return GestureDetector(
                  onTap: () {}, // Handle your callback
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 100),
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                    height: 70,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: const Color.fromARGB(255, 255, 255, 255),
                    ),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Icon(Icons.holiday_village),
                          Text(
                            "${notifications[index].title}",
                            style: TextStyle(),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.edit),
                            iconSize: 30,
                          )
                        ]),
                  ),
                );
               },
              
                
           
            ),)
          )
        ]),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            shadowColor: const Color.fromARGB(255, 104, 57, 223),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(30))),
            scrollable: true,
            title: const Text('New notification'),
            content: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      controller: _title_controller,
                      decoration: const InputDecoration(
                        labelText: 'Title',
                        hintText: 'Type a title',
                        icon: Icon(Icons.title_outlined,
                            color: Color.fromARGB(255, 104, 57, 223)),
                      ),
                    ),
                    TextFormField(
                      controller: _description_controller,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                        icon: Icon(Icons.message_outlined,
                            color: Color.fromARGB(255, 104, 57, 223)),
                      ),
                    ),
                    const SizedBox(height: 25),
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            createNotification();
                            _description_controller.clear();
                            _title_controller.clear();
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 104, 57, 223),
                          ),
                          child: const Text('Create'),
                        ),
                        const SizedBox(width: 10),
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text(
                              'Cancel',
                              style: TextStyle(
                                color: Color.fromARGB(255, 104, 57, 223),
                              ),
                            ))
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        backgroundColor: Colors.white,
        child: const Icon(
          Icons.add,
          color: Color.fromARGB(255, 104, 57, 223),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.checkroom),
            label: 'Wardrobe',
            backgroundColor: Color.fromARGB(255, 104, 57, 223),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.wb_sunny),
            label: 'Weather',
            backgroundColor: Color.fromARGB(255, 104, 57, 223),
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
    );
  }

}
