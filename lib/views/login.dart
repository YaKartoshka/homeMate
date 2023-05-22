import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:home_mate/views/welcome.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'notifications.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return const Notifications();
        } else {
          return const Welcome();
        }
      },
    );
  }
}

class _LoginState extends State<Login> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  FirebaseFirestore db = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
  clientId: '184211977144-bebfudln36n5f5d8bpu56gtprpemolnp.apps.googleusercontent.com',
  scopes: ['email'],
);
 bool isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
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
              const SizedBox(
                width: 0,
                height: 30,
              ),
              const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text(
                  "HomeMate",
                  style: TextStyle(
                    fontSize: 45,
                    fontFamily: 'Poppins',
                    color: Colors.white,
                    shadows: <Shadow>[
                      Shadow(
                          offset: Offset(0, 10.0),
                          blurRadius: 10.0,
                          color: Color.fromARGB(70, 0, 0, 0)),
                    ],
                  ),
                ),
              ]),
              Center(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  margin: const EdgeInsets.all(50),
                  width: 320,
                  height: 400,
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Login",
                            style: TextStyle(
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
                                const SizedBox(
                                  height: 25,
                                ),
                                SizedBox(
                                    width: 250,
                                    child: TextFormField(
                                        controller: emailController,
                                        decoration: const InputDecoration(
                                          hintText: 'Enter your email',
                                          labelText: 'Email',
                                        ))),
                                const SizedBox(
                                  height: 30,
                                ),
                                SizedBox(
                                    width: 250,
                                    child: TextFormField(
                                        controller: passwordController,
                                        decoration: const InputDecoration(
                                          hintText: 'Enter your password',
                                          labelText: 'Password',
                                        ))),
                                const SizedBox(
                                  height: 10,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, '/reset_password');
                                  },
                                  child: const Text(
                                    'Forget a password?',
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
                                ),
                                const SizedBox(
                                  height: 60,
                                ),
                                SizedBox(
                                    width: 250,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Center(
                                          child: isLoading ? const CircularProgressIndicator() : ElevatedButton(
                                            onPressed: isLoading ? null : signIn,
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  const Color.fromARGB(
                                                      255, 94, 91, 255),
                                              fixedSize: const Size(170, 50),
                                            ),
                                            child: const Text(
                                              "Login",
                                              style: TextStyle(
                                                fontSize: 20,
                                              ),
                                            ),
                                          ),
                                        ),
                                       
                                      ],
                                    )),
                                    //  ElevatedButton(
                                    //     onPressed: signInWithGoogle,
                                    //     child: Text('Sign in with Google'),
                                    //   ),
                              ],
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ])));
  }

// Future<UserCredential?> signInWithGoogle() async {
//     // Trigger the Google authentication flow
//     final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

//     if (googleUser != null) {
//       // Obtain the Google authentication details
//       final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

//       // Create a new credential with the Google ID token and access token
//       final OAuthCredential credential = GoogleAuthProvider.credential(
//         accessToken: googleAuth.accessToken,
//         idToken: googleAuth.idToken,
//       );

//       // Sign in to Firebase with the Google credentials
//       try {
//         final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
//         return userCredential;
//       } catch (e) {
//         print('Error signing in with Google: $e');
//         return null;
//       }
//     }

//     return null;
//   }

  void signIn() async {
  setState(() {
      isLoading = true;
    });

    try {
      await Firebase.initializeApp();
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      User? user = userCredential.user;
      if (user != null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
      var dashboards=db.collection('dashboards').get().then((querySnapshot) {
        for(var doc in querySnapshot.docs){
          db.collection("dashboards").doc(doc.id).collection('members').where("email", isEqualTo: emailController.text.trim()).get().then((memberQuerySnapshot){
          for (var memberDocSnapshot in memberQuerySnapshot.docs) {
            prefs.setString('dashboard_id', memberDocSnapshot.data()['dashboard_id']);
            prefs.setString('userId', memberDocSnapshot.data()['userId']);
            prefs.setString('role', memberDocSnapshot.data()['role']);
            Navigator.pushReplacementNamed(context, '/main_view');
          }
          }
          );
        }
      }
      
      
      );
    


        // db
        //     .collection("dashboards")
        //     .where("email", isEqualTo: emailController.text)
        //     .get()
        //     .then((querySnapshot) {
        //   for (var docSnapshot in querySnapshot.docs) {
        //     prefs.setString('dashboard_id', docSnapshot.id);
        //     Navigator.pushReplacementNamed(context, '/main_view');
        //   }
        // }, onError: (e) => Navigator.pop(context));
        
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return const AlertDialog(
                  title: Text('Basic dialog title'),
                  content: Text('No user found for that email.'));
            });
      } else if (e.code == 'wrong-password') {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return const AlertDialog(
                  title: Text('Basic dialog title'),
                  content: Text('Wrong password provided for that user'));
            });
      }
    } finally {
      setState(() {
        isLoading = false;
      });
      setState(() {});
    }
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
