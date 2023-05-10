import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  State<Notifications> createState() => _Notifications_State();
}

class Notification {
  String? title;
  String? description;

  Notification({required this.title, required this.description});
  factory Notification.fromMap(Map<String, dynamic> map) {
    return Notification(title: map['title'], description: map['description']);
  }
}

class _Notifications_State extends State<Notifications> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  int _selectedIndex = 3;
  SharedPreferences? prefs;
  final _title_controller = TextEditingController();
  final _description_controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String _dashboard_id = '';
  late Future<List<Notification>> _notificationsFuture;

  @override
  void initState() {
    super.initState();
    _notificationsFuture=getNotifications();
  }

  void createNotification() {
    String? newTitle = _title_controller.text;
    String? newDescription = _description_controller.text;
    // notifications.add(Notification(newTitle, newDescription));

    db
        .collection('dashboards')
        .doc(_dashboard_id)
        .collection('notifications')
        .add({'title': newTitle, 'description': newDescription});
    setState(() {
      _notificationsFuture = getNotifications();
   
    });
  }

  Future<List<Notification>> getNotifications() async {
    prefs = await SharedPreferences.getInstance();
    _dashboard_id = prefs!.getString("dashboard_id")!;
    final snapshot = await FirebaseFirestore.instance
        .collection('dashboards')
        .doc(_dashboard_id)
        .collection('notifications')
        .get();

    final notifications =
        snapshot.docs.map((doc) => Notification.fromMap(doc.data())).toList();
    log('${notifications}');
    return notifications;
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
              child: Column(
                children: [
                  Expanded(
                      child: FutureBuilder<List<Notification>>(
                          future: _notificationsFuture,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return ListView.builder(
                                padding: const EdgeInsets.fromLTRB(8, 8, 8, 5),
                                itemCount: snapshot.data!.length,
                                itemBuilder: (BuildContext context, int index) {
                                  final notifications = snapshot.data![index];
                                  return GestureDetector(
                                    onTap: () {}, // Handle your callback
                                    child: AnimatedContainer(
                                      duration:
                                          const Duration(milliseconds: 100),
                                      padding: const EdgeInsets.fromLTRB(
                                          20, 0, 20, 0),
                                      margin: const EdgeInsets.fromLTRB(
                                          0, 10, 0, 10),
                                      height: 70,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        color: const Color.fromARGB(
                                            255, 255, 255, 255),
                                      ),
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Icon(Icons.holiday_village),
                                            Text(
                                              "${notifications.title}",
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
                              );
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else {
                              return Center(child: CircularProgressIndicator());
                            }
                          }))
                ],
              ))
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
    );
  }
}
