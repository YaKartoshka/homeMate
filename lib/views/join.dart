import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:home_mate/appLocalization';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_bcrypt/flutter_bcrypt.dart';

import '../control/localProvider.dart';

class Join extends StatefulWidget {
  const Join({super.key});

  @override
  State<Join> createState() => _JoinState();
}

class _JoinState extends State<Join> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _dashboardIdController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  var fcmToken = '';

  bool isLoading = false;

  void _joinDashboard() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final isValid = _formKey.currentState!.validate();
    if (!isValid || isLoading) {
      return;
    }

    setState(() {
      // new
      isLoading = true;
    });
    fcmToken = (await FirebaseMessaging.instance.getToken())!;
    final dashboardId = _dashboardIdController.text;
    final email = _emailController.text;
    final password = _passwordController.text;

    final languageCode = prefs.getString('language');

    final appTranslations = AppTranslations
        .translations['${languageCode}']!;
    final dashboardSnapshot =
        await _firestore.collection('dashboards').doc(dashboardId).get();
    if (!dashboardSnapshot.exists) {
      ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(
          content: Text(Intl.message(appTranslations['invalid_dashboard_id']!)),
        ),
      );

      setState(() {
        // new
        isLoading = false;
      });
      return;
    }

    try {
      final pass_salt = "\$2b\$06\$.KIqkgeXOwwL1kDqbN/SSO";

      final hashedPassword =
          await FlutterBcrypt.hashPw(password: password, salt: pass_salt);

      // Join dashboard and add user to members collection
      final userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: hashedPassword,
      );
      final user = userCredential.user!;
      final membersRef = _firestore
          .collection('dashboards')
          .doc(dashboardId)
          .collection('members');
      final idToken = await user.getIdToken();
      await membersRef.doc(user.uid).set({
        'email': email,
        'password': password,
        'userId': user.uid,
        'dashboard_id': dashboardId,
        'role': 'member',
        'fcmToken': fcmToken,
        'idToken': idToken,
        "password": hashedPassword,
        "salt": pass_salt
      });
      prefs.setString('dashboard_id', dashboardId);
      prefs.setString('userId', user.uid);
      prefs.setString('role', 'member');
      // Show success message and clear form
      ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(
          content: Text(Intl.message(appTranslations['joined_dashboard']!)),
        ),
      );
      _formKey.currentState!.reset();

      Navigator.pushReplacementNamed(context, '/main_view');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title:  Text(Intl.message(appTranslations['error']!)),
              content:  Text(Intl.message(appTranslations['already_exists']!)),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child:  Text(Intl.message(appTranslations['ok']!)),
                ),
              ],
            );
          },
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(
            content: Text(Intl.message(appTranslations['error']!)),
          ),
        );
      }
      setState(() {
        // new
        isLoading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(
          content: Text(Intl.message(appTranslations['error']!)),
        ),
      );
      setState(() {
        // new
        isLoading = false;
      });
    }
  }

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final ButtonStyle style =
        ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20));
           final localeProvider = Provider.of<LocaleProvider>(context);
    final currentLocale = localeProvider.locale;
    
    final appTranslations = AppTranslations
        .translations['${currentLocale}']!;
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
                           Text(
                            Intl.message(appTranslations['join']!),
                            style: TextStyle(
                              fontSize: 25,
                          
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
                                    controller: _dashboardIdController,
                                    decoration:  InputDecoration(
                                      hintText: Intl.message(appTranslations['enter_dashboard_id']!),
                                      labelText: Intl.message(appTranslations['dashboard_id']!),
                                    ),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return Intl.message(appTranslations['enter_dashboard_id']!);
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                SizedBox(
                                  width: 250,
                                  child: TextFormField(
                                    controller: _emailController,
                                    decoration:  InputDecoration(
                                      hintText: Intl.message(appTranslations['enter_your_email']!),
                                      labelText: Intl.message(appTranslations['email']!),
                                    ),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return Intl.message(appTranslations['enter_your_email']!);
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                SizedBox(
                                  width: 250,
                                  child: TextFormField(
                                    controller: _passwordController,
                                    decoration:  InputDecoration(
                                      hintText: Intl.message(appTranslations['enter_password']!),
                                      labelText: Intl.message(appTranslations['password']!),
                                    ),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return Intl.message(appTranslations['enter_password']!);
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                const SizedBox(
                                  height: 35,
                                ),
                                SizedBox(
                                    width: 250,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Center(
                                          child: isLoading
                                              ? const CircularProgressIndicator()
                                              : ElevatedButton(
                                                  onPressed: isLoading
                                                      ? null
                                                      : _joinDashboard,
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Color.fromARGB(
                                                            255, 94, 91, 255),
                                                    fixedSize: Size(170, 50),
                                                  ),
                                                  child:  Text(
                                                    Intl.message(appTranslations['join']!),
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                    ),
                                                  ),
                                                ),
                                        )
                                      ],
                                    )),
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
