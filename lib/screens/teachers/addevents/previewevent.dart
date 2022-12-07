import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cummins/screens/teachers/addevents/previewdetails.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart' as mat;
import 'package:fluent_ui/fluent_ui.dart';
import 'package:intl/intl.dart';

class PreviewEvent extends StatefulWidget {
  final String? title;
  final String? subtitle;
  final File? image;
  final String? description;
  PreviewEvent(
      {Key? key, this.title, this.subtitle, this.image, this.description})
      : super(key: key);

  @override
  State<PreviewEvent> createState() => _PreviewEventState();
}

class _PreviewEventState extends State<PreviewEvent> {
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
            ),
          )
        ],
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            width: double.maxFinite,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: LinearGradient(colors: [
                  const Color(0xff35A4C8),
                  const Color(0xff4F62A2).withOpacity(0.2)
                ]),
                image: DecorationImage(
                    fit: BoxFit.cover, image: FileImage(widget.image!))),
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
                    "${widget.title}",
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 27),
                  ),
                  SizedBox(
                    width: 300,
                    child: Text(
                      "${widget.subtitle}",
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
                            shape:
                                ButtonState.resolveWith<RoundedRectangleBorder>(
                                    (states) => RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(5))),
                            backgroundColor: ButtonState.resolveWith<Color>(
                                (states) => Colors.white.withOpacity(0.4))),
                        onPressed: () {
                          Navigator.push(
                              context,
                              FluentPageRoute(
                                  builder: (context) => PreviewEventDetails(
                                      title: "${widget.title}",
                                      date: _date,
                                      description: "${widget.description}",
                                      subtitle: "${widget.subtitle}",
                                      imageurl: widget.image!)));
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
          ),
        ],
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
                    child: Text("Cancle", style: TextStyle(color: Colors.red)),
                  ),
                ),
              ),
              Expanded(
                child: FilledButton(
                  style: ButtonStyle(
                      shape: ButtonState.resolveWith((states) =>
                          const RoundedRectangleBorder(
                              borderRadius: mat.BorderRadiusDirectional.zero))),
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
                    DateTime dt = DateTime(_date.year, _date.month, _date.year);
                    final TaskSnapshot task = await storageRef
                        .child("events")
                        .child("${widget.title}")
                        .putFile(widget.image!);
                    if (task.bytesTransferred == task.totalBytes) {
                      eventRef.doc().set({
                        "title": widget.title!,
                        "subtitle": widget.subtitle!,
                        "description": widget.description!,
                        "date": dt,
                        "image_url": await task.ref.getDownloadURL()
                      }).then((value) {
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
    );
  }
}
