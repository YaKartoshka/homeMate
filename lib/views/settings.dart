import 'package:flutter/material.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  final dashboard_id_input = TextEditingController();
  final dashboard_name_input = TextEditingController();
  bool theme = true;
  @override
  void initState() {
    dashboard_id_input.text = "test_id";
    dashboard_name_input.text = "test_name";
    super.initState();
  }

  void resetDashboardId() {}

  void saveSettings() {}
  Widget build(BuildContext context) {
    final adaptiveSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 149, 152, 229),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(MediaQuery.of(context).padding.top),
        child: SizedBox(
          height: MediaQuery.of(context).padding.top,
        ),
      ),
      body: Container(
        child: Column(
          children: [
            SizedBox(height: 15),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: Text(
                    "Settings",
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 30,
                        color: Colors.white),
                  ),
                )
              ],
            ),
            const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                  color: Colors.red, borderRadius: BorderRadius.circular(30)),
              width: adaptiveSize.width - 50,
              height: adaptiveSize.height - 200,
              child: ListView(
                children: [
                  Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: Colors.black, width: 2),
                        
                          ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                        child: Column(children: [
                          const Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                                child: Text(
                                  "Dashboard",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 20),
                          Form(
                              child: Column(
                            children: [
                              Row(
                                children: [
                                  Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 16),
                                      child: SizedBox(
                                        width: adaptiveSize.width - 200,
                                        child: TextFormField(
                                          controller: dashboard_id_input,
                                          readOnly: true,
                                          decoration: const InputDecoration(
                                              border: OutlineInputBorder(),
                                              labelText: 'Dashboard ID',
                                              labelStyle:
                                                  TextStyle(fontSize: 15)),
                                        ),
                                      )),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                                    child: IconButton(
                                        onPressed: resetDashboardId,
                                        icon: const Icon(
                                          Icons.sync,
                                          size: 30,
                                        )),
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 16),
                                      child: SizedBox(
                                        width: adaptiveSize.width - 200,
                                        child: TextFormField(
                                          controller: dashboard_name_input,
                                          readOnly: true,
                                          decoration: const InputDecoration(
                                            border: OutlineInputBorder(),
                                            labelText: 'Dashboard Name',
                                          ),
                                        ),
                                      )),
                                ],
                              ),
                              Row(
                                children: [
                                  Switch(
                                    // This bool value toggles the switch.
                                    value: theme,
                                    activeColor: Colors.purple,
                                    inactiveThumbColor: Colors.black,
                                    onChanged: (bool value) {
                                      // This is called when the user toggles the switch.
                                      setState(() {
                                        theme = value;
                                      });
                                    },
                                  ),
                                  const Text(
                                    "Dark Theme",
                                    style: TextStyle(
                                        fontSize: 20, fontFamily: 'Poppins'),
                                  )
                                ],
                              ),
                              const Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(10, 10, 0, 10),
                                    child: Text(
                                      "Users",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500),
                                    )
                                  )
                                ]
                              ),
                              Row(
                                children: [
                                  Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 16),
                                      child: SizedBox(
                                        width: adaptiveSize.width - 200,
                                        child: TextFormField(
                                          controller: dashboard_id_input,
                                          readOnly: true,
                                          decoration: const InputDecoration(
                                              border: OutlineInputBorder(),
                                              labelText: 'User Name',
                                              labelStyle:
                                                  TextStyle(fontSize: 15)),
                                        ),
                                      )),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                                    child: IconButton(
                                        onPressed: resetDashboardId,
                                        icon: const Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                          size: 30,
                                        )),
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 16),
                                      child: SizedBox(
                                        width: adaptiveSize.width - 200,
                                        child: TextFormField(
                                          controller: dashboard_id_input,
                                          readOnly: true,
                                          decoration: const InputDecoration(
                                              border: OutlineInputBorder(),
                                              labelText: 'User Name',
                                              labelStyle:
                                                  TextStyle(fontSize: 15)),
                                        ),
                                      )),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                                    child: IconButton(
                                        onPressed: resetDashboardId,
                                        icon: const Icon(
                                          Icons.delete,
                                          size: 30,
                                          color: Colors.red,
                                        )),
                                  )
                                ],
                              ),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              const Color.fromARGB(255, 104, 57, 223),
                                          fixedSize: const Size(200, 50)),
                                      onPressed: saveSettings,
                                      child: const Text(
                                        "Save",
                                        style: TextStyle(
                                            fontSize: 24,
                                            fontFamily: 'Poppins'),
                                      ))
                                ],
                              ),
                              const SizedBox(height: 20)
                            ],
                          ))
                        ]),
                      ))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
