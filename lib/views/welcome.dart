import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'dart:developer' as developer;
import 'package:intl/intl.dart';
import 'package:home_mate/appLocalization';
import 'package:provider/provider.dart';

import '../control/localProvider.dart';

class Welcome extends StatefulWidget {
  const Welcome({super.key});

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  FirebaseFirestore db = FirebaseFirestore.instance;

  static const colorizeColors = [
    Colors.white,
    Colors.purple,
    Color.fromARGB(255, 197, 75, 219),
    Colors.white
  ];

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);
    final currentLocale = localeProvider.locale;
    
    final appTranslations = AppTranslations
        .translations['${currentLocale}']!;
    final ButtonStyle style =
        ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20));
    return Scaffold(
        resizeToAvoidBottomInset: false,
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
                  colorFilter: ColorFilter.mode(
                      Color.fromARGB(255, 149, 152, 229), BlendMode.overlay)),
            ),
            child: Column(children: [
              const SizedBox(
                width: 0,
                height: 100,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                AnimatedTextKit(
                  isRepeatingAnimation: true,
                  repeatForever: true,
                  animatedTexts: [
                    ColorizeAnimatedText(
                      "Home Mate",
                      speed: const Duration(milliseconds: 700),
                      textStyle: const TextStyle(
                        fontSize: 60,
                        fontFamily: 'Poppins',
                        color: Colors.white,
                        shadows: <Shadow>[
                          Shadow(
                              offset: Offset(0, 10.0),
                              blurRadius: 10.0,
                              color: Color.fromARGB(70, 0, 0, 0)),
                        ],
                      ),
                      colors: colorizeColors,
                    ),
                  ],
                ),
              ]),
              GradientText(
                Intl.message(appTranslations['or']!),
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                    shadows: <Shadow>[
                      Shadow(
                          offset: Offset(0, 4.0),
                          blurRadius: 4.0,
                          color: Color.fromARGB(10, 0, 0, 0)),
                    ]),
                gradient: const LinearGradient(
                  colors: [
                    Color.fromARGB(200, 251, 23, 242),
                    Color.fromARGB(220, 248, 67, 239),
                    Color.fromARGB(255, 159, 147, 147),
                  ],
                  transform: GradientRotation(36),
                ),
              ),
              GradientText(
                  Intl.message(appTranslations['just_add_some_comfort']!),
                  style: const TextStyle(
                      fontSize: 20,
                 
                      shadows: <Shadow>[
                        Shadow(
                            offset: Offset(0, 4.0),
                            blurRadius: 4.0,
                            color: Color.fromARGB(10, 0, 0, 0)),
                      ]),
                  gradient: const LinearGradient(
                    colors: [
                      Color.fromARGB(199, 240, 6, 232),
                      Color.fromARGB(220, 244, 79, 208),
                      Color.fromARGB(255, 221, 25, 175),
                    ],
                    transform: GradientRotation(36),
                  )),
              const SizedBox(
                height: 50,
              ),
              ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/create_panel');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    fixedSize: const Size(270, 84),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  child: Text(
                    Intl.message(appTranslations['create_panel_in_welcome']!),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                      color: Color.fromARGB(255, 69, 5, 173),
                      shadows: <Shadow>[
                        Shadow(
                            offset: Offset(0, 10.0),
                            blurRadius: 10.0,
                            color: Color.fromARGB(70, 0, 0, 0)),
                      ],
                    ),
                  )),
              const SizedBox(
                height: 40,
              ),
              ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/join');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    fixedSize: const Size(270, 84),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  child: Text(
                    Intl.message(appTranslations['join_in_welcome']!),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                      color: Color.fromARGB(255, 69, 5, 173),
                      shadows: <Shadow>[
                        Shadow(
                            offset: Offset(0, 10.0),
                            blurRadius: 10.0,
                            color: Color.fromARGB(70, 0, 0, 0)),
                      ],
                    ),
                  )),
              const SizedBox(
                height: 25,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/login');
                },
                child: Text(
                  Intl.message(appTranslations['already_have_account']!),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
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
            ])));
  }
}

class GradientText extends StatelessWidget {
  const GradientText(
    this.text, {
    super.key,
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
