import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cummins/screens/admin/adminteachers/addteachers.dart';
import 'package:easy_table/easy_table.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../dataModals/teachermodal.dart';

class AdminTeachers extends StatefulWidget {
  AdminTeachers({Key? key}) : super(key: key);

  @override
  State<AdminTeachers> createState() => _AdminTeachersState();
}

class _AdminTeachersState extends State<AdminTeachers> {
  double sidebarWidth = 0;
  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      header: const PageHeader(
        title: Text("Teachers"),
      ),
      content: Container(
        padding: const EdgeInsets.all(30),
        child: Row(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('teachers')
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: ProgressRing());
                  }
                  return EasyTable(
                    columnWidthBehavior: ColumnWidthBehavior.fit,
                    EasyTableModel<Teacher>(
                        rows: snapshot.data!.docs
                            .map((e) => Teacher(e['name'], e['email']))
                            .toList(),
                        columns: [
                          EasyTableColumn(
                              name: "Teacher Name",
                              stringValue: (row) => row.teacherName),
                          EasyTableColumn(
                              name: "Teacher Email",
                              stringValue: (row) => row.teacherEmail)
                        ]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomBar: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.all(20),
        child: SizedBox(
          width: 200,
          height: 40,
          child: FilledButton(
            onPressed: () {
              showDialog(context: context, builder: (context) => AddTeachers());
            },
            child: const Center(
              child: Text("Add Teacher"),
            ),
          ),
        ),
      ),
    );
  }
}
