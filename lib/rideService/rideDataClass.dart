

import 'package:google_maps_place_picker/google_maps_place_picker.dart';

class RideDataStore{
  PickResult pickUpLocation;
  PickResult dropLocation;
  double pickLat;
  double pickLng;
  double dropLat;
  double dropLng;
  double price;
  double distance;
  String distanceText;
  String travellingTime;
}