import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cummins/screens/teachers/homescreen/teacherscreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as mat;

import '../../../firebase_options.dart';

class TeacherLogin extends StatefulWidget {
  TeacherLogin({Key? key}) : super(key: key);

  @override
  State<TeacherLogin> createState() => _LoginState();
}

String user = "";

class _LoginState extends State<TeacherLogin> {
  bool _obsure = true;
  String passwordText = "Show Password";
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              alignment: Alignment.bottomCenter,
              fit: BoxFit.cover,
              image: AssetImage("assets/teacherback.png"))),
      child: mat.Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            children: [
              FutureBuilder(
                future: Firebase.initializeApp(
                    options: DefaultFirebaseOptions.currentPlatform),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: ProgressRing(),
                    );
                  }
                  return Container(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Login",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 30),
                        ),
                        const Text(
                          "Login with your college Email ID and password.",
                          style: TextStyle(fontSize: 15),
                        ),
                        Container(
                          height: 50,
                        ),
                        Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          child: InfoLabel(
                            label: "Email",
                            child: TextBox(
                              controller: _emailController,
                              style: const TextStyle(fontSize: 15),
                              padding: const EdgeInsets.all(10),
                              suffix: const Padding(
                                  padding: EdgeInsets.all(5),
                                  child: Icon(
                                    mat.Icons.account_circle,
                                    size: 20,
                                  )),
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          child: InfoLabel(
                            label: "Password",
                            child: TextBox(
                              controller: _passwordController,
                              obscureText: _obsure,
                              style: const TextStyle(fontSize: 15),
                              padding: const EdgeInsets.all(10),
                              suffix: const Padding(
                                  padding: EdgeInsets.all(5),
                                  child: Icon(
                                    mat.Icons.remove_red_eye,
                                    size: 20,
                                  )),
                            ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            child: Text(
                              passwordText,
                              style: const TextStyle(
                                  fontWeight: FontWeight.normal),
                            ),
                            onPressed: () {
                              setState(() {
                                _obsure = !_obsure;
                              });
                              if (_obsure) {
                                setState(() {
                                  passwordText = "Show Password";
                                });
                              } else {
                                setState(() {
                                  passwordText = "Hide Password";
                                });
                              }
                            },
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          margin: const EdgeInsets.only(top: 50),
                          child: SizedBox(
                            width: 250,
                            height: 40,
                            child: Button(
                              style: ButtonStyle(
                                  backgroundColor:
                                      ButtonState.resolveWith<Color>(
                                          (states) => const Color(0xff206EC8))),
                              onPressed: () async {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return const Center(
                                        child: ProgressRing(),
                                      );
                                    });
                                final ref = FirebaseFirestore.instance
                                    .collection('teachers');
                                final query = await ref
                                    .where('email',
                                        isEqualTo: _emailController.text
                                            .replaceAll(" ", ""))
                                    .get();
                                for (var e in query.docs) {
                                  if (_emailController.text == e['email'] ||
                                      _passwordController.text ==
                                          e['password']) {
                                    setState(() {
                                      user = e.id;
                                    });
                                    // ignore: use_build_context_synchronously
                                    Navigator.push(
                                        context,
                                        FluentPageRoute(
                                            builder: (context) =>
                                                TeacherScreen()));
                                  } else {
                                    Navigator.pop(context);
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return const Center(
                                            child: Text("Invalid Credentials"),
                                          );
                                        });
                                  }
                                }
                              },
                              child: const Center(
                                  child: Text(
                                "Login",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 15),
                              )),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
