class PickupDropOrderListModel {
  bool success;
  List<Data> data;
  String message;

  PickupDropOrderListModel({this.success, this.data, this.message});

  PickupDropOrderListModel.fromJson(Map<String, dynamic> json) {
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
  String receiverName;
  String receiverMobile;
  String receiverAddress;
  dynamic receiverPin;
  String receiverLandmark;
  String receiverLatitude;
  String receiverLongitude;
  String senderName;
  String senderMobile;
  String senderAddress;
  dynamic senderPin;
  String senderLandmark;
  String senderLatitude;
  String senderLongitude;
  String paymentMethod;
  String payer;
  int carrierId;
  String itemType;
  String productName;
  String productAmount;
  String productRemarks;
  String weight;
  String distance;
  String costPerKm;
  String extraPersonCharge;
  String deliveryCharge;
  String payableAmount;
  String ewalletAmount;
  String expectedDeliveryTime;
  String vehicleType;
  String pickupOn;
  String rejectedOn;
  String assignedOn;
  String completedOn;
  String status;
  int createdBy;
  String orderId;
  String transactionId;
  String transactionStatus;
  dynamic ewalletId;
  String createdAt;
  String updatedAt;
  Carrier carrier;

  Data(
      {this.id,
        this.receiverName,
        this.receiverMobile,
        this.receiverAddress,
        this.receiverPin,
        this.receiverLandmark,
        this.receiverLatitude,
        this.receiverLongitude,
        this.senderName,
        this.senderMobile,
        this.senderAddress,
        this.senderPin,
        this.senderLandmark,
        this.senderLatitude,
        this.senderLongitude,
        this.paymentMethod,
        this.payer,
        this.carrierId,
        this.itemType,
        this.productName,
        this.productAmount,
        this.productRemarks,
        this.weight,
        this.distance,
        this.costPerKm,
        this.extraPersonCharge,
        this.deliveryCharge,
        this.payableAmount,
        this.ewalletAmount,
        this.expectedDeliveryTime,
        this.vehicleType,
        this.pickupOn,
        this.rejectedOn,
        this.assignedOn,
        this.completedOn,
        this.status,
        this.createdBy,
        this.orderId,
        this.transactionId,
        this.transactionStatus,
        this.ewalletId,
        this.createdAt,
        this.updatedAt,
        this.carrier});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    receiverName = json['receiver_name'];
    receiverMobile = json['receiver_mobile'];
    receiverAddress = json['receiver_address'];
    receiverPin = json['receiver_pin'];
    receiverLandmark = json['receiver_landmark'];
    receiverLatitude = json['receiver_latitude'];
    receiverLongitude = json['receiver_longitude'];
    senderName = json['sender_name'];
    senderMobile = json['sender_mobile'];
    senderAddress = json['sender_address'];
    senderPin = json['sender_pin'];
    senderLandmark = json['sender_landmark'];
    senderLatitude = json['sender_latitude'];
    senderLongitude = json['sender_longitude'];
    paymentMethod = json['payment_method'];
    payer = json['payer'];
    carrierId = json['carrier_id'];
    itemType = json['item_type'];
    productName = json['product_name'];
    productAmount = json['product_amount'];
    productRemarks = json['product_remarks'];
    weight = json['weight'];
    distance = json['distance'];
    costPerKm = json['cost_per_km'];
    extraPersonCharge = json['extra_person_charge'];
    deliveryCharge = json['delivery_charge'];
    payableAmount = json['payable_amount'];
    ewalletAmount = json['ewallet_amount'];
    expectedDeliveryTime = json['expected_delivery_time'];
    vehicleType = json['vehicle_type'];
    pickupOn = json['pickup_on'];
    rejectedOn = json['rejected_on'];
    assignedOn = json['assigned_on'];
    completedOn = json['completed_on'];
    status = json['status'];
    createdBy = json['created_by'];
    orderId = json['order_id'];
    transactionId = json['transaction_id'];
    transactionStatus = json['transaction_status'];
    ewalletId = json['ewallet_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    carrier =
    json['carrier'] != null ? new Carrier.fromJson(json['carrier']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['receiver_name'] = this.receiverName;
    data['receiver_mobile'] = this.receiverMobile;
    data['receiver_address'] = this.receiverAddress;
    data['receiver_pin'] = this.receiverPin;
    data['receiver_landmark'] = this.receiverLandmark;
    data['receiver_latitude'] = this.receiverLatitude;
    data['receiver_longitude'] = this.receiverLongitude;
    data['sender_name'] = this.senderName;
    data['sender_mobile'] = this.senderMobile;
    data['sender_address'] = this.senderAddress;
    data['sender_pin'] = this.senderPin;
    data['sender_landmark'] = this.senderLandmark;
    data['sender_latitude'] = this.senderLatitude;
    data['sender_longitude'] = this.senderLongitude;
    data['payment_method'] = this.paymentMethod;
    data['payer'] = this.payer;
    data['carrier_id'] = this.carrierId;
    data['item_type'] = this.itemType;
    data['product_name'] = this.productName;
    data['product_amount'] = this.productAmount;
    data['product_remarks'] = this.productRemarks;
    data['weight'] = this.weight;
    data['distance'] = this.distance;
    data['cost_per_km'] = this.costPerKm;
    data['extra_person_charge'] = this.extraPersonCharge;
    data['delivery_charge'] = this.deliveryCharge;
    data['payable_amount'] = this.payableAmount;
    data['ewallet_amount'] = this.ewalletAmount;
    data['expected_delivery_time'] = this.expectedDeliveryTime;
    data['vehicle_type'] = this.vehicleType;
    data['pickup_on'] = this.pickupOn;
    data['rejected_on'] = this.rejectedOn;
    data['assigned_on'] = this.assignedOn;
    data['completed_on'] = this.completedOn;
    data['status'] = this.status;
    data['created_by'] = this.createdBy;
    data['order_id'] = this.orderId;
    data['transaction_id'] = this.transactionId;
    data['transaction_status'] = this.transactionStatus;
    data['ewallet_id'] = this.ewalletId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.carrier != null) {
      data['carrier'] = this.carrier.toJson();
    }
    return data;
  }
}

class Carrier {
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
  User user;

  Carrier(
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
        this.user});

  Carrier.fromJson(Map<String, dynamic> json) {
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
