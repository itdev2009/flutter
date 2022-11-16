class AddressShowAllModel {
  List<Data> data;
  String message;
  int status;

  AddressShowAllModel({this.data, this.message, this.status});

  AddressShowAllModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<Data>();
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
      });
    }
    message = json['message'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    data['status'] = this.status;
    return data;
  }
}

class Data {
  int id;
  int userId;
  String address;
  String landmark;
  String city;
  String state;
  int zip;
  String longitude;
  String latitude;
  int isActive;
  String addressName;
  int isDefault;
  String createdAt;
  String updatedAt;

  Data(
      {this.id,
        this.userId,
        this.address,
        this.landmark,
        this.city,
        this.state,
        this.zip,
        this.longitude,
        this.latitude,
        this.isActive,
        this.addressName,
        this.isDefault,
        this.createdAt,
        this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    address = json['address'];
    landmark = json['landmark'];
    city = json['city'];
    state = json['state'];
    zip = json['zip'];
    longitude = json['longitude'];
    latitude = json['latitude'];
    isActive = json['is_active'];
    addressName = json['address_name'];
    isDefault = json['is_default'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['address'] = this.address;
    data['landmark'] = this.landmark;
    data['city'] = this.city;
    data['state'] = this.state;
    data['zip'] = this.zip;
    data['longitude'] = this.longitude;
    data['latitude'] = this.latitude;
    data['is_active'] = this.isActive;
    data['address_name'] = this.addressName;
    data['is_default'] = this.isDefault;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
