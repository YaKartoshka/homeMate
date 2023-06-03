import 'package:flutter/material.dart';

class Wardrobe extends StatefulWidget {
  const Wardrobe({Key? key}) : super(key: key);

  @override
  _WardrobeState createState() => _WardrobeState();
}

class _WardrobeState extends State<Wardrobe> {
  List<WardrobeItem> wardrobeItems = [
    WardrobeItem(category: 'Shirts', description: 'Blue T-Shirt'),
    WardrobeItem(category: 'Pants', description: 'Black Jeans'),
  ];

  String newCategory = '';
  String newDescription = '';

  void addItem() {
    setState(() {
      wardrobeItems.add(WardrobeItem(
        category: newCategory,
        description: newDescription,
      ));
      newCategory = '';
      newDescription = '';
    });
  }

  void deleteItem(int index) {
    setState(() {
      wardrobeItems.removeAt(index);
    });
  }

  void modifyItem(int index, String newCategory, String newDescription) {
    setState(() {
      wardrobeItems[index].category = newCategory;
      wardrobeItems[index].description = newDescription;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 149, 152, 229),
      appBar: AppBar(
        title: Text("Wardrobe",
            style: TextStyle(fontFamily: 'Poppins', fontSize: 24)),
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: Color.fromARGB(255, 149, 152, 229),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    onChanged: (value) {
                      setState(() {
                        newCategory = value;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Category',
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    onChanged: (value) {
                      setState(() {
                        newDescription = value;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Description',
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: addItem,
              child: Text('Add Item'),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: wardrobeItems.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(wardrobeItems[index].category),
                    subtitle: Text(wardrobeItems[index].description),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            // Show a dialog to modify item
                            showDialog(
                              context: context,
                              builder: (context) {
                                String modifiedCategory =
                                    wardrobeItems[index].category;
                                String modifiedDescription =
                                    wardrobeItems[index].description;

                                return AlertDialog(
                                  title: Text('Modify Item'),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      TextFormField(
                                        initialValue: modifiedCategory,
                                        onChanged: (value) {
                                          setState(() {
                                            modifiedCategory = value;
                                          });
                                        },
                                        decoration: InputDecoration(
                                          labelText: 'Category',
                                        ),
                                      ),
                                      SizedBox(height: 16),
                                      TextFormField(
                                        initialValue: modifiedDescription,
                                        onChanged: (value) {
                                          setState(() {
                                            modifiedDescription = value;
                                          });
                                        },
                                        decoration: InputDecoration(
                                          labelText: 'Description',
                                        ),
                                      ),
                                    ],
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        modifyItem(index, modifiedCategory,
                                            modifiedDescription);
                                        Navigator.pop(context);
                                      },
                                      child: Text('Save'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            deleteItem(index);
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WardrobeItem {
  String category;
  String description;

  WardrobeItem({required this.category, required this.description});
}
