import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:home_mate/appLocalization';
import 'package:home_mate/views/note_list_view.dart';
import 'package:home_mate/views/notes.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../control/localProvider.dart';
import '../control/themeProvider.dart';
import 'main_view.dart';
import 'myNotesListView.dart';

class LocalNotes extends StatefulWidget {
  @override
  State<LocalNotes> createState() => _LocalNotesState();
}

class LocalNote {
  String? title;
  String? noteId;
  LocalNote({required this.title, required this.noteId});
  factory LocalNote.fromMap(Map<String, dynamic> map) {
    return LocalNote(title: map['title'], noteId: map['noteId']);
  }
}

class _LocalNotesState extends State<LocalNotes> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  String _role = '';
  final _title_controller = TextEditingController();
  final _new_title_controller = TextEditingController();
  final _description_controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String _user_id = '';
  String _dashboard_id = '';
  late Future<List<LocalNote>> _notesFuture;

  @override
  void initState() {
    super.initState();
    _notesFuture = getNotes();
  }

  Future<void> createNote() async {
    String? newTitle = _title_controller.text;
    SharedPreferences? prefs = await SharedPreferences.getInstance();
    _user_id = prefs.getString('userId')!;
    log(_user_id);
    

    db
        .collection('dashboards')
        .doc(_dashboard_id)
        .collection('members')
        .doc(_user_id)
        .collection('notes')
        .add({'title': newTitle}).then((documentSnapshot) => {
              db
                  .collection('dashboards')
                  .doc(_dashboard_id)
                  .collection('members')
                  .doc(_user_id)
                  .collection('notes')
                  .doc(documentSnapshot.id)
                  .update({
                'noteId': documentSnapshot.id,
              }).then((value) => setState(() {
                        _notesFuture = getNotes();
                      }))
            });
  }

  void editNote(noteId) async {
    String? newTitle = _new_title_controller.text;
    SharedPreferences? prefs = await SharedPreferences.getInstance();
    _user_id = prefs.getString('userId')!;
    db
        .collection('dashboards')
        .doc(_dashboard_id)
        .collection('members')
        .doc(_user_id)
        .collection('notes')
        .doc(noteId)
        .update({"title": newTitle}).then((value) => setState(() {
              _notesFuture = getNotes();
            }));
  }

  void deleteNote(noteId) async {
    SharedPreferences? prefs = await SharedPreferences.getInstance();
    _user_id = prefs.getString('userId')!;
    db
        .collection('dashboards')
        .doc(_dashboard_id)
        .collection('members')
        .doc(_user_id)
        .collection('notes')
        .doc(noteId)
        .delete()
        .then((value) => setState(() {
              _notesFuture = getNotes();
            }));
  }

  Future<List<LocalNote>> getNotes() async {
    SharedPreferences? prefs = await SharedPreferences.getInstance();
    _dashboard_id = prefs.getString("dashboard_id")!;
    _user_id = prefs.getString('userId')!;
    _role = prefs.getString("role")!;
    
    var note_user_id = '';
    final snapshot = await FirebaseFirestore.instance
        .collection('dashboards')
        .doc(_dashboard_id)
        .collection('members')
        .where('userId', isEqualTo: _user_id)
        .get();

    for (var docSnapshot in snapshot.docs) {
      note_user_id = docSnapshot.data()['userId'];
    }

    final notes_snapshot = await FirebaseFirestore.instance
        .collection('dashboards')
        .doc(_dashboard_id)
        .collection('members')
        .doc(note_user_id)
        .collection('notes')
        .get();

    final notes = notes_snapshot.docs
        .map((doc) => LocalNote.fromMap(doc.data()))
        .toList();
    log('${notes}');
    return notes;
  }

  @override
  Widget build(BuildContext context) {
    final ButtonStyle style =
        ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20));
    final adaptiveSize = MediaQuery.of(context).size;
    final localeProvider = Provider.of<LocaleProvider>(context);
    final currentLocale = localeProvider.locale;
    final themeProvider = Provider.of<ThemeProvider>(context);
    themeProvider.fetchTheme();

    final appTranslations = AppTranslations.translations['${currentLocale}']!;

    return Consumer<ThemeProvider>(builder: (context, themeProvider, _) {
      final theme = themeProvider.theme;
      return Scaffold(
        appBar: AppBar(
          title: Text(Intl.message(appTranslations['my_notes']!),
              style: TextStyle( fontSize: 24)),
          centerTitle: true,
          automaticallyImplyLeading: false,
          backgroundColor: theme == 'dark'
              ? Color.fromARGB(255, 36, 36, 36)
              : theme == 'light'
                  ? Color.fromARGB(255, 225, 220, 220)
                  : Color.fromARGB(255, 149, 152, 229),
        ),
        backgroundColor: theme == 'dark'
            ? Colors.black
            : theme == 'light'
                ? Colors.white
                : Color.fromARGB(255, 149, 152, 229),
        body: Center(
            child: Container(
          decoration: const BoxDecoration(),
          child: Column(children: [
            const SizedBox(
              height: 30,
            ),
            SizedBox(
                width: MediaQuery.of(context).size.width - 50,
                height: adaptiveSize.height - 200,
                child: Column(
                  children: [
                    Expanded(
                        child: FutureBuilder<List<LocalNote>>(
                            future: _notesFuture,
                            builder: (BuildContext context,
                                AsyncSnapshot<List<LocalNote>> snapshot) {
                              if (snapshot.hasData) {
                                return ListView.builder(
                                  padding:
                                      const EdgeInsets.fromLTRB(8, 8, 8, 5),
                                  itemCount: snapshot.data!.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    final notes = snapshot.data![index];
                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            (context),
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    MyNoteListView(
                                                        arguments: Note(
                                                            noteId:
                                                                notes.noteId,
                                                            title:
                                                                notes.title))));
                                      }, // Handle your callback
                                      child: AnimatedContainer(
                                          duration:
                                              const Duration(milliseconds: 100),
                                          padding: const EdgeInsets.fromLTRB(
                                              20, 0, 20, 0),
                                          margin: const EdgeInsets.fromLTRB(
                                              0, 10, 0, 10),
                                          height: 80,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            color: theme == 'dark'
                                                ? Colors.white
                                                : theme == 'light'
                                                    ? Color.fromARGB(
                                                        255, 36, 36, 36)
                                                    : Colors.white,
                                            boxShadow: [
                                              BoxShadow(
                                                color: theme == 'dark'
                                                    ? Colors.white
                                                        .withOpacity(0.5)
                                                    : theme == 'light'
                                                        ? Colors.black
                                                            .withOpacity(0.5)
                                                        : Color.fromARGB(255,
                                                                104, 57, 223)
                                                            .withOpacity(0.5),
                                                spreadRadius: 5,
                                                blurRadius: 7,
                                                offset: Offset(0,
                                                    3), // changes position of shadow
                                              ),
                                            ],
                                          ),
                                          child: Column(
                                            children: [
                                              Padding(
                                                  padding: EdgeInsets.fromLTRB(
                                                      10, 10, 5, 5),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        '${notes.title}',
                                                        style: TextStyle(
                                                          fontSize: 30,
                                                          color: theme == 'dark'
                                                              ? Colors.black
                                                              : theme == 'light'
                                                                  ? Colors.white
                                                                  : Colors
                                                                      .black,
                                                        ),
                                                      ),
                                                      if (_role != 'guest')
                                                        IconButton(
                                                          color: theme == 'dark'
                                                              ? Colors.black
                                                              : theme == 'light'
                                                                  ? Colors.white
                                                                  : Colors
                                                                      .black,
                                                          onPressed: () {
                                                            showDialog<String>(
                                                              context: context,
                                                              builder: (BuildContext
                                                                      context) =>
                                                                  AlertDialog(
                                                                shadowColor: theme ==
                                                                        'dark'
                                                                    ? Colors
                                                                        .white
                                                                    : theme ==
                                                                            'light'
                                                                        ? Colors
                                                                            .black
                                                                        : Color.fromARGB(
                                                                            255,
                                                                            104,
                                                                            57,
                                                                            223),
                                                                shape: const RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.all(
                                                                            Radius.circular(30))),
                                                                scrollable:
                                                                    true,
                                                                title: Text(Intl
                                                                    .message(
                                                                        appTranslations[
                                                                            'note_editor']!)),
                                                                content:
                                                                    Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .all(
                                                                          8.0),
                                                                  child: Form(
                                                                    child:
                                                                        Column(
                                                                      children: <Widget>[
                                                                        TextFormField(
                                                                          controller:
                                                                              _new_title_controller,
                                                                          decoration:
                                                                              InputDecoration(
                                                                            labelText:
                                                                                Intl.message(appTranslations['new_title']!),
                                                                            hintText:
                                                                                Intl.message(appTranslations['type_title']!),
                                                                            icon: Icon(Icons.title_outlined,
                                                                                color: theme == 'dark'
                                                                                    ? Colors.black
                                                                                    : theme == 'light'
                                                                                        ? Colors.black
                                                                                        : Color.fromARGB(255, 104, 57, 223)),
                                                                          ),
                                                                        ),
                                                                        const SizedBox(
                                                                            height:
                                                                                25),
                                                                        Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceAround,
                                                                          children: [
                                                                            ElevatedButton(
                                                                              onPressed: () {
                                                                                editNote(notes.noteId);
                                                                                _new_title_controller.clear();
                                                                                Navigator.pop(context);
                                                                              },
                                                                              style: ElevatedButton.styleFrom(
                                                                                fixedSize: Size(110, 40),
                                                                                backgroundColor: theme == 'dark'
                                                                                    ? Colors.black
                                                                                    : theme == 'light'
                                                                                        ? Colors.black
                                                                                        : Color.fromARGB(255, 104, 57, 223),
                                                                              ),
                                                                              child: Text(Intl.message(appTranslations['save']!)),
                                                                            ),
                                                                            const SizedBox(width: 10),
                                                                            ElevatedButton(
                                                                                onPressed: () {
                                                                                  Navigator.pop(context);
                                                                                },
                                                                                style: ElevatedButton.styleFrom(
                                                                                  backgroundColor: Colors.white,
                                                                                  fixedSize: Size(110, 40),
                                                                                ),
                                                                                child: Text(
                                                                                  Intl.message(appTranslations['cancel']!),
                                                                                  style: TextStyle(
                                                                                    color: theme == 'dark'
                                                                                        ? Colors.black
                                                                                        : theme == 'light'
                                                                                            ? Colors.black
                                                                                            : Color.fromARGB(255, 104, 57, 223),
                                                                                  ),
                                                                                ))
                                                                          ],
                                                                        ),
                                                                        SizedBox(
                                                                            height:
                                                                                20),
                                                                        Row(
                                                                          children: [
                                                                            ElevatedButton(
                                                                                onPressed: () {
                                                                                  deleteNote(notes.noteId);
                                                                                  Navigator.pop(context);
                                                                                },
                                                                                style: ElevatedButton.styleFrom(
                                                                                  backgroundColor: Colors.red,
                                                                                  foregroundColor: Colors.white,
                                                                                  fixedSize: Size(230, 40),
                                                                                ),
                                                                                child: Text(Intl.message(appTranslations['delete']!)))
                                                                          ],
                                                                        )
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                          icon: Icon(
                                                            Icons.edit_outlined,
                                                            size: 30,
                                                          ),
                                                        )
                                                    ],
                                                  )),
                                              SizedBox(
                                                height: 12,
                                              ),
                                              
                                            ],
                                          )),
                                    );
                                  },
                                );
                              } else if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              } else {
                                return Center(
                                    child: CircularProgressIndicator());
                              }
                            }))
                  ],
                ))
          ]),
        )),
        floatingActionButton: FloatingActionButton(
          onPressed: () => showDialog<String>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              shadowColor: theme == 'dark'
                  ? Colors.white
                  : theme == 'light'
                      ? Colors.black
                      : Color.fromARGB(255, 104, 57, 223),
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30))),
              scrollable: true,
              title: Text(Intl.message(appTranslations['new_note']!)),
              content: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        controller: _title_controller,
                        decoration: InputDecoration(
                          labelText: Intl.message(appTranslations['title']!),
                          hintText:
                              Intl.message(appTranslations['type_title']!),
                          icon: Icon(Icons.title_outlined,
                              color: theme == 'dark'
                                  ? Colors.black
                                  : theme == 'light'
                                      ? Colors.black
                                      : Color.fromARGB(255, 104, 57, 223)),
                        ),
                      ),
                      const SizedBox(height: 25),
                      Row(
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              createNote();
                              _description_controller.clear();
                              _title_controller.clear();
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: theme == 'dark'
                                  ? Colors.black
                                  : theme == 'light'
                                      ? Colors.black
                                      : Color.fromARGB(255, 104, 57, 223),
                            ),
                            child:
                                Text(Intl.message(appTranslations['create']!)),
                          ),
                          const SizedBox(width: 10),
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                Intl.message(appTranslations['cancel']!),
                                style: TextStyle(
                                  color: theme == 'dark'
                                      ? Colors.black
                                      : theme == 'light'
                                          ? Colors.black
                                          : Color.fromARGB(255, 104, 57, 223),
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
          child: Icon(
            Icons.add,
            color: theme == 'dark'
                ? Colors.black
                : theme == 'light'
                    ? Colors.black
                    : Color.fromARGB(255, 104, 57, 223),
          ),
        ),
      );
    });
  }
}
