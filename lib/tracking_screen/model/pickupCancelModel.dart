import 'dart:convert';
class PickupCancelModel {
  PickupCancelModel({
    this.success,
    this.data,
    this.message,
  });

  bool success;
  Data data;
  String message;

  factory PickupCancelModel.fromJson(Map<String, dynamic> json) => PickupCancelModel(
    success: json["success"],
    data: Data.fromJson(json["data"]),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": data.toJson(),
    "message": message,
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

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    receiverName: json["receiver_name"],
    receiverMobile: json["receiver_mobile"],
    receiverAddress: json["receiver_address"],
    receiverPin: json["receiver_pin"],
    receiverLandmark: json["receiver_landmark"],
    receiverLatitude: json["receiver_latitude"],
    receiverLongitude: json["receiver_longitude"],
    senderName: json["sender_name"],
    senderMobile: json["sender_mobile"],
    senderAddress: json["sender_address"],
    senderPin: json["sender_pin"],
    senderLandmark: json["sender_landmark"],
    senderLatitude: json["sender_latitude"],
    senderLongitude: json["sender_longitude"],
    paymentMethod: json["payment_method"],
    payer: json["payer"],
    partner: json["partner"],
    carrierId: json["carrier_id"],
    itemType: json["item_type"],
    productName: json["product_name"],
    productAmount: json["product_amount"],
    productRemarks: json["product_remarks"],
    productImage: json["product_image"],
    weight: json["weight"],
    distance: json["distance"],
    costPerKm: json["cost_per_km"],
    extraPersonCharge: json["extra_person_charge"],
    deliveryCharge: json["delivery_charge"],
    payableAmount: json["payable_amount"],
    ewalletAmount: json["ewallet_amount"],
    expectedDeliveryTime: DateTime.parse(json["expected_delivery_time"]),
    vehicleType: json["vehicle_type"],
    pickupOn: json["pickup_on"],
    rejectedOn: json["rejected_on"],
    assignedOn: DateTime.parse(json["assigned_on"]),
    completedOn: DateTime.parse(json["completed_on"]),
    status: json["status"],
    createdBy: json["created_by"],
    thirdpartyOrderId: json["thirdparty_order_id"],
    orderId: json["order_id"],
    transactionId: json["transaction_id"],
    transactionStatus: json["transaction_status"],
    ewalletId: json["ewallet_id"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "receiver_name": receiverName,
    "receiver_mobile": receiverMobile,
    "receiver_address": receiverAddress,
    "receiver_pin": receiverPin,
    "receiver_landmark": receiverLandmark,
    "receiver_latitude": receiverLatitude,
    "receiver_longitude": receiverLongitude,
    "sender_name": senderName,
    "sender_mobile": senderMobile,
    "sender_address": senderAddress,
    "sender_pin": senderPin,
    "sender_landmark": senderLandmark,
    "sender_latitude": senderLatitude,
    "sender_longitude": senderLongitude,
    "payment_method": paymentMethod,
    "payer": payer,
    "partner": partner,
    "carrier_id": carrierId,
    "item_type": itemType,
    "product_name": productName,
    "product_amount": productAmount,
    "product_remarks": productRemarks,
    "product_image": productImage,
    "weight": weight,
    "distance": distance,
    "cost_per_km": costPerKm,
    "extra_person_charge": extraPersonCharge,
    "delivery_charge": deliveryCharge,
    "payable_amount": payableAmount,
    "ewallet_amount": ewalletAmount,
    "expected_delivery_time": expectedDeliveryTime.toIso8601String(),
    "vehicle_type": vehicleType,
    "pickup_on": pickupOn,
    "rejected_on": rejectedOn,
    "assigned_on": assignedOn.toIso8601String(),
    "completed_on": completedOn.toIso8601String(),
    "status": status,
    "created_by": createdBy,
    "thirdparty_order_id": thirdpartyOrderId,
    "order_id": orderId,
    "transaction_id": transactionId,
    "transaction_status": transactionStatus,
    "ewallet_id": ewalletId,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
