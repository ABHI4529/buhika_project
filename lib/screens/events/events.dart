import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cummins/screens/events/eventDetails.dart';
import 'package:flutter/material.dart' as mat;
import 'package:fluent_ui/fluent_ui.dart';
import 'package:intl/intl.dart';

class Events extends StatefulWidget {
  Events({Key? key}) : super(key: key);

  @override
  State<Events> createState() => _EventsState();
}

class _EventsState extends State<Events> {
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
          "Events",
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
              ))
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('events').snapshots(),
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
                    gradient: LinearGradient(colors: [
                      const Color(0xff35A4C8),
                      const Color(0xff4F62A2).withOpacity(0.2)
                    ]),
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(
                            snapshot.data!.docs[index]['image_url']))),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: LinearGradient(colors: [
                      const Color(0xff35A4C8),
                      const Color(0xff4F62A2).withOpacity(0.6)
                    ]),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        snapshot.data!.docs[index]['title'],
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 27),
                      ),
                      SizedBox(
                        width: 300,
                        child: Text(
                          snapshot.data!.docs[index]['subtitle'],
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 30),
                        child: SizedBox(
                          height: 35,
                          width: 135,
                          child: Button(
                            style: ButtonStyle(
                                shape: ButtonState.resolveWith<
                                        RoundedRectangleBorder>(
                                    (states) => RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(5))),
                                backgroundColor: ButtonState.resolveWith<Color>(
                                    (states) => Colors.white.withOpacity(0.4))),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  FluentPageRoute(
                                      builder: (context) => EventDetails(
                                          title: snapshot.data!.docs[index]
                                              ['title'],
                                          date: snapshot.data!.docs[index]
                                              ['date'],
                                          description: snapshot
                                              .data!.docs[index]['description'],
                                          subtitle: snapshot.data!.docs[index]
                                              ['subtitle'],
                                          imageurl: snapshot.data!.docs[index]
                                              ['image_url'])));
                            },
                            child: const Center(
                              child: Text(
                                "Read More",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
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
