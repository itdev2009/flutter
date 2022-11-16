class RegistrationModel {
  Success success;

  RegistrationModel({this.success});

  RegistrationModel.fromJson(Map<String, dynamic> json) {
    success =
    json['success'] != null ? new Success.fromJson(json['success']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.success != null) {
      data['success'] = this.success.toJson();
    }
    return data;
  }
}

class Success {
  String token;
  String name;
  int id;

  Success({this.token, this.name, this.id});

  Success.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    name = json['name'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = this.token;
    data['name'] = this.name;
    data['id'] = this.id;
    return data;
  }
}