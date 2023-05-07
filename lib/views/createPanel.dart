import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:home_mate/views/notifications.dart';
import 'package:home_mate/views/welcome.dart';

class CreatePanel extends StatefulWidget {
  const CreatePanel({super.key});

  @override
  State<CreatePanel> createState() => _JoinState();
}

class _JoinState extends State<CreatePanel> {
  FirebaseFirestore db=FirebaseFirestore.instance;
  final _dashboard_id_field = TextEditingController();
  final _email_field = TextEditingController();
  final _password_field = TextEditingController();
  final _repeated_password_field = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void createPanel(){
     String dashboard_id = _dashboard_id_field.text;
     String email = _email_field.text;
     String password = _password_field.text;

   
    final data = {"dashboard_id": '${dashboard_id}', "email": '${email}',"password":'${password}'};

    db.collection("dashboards").add(data).then((documentSnapshot) =>
        print("Added Data with ID: ${documentSnapshot.id}"));
          
           
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
                                      controller: _dashboard_id_field,
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
                                          child: ElevatedButton(
                                            onPressed: () {
                                              createPanel();
                                               Navigator.pushNamed(context, '/notifications');
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  const Color.fromARGB(
                                                      255, 94, 91, 255),
                                              fixedSize: const Size(170, 50),
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
