class ChangePasswordModel {
  bool error;
  String message;
  int status;

  ChangePasswordModel({this.error, this.message, this.status});

  ChangePasswordModel.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    message = json['message'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['error'] = this.error;
    data['message'] = this.message;
    data['status'] = this.status;
    return data;
  }
}
