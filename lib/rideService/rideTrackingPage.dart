import 'dart:async';
import 'dart:typed_data';

import 'package:delivery_on_time/help/api_response.dart';
import 'package:delivery_on_time/orderDetails_screen/orderListPage.dart';
import 'package:delivery_on_time/pickup_drop_screen/model/mapDistanceModel.dart';
import 'package:delivery_on_time/rideService/model/bikeRideCancelModel.dart';
import 'package:delivery_on_time/rideService/model/rideBookingDetailsModel.dart';
import 'package:delivery_on_time/rideService/repository/bikeRideRepository.dart';
import 'package:delivery_on_time/rideService/rideBookingList.dart';
import 'package:delivery_on_time/screens/home.dart';
import 'package:delivery_on_time/screens/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants.dart';
import 'bloc/bikeRideCancelBloc.dart';

class RideTrackingPage extends StatefulWidget {
  final int rideId;
  final String userToken;

  const RideTrackingPage({Key key, this.rideId, this.userToken}) : super(key: key);

  @override
  _RideTrackingPageState createState() => _RideTrackingPageState();
}

class _RideTrackingPageState extends State<RideTrackingPage> {
  Future<RideBookingDetailsModel> _bikeTrackingFuture;
  Future<MapDistanceModel> _rideDistanceFuture;
  BikeRideRepository _bikeRideRepository;
  BikRideCancelBloc _bikRideCancelBloc;

  GoogleMapController mapController;
  Map<PolylineId, Polyline> polylines = {};
  Map<MarkerId, Marker> markers = {};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  LocationData availableBikeLocation;

  String googleAPiKey = mapAPIKey;
  Uint8List carImage;
  Uint8List bikeImage;
  Uint8List pickupIcon;
  Uint8List dropIcon;
  CameraPosition initialCameraPosition;

  bool bikerUpdateCheck = true;
  bool rideDistanceUpdateCheck = true;
  bool oneTimeBikerUpdate = true;
  bool initdispose = true;

  Timer timer;

  double pickLat = 0;
  double pickLng = 0;
  double dropLat = 0;
  double dropLng = 0;
  double carrierLat = 0;
  double carrierLng = 0;

  @override
  void initState() {
    super.initState();
    _bikeRideRepository = BikeRideRepository();
    _bikRideCancelBloc = BikRideCancelBloc();
    _bikeTrackingFuture = _bikeRideRepository.rideTracking(widget.rideId, widget.userToken);
    _getBikerMarkerImage();
    setUpTimedFetch();
  }

