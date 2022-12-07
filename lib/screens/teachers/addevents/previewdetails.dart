import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart' as mat;
import 'package:fluent_ui/fluent_ui.dart';
import 'package:intl/intl.dart';

class PreviewEventDetails extends StatefulWidget {
  final String title;
  final String subtitle;
  final DateTime date;
  final String description;
  final File imageurl;
  PreviewEventDetails(
      {Key? key,
      required this.title,
      required this.date,
      required this.description,
      required this.subtitle,
      required this.imageurl})
      : super(key: key);

  @override
  State<PreviewEventDetails> createState() => _EventDetailsState();
}

class _EventDetailsState extends State<PreviewEventDetails> {
  DateTime _date = DateTime.now();
  DateFormat dateformat = DateFormat("dd of MMMM yyyy");
  @override
  void initState() {
    setState(() {
      _date = widget.date;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.cover, image: FileImage(widget.imageurl))),
      child: mat.Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                const Color(0xff4F62A2),
                const Color(0xff4F62A2).withOpacity(0.8),
                const Color(0xff35A4C8).withOpacity(0.6),
              ]),
        ),
        child: mat.Scaffold(
          backgroundColor: Colors.transparent,
          appBar: mat.AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Text(
              widget.title,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold),
            ),
            actions: [
              Container(
                alignment: Alignment.bottomCenter,
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                child: Text(dateformat.format(_date),
                    style: const TextStyle(color: Colors.white)),
              )
            ],
          ),
          body: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.subtitle,
                    style: const TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 30),
                    child: Text(widget.description,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 14)),
                  )
                ],
              ),
            ),
          ),
          bottomNavigationBar: mat.BottomAppBar(
            child: SizedBox(
              height: 60,
              child: Row(
                children: [
                  Expanded(
                    child: Button(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Center(
                        child:
                            Text("Cancle", style: TextStyle(color: Colors.red)),
                      ),
                    ),
                  ),
                  Expanded(
                    child: FilledButton(
                      style: ButtonStyle(
                          shape: ButtonState.resolveWith((states) =>
                              const RoundedRectangleBorder(
                                  borderRadius:
                                      mat.BorderRadiusDirectional.zero))),
                      onPressed: () async {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return Center(
                                  child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  ProgressRing(),
                                  Text(
                                    "\nSyncing status...",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ));
                            });
                        final eventRef =
                            FirebaseFirestore.instance.collection('events');
                        final storageRef = FirebaseStorage.instance.ref();
                        DateTime dt =
                            DateTime(_date.year, _date.month, _date.year);
                        final TaskSnapshot task = await storageRef
                            .child("events")
                            .child(widget.title)
                            .putFile(widget.imageurl);
                        if (task.bytesTransferred == task.totalBytes) {
                          eventRef.doc().set({
                            "title": widget.title,
                            "subtitle": widget.subtitle,
                            "description": widget.description,
                            "date": dt,
                            "image_url": await task.ref.getDownloadURL()
                          }).then((value) {
                            Navigator.pop(context);
                            Navigator.pop(context);
                            Navigator.pop(context);
                          });
                        }
                      },
                      child: const Center(
                        child: Text(
                          "Save",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
