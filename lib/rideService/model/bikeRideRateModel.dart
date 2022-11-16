class BikeRideRateModel {
  bool success;
  Data data;
  String message;

  BikeRideRateModel({this.success, this.data, this.message});

  BikeRideRateModel.fromJson(Map<String, dynamic> json) {
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
  RateCard rateCard;
  String nearestCarrierDistance;
  String pickupToDropDistance;
  String totalDistance;
  String baseFare;
  String totalFare;
  String totalTax;
  String payableAmount;
  String taxPercent;
  int min_negotiable_price;

  Data(
      {this.rateCard,
        this.nearestCarrierDistance,
        this.pickupToDropDistance,
        this.totalDistance,
        this.baseFare,
        this.totalFare,
        this.totalTax,
        this.payableAmount,
        this.taxPercent,
        this.min_negotiable_price,

      });

  Data.fromJson(Map<String, dynamic> json) {
    rateCard = json['rate_card'] != null
        ? new RateCard.fromJson(json['rate_card'])
        : null;
    nearestCarrierDistance = json['nearest_carrier_distance'];
    pickupToDropDistance = json['pickup_to_drop_distance'];
    totalDistance = json['total_distance'];
    baseFare = json['base_fare'];
    totalFare = json['total_fare'];
    totalTax = json['total_tax'];
    payableAmount = json['payable_amount'];
    taxPercent = json['tax_percent'];
    min_negotiable_price = json['min_negotiable_price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.rateCard != null) {
      data['rate_card'] = this.rateCard.toJson();
    }
    data['nearest_carrier_distance'] = this.nearestCarrierDistance;
    data['pickup_to_drop_distance'] = this.pickupToDropDistance;
    data['total_distance'] = this.totalDistance;
    data['base_fare'] = this.baseFare;
    data['total_fare'] = this.totalFare;
    data['total_tax'] = this.totalTax;
    data['payable_amount'] = this.payableAmount;
    data['tax_percent'] = this.taxPercent;
    data['min_negotiable_price'] = this.min_negotiable_price;
    return data;
  }
}

class RateCard {
  int appConfigId;
  String rateChartType;
  String vehicleType;
  String timeFrom;
  String timeTo;
  int uptoKm;
  int pricePerKm;
  String createdAt;
  String updatedAt;

  RateCard(
      {this.appConfigId,
        this.rateChartType,
        this.vehicleType,
        this.timeFrom,
        this.timeTo,
        this.uptoKm,
        this.pricePerKm,
        this.createdAt,
        this.updatedAt});

  RateCard.fromJson(Map<String, dynamic> json) {
    appConfigId = json['app_config_id'];
    rateChartType = json['rate_chart_type'];
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
    data['rate_chart_type'] = this.rateChartType;
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
