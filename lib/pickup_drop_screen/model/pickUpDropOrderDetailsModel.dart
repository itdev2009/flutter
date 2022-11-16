class PickUpDropOrderDetailsModel {
  PickUpDropOrderDetailsModel({
    this.success,
    this.data,
    this.message,
  });

  bool success;
  List<Datum> data;
  String message;

  factory PickUpDropOrderDetailsModel.fromJson(Map<String, dynamic> json) => PickUpDropOrderDetailsModel(
    success: json["success"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "message": message,
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
  dynamic carrierId;
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
  List<ReceiverDetail> receiverDetails;
  dynamic carrier;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
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
    assignedOn: json["assigned_on"],
    completedOn: json["completed_on"],
    status: json["status"],
    createdBy: json["created_by"],
    thirdpartyOrderId: json["thirdparty_order_id"],
    orderId: json["order_id"],
    transactionId: json["transaction_id"],
    transactionStatus: json["transaction_status"],
    ewalletId: json["ewallet_id"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    receiverDetails: List<ReceiverDetail>.from(json["receiver_details"].map((x) => ReceiverDetail.fromJson(x))),
    carrier: json["carrier"],
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
    "assigned_on": assignedOn,
    "completed_on": completedOn,
    "status": status,
    "created_by": createdBy,
    "thirdparty_order_id": thirdpartyOrderId,
    "order_id": orderId,
    "transaction_id": transactionId,
    "transaction_status": transactionStatus,
    "ewallet_id": ewalletId,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "receiver_details": List<dynamic>.from(receiverDetails.map((x) => x.toJson())),
    "carrier": carrier,
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
    this.remarks,
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
  dynamic image;
  String status;
  DateTime createdAt;
  DateTime updatedAt;
  String remarks;

  factory ReceiverDetail.fromJson(Map<String, dynamic> json) => ReceiverDetail(
    id: json["id"],
    pickupsId: json["pickups_id"],
    receiverName: json["receiver_name"],
    receiverMobile: json["receiver_mobile"],
    receiverAddress: json["receiver_address"],
    receiverPin: json["receiver_pin"],
    receiverLandmark: json["receiver_landmark"],
    receiverLatitude: json["receiver_latitude"],
    receiverLongitude: json["receiver_longitude"],
    image: json["image"],
    status: json["status"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    remarks: json["remarks"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "pickups_id": pickupsId,
    "receiver_name": receiverName,
    "receiver_mobile": receiverMobile,
    "receiver_address": receiverAddress,
    "receiver_pin": receiverPin,
    "receiver_landmark": receiverLandmark,
    "receiver_latitude": receiverLatitude,
    "receiver_longitude": receiverLongitude,
    "image": image,
    "status": status,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "remarks": remarks,
  };
}
