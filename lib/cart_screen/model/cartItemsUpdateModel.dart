class CartItemsUpdateModel {
  Data data;
  String message;
  int status;

  CartItemsUpdateModel({this.data, this.message, this.status});

  CartItemsUpdateModel.fromJson(Map<String, dynamic> json) {
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
  List<CartItems> cartItems;
  int cartItemCount;
  String packingCharges;
  int orderSurcharge;
  String cartAmount;
  String cartTotalAmount;
  int gst;
  String taxAmount;
  String totalIncludingTax;
  String deliveryFee;
  String totalIncludingTaxDelivery;
  String totalAfterDiscount;

  Data(
      {this.cartItems,
        this.cartItemCount,
        this.packingCharges,
        this.orderSurcharge,
        this.cartAmount,
        this.cartTotalAmount,
        this.gst,
        this.taxAmount,
        this.totalIncludingTax,
        this.deliveryFee,
        this.totalIncludingTaxDelivery,
        this.totalAfterDiscount});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['cart_items'] != null) {
      cartItems = new List<CartItems>();
      json['cart_items'].forEach((v) {
        cartItems.add(new CartItems.fromJson(v));
      });
    }
    cartItemCount = json['cart_item_count'];
    packingCharges = json['packing_charges'];
    orderSurcharge = json['order_surcharge'];
    cartAmount = json['cart_amount'];
    cartTotalAmount = json['cart_total_amount'];
    gst = json['gst'];
    taxAmount = json['tax_amount'];
    totalIncludingTax = json['total_including_tax'];
    deliveryFee = json['delivery_fee'];
    totalIncludingTaxDelivery = json['total_including_tax_delivery'];
    totalAfterDiscount = json['total_after_discount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.cartItems != null) {
      data['cart_items'] = this.cartItems.map((v) => v.toJson()).toList();
    }
    data['cart_item_count'] = this.cartItemCount;
    data['packing_charges'] = this.packingCharges;
    data['order_surcharge'] = this.orderSurcharge;
    data['cart_amount'] = this.cartAmount;
    data['cart_total_amount'] = this.cartTotalAmount;
    data['gst'] = this.gst;
    data['tax_amount'] = this.taxAmount;
    data['total_including_tax'] = this.totalIncludingTax;
    data['delivery_fee'] = this.deliveryFee;
    data['total_including_tax_delivery'] = this.totalIncludingTaxDelivery;
    data['total_after_discount'] = this.totalAfterDiscount;
    return data;
  }
}

class CartItems {
  int cartItemId;
  int cartId;
  int skuId;
  int productId;
  int quantity;
  String skuName;
  String preparationTime;
  int isOutOfStock;
  String unitPrice;
  String productIdentification;
  String productName;
  String productImage;
  int maxNoOfUnitPerPackage;
  int packingCharges;
  String totalprice;
  String detailedProductImages;
  String productDescription;

  CartItems(
      {this.cartItemId,
        this.cartId,
        this.skuId,
        this.productId,
        this.quantity,
        this.skuName,
        this.preparationTime,
        this.isOutOfStock,
        this.unitPrice,
        this.productIdentification,
        this.productName,
        this.productImage,
        this.maxNoOfUnitPerPackage,
        this.packingCharges,
        this.totalprice,
        this.detailedProductImages,
        this.productDescription});

  CartItems.fromJson(Map<String, dynamic> json) {
    cartItemId = json['cart_item_id'];
    cartId = json['cart_id'];
    skuId = json['sku_id'];
    productId = json['product_id'];
    quantity = json['quantity'];
    skuName = json['sku_name'];
    preparationTime = json['preparation_time'];
    isOutOfStock = json['is_out_of_stock'];
    unitPrice = json['unit_price'];
    productIdentification = json['product_identification'];
    productName = json['product_name'];
    productImage = json['product_image'];
    maxNoOfUnitPerPackage = json['max_no_of_unit_per_package'];
    packingCharges = json['packing_charges'];
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
    data['is_out_of_stock'] = this.isOutOfStock;
    data['unit_price'] = this.unitPrice;
    data['product_identification'] = this.productIdentification;
    data['product_name'] = this.productName;
    data['product_image'] = this.productImage;
    data['max_no_of_unit_per_package'] = this.maxNoOfUnitPerPackage;
    data['packing_charges'] = this.packingCharges;
    data['totalprice'] = this.totalprice;
    data['detailed_product_images'] = this.detailedProductImages;
    data['product_description'] = this.productDescription;
    return data;
  }
}
