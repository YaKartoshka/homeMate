import 'package:flutter/material.dart';
import 'package:home_mate/views/welcome.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
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
          image: DecorationImage(
            image: AssetImage("assets/background.png"),
            fit: BoxFit.fill,
            colorFilter: ColorFilter.mode(Color.fromARGB(255, 149, 152, 229), BlendMode.overlay)
          ),
        ),
        child:  Column(
          children: [ GestureDetector( onTap: () {Navigator.push(context, MaterialPageRoute(builder: (context) => Welcome()),); },
              child: const Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                 Padding(
                  padding: EdgeInsets.fromLTRB(20, 20, 0, 0),
                  child:  Image(image: AssetImage("assets/back_arrow.png")),
                  )
               
              ]
            )),
            const SizedBox(
              width: 0,
              height: 30,
            ),
            const Row(
              
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("HomeMate", style: TextStyle(
                  fontSize: 45,
                  fontFamily: 'Poppins',
                  color: Colors.white,
                  shadows: <Shadow>[
                    Shadow(
                      offset: Offset(0, 10.0),
                      blurRadius: 10.0,
                      color: Color.fromARGB(70, 0, 0, 0)
                    ),
                  
                  ],

                ),),
               
              ]
            ),
        Center(
          child: Container(
            decoration:  BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30.0),
             
            ),
            margin: const EdgeInsets.all(50),
            width: 320,
            height: 400,
            child:    Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                   const Text("Login", style: TextStyle(
                        fontSize: 25,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    Form(  
                      key: _formKey,  
                      child: Column(  
                        crossAxisAlignment: CrossAxisAlignment.start,  
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const SizedBox(height: 25,),
                          SizedBox(
                            width: 250,
                            
                            child:TextFormField(  
                            decoration: const InputDecoration(  
                          
                              hintText: 'Enter your name',  
                              labelText: 'Email',  
                              
                            )
                          )
   
                          ),
                          const SizedBox(height: 30,),
                          SizedBox(
                            width: 250,
                            child:TextFormField(  
                            decoration: const InputDecoration(  
                          
                              hintText: 'Enter your password',  
                              labelText: 'Password',  
                              
                            )
                          )
                          ), 
                          const SizedBox(height: 60,),
                          SizedBox(
                            width: 250,
                            child:  Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Center(
                                  
                                  child: ElevatedButton(onPressed: (){}, style: ElevatedButton.styleFrom(
                                      backgroundColor: Color.fromARGB(255, 94, 91, 255),
                                      fixedSize: Size(170, 50),

                                  ), child: const Text("Login", style: TextStyle(
                                    fontSize: 20,
                                 
                                  ),),
                                  ),
                                )
                              ],
                         )
                          ),   
                          
                           
                        ], 

                      ), 
                       
                    )  
                    
                  ],
                  
                )
              ],
            ),

          ),
        ),
        
      
      

      ])
     
    )
   );
    
  }
}

class GradientText extends StatelessWidget {
  const GradientText(
    this.text, {super.key, 
    required this.gradient,
    this.style,
  });

  final String text;
  final TextStyle? style;
  final Gradient gradient;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => gradient.createShader(
        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
      ),
      child: Text(text, style: style),
    );
  }
}