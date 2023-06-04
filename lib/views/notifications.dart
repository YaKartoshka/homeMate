import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:home_mate/appLocalization';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../control/localProvider.dart';

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
  String _role = '';

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
    _notificationsFuture = getNotifications();
  }

  void sendNotification(title, description) async {
    log('1');
    if (_role != 'guest') {
      log('2');
      log(_dashboard_id);
      await db
          .collection("dashboards")
          .doc(_dashboard_id)
          .collection("members")
          .get()
          .then(
        (querySnapshot) async {
          log('${querySnapshot.docs}');
          for (var docSnapshot in querySnapshot.docs) {
            log('4');
            Map<String, dynamic> notification = {
              'to': docSnapshot.data()['fcmToken'],
              'notification': {
                'title': '${title}',
                'body': '${description}',
              },
            };
            try {
              final response = await http.post(
                Uri.parse('https://fcm.googleapis.com/fcm/send'),
                headers: <String, String>{
                  'Content-Type': 'application/json',
                  'Authorization':
                      'key=AAAA4Fa_r2c:APA91bG3gn2hvEGUrgHZ_o3qZxhrJfSFIkaDNjZSgFdTJ8OlCrCflaD4gxvVasLoYjCsS3wJa2eDOaCrt0PG1LSfprCF8DHJzojCbwE8c9ypwJdUF9FHrCvArMnQrvIWoA-ABRxM2nwZ',
                },
                body: jsonEncode(notification),
              );

              if (response.statusCode == 200) {
                log('Notification sent successfully');
              } else {
                log('Failed to send notification. Error: ${response.body}');
              }
            } catch (e) {
              log('Error sending notification: $e');
            }
          }
        },
      );
    }
  }

  void createNotification() {
    String? newTitle = _title_controller.text;
    String? newDescription = _description_controller.text;

    if (_role != 'guest') {
      db
          .collection('dashboards')
          .doc(_dashboard_id)
          .collection('notifications')
          .add({'title': newTitle, 'description': newDescription});
      setState(() {
        _notificationsFuture = getNotifications();
      });
    }
  }

  Future<List<Notification>> getNotifications() async {
    SharedPreferences? prefs = await SharedPreferences.getInstance();
    _dashboard_id = prefs!.getString("dashboard_id")!;
    _role = prefs.getString("role")!;
    final snapshot = await FirebaseFirestore.instance
        .collection('dashboards')
        .doc(_dashboard_id)
        .collection('notifications')
        .get();

    final notifications =
        snapshot.docs.map((doc) => Notification.fromMap(doc.data())).toList();
    return notifications;
  }

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);
    final currentLocale = localeProvider.locale;
    
    final appTranslations = AppTranslations
        .translations['${currentLocale}']!;
    final ButtonStyle style =
        ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20));
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 149, 152, 229),
      appBar: AppBar(
        title: Text(Intl.message(appTranslations['notifications']!),
            style: TextStyle(fontFamily: 'Poppins', fontSize: 24)),
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: Color.fromARGB(255, 149, 152, 229),
      ),
      body: Container(
        decoration: const BoxDecoration(),
        child: Column(children: [
          const SizedBox(
            height: 10,
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
                                    onTap: () {
                                      sendNotification(notifications.title,
                                          notifications.description);
                                    }, // Handle your callback
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
            title:  Text(Intl.message(appTranslations['new_notification']!)),
            content: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      controller: _title_controller,
                      decoration:  InputDecoration(
                        labelText: Intl.message(appTranslations['title']!),
                        hintText: Intl.message(appTranslations['type_title']!),
                        icon: Icon(Icons.title_outlined,
                            color: Color.fromARGB(255, 104, 57, 223)),
                      ),
                    ),
                    TextFormField(
                      controller: _description_controller,
                      decoration:  InputDecoration(
                        labelText: Intl.message(appTranslations['description']!),
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
                          child:  Text(Intl.message(appTranslations['create']!)),
                        ),
                        const SizedBox(width: 10),
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child:  Text(
                              Intl.message(appTranslations['cancel']!),
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
