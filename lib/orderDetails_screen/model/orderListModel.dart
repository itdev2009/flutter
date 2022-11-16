class OrderListModel {
  List<Data> data;
  String message;
  int code;

  OrderListModel({this.data, this.message, this.code});

  OrderListModel.fromJson(Map<String, dynamic> json) {
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
  int orderId;
  Vendor vendor;
  String orderStatus;
  int carrierId;
  String carrierName;
  String carrierMobileNumber;
  String carrierEmail;
  String transactionId;
  String transactionStatus;
  String paymentType;
  int ewalletId;
  String transactionAmount;
  String ewalletAmount;
  String codAmount;
  String onlineAmount;
  String createdAt;
  String updatedAt;
  int isAccepted;
  int isAssigned;
  String couponDescripition;
  String amountBeforeDiscount;
  String couponCode;
  int cartId;
  List<ItemDetails> itemDetails;
  String orderAmount;
  String taxAmount;
  String deliveryAmount;
  String deliveryAddress;
  int vendorId;
  int customerId;
  int isActive;

  Data(
      {this.id,
        this.orderId,
        this.vendor,
        this.orderStatus,
        this.carrierId,
        this.carrierName,
        this.carrierMobileNumber,
        this.carrierEmail,
        this.transactionId,
        this.transactionStatus,
        this.paymentType,
        this.ewalletId,
        this.transactionAmount,
        this.ewalletAmount,
        this.codAmount,
        this.onlineAmount,
        this.createdAt,
        this.updatedAt,
        this.isAccepted,
        this.isAssigned,
        this.couponDescripition,
        this.amountBeforeDiscount,
        this.couponCode,
        this.cartId,
        this.itemDetails,
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
    vendor =
    json['vendor'] != null ? new Vendor.fromJson(json['vendor']) : null;
    orderStatus = json['order_status'];
    carrierId = json['carrier_id'];
    carrierName = json['carrier_name'];
    carrierMobileNumber = json['carrier_mobile_number'];
    carrierEmail = json['carrier_email'];
    transactionId = json['transaction_id'];
    transactionStatus = json['transaction_status'];
    paymentType = json['payment_type'];
    ewalletId = json['ewallet_id'];
    transactionAmount = json['transaction_amount'];
    ewalletAmount = json['ewallet_amount'];
    codAmount = json['cod_amount'];
    onlineAmount = json['online_amount'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    isAccepted = json['is_accepted'];
    isAssigned = json['is_assigned'];
    couponDescripition = json['coupon_descripition'];
    amountBeforeDiscount = json['amount_before_discount'];
    couponCode = json['coupon_code'];
    cartId = json['cart_id'];
    if (json['item_details'] != null) {
      itemDetails = new List<ItemDetails>();
      json['item_details'].forEach((v) {
        itemDetails.add(new ItemDetails.fromJson(v));
      });
    }
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
    if (this.vendor != null) {
      data['vendor'] = this.vendor.toJson();
    }
    data['order_status'] = this.orderStatus;
    data['carrier_id'] = this.carrierId;
    data['carrier_name'] = this.carrierName;
    data['carrier_mobile_number'] = this.carrierMobileNumber;
    data['carrier_email'] = this.carrierEmail;
    data['transaction_id'] = this.transactionId;
    data['transaction_status'] = this.transactionStatus;
    data['payment_type'] = this.paymentType;
    data['ewallet_id'] = this.ewalletId;
    data['transaction_amount'] = this.transactionAmount;
    data['ewallet_amount'] = this.ewalletAmount;
    data['cod_amount'] = this.codAmount;
    data['online_amount'] = this.onlineAmount;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['is_accepted'] = this.isAccepted;
    data['is_assigned'] = this.isAssigned;
    data['coupon_descripition'] = this.couponDescripition;
    data['amount_before_discount'] = this.amountBeforeDiscount;
    data['coupon_code'] = this.couponCode;
    data['cart_id'] = this.cartId;
    if (this.itemDetails != null) {
      data['item_details'] = this.itemDetails.map((v) => v.toJson()).toList();
    }
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

class Vendor {
  int id;
  String shopName;
  String mobileNumber;
  int mobileVerifiedFlag;
  String mobileVerifiedToken;
  String mobileVerifiedAt;
  String address;
  String city;
  String state;
  int zip;
  String longitude;
  String latitude;
  String vendorImage;
  int categoryId;
  String createdAt;
  String updatedAt;
  String availableFrom;
  String availableTo;
  int isActive;
  int parentId;
  int vendorId;

  Vendor(
      {this.id,
        this.shopName,
        this.mobileNumber,
        this.mobileVerifiedFlag,
        this.mobileVerifiedToken,
        this.mobileVerifiedAt,
        this.address,
        this.city,
        this.state,
        this.zip,
        this.longitude,
        this.latitude,
        this.vendorImage,
        this.categoryId,
        this.createdAt,
        this.updatedAt,
        this.availableFrom,
        this.availableTo,
        this.isActive,
        this.parentId,
        this.vendorId});

  Vendor.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    shopName = json['shop_name'];
    mobileNumber = json['mobile_number'];
    mobileVerifiedFlag = json['mobile_verified_flag'];
    mobileVerifiedToken = json['mobile_verified_token'];
    mobileVerifiedAt = json['mobile_verified_at'];
    address = json['address'];
    city = json['city'];
    state = json['state'];
    zip = json['zip'];
    longitude = json['longitude'];
    latitude = json['latitude'];
    vendorImage = json['vendor_image'];
    categoryId = json['category_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    availableFrom = json['available_from'];
    availableTo = json['available_to'];
    isActive = json['is_active'];
    parentId = json['parent_id'];
    vendorId = json['vendor_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['shop_name'] = this.shopName;
    data['mobile_number'] = this.mobileNumber;
    data['mobile_verified_flag'] = this.mobileVerifiedFlag;
    data['mobile_verified_token'] = this.mobileVerifiedToken;
    data['mobile_verified_at'] = this.mobileVerifiedAt;
    data['address'] = this.address;
    data['city'] = this.city;
    data['state'] = this.state;
    data['zip'] = this.zip;
    data['longitude'] = this.longitude;
    data['latitude'] = this.latitude;
    data['vendor_image'] = this.vendorImage;
    data['category_id'] = this.categoryId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['available_from'] = this.availableFrom;
    data['available_to'] = this.availableTo;
    data['is_active'] = this.isActive;
    data['parent_id'] = this.parentId;
    data['vendor_id'] = this.vendorId;
    return data;
  }
}

class ItemDetails {
  int cartItemId;
  int cartId;
  int skuId;
  int productId;
  int quantity;
  String skuName;
  int vendorId;
  String preparationTime;
  int isOutOfStock;
  String unitPrice;
  String productIdentification;
  String productName;
  String productImage;
  String totalprice;
  String detailedProductImages;
  String vendorName;
  String productDescription;

  ItemDetails(
      {this.cartItemId,
        this.cartId,
        this.skuId,
        this.productId,
        this.quantity,
        this.skuName,
        this.vendorId,
        this.preparationTime,
        this.isOutOfStock,
        this.unitPrice,
        this.productIdentification,
        this.productName,
        this.productImage,
        this.totalprice,
        this.detailedProductImages,
        this.vendorName,
        this.productDescription});

  ItemDetails.fromJson(Map<String, dynamic> json) {
    cartItemId = json['cart_item_id'];
    cartId = json['cart_id'];
    skuId = json['sku_id'];
    productId = json['product_id'];
    quantity = json['quantity'];
    skuName = json['sku_name'];
    vendorId = json['vendor_id'];
    preparationTime = json['preparation_time'];
    isOutOfStock = json['is_out_of_stock'];
    unitPrice = json['unit_price'];
    productIdentification = json['product_identification'];
    productName = json['product_name'];
    productImage = json['product_image'];
    totalprice = json['totalprice'];
    detailedProductImages = json['detailed_product_images'];
    vendorName = json['vendor_name'];
    productDescription = json['product_description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cart_item_id'] = this.cartItemId;
    data['cart_id'] = this.cartId;
    data['sku_id'] = this.skuId;
    data['product_id'] = this.productId;
    data['quantity'] = this.quantity;
    data['sku_name'] = this.skuName;
    data['vendor_id'] = this.vendorId;
    data['preparation_time'] = this.preparationTime;
    data['is_out_of_stock'] = this.isOutOfStock;
    data['unit_price'] = this.unitPrice;
    data['product_identification'] = this.productIdentification;
    data['product_name'] = this.productName;
    data['product_image'] = this.productImage;
    data['totalprice'] = this.totalprice;
    data['detailed_product_images'] = this.detailedProductImages;
    data['vendor_name'] = this.vendorName;
    data['product_description'] = this.productDescription;
    return data;
  }
}
