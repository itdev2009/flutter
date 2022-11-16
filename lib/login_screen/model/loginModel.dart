class LoginModel {
  Success success;
  Data data;
  String cartId;
  List<Role> role;
  int status;
  String ewalletId;
  String ewalletBalance;

  LoginModel(
      {this.success,
        this.data,
        this.cartId,
        this.role,
        this.status,
        this.ewalletId,
        this.ewalletBalance});

  LoginModel.fromJson(Map<String, dynamic> json) {
    success =
    json['success'] != null ? new Success.fromJson(json['success']) : null;
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    cartId = json['cart_id'];
    if (json['role'] != null) {
      role = new List<Role>();
      json['role'].forEach((v) {
        role.add(new Role.fromJson(v));
      });
    }
    status = json['status'];
    ewalletId = json['ewallet_id'];
    ewalletBalance = json['ewallet_balance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.success != null) {
      data['success'] = this.success.toJson();
    }
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    data['cart_id'] = this.cartId;
    if (this.role != null) {
      data['role'] = this.role.map((v) => v.toJson()).toList();
    }
    data['status'] = this.status;
    data['ewallet_id'] = this.ewalletId;
    data['ewallet_balance'] = this.ewalletBalance;
    return data;
  }
}

class Success {
  String token;

  Success({this.token});

  Success.fromJson(Map<String, dynamic> json) {
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = this.token;
    return data;
  }
}

class Data {
  int id;
  String name;
  String email;
  String mobileNumber;
  String emailVerifiedFlag;
  String emailVerifiedToken;
  String emailVerifiedAt;
  String mobileVerifiedFlag;
  String mobileVerifiedAt;
  String mobileVerifiedToken;
  String createdAt;
  String updatedAt;
  String vendorId;
  String carrierId;
  String deviceId;

  Data(
      {this.id,
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
        this.deviceId});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
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

class Role {
  String name;

  Role({this.name});

  Role.fromJson(Map<String, dynamic> json) {
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    return data;
  }
}
