import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cummins/screens/events/eventDetails.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' as mat;
import 'package:fluent_ui/fluent_ui.dart';
import 'package:intl/intl.dart';

class TeacherEvents extends StatefulWidget {
  TeacherEvents({Key? key}) : super(key: key);

  @override
  State<TeacherEvents> createState() => _EventsState();
}

class _EventsState extends State<TeacherEvents> {
  final eventRef = FirebaseFirestore.instance.collection('events');
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
        stream: eventRef.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: ProgressRing());
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              return CupertinoContextMenu(
                actions: [
                  CupertinoContextMenuAction(
                      onPressed: () async {
                        await showDialog<String>(
                            builder: (context) => ContentDialog(
                                  title: const Text("Delete This Event ?"),
                                  content: const Text(
                                    "This action will remove the selected event",
                                  ),
                                  actions: [
                                    Button(
                                        child: const Text("Cancle"),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        }),
                                    FilledButton(
                                        style: ButtonStyle(
                                            backgroundColor:
                                                ButtonState.resolveWith(
                                                    (states) => Colors.red)),
                                        child: const Text("Delete"),
                                        onPressed: () {
                                          showDialog(
                                              context: context,
                                              builder: (context) {
                                                return const Center(
                                                  child: ProgressRing(),
                                                );
                                              });
                                          eventRef
                                              .doc(
                                                  snapshot.data!.docs[index].id)
                                              .delete()
                                              .then((value) {
                                            Navigator.pop(context);
                                            Navigator.pop(context);
                                            Navigator.pop(context);
                                          });
                                        })
                                  ],
                                ),
                            context: context);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Delete"),
                          Icon(
                            CupertinoIcons.delete_solid,
                            color: Colors.red,
                          ),
                        ],
                      )),
                  CupertinoContextMenuAction(
                      onPressed: () {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Edit"),
                          Icon(
                            CupertinoIcons.square_pencil_fill,
                            color: Colors.blue,
                          ),
                        ],
                      )),
                  CupertinoContextMenuAction(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text("Cancle"),
                          Icon(
                            CupertinoIcons.multiply_square_fill,
                            color: Colors.grey,
                          ),
                        ],
                      ))
                ],
                child: EventCard(
                  index: index,
                  snapshot: snapshot,
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class EventCard extends mat.StatelessWidget {
  AsyncSnapshot<QuerySnapshot> snapshot;
  int index;
  EventCard({
    required this.snapshot,
    required this.index,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(mat.BuildContext context) {
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
              image: NetworkImage(snapshot.data!.docs[index]['image_url']))),
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
                      shape: ButtonState.resolveWith<RoundedRectangleBorder>(
                          (states) => RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5))),
                      backgroundColor: ButtonState.resolveWith<Color>(
                          (states) => Colors.white.withOpacity(0.4))),
                  onPressed: () {
                    Navigator.push(
                        context,
                        FluentPageRoute(
                            builder: (context) => EventDetails(
                                title: snapshot.data!.docs[index]['title'],
                                date: snapshot.data!.docs[index]['date'],
                                description: snapshot.data!.docs[index]
                                    ['description'],
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
  }
}
