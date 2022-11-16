class OrderDetailsModel {
  List<Data> data;
  String message;
  int code;

  OrderDetailsModel({this.data, this.message, this.code});

  OrderDetailsModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<Data>();
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
      });
    }
    message = json['message'];
    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    data['code'] = this.code;
    return data;
  }
}

class Data {
  String id;
  String orderId;
  String transactionId;
  String transactionStatus;
  String transactionAmount;
  String createdAt;
  String updatedAt;
  String isAccepted;
  String isAssigned;
  String cartId;
  String orderAmount;
  String taxAmount;
  String deliveryAmount;
  String deliveryAddress;
  String vendorId;
  String customerId;
  String isActive;

  Data(
      {this.id,
        this.orderId,
        this.transactionId,
        this.transactionStatus,
        this.transactionAmount,
        this.createdAt,
        this.updatedAt,
        this.isAccepted,
        this.isAssigned,
        this.cartId,
        this.orderAmount,
        this.taxAmount,
        this.deliveryAmount,
        this.deliveryAddress,
        this.vendorId,
        this.customerId,
        this.isActive});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderId = json['order_id'];
    transactionId = json['transaction_id'];
    transactionStatus = json['transaction_status'];
    transactionAmount = json['transaction_amount'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    isAccepted = json['is_accepted'];
    isAssigned = json['is_assigned'];
    cartId = json['cart_id'];
    orderAmount = json['order_amount'];
    taxAmount = json['tax_amount'];
    deliveryAmount = json['delivery_amount'];
    deliveryAddress = json['delivery_address'];
    vendorId = json['vendor_id'];
    customerId = json['customer_id'];
    isActive = json['is_active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['order_id'] = this.orderId;
    data['transaction_id'] = this.transactionId;
    data['transaction_status'] = this.transactionStatus;
    data['transaction_amount'] = this.transactionAmount;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['is_accepted'] = this.isAccepted;
    data['is_assigned'] = this.isAssigned;
    data['cart_id'] = this.cartId;
    data['order_amount'] = this.orderAmount;
    data['tax_amount'] = this.taxAmount;
    data['delivery_amount'] = this.deliveryAmount;
    data['delivery_address'] = this.deliveryAddress;
    data['vendor_id'] = this.vendorId;
    data['customer_id'] = this.customerId;
    data['is_active'] = this.isActive;
    return data;
  }
}
