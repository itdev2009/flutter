class WalletBalanceModel {
  Data data;
  String message;
  int status;

  WalletBalanceModel({this.data, this.message, this.status});

  WalletBalanceModel.fromJson(Map<String, dynamic> json) {
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
  String ewalletBalance;

  Data({this.ewalletBalance});

  Data.fromJson(Map<String, dynamic> json) {
    ewalletBalance = json['ewallet_balance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ewallet_balance'] = this.ewalletBalance;
    return data;
  }
}
