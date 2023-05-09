import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'main_view.dart';

  class Notes extends StatefulWidget {
  
 
  @override
  State<Notes> createState() => _NotesState();
}
class Note {
  String? title;
 
  Note(this.title);
}
class _NotesState extends State<Notes> {
  SharedPreferences? prefs;
  final _title_controller = TextEditingController();
  final _description_controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  List<Note> notes = [
    Note("Dinner"),
    Note("Dinner"),
  ];

  Future<void> _initPrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    super.initState();
    _initPrefs();
  }
  void createNotification() {
    setState(() {
      String? newTitle = _title_controller.text;
      notes.add(Note(newTitle));
    });
  }

  @override
  Widget build(BuildContext context) {
    final ButtonStyle style =
        ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20));
    final adaptive_size = MediaQuery.of(context).size;
    
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 149, 152, 229),
      
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
                "Notes",
                style: TextStyle(
                    fontSize: 40, fontFamily: 'Poppins', color: Colors.white),
              )
            ],
          ),
          SizedBox(
              width: MediaQuery.of(context).size.width - 50,
              height: 500,
              child: Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(8, 8, 8, 5),
                  itemCount: notes.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {}, // Handle your callback
                      child: AnimatedContainer(
                          duration: const Duration(milliseconds: 100),
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                          margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                          height: 170,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: const Color.fromARGB(230, 244, 244, 244),
                            boxShadow: [
                              BoxShadow(
                                color: Color.fromARGB(255, 151, 110, 245)
                                    .withOpacity(0.5),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset:
                                    Offset(0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Padding(
                                  padding: EdgeInsets.fromLTRB(10, 10, 5, 5),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '${notes[index].title}',
                                        style: TextStyle(
                                          fontSize: 30,
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {},
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
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 70,
                                    width: adaptive_size.width / 1.8,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Color.fromARGB(
                                                255, 143, 85, 197),
                                            width: 2),
                                        color:
                                            Color.fromARGB(255, 226, 224, 224),
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Container(
                                            child: Row(children: [
                                              Icon(Icons.check_circle_outline),
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
                ),
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
            title: const Text('New note'),
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