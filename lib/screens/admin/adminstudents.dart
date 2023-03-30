import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cummins/dataModals/StudentModal.dart';
import 'package:cummins/dataModals/StudentTableModel.dart';
import 'package:cummins/screens/admin/adminstudent/addstudent.dart';
import 'package:easy_table/easy_table.dart';
import 'package:flutter/material.dart' as mat;
import 'package:fluent_ui/fluent_ui.dart';

class AdminStudents extends StatefulWidget {
  AdminStudents({Key? key}) : super(key: key);

  @override
  State<AdminStudents> createState() => _AdminStudentsState();
}

class _AdminStudentsState extends State<AdminStudents> {
  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      header: PageHeader(
        title: const Text("Students"),
        commandBar: SizedBox(
          width: 30,
          child: CommandBar(
            primaryItems: [
              CommandBarButton(
                onPressed: () {},
                icon: Icon(FluentIcons.explore_data),
                label: Text("Export"),
              ),
              CommandBarButton(
                onPressed: () {},
                icon: Icon(FluentIcons.import_mirrored),
                label: Text("Import"),
              ),
              CommandBarButton(
                onPressed: () {},
                icon: Icon(FluentIcons.print),
                label: Text("Print"),
              )
            ],
          ),
        ),
      ),
      content: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('students')
              .orderBy("rolnum")
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: ProgressRing());
            }
            return Container(
                width: double.maxFinite,
                height: double.maxFinite,
                padding: const EdgeInsets.only(left: 30, right: 30, bottom: 30),
                child: EasyTable(
                  columnWidthBehavior: ColumnWidthBehavior.fit,
                  EasyTableModel<Student>(

                      rows: snapshot.data!.docs
                          .map((e) => Student(e['name'], e['email'], e['field'],
                              e['rolnum'], e['section'], e['year']))
                          .toList(),
                      columns: [
                        EasyTableColumn(
                            name: "Roll No.",
                            stringValue: (row) => row.rollnumber),
                        EasyTableColumn(
                            name: "Student Name",
                            stringValue: (row) => row.studentName),
                        EasyTableColumn(
                            name: "Student Email",
                            stringValue: (row) => row.studentEmail),
                        EasyTableColumn(
                            name: "Field", stringValue: (row) => row.field),
                        EasyTableColumn(
                            name: "Year", stringValue: (row) => row.year),
                      ]),

                  onRowTap: (Student std) {},
                  focusable: true,
                ));
          }),
      bottomBar: Container(
          padding: const EdgeInsets.all(20),
          alignment: Alignment.centerRight,
          child: SizedBox(
            width: 200,
            height: 30,
            child: FilledButton(
              onPressed: () {
                showDialog(
                    context: context, builder: (context) => AddStudent());
              },
              child: Center(child: Text("Add Student")),
            ),
          )),
    );
  }
}
