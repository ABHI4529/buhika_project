import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cummins/dataModals/notificationmodel.dart';
import 'package:cummins/main.dart';
import 'package:flutter/material.dart' as mat;
import 'package:fluent_ui/fluent_ui.dart';
import 'package:intl/intl.dart';

class Notifications extends StatefulWidget {
  Notifications({Key? key}) : super(key: key);

  @override
  State<Notifications> createState() => _NotificationState();
}

class _NotificationState extends State<Notifications> {
  DateFormat dateFormat = DateFormat("dd of MMMM yyyy");
  final _date = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return mat.Scaffold(
      backgroundColor: Colors.white,
      appBar: mat.AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Notifications",
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
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('students')
            .doc(user)
            .collection('notifications')
            .where('read', isEqualTo: false)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: ProgressRing());
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: const LinearGradient(
                        colors: [Color(0xff35A4C8), Color(0xff4F62A2)])),
                child: Expander(
                  headerHeight: 100,
                  contentBackgroundColor: Colors.transparent,
                  headerBackgroundColor: ButtonState.resolveWith<Color>(
                      (states) => Colors.transparent),
                  header: Container(
                    padding: const EdgeInsets.only(top: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          snapshot.data!.docs[index]['title'],
                          style: const TextStyle(
                              fontSize: 23,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          snapshot.data!.docs[index]['subtitle'],
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        )
                      ],
                    ),
                  ),
                  content: Container(
                    alignment: Alignment.centerRight,
                    child: SizedBox(
                      width: 130,
                      child: Button(
                        style: ButtonStyle(
                            backgroundColor: ButtonState.resolveWith<Color>(
                                (states) => Colors.white.withOpacity(0.3))),
                        onPressed: () async {
                          await showDialog<String>(
                              builder: (context) => ContentDialog(
                                    title: const Text("Mark as read ?"),
                                    content: const Text(
                                      "This action will remove the notification and mark it as read",
                                    ),
                                    actions: [
                                      Button(
                                          child: const Text("Cancle"),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          }),
                                      FilledButton(
                                          child: const Text("Read"),
                                          onPressed: () {
                                            final ref = FirebaseFirestore
                                                .instance
                                                .collection('students')
                                                .doc(user)
                                                .collection('notifications');
                                            ref
                                                .doc(snapshot
                                                    .data!.docs[index].id)
                                                .update({'read': true}).then(
                                                    (value) =>
                                                        Navigator.pop(context));
                                          })
                                    ],
                                  ),
                              context: context);
                        },
                        child: const Text(
                          "Mark as read",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
