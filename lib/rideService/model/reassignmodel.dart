// To parse this JSON data, do
//
//     final reassignmodel = reassignmodelFromJson(jsonString);

import 'dart:convert';

Reassignmodel reassignmodelFromJson(String str) => Reassignmodel.fromJson(json.decode(str));

String reassignmodelToJson(Reassignmodel data) => json.encode(data.toJson());

class Reassignmodel {
  Reassignmodel({
    this.success,
    this.data,
    this.message,
  });

  bool success;
  Data data;
  String message;

  factory Reassignmodel.fromJson(Map<String, dynamic> json) => Reassignmodel(
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
  });

  int id;
  int customerId;
  dynamic carrierId;
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
  dynamic orderId;
  dynamic rating;
  dynamic review;
  dynamic pickedUpAt;
  dynamic droppedAt;
  String updatedAt;
  String createdAt;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    customerId: json["customer_id"],
    carrierId: json["carrier_id"],
    pickupAddress: json["pickup_address"],
    pickupLatitude: json["pickup_latitude"],
    pickupLongitude: json["pickup_longitude"],
    dropAddress: json["drop_address"],
    dropLatitude: json["drop_latitude"],
    dropLongitude: json["drop_longitude"],
    projectedDistance: json["projected_distance"],
    status: json["status"],
    actualDistance: json["actual_distance"],
    tripCharge: json["trip_charge"],
    tax: json["tax"],
    payableAmount: json["payable_amount"],
    ewalletAmount: json["ewallet_amount"],
    paymentMethod: json["payment_method"],
    paymentStatus: json["payment_status"],
    transactionId: json["transaction_id"],
    orderId: json["order_id"],
    rating: json["rating"],
    review: json["review"],
    pickedUpAt: json["picked_up_at"],
    droppedAt: json["dropped_at"],
    updatedAt: json["updated_at"],
    createdAt: json["created_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "customer_id": customerId,
    "carrier_id": carrierId,
    "pickup_address": pickupAddress,
    "pickup_latitude": pickupLatitude,
    "pickup_longitude": pickupLongitude,
    "drop_address": dropAddress,
    "drop_latitude": dropLatitude,
    "drop_longitude": dropLongitude,
    "projected_distance": projectedDistance,
    "status": status,
    "actual_distance": actualDistance,
    "trip_charge": tripCharge,
    "tax": tax,
    "payable_amount": payableAmount,
    "ewallet_amount": ewalletAmount,
    "payment_method": paymentMethod,
    "payment_status": paymentStatus,
    "transaction_id": transactionId,
    "order_id": orderId,
    "rating": rating,
    "review": review,
    "picked_up_at": pickedUpAt,
    "dropped_at": droppedAt,
    "updated_at": updatedAt,
    "created_at": createdAt,
  };
}
