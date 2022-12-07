import 'package:cummins/screens/feedback/feedback.dart';
import 'package:cummins/screens/notification/notification.dart';
import 'package:cummins/screens/teachers/addevents/addevent.dart';
import 'package:cummins/screens/teachers/attendence/attendence.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as mat;
import 'package:intl/intl.dart';

import '../addnotifications/addnotifications.dart';

class TeacherScreen extends StatefulWidget {
  TeacherScreen({Key? key}) : super(key: key);

  @override
  State<TeacherScreen> createState() => _HomeState();
}

class _HomeState extends State<TeacherScreen> {
  DateFormat dateFormat = DateFormat("dd of MMMM yyyy");
  final _date = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return mat.Scaffold(
      appBar: mat.AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Home",
          style: TextStyle(
              color: Color(0xff474747),
              fontSize: 30,
              fontWeight: FontWeight.bold),
        ),
        actions: [
          Container(
            alignment: Alignment.bottomCenter,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
            child: Text(
              dateFormat.format(_date),
              style: const TextStyle(color: Color(0xff474747)),
            ),
          )
        ],
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(context,
                    FluentPageRoute(builder: (context) => Attendence()));
              },
              child: CButton(
                padding: 20,
                label: "Register",
                subtitle: "Mark student's present / absent register",
                image: Image.asset("assets/register.png"),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context, FluentPageRoute(builder: (context) => AddEvent()));
              },
              child: CButton(
                padding: 0,
                label: "Events",
                subtitle: "Get a brief information about all the events",
                image: Image.asset("assets/events.png"),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(context,
                    FluentPageRoute(builder: (context) => AddNotification()));
              },
              child: CButton(
                padding: 0,
                label: "Notifications",
                subtitle: "Get all of your notifications in one place",
                image: Image.asset("assets/notification.png"),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class CButton extends StatelessWidget {
  final String? label;
  final Image? image;
  double padding = 0;
  final String? subtitle;
  CButton(
      {Key? key, required this.padding, this.label, this.subtitle, this.image})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      height: 140,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: const LinearGradient(
              colors: [Color(0xff35A4C8), Color(0xff4F62A2)])),
      child: Row(
        children: [
          Expanded(
              child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "$label",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 23),
                ),
                Text(
                  "$subtitle",
                  style: TextStyle(color: Colors.white, fontSize: 13),
                )
              ],
            ),
          )),
          Container(
            margin: const EdgeInsets.only(right: 5),
            padding: EdgeInsets.all(padding),
            child: image,
          )
        ],
      ),
    );
  }
}
