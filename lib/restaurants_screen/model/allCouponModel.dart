class AllCouponModel {
  List<Data> data;
  String message;
  int code;

  AllCouponModel({this.data, this.message, this.code});

  AllCouponModel.fromJson(Map<String, dynamic> json) {
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
  int id;
  String couponCode;
  String couponDescription;
  String couponValidFrom;
  String couponValidTo;
  int couponUsageCount;
  String discountType;
  String discountAmount;
  String couponBannerUrl;
  int isVisible;
  List<Categories> categories;
  List<Vendors> vendors;

  Data(
      {this.id,
        this.couponCode,
        this.couponDescription,
        this.couponValidFrom,
        this.couponValidTo,
        this.couponUsageCount,
        this.discountType,
        this.discountAmount,
        this.couponBannerUrl,
        this.isVisible,
        this.categories,
        this.vendors});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    couponCode = json['coupon_code'];
    couponDescription = json['coupon_description'];
    couponValidFrom = json['coupon_valid_from'];
    couponValidTo = json['coupon_valid_to'];
    couponUsageCount = json['coupon_usage_count'];
    discountType = json['discount_type'];
    discountAmount = json['discount_amount'];
    couponBannerUrl = json['coupon_banner_url'];
    isVisible = json['is_visible'];
    if (json['categories'] != null) {
      categories = new List<Categories>();
      json['categories'].forEach((v) {
        categories.add(new Categories.fromJson(v));
      });
    }
    if (json['vendors'] != null) {
      vendors = new List<Vendors>();
      json['vendors'].forEach((v) {
        vendors.add(new Vendors.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['coupon_code'] = this.couponCode;
    data['coupon_description'] = this.couponDescription;
    data['coupon_valid_from'] = this.couponValidFrom;
    data['coupon_valid_to'] = this.couponValidTo;
    data['coupon_usage_count'] = this.couponUsageCount;
    data['discount_type'] = this.discountType;
    data['discount_amount'] = this.discountAmount;
    data['coupon_banner_url'] = this.couponBannerUrl;
    data['is_visible'] = this.isVisible;
    if (this.categories != null) {
      data['categories'] = this.categories.map((v) => v.toJson()).toList();
    }
    if (this.vendors != null) {
      data['vendors'] = this.vendors.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Categories {
  int categoryId;
  String categoryImage;
  String categoryName;

  Categories({this.categoryId, this.categoryImage, this.categoryName});

  Categories.fromJson(Map<String, dynamic> json) {
    categoryId = json['category_id'];
    categoryImage = json['category_image'];
    categoryName = json['category_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['category_id'] = this.categoryId;
    data['category_image'] = this.categoryImage;
    data['category_name'] = this.categoryName;
    return data;
  }
}

class Vendors {
  int vendorId;
  String shopName;
  String address;
  String city;
  String state;
  int zip;
  String mobileNumber;

  Vendors(
      {this.vendorId,
        this.shopName,
        this.address,
        this.city,
        this.state,
        this.zip,
        this.mobileNumber});

  Vendors.fromJson(Map<String, dynamic> json) {
    vendorId = json['vendor_id'];
    shopName = json['shop_name'];
    address = json['address'];
    city = json['city'];
    state = json['state'];
    zip = json['zip'];
    mobileNumber = json['mobile_number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['vendor_id'] = this.vendorId;
    data['shop_name'] = this.shopName;
    data['address'] = this.address;
    data['city'] = this.city;
    data['state'] = this.state;
    data['zip'] = this.zip;
    data['mobile_number'] = this.mobileNumber;
    return data;
  }
}
