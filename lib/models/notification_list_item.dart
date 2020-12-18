class NotificationResponse {
  String message;
  List<Notifications> notifications;
  int status;

  NotificationResponse({this.message, this.notifications, this.status});

  NotificationResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['notifications'] != null) {
      notifications = new List<Notifications>();
      json['notifications'].forEach((v) {
        notifications.add(new Notifications.fromJson(v));
      });
    }
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.notifications != null) {
      data['notifications'] =
          this.notifications.map((v) => v.toJson()).toList();
    }
    data['status'] = this.status;
    return data;
  }
}

class Notifications {
  bool readMessage;
  String createdOnStr;
  int id;
  String title;
  String message;
  String createdOn;
  int userId;

  Notifications(
      {this.readMessage,
        this.createdOnStr,
        this.id,
        this.title,
        this.message,
        this.createdOn,
        this.userId});

  Notifications.fromJson(Map<String, dynamic> json) {
    readMessage = json['readMessage'];
    createdOnStr = json['createdOnStr'];
    id = json['id'];
    title = json['title'];
    message = json['message'];
    createdOn = json['createdOn'];
    userId = json['userId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['readMessage'] = this.readMessage;
    data['createdOnStr'] = this.createdOnStr;
    data['id'] = this.id;
    data['title'] = this.title;
    data['message'] = this.message;
    data['createdOn'] = this.createdOn;
    data['userId'] = this.userId;
    return data;
  }
}