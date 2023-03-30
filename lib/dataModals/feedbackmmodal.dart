class FeedbackModal {
  String? question;
  double? value;

  FeedbackModal({this.question, this.value});

  FeedbackModal.fromJson(Map<String, dynamic> json) {
    question = json['question'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['question'] = this.question;
    data['value'] = this.value;
    return data;
  }
}