import 'package:blur/blur.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart' as mat;
import 'package:fluent_ui/fluent_ui.dart';
import 'package:intl/intl.dart';

class AddNotification extends StatefulWidget {
  AddNotification({Key? key}) : super(key: key);

  @override
  State<AddNotification> createState() => _AddNotificationState();
}

class _AddNotificationState extends State<AddNotification> {
  DateFormat dateFormat = DateFormat("dd of MMMM yyyy");
  final _date = DateTime.now();
  final _titleController = TextEditingController();
  final _subController = TextEditingController();
  final _fieldController = TextEditingController();
  final _yearController = TextEditingController();
  final _fieldList = ["Mechanical", "Civil", "Computer Science", "AI", "All"];
  final _yearList = ["1st Year", "2nd Year", "3rd Year", "4th Year", "All"];
  final _flyController = FlyoutController();

  Future sendNotification() async {
    final _studentId =
        await FirebaseFirestore.instance.collection('students').get();
    _studentId.docs.forEach((e) {
      final _notiRef = FirebaseFirestore.instance
          .collection('students')
          .doc(e.id)
          .collection('notifications');
      _notiRef.doc().set({
        "title": _titleController.text,
        "subtitle": _subController.text,
        "date": DateTime(_date.year, _date.month, _date.day),
        "read": false,
        "field": _fieldController.text,
        "year": _yearController.text
      }).then((value) {
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pop(context);
      });
    });
  }

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
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      FluentIcons.info,
                      color: Colors.blue.dark,
                    ),
                    Text("  Notifications cannot be edited or deleted"),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                child: InfoLabel(
                  label: "Title",
                  child: TextBox(
                    controller: _titleController,

                  ),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                child: InfoLabel(
                  label: "Sub Title",
                  child: TextBox(
                    controller: _subController,
                    maxLines: 3,
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 5),
                      child: InfoLabel(
                        label: "Field",
                        child: TextBox(
                          readOnly: true,
                          controller: _fieldController,
                          onTap: () {
                            showBottomSheet(
                                context: context,
                                builder: (context) {
                                  return FieldList(
                                    list: _fieldList,
                                    controller: _fieldController,
                                  );
                                });
                          },
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 5),
                      child: InfoLabel(
                        label: "Year",
                        child: TextBox(
                          readOnly: true,
                          controller: _yearController,
                          onTap: () {
                            showBottomSheet(
                                context: context,
                                builder: (context) {
                                  return FieldList(
                                    list: _yearList,
                                    controller: _yearController,
                                  );
                                });
                          },
                        ),
                      ),
                    ),
                  )
                ],
              ),
              Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.only(top: 100),
                child: SizedBox(
                  height: 35,
                  width: 200,
                  child: FilledButton(
                    onPressed: () async {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return ContentDialog(
                              title: Text("Send Notification"),
                              content: Text(
                                  "This will alert students about the above notification"),
                              actions: [
                                Button(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text("Cancel"),
                                ),
                                FilledButton(
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return Center(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: const [
                                                ProgressRing(),
                                                Text(
                                                  "\nSyncing Status",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                )
                                              ],
                                            ),
                                          );
                                        });
                                    sendNotification();
                                  },
                                  child: Text("Send"),
                                )
                              ],
                            );
                          });
                    },
                    child: Center(child: Text("Send")),
                  ),
                ),
              )
            ],
          ),
        ));
  }
}

class FieldList extends mat.StatefulWidget {
  final TextEditingController controller;
  final List list;
  const FieldList({
    required this.controller,
    required this.list,
    Key? key,
  }) : super(key: key);

  @override
  mat.State<FieldList> createState() => _FieldListState();
}

class _FieldListState extends mat.State<FieldList> {
  @override
  Widget build(mat.BuildContext context) {
    return Blur(
        overlay: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 5,
              width: 50,
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(10)),
            ),
            Container(
              width: double.maxFinite,
              padding: const EdgeInsets.only(top: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "  Select Field",
                    style: TextStyle(fontSize: 30),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 30),
                    child: Column(
                      children: widget.list
                          .map((e) => ListTile(
                                onPressed: () {
                                  setState(() {
                                    widget.controller.text = e;
                                    Navigator.pop(context);
                                  });
                                },
                                title: Text(e),
                              ))
                          .toList(),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
        child: Container());
  }
}
