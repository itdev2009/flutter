class CartItemsEmptyModel {
  Data data;
  String message;
  int status;

  CartItemsEmptyModel({this.data, this.message, this.status});

  CartItemsEmptyModel.fromJson(Map<String, dynamic> json) {
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
  String cartid;

  Data({this.cartid});

  Data.fromJson(Map<String, dynamic> json) {
    cartid = json['cartid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cartid'] = this.cartid;
    return data;
  }
}
