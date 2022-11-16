class BikerAvailableModel {
  bool success;
  List<Data> data;
  String message;

  BikerAvailableModel({this.success, this.data, this.message});

  BikerAvailableModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = new List<Data>();
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    return data;
  }
}

class Data {
  int id;
  String mobileNumber;
  int mobileVerifiedFlag;
  String mobileVerifiedToken;
  String mobileVerifiedAt;
  String deviceId;
  String createdAt;
  String updatedAt;
  int isActive;
  int isAvailable;
  String latitude;
  String longitude;
  String proofVehicleNo;
  String proofPhoto;
  String proofAddress;
  String vehicleType;
  double distance;
  User user;

  Data(
      {this.id,
        this.mobileNumber,
        this.mobileVerifiedFlag,
        this.mobileVerifiedToken,
        this.mobileVerifiedAt,
        this.deviceId,
        this.createdAt,
        this.updatedAt,
        this.isActive,
        this.isAvailable,
        this.latitude,
        this.longitude,
        this.proofVehicleNo,
        this.proofPhoto,
        this.proofAddress,
        this.vehicleType,
        this.distance,
        this.user});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    mobileNumber = json['mobile_number'];
    mobileVerifiedFlag = json['mobile_verified_flag'];
    mobileVerifiedToken = json['mobile_verified_token'];
    mobileVerifiedAt = json['mobile_verified_at'];
    deviceId = json['device_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    isActive = json['is_active'];
    isAvailable = json['is_available'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    proofVehicleNo = json['proof_vehicle_no'];
    proofPhoto = json['proof_photo'];
    proofAddress = json['proof_address'];
    vehicleType = json['vehicle_type'];
    distance = json['distance'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['mobile_number'] = this.mobileNumber;
    data['mobile_verified_flag'] = this.mobileVerifiedFlag;
    data['mobile_verified_token'] = this.mobileVerifiedToken;
    data['mobile_verified_at'] = this.mobileVerifiedAt;
    data['device_id'] = this.deviceId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['is_active'] = this.isActive;
    data['is_available'] = this.isAvailable;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['proof_vehicle_no'] = this.proofVehicleNo;
    data['proof_photo'] = this.proofPhoto;
    data['proof_address'] = this.proofAddress;
    data['vehicle_type'] = this.vehicleType;
    data['distance'] = this.distance;
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    return data;
  }
}

class User {
  int id;
  String name;
  String email;
  String profilePic;
  String mobileNumber;
  int emailVerifiedFlag;
  String emailVerifiedToken;
  String emailVerifiedAt;
  int mobileVerifiedFlag;
  String mobileVerifiedAt;
  String mobileVerifiedToken;
  String createdAt;
  String updatedAt;
  int vendorId;
  int carrierId;
  String deviceId;

  User(
      {this.id,
        this.name,
        this.email,
        this.profilePic,
        this.mobileNumber,
        this.emailVerifiedFlag,
        this.emailVerifiedToken,
        this.emailVerifiedAt,
        this.mobileVerifiedFlag,
        this.mobileVerifiedAt,
        this.mobileVerifiedToken,
        this.createdAt,
        this.updatedAt,
        this.vendorId,
        this.carrierId,
        this.deviceId});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    profilePic = json['profile_pic'];
    mobileNumber = json['mobile_number'];
    emailVerifiedFlag = json['email_verified_flag'];
    emailVerifiedToken = json['email_verified_token'];
    emailVerifiedAt = json['email_verified_at'];
    mobileVerifiedFlag = json['mobile_verified_flag'];
    mobileVerifiedAt = json['mobile_verified_at'];
    mobileVerifiedToken = json['mobile_verified_token'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    vendorId = json['vendor_id'];
    carrierId = json['carrier_id'];
    deviceId = json['device_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['profile_pic'] = this.profilePic;
    data['mobile_number'] = this.mobileNumber;
    data['email_verified_flag'] = this.emailVerifiedFlag;
    data['email_verified_token'] = this.emailVerifiedToken;
    data['email_verified_at'] = this.emailVerifiedAt;
    data['mobile_verified_flag'] = this.mobileVerifiedFlag;
    data['mobile_verified_at'] = this.mobileVerifiedAt;
    data['mobile_verified_token'] = this.mobileVerifiedToken;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['vendor_id'] = this.vendorId;
    data['carrier_id'] = this.carrierId;
    data['device_id'] = this.deviceId;
    return data;
  }
}