  setUpTimedFetch() async {
    if (initdispose) {
      timer = Timer.periodic(Duration(milliseconds: 10000), (timer) {
        setState(() {
          bikerUpdateCheck = true;
          rideDistanceUpdateCheck = true;
          _bikeTrackingFuture = _bikeRideRepository.rideTracking(widget.rideId, widget.userToken);
        });
        Future.delayed(Duration(seconds: 3), () {
          setState(() {
            bikerUpdateCheck = true;
          });
        });
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    initdispose = false;
    timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: FutureBuilder<RideBookingDetailsModel>(
            future: _bikeTrackingFuture,
              builder: (context, snapshot) {
              if (snapshot.hasData) {
                carrierLat = double.parse(snapshot.data.data.carrier.latitude);
                carrierLng = double.parse(snapshot.data.data.carrier.longitude);

                if (oneTimeBikerUpdate) {
                  pickLat = double.parse(snapshot.data.data.pickupLatitude);
                  pickLng = double.parse(snapshot.data.data.pickupLongitude);
                  dropLat = double.parse(snapshot.data.data.dropLatitude);
                  dropLng = double.parse(snapshot.data.data.dropLongitude);

                  initialCameraPosition = CameraPosition(target: LatLng((pickLat + dropLat) / 2, (pickLng + dropLng) / 2), zoom: 12);

                  /// origin marker
                  _addMarker(LatLng(pickLat, pickLng), "origin", BitmapDescriptor.fromBytes(pickupIcon));

                  /// destination marker
                  _addMarker(LatLng(dropLat, dropLng), "destination", BitmapDescriptor.fromBytes(dropIcon));

                  oneTimeBikerUpdate = false;
                }

                if (bikerUpdateCheck) {
                  if (snapshot.data.data.status == "IN_TRANSIT" ) {
                    if (rideDistanceUpdateCheck) {
                      _rideDistanceFuture = _bikeRideRepository.rideDistanceCalculate(carrierLat, carrierLng, dropLat, dropLng);
                      rideDistanceUpdateCheck = false;
                    }
                    initialCameraPosition = CameraPosition(target: LatLng(carrierLat, carrierLng), zoom: 14);

                    _getPolyline(carrierLat, carrierLng, dropLat, dropLng);
                  } else if (snapshot.data.data.status == "ASSIGNED" || snapshot.data.data.status == "ACCEPTED") {
                    if (rideDistanceUpdateCheck) {
                      _rideDistanceFuture = _bikeRideRepository.rideDistanceCalculate(carrierLat, carrierLng, pickLat, pickLng);
                      rideDistanceUpdateCheck = false;
                    }
                    initialCameraPosition = CameraPosition(target: LatLng(carrierLat, carrierLng), zoom: 14);

                    _getPolyline(carrierLat, carrierLng, pickLat, pickLng);
                  }else if (snapshot.data.data.status == "DROPPED") {
                    Future.delayed(Duration.zero,(){
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (BuildContext context) => HomePage()),
                          ModalRoute.withName('/home')
                      );
                    });
                    Fluttertoast.showToast(
                        msg: "Thank you for taking ride from us.",
                        fontSize: 14,
                        backgroundColor: Colors.orange[100],
                        textColor: darkThemeBlue,
                        toastLength: Toast.LENGTH_LONG);
                  }else if (snapshot.data.data.status == "DECLINED") {
                    Future.delayed(Duration.zero,(){
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (BuildContext context) => HomeController(currentIndex: 0,)),
                          ModalRoute.withName('/home')
                      );
                    });
                    Fluttertoast.showToast(
                        msg: "Rider has declined your booking.\nWe are sorry for the inconvenience",
                        fontSize: 13,
                        backgroundColor: Colors.orange[100],
                        textColor: darkThemeBlue,
                        toastLength: Toast.LENGTH_LONG);
                  }

                  Map<String, double> mapData = {"latitude": carrierLat, "longitude": carrierLng};
                  availableBikeLocation = new LocationData.fromMap(mapData);

                  _updateBikerMarkerAndCircle(availableBikeLocation, snapshot.data.data.id.toString(), snapshot.data.data.carrier.vehicle_type == '2W' ? bikeImage: carImage);

                  bikerUpdateCheck = false;
                }

                return Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                            // margin: EdgeInsets.only(top: screenHeight * 0.007, right: screenHeight * 0.007, left: screenHeight * 0.007),
                            height: screenHeight * 0.55,
                            // width: screenWidth * 0.985,
                            child: GoogleMap(
                              myLocationEnabled: false,
                              compassEnabled: false,
                              myLocationButtonEnabled: false,
                              zoomControlsEnabled: false,
                              mapToolbarEnabled: false,
                              trafficEnabled: false,
                              mapType: MapType.normal,
                              initialCameraPosition: initialCameraPosition,
                              markers: Set<Marker>.of(markers.values),
                              polylines: Set<Polyline>.of(polylines.values),
                              onMapCreated: (GoogleMapController controller) {
                                mapController = controller;
                              },
                            )),
                        Positioned(
                          top: 17,
                          left: 17,
                          child: InkWell(
                              onTap: () {
                                //Navigator.pop(context);
                                //SystemNavigator.pop();

                                SystemNavigator.pop();
                              },
                              child: Card(
                                elevation: 10,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                color: Colors.white.withOpacity(0),
                                child: CircleAvatar(
                                  child: Icon(
                                    Icons.arrow_back_sharp,
                                    color: Colors.black,
                                  ),
                                  radius: 18,
                                  backgroundColor: Colors.white.withOpacity(0.8),
                                ),
                              )),
                        ),
                        Positioned(
                          bottom: 20,
                          right: 18,
                          child: InkWell(
                            onTap: () {
                              // mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
                              //     target: LatLng((rideDataStore.pickLat + rideDataStore.dropLat) / 2,
                              //         (rideDataStore.pickLng + rideDataStore.dropLng) / 2),
                              //     zoom: 12)));
                            },
                            child: Card(
                              elevation: 10,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: CircleAvatar(
                                child: Icon(
                                  Icons.zoom_out_map,
                                  color: Colors.black,
                                  size: 22,
                                ),
                                radius: 20,
                                backgroundColor: Colors.white.withOpacity(1),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: Container(
                        // height: screenHeight*0.4,
                        decoration: BoxDecoration(
                            boxShadow: [BoxShadow(spreadRadius: 5, blurRadius: 15, offset: Offset(0, -2), color: Colors.black38)]),
                        child: ListView(
                          shrinkWrap: true,
                          children: [
                            Container(
                              color: Colors.white,
                              padding: EdgeInsets.fromLTRB(15.0, 18.0, 14.0, 18.0),
                              child: Row(
                                children: [
                                  Text(
                                      "${!(snapshot.data.data.status == "ACCEPTED") ? "Ride is coming at \npickup point" : "Enjoy Your Ride"}",
                                      style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w500),overflow: TextOverflow.ellipsis,),
                                  Spacer(),
                                  FutureBuilder<MapDistanceModel>(
                                      future: _rideDistanceFuture,
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          if (snapshot.data.rows[0].elements[0].status == "ZERO_RESULTS") {
                                            return Text("No Data Found");
                                          } else {
                                            return Container(
                                                width: 100,
                                                padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
                                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.0), color: orangeCol),
                                                child: Column(
                                                  children: [
                                                    Text(
                                                      snapshot.data.rows[0].elements[0].distance.text,
                                                      style: GoogleFonts.poppins(
                                                          fontSize: 13, color: Colors.white, fontWeight: FontWeight.w500),
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                    Divider(
                                                      color: Colors.white,
                                                      height: 5,
                                                    ),
                                                    Text(
                                                      snapshot.data.rows[0].elements[0].duration.text,
                                                      style: GoogleFonts.poppins(
                                                          fontSize: 13, color: Colors.white, fontWeight: FontWeight.w500),
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                  ],
                                                ));
                                          }
                                        } else if (snapshot.hasError) {
                                          print(snapshot.error);
                                          return Text("");
                                        } else
                                          return Padding(
                                            padding: EdgeInsets.fromLTRB(30.0, 0.0, 20.0, 15.0),
                                            child: JumpingDotsProgressIndicator(
                                              numberOfDots: 5,
                                              fontSize: 22.0,
                                              milliseconds: 250,
                                              dotSpacing: 0.2,
                                            ),
                                          );
                                      }),
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.fromLTRB(14.0, 18.0, 14.0, 18.0),
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(color: Colors.black26, width: 0.5),
                                      top: BorderSide(color: Colors.black26, width: 0.5)),
                                  color: Colors.white),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    children: [
                                      Stack(
                                        // fit: StackFit.loose,
                                        //overflow: Overflow.visible,
                                      clipBehavior: Clip.none,
                                        children: [
                                          Positioned(
                                            left: screenWidth * 0.11,
                                            top: screenWidth * 0.02,
                                            child: snapshot.data.data.carrier.vehicle_type == '2W' ? Image.asset("assets/images/icons/bikeRide_icon/bike_image04.png") : Image.asset('assets/images/icons/bikeRide_icon/car_png.png'),
                                            width: screenWidth * 0.19,
                                          ),
                                          Container(
                                            // margin: EdgeInsets.only(top: 20,bottom: 20),
                                            padding: EdgeInsets.all(3),
                                            height: screenWidth * 0.16,
                                            width: screenWidth * 0.16,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              shape: BoxShape.circle,
                                            ),
                                            child: Container(
                                              height: screenWidth * 0.15,
                                              width: screenWidth * 0.15,
                                              clipBehavior: Clip.hardEdge,
                                              decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                                              child: FadeInImage(
                                                height: screenWidth * 0.095,
                                                width: screenWidth * 0.095,
                                                image: NetworkImage(
                                                  "$imageBaseURL${snapshot.data.data.carrier.proofPhoto}",
                                                ),
                                                placeholder: AssetImage("assets/images/icons/profile.png"),
                                                fit: BoxFit.fill,
                                              ),
                                              // child: Image.asset("asset/blank-profile-picture-973460_1280.webp")
                                            ),
                                          ),
                                        ],
                                      ),
                                      Spacer(),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Text("${snapshot.data.data.carrier.vehicle_no}",
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.poppins(fontSize: 14, color: Colors.black, fontWeight: FontWeight.w400)),
                                          SizedBox(
                                            height: 3,
                                          ),
                                          Text("${snapshot.data.data.carrier.vehicle_make}",
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.poppins(fontSize: 18, color: Colors.black, fontWeight: FontWeight.w500)),
                                          Text("${snapshot.data.data.carrier.user.name}",
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.poppins(fontSize: 13, color: Colors.black, fontWeight: FontWeight.w400)),


                                          //${snapshot.data.data.payableAmount}
                                          SizedBox(
                                            height: 1,
                                          ),
                                          Text("Trip Charge : ₹ ${snapshot.data.data.payableAmount}",
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.poppins(fontSize: 13, color: Colors.black, fontWeight: FontWeight.w400)),
                                        ],
                                      ),
                                    ],
                                  ),

                                  //new row here


                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                                    child: Row(
                                      children: [
                                        SizedBox(
                                           width: screenWidth*0.20,
                                          child: ButtonTheme(
                                            /*__To Enlarge Button Size__*/

                                            padding: EdgeInsets.only(left:2),
                                            height: 40.0,
                                            minWidth: screenWidth * 0.28,
                                            child: RaisedButton(
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(10.0),
                                              ),
                                              onPressed: () {
                                                launch('tel: ${snapshot.data.data.carrier.user.mobileNumber}');
                                              },
                                              color: orangeCol,
                                              textColor: Colors.white,
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.call,
                                                    size: screenWidth*0.04,
                                                  ),
                                                  Text("  Contact", style: GoogleFonts.poppins(fontSize: screenWidth*0.030, fontWeight: FontWeight.w500)),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        Spacer(),
                                        SizedBox(
                                          width: screenWidth*0.20,
                                          child: ButtonTheme(
                                            /*__To Enlarge Button Size__*/
                                            padding: EdgeInsets.only(left:2),
                                            height: 40.0,
                                            minWidth: screenWidth * 0.28,
                                            child: RaisedButton(
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(10.0),
                                              ),
                                              onPressed: () async {
                                                const url = 'https://wa.me/918800440394';
                                                if (await canLaunch(url)) {
                                                  await launch(url);
                                                } else {
                                                  throw 'Could not launch $url';
                                                }
                                              },
                                              color: orangeCol,
                                              textColor: Colors.white,
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Image.asset(
                                                    "assets/images/icons/support.png",
                                                    height: screenWidth*0.04,
                                                  ),
                                                  Text("  Support", style: GoogleFonts.poppins(fontSize: screenWidth*0.030, fontWeight: FontWeight.w500)),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        Spacer(),
                                        SizedBox(
                                          width: screenWidth*0.20,
                                          child: ButtonTheme(
                                            /*__To Enlarge Button Size__*/
                                            padding: EdgeInsets.only(left:2),
                                            height: 40.0,
                                            minWidth: screenWidth * 0.28,
                                            child: RaisedButton(
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(10.0),
                                              ),
                                              onPressed: (){

                                                if(snapshot.data.data.status == 'ACCEPTED'){
                                                  showCancelModalSheet();
                                                }else
                                                  Fluttertoast.showToast(
                                                      msg: "You can't cancel this ride now.",
                                                      fontSize: 14,
                                                      backgroundColor: Colors.orange[100],
                                                      textColor: darkThemeBlue,
                                                      toastLength: Toast.LENGTH_LONG);
                                              },
                                              color: orangeCol,
                                              textColor: Colors.white,
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.cancel_outlined,
                                                    size: screenWidth*0.042,
                                                  ),
                                                  Text("  Cancel", style: GoogleFonts.poppins(fontSize: screenWidth*0.030, fontWeight: FontWeight.w500)),

                                                ],
                                              ),
                                            ),
                                          ),
                                        ),

                                        Spacer(),

                                        SizedBox(
                                          width: screenWidth*0.20,
                                          child: ButtonTheme(
                                            /*__To Enlarge Button Size__*/
                                            padding: EdgeInsets.only(left:0),
                                            height: 40.0,
                                            minWidth: screenWidth * 0.28,
                                            child: RaisedButton(
                                                  shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(10.0),
                                              ),
                                              onPressed: () {
                                                //launch('tel: ${snapshot.data.data.carrier.user.mobileNumber}');
                                                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                                  return RideBookingList();
                                                }));
                                              },
                                              color: orangeCol,
                                              textColor: Colors.white,
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.electric_bike_sharp,
                                                    size: screenWidth*0.04,
                                                  ),
                                                  Text("  Trip History", style: GoogleFonts.poppins(fontSize: screenWidth*0.026, fontWeight: FontWeight.w500)),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),




                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.fromLTRB(8.0, 14.0, 15.0, 12.0),
                              decoration:
                                  BoxDecoration(border: Border(bottom: BorderSide(color: Colors.black45, width: 0.5)), color: Colors.white),
                              height: 100,
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Column(
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Image.asset("assets/images/icons/bikeRide_icon/pin_green_round.png"),
                                        ),
                                        Expanded(
                                            flex: 2,
                                            child: VerticalDivider(
                                              color: Colors.black,
                                              thickness: 0.8,
                                              indent: 4,
                                              endIndent: 4,
                                            )),
                                        Expanded(
                                          flex: 1,
                                          child: Image.asset("assets/images/icons/bikeRide_icon/pin_red_round.png"),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 7,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Text("${snapshot.data.data.pickupAddress}",
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.poppins(fontSize: 13, color: Colors.black, fontWeight: FontWeight.w400)),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Divider(
                                            color: Colors.black45,
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Text("${snapshot.data.data.dropAddress}",
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.poppins(fontSize: 13, color: Colors.black, fontWeight: FontWeight.w400)),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              } else if (snapshot.hasError) {
                print(snapshot.error);
                return Text("No Data Found");
              } else
                return Center(
                  child: CircularProgressIndicator(
                      backgroundColor: circularBGCol, strokeWidth: 4, valueColor: AlwaysStoppedAnimation<Color>(circularStrokeCol)),
                );
            }),
      ),
    );
  }

  Future<void> _getBikerMarkerImage() async {
    // ByteData byteData = await DefaultAssetBundle.of(context).load("assets/images/icons/bike_icon3.png");
    ByteData byteBikeIconData01 = await DefaultAssetBundle.of(context).load("assets/images/icons/bikeRide_icon/bike1.png");
    bikeImage = byteBikeIconData01.buffer.asUint8List();
    ByteData byteDataPickup = await DefaultAssetBundle.of(context).load("assets/images/icons/bikeRide_icon/pin_green_round.png");
    pickupIcon = byteDataPickup.buffer.asUint8List();
    ByteData byteDataDrop = await DefaultAssetBundle.of(context).load("assets/images/icons/bikeRide_icon/pin_red_round.png");
    dropIcon = byteDataDrop.buffer.asUint8List();
    ByteData byteDataCar = await DefaultAssetBundle.of(context).load("assets/images/icons/bikeRide_icon/car_png.png");
    carImage = byteDataCar.buffer.asUint8List();
  }

  _addMarker(LatLng position, String id, BitmapDescriptor descriptor) {
    MarkerId markerId = MarkerId(id);
    Marker marker = Marker(markerId: markerId, icon: descriptor, position: position);
    markers[markerId] = marker;
  }

  void _updateBikerMarkerAndCircle(LocationData newLocalData, String id, Uint8List imageData) {
    print("biker update");
    LatLng latlng = LatLng(newLocalData.latitude, newLocalData.longitude);
    MarkerId markerId = MarkerId(id);
    Future.delayed(Duration.zero, () {
      this.setState(() {
        markers[markerId] = Marker(
            markerId: markerId,
            position: latlng,
            rotation: newLocalData.accuracy,
            draggable: false,
            zIndex: 2,
            flat: true,
            anchor: Offset(0.5, 0.5),
            icon: BitmapDescriptor.fromBytes(imageData));
        // circle = Circle(
        //     circleId: CircleId("car"),
        //     radius: newLocalData.accuracy,
        //     zIndex: 1,
        //     strokeWidth: 0,
        //     strokeColor: Colors.blue,
        //     center: latlng,
        //     fillColor: Colors.blue.withAlpha(0));
      });
    });
  }

  _addPolyLine() {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(polylineId: id, color: Color.fromRGBO(52, 52, 52, 1), points: polylineCoordinates, width: 3);
    polylines[id] = polyline;
    setState(() {});
  }

  _getPolyline(double pickLat, double pickLng, double dropLat, double dropLng) async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        mapAPIKey, PointLatLng(pickLat, pickLng), PointLatLng(dropLat, dropLng),
        travelMode: TravelMode.driving, wayPoints: [PolylineWayPoint(location: "")]);
    if (result.points.isNotEmpty) {
      polylineCoordinates.clear();
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
    _addPolyLine();
  }

  void showCancelModalSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(15.0),
        ),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                "Do You Want to Cancel Your Ride?",
                style: GoogleFonts.poppins(fontSize: screenWidth*0.048, fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: 20.0,
              ),
              Image.asset("assets/images/icons/bikeRide_icon/bike_image04.png",width: screenWidth*0.6,),
              SizedBox(
                height: 25.0,
              ),
              InkWell(
                onTap: () {
                  _bikRideCancelBloc.bikRideCancel({"id":"${widget.rideId}"}, widget.userToken);
                },
                child: Container(
                  height: 40.0,
                  width: MediaQuery.of(context).size.width,
                  // margin: EdgeInsets.all(2),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                            color: Colors.white70,
                            // offset: Offset(2, 4),
                            blurRadius: 5,
                            spreadRadius: 2)
                      ],
                      gradient: LinearGradient(
                          begin: Alignment.centerLeft, end: Alignment.centerRight, colors: [Color(0xffeb8a35), Color(0xffe36126)])),
                  child: StreamBuilder<ApiResponse<BikeRideCancelModel>>(
                    stream: _bikRideCancelBloc.bikeRideCancelStream,
                    builder: (context, snapshot) {

                      if (snapshot.hasData) {
                        switch (snapshot.data.status) {
                          case Status.LOADING:
                            return CircularProgressIndicator(
                                backgroundColor: circularBGCol,
                                strokeWidth: strokeWidth,
                                valueColor: AlwaysStoppedAnimation<Color>(circularStrokeCol));

                            break;
                          case Status.COMPLETED:

                              Fluttertoast.showToast(
                                  msg: "Your ride has been cancelled.",
                                  fontSize: 14,
                                  backgroundColor: Colors.orange[100],
                                  textColor: darkThemeBlue,
                                  toastLength: Toast.LENGTH_LONG);
                              Future.delayed(Duration.zero,(){
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(builder: (BuildContext context) => HomePage()),
                                    ModalRoute.withName('/home')
                                );
                              });
                            break;
                          case Status.ERROR:
                            /*
                            print(snapshot.error);
                            Fluttertoast.showToast(
                                msg: "Oops! Something went wrong.. \nPlease try again!",
                                fontSize: 14,
                                backgroundColor: Colors.orange[100],
                                textColor: darkThemeBlue,
                                toastLength: Toast.LENGTH_LONG);
                            print(snapshot.data.message);

                             */


                            Fluttertoast.showToast(
                                msg: "Your ride has been cancelled.",
                                fontSize: 14,
                                backgroundColor: Colors.orange[100],
                                textColor: darkThemeBlue,
                                toastLength: Toast.LENGTH_LONG);
                            Future.delayed(Duration.zero,(){
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(builder: (BuildContext context) => HomePage()),
                                  ModalRoute.withName('/home')
                              );
                            });


                            break;
                        }
                      }
                      else if (snapshot.hasError) {
                        print(snapshot.error);
                      }
                      return Text("Bike Ride Cancel", style: GoogleFonts.poppins(fontSize: screenWidth*0.038, fontWeight: FontWeight.w500,color: Colors.white));
                    },
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
            ],
          ),
        );
      },
    );
  }
}
