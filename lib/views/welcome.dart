import 'package:flutter/material.dart';
import 'package:home_mate/views/createPanel.dart';
import 'package:home_mate/views/join.dart';
import 'package:home_mate/views/login.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
class Welcome extends StatefulWidget {
  const Welcome({super.key});

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  static const colorizeColors = [
  Colors.white,
  Colors.purple,
  Color.fromARGB(255, 197, 75, 219),
   Colors.white
];


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
        child: Column(
          children: [
            const SizedBox(
              width: 0,
              height: 100,
            ),
            Row(
              
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Text("HomeMate", style: TextStyle(
                //   fontSize: 60,
                //   fontFamily: 'Poppins',
                //   color: Colors.white,
                //   shadows: <Shadow>[
                //     Shadow(
                //       offset: Offset(0, 10.0),
                //       blurRadius: 10.0,
                //       color: Color.fromARGB(70, 0, 0, 0)
                //     ),
                  
                //   ],

                // ),
                // ),
                AnimatedTextKit(
                  isRepeatingAnimation: true,
                  repeatForever: true,
                  animatedTexts: [
                     ColorizeAnimatedText(
                      'Home Mate',
                      speed: const Duration(milliseconds:700 ),
                      textStyle:  const TextStyle(
                        fontSize: 60,
                        fontFamily: 'Poppins',
                        color: Colors.white,
                        shadows: <Shadow>[
                          Shadow(
                            offset: Offset(0, 10.0),
                            blurRadius: 10.0,
                            color: Color.fromARGB(70, 0, 0, 0)
                          ),
                        
                        ],
                        ),
                      colors: colorizeColors,
                    ),
                  ],
                ),
                              
              ]
            ),
           const GradientText("or",  style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'Poppins',
                  shadows: <Shadow>[
                     Shadow(
                      offset: Offset(0, 4.0),
                      blurRadius: 4.0,
                      color: Color.fromARGB(10, 0, 0, 0)
                    ),
                  ]
                ),  gradient: LinearGradient(colors: [
                  Color.fromARGB(200, 251, 23, 242),
                  Color.fromARGB(220, 248, 67, 239),
                  Color.fromARGB(255, 159, 147, 147),
                
                ], transform: GradientRotation(36),
                ),
    
          
        ),
          const GradientText("just add some comfort",  style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'Poppins',
                  shadows: <Shadow>[
                     Shadow(
                      offset: Offset(0, 4.0),
                      blurRadius: 4.0,
                      color: Color.fromARGB(10, 0, 0, 0)
                    ),
                  ]
                ),  gradient: LinearGradient(colors: [
                  Color.fromARGB(200, 251, 23, 242),
                  Color.fromARGB(220, 253, 112, 247),
                  Color.fromARGB(255, 148, 81, 132),
                
                ], transform: GradientRotation(36),
                )
    
          
        ),
        const SizedBox(
          height: 50,
        ),
      ElevatedButton( onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context) => const CreatePanel()),); },
        style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        fixedSize: const Size(270, 84),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        
      ),
        child: const Text("CREATE A PANEL", style: TextStyle(
          fontSize: 20,
          fontFamily: 'Poppins',
          color: Color.fromARGB(255, 69, 5, 173),
          shadows: <Shadow>[
            Shadow(
              offset: Offset(0, 10.0),
              blurRadius: 10.0,
              color: Color.fromARGB(70, 0, 0, 0)
            ),
          
          ],
        ),
      )),
      const SizedBox(
        height: 40,
      ),
      ElevatedButton( onPressed: () {Navigator.push(context, MaterialPageRoute(builder:(context) => const Join()),);}, style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        fixedSize: const Size(270, 84),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        
      ),
        child: const Text("JOIN", style: TextStyle(
          fontSize: 20,
          fontFamily: 'Poppins',
          color: Color.fromARGB(255, 69, 5, 173),
          shadows: <Shadow>[
            Shadow(
              offset: Offset(0, 10.0),
              blurRadius: 10.0,
              color: Color.fromARGB(70, 0, 0, 0)
            ),
          
          ],
        ),
      )),
      SizedBox(height: 25,),
      
      GestureDetector(
      onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Login()),
    );
  },
  child: const Text(
    'Already have an account?',
    style: TextStyle(
      fontSize: 16,
      fontFamily: 'Poppins',
      color: Color.fromARGB(255, 69, 5, 173),
      shadows: <Shadow>[
        Shadow(
          offset: Offset(0, 10.0),
          blurRadius: 10.0,
          color: Color.fromARGB(70, 0, 0, 0),
        ),
      ],
    ),
  ),
)

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