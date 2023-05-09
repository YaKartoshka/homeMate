import 'package:flutter/material.dart';

class NoteListView extends StatefulWidget {
  const NoteListView({super.key});

  @override
  State<NoteListView> createState() => _NoteListViewState();
}

class NoteList{
  String? title;
  List? content;
  NoteList(this.title, this.content);
}

class _NoteListViewState extends State<NoteListView> {
  List<NoteList> noteLists = [
    NoteList("Products", ["Egg","Bread"]),
  ];


  @override
  Widget build(BuildContext context) {
    final adaptive_size=MediaQuery.of(context).size;
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
                "Products",
                style: TextStyle(
                    fontSize: 40, fontFamily: 'Poppins', color: Colors.white),
              )
            ],
          ),
          SizedBox(
              width: MediaQuery.of(context).size.width - 50,
              height: 500,
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.fromLTRB(8, 8, 8, 5),
                      itemCount: noteLists.length,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                         // Handle your callback
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
                                    offset: Offset(
                                        0, 3), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(10, 10, 5, 5),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            '${noteLists[index].title}',
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
                                            color: Color.fromARGB(
                                                255, 226, 224, 224),
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
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
                    ),
                  )
                ],
              ))
        ]),
    ),
    );
  }
}
