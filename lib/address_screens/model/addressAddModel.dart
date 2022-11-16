class AddressAddModel {
  Data data;
  String message;
  int status;

  AddressAddModel({this.data, this.message, this.status});

  AddressAddModel.fromJson(Map<String, dynamic> json) {
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
  String createdAt;
  String address;
  String landmark;
  String zip;
  String city;
  String state;
  String userId;
  String longitude;
  String latitude;
  String addressName;
  int isDefault;
  String updatedAt;
  int id;

  Data(
      {this.createdAt,
        this.address,
        this.landmark,
        this.zip,
        this.city,
        this.state,
        this.userId,
        this.longitude,
        this.latitude,
        this.addressName,
        this.isDefault,
        this.updatedAt,
        this.id});

  Data.fromJson(Map<String, dynamic> json) {
    createdAt = json['created_at'];
    address = json['address'];
    landmark = json['landmark'];
    zip = json['zip'];
    city = json['city'];
    state = json['state'];
    userId = json['user_id'];
    longitude = json['longitude'];
    latitude = json['latitude'];
    addressName = json['address_name'];
    isDefault = json['is_default'];
    updatedAt = json['updated_at'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['created_at'] = this.createdAt;
    data['address'] = this.address;
    data['landmark'] = this.landmark;
    data['zip'] = this.zip;
    data['city'] = this.city;
    data['state'] = this.state;
    data['user_id'] = this.userId;
    data['longitude'] = this.longitude;
    data['latitude'] = this.latitude;
    data['address_name'] = this.addressName;
    data['is_default'] = this.isDefault;
    data['updated_at'] = this.updatedAt;
    data['id'] = this.id;
    return data;
  }
}
