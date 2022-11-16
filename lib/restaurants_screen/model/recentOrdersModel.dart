class RecentOrdersModel {
  List<Data> data;
  String message;
  int code;

  RecentOrdersModel({this.data, this.message, this.code});

  RecentOrdersModel.fromJson(Map<String, dynamic> json) {
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
  String transactionId;
  String transactionStatus;
  String paymentType;
  Null ewalletId;
  int transactionAmount;
  Null ewalletAmount;
  int codAmount;
  int onlineAmount;
  String createdAt;
  String updatedAt;
  int isAccepted;
  int isAssigned;
  Null couponDescripition;
  int amountBeforeDiscount;
  Null couponCode;
  int cartId;
  int orderAmount;
  int taxAmount;
  int deliveryAmount;
  String deliveryAddress;
  int vendorId;
  int customerId;
  int isActive;
  List<OrderItems> orderItems;

  Data(
      {this.id,
        this.orderId,
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
        this.orderAmount,
        this.taxAmount,
        this.deliveryAmount,
        this.deliveryAddress,
        this.vendorId,
        this.customerId,
        this.isActive,
        this.orderItems});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderId = json['order_id'];
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
    orderAmount = json['order_amount'];
    taxAmount = json['tax_amount'];
    deliveryAmount = json['delivery_amount'];
    deliveryAddress = json['delivery_address'];
    vendorId = json['vendor_id'];
    customerId = json['customer_id'];
    isActive = json['is_active'];
    if (json['order_items'] != null) {
      orderItems = new List<OrderItems>();
      json['order_items'].forEach((v) {
        orderItems.add(new OrderItems.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['order_id'] = this.orderId;
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
    data['order_amount'] = this.orderAmount;
    data['tax_amount'] = this.taxAmount;
    data['delivery_amount'] = this.deliveryAmount;
    data['delivery_address'] = this.deliveryAddress;
    data['vendor_id'] = this.vendorId;
    data['customer_id'] = this.customerId;
    data['is_active'] = this.isActive;
    if (this.orderItems != null) {
      data['order_items'] = this.orderItems.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OrderItems {
  int cartItemId;
  int cartId;
  int skuId;
  int productId;
  int quantity;
  String skuName;
  Null preparationTime;
  String unitPrice;
  String productIdentification;
  String productName;
  String productImage;
  String totalprice;
  String detailedProductImages;
  String productDescription;

  OrderItems(
      {this.cartItemId,
        this.cartId,
        this.skuId,
        this.productId,
        this.quantity,
        this.skuName,
        this.preparationTime,
        this.unitPrice,
        this.productIdentification,
        this.productName,
        this.productImage,
        this.totalprice,
        this.detailedProductImages,
        this.productDescription});

  OrderItems.fromJson(Map<String, dynamic> json) {
    cartItemId = json['cart_item_id'];
    cartId = json['cart_id'];
    skuId = json['sku_id'];
    productId = json['product_id'];
    quantity = json['quantity'];
    skuName = json['sku_name'];
    preparationTime = json['preparation_time'];
    unitPrice = json['unit_price'];
    productIdentification = json['product_identification'];
    productName = json['product_name'];
    productImage = json['product_image'];
    totalprice = json['totalprice'];
    detailedProductImages = json['detailed_product_images'];
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
    data['preparation_time'] = this.preparationTime;
    data['unit_price'] = this.unitPrice;
    data['product_identification'] = this.productIdentification;
    data['product_name'] = this.productName;
    data['product_image'] = this.productImage;
    data['totalprice'] = this.totalprice;
    data['detailed_product_images'] = this.detailedProductImages;
    data['product_description'] = this.productDescription;
    return data;
  }
}
