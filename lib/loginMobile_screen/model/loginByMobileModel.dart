class LoginByMobileModel {
  Success success;
  Data data;
  UserAddress userAddress;
  int cartId;
  CartVendorDetails cartVendorDetails;
  int status;
  String message;
  dynamic ewalletId;
  String ewalletBalance;

  LoginByMobileModel(
      {this.success,
        this.data,
        this.userAddress,
        this.cartId,
        this.cartVendorDetails,
        this.status,
        this.message,
        this.ewalletId,
        this.ewalletBalance});

  LoginByMobileModel.fromJson(Map<String, dynamic> json) {
    success =
    json['success'] != null ? new Success.fromJson(json['success']) : null;
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    userAddress = json['user_address'] != null
        ? new UserAddress.fromJson(json['user_address'])
        : null;
    cartId = json['cart_id'];
    cartVendorDetails = json['cart_vendor_details'] != null
        ? new CartVendorDetails.fromJson(json['cart_vendor_details'])
        : null;
    status = json['status'];
    message = json['message'];
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
    if (this.userAddress != null) {
      data['user_address'] = this.userAddress.toJson();
    }
    data['cart_id'] = this.cartId;
    if (this.cartVendorDetails != null) {
      data['cart_vendor_details'] = this.cartVendorDetails.toJson();
    }
    data['status'] = this.status;
    data['message'] = this.message;
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
  String address;
  String latitude;
  String longitude;


  Data(
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
        this.deviceId,
        this.address,
        this.latitude,
        this.longitude

      });

  Data.fromJson(Map<String, dynamic> json) {
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
    address = json['address'];
    latitude = json['latitude'];
    longitude = json['longitude'];
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
    data['address'] = this.address;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    return data;
  }
}

class UserAddress {
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

  UserAddress(
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

  UserAddress.fromJson(Map<String, dynamic> json) {
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

class CartVendorDetails {
  int id;
  String shopName;
  String mobileNumber;
  int mobileVerifiedFlag;
  String mobileVerifiedToken;
  String mobileVerifiedAt;
  String address;
  String city;
  String state;
  int zip;
  String longitude;
  String latitude;
  String vendorImage;
  int categoryId;
  String createdAt;
  String updatedAt;
  String availableFrom;
  String availableTo;
  int isActive;
  int parentId;

  CartVendorDetails(
      {this.id,
        this.shopName,
        this.mobileNumber,
        this.mobileVerifiedFlag,
        this.mobileVerifiedToken,
        this.mobileVerifiedAt,
        this.address,
        this.city,
        this.state,
        this.zip,
        this.longitude,
        this.latitude,
        this.vendorImage,
        this.categoryId,
        this.createdAt,
        this.updatedAt,
        this.availableFrom,
        this.availableTo,
        this.isActive,
        this.parentId});

  CartVendorDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    shopName = json['shop_name'];
    mobileNumber = json['mobile_number'];
    mobileVerifiedFlag = json['mobile_verified_flag'];
    mobileVerifiedToken = json['mobile_verified_token'];
    mobileVerifiedAt = json['mobile_verified_at'];
    address = json['address'];
    city = json['city'];
    state = json['state'];
    zip = json['zip'];
    longitude = json['longitude'];
    latitude = json['latitude'];
    vendorImage = json['vendor_image'];
    categoryId = json['category_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    availableFrom = json['available_from'];
    availableTo = json['available_to'];
    isActive = json['is_active'];
    parentId = json['parent_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['shop_name'] = this.shopName;
    data['mobile_number'] = this.mobileNumber;
    data['mobile_verified_flag'] = this.mobileVerifiedFlag;
    data['mobile_verified_token'] = this.mobileVerifiedToken;
    data['mobile_verified_at'] = this.mobileVerifiedAt;
    data['address'] = this.address;
    data['city'] = this.city;
    data['state'] = this.state;
    data['zip'] = this.zip;
    data['longitude'] = this.longitude;
    data['latitude'] = this.latitude;
    data['vendor_image'] = this.vendorImage;
    data['category_id'] = this.categoryId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['available_from'] = this.availableFrom;
    data['available_to'] = this.availableTo;
    data['is_active'] = this.isActive;
    data['parent_id'] = this.parentId;
    return data;
  }
}
