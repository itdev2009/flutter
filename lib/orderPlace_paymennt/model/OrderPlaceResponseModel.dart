class OrderPlaceResponseModel {
  Data data;
  String message;
  int code;

  OrderPlaceResponseModel({this.data, this.message, this.code});

  OrderPlaceResponseModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    message = json['message'];
    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    data['message'] = this.message;
    data['code'] = this.code;
    return data;
  }
}

class Data {
  String couponCode;
  String couponDescripition;
  String amount;
  String ewalletAmount;
  String codAmount;
  String onlineAmount;
  String name;
  String email;
  String phone;
  String orderid;
  String userid;
  String cartid;
  String deliveryAddress;
  String transactionId;
  int id;
  String paymentType;

  Data(
      {this.couponCode,
        this.couponDescripition,
        this.amount,
        this.ewalletAmount,
        this.codAmount,
        this.onlineAmount,
        this.name,
        this.email,
        this.phone,
        this.orderid,
        this.userid,
        this.cartid,
        this.deliveryAddress,
        this.transactionId,
        this.id,
        this.paymentType});

  Data.fromJson(Map<String, dynamic> json) {
    couponCode = json['coupon_code'];
    couponDescripition = json['coupon_descripition'];
    amount = json['amount'];
    ewalletAmount = json['ewallet_amount'];
    codAmount = json['cod_amount'];
    onlineAmount = json['online_amount'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    orderid = json['orderid'];
    userid = json['userid'];
    cartid = json['cartid'];
    deliveryAddress = json['delivery_address'];
    transactionId = json['transaction_id'];
    id = json['id'];
    paymentType = json['payment_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['coupon_code'] = this.couponCode;
    data['coupon_descripition'] = this.couponDescripition;
    data['amount'] = this.amount;
    data['ewallet_amount'] = this.ewalletAmount;
    data['cod_amount'] = this.codAmount;
    data['online_amount'] = this.onlineAmount;
    data['name'] = this.name;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['orderid'] = this.orderid;
    data['userid'] = this.userid;
    data['cartid'] = this.cartid;
    data['delivery_address'] = this.deliveryAddress;
    data['transaction_id'] = this.transactionId;
    data['id'] = this.id;
    data['payment_type'] = this.paymentType;
    return data;
  }
}
