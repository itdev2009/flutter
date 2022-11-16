import 'dart:async';
import 'package:delivery_on_time/help/api_response.dart';
import 'package:delivery_on_time/ratingScreen/model/ratingModel.dart';
import 'package:delivery_on_time/ratingScreen/repository/ratingRepository.dart';

class RatingBloc {

  RatingRepository _ratingRepository;

  StreamController _ratingController;

  StreamSink<ApiResponse<RatingModel>> get ratingSink =>
      _ratingController.sink;

  Stream<ApiResponse<RatingModel>> get ratingStream =>
      _ratingController.stream;


  RatingBloc() {
    _ratingController = StreamController<ApiResponse<RatingModel>>.broadcast();
    _ratingRepository = RatingRepository();
  }

  rating(Map body, String token) async {
    ratingSink.add(ApiResponse.loading("Submitting",));
    try {
      RatingModel response = await _ratingRepository.rating(body, "Bearer $token");
      ratingSink.add(ApiResponse.completed(response));
    } catch (e) {
      ratingSink.add(ApiResponse.error(e.toString()));
      print(e);
    }
  }


  dispose() {
    _ratingController?.close();
    ratingSink?.close();
  }
}