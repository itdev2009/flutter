// To parse this JSON data, do
//
//     final multiplePickup = multiplePickupFromJson(jsonString);

import 'dart:convert';

MultiplePickup multiplePickupFromJson(String str) => MultiplePickup.fromJson(json.decode(str));

String multiplePickupToJson(MultiplePickup data) => json.encode(data.toJson());

class MultiplePickup {
  MultiplePickup({
    this.success,
    this.data,
    this.message,
  });

  bool success;
  Data data;
  String message;

  factory MultiplePickup.fromJson(Map<String, dynamic> json) => MultiplePickup(
    success: json["success"] == null ? null : json["success"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
    message: json["message"] == null ? null : json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success == null ? null : success,
    "data": data == null ? null : data.toJson(),
    "message": message == null ? null : message,
  };
}

class Data {
  Data({
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
  });

  int id;
  dynamic receiverName;
  String receiverMobile;
  dynamic receiverAddress;
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
  dynamic carrierId;
  dynamic itemType;
  dynamic productName;
  dynamic productAmount;
  dynamic productRemarks;
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
  dynamic pickupOn;
  dynamic rejectedOn;
  dynamic assignedOn;
  dynamic completedOn;
  String status;
  int createdBy;
  dynamic thirdpartyOrderId;
  String orderId;
  String transactionId;
  String transactionStatus;
  dynamic ewalletId;
  DateTime createdAt;
  DateTime updatedAt;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"] == null ? null : json["id"],
    receiverName: json["receiver_name"],
    receiverMobile: json["receiver_mobile"] == null ? null : json["receiver_mobile"],
    receiverAddress: json["receiver_address"],
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
    carrierId: json["carrier_id"],
    itemType: json["item_type"],
    productName: json["product_name"],
    productAmount: json["product_amount"],
    productRemarks: json["product_remarks"],
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
    pickupOn: json["pickup_on"],
    rejectedOn: json["rejected_on"],
    assignedOn: json["assigned_on"],
    completedOn: json["completed_on"],
    status: json["status"] == null ? null : json["status"],
    createdBy: json["created_by"] == null ? null : json["created_by"],
    thirdpartyOrderId: json["thirdparty_order_id"],
    orderId: json["order_id"] == null ? null : json["order_id"],
    transactionId: json["transaction_id"] == null ? null : json["transaction_id"],
    transactionStatus: json["transaction_status"] == null ? null : json["transaction_status"],
    ewalletId: json["ewallet_id"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "receiver_name": receiverName,
    "receiver_mobile": receiverMobile == null ? null : receiverMobile,
    "receiver_address": receiverAddress,
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
    "carrier_id": carrierId,
    "item_type": itemType,
    "product_name": productName,
    "product_amount": productAmount,
    "product_remarks": productRemarks,
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
    "pickup_on": pickupOn,
    "rejected_on": rejectedOn,
    "assigned_on": assignedOn,
    "completed_on": completedOn,
    "status": status == null ? null : status,
    "created_by": createdBy == null ? null : createdBy,
    "thirdparty_order_id": thirdpartyOrderId,
    "order_id": orderId == null ? null : orderId,
    "transaction_id": transactionId == null ? null : transactionId,
    "transaction_status": transactionStatus == null ? null : transactionStatus,
    "ewallet_id": ewalletId,
    "created_at": createdAt == null ? null : createdAt.toIso8601String(),
    "updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
  };
}

