import 'package:cummins/firebase_options.dart';
import 'package:cummins/screens/admin/adminregister/adminregister.dart';
import 'package:cummins/screens/admin/adminstudents.dart';
import 'package:cummins/screens/admin/adminteachers.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' as mat;
import 'package:fluent_ui/fluent_ui.dart';
import 'package:intl/intl.dart';

import 'adminfeedback/adminfeedback.dart';

class Admin extends StatefulWidget {
  Admin({Key? key}) : super(key: key);

  @override
  State<Admin> createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  DateFormat dateFormat = DateFormat("dd of MMMM yyyy");
  final _date = DateTime.now();
  int _navIndex = 2;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Firebase.initializeApp(options: DefaultFirebaseOptions.web),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: ProgressRing());
          }
          return NavigationView(
            pane: NavigationPane(
                selected: _navIndex,
                onChanged: (value) {
                  setState(() {
                    _navIndex = value;
                  });
                },
                items: [
                  PaneItem(
                      icon: const Icon(FluentIcons.home),
                      title: const Text("Home"), body: AdminHome()),
                  PaneItem(
                      icon: const Icon(FluentIcons.people),
                      title: const Text("Students"),
                      body: AdminStudents()
                  ),
                  PaneItem(
                    icon: const Icon(FluentIcons.feedback),
                    title: const Text("Feedback"),
                    body: AdminFeedback()
                  ),
                  PaneItem(
                      icon: const Icon(FluentIcons.action_center),
                      title: const Text("Teachers"),
                      body: AdminTeachers()
                  ),
                  PaneItem(
                      icon: const Icon(FluentIcons.registry_editor),
                      title: const Text("Register"),
                      body: AdminRegister()
                  ),
                ]),

            appBar: const NavigationAppBar(
                title: Center(
              child: Text(
                "Cummins College of Engineering",
                style: TextStyle(fontSize: 20),
              ),
            )),
          );
        });
  }
}

class AdminHome extends StatefulWidget {
  AdminHome({Key? key}) : super(key: key);

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  @override
  Widget build(BuildContext context) {
    return const ScaffoldPage(
      header: PageHeader(
        title: Text("Home"),
      ),
    );
  }
}
