
class MapTrackingModel {

  Data data;
  String message;
  String status;

  MapTrackingModel({this.data, this.message, this.status});

  MapTrackingModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    message = json['message'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    data['message'] = this.message;
    data['status'] = this.status;
    return data;
  }
}

class Data {
  int transid;
  String longitude;
  String latitude;
  String createdAt;
  String updatedAt;

  Data(
      {this.transid,
        this.longitude,
        this.latitude,
        this.createdAt,
        this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
    transid = json['transid'];
    longitude = json['longitude'];
    latitude = json['latitude'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['transid'] = this.transid;
    data['longitude'] = this.longitude;
    data['latitude'] = this.latitude;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}



