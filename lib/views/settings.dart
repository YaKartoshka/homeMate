import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class User {
  String? email;
  String? userId;
  String? role;
  User({required this.email, required this.userId, required this.role});
  factory User.fromMap(Map<String, dynamic> map) {
    return User(email: map['email'], userId: map['userId'], role: map['role']);
  }
}

class _SettingsViewState extends State<SettingsView> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String _dashboard_id = '';
  String _userId = '';
  String _role = '';
  String _dashboard_name = '';
  SharedPreferences? prefs;
  late Future<List<User>> _membersFuture;
  final dashboard_id_input = TextEditingController();
  final dashboard_name_input = TextEditingController();
  bool theme = true;
  @override
  void initState() {
    super.initState();
    getSettings();
    _membersFuture = getMembers();
  }

  void resetDashboardId() {}

  void deleteUser(memberId) async {
   
    // await db.collection("dashboards").doc(_dashboard_id).collection("members").doc(memberId).delete();
    try {
      await _auth
          .userChanges()
          .firstWhere((user) => user!.uid == memberId).then((user) async {
            log('${user}');
            await user?.delete();
          },);
         
      log('User deleted successfully.');
    } catch (e) {
      log('Error deleting user: $e');
    }
  }

  Future<List<User>> getMembers() async {
    prefs = await SharedPreferences.getInstance();
    _dashboard_id = prefs!.getString("dashboard_id")!;

    final snapshot = await db
        .collection('dashboards')
        .doc(_dashboard_id)
        .collection('members')
        .get();

    final members =
        snapshot.docs.map((doc) => User.fromMap(doc.data())).toList();
    return members;
  }

  void getSettings() async {
    SharedPreferences? prefs = await SharedPreferences.getInstance();
    _dashboard_id = prefs.getString("dashboard_id")!;
    _userId = prefs.getString('userId')!;
    _role = prefs.getString('role')!;
    db.collection("dashboards").doc(_dashboard_id).get().then(
      (DocumentSnapshot doc) {
        final data = doc.data() as Map<String, dynamic>;
        log('$_userId');
        setState(() {
          dashboard_id_input.text = data['dashboard_id'];
          dashboard_name_input.text = data['dashboard_name'];
        });
      },
      onError: (e) => log("Error getting document: $e"),
    );
  }

  void saveSettings() {}

  Widget build(BuildContext context) {
    final adaptiveSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 149, 152, 229),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(MediaQuery.of(context).padding.top),
        child: SizedBox(
          height: MediaQuery.of(context).padding.top,
        ),
      ),
      body: Container(
        child: Column(
          children: [
            SizedBox(height: 15),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: Text(
                    "Settings",
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 30,
                        color: Colors.white),
                  ),
                )
              ],
            ),
            const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                   borderRadius: BorderRadius.circular(30)),
              width: adaptiveSize.width - 50,
              height: adaptiveSize.height - 200,
              child: ListView(
                children: [
                  Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: Colors.black, width: 2),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                        child: Column(children: [
                          const Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                                child: Text(
                                  "Dashboard",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 20),
                          Form(
                              child: Column(
                            children: [
                              Row(
                                children: [
                                  Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 16),
                                      child: SizedBox(
                                        width: adaptiveSize.width - 200,
                                        child: TextFormField(
                                          controller: dashboard_id_input,
                                          readOnly: true,
                                          decoration: const InputDecoration(
                                              border: OutlineInputBorder(),
                                              labelText: 'Dashboard ID',
                                              labelStyle:
                                                  TextStyle(fontSize: 15)),
                                        ),
                                      )),
                                  if (_role =='admin')    
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(20, 0, 0, 0),
                                    child: 
                                    
                                    IconButton(
                                        onPressed: resetDashboardId,
                                        icon: const Icon(
                                          Icons.sync,
                                          size: 30,
                                        )),
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 16),
                                      child: SizedBox(
                                        width: adaptiveSize.width - 200,
                                        child: TextFormField(
                                          controller: dashboard_name_input,
                                          readOnly: true,
                                          decoration: const InputDecoration(
                                            border: OutlineInputBorder(),
                                            labelText: 'Dashboard Name',
                                          ),
                                        ),
                                      )),
                                ],
                              ),
                              Row(
                                children: [
                                  Switch(
                                    // This bool value toggles the switch.
                                    value: theme,
                                    activeColor: Colors.purple,
                                    inactiveThumbColor: Colors.black,
                                    onChanged: (bool value) {
                                      // This is called when the user toggles the switch.
                                      setState(() {
                                        theme = value;
                                      });
                                    },
                                  ),
                                  const Text(
                                    "Dark Theme",
                                    style: TextStyle(
                                        fontSize: 20, fontFamily: 'Poppins'),
                                  )
                                ],
                              ),
                              const Row(children: [
                                Padding(
                                    padding: EdgeInsets.fromLTRB(10, 10, 0, 10),
                                    child: Text(
                                      "Users",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500),
                                    ))
                              ]),
                              Container(
                                  width: adaptiveSize.width - 50,
                                  height: adaptiveSize.height / 6,
                                  child: Row(
                                    children: [
                                      Expanded(
                                          flex: 1,
                                          child: FutureBuilder<List<User>>(
                                              future: _membersFuture,
                                              builder: (BuildContext context,
                                                  AsyncSnapshot<List<User>>
                                                      snapshot) {
                                                if (snapshot.hasData) {
                                                  return ListView.builder(
                                                    padding: const EdgeInsets
                                                        .fromLTRB(8, 8, 8, 5),
                                                    itemCount:
                                                        snapshot.data!.length,
                                                    itemBuilder:
                                                        (BuildContext context,
                                                            int index) {
                                                      final members =
                                                          snapshot.data![index];
                                                      return Container(
                                                        margin:
                                                            EdgeInsets.fromLTRB(
                                                                0, 7, 0, 7),
                                                        padding:
                                                            EdgeInsets.fromLTRB(
                                                                20, 0, 20, 0),
                                                        decoration:
                                                            BoxDecoration(
                                                          border: Border.all(
                                                              color:
                                                                  Colors.black,
                                                              width: 2),
                                                        ),
                                                        child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Container(
                                                                margin: EdgeInsets
                                                                    .fromLTRB(
                                                                        0,
                                                                        15,
                                                                        0,
                                                                        15),
                                                                child: Text(
                                                                    '${members.email}'),
                                                              ),
                                                              if (_role ==
                                                                      'admin' &&
                                                                  members.userId !=
                                                                      _userId)
                                                                IconButton(
                                                                  onPressed:
                                                                      () {
                                                                    deleteUser(
                                                                        members
                                                                            .userId);
                                                                  },
                                                                  icon:
                                                                      const Icon(
                                                                    color: Color
                                                                        .fromARGB(
                                                                            255,
                                                                            207,
                                                                            54,
                                                                            43),
                                                                    Icons
                                                                        .delete,
                                                                    size: 30,
                                                                  ),
                                                                ),
                                                            ]),
                                                      );
                                                    },
                                                  );
                                                } else if (snapshot.hasError) {
                                                  return Text(
                                                      'Error: ${snapshot.error}');
                                                } else {
                                                  return const Center(
                                                      child:
                                                          CircularProgressIndicator());
                                                }
                                              }))
                                    ],
                                  )),
                              const SizedBox(height: 20),
                              if (_role =='admin')
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  
                                  ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color.fromARGB(
                                              255, 104, 57, 223),
                                          fixedSize: const Size(200, 50)),
                                      onPressed: saveSettings,
                                      child: const Text(
                                        "Save",
                                        style: TextStyle(
                                            fontSize: 24,
                                            fontFamily: 'Poppins'),
                                      ))
                                ],
                              ),
                              const SizedBox(height: 20)
                            ],
                          ))
                        ]),
                      ))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
