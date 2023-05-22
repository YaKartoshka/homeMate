import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:home_mate/views/notes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NoteListView extends StatefulWidget {
  final Note arguments;
  const NoteListView({super.key, required this.arguments});

  @override
  State<NoteListView> createState() => _NoteListViewState();
}

class NoteItem {
  String? title;
  String? noteItemId;
  bool? isCompleted;
  NoteItem(
      {required this.title,
      required this.noteItemId,
      required this.isCompleted});
  factory NoteItem.fromMap(Map<String, dynamic> map) {
    return NoteItem(
        title: map['title'],
        noteItemId: map['noteItemId'],
        isCompleted: map['isCompleted']);
  }
}

class _NoteListViewState extends State<NoteListView> {
  String _progressBarPercentage = '';
  var _progressBar = 0.0;
  late Future<List<NoteItem>> _noteItemsFuture;
  FirebaseFirestore db = FirebaseFirestore.instance;
  SharedPreferences? prefs;
  final _title_controller = TextEditingController();
  final _new_title_controller = TextEditingController();
  final _description_controller = TextEditingController();
  String _dashboard_id = '';
  String note_id = '';

  @override
  void initState() {
    super.initState();
    _noteItemsFuture = getNoteItems();
    getProgress();
  }

  Future<List<NoteItem>> getNoteItems() async {
    prefs = await SharedPreferences.getInstance();
    _dashboard_id = prefs!.getString("dashboard_id")!;
    note_id = widget.arguments.noteId!;

    final snapshot = await db
        .collection('dashboards')
        .doc(_dashboard_id)
        .collection('notes')
        .doc(note_id)
        .collection('note_items')
        .get();

    final noteItems =
        snapshot.docs.map((doc) => NoteItem.fromMap(doc.data())).toList();

    return noteItems;
  }

  Future<void> createNoteItem() async {
    note_id = widget.arguments.noteId!;
    String? newTitle = _title_controller.text;
    var noteItemsCollection = db
        .collection('dashboards')
        .doc(_dashboard_id)
        .collection('notes')
        .doc(note_id)
        .collection('note_items');

    var newNote = noteItemsCollection
        .add({'title': newTitle, 'isCompleted': false}).then(
            (documentSnapshot) => {
                  noteItemsCollection.doc(documentSnapshot.id).update({
                    'noteItemId': documentSnapshot.id,
                  }).then((value) => setState(() {
                        _noteItemsFuture = getNoteItems();
                        getProgress();
                      }))
                });
  }

  Future<void> editNoteItem(noteItemId) async {
    String? newTitle = _new_title_controller.text;
    db
        .collection('dashboards')
        .doc(_dashboard_id)
        .collection('notes')
        .doc(note_id)
        .collection('note_items')
        .doc(noteItemId).update({
          "title": newTitle
        }).then((value) => 
        setState(() {
          _noteItemsFuture = getNoteItems();
        })
        );
  }

  Future<void> deleteNoteItem(noteItemId) async {
    db
        .collection('dashboards')
        .doc(_dashboard_id)
        .collection('notes')
        .doc(note_id)
        .collection('note_items')
        .doc(noteItemId)
        .delete()
        .then(
          (doc) => log("Document deleted"),
          onError: (e) => log("Error updating document $e"),
        );

    setState(() {
      _noteItemsFuture = getNoteItems();
      getProgress();
    });
  }

  getProgress() async {
    prefs = await SharedPreferences.getInstance();
    _dashboard_id = prefs!.getString("dashboard_id")!;
    note_id = widget.arguments.noteId!;

    final snapshot = await db
        .collection('dashboards')
        .doc(_dashboard_id)
        .collection('notes')
        .doc(note_id)
        .collection('note_items')
        .get();

    final noteItems =
        snapshot.docs.map((doc) => NoteItem.fromMap(doc.data())).toList();
    var max = noteItems.length;
    var completed = noteItems.where((element) => element.isCompleted == true);
    var percentage = (completed.length / max);
    setState(() {
      log("$percentage");
      _progressBarPercentage =
          percentage.isNaN ? "0%" : '${(percentage * 100).ceil().toString()}%';
      _progressBar = percentage.isNaN ? 0 : percentage;
    });
  }

  void changeStatus(noteItemId, noteItemStatus) {
    db
        .collection('dashboards')
        .doc(_dashboard_id)
        .collection('notes')
        .doc(note_id)
        .collection("note_items")
        .doc(noteItemId)
        .update({'isCompleted': !noteItemStatus});

    setState(() {
      _noteItemsFuture = getNoteItems();
    });
  }

