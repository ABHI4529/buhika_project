class StudentModal {
  StudentModal(this.studentName, this.present);

  late String studentName;
  late bool present;

  StudentModal.fromJson(Map<String, dynamic> json) {
    studentName = json['studentname'];
    present = json['present'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['studentName'] = studentName;
    data['present'] = present;
    return data;
  }
}
