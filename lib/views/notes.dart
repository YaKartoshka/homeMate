import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:home_mate/appLocalization';
import 'package:home_mate/views/note_list_view.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../control/localProvider.dart';
import 'main_view.dart';

class Notes extends StatefulWidget {
  @override
  State<Notes> createState() => _NotesState();
}

class Note {
  String? title;
  String? noteId;
  Note({required this.title, required this.noteId});
  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(title: map['title'], noteId: map['noteId']);
  }
}

class _NotesState extends State<Notes> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  String _role = '';
  final _title_controller = TextEditingController();
  final _new_title_controller = TextEditingController();
  final _description_controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String _dashboard_id = '';
  late Future<List<Note>> _notesFuture;

  @override
  void initState() {
    super.initState();
    _notesFuture = getNotes();
  }

  Future<void> createNote() async {
    // log(_dashboard_id);
    // s
    String? newTitle = _title_controller.text;

    var newNote = db
        .collection('dashboards')
        .doc(_dashboard_id)
        .collection('notes')
        .add({'title': newTitle}).then((documentSnapshot) => {
              db
                  .collection('dashboards')
                  .doc(_dashboard_id)
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
    db
        .collection("dashboards")
        .doc(_dashboard_id)
        .collection("notes")
        .doc(noteId)
        .update({"title": newTitle}).then((value) => setState(() {
              _notesFuture = getNotes();
            }));
  }

  void deleteNote(noteId) {
    db
        .collection("dashboards")
        .doc(_dashboard_id)
        .collection("notes")
        .doc(noteId)
        .delete()
        .then((value) => setState(() {
              _notesFuture = getNotes();
            }));
  }

  Future<List<Note>> getNotes() async {
    SharedPreferences? prefs = await SharedPreferences.getInstance();
    _dashboard_id = prefs.getString("dashboard_id")!;
    _role = prefs.getString("role")!;
    final snapshot = await FirebaseFirestore.instance
        .collection('dashboards')
        .doc(_dashboard_id)
        .collection('notes')
        .get();

    final notes = snapshot.docs.map((doc) => Note.fromMap(doc.data())).toList();
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
    
    final appTranslations = AppTranslations
        .translations['${currentLocale}']!;
    return Scaffold(
      appBar: AppBar(
        title: Text(Intl.message(appTranslations['notes']!),
            style: TextStyle(fontFamily: 'Poppins', fontSize: 24)),
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: Color.fromARGB(255, 149, 152, 229),
      ),
      backgroundColor: const Color.fromARGB(255, 149, 152, 229),
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
                      child: FutureBuilder<List<Note>>(
                          future: _notesFuture,
                          builder: (BuildContext context,
                              AsyncSnapshot<List<Note>> snapshot) {
                            if (snapshot.hasData) {
                              return ListView.builder(
                                padding: const EdgeInsets.fromLTRB(8, 8, 8, 5),
                                itemCount: snapshot.data!.length,
                                itemBuilder: (BuildContext context, int index) {
                                  final notes = snapshot.data![index];
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          (context),
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  NoteListView(
                                                      arguments: Note(
                                                          noteId: notes.noteId,
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
                                        height: 170,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          color: Color.fromARGB(
                                              255, 250, 250, 250),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Color.fromARGB(
                                                      255, 151, 110, 245)
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
                                                      ),
                                                    ),
                                                    if (_role != 'guest')
                                                      IconButton(
                                                        onPressed: () {
                                                          showDialog<String>(
                                                            context: context,
                                                            builder: (BuildContext
                                                                    context) =>
                                                                AlertDialog(
                                                              shadowColor:
                                                                  const Color
                                                                          .fromARGB(
                                                                      255,
                                                                      104,
                                                                      57,
                                                                      223),
                                                              shape: const RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              30))),
                                                              scrollable: true,
                                                              title: Text(
                                                                  Intl.message(appTranslations['note_editor']!)),
                                                              content: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        8.0),
                                                                child: Form(
                                                                  child: Column(
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
                                                                          icon: Icon(
                                                                              Icons.title_outlined,
                                                                              color: Color.fromARGB(255, 104, 57, 223)),
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
                                                                            onPressed:
                                                                                () {
                                                                              editNote(notes.noteId);
                                                                              _new_title_controller.clear();
                                                                              Navigator.pop(context);
                                                                            },
                                                                            style:
                                                                                ElevatedButton.styleFrom(
                                                                              fixedSize: Size(110, 40),
                                                                              backgroundColor: Color.fromARGB(255, 104, 57, 223),
                                                                            ),
                                                                            child:
                                                                                Text(Intl.message(appTranslations['save']!)),
                                                                          ),
                                                                          const SizedBox(
                                                                              width: 10),
                                                                          ElevatedButton(
                                                                              onPressed: () {
                                                                                Navigator.pop(context);
                                                                              },
                                                                              style: ElevatedButton.styleFrom(
                                                                                backgroundColor: Colors.white,
                                                                                fixedSize: Size(110, 40),
                                                                              ),
                                                                              child:  Text(
                                                                                Intl.message(appTranslations['cancel']!),
                                                                                style: TextStyle(
                                                                                  color: Color.fromARGB(255, 104, 57, 223),
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
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  height: 70,
                                                  width:
                                                      adaptiveSize.width / 1.8,
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: Color.fromARGB(
                                                              255,
                                                              143,
                                                              85,
                                                              197),
                                                          width: 2),
                                                      color: Color.fromARGB(
                                                          255, 226, 224, 224),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20)),
                                                  child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceAround,
                                                      children: [
                                                        Container(
                                                          child: Row(children: [
                                                            Icon(Icons
                                                                .check_circle_outline),
                                                            Text('3/5')
                                                          ]),
                                                        ),
                                                        Container(
                                                          child: Row(children: [
                                                            Icon(Icons.comment),
                                                            Text('3/5')
                                                          ]),
                                                        )
                                                      ]),
                                                )
                                              ],
                                            )
                                          ],
                                        )),
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
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            shadowColor: const Color.fromARGB(255, 104, 57, 223),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(30))),
            scrollable: true,
            title:  Text(Intl.message(appTranslations['new_note']!)),
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
                            backgroundColor: Color.fromARGB(255, 104, 57, 223),
                          ),
                          child: Text(Intl.message(appTranslations['create']!)),
                        ),
                        const SizedBox(width: 10),
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
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
