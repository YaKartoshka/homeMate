import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bcrypt/flutter_bcrypt.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
  GoogleSignInAccount? _currentUser;
  bool _isAuthorized = false; // has granted permissions?
  String _contactText = '';
//   final GoogleSignIn _googleSignIn = GoogleSignIn(
//   serverClientId: '963528077159-5rntvf2c7b8sftdd7pu6he57mvsp4oid.apps.googleusercontent.com',
//   scopes: ['email'],
// );
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final adaptiveSize = MediaQuery.of(context).size;
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
                height: 20,
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
                  margin: const EdgeInsets.fromLTRB(50, 20, 50, 50),
                  width: adaptiveSize.width-50,
                  height: adaptiveSize.height/2 + 120,
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
                                  height: 30,
                                ),
                                SizedBox(
                                    width: adaptiveSize.width-150,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Center(
                                          child: isLoading
                                              ? const CircularProgressIndicator()
                                              : ElevatedButton(
                                                  onPressed:
                                                      isLoading ? null : signIn,
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        const Color.fromARGB(
                                                            255, 94, 91, 255),
                                                    fixedSize:
                                                        const Size(170, 50),
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
                                    Container(
                                      margin: EdgeInsets.only(top: 10),
                                      width: 250,
                                      child: Center(child: Text("or"),)
                                    ),
                                Container(
                                    margin: EdgeInsets.only(top: 10),
                                    width: 250,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Center(
                                          child: isLoading
                                              ? const CircularProgressIndicator()
                                              : ElevatedButton(
                                                  onPressed: () {
                                                    _handleGoogleSignIn();
                                                  },
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                          backgroundColor:
                                                              Color.fromARGB(
                                                                  255,
                                                                  94,
                                                                  91,
                                                                  255)),
                                                  child: Icon(
                                                      FontAwesomeIcons.google),
                                                ),
                                        ),
                                        SizedBox(height: 10),
                                        Center(
                                          child: isLoading
                                              ? const CircularProgressIndicator()
                                              : ElevatedButton(
                                                  onPressed: () {
                                                    signInWithGitHub();
                                                  },
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                          backgroundColor:
                                                              Color.fromARGB(
                                                                  255,
                                                                  94,
                                                                  91,
                                                                  255)),
                                                  child: Icon(
                                                      FontAwesomeIcons.github),
                                                ),
                                        ),
                                        SizedBox(height: 10),
                                        Center(
                                          child: isLoading
                                              ? const CircularProgressIndicator()
                                              : ElevatedButton(
                                                  onPressed: () {
                                                    signInWithMicrosoft();
                                                  },
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                          backgroundColor:
                                                              Color.fromARGB(
                                                                  255,
                                                                  94,
                                                                  91,
                                                                  255)),
                                                  child: Icon(FontAwesomeIcons
                                                      .microsoft),
                                                ),
                                        ),
                                      ],
                                    )),
                                Container(
                                  width: 250,
                                  child: Center(
                                    child: isLoading
                                        ? const CircularProgressIndicator()
                                        : ElevatedButton(
                                            onPressed: () {
                                              guestmode();
                                            },
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor: Color.fromARGB(
                                                    255, 94, 91, 255)),
                                            child: Text("Guest"),
                                          ),
                                  ),
                                )
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

  Future<UserCredential?> _handleGoogleSignIn() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      final User? user = userCredential.user;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (user != null) {
        // User is signed in
        db.collection('dashboards').get().then((querySnapshot) {
          for (var doc in querySnapshot.docs) {
            db
                .collection("dashboards")
                .doc(doc.id)
                .collection('members')
                .where("email", isEqualTo: user.email)
                .get()
                .then((memberQuerySnapshot) {
              for (var memberDocSnapshot in memberQuerySnapshot.docs) {
                if (memberDocSnapshot.exists) {
                  prefs.setString(
                      'dashboard_id', memberDocSnapshot.data()['dashboard_id']);
                  prefs.setString('userId', memberDocSnapshot.data()['userId']);
                  prefs.setString('role', memberDocSnapshot.data()['role']);
                  Navigator.pushReplacementNamed(context, '/main_view');
                } else {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return const AlertDialog(
                            title: Text('Not found'),
                            content: Text('No user found for that email.'));
                      });
                }
              }
            });
          }
        });
      }
    } catch (e) {
      log('Error signing in with Google: $e');
    }

    return null;
  }

  void guestmode() async {
    setState(() {
      isLoading = true;
    });
    final guest_email = "guest";
    await Firebase.initializeApp();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var dashboards = db.collection('dashboards').get().then((querySnapshot) {
      for (var doc in querySnapshot.docs) {
        db
            .collection("dashboards")
            .doc(doc.id)
            .collection('members')
            .where("email", isEqualTo: guest_email)
            .get()
            .then((memberQuerySnapshot) {
          for (var memberDocSnapshot in memberQuerySnapshot.docs) {
            prefs.setString(
                'dashboard_id', memberDocSnapshot.data()['dashboard_id']);
            prefs.setString('userId', memberDocSnapshot.data()['userId']);
            prefs.setString('role', memberDocSnapshot.data()['role']);
            Navigator.pushReplacementNamed(context, '/main_view');
          }
        });
      }
    });
  }

  void signInWithGitHub() async {
    try {
      GithubAuthProvider githubProvider = GithubAuthProvider();
      final res =
          await FirebaseAuth.instance.signInWithProvider(githubProvider);
      final user = res.user!.providerData[0];
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (user.email != null) {
        db.collection('dashboards').get().then((querySnapshot) {
          for (var doc in querySnapshot.docs) {
            db
                .collection("dashboards")
                .doc(doc.id)
                .collection('members')
                .where("email", isEqualTo: user.email)
                .get()
                .then((memberQuerySnapshot) {
              for (var memberDocSnapshot in memberQuerySnapshot.docs) {
                if (memberDocSnapshot.exists) {
                  prefs.setString(
                      'dashboard_id', memberDocSnapshot.data()['dashboard_id']);
                  prefs.setString('userId', memberDocSnapshot.data()['userId']);
                  prefs.setString('role', memberDocSnapshot.data()['role']);
                  Navigator.pushReplacementNamed(context, '/main_view');
                } else {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return const AlertDialog(
                            title: Text('Not found'),
                            content: Text('No user found for that email.'));
                      });
                }
              }
            });
          }
        });
      }
    } catch (e) {
      log('Error signing in with Github: $e');
    }
  }

  void signInWithMicrosoft() async {
    try {
      MicrosoftAuthProvider microsoftProvider = MicrosoftAuthProvider();    
      final res =
          await FirebaseAuth.instance.signInWithProvider(microsoftProvider);
      final user = res.user!.providerData[0];
      SharedPreferences prefs = await SharedPreferences.getInstance();
      log('${user}');
      if (user.email != null) {
        db.collection('dashboards').get().then((querySnapshot) {
          for (var doc in querySnapshot.docs) {
            db
                .collection("dashboards")
                .doc(doc.id)
                .collection('members')
                .where("email", isEqualTo: user.email)
                .get()
                .then((memberQuerySnapshot) {
              for (var memberDocSnapshot in memberQuerySnapshot.docs) {
                if (memberDocSnapshot.exists) {
                  prefs.setString(
                      'dashboard_id', memberDocSnapshot.data()['dashboard_id']);
                  prefs.setString('userId', memberDocSnapshot.data()['userId']);
                  prefs.setString('role', memberDocSnapshot.data()['role']);
                  Navigator.pushReplacementNamed(context, '/main_view');
                } else {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return const AlertDialog(
                            title: Text('Not found'),
                            content: Text('No user found for that email.'));
                      });
                }
              }
            });
          }
        });
      }
    } catch (e) {
      log('Error signing in with Microsoft: $e');
    }
  }

  void signIn() async {
    setState(() {
      isLoading = true;
    });

    try {
      await Firebase.initializeApp();
      final pass_salt = await FlutterBcrypt.salt();
      final hash_pass = await FlutterBcrypt.hashPw(
          password: passwordController.text.trim(), salt: pass_salt);
      log(hash_pass);
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: hash_pass,
      );
      User? user = userCredential.user;

      if (user != null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        var dashboards =
            db.collection('dashboards').get().then((querySnapshot) {
          for (var doc in querySnapshot.docs) {
            db
                .collection("dashboards")
                .doc(doc.id)
                .collection('members')
                .where("email", isEqualTo: emailController.text.trim())
                .get()
                .then((memberQuerySnapshot) {
              for (var memberDocSnapshot in memberQuerySnapshot.docs) {
                prefs.setString(
                    'dashboard_id', memberDocSnapshot.data()['dashboard_id']);
                prefs.setString('userId', memberDocSnapshot.data()['userId']);
                prefs.setString('role', memberDocSnapshot.data()['role']);
                Navigator.pushReplacementNamed(context, '/main_view');
              }
            });
          }
        });
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return const AlertDialog(
                  title: Text('Not found'),
                  content: Text('No user found for that email.'));
            });
      } else if (e.code == 'wrong-password') {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return const AlertDialog(
                  title: Text('Wrong'),
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
