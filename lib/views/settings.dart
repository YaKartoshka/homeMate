import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:home_mate/appLocalization';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../control/localProvider.dart';
import '../control/themeProvider.dart';

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
    final memberDoc = await db
        .collection("dashboards")
        .doc(_dashboard_id)
        .collection("members")
        .doc(memberId);

    memberDoc.get().then(
      (DocumentSnapshot doc) async {
        final data = doc.data() as Map<String, dynamic>;
        final url =
            'https://identitytoolkit.googleapis.com/v1/accounts:delete?key=AIzaSyAXlJYSM2yNvcktWRF0JmgSShhqqMEyAD4';

        final response = await http.post(
          Uri.parse(url),
          body: json.encode({
            'idToken': data['idToken'],
          }),
        );

        if (response.statusCode == 200) {
          memberDoc.delete();
        } else {
          print('Failed to delete user. Error: ${response.body}');
        }
      },
      onError: (e) => print("Error getting document: $e"),
    );
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

  void handleClick(String value) async {
    SharedPreferences? prefs = await SharedPreferences.getInstance();
    if (value == "Logout" || value == 'Выйти' || value == "Шығу") {
      prefs.remove('dashboard_id');
      prefs.remove('role');
      prefs.remove('userId');
      _auth.signOut();

      Navigator.pushReplacementNamed(context, '/');
    }
  }

  void saveSettings() {}

  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);
    final currentLocale = localeProvider.locale;
    final appTranslations = AppTranslations.translations['${currentLocale}']!;
    final themeProvider = Provider.of<ThemeProvider>(context);
    themeProvider.fetchTheme();
    final adaptiveSize = MediaQuery.of(context).size;

    return Consumer2<LocaleProvider, ThemeProvider>(
        builder: (context, localeProvider, themeProvider, _) {
      final theme = themeProvider.theme;
      return Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: theme == 'dark'
              ? Colors.black
              : theme == 'light'
                  ? Colors.white
                  : Color.fromARGB(255, 149, 152, 229),
          appBar: AppBar(
            title: Text(Intl.message(appTranslations['settings']!),
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 24,
                  color: theme == 'dark'
              ? Colors.white
              : theme == 'light'
                  ? Colors.black
                  : Colors.white,
                )),
            centerTitle: true,
            automaticallyImplyLeading: false,
            actions: <Widget>[
              PopupMenuButton<String>(
                onSelected: handleClick,
                itemBuilder: (BuildContext context) {
                  return {Intl.message(appTranslations['logout']!)}
                      .map((String choice) {
                    return PopupMenuItem<String>(
                      value: choice,
                      child: Text(choice),
                    );
                  }).toList();
                },
              ),
            ],
            backgroundColor: theme == 'dark'
                ? Color.fromARGB(255, 36, 36, 36)
                : theme == 'light'
                    ? Color.fromARGB(255, 225, 220, 220)
                    : Color.fromARGB(255, 149, 152, 229),
          ),
          body: Center(
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(30)),
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
                              padding:
                                  const EdgeInsets.fromLTRB(20, 20, 20, 20),
                              child: Column(children: [
                                Row(
                                  children: [
                                    Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(10, 10, 0, 0),
                                      child: Text(
                                        Intl.message(
                                            appTranslations['dashboard']!),
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
                                                decoration: InputDecoration(
                                                    border:
                                                        OutlineInputBorder(),
                                                    labelText: Intl.message(
                                                        appTranslations[
                                                            'dashboard_id']!),
                                                    labelStyle: TextStyle(
                                                        fontSize: 15)),
                                              ),
                                            )),
                                        if (_role == 'admin')
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                20, 0, 0, 0),
                                            child: IconButton(
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
                                                controller:
                                                    dashboard_name_input,
                                                readOnly: true,
                                                decoration: InputDecoration(
                                                  border: OutlineInputBorder(),
                                                  labelText: Intl.message(
                                                      appTranslations[
                                                          'dashboard_name']!),
                                                ),
                                              ),
                                            )),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        
                                        Text(
                                          Intl.message(
                                              appTranslations['style_settings']!),
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(8, 10, 0, 0),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.language,
                                            size: 30,
                                          ),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          
                                          DropdownButton<Locale>(
                                            value: currentLocale,
                                            onChanged: (locale) {
                                           
                                              localeProvider.setLocale(locale!);
                                              prefs!.setString(
                                                  'language', '${locale}');
                                            },
                                            items: const [
                                              DropdownMenuItem<Locale>(
                                                value: Locale('kk'),
                                                child: Text('Kazakh'),
                                              ),
                                              DropdownMenuItem<Locale>(
                                                value: Locale('ru'),
                                                child: Text('Russian'),
                                              ),
                                              DropdownMenuItem<Locale>(
                                                value: Locale('en'),
                                                child: Text('English'),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                    Padding(padding: 
                                    EdgeInsets.fromLTRB(8, 10, 0, 0),
                                    child: Row(children: [
                                        Icon(
                                            Icons.invert_colors,
                                            size: 30,
                                          ),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          
                                      DropdownButton<String>(
                                            value: theme,
                                            onChanged: (theme) {
                                              prefs?.setString(
                                                  'theme', '${theme}');
                                              themeProvider.fetchTheme();
                                         
                                            },
                                            items: const [
                                              DropdownMenuItem<String>(
                                                value: 'default',
                                                child: Text('Default'),
                                              ),
                                              DropdownMenuItem<String>(
                                                value: 'light',
                                                child: Text('Light'),
                                              ),
                                              DropdownMenuItem<String>(
                                                value: 'dark',
                                                child: Text('Dark'),
                                              ),
                                            ],
                                          )
                                    ]),
                                    ),
                                    Row(children: [
                                      Padding(
                                          padding: EdgeInsets.fromLTRB(
                                              10, 10, 0, 10),
                                          child: Text(
                                            Intl.message(
                                                appTranslations['users']!),
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
                                                child:
                                                    FutureBuilder<List<User>>(
                                                        future: _membersFuture,
                                                        builder: (BuildContext
                                                                context,
                                                            AsyncSnapshot<
                                                                    List<User>>
                                                                snapshot) {
                                                          if (snapshot
                                                              .hasData) {
                                                            return ListView
                                                                .builder(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .fromLTRB(
                                                                      8,
                                                                      8,
                                                                      8,
                                                                      5),
                                                              itemCount:
                                                                  snapshot.data!
                                                                      .length,
                                                              itemBuilder:
                                                                  (BuildContext
                                                                          context,
                                                                      int index) {
                                                                final members =
                                                                    snapshot.data![
                                                                        index];
                                                                return Container(
                                                                  margin: const EdgeInsets
                                                                          .fromLTRB(
                                                                      0,
                                                                      7,
                                                                      0,
                                                                      7),
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .fromLTRB(
                                                                          20,
                                                                          0,
                                                                          20,
                                                                          0),
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    border: Border.all(
                                                                        color: Colors
                                                                            .black,
                                                                        width:
                                                                            2),
                                                                  ),
                                                                  child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        Container(
                                                                          margin: const EdgeInsets.fromLTRB(
                                                                              0,
                                                                              15,
                                                                              0,
                                                                              15),
                                                                          child:
                                                                              Text('${members.email}'),
                                                                        ),
                                                                        if (_role ==
                                                                                'admin' &&
                                                                            members.userId !=
                                                                                _userId)
                                                                          IconButton(
                                                                            onPressed:
                                                                                () {
                                                                              deleteUser(members.userId);
                                                                            },
                                                                            icon:
                                                                                Icon(
                                                                              color: Color.fromARGB(255, 207, 54, 43),
                                                                              Icons.delete,
                                                                              size: 30,
                                                                            ),
                                                                          ),
                                                                      ]),
                                                                );
                                                              },
                                                            );
                                                          } else if (snapshot
                                                              .hasError) {
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
                                    if (_role == 'admin')
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      theme == 'dark'
                                                          ? Colors.black
                                                          : theme == 'light'
                                                              ? Colors.black
                                                              : Color.fromARGB(
                                                                  255,
                                                                  104,
                                                                  57,
                                                                  223),
                                                  fixedSize:
                                                      const Size(200, 50)),
                                              onPressed: saveSettings,
                                              child: Text(
                                                Intl.message(
                                                    appTranslations['save']!),
                                                style: TextStyle(
                                                    fontSize: 24,
                                                    fontWeight:
                                                        FontWeight.w400),
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
          ));
    });
  }
}
