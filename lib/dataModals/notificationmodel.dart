class NotificationModel {
  List<Notification>? notification;

  NotificationModel({this.notification});

  NotificationModel.fromJson(Map<String, dynamic> json) {
    if (json['notification'] != null) {
      notification = <Notification>[];
      json['notification'].forEach((v) {
        notification!.add(new Notification.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.notification != null) {
      data['notification'] = this.notification!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Notification {
  String? date;
  String? title;
  String? subtitle;
  bool? read;

  Notification({this.date, this.title, this.subtitle, this.read});

  Notification.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    title = json['title'];
    subtitle = json['subtitle'];
    read = json['read'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['title'] = this.title;
    data['subtitle'] = this.subtitle;
    data['read'] = this.read;
    return data;
  }
}
