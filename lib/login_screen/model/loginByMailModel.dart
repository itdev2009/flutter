// To parse this JSON data, do
//
//     final loginByMailModel = loginByMailModelFromJson(jsonString);

import 'dart:convert';

LoginByMailModel loginByMailModelFromJson(String str) => LoginByMailModel.fromJson(json.decode(str));

String loginByMailModelToJson(LoginByMailModel data) => json.encode(data.toJson());

class LoginByMailModel {
  LoginByMailModel({
    this.success,
    this.data,
    this.message,
  });

  bool success;
  LoginByMailModelData data;
  String message;

  factory LoginByMailModel.fromJson(Map<String, dynamic> json) => LoginByMailModel(
    success: json["success"],
    data: LoginByMailModelData.fromJson(json["data"]),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": data.toJson(),
    "message": message,
  };
}

class LoginByMailModelData {
  LoginByMailModelData({
    this.token,
    this.data,
  });

  String token;
  DataData data;

  factory LoginByMailModelData.fromJson(Map<String, dynamic> json) => LoginByMailModelData(
    token: json["token"],
    data: DataData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "token": token,
    "data": data.toJson(),
  };
}

class DataData {
  DataData({
    this.id,
    this.name,
    this.email,
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
    this.deviceId,
  });

  int id;
  String name;
  String email;
  dynamic mobileNumber;
  String emailVerifiedFlag;
  dynamic emailVerifiedToken;
  dynamic emailVerifiedAt;
  String mobileVerifiedFlag;
  dynamic mobileVerifiedAt;
  dynamic mobileVerifiedToken;
  DateTime createdAt;
  DateTime updatedAt;
  dynamic vendorId;
  dynamic carrierId;
  dynamic deviceId;

  factory DataData.fromJson(Map<String, dynamic> json) => DataData(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    mobileNumber: json["mobile_number"],
    emailVerifiedFlag: json["email_verified_flag"],
    emailVerifiedToken: json["email_verified_token"],
    emailVerifiedAt: json["email_verified_at"],
    mobileVerifiedFlag: json["mobile_verified_flag"],
    mobileVerifiedAt: json["mobile_verified_at"],
    mobileVerifiedToken: json["mobile_verified_token"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    vendorId: json["vendor_id"],
    carrierId: json["carrier_id"],
    deviceId: json["device_id"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "mobile_number": mobileNumber,
    "email_verified_flag": emailVerifiedFlag,
    "email_verified_token": emailVerifiedToken,
    "email_verified_at": emailVerifiedAt,
    "mobile_verified_flag": mobileVerifiedFlag,
    "mobile_verified_at": mobileVerifiedAt,
    "mobile_verified_token": mobileVerifiedToken,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "vendor_id": vendorId,
    "carrier_id": carrierId,
    "device_id": deviceId,
  };
}
