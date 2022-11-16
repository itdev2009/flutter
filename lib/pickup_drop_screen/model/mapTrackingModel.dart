
import 'dart:convert';

MapTrackingMultiplePickup mapTrackingMultiplePickupFromJson(String str) => MapTrackingMultiplePickup.fromJson(json.decode(str));

String mapTrackingMultiplePickupToJson(MapTrackingMultiplePickup data) => json.encode(data.toJson());

class MapTrackingMultiplePickup {
  MapTrackingMultiplePickup({
    this.success,
    this.data,
    this.message,
  });

  bool success;
  List<Datum> data;
  String message;

  factory MapTrackingMultiplePickup.fromJson(Map<String, dynamic> json) => MapTrackingMultiplePickup(
    success: json["success"] == null ? null : json["success"],
    data: json["data"] == null ? null : List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    message: json["message"] == null ? null : json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success == null ? null : success,
    "data": data == null ? null : List<dynamic>.from(data.map((x) => x.toJson())),
    "message": message == null ? null : message,
  };
}

class Datum {
  Datum({
    this.id,
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
    this.partner,
    this.carrierId,
    this.itemType,
    this.productName,
    this.productAmount,
    this.productRemarks,
    this.productImage,
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
    this.thirdpartyOrderId,
    this.orderId,
    this.transactionId,
    this.transactionStatus,
    this.ewalletId,
    this.createdAt,
    this.updatedAt,
    this.receiverDetails,
    this.carrier,
  });

