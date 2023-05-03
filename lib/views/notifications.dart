import 'package:flutter/material.dart';

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  int _selectedIndex = 0;
  
   void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

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
        child: Column(
          
          children: [
            const SizedBox(height: 30,),

            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Notifications", style: TextStyle(
                  fontSize: 40  ,
                  fontFamily: 'Poppins',
                  color: Colors.white
                ),)
              ],
            ),
           SizedBox(
            height: 500,
            child: ListView(
          
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 5),
            children: <Widget>[
              Container(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                height: 70,
              
                decoration: BoxDecoration(
                   borderRadius: BorderRadius.circular(30),
                   color: const Color.fromARGB(255, 255, 255, 255),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [ 
                    const Icon(
                      Icons.holiday_village
                    ),
                    const Text("Let's eat", style: TextStyle(
                      
                    ),),
                    IconButton(onPressed: (){}, icon: const Icon(Icons.abc), iconSize: 30,)
                  ]),
              ),
              GestureDetector (
                onTap: () {
                 
                }, // Handle your callback
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 100),
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                  height: 70,
                
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: const Color.fromARGB(255, 255, 255, 255),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [ 
                      const Icon(
                        Icons.holiday_village
                      ),
                      const Text("Let's eat", style: TextStyle(
                        
                      ),),
                      IconButton(onPressed: (){}, icon: const Icon(Icons.abc), iconSize: 30,)
                    ]),
                ),
              ),
              GestureDetector (
                onTap: () {}, // Handle your callback
                child: Container(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                height: 70,
              
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: const Color.fromARGB(255, 255, 255, 255),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [ 
                    const Icon(
                      Icons.holiday_village
                    ),
                    const Text("Let's eat", style: TextStyle(
                      
                    ),),
                    IconButton(onPressed: (){}, icon: const Icon(Icons.abc), iconSize: 30,)
                  ]),
                ),
              ),
              GestureDetector (
                onTap: () {}, // Handle your callback
                child: Container(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                height: 70,
              
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: const Color.fromARGB(255, 255, 255, 255),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [ 
                    const Icon(
                      Icons.holiday_village
                    ),
                    const Text("Let's eat", style: TextStyle(
                      
                    ),),
                    IconButton(onPressed: (){}, icon: const Icon(Icons.abc), iconSize: 30,)
                  ]),
                ),
              ),
              GestureDetector (
                onTap: () {}, // Handle your callback
                child: Container(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                height: 70,
              
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: const Color.fromARGB(255, 255, 255, 255),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [ 
                    const Icon(
                      Icons.holiday_village
                    ),
                    const Text("Let's eat", style: TextStyle(
                      
                    ),),
                    IconButton(onPressed: (){}, icon: const Icon(Icons.abc), iconSize: 30,)
                  ]),
                ),
              ),
              GestureDetector (
                onTap: () {}, // Handle your callback
                child: Container(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                height: 70,
              
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: const Color.fromARGB(255, 255, 255, 255),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [ 
                    const Icon(
                      Icons.holiday_village
                    ),
                    const Text("Let's eat", style: TextStyle(
                      
                    ),),
                    IconButton(onPressed: (){}, icon: const Icon(Icons.abc), iconSize: 30,)
                  ]),
                ),
              ),

               
            ],
          ),
           )

               
              ]
            ),

      
    ),
     bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.checkroom),
            label: 'Wardrobe',
            backgroundColor: Color.fromARGB(255, 104, 57, 223),
          ),
          
          BottomNavigationBarItem(
            icon: Icon(Icons.wb_sunny),
            label: 'Weather',
            backgroundColor: Color.fromARGB(255, 104, 57, 223),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event),
            label: 'Notes',
            backgroundColor: Color.fromARGB(255, 104, 57, 223),
          ),
           BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
            backgroundColor: Color.fromARGB(255, 104, 57, 223),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
            backgroundColor: Color.fromARGB(255, 104, 57, 223),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white,
        unselectedItemColor: const Color.fromARGB(255, 225, 220, 220),
        onTap: _onItemTapped,
      ),
   );
    
  }
}

