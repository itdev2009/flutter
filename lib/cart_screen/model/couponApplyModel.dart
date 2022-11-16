class CouponApplyModel {
  Data data;
  String message;
  int code;

  CouponApplyModel({this.data, this.message, this.code});

  CouponApplyModel.fromJson(Map<String, dynamic> json) {
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
  String couponDescription;
  String discountAmount;
  String totalAfterDiscount;
  String taxAmount;
  String totalIncludingTaxWithDiscount;
  String totalIncludingTaxDeliveryFeeWithDiscount;

  Data(
      {this.couponDescription,
        this.discountAmount,
        this.totalAfterDiscount,
        this.taxAmount,
        this.totalIncludingTaxWithDiscount,
        this.totalIncludingTaxDeliveryFeeWithDiscount});

  Data.fromJson(Map<String, dynamic> json) {
    couponDescription = json['coupon_description'];
    discountAmount = json['discount_amount'];
    totalAfterDiscount = json['total_after_discount'];
    taxAmount = json['tax_amount'];
    totalIncludingTaxWithDiscount = json['total_including_tax_with_discount'];
    totalIncludingTaxDeliveryFeeWithDiscount =
    json['total_including_tax_delivery_fee_with_discount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['coupon_description'] = this.couponDescription;
    data['discount_amount'] = this.discountAmount;
    data['total_after_discount'] = this.totalAfterDiscount;
    data['tax_amount'] = this.taxAmount;
    data['total_including_tax_with_discount'] =
        this.totalIncludingTaxWithDiscount;
    data['total_including_tax_delivery_fee_with_discount'] =
        this.totalIncludingTaxDeliveryFeeWithDiscount;
    return data;
  }
}