  int id;
  dynamic receiverName;
  String receiverMobile;
  String receiverAddress;
  dynamic receiverPin;
  dynamic receiverLandmark;
  String receiverLatitude;
  String receiverLongitude;
  String senderName;
  String senderMobile;
  String senderAddress;
  dynamic senderPin;
  dynamic senderLandmark;
  String senderLatitude;
  String senderLongitude;
  String paymentMethod;
  String payer;
  String partner;
  int carrierId;
  dynamic itemType;
  String productName;
  dynamic productAmount;
  String productRemarks;
  dynamic productImage;
  dynamic weight;
  String distance;
  String costPerKm;
  dynamic extraPersonCharge;
  String deliveryCharge;
  String payableAmount;
  dynamic ewalletAmount;
  DateTime expectedDeliveryTime;
  String vehicleType;
  DateTime pickupOn;
  dynamic rejectedOn;
  DateTime assignedOn;
  DateTime completedOn;
  String status;
  int createdBy;
  dynamic thirdpartyOrderId;
  String orderId;
  String transactionId;
  String transactionStatus;
  dynamic ewalletId;
  DateTime createdAt;
  DateTime updatedAt;
  List<ReceiverDetail> receiverDetails;
  Carrier carrier;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"] == null ? null : json["id"],
    receiverName: json["receiver_name"],
    receiverMobile: json["receiver_mobile"] == null ? null : json["receiver_mobile"],
    receiverAddress: json["receiver_address"] == null ? null : json["receiver_address"],
    receiverPin: json["receiver_pin"],
    receiverLandmark: json["receiver_landmark"],
    receiverLatitude: json["receiver_latitude"] == null ? null : json["receiver_latitude"],
    receiverLongitude: json["receiver_longitude"] == null ? null : json["receiver_longitude"],
    senderName: json["sender_name"] == null ? null : json["sender_name"],
    senderMobile: json["sender_mobile"] == null ? null : json["sender_mobile"],
    senderAddress: json["sender_address"] == null ? null : json["sender_address"],
    senderPin: json["sender_pin"],
    senderLandmark: json["sender_landmark"],
    senderLatitude: json["sender_latitude"] == null ? null : json["sender_latitude"],
    senderLongitude: json["sender_longitude"] == null ? null : json["sender_longitude"],
    paymentMethod: json["payment_method"] == null ? null : json["payment_method"],
    payer: json["payer"] == null ? null : json["payer"],
    partner: json["partner"] == null ? null : json["partner"],
    carrierId: json["carrier_id"] == null ? null : json["carrier_id"],
    itemType: json["item_type"],
    productName: json["product_name"] == null ? null : json["product_name"],
    productAmount: json["product_amount"],
    productRemarks: json["product_remarks"] == null ? null : json["product_remarks"],
    productImage: json["product_image"],
    weight: json["weight"],
    distance: json["distance"] == null ? null : json["distance"],
    costPerKm: json["cost_per_km"] == null ? null : json["cost_per_km"],
    extraPersonCharge: json["extra_person_charge"],
    deliveryCharge: json["delivery_charge"] == null ? null : json["delivery_charge"],
    payableAmount: json["payable_amount"] == null ? null : json["payable_amount"],
    ewalletAmount: json["ewallet_amount"],
    expectedDeliveryTime: json["expected_delivery_time"] == null ? null : DateTime.parse(json["expected_delivery_time"]),
    vehicleType: json["vehicle_type"] == null ? null : json["vehicle_type"],
    pickupOn: json["pickup_on"] == null ? null : DateTime.parse(json["pickup_on"]),
    rejectedOn: json["rejected_on"],
    assignedOn: json["assigned_on"] == null ? null : DateTime.parse(json["assigned_on"]),
    completedOn: json["completed_on"] == null ? null : DateTime.parse(json["completed_on"]),
    status: json["status"] == null ? null : json["status"],
    createdBy: json["created_by"] == null ? null : json["created_by"],
    thirdpartyOrderId: json["thirdparty_order_id"],
    orderId: json["order_id"] == null ? null : json["order_id"],
    transactionId: json["transaction_id"] == null ? null : json["transaction_id"],
    transactionStatus: json["transaction_status"] == null ? null : json["transaction_status"],
    ewalletId: json["ewallet_id"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    receiverDetails: json["receiver_details"] == null ? null : List<ReceiverDetail>.from(json["receiver_details"].map((x) => ReceiverDetail.fromJson(x))),
    carrier: json["carrier"] == null ? null : Carrier.fromJson(json["carrier"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "receiver_name": receiverName,
    "receiver_mobile": receiverMobile == null ? null : receiverMobile,
    "receiver_address": receiverAddress == null ? null : receiverAddress,
    "receiver_pin": receiverPin,
    "receiver_landmark": receiverLandmark,
    "receiver_latitude": receiverLatitude == null ? null : receiverLatitude,
    "receiver_longitude": receiverLongitude == null ? null : receiverLongitude,
    "sender_name": senderName == null ? null : senderName,
    "sender_mobile": senderMobile == null ? null : senderMobile,
    "sender_address": senderAddress == null ? null : senderAddress,
    "sender_pin": senderPin,
    "sender_landmark": senderLandmark,
    "sender_latitude": senderLatitude == null ? null : senderLatitude,
    "sender_longitude": senderLongitude == null ? null : senderLongitude,
    "payment_method": paymentMethod == null ? null : paymentMethod,
    "payer": payer == null ? null : payer,
    "partner": partner == null ? null : partner,
    "carrier_id": carrierId == null ? null : carrierId,
    "item_type": itemType,
    "product_name": productName == null ? null : productName,
    "product_amount": productAmount,
    "product_remarks": productRemarks == null ? null : productRemarks,
    "product_image": productImage,
    "weight": weight,
    "distance": distance == null ? null : distance,
    "cost_per_km": costPerKm == null ? null : costPerKm,
    "extra_person_charge": extraPersonCharge,
    "delivery_charge": deliveryCharge == null ? null : deliveryCharge,
    "payable_amount": payableAmount == null ? null : payableAmount,
    "ewallet_amount": ewalletAmount,
    "expected_delivery_time": expectedDeliveryTime == null ? null : expectedDeliveryTime.toIso8601String(),
    "vehicle_type": vehicleType == null ? null : vehicleType,
    "pickup_on": pickupOn == null ? null : pickupOn.toIso8601String(),
    "rejected_on": rejectedOn,
    "assigned_on": assignedOn == null ? null : assignedOn.toIso8601String(),
    "completed_on": completedOn == null ? null : completedOn.toIso8601String(),
    "status": status == null ? null : status,
    "created_by": createdBy == null ? null : createdBy,
    "thirdparty_order_id": thirdpartyOrderId,
    "order_id": orderId == null ? null : orderId,
    "transaction_id": transactionId == null ? null : transactionId,
    "transaction_status": transactionStatus == null ? null : transactionStatus,
    "ewallet_id": ewalletId,
    "created_at": createdAt == null ? null : createdAt.toIso8601String(),
    "updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
    "receiver_details": receiverDetails == null ? null : List<dynamic>.from(receiverDetails.map((x) => x.toJson())),
    "carrier": carrier == null ? null : carrier.toJson(),
  };
}

class Carrier {
  Carrier({
    this.id,
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
    this.address,
    this.proofVehicleNo,
    this.proofPhoto,
    this.proofAddress,
    this.vehicleType,
    this.vehicleNo,
    this.vehicleMake,
    this.referralCode,
    this.pincode,
    this.isValidate,
    this.lastActivity,
    this.user,
  });

  int id;
  String mobileNumber;
  int mobileVerifiedFlag;
  String mobileVerifiedToken;
  dynamic mobileVerifiedAt;
  String deviceId;
  DateTime createdAt;
  DateTime updatedAt;
  int isActive;
  int isAvailable;
  String latitude;
  String longitude;
  String address;
  String proofVehicleNo;
  String proofPhoto;
  String proofAddress;
  String vehicleType;
  String vehicleNo;
  String vehicleMake;
  dynamic referralCode;
  dynamic pincode;
  int isValidate;
  DateTime lastActivity;
  User user;

  factory Carrier.fromJson(Map<String, dynamic> json) => Carrier(
    id: json["id"] == null ? null : json["id"],
    mobileNumber: json["mobile_number"] == null ? null : json["mobile_number"],
    mobileVerifiedFlag: json["mobile_verified_flag"] == null ? null : json["mobile_verified_flag"],
    mobileVerifiedToken: json["mobile_verified_token"] == null ? null : json["mobile_verified_token"],
    mobileVerifiedAt: json["mobile_verified_at"],
    deviceId: json["device_id"] == null ? null : json["device_id"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    isActive: json["is_active"] == null ? null : json["is_active"],
    isAvailable: json["is_available"] == null ? null : json["is_available"],
    latitude: json["latitude"] == null ? null : json["latitude"],
    longitude: json["longitude"] == null ? null : json["longitude"],
    address: json["address"] == null ? null : json["address"],
    proofVehicleNo: json["proof_vehicle_no"] == null ? null : json["proof_vehicle_no"],
    proofPhoto: json["proof_photo"] == null ? null : json["proof_photo"],
    proofAddress: json["proof_address"] == null ? null : json["proof_address"],
    vehicleType: json["vehicle_type"] == null ? null : json["vehicle_type"],
    vehicleNo: json["vehicle_no"] == null ? null : json["vehicle_no"],
    vehicleMake: json["vehicle_make"] == null ? null : json["vehicle_make"],
    referralCode: json["referral_code"],
    pincode: json["pincode"],
    isValidate: json["is_validate"] == null ? null : json["is_validate"],
    lastActivity: json["last_activity"] == null ? null : DateTime.parse(json["last_activity"]),
    user: json["user"] == null ? null : User.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "mobile_number": mobileNumber == null ? null : mobileNumber,
    "mobile_verified_flag": mobileVerifiedFlag == null ? null : mobileVerifiedFlag,
    "mobile_verified_token": mobileVerifiedToken == null ? null : mobileVerifiedToken,
    "mobile_verified_at": mobileVerifiedAt,
    "device_id": deviceId == null ? null : deviceId,
    "created_at": createdAt == null ? null : createdAt.toIso8601String(),
    "updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
    "is_active": isActive == null ? null : isActive,
    "is_available": isAvailable == null ? null : isAvailable,
    "latitude": latitude == null ? null : latitude,
    "longitude": longitude == null ? null : longitude,
    "address": address == null ? null : address,
    "proof_vehicle_no": proofVehicleNo == null ? null : proofVehicleNo,
    "proof_photo": proofPhoto == null ? null : proofPhoto,
    "proof_address": proofAddress == null ? null : proofAddress,
    "vehicle_type": vehicleType == null ? null : vehicleType,
    "vehicle_no": vehicleNo == null ? null : vehicleNo,
    "vehicle_make": vehicleMake == null ? null : vehicleMake,
    "referral_code": referralCode,
    "pincode": pincode,
    "is_validate": isValidate == null ? null : isValidate,
    "last_activity": lastActivity == null ? null : lastActivity.toIso8601String(),
    "user": user == null ? null : user.toJson(),
  };
}

class User {
  User({
    this.id,
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
    this.referralCode,
    this.createdAt,
    this.updatedAt,
    this.vendorId,
    this.carrierId,
    this.deviceId,
    this.isActive,
  });

  int id;
  String name;
  String email;
  dynamic profilePic;
  String mobileNumber;
  int emailVerifiedFlag;
  String emailVerifiedToken;
  dynamic emailVerifiedAt;
  int mobileVerifiedFlag;
  dynamic mobileVerifiedAt;
  dynamic mobileVerifiedToken;
  String referralCode;
  DateTime createdAt;
  DateTime updatedAt;
  dynamic vendorId;
  int carrierId;
  String deviceId;
  int isActive;

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"] == null ? null : json["id"],
    name: json["name"] == null ? null : json["name"],
    email: json["email"] == null ? null : json["email"],
    profilePic: json["profile_pic"],
    mobileNumber: json["mobile_number"] == null ? null : json["mobile_number"],
    emailVerifiedFlag: json["email_verified_flag"] == null ? null : json["email_verified_flag"],
    emailVerifiedToken: json["email_verified_token"] == null ? null : json["email_verified_token"],
    emailVerifiedAt: json["email_verified_at"],
    mobileVerifiedFlag: json["mobile_verified_flag"] == null ? null : json["mobile_verified_flag"],
    mobileVerifiedAt: json["mobile_verified_at"],
    mobileVerifiedToken: json["mobile_verified_token"],
    referralCode: json["referral_code"] == null ? null : json["referral_code"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    vendorId: json["vendor_id"],
    carrierId: json["carrier_id"] == null ? null : json["carrier_id"],
    deviceId: json["device_id"] == null ? null : json["device_id"],
    isActive: json["is_active"] == null ? null : json["is_active"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "name": name == null ? null : name,
    "email": email == null ? null : email,
    "profile_pic": profilePic,
    "mobile_number": mobileNumber == null ? null : mobileNumber,
    "email_verified_flag": emailVerifiedFlag == null ? null : emailVerifiedFlag,
    "email_verified_token": emailVerifiedToken == null ? null : emailVerifiedToken,
    "email_verified_at": emailVerifiedAt,
    "mobile_verified_flag": mobileVerifiedFlag == null ? null : mobileVerifiedFlag,
    "mobile_verified_at": mobileVerifiedAt,
    "mobile_verified_token": mobileVerifiedToken,
    "referral_code": referralCode == null ? null : referralCode,
    "created_at": createdAt == null ? null : createdAt.toIso8601String(),
    "updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
    "vendor_id": vendorId,
    "carrier_id": carrierId == null ? null : carrierId,
    "device_id": deviceId == null ? null : deviceId,
    "is_active": isActive == null ? null : isActive,
  };
}

class ReceiverDetail {
  ReceiverDetail({
    this.id,
    this.pickupsId,
    this.receiverName,
    this.receiverMobile,
    this.receiverAddress,
    this.receiverPin,
    this.receiverLandmark,
    this.receiverLatitude,
    this.receiverLongitude,
    this.image,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  int pickupsId;
  String receiverName;
  String receiverMobile;
  String receiverAddress;
  String receiverPin;
  String receiverLandmark;
  String receiverLatitude;
  String receiverLongitude;
  String image;
  String status;
  DateTime createdAt;
  DateTime updatedAt;

  factory ReceiverDetail.fromJson(Map<String, dynamic> json) => ReceiverDetail(
    id: json["id"] == null ? null : json["id"],
    pickupsId: json["pickups_id"] == null ? null : json["pickups_id"],
    receiverName: json["receiver_name"] == null ? null : json["receiver_name"],
    receiverMobile: json["receiver_mobile"] == null ? null : json["receiver_mobile"],
    receiverAddress: json["receiver_address"] == null ? null : json["receiver_address"],
    receiverPin: json["receiver_pin"] == null ? null : json["receiver_pin"],
    receiverLandmark: json["receiver_landmark"] == null ? null : json["receiver_landmark"],
    receiverLatitude: json["receiver_latitude"] == null ? null : json["receiver_latitude"],
    receiverLongitude: json["receiver_longitude"] == null ? null : json["receiver_longitude"],
    image: json["image"] == null ? null : json["image"],
    status: json["status"] == null ? null : json["status"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "pickups_id": pickupsId == null ? null : pickupsId,
    "receiver_name": receiverName == null ? null : receiverName,
    "receiver_mobile": receiverMobile == null ? null : receiverMobile,
    "receiver_address": receiverAddress == null ? null : receiverAddress,
    "receiver_pin": receiverPin == null ? null : receiverPin,
    "receiver_landmark": receiverLandmark == null ? null : receiverLandmark,
    "receiver_latitude": receiverLatitude == null ? null : receiverLatitude,
    "receiver_longitude": receiverLongitude == null ? null : receiverLongitude,
    "image": image == null ? null : image,
    "status": status == null ? null : status,
    "created_at": createdAt == null ? null : createdAt.toIso8601String(),
    "updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
  };
}
