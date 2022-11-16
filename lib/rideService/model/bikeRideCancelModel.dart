class BikeRideCancelModel {
  bool success;
  Data data;
  String message;

  BikeRideCancelModel({this.success, this.data, this.message});

  BikeRideCancelModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    data['message'] = this.message;
    return data;
  }
}

class Data {
  int id;
  int customerId;
  int carrierId;
  String pickupAddress;
  String pickupLatitude;
  String pickupLongitude;
  String dropAddress;
  String dropLatitude;
  String dropLongitude;
  String projectedDistance;
  String status;
  String actualDistance;
  String tripCharge;
  String tax;
  String payableAmount;
  dynamic ewalletAmount;
  String paymentMethod;
  String paymentStatus;
  String transactionId;
  String orderId;
  dynamic rating;
  dynamic review;
  dynamic pickedUpAt;
  dynamic droppedAt;
  String updatedAt;
  String createdAt;
  Carrier carrier;
  Customer customer;

  Data(
      {this.id,
        this.customerId,
        this.carrierId,
        this.pickupAddress,
        this.pickupLatitude,
        this.pickupLongitude,
        this.dropAddress,
        this.dropLatitude,
        this.dropLongitude,
        this.projectedDistance,
        this.status,
        this.actualDistance,
        this.tripCharge,
        this.tax,
        this.payableAmount,
        this.ewalletAmount,
        this.paymentMethod,
        this.paymentStatus,
        this.transactionId,
        this.orderId,
        this.rating,
        this.review,
        this.pickedUpAt,
        this.droppedAt,
        this.updatedAt,
        this.createdAt,
        this.carrier,
        this.customer});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    customerId = json['customer_id'];
    carrierId = json['carrier_id'];
    pickupAddress = json['pickup_address'];
    pickupLatitude = json['pickup_latitude'];
    pickupLongitude = json['pickup_longitude'];
    dropAddress = json['drop_address'];
    dropLatitude = json['drop_latitude'];
    dropLongitude = json['drop_longitude'];
    projectedDistance = json['projected_distance'];
    status = json['status'];
    actualDistance = json['actual_distance'];
    tripCharge = json['trip_charge'];
    tax = json['tax'];
    payableAmount = json['payable_amount'];
    ewalletAmount = json['ewallet_amount'];
    paymentMethod = json['payment_method'];
    paymentStatus = json['payment_status'];
    transactionId = json['transaction_id'];
    orderId = json['order_id'];
    rating = json['rating'];
    review = json['review'];
    pickedUpAt = json['picked_up_at'];
    droppedAt = json['dropped_at'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    carrier =
    json['carrier'] != null ? new Carrier.fromJson(json['carrier']) : null;
    customer = json['customer'] != null
        ? new Customer.fromJson(json['customer'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['customer_id'] = this.customerId;
    data['carrier_id'] = this.carrierId;
    data['pickup_address'] = this.pickupAddress;
    data['pickup_latitude'] = this.pickupLatitude;
    data['pickup_longitude'] = this.pickupLongitude;
    data['drop_address'] = this.dropAddress;
    data['drop_latitude'] = this.dropLatitude;
    data['drop_longitude'] = this.dropLongitude;
    data['projected_distance'] = this.projectedDistance;
    data['status'] = this.status;
    data['actual_distance'] = this.actualDistance;
    data['trip_charge'] = this.tripCharge;
    data['tax'] = this.tax;
    data['payable_amount'] = this.payableAmount;
    data['ewallet_amount'] = this.ewalletAmount;
    data['payment_method'] = this.paymentMethod;
    data['payment_status'] = this.paymentStatus;
    data['transaction_id'] = this.transactionId;
    data['order_id'] = this.orderId;
    data['rating'] = this.rating;
    data['review'] = this.review;
    data['picked_up_at'] = this.pickedUpAt;
    data['dropped_at'] = this.droppedAt;
    data['updated_at'] = this.updatedAt;
    data['created_at'] = this.createdAt;
    if (this.carrier != null) {
      data['carrier'] = this.carrier.toJson();
    }
    if (this.customer != null) {
      data['customer'] = this.customer.toJson();
    }
    return data;
  }
}

class Carrier {
  int id;
  String latitude;
  String longitude;
  String proofVehicleNo;
  String proofPhoto;
  String proofAddress;
  int isAvailable;
  String updatedAt;
  User user;

  Carrier(
      {this.id,
        this.latitude,
        this.longitude,
        this.proofVehicleNo,
        this.proofPhoto,
        this.proofAddress,
        this.isAvailable,
        this.updatedAt,
        this.user});

  Carrier.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    proofVehicleNo = json['proof_vehicle_no'];
    proofPhoto = json['proof_photo'];
    proofAddress = json['proof_address'];
    isAvailable = json['is_available'];
    updatedAt = json['updated_at'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['proof_vehicle_no'] = this.proofVehicleNo;
    data['proof_photo'] = this.proofPhoto;
    data['proof_address'] = this.proofAddress;
    data['is_available'] = this.isAvailable;
    data['updated_at'] = this.updatedAt;
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    return data;
  }
}

class User {
  int id;
  int carrierId;
  String name;
  String mobileNumber;
  Null profilePic;
  String deviceId;

  User(
      {this.id,
        this.carrierId,
        this.name,
        this.mobileNumber,
        this.profilePic,
        this.deviceId});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    carrierId = json['carrier_id'];
    name = json['name'];
    mobileNumber = json['mobile_number'];
    profilePic = json['profile_pic'];
    deviceId = json['device_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['carrier_id'] = this.carrierId;
    data['name'] = this.name;
    data['mobile_number'] = this.mobileNumber;
    data['profile_pic'] = this.profilePic;
    data['device_id'] = this.deviceId;
    return data;
  }
}

class Customer {
  int id;
  String name;
  String email;
  String profilePic;
  String mobileNumber;
  int emailVerifiedFlag;
  String emailVerifiedToken;
  Null emailVerifiedAt;
  int mobileVerifiedFlag;
  String mobileVerifiedAt;
  String mobileVerifiedToken;
  String createdAt;
  String updatedAt;
  Null vendorId;
  Null carrierId;
  String deviceId;

  Customer(
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

  Customer.fromJson(Map<String, dynamic> json) {
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
