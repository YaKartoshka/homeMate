import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:home_mate/views/notes.dart';

class NoteListView extends StatefulWidget {
  const NoteListView({super.key});

  @override
  State<NoteListView> createState() => _NoteListViewState();
}

class NoteItem {
  String? title;
  String? noteItemId;
  bool? isChecked;
  NoteItem(this.title, this.noteItemId, this.isChecked);
}

class _NoteListViewState extends State<NoteListView> {
  final List<NoteItem> noteItems = [
    NoteItem('Item 1', '214', true),
    NoteItem('Item 2', '546', false),
    NoteItem('Item 3', '243', true),
    NoteItem('Item 1', '214', true),
    NoteItem('Item 2', '546', false),
    NoteItem('Item 3', '243', true),
    NoteItem('Item 1', '214', true),
    NoteItem('Item 2', '546', false),
    NoteItem('Item 3', '243', true),
  ];
  bool isChecked = false;
  @override
  Widget build(BuildContext context) {
    final adaptive_size = MediaQuery.of(context).size;
    final note = ModalRoute.of(context)!.settings.arguments as Note;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color.fromRGBO(149, 152, 229, 1),
      body: Container(
        decoration: const BoxDecoration(),
        child: Column(children: [
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
            margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
            width: adaptive_size.width - 50,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Column(
              children: [
                SizedBox(
                  height: 15,
                ),
                Text(
                  "${note.title}",
                  style: TextStyle(
                    fontSize: 35,
                    fontFamily: 'Poppins',
                  ),
                ),
                Container(
                  height: 500,
                  child: ListView.builder(
                      itemCount: noteItems.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Transform.scale(
                              scale: 1.2,
                              child: Checkbox(
                                value: noteItems[index].isChecked,
                                onChanged: (bool? value) {
                                  setState(() {
                                    noteItems[index].isChecked = value!;
                                  });
                                },
                                activeColor: Colors.blue,
                                checkColor: Colors.white,
                                visualDensity: VisualDensity(
                                    vertical: 3.0, horizontal: 3.0),
                              ),
                            ),
                            Text(
                              '${noteItems[index].title}',
                              style: TextStyle(
                                fontSize: 20,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            Flex(direction: Axis.horizontal, children: [
                              Padding(
                                padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                                child: IconButton(
                                  onPressed: () {},
                                  icon: Icon(
                                    Icons.delete,
                                    size: 30,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                                child: IconButton(
                                  onPressed: () {},
                                  icon: Icon(
                                    Icons.edit,
                                    size: 30,
                                  ),
                                ),
                              ),
                            ])
                          ],
                        );
                      }),
                ),
              ],
            ),
          ),
          SizedBox(height: 15),
          SizedBox(
            width: adaptive_size.width - 50,
            child: Column(children: [
              Text('80%',style: TextStyle(
                fontSize: 25,
                color: Colors.white
              ),),
              LinearProgressIndicator(
              value: 0.7,
              color: Color.fromARGB(255, 104, 57, 223),
              minHeight: 15,
            ),
            ],)
          )
        ]),
      ),
    );
  }
}
