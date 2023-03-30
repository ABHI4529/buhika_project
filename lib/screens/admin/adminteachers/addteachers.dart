import 'package:blur/blur.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluent_ui/fluent_ui.dart';

class AddTeachers extends StatefulWidget {
  AddTeachers({Key? key}) : super(key: key);

  @override
  State<AddTeachers> createState() => _AddTeachersState();
}

class _AddTeachersState extends State<AddTeachers> {
  final List _subjects = [];
  final _subjectName = TextEditingController();
  final _teacherName = TextEditingController();
  final _teacherEmail = TextEditingController();
  final _teacherPassword = TextEditingController();
  final _date = DateTime.now();

  Future saveTeacher() async {
    final _teacherDocs = FirebaseFirestore.instance.collection('teachers');
    _teacherDocs.doc().set({
      "name": _teacherName.text,
      "email": _teacherEmail.text,
      "password": _teacherPassword.text,
      "subject": _subjects.map((e) => e),
      "date": DateTime(_date.year, _date.month, _date.day)
    });
  }

  @override
  Widget build(BuildContext context) {
    return ContentDialog(
      title: Text("Add Teachers"),
      content: Wrap(
        children: [
          Column(
            children: [
              InfoLabel(
                label: "Teacher  Name",
                child: TextBox(

                  controller: _teacherName,
                ),
              ),
              Container(height: 10),
              InfoLabel(
                label: "Teacher Email",
                child: TextBox(
                  controller: _teacherEmail,

                ),
              ),
              Container(height: 10),
              InfoLabel(
                label: "Teacher Password",
                child: TextBox(
                  controller: _teacherPassword,
                ),
              ),
              Container(height: 10),
              Row(
                children: const [
                  Icon(FluentIcons.info),
                  Text("  Added subjects will appear here"),
                ],
              ),
              Container(height: 10),
              Column(
                children: _subjects
                    .map((e) => Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                e,
                              ),
                              IconButton(
                                icon: const Icon(FluentIcons.chrome_close),
                                onPressed: () {
                                  setState(() {
                                    _subjects.remove(e);
                                  });
                                },
                              )
                            ],
                          ),
                        ))
                    .toList(),
              ),
              Container(height: 10),
              InfoLabel(
                label: "Add Subject",
                child: TextBox(
                  controller: _subjectName,
                  onSubmitted: (value) {
                    setState(() {
                      _subjects.add(value);
                      _subjectName.clear();
                    });
                  },
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        Button(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("Cancel"),
        ),
        FilledButton(
          child: const Text("Save"),
          onPressed: () {
            saveTeacher().then((value) => Navigator.pop(context));
          },
        )
      ],
    );
  }
}
