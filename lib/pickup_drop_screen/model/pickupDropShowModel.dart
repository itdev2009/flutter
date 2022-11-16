class PickupDropShowModel {
  bool success;
  List<Data> data;
  String message;

  PickupDropShowModel({this.success, this.data, this.message});

  PickupDropShowModel.fromJson(Map<String, dynamic> json) {
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
  String receiverPin;
  String receiverLandmark;
  String senderName;
  String senderMobile;
  String senderAddress;
  String senderPin;
  String senderLandmark;
  String paymentMethod;
  String payer;
  String carrierId;
  String itemType;
  String productName;
  String weight;
  String pickupOn;
  String assignedOn;
  String completedOn;
  String status;
  String createdBy;
  String createdAt;
  String updatedAt;

  Data(
      {this.id,
        this.receiverName,
        this.receiverMobile,
        this.receiverAddress,
        this.receiverPin,
        this.receiverLandmark,
        this.senderName,
        this.senderMobile,
        this.senderAddress,
        this.senderPin,
        this.senderLandmark,
        this.paymentMethod,
        this.payer,
        this.carrierId,
        this.itemType,
        this.productName,
        this.weight,
        this.pickupOn,
        this.assignedOn,
        this.completedOn,
        this.status,
        this.createdBy,
        this.createdAt,
        this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    receiverName = json['receiver_name'];
    receiverMobile = json['receiver_mobile'];
    receiverAddress = json['receiver_address'];
    receiverPin = json['receiver_pin'];
    receiverLandmark = json['receiver_landmark'];
    senderName = json['sender_name'];
    senderMobile = json['sender_mobile'];
    senderAddress = json['sender_address'];
    senderPin = json['sender_pin'];
    senderLandmark = json['sender_landmark'];
    paymentMethod = json['payment_method'];
    payer = json['payer'];
    carrierId = json['carrier_id'];
    itemType = json['item_type'];
    productName = json['product_name'];
    weight = json['weight'];
    pickupOn = json['pickup_on'];
    assignedOn = json['assigned_on'];
    completedOn = json['completed_on'];
    status = json['status'];
    createdBy = json['created_by'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['receiver_name'] = this.receiverName;
    data['receiver_mobile'] = this.receiverMobile;
    data['receiver_address'] = this.receiverAddress;
    data['receiver_pin'] = this.receiverPin;
    data['receiver_landmark'] = this.receiverLandmark;
    data['sender_name'] = this.senderName;
    data['sender_mobile'] = this.senderMobile;
    data['sender_address'] = this.senderAddress;
    data['sender_pin'] = this.senderPin;
    data['sender_landmark'] = this.senderLandmark;
    data['payment_method'] = this.paymentMethod;
    data['payer'] = this.payer;
    data['carrier_id'] = this.carrierId;
    data['item_type'] = this.itemType;
    data['product_name'] = this.productName;
    data['weight'] = this.weight;
    data['pickup_on'] = this.pickupOn;
    data['assigned_on'] = this.assignedOn;
    data['completed_on'] = this.completedOn;
    data['status'] = this.status;
    data['created_by'] = this.createdBy;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
