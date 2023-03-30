import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_table/easy_table.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as mat;
import 'package:intl/intl.dart';

class AdminRegister extends StatefulWidget {
  AdminRegister({Key? key}) : super(key: key);

  @override
  State<AdminRegister> createState() => _AdminRegisterState();
}

class _AdminRegisterState extends State<AdminRegister> {
  List students = [];
  DateTime _selectedDate = DateTime.now();

  Future getAllStudents() async {
    String s = "";
    final QuerySnapshot stdCol = await FirebaseFirestore.instance
        .collection('register')
        .where("field", isEqualTo: _field)
        .where("year", isEqualTo: _year)
        .where("section", isEqualTo: _section)
        .where("teacher", isEqualTo: _teacher)
        .get();
    stdCol.docs.forEach((e) {
      setState(() {
        students = e['students'];
      });
    });
  }

  @override
  void initState() {
    getAllStudents();
    super.initState();
  }

  final DateFormat dateFormat = DateFormat("dd-MM-yyyy");
  DateTime dt = DateTime.now();
  bool _onfieldselected = false;
  bool _onsectionselected = false;
  bool _onteacherselected = false;
  bool _onyearselected = false;
  final _fieldController = TextEditingController();
  final _yearController = TextEditingController();
  final _teacherController = TextEditingController();
  final _sectionController = TextEditingController();
  String _field = "";
  String _year = "";
  String _section = "";
  String _teacher = "";


  @override
  Widget build(BuildContext context) {
    var data_date = DateTime(dt.year, dt.month, dt.day);
    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection("register").where('date', isGreaterThan: data_date).snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {

          List<String> preFields = [];
          List<String> preYears = [];
          List<String> years = [];
          List<String> fields = [];
          List<String> sections = [];
          List<String> teachers = [];

          if (!snapshot.hasData) {
            return const Center(child: ProgressRing());
          }
          if(snapshot.data != null){
            for (var element in snapshot.data!.docs) {
              preFields.add(element['field']);
              preYears.add(element['year']);
              sections.add(element['section']);
              teachers.add(element['teacher']);
            }
            fields = preFields.toSet().toList();
            years = preYears.toSet().toList();
          }
          return ScaffoldPage(
            header: PageHeader(
              title: const Text("Register"),
              commandBar: Container(
                width: 400,
                child: CommandBar(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.end,
                    primaryItems: [
                      CommandBarButton(
                          onPressed: () async {
                            showDialog(context: context, builder: (context){
                              return ContentDialog(
                                title: const Text("Select Date"),
                                content: DatePicker(

                                  selected: DateTime.now(),
                                  onChanged: (value){
                                    setState(() {
                                      _selectedDate = value;
                                    });
                                  },
                                ),
                                actions: [
                                  TextButton(
                                    child: const Text("Cancel"),
                                    onPressed: (){},
                                  ),
                                  FilledButton(
                                    child: const Text("Select"),
                                    onPressed: (){
                                      setState(() {
                                        dt = _selectedDate;
                                      });
                                      Navigator.pop(context);
                                    },
                                  )
                                ],
                              );
                            });
                          },
                          label: Text(dateFormat.format(dt)),
                          icon: Icon(
                            FluentIcons.date_time,
                            color: Colors.blue.darker,
                          )),
                    ]),
              ),
            ),
            content: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(25),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 200,
                        child: AutoSuggestBox(
                            controller: _fieldController,
                            onSelected: (value) {
                              if (value.value == null) {
                                setState(() {
                                  _onfieldselected = false;
                                });
                              } else {
                                setState(() {
                                  _onfieldselected = true;
                                });
                              }
                            },
                            placeholder: "Select Field",
                            items: fields
                                .map((e) => AutoSuggestBoxItem(value: "${e}", label: "${e}"))
                                .toList()),
                      ),
                      Container(
                        width: 10,
                      ),
                      _onfieldselected
                          ? SizedBox(
                              width: 200,
                              child: AutoSuggestBox(
                                  controller: _yearController,
                                  onSelected: (value) {
                                    if (value.value == null) {
                                      setState(() {
                                        _onyearselected = false;
                                      });
                                    } else {
                                      setState(() {
                                        _onyearselected = true;
                                      });
                                    }
                                  },
                                  placeholder: "Select Year",
                                  items: years
                                      .map((e) => AutoSuggestBoxItem(value: "${e}", label: "${e}"))
                                      .toList()),
                            )
                          : Container(),
                      Container(
                        width: 10,
                      ),
                      _onyearselected
                          ? SizedBox(
                              width: 200,
                              child: AutoSuggestBox(
                                  controller: _sectionController,
                                  onSelected: (value) {
                                    if (value.value  == null) {
                                      setState(() {
                                        _onsectionselected = false;
                                      });
                                    } else {
                                      setState(() {
                                        _onsectionselected = true;
                                      });
                                    }
                                  },
                                items: sections.toSet().toList()
                                    .map((e) => AutoSuggestBoxItem(value: "${e}", label: "${e}")).toList(),
                                  placeholder: "Select Section",),
                            )
                          : Container(),
                      Container(
                        width: 10,
                      ),
                      _onsectionselected
                          ? SizedBox(
                              width: 200,
                              child: AutoSuggestBox(
                                  controller: _teacherController,
                                  onSelected: (value) {
                                    items:
                                    if (value.value == null) {
                                      setState(() {
                                        _onteacherselected = false;
                                      });
                                    } else {
                                      setState(() {
                                        _onteacherselected = true;
                                      });
                                    }
                                  },
                                  placeholder: "Select Teacher",
                                  items: teachers.toSet().toList()
                                      .map((e) => AutoSuggestBoxItem(value: "${e}", label: "${e}"))
                                      .toList()),
                            )
                          : Container(),
                      Container(
                        width: 10,
                      ),
                      _onteacherselected
                          ? SizedBox(
                              width: 100,
                              height: 35,
                              child: FilledButton(
                                child: Center(child: Text("Search")),
                                onPressed: () {
                                  setState(() {
                                    _field = _fieldController.text;
                                    _year = _yearController.text;
                                    _section = _sectionController.text;
                                    _teacher = _teacherController.text;
                                  });
                                  getAllStudents();
                                },
                              ),
                            )
                          : Container()
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(25),
                    child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection("students")
                          .where("field", isEqualTo: _field)
                          .where("section", isEqualTo: _section)
                          .where("year", isEqualTo: _year)
                          .snapshots(),
                      builder:
                          (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(child: ProgressRing());
                        }
                        return ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            Color tileColor = Colors.white;
                            if (students
                                .contains(snapshot.data!.docs[index]['name'])) {
                              tileColor = Colors.green;
                            } else {
                              tileColor = Colors.red.dark;
                            }
                            return ListTile(
                              tileColor: ButtonState.resolveWith((states) => tileColor.withAlpha(30)),
                              shape:
                                  Border(bottom: BorderSide(color: tileColor)),
                              title:
                                  Text("${snapshot.data!.docs[index]['name']}"),
                              subtitle: Text(
                                "Roll No. : ${snapshot.data!.docs[index]['rolnum']}"
                                " | Section : ${snapshot.data!.docs[index]['section']}"
                                " | ${snapshot.data!.docs[index]['year']}",
                                style: const TextStyle(
                                    fontStyle: FontStyle.italic),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                )
              ],
            ),
          );
        });
  }
}