  @override
  Widget build(BuildContext context) {
    final adaptive_size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color.fromRGBO(149, 152, 229, 1),
      body: Container(
        decoration: const BoxDecoration(),
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          const SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(20, 20, 0, 0),
                          child:
                              Image(image: AssetImage("assets/back_arrow.png")),
                        )
                      ])),
            ],
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
            width: adaptive_size.width - 50,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Column(
              children: [
                const SizedBox(
                  height: 15,
                ),
                Text(
                  "${widget.arguments.title}",
                  style: const TextStyle(
                    fontSize: 35,
                    fontFamily: 'Poppins',
                  ),
                ),
                SizedBox(
                    width: adaptive_size.width - 20,
                    height: adaptive_size.height - 300,
                    child: Row(
                      children: [
                        Expanded(
                            flex: 1,
                            child: FutureBuilder<List<NoteItem>>(
                                future: _noteItemsFuture,
                                builder: (BuildContext context,
                                    AsyncSnapshot<List<NoteItem>> snapshot) {
                                  if (snapshot.hasData) {
                                    return ListView.builder(
                                      padding:
                                          const EdgeInsets.fromLTRB(8, 8, 8, 5),
                                      itemCount: snapshot.data!.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        final noteItems = snapshot.data![index];
                                        return GestureDetector(
                                            onTap:
                                                () {}, // Handle your callback
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Transform.scale(
                                                  scale: 1.2,
                                                  child: Checkbox(
                                                    value:
                                                        noteItems.isCompleted,
                                                    onChanged: (bool? value) {
                                                      changeStatus(
                                                          noteItems.noteItemId,
                                                          noteItems
                                                              .isCompleted);
                                                    },
                                                    activeColor: Colors.blue,
                                                    checkColor: Colors.white,
                                                    visualDensity:
                                                        const VisualDensity(
                                                            vertical: 3.0,
                                                            horizontal: 3.0),
                                                  ),
                                                ),
                                                Text(
                                                  '${noteItems.title}',
                                                  style: const TextStyle(
                                                    fontSize: 20,
                                                    fontFamily: 'Poppins',
                                                  ),
                                                ),
                                                Flex(
                                                    direction: Axis.horizontal,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .fromLTRB(
                                                                0, 0, 10, 0),
                                                        child: IconButton(
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
                                                                            Radius.circular(20))),
                                                                scrollable:
                                                                    true,
                                                                title:
                                                                    const Text(
                                                                  'Are you sure?',
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                ),
                                                                content:
                                                                    Padding(
                                                                        padding:
                                                                            const EdgeInsets.all(
                                                                                8.0),
                                                                        child:
                                                                            Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceAround,
                                                                          children: [
                                                                            ElevatedButton(
                                                                                onPressed: () {
                                                                                  Navigator.pop(context);
                                                                                },
                                                                                style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.purple, shadowColor: Colors.red, fixedSize: const Size(80, 40)),
                                                                                child: const Text("Cancel")),
                                                                            ElevatedButton(
                                                                                onPressed: () {
                                                                                  deleteNoteItem(noteItems.noteItemId);
                                                                                  Navigator.pop(context);
                                                                                },
                                                                                style: ElevatedButton.styleFrom(backgroundColor: Colors.red, fixedSize: const Size(80, 40)),
                                                                                child: const Text("Delete"))
                                                                          ],
                                                                        )),
                                                              ),
                                                            );
                                                          },
                                                          icon: const Icon(
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    207,
                                                                    54,
                                                                    43),
                                                            Icons.delete,
                                                            size: 30,
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .fromLTRB(
                                                                0, 0, 10, 0),
                                                        child: IconButton(
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
                                                                            Radius.circular(30))),
                                                                scrollable:
                                                                    true,
                                                                title: const Text(
                                                                    'Edit'),
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
                                                                              _title_controller,
                                                                          decoration:
                                                                              const InputDecoration(
                                                                            labelText:
                                                                                'New title',
                                                                            hintText:
                                                                                'Type a title',
                                                                            icon:
                                                                                Icon(Icons.title_outlined, color: Color.fromARGB(255, 104, 57, 223)),
                                                                          ),
                                                                        ),
                                                                        const SizedBox(
                                                                            height:
                                                                                25),
                                                                        Row(
                                                                          children: [
                                                                            ElevatedButton(
                                                                              onPressed: () {
                                                                                editNoteItem(noteItems.noteItemId);
                                                                                _new_title_controller.clear();
                                                                                Navigator.pop(context);
                                                                              },
                                                                              style: ElevatedButton.styleFrom(
                                                                                backgroundColor: const Color.fromARGB(255, 104, 57, 223),
                                                                              ),
                                                                              child: const Text('Save'),
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
                                                            );
                                                          },
                                                          icon: const Icon(
                                                            Icons.edit,
                                                            size: 30,
                                                          ),
                                                        ),
                                                      ),
                                                    ])
                                              ],
                                            ));
                                      },
                                    );
                                  } else if (snapshot.hasError) {
                                    return Text('Error: ${snapshot.error}');
                                  } else {
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  }
                                }))
                      ],
                    )),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        shadowColor: const Color.fromARGB(255, 104, 57, 223),
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(30))),
                        scrollable: true,
                        title: const Text('New note item'),
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
                                        color:
                                            Color.fromARGB(255, 104, 57, 223)),
                                  ),
                                ),
                                const SizedBox(height: 25),
                                Row(
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        createNoteItem();
                                        _title_controller.clear();
                                        Navigator.pop(context);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color.fromARGB(
                                            255, 104, 57, 223),
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
                                            color: Color.fromARGB(
                                                255, 104, 57, 223),
                                          ),
                                        ))
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  child: const Text('Add Item'),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 104, 57, 223),
                      fixedSize: const Size(200, 30)),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
          const SizedBox(height: 15),
          SizedBox(
              width: adaptive_size.width - 50,
              child: Column(
                children: [
                  Text(
                    _progressBarPercentage,
                    style: const TextStyle(fontSize: 25, color: Colors.white),
                  ),
                  LinearProgressIndicator(
                    value: _progressBar,
                    color: const Color.fromARGB(255, 104, 57, 223),
                    minHeight: 15,
                  ),
                ],
              ))
        ]),
      ),
    );
  }
}
