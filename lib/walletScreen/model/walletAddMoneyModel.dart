class WalletAddMoneyModel {
  Data data;
  String message;
  String status;

  WalletAddMoneyModel({this.data, this.message, this.status});

  WalletAddMoneyModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    message = json['message'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    data['message'] = this.message;
    data['status'] = this.status;
    return data;
  }
}

class Data {
  List<EwalletDetails> ewalletDetails;
  TansactionDetails tansactionDetails;
  String ewalletBalance;

  Data({this.ewalletDetails, this.tansactionDetails, this.ewalletBalance});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['ewallet_details'] != null) {
      ewalletDetails = new List<EwalletDetails>();
      json['ewallet_details'].forEach((v) {
        ewalletDetails.add(new EwalletDetails.fromJson(v));
      });
    }
    tansactionDetails = json['tansaction_details'] != null
        ? new TansactionDetails.fromJson(json['tansaction_details'])
        : null;
    ewalletBalance = json['ewallet_balance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.ewalletDetails != null) {
      data['ewallet_details'] =
          this.ewalletDetails.map((v) => v.toJson()).toList();
    }
    if (this.tansactionDetails != null) {
      data['tansaction_details'] = this.tansactionDetails.toJson();
    }
    data['ewallet_balance'] = this.ewalletBalance;
    return data;
  }
}

class EwalletDetails {
  int id;
  int userId;
  int isActive;
  String createdAt;
  String updatedAt;

  EwalletDetails(
      {this.id, this.userId, this.isActive, this.createdAt, this.updatedAt});

  EwalletDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    isActive = json['is_active'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['is_active'] = this.isActive;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class TansactionDetails {
  int ewalletId;
  String gatewayOrderId;
  String transactionId;
  String transactionFrom;
  String transactionAmount;
  String transactionType;
  String transactionStatus;
  String createdAt;
  String transactionDescription;
  String updatedAt;
  int id;

  TansactionDetails(
      {this.ewalletId,
        this.gatewayOrderId,
        this.transactionId,
        this.transactionFrom,
        this.transactionAmount,
        this.transactionType,
        this.transactionStatus,
        this.createdAt,
        this.transactionDescription,
        this.updatedAt,
        this.id});

  TansactionDetails.fromJson(Map<String, dynamic> json) {
    ewalletId = json['ewallet_id'];
    gatewayOrderId = json['gateway_order_id'];
    transactionId = json['transaction_id'];
    transactionFrom = json['transaction_from'];
    transactionAmount = json['transaction_amount'];
    transactionType = json['transaction_type'];
    transactionStatus = json['transaction_status'];
    createdAt = json['created_at'];
    transactionDescription = json['transaction_description'];
    updatedAt = json['updated_at'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ewallet_id'] = this.ewalletId;
    data['gateway_order_id'] = this.gatewayOrderId;
    data['transaction_id'] = this.transactionId;
    data['transaction_from'] = this.transactionFrom;
    data['transaction_amount'] = this.transactionAmount;
    data['transaction_type'] = this.transactionType;
    data['transaction_status'] = this.transactionStatus;
    data['created_at'] = this.createdAt;
    data['transaction_description'] = this.transactionDescription;
    data['updated_at'] = this.updatedAt;
    data['id'] = this.id;
    return data;
  }
}
