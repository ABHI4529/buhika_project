import 'dart:io';

import 'package:cummins/screens/events/events.dart';
import 'package:cummins/screens/teachers/addevents/previewevent.dart';
import 'package:cummins/screens/teachers/addevents/teacherevents.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' as mat;
import 'package:fluent_ui/fluent_ui.dart';
import 'package:intl/intl.dart';

class AddEvent extends StatefulWidget {
  AddEvent({Key? key}) : super(key: key);

  @override
  State<AddEvent> createState() => _AddEventState();
}

class _AddEventState extends State<AddEvent> {
  String imagedownloadURL = "";
  String imageURL = "";
  File imageFile = File("");
  DateFormat dateFormat = DateFormat("dd of MMMM yyyy");
  final _date = DateTime.now();
  final _titleController = TextEditingController();
  final _shortDescription = TextEditingController();
  final _longDescription = TextEditingController();
  FlyoutController flyoutController = FlyoutController();
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
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              alignment: Alignment.centerRight,
              child: FlyoutTarget(
                  controller: flyoutController,
                  child: IconButton(
                    onPressed: () {
                      flyoutController.showFlyout(builder: (context)=> FlyoutContent(
                        child: Container(
                        width: 200,
                        padding: const EdgeInsets.all(5),
                        child: SizedBox(
                          height: 35,
                          child: FilledButton(
                            onPressed: () {
                              flyoutController.dispose();
                              Navigator.push(
                                  context,
                                  FluentPageRoute(
                                      builder: (context) => TeacherEvents()));
                            },
                            child: const Center(child: Text("Show All Events")),
                          ),
                        ),
                      )));
                    },
                    icon: const Icon(
                      mat.Icons.more_horiz,
                      color: Color(0xff474747),
                      size: 25,
                    ),
                  )),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
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
                child: SizedBox(
                  height: 35,
                  child: Button(
                    onPressed: () async {
                      final storageRef = FirebaseStorage.instance;
                      FilePickerResult? result = await FilePicker.platform
                          .pickFiles(
                              allowMultiple: true,
                              dialogTitle: "Select Image",
                              type: FileType.image);
                      if (result != null) {
                        File file = File("${result.files.single.path}");

                        setState(() {
                          imageFile = file;
                        });
                      }
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: mat.MainAxisAlignment.center,
                      children: const [
                        Text("Add Image   "),
                        Icon(
                          mat.Icons.add_circle_outline,
                          size: 20,
                        )
                      ],
                    ),
                  ),
                )),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: InfoLabel(
                label: "Short Description",
                child: TextBox(
                  maxLines: 4,
                  controller: _shortDescription,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: InfoLabel(
                label: "Long Description",
                child: TextBox(
                  maxLines: 10,
                  controller: _longDescription,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 50),
              child: SizedBox(
                height: 40,
                width: 200,
                child: FilledButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        FluentPageRoute(
                            builder: (context) => PreviewEvent(
                                  title: _titleController.text,
                                  subtitle: _shortDescription.text,
                                  description: _longDescription.text,
                                  image: imageFile,
                                )));
                  },
                  child: Center(child: Text("Preview")),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
