class RatingModel {
  List<Data> data;
  String message;
  int status;

  RatingModel({this.data, this.message, this.status});

  RatingModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<Data>();
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
      });
    }
    message = json['message'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    data['status'] = this.status;
    return data;
  }
}

class Data {
  String averageRating;
  int totalNumberOfRating;
  String feedbackType;
  String feedbackTypeId;

  Data(
      {this.averageRating,
        this.totalNumberOfRating,
        this.feedbackType,
        this.feedbackTypeId});

  Data.fromJson(Map<String, dynamic> json) {
    averageRating = json['average_rating'];
    totalNumberOfRating = json['total_number_of_rating'];
    feedbackType = json['feedback_type'];
    feedbackTypeId = json['feedback_type_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['average_rating'] = this.averageRating;
    data['total_number_of_rating'] = this.totalNumberOfRating;
    data['feedback_type'] = this.feedbackType;
    data['feedback_type_id'] = this.feedbackTypeId;
    return data;
  }
}
