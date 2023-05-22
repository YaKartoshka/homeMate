import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreatePanel extends StatefulWidget {
  const CreatePanel({super.key});

  @override
  State<CreatePanel> createState() => _JoinState();
}

class _JoinState extends State<CreatePanel> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  final _dashboard_name_field = TextEditingController();
  final _email_field = TextEditingController();
  final _password_field = TextEditingController();
  final _repeated_password_field = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isLoading = false;

  void createPanel() async {
    if (isLoading) return;
    setState(() {
      isLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String dashboard_name = _dashboard_name_field.text.trim();
    final String email = _email_field.text.trim();
    final String password = _password_field.text.trim();
    final String repeatedPassword = _repeated_password_field.text.trim();

    // Check if passwords match
    if (password != repeatedPassword) {
      _showErrorDialog("Passwords don't match",
          "Please make sure both passwords are the same.");
      setState(() {
        isLoading = false;
      });
      return;
    }

    // Validate email format
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email)) {
      _showErrorDialog("Invalid email", "Please enter a valid email address.");
      setState(() {
        isLoading = false;
      });
      return;
    }

    // Send email verification

    setState(() {
      isLoading =
          true; // Add this variable to the state class to track loading state
    });

    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
     
      final user = userCredential.user!;
      var dashboardsCollection = db.collection("dashboards");
      var created_dashboard= await dashboardsCollection.doc();
      final data = {"dashboard_name": '$dashboard_name', "email": '$email', "dashboard_id": created_dashboard.id};
      await created_dashboard.set(data);
      var created_user= await dashboardsCollection.doc(created_dashboard.id).collection("members").doc();
      final userData = {"userId": user.uid, "email": email, "role": "admin", "dashboard_id": created_dashboard.id };
      await dashboardsCollection.doc(created_dashboard.id).collection("members").add(userData);
      
      setState(() {
        isLoading = false;
      });
      prefs.setString(
        'dashboard_id', created_dashboard.id
      );
      prefs.setString('userId', user.uid);
      prefs.setString('role', 'admin');
      Navigator.pushNamed(context, '/main_view');
    } on FirebaseAuthException catch (e) {
      setState(() {
        isLoading = false;
      });

      if (e.code == 'weak-password') {
        _showErrorDialog("Weak password",
            "The password provided is too weak. Please choose a stronger password and try again.");
      } else if (e.code == 'email-already-in-use') {
        _showErrorDialog("Account already exists",
            "An account already exists for $email. Please sign in or use a different email address.");
      } else {
        _showErrorDialog("Error", "An error occurred: ${e.toString()}");
      }
    } catch (e) {
      _showErrorDialog("Error", "An error occurred: ${e.toString()}");
    }

    // Save data to Firestore
  }

  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showSuccessDialog(String title, String message, String routeName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                // Navigate to notifications page
                Navigator.pushNamed(context, '/login');
              },
            ),
          ],
        );
      },
    );
  }

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
                height: 15,
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
                  margin: const EdgeInsets.all(10),
                  width: 320,
                  height: 490,
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Create a panel",
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
                                        controller: _dashboard_name_field,
                                        decoration: const InputDecoration(
                                          hintText: 'Enter your Dashboard Name',
                                          labelText: 'Dashboard Name',
                                        ))),
                                const SizedBox(
                                  height: 10,
                                ),
                                SizedBox(
                                    width: 250,
                                    child: TextFormField(
                                        controller: _email_field,
                                        decoration: const InputDecoration(
                                          hintText: 'Enter your email',
                                          labelText: 'Email',
                                        ))),
                                const SizedBox(
                                  height: 10,
                                ),
                                SizedBox(
                                    width: 250,
                                    child: TextFormField(
                                        controller: _password_field,
                                        decoration: const InputDecoration(
                                          hintText: 'Enter your password',
                                          labelText: 'Password',
                                        ))),
                                const SizedBox(
                                  height: 25,
                                ),
                                SizedBox(
                                    width: 250,
                                    child: TextFormField(
                                        controller: _repeated_password_field,
                                        decoration: const InputDecoration(
                                          hintText: 'Enter your password',
                                          labelText: 'Repeat a password',
                                        ))),
                                const SizedBox(
                                  height: 45,
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
                                                      : createPanel,
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        const Color.fromARGB(
                                                            255, 94, 91, 255),
                                                    fixedSize:
                                                        const Size(170, 50),
                                                  ),
                                                  child: const Text(
                                                    "Create",
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
