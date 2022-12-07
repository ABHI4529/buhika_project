import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart' as mat;
import 'package:fluent_ui/fluent_ui.dart';
import 'package:intl/intl.dart';

class EventDetails extends StatefulWidget {
  final String title;
  final String subtitle;
  final Timestamp date;
  final String description;
  final String imageurl;
  EventDetails(
      {Key? key,
      required this.title,
      required this.date,
      required this.description,
      required this.subtitle,
      required this.imageurl})
      : super(key: key);

  @override
  State<EventDetails> createState() => _EventDetailsState();
}

class _EventDetailsState extends State<EventDetails> {
  DateTime dt = DateTime.now();
  DateFormat dateformat = DateFormat("dd of MMMM yyyy");
  @override
  void initState() {
    Timestamp tm = widget.date;
    setState(() {
      dt = tm.toDate();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.cover, image: NetworkImage(widget.imageurl))),
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
                child: Text(dateformat.format(dt),
                    style: const TextStyle(color: Colors.white)),
              )
            ],
          ),
          body: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(15),
              child: Column(
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
        ),
      ),
    );
  }
}
