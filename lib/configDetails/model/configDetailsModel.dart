class ConfigDetailsModel {
  bool success;
  Data data;
  String message;

  ConfigDetailsModel({this.success, this.data, this.message});

  ConfigDetailsModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    data['message'] = this.message;
    return data;
  }
}

class Data {
  int id;
  int foodCategoryId;
  int maxOrdersPerCarrier;
  int forgotPasswordOtpValidityMins;
  int gst;
  int orderBaseCharge;
  int orderBaseKm;
  int orderExtraPerKmCharge;
  int orderSurcharge;
  int orderContainerCharge;
  String createdAt;
  String updatedAt;
  List<RateChartConfig> rateChartConfig;

  Data(
      {this.id,
        this.foodCategoryId,
        this.maxOrdersPerCarrier,
        this.forgotPasswordOtpValidityMins,
        this.gst,
        this.orderBaseCharge,
        this.orderBaseKm,
        this.orderExtraPerKmCharge,
        this.orderSurcharge,
        this.orderContainerCharge,
        this.createdAt,
        this.updatedAt,
        this.rateChartConfig});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    foodCategoryId = json['food_category_id'];
    maxOrdersPerCarrier = json['max_orders_per_carrier'];
    forgotPasswordOtpValidityMins = json['forgot_password_otp_validity_mins'];
    gst = json['gst'];
    orderBaseCharge = json['order_base_charge'];
    orderBaseKm = json['order_base_km'];
    orderExtraPerKmCharge = json['order_extra_per_km_charge'];
    orderSurcharge = json['order_surcharge'];
    orderContainerCharge = json['order_container_charge'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['rate_chart_config'] != null) {
      rateChartConfig = new List<RateChartConfig>();
      json['rate_chart_config'].forEach((v) {
        rateChartConfig.add(new RateChartConfig.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['food_category_id'] = this.foodCategoryId;
    data['max_orders_per_carrier'] = this.maxOrdersPerCarrier;
    data['forgot_password_otp_validity_mins'] =
        this.forgotPasswordOtpValidityMins;
    data['gst'] = this.gst;
    data['order_base_charge'] = this.orderBaseCharge;
    data['order_base_km'] = this.orderBaseKm;
    data['order_extra_per_km_charge'] = this.orderExtraPerKmCharge;
    data['order_surcharge'] = this.orderSurcharge;
    data['order_container_charge'] = this.orderContainerCharge;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.rateChartConfig != null) {
      data['rate_chart_config'] =
          this.rateChartConfig.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class RateChartConfig {
  int appConfigId;
  String vehicleType;
  String timeFrom;
  String timeTo;
  int uptoKm;
  int pricePerKm;
  String createdAt;
  String updatedAt;

  RateChartConfig(
      {this.appConfigId,
        this.vehicleType,
        this.timeFrom,
        this.timeTo,
        this.uptoKm,
        this.pricePerKm,
        this.createdAt,
        this.updatedAt});

  RateChartConfig.fromJson(Map<String, dynamic> json) {
    appConfigId = json['app_config_id'];
    vehicleType = json['vehicle_type'];
    timeFrom = json['time_from'];
    timeTo = json['time_to'];
    uptoKm = json['upto_km'];
    pricePerKm = json['price_per_km'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['app_config_id'] = this.appConfigId;
    data['vehicle_type'] = this.vehicleType;
    data['time_from'] = this.timeFrom;
    data['time_to'] = this.timeTo;
    data['upto_km'] = this.uptoKm;
    data['price_per_km'] = this.pricePerKm;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
