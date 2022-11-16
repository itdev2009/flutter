class WalletTransactionModel {
  List<Data> data;
  String message;
  int status;

  WalletTransactionModel({this.data, this.message, this.status});

  WalletTransactionModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<Data>();
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
      });
    }
    message = json['message'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    data['status'] = this.status;
    return data;
  }
}

class Data {
  int id;
  int ewalletId;
  String gatewayOrderId;
  String transactionId;
  String transactionFrom;
  int orderId;
  dynamic transactionAmount;
  String transactionType;
  String transactionStatus;
  String createdAt;
  String updatedAt;
  String transactionDescription;

  Data(
      {this.id,
        this.ewalletId,
        this.gatewayOrderId,
        this.transactionId,
        this.transactionFrom,
        this.orderId,
        this.transactionAmount,
        this.transactionType,
        this.transactionStatus,
        this.createdAt,
        this.updatedAt,
        this.transactionDescription});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    ewalletId = json['ewallet_id'];
    gatewayOrderId = json['gateway_order_id'];
    transactionId = json['transaction_id'];
    transactionFrom = json['transaction_from'];
    orderId = json['order_id'];
    transactionAmount = json['transaction_amount'];
    transactionType = json['transaction_type'];
    transactionStatus = json['transaction_status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    transactionDescription = json['transaction_description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['ewallet_id'] = this.ewalletId;
    data['gateway_order_id'] = this.gatewayOrderId;
    data['transaction_id'] = this.transactionId;
    data['transaction_from'] = this.transactionFrom;
    data['order_id'] = this.orderId;
    data['transaction_amount'] = this.transactionAmount;
    data['transaction_type'] = this.transactionType;
    data['transaction_status'] = this.transactionStatus;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['transaction_description'] = this.transactionDescription;
    return data;
  }
}
