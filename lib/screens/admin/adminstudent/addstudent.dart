import 'package:blur/blur.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluent_ui/fluent_ui.dart';

class AddStudent extends StatefulWidget {
  AddStudent({Key? key}) : super(key: key);

  @override
  State<AddStudent> createState() => _AddStudentState();
}

class _AddStudentState extends State<AddStudent> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final _fieldController = TextEditingController();
  final _yearController = TextEditingController();
  final _sectionController = TextEditingController();
  final _rolnumController = TextEditingController();
  DateTime dt = DateTime.now();

  Future saveStudent() async {
    final studentRef = FirebaseFirestore.instance.collection('students');
    studentRef.doc().set({
      "name": _nameController.text,
      "email": _emailController.text,
      "password": _passController.text,
      "section": _sectionController.text,
      "year": _yearController.text,
      "rolnum": _rolnumController.text,
      "field": _fieldController.text,
      "date": DateTime(dt.year, dt.month, dt.day)
    });
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      runAlignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width / 2,
          height: MediaQuery.of(context).size.height / 2,
          child: Blur(
            borderRadius: BorderRadius.circular(10),
            blur: 2,
            child: Container(),
            overlay: Container(
              padding: const EdgeInsets.all(30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text(
                    "Add Student",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 30),
                    child: TextBox(
                      controller: _nameController,
                      textInputAction: TextInputAction.next,
                      header: "Student Name",
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    child: TextBox(
                      controller: _emailController,
                      textInputAction: TextInputAction.next,
                      header: "Email",
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    child: TextBox(
                      controller: _passController,
                      textInputAction: TextInputAction.next,
                      header: "Password",
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(top: 10),
                          child: TextBox(
                            placeholder: "Roll No.",
                            controller: _rolnumController,
                            textInputAction: TextInputAction.next,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                            margin: const EdgeInsets.only(top: 10, left: 10),
                            child: AutoSuggestBox.form(
                                controller: _fieldController,
                                textInputAction: TextInputAction.next,
                                placeholder: "Select Field",
                                items: const [
                                  "Mechanical",
                                  "Electrical",
                                  "Computer Engineering"
                                ])),
                      ),
                      Expanded(
                        child: Container(
                            margin: const EdgeInsets.only(top: 10, left: 10),
                            child: AutoSuggestBox.form(
                                controller: _yearController,
                                textInputAction: TextInputAction.next,
                                placeholder: "Select Year",
                                items: const [
                                  "1st Year",
                                  "2nd Year",
                                  "3rd Year",
                                  "4th Year"
                                ])),
                      ),
                      Expanded(
                        child: Container(
                            margin: const EdgeInsets.only(top: 10, left: 10),
                            child: AutoSuggestBox.form(
                                controller: _sectionController,
                                textInputAction: TextInputAction.next,
                                placeholder: "Select Section",
                                items: const ["A", "B", "C", "D", "E"])),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                            margin: const EdgeInsets.only(top: 10),
                            child: SizedBox(
                              height: 35,
                              child: Button(
                                onPressed: () {},
                                child: Center(child: Text("Cancel")),
                              ),
                            )),
                      ),
                      Expanded(
                        child: Container(
                            margin: const EdgeInsets.only(top: 10, left: 10),
                            child: SizedBox(
                              height: 35,
                              child: Button(
                                onPressed: () {},
                                child: Center(child: Text("Save & New")),
                              ),
                            )),
                      ),
                      Expanded(
                        child: Container(
                            margin: const EdgeInsets.only(top: 10, left: 10),
                            child: SizedBox(
                              height: 35,
                              child: FilledButton(
                                onPressed: () {
                                  saveStudent()
                                      .then((value) => Navigator.pop(context));
                                },
                                child: Center(child: Text("Save")),
                              ),
                            )),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
