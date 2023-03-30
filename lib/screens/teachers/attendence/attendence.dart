import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cummins/dataModals/StudentModal.dart';
import 'package:flutter/material.dart' as mat;
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

import '../addnotifications/addnotifications.dart';

class Attendence extends StatefulWidget {
  Attendence({Key? key}) : super(key: key);

  @override
  State<Attendence> createState() => _AttendenceState();
}

class _AttendenceState extends State<Attendence> {
  DateFormat dateFormat = DateFormat("dd of MMMM yyyy");
  final _date = DateTime.now();
  var _stRef = FirebaseFirestore.instance.collection('students');
  final _yearController = TextEditingController();
  final _fieldController = TextEditingController();
  final _sectionController = TextEditingController();
  final _teacherController = TextEditingController();
  final _fieldList = [
    "Mechanical",
    "Civil",
    "Computer Engineering",
    "BCA",
    "AI",
    "All"
  ];
  Color color = Colors.white;
  final _yearList = ["1st Year", "2nd Year", "3rd Year", "4th Year", "All"];
  final _sectionList = ["A", "B", "C", "D", "E", "All"];
  List studentList = [];
  Future getStudents() async {
    setState(() {
      // ignore: unnecessary_cast
      _stRef = FirebaseFirestore.instance.collection('students')
          as CollectionReference<Map<String, dynamic>>;
    });
  }

  Future saveRegister() async {
    final refCol = FirebaseFirestore.instance.collection("register");
    refCol.doc().set({
      "date": DateTime(_date.year, _date.month, _date.day),
      "section": _sectionController.text,
      "field": _fieldController.text,
      "year": _yearController.text,
      "teacher": _teacherController.text,
      "students": studentList.map((e) => e).toList()
    });
  }

  @override
  void initState() {
    super.initState();
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
            "Attendence",
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
        body: mat.Column(
          children: [
            Container(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: const Icon(
                  mat.Icons.more_vert,
                  size: 20,
                ),
                onPressed: () {},
              ),
            ),
            Container(
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.only(left: 15, right: 5),
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
                          horizontal: 5, vertical: 5),
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
                          }),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 5),
                      child: InfoLabel(
                        label: "Section",
                        child: TextBox(
                          readOnly: true,
                          controller: _sectionController,
                          onTap: () {
                            showBottomSheet(
                                context: context,
                                builder: (context) {
                                  return FieldList(
                                    list: _sectionList,
                                    controller: _sectionController,
                                  );
                                });
                          },
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 20, left: 5, right: 10),
                    child: SizedBox(
                      height: 35,
                      width: 50,
                      child: FilledButton(
                        onPressed: () {
                          if (_fieldController.text.isEmpty ||
                              _yearController.text.isEmpty) {
                          } else {
                            getStudents();
                          }
                        },
                        child: Center(child: Icon(FluentIcons.filter_solid)),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: mat.StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("students")
                      .snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: ProgressRing());
                    }
                    return AutoSuggestBox(
                      controller: _teacherController,
                      placeholder: "Teacher Name",
                      items: snapshot.data!.docs
                          .map((e) => AutoSuggestBoxItem(value: "${e['name']}", label: "${e['name']}"))
                          .toList(),
                    );
                  }),
            ),
            Container(
              height: 20,
            ),
            Expanded(
              child: StreamBuilder(
                stream: _stRef
                    .where('field', isEqualTo: _fieldController.text)
                    .where('year', isEqualTo: _yearController.text)
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: ProgressRing());
                  }
                  return SingleChildScrollView(
                    child: Column(
                      children: snapshot.data!.docs
                          .map((e) => StudentSlide(
                              docs: e, students: studentList, index: 1))
                          .toList(),
                    ),
                  );
                },
              ),
            ),
            Container(
              height: 100,
            )
          ],
        ),
        floatingActionButtonLocation:
            mat.FloatingActionButtonLocation.centerFloat,
        floatingActionButton: SizedBox(
          width: 150,
          height: 35,
          child: FilledButton(
              child: const Center(child: Text("Save")),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return ContentDialog(
                        title: const Text("Complete Register ?"),
                        content: const Text(
                            "Before saving the register please make sure you have"
                            " correctly marked all the students."),
                        actions: [
                          Button(
                            child: const Text("Cancel"),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          FilledButton(
                            onPressed: () {
                              mat.showDialog(
                                  context: context,
                                  builder: (context) {
                                    return const Center(
                                      child: ProgressRing(),
                                    );
                                  });
                              saveRegister().then((value) {
                                Navigator.pop(context);
                                Navigator.pop(context);
                                Navigator.pop(context);
                              });
                            },
                            child: const Text("Save"),
                          )
                        ],
                      );
                    });
              }),
        ));
  }
}

class StudentSlide extends mat.StatefulWidget {
  QueryDocumentSnapshot docs;
  List students;
  int index;
  StudentSlide(
      {Key? key,
      required this.docs,
      required this.index,
      required this.students})
      : super(key: key);

  @override
  mat.State<StudentSlide> createState() => _StudentSlideState();
}

class _StudentSlideState extends mat.State<StudentSlide> {
  Color color = Colors.white;
  @override
  Widget build(BuildContext context) {
    return Slidable(
        closeOnScroll: true,
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(5),
                bottomLeft: Radius.circular(5),
              ),
              backgroundColor: Colors.blue.dark,
              onPressed: (context) {
                setState(() {
                  color = Colors.blue.dark.withOpacity(0.3);
                });
                String studentName = widget.docs['name'];
                if (widget.students.contains(studentName)) {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return Wrap(
                          alignment: WrapAlignment.center,
                          runAlignment: WrapAlignment.end,
                          crossAxisAlignment: mat.WrapCrossAlignment.center,
                          children: [
                            InfoBar(
                              title: const Text("Info"),
                              isLong: false,

                              action: IconButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: const Icon(FluentIcons.chrome_close)),
                              content:
                                  const Text("The Student Already Marked Present"),
                            ),
                          ],
                        );
                      });
                } else {
                  widget.students.add(studentName);
                }
              },
              icon: mat.Icons.check,
            ),
            SlidableAction(
              spacing: 5,
              backgroundColor: Colors.red.dark,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(5),
                bottomRight: Radius.circular(5),
              ),
              onPressed: (context) {
                setState(() {
                  color = Colors.red.dark.withOpacity(0.3);
                });
              },
              icon: mat.Icons.close,
            )
          ],
        ),
        child: ListTile(
          tileColor: ButtonState.resolveWith((states) => color),
          title: Text(
            "${widget.docs['name']}",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ));
  }
}
