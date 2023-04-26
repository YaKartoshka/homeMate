import 'package:flutter/material.dart';

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final ButtonStyle style =
        ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20));
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 149, 152, 229),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(MediaQuery.of(context).padding.top),
        child: SizedBox(
        height: MediaQuery.of(context).padding.top,
        ),
      ),
      body: Container(
        
        decoration: const BoxDecoration(
       
        ),
        child:   Column(
          children: [
            Row(
              children: [
                IconButton(
                icon: Image.asset('assets/menu.png'),
                iconSize: 50,
                onPressed: () {},
              )

               
              ]
            ),

            
      ])
     
    )
   );
    
  }
}

