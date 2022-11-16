import 'package:delivery_on_time/constants.dart';
import 'package:delivery_on_time/help/api_response.dart';
import 'package:delivery_on_time/pickupDropPage/pickDropOrderListPage.dart';
import 'package:delivery_on_time/pickup_drop_screen/model/mapTrackingModel.dart';
import 'package:delivery_on_time/pickup_drop_screen/model/pickDropOrderListModel.dart' as olm;
import 'package:delivery_on_time/pickup_drop_screen/model/pickUpDropOrderDetailsModel.dart';
import 'package:delivery_on_time/screens/home.dart';
import 'package:delivery_on_time/tracking_screen/bloc/mapTrackingBloc.dart';
import 'package:delivery_on_time/tracking_screen/model/mapTrackingModel.dart';
import 'package:delivery_on_time/tracking_screen/model/pickupCancelModel.dart';
import 'package:delivery_on_time/tracking_screen/repository/mapTrackingRepository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_shimmer/flutter_shimmer.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'dart:typed_data';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'package:hardware_buttons/hardware_buttons.dart' as HardwareButtons;
import 'package:flutter_ajanuw_android_pip/flutter_ajanuw_android_pip.dart';
import '../constants.dart';
import 'bloc/PickupCancelBloc.dart';


class NewMapTrackingPickDropPage extends StatefulWidget {
  final int pickupId;
  const NewMapTrackingPickDropPage({Key key, this.pickupId}) : super(key: key);
  @override
  _MapTrackingPageState createState() => _MapTrackingPageState(pickupId);
}

class _MapTrackingPageState extends State<NewMapTrackingPickDropPage> {

  final int pickupId;
  Timer timer;

  _MapTrackingPageState(this.pickupId);

  LocationData currentLocationUser;
  LocationData currentLocationDeliveryBoy;
  bool locUpdate = false;
  bool initdispose = true;

  StreamSubscription _locationSubscription;
  Location _locationTracker = Location();
  Marker marker;
  Circle circle;
  GoogleMapController _controller;
  //List<Marker> markers;
  String pickStatus;
  MapTrackingRepository _mapTrackingRepository;
  MapTrackingBloc _mapTrackingBloc;
  Stream _trackingStream;
  Uint8List imageData;
  Future<MapTrackingMultiplePickup> _pickDropOrderDetailsApi;
  Future<PickupCancelModel> _pickupCancelApi;
  PickupCancelBloc _pickupCancelBloc;
  SharedPreferences prefs;
  String userToken = "";
  // list of locations to display polylines
  List<LatLng> latLen = [];
  Map<MarkerId, Marker> markers = {};
  Map<PolylineId, Polyline> polylines = {};
  final Set<Polyline> _polyline = {};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  Uint8List carImage;
  Uint8List bikeImage;
  Uint8List pickupIcon;
  Uint8List dropIcon;

  // StreamSubscription<HardwareButtons.HomeButtonEvent> _homeButtonSubscription;


  Future<void> createSharedPref() async {
    prefs = await SharedPreferences.getInstance();
    userToken = prefs.getString("user_token");
    print('userToken>>>>$userToken');
    print('pickupId>>>>$pickupId');

    _pickDropOrderDetailsApi = _mapTrackingRepository.mapTracking(pickupId.toString(), userToken);

    locUpdate = true;
    setUpTimedFetch();
    setState(() {});
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
  @override
  void initState() {
    super.initState();
    _getBikerMarkerImage();
    numberOfReceivers=0;
    _mapTrackingRepository = new MapTrackingRepository();
    _pickupCancelBloc = PickupCancelBloc();
    createSharedPref();
  }

  setUpTimedFetch() async {
    imageData = await getMarker();

    if (initdispose) {
      timer = Timer.periodic(Duration(milliseconds: 10000), (timer) {
        setState(() {
          locUpdate = true;
          _pickDropOrderDetailsApi = _mapTrackingRepository.mapTracking(pickupId.toString(), userToken);
        });
      });
    }
  }

  static final CameraPosition initialLocation = CameraPosition(
    target: LatLng(22.649375, 88.391528),
    zoom: 14.4746,
  );

  Future<Uint8List> getMarker() async {
    ByteData byteData = await DefaultAssetBundle.of(context).load("assets/images/icons/bike_icon3.png");
    return byteData.buffer.asUint8List();
  }

  void updateMarkerAndCircle(LocationData newLocalData, Uint8List imageData) {
    print("marker update");
    LatLng latlng = LatLng(newLocalData.latitude, newLocalData.longitude);
    Future.delayed(Duration.zero, () {
      this.setState(() {
        marker = Marker(
            markerId: MarkerId("home"),
            position: latlng,
            rotation: newLocalData.heading,
            draggable: false,
            zIndex: 2,
            flat: true,
            anchor: Offset(0.5, 0.5),
            icon: BitmapDescriptor.fromBytes(imageData));
        circle = Circle(
            circleId: CircleId("car"),
            radius: newLocalData.accuracy,
            zIndex: 1,
            strokeWidth: 0,
            strokeColor: Colors.blue,
            center: latlng,
            fillColor: Colors.blue.withAlpha(0));
      });
    });
  }

  _addMarker(LatLng position, String id, BitmapDescriptor descriptor) {

    MarkerId markerId = MarkerId(id);
    Marker marker = Marker(markerId: markerId, icon: descriptor, position: position);
    markers[markerId] = marker;
  }
  _addPolyLine() {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(polylineId: id, color: orangeCol, points: polylineCoordinates, width: 3);
    polylines[id] = polyline;
    setState(() {});
  }



  /*void getCurrentLocation() async {
    try {
      imageData = await getMarker();
      // var location = await _locationTracker.getLocation();
      currentLocationUser = await _locationTracker.getLocation();
      print(currentLocationUser.accuracy);
      print(currentLocationUser.altitude);
      print(currentLocationUser.speed);
      updateMarkerAndCircle(currentLocationUser, imageData);

      if (_locationSubscription != null) {
      if (_locationSubscription != null) {
        _locationSubscription.cancel();
      }

      _locationSubscription =
          _locationTracker.onLocationChanged.listen((newLocalData) {
        if (_controller != null) {
          _controller.animateCamera(CameraUpdate.newCameraPosition(
              new CameraPosition(
                  bearing: 192.8334901395799,
                  target: LatLng(newLocalData.latitude, newLocalData.longitude),
                  tilt: 0,
                  zoom: 18.00)));
          updateMarkerAndCircle(newLocalData, imageData);
        }
      });
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        debugPrint("Permission Denied");
      }
    }
  }*/

  @override
  void dispose() {
    super.dispose();
    if (_locationSubscription != null) {
      _locationSubscription.cancel();
    }
    initdispose = false;
    timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: darkThemeBlue,
        // appBar: AppBar(
        //     backgroundColor: lightThemeBlue,
        //     leading: IconButton(
        //         onPressed: () {
        //           Navigator.pop(context);
        //         },
        //         icon: Icon(
        //           Icons.arrow_back,
        //           color: Colors.white,
        //         )),
        //     title: Center(
        //         child: Column(
        //           mainAxisSize: MainAxisSize.min,
        //           children: [
        //             Text("ORDER FROM",
        //                 style: GoogleFonts.poppins(fontSize: 8, color: textCol, fontWeight: FontWeight.w300)),
        //             Text("${(orderDetailsData.vendor!=null)?orderDetailsData.vendor.shopName:"Shop Name"}".toUpperCase(),
        //                 overflow: TextOverflow.ellipsis,
        //                 style: GoogleFonts.poppins(fontSize: 12, color: Colors.white, fontWeight: FontWeight.w400)),
        //
        //           ],
        //         )),
        //     actions: <Widget>[
        //       IconButton(
        //         color: Colors.white,
        //         icon: Icon(
        //           Icons.notifications,
        //           color: Colors.white,
        //           size: 0,
        //         ),
        //       ),
        //     ]),

        body: ListView(
          // mainAxisSize: MainAxisSize.min,
          // crossAxisAlignment: CrossAxisAlignment.start,
          // mainAxisAlignment: MainAxisAlignment.start,
          shrinkWrap: true,
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            /*StreamBuilder<ApiResponse<MapTrackingMultiplePickup>>(
              stream: _mapTrackingBloc.mapTrackingStream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  switch (snapshot.data.status) {
                    case Status.LOADING:
                      return Container();
                      break;
                    case Status.COMPLETED:
                      if (snapshot.data.data.data[0].carrier != null) {
                        print(snapshot.data.data.data[0].carrier.latitude);
                        print(snapshot.data.data.data[0].receiverDetails.length);
                        print(double.parse(snapshot.data.data.data[0].receiverLatitude));

                        for(int i=0; i< snapshot.data.data.data[0].receiverDetails.length; i++)
                        {
                          //print('destination${i}');
                          _addMarker(LatLng(double.parse(snapshot.data.data.data[0].receiverDetails[i].receiverLatitude), double.parse(snapshot.data.data.data[0].receiverDetails[i].receiverLongitude)), "destination${i}", BitmapDescriptor.defaultMarker);
                        }

                        if (locUpdate) {
                          try {

                            Map<String, double> mapData = {
                              "latitude": double.parse(snapshot.data.data.data[0].carrier.latitude),
                             "longitude": double.parse(snapshot.data.data.data[0].carrier.longitude)
                             // "latitude": 20.5,
                             // "longitude": 100.0
                            };

                            locUpdate = true;

                            currentLocationDeliveryBoy = new LocationData.fromMap(mapData);

                            updateMarkerAndCircle(currentLocationDeliveryBoy, imageData);

                            if (_locationSubscription != null) {
                              _locationSubscription.cancel();
                            }

                            _locationSubscription = _locationTracker.onLocationChanged.listen((newLocalData) {
                              if (_controller != null) {
                                _controller.animateCamera(CameraUpdate.newCameraPosition(new CameraPosition(
                                    bearing: 192.8334901395799,
                                    target: LatLng(currentLocationDeliveryBoy.latitude, currentLocationDeliveryBoy.longitude),
                                    tilt: 0,
                                    zoom: 12.00)));
                                updateMarkerAndCircle(currentLocationDeliveryBoy, imageData);
                              }
                            });
                          } on PlatformException catch (e) {
                            if (e.code == 'PERMISSION_DENIED') {
                              debugPrint("Permission Denied");
                            }
                          }
                          locUpdate = false;
                        }
                      } else {
                        Navigator.pop(context);
                      }
                      break;
                    case Status.ERROR:
                      Fluttertoast.showToast(
                          msg: "${snapshot.data.message}",
                          fontSize: 14,
                          backgroundColor: Colors.orange[100],
                          textColor: darkThemeBlue,
                          toastLength: Toast.LENGTH_LONG);
                      *//*return Error(
                        errorMessage: snapshot.data.message,
                      );*//*
                      break;
                  }
                } else if (snapshot.hasError) {
                  print("error");
                }
                return Container();
              },
            ),*/
            FutureBuilder<MapTrackingMultiplePickup>(
                future: _pickDropOrderDetailsApi,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data.data[0]!= null) {
                      pickStatus=snapshot.data.data[0].status;
                      print('status>>>>$pickStatus');
                    if (snapshot.data.data[0].status == "DELIVERED") {
                      Future.delayed(Duration.zero,(){
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (BuildContext context) => HomePage()),
                            ModalRoute.withName('/home')
                        );
                      });
                      Fluttertoast.showToast(
                          msg: "Thank you for taking Pickup from us.",
                          fontSize: 14,
                          backgroundColor: Colors.orange[100],
                          textColor: darkThemeBlue,
                          toastLength: Toast.LENGTH_LONG);
                    }else if (snapshot.data.data[0].status == "DECLINED") {
                      Future.delayed(Duration.zero,(){
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (BuildContext context) => HomePage()),
                            ModalRoute.withName('/home')
                        );
                      });
                      Fluttertoast.showToast(
                          msg: "Rider has declined your booking.\nWe are sorry for the inconvenience",
                          fontSize: 13,
                          backgroundColor: Colors.orange[100],
                          textColor: darkThemeBlue,
                          toastLength: Toast.LENGTH_LONG);
                    }else if (snapshot.data.data[0].status == "CANCELLED") {
                      Future.delayed(Duration.zero,(){
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (BuildContext context) => HomePage()),
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




                      latLen.clear();

                    if (snapshot.data.data[0].carrier != null){
                      if(snapshot.data.data[0].carrier.vehicleType=="2W"){
                        _addMarker(LatLng(double.parse(snapshot.data.data[0].carrier.latitude), double.parse(snapshot.data.data[0].carrier.longitude)), "carrier", BitmapDescriptor.fromBytes(bikeImage));
                        latLen.add(LatLng(double.parse(snapshot.data.data[0].carrier.latitude), double.parse(snapshot.data.data[0].carrier.longitude)));
                      }else{
                        _addMarker(LatLng(double.parse(snapshot.data.data[0].carrier.latitude), double.parse(snapshot.data.data[0].carrier.longitude)), "carrier", BitmapDescriptor.fromBytes(carImage));
                        latLen.add(LatLng(double.parse(snapshot.data.data[0].carrier.latitude), double.parse(snapshot.data.data[0].carrier.longitude)));
                      }
                    }
                    _addMarker(LatLng(double.parse(snapshot.data.data[0].senderLatitude), double.parse(snapshot.data.data[0].senderLongitude)), "origin",  BitmapDescriptor.fromBytes(pickupIcon));
                    latLen.add(LatLng(double.parse(snapshot.data.data[0].senderLatitude), double.parse(snapshot.data.data[0].senderLongitude)));
                      for(int i=0; i< snapshot.data.data[0].receiverDetails.length; i++)
                      {
                        //print('destination${i}');
                        _addMarker(LatLng(double.parse(snapshot.data.data[0].receiverDetails[i].receiverLatitude), double.parse(snapshot.data.data[0].receiverDetails[i].receiverLongitude)), "destination${i}", BitmapDescriptor.defaultMarker);
                        latLen.add(LatLng(double.parse(snapshot.data.data[0].receiverDetails[i].receiverLatitude), double.parse(snapshot.data.data[0].receiverDetails[i].receiverLongitude)));
                      }



                      // declared for loop for various locations
                      for(int i=0; i<latLen.length; i++){
                        _polyline.add(
                            Polyline(
                              polylineId: PolylineId('poly'),
                              points: latLen,
                              color: Colors.orange,
                              width: 3
                            )
                        );
                      }

                      if (snapshot.data.data[0].carrier != null){
                        if (locUpdate) {
                          try {

                            Map<String, double> mapData = {
                              "latitude": double.parse(snapshot.data.data[0].carrier.latitude),
                              "longitude": double.parse(snapshot.data.data[0].carrier.longitude)
                              //"latitude": 23.0128,
                              //"longitude": 87.5939
                            };

                            locUpdate = true;

                            currentLocationDeliveryBoy = new LocationData.fromMap(mapData);

                            updateMarkerAndCircle(currentLocationDeliveryBoy, imageData);

                            if (_locationSubscription != null) {
                              _locationSubscription.cancel();
                            }

                            _locationSubscription = _locationTracker.onLocationChanged.listen((newLocalData) {
                              if (_controller != null) {
                                _controller.animateCamera(CameraUpdate.newCameraPosition(new CameraPosition(
                                    bearing: 192.8334901395799,
                                    target: LatLng(currentLocationDeliveryBoy.latitude, currentLocationDeliveryBoy.longitude),
                                    tilt: 0,
                                    zoom: 12.00)));
                                updateMarkerAndCircle(currentLocationDeliveryBoy, imageData);
                              }
                            });
                          } on PlatformException catch (e) {
                            if (e.code == 'PERMISSION_DENIED') {
                              debugPrint("Permission Denied");
                            }
                          }
                          locUpdate = false;
                        }
                      }else{
                        print('userLat>>>>>>$userLat');
                        print('userLong>>>>>>$userLong');
                        if(userLat!=null&&userLong!=null){
                          if (locUpdate) {
                            try {
                              Map<String, double> mapData = {
                                "latitude": userLat,
                                "longitude": userLong
                                //"latitude": 23.0128,
                                //"longitude": 87.5939
                              };

                              locUpdate = true;

                              currentLocationDeliveryBoy = new LocationData.fromMap(mapData);

                              updateMarkerAndCircle(currentLocationDeliveryBoy, imageData);

                              if (_locationSubscription != null) {
                                _locationSubscription.cancel();
                              }

                              _locationSubscription = _locationTracker.onLocationChanged.listen((newLocalData) {
                                if (_controller != null) {
                                  _controller.animateCamera(CameraUpdate.newCameraPosition(new CameraPosition(
                                      bearing: 192.8334901395799,
                                      target: LatLng(currentLocationDeliveryBoy.latitude, currentLocationDeliveryBoy.longitude),
                                      tilt: 0,
                                      zoom: 12.00)));
                                  updateMarkerAndCircle(currentLocationDeliveryBoy, imageData);
                                }
                              });
                            } on PlatformException catch (e) {
                              if (e.code == 'PERMISSION_DENIED') {
                                debugPrint("Permission Denied");
                              }
                            }
                            locUpdate = false;
                          }
                        }

                      }

                    }
                  }
                  return Container();
                }),
            Container(
              margin: EdgeInsets.only(top: screenHeight * 0.007, right: screenHeight * 0.007, left: screenHeight * 0.007),
              height: screenHeight * 0.7,
              width: screenWidth * 0.985,
              child: GoogleMap(
                myLocationEnabled: true,
                compassEnabled: true,
                myLocationButtonEnabled: false,
                zoomControlsEnabled: true,
                mapType: MapType.normal,
                initialCameraPosition: initialLocation,
                // markers: Set.of((marker != null) ? [marker] : []),
                markers: Set<Marker>.of(markers.values),
                polylines: _polyline,
                circles: Set.of((circle != null) ? [circle] : []),
                onMapCreated: (GoogleMapController controller) {
                  _controller = controller;
                },
              ),
            ),
            /*Padding(
              padding: EdgeInsets.fromLTRB(15.0, 15.0, 8.0, 1.0),
              child: Row(
                children: [
                  Image.asset("assets/images/icons/food-serving.png",
                    height: screenWidth*0.09,
                    width: screenWidth*0.09,),
                  Expanded(
                    child: Text("  Your order is on it's way!",
                        style: GoogleFonts.poppins(
                            fontSize: screenWidth*0.05,
                            color: Colors.white,
                            fontWeight: FontWeight.w300
                        )),
                  ),
                ],
              ),
            ),*/
            FutureBuilder<MapTrackingMultiplePickup>(
              future: _pickDropOrderDetailsApi,
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  if(snapshot.data.data[0].carrier != null){
                    return  Container(
                      // height: screenHeight * 0.386,
                      color: darkThemeBlue,
                      padding: EdgeInsets.fromLTRB(15.0, 15.0, 8.0, 1.0),
                      child: ListView(
                        shrinkWrap: true,
                        physics: const ClampingScrollPhysics(),
                        //physics: AlwaysScrollableScrollPhysics(),
                        children: [
                          Row(
                            children: [
                              Image.asset("assets/images/icons/food-serving.png",
                                height: screenWidth*0.09,
                                width: screenWidth*0.09,),
                              Expanded(
                                child: Text("  Your order is on it's way!",
                                    style: GoogleFonts.poppins(
                                        fontSize: screenWidth*0.05,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w300
                                    )),
                              ),
                            ],
                          ),
                          SizedBox(height: screenWidth*0.03,),
                          Container(
                            margin: EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 4.0),
                            padding: EdgeInsets.all(screenWidth*0.03),
                            clipBehavior: Clip.hardEdge,
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0), color: Colors.white),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  flex: 10,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("Delivery Partner Details",
                                          style: GoogleFonts.poppins(fontSize: screenWidth*0.037, color: Colors.black, fontWeight: FontWeight.w600)),
                                      SizedBox(
                                        height: screenWidth*0.03,
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            flex: 1,
                                            child: Text("Mobile :",
                                                style: GoogleFonts.poppins(fontSize: screenWidth*0.032, color: Colors.black, fontWeight: FontWeight.w500)),
                                          ),
                                          Expanded(
                                            flex: 4,
                                            child: Text("${(snapshot.data.data[0].carrier.mobileNumber != null)?snapshot.data.data[0].carrier.mobileNumber:"Courier Mobile Number"}",
                                                overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts.poppins(fontSize: screenWidth*0.032, color: Colors.black87, fontWeight: FontWeight.w500)),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            flex: 1,
                                            child: Text("Vehicle Type :",
                                                style: GoogleFonts.poppins(fontSize: screenWidth*0.032, color: Colors.black, fontWeight: FontWeight.w500)),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: Text("${(snapshot.data.data[0].carrier.vehicleType!= null)?snapshot.data.data[0].carrier.vehicleType:"Vehicle Type"}",
                                                overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts.poppins(fontSize: screenWidth*0.032, color: Colors.black87, fontWeight: FontWeight.w500)),
                                          ),
                                        ],
                                      ),
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
                                                child: snapshot.data.data[0].carrier.vehicleType == '2W' ? Image.asset("assets/images/icons/bikeRide_icon/bike_image04.png") : Image.asset('assets/images/icons/bikeRide_icon/car_png.png'),
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
                                                      "$imageBaseURL${snapshot.data.data[0].carrier.proofPhoto}",
                                                    ),
                                                    placeholder: AssetImage("assets/images/icons/profile.png"),
                                                    fit: BoxFit.fill,
                                                  ),
                                                  // child: Image.asset("asset/blank-profile-picture-973460_1280.webp")
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text("${snapshot.data.data[0].carrier.vehicleNo}",
                                                  overflow: TextOverflow.ellipsis,
                                                  style: GoogleFonts.poppins(fontSize: 14, color: Colors.black, fontWeight: FontWeight.w400)),
                                              SizedBox(
                                                height: 3,
                                              ),
                                              Text("${snapshot.data.data[0].carrier.vehicleMake}",
                                                  overflow: TextOverflow.ellipsis,
                                                  style: GoogleFonts.poppins(fontSize: 18, color: Colors.black, fontWeight: FontWeight.w500)),
                                              Text("${snapshot.data.data[0].carrier.user.name}",
                                                  overflow: TextOverflow.ellipsis,
                                                  style: GoogleFonts.poppins(fontSize: 13, color: Colors.black, fontWeight: FontWeight.w400)),


                                              //${snapshot.data.data.payableAmount}
                                              SizedBox(
                                                height: 1,
                                              ),
                                              Text("Pick up Charge : ₹ ${snapshot.data.data[0].payableAmount}",
                                                  overflow: TextOverflow.ellipsis,
                                                  style: GoogleFonts.poppins(fontSize: 13, color: Colors.black, fontWeight: FontWeight.w400)),
                                            ],
                                          ),
                                        ],
                                      ),

                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: ButtonTheme(
                                    /*__To Enlarge Button Size__*/
                                    height: 35.0,
                                    child: RaisedButton(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10.0),
                                      ),
                                      onPressed: () {
                                        //print(orderDetailsData.carrier.mobileNumber);
                                        launch('tel: ${snapshot.data.data[0].carrier.mobileNumber}');
                                      },
                                      color: orangeCol,
                                      textColor: Colors.white,
                                      child: Icon(
                                        Icons.call_outlined,
                                        size: screenWidth*0.04,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Container(
                          //   margin: EdgeInsets.fromLTRB(0.0, 4.0, 0.0, 4.0),
                          //   padding: EdgeInsets.fromLTRB(12.0,8.0,12.0,8.0),
                          //   clipBehavior: Clip.hardEdge,
                          //   decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0), color: Colors.white),
                          //   child: Column(
                          //     crossAxisAlignment: CrossAxisAlignment.start,
                          //     children: [
                          //       Align(
                          //         alignment: Alignment.topRight,
                          //         child: Text("ORDER #${orderDetailsData.id}",
                          //             style: GoogleFonts.poppins(fontSize: 12.5, color: lightThemeBlue, fontWeight: FontWeight.w600,
                          //                 letterSpacing: 0.2)),
                          //       ),
                          //       Text("Delivery Address",
                          //           style: GoogleFonts.poppins(fontSize: 13, color: Colors.black, fontWeight: FontWeight.w600)),
                          //       SizedBox(
                          //         height: 5,
                          //       ),
                          //       Text("${orderDetailsData.deliveryAddress}",
                          //           overflow: TextOverflow.fade,
                          //           style: GoogleFonts.poppins(fontSize: 12, color: Colors.black54, fontWeight: FontWeight.w400)),
                          //     ],
                          //   ),
                          // ),

                        ],
                      ),
                    );
                  }else{
                    return Center(child: Text("You don't have any carrier",style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,fontSize: screenWidth*0.042,color: Colors.white
                    ),));
                  }

                }
                else if (snapshot.hasError) {
                  print(snapshot.error);
                  return Center(child: Text("Oops! Something Went Wrong",style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,fontSize: screenWidth*0.042,color: Colors.white
                  ),));
                } else {
                  return ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: 6,
                      itemBuilder: (context, index){
                        return ListTileShimmer(
                          padding: EdgeInsets.only(top: 0,bottom: 0),
                          margin: EdgeInsets.only(top: 20,bottom: 20),
                          height: 60,
                          isDisabledAvatar: true,
                          isRectBox: true,
                          colors: [
                            Colors.white
                          ],
                        );
                      }
                  );
                }
              },
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: screenWidth*0.30,
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
                    width: screenWidth*0.30,
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

                          if(pickStatus == 'PENDING'){
                            showCancelModalSheet();
                          }else
                            Fluttertoast.showToast(
                                msg: "You can't cancel this pickup now.",
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
                    width: screenWidth*0.30,
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
                          Navigator.push(context,
                              MaterialPageRoute(builder: (BuildContext context) {
                                return PickDropOrderListPage();
                              }));
                        },
                        color: orangeCol,
                        textColor: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.only(left:5.0,right: 5.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.electric_bike_sharp,
                                size: screenWidth*0.04,
                              ),
                              Text("  Pickup History", style: GoogleFonts.poppins(fontSize: screenWidth*0.026, fontWeight: FontWeight.w500)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),




                ],
              ),
            ),

            // Container(
            //   color: Colors.white,
            //   height: screenHeight*0.385,
            //   width: screenWidth,
            //   margin: EdgeInsets.only(top: screenHeight*0.012,right: screenHeight*0.007,left: screenHeight*0.007,bottom: screenHeight*0.007),
            //   padding: EdgeInsets.all(25.0),
            //   child: Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       Expanded(
            //         flex: 1,
            //         child: Container(
            //           // color: Colors.orange,
            //           width: screenWidth,
            //           child: Row(
            //             children: [
            //               Text("Order Details",
            //               style: TextStyle(
            //                 fontSize: 19,
            //                 fontWeight: FontWeight.w500,
            //               ),),
            //               Spacer(),
            //               InkWell(
            //                   onTap: (){
            //                     Navigator.pop(context);
            //                   },
            //                   child: Icon(Icons.cancel_outlined))
            //             ],
            //           ),
            //         ),
            //       ),
            //       Expanded(
            //         flex: 1,
            //         child: Divider(
            //           color: Colors.orange,
            //           height: screenHeight*0.03,
            //           thickness: 2,
            //         ),
            //       ),
            //       Expanded(
            //         flex: 1,
            //         child: Row(
            //           children: [
            //             Text("Order Number : ",
            //               style: TextStyle(
            //                 fontSize: 14,
            //                 fontWeight: FontWeight.w500,
            //               ),),
            //             Text("${orderDetailsData.orderId}",
            //               style: TextStyle(
            //                 fontSize: 15,
            //               ),),
            //           ],
            //         ),
            //       ),
            //       Expanded(
            //         flex: 1,
            //         child: Row(
            //           children: [
            //             Text("Order Amount : ",
            //               style: TextStyle(
            //                 fontSize: 14,
            //                 fontWeight: FontWeight.w500,
            //               ),),
            //             Text("${orderDetailsData.transactionAmount}",
            //               style: TextStyle(
            //                 fontSize: 15,
            //               ),),
            //           ],
            //         ),
            //       ),
            //       Expanded(
            //         flex: 1,
            //         child: Row(
            //           children: [
            //             Text("Date : ",
            //               style: TextStyle(
            //                 fontSize: 14,
            //                 fontWeight: FontWeight.w500,
            //               ),),
            //             Text("${orderDetailsData.createdAt}",
            //               style: TextStyle(
            //                 fontSize: 15,
            //               ),),
            //           ],
            //         ),
            //       ),
            //
            //
            //       Expanded(
            //         flex: 2,
            //         child: Row(
            //           children: [
            //             Text("Deliver to : ",
            //               style: TextStyle(
            //                 fontSize: 14,
            //                 fontWeight: FontWeight.w500,
            //               ),),
            //             Flexible(
            //               // flex: 5,
            //               child: Text("${orderDetailsData.deliveryAddress}",
            //                 style: TextStyle(
            //                   fontSize: 14,
            //                 ),),
            //             ),
            //           ],
            //         ),
            //       ),
            //       Expanded(
            //         flex: 1,
            //         child: Row(
            //           children: [
            //             Text("Payment Status : ",
            //               style: TextStyle(
            //                 fontSize: 14,
            //                 fontWeight: FontWeight.w500,
            //               ),),
            //             Text("${orderDetailsData.transactionStatus}",
            //               style: TextStyle(
            //                 fontSize: 15,
            //                 color: (orderDetailsData.transactionStatus=="Success")? Colors.green : Colors.red
            //               ),),
            //           ],
            //         ),
            //       ),
            //
            //     ],
            //   ),
            // ),
          ],
        ),
        /*floatingActionButtonLocation: FloatingActionButtonLocation.miniEndTop,
        floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.white.withOpacity(0.8),
            child: Icon(
              Icons.location_searching,
              color: orangeCol,
            ),
            onPressed: () {
              // getCurrentLocation();
              updateMarkerAndCircle(
                  currentLocationDeliveryBoy, imageData);
            }),*/
      ),
    );
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
                "Do You Want to Cancel Your Pickup?",
                style: GoogleFonts.poppins(fontSize: screenWidth*0.048, fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: 20.0,
              ),
              Image.asset("assets/images/icons/bikeRide_icon/bike_image04.png",width: screenWidth*0.6,),
              SizedBox(
                height: 25.0,
              ),
              /*InkWell(
                onTap: () {
                  _pickupCancelApi = _mapTrackingRepository.pickupCancel(pickupId.toString(), userToken);

                },
                child: Container(
                  height: 60.0,
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
                  child: FutureBuilder<PickupCancelModel>(
                    future: _pickupCancelApi,
                    builder: (context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                        Fluttertoast.showToast(
                            msg: "Your pickup has been cancelled.",
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
                      }
                      else if (snapshot.hasError) {
                        print(snapshot.error);
                      }
                      return Text("Pickup Cancel", style: GoogleFonts.poppins(fontSize: screenWidth*0.038, fontWeight: FontWeight.w500,color: Colors.white));
                    },


                  ),

                ),
              ),*/
              InkWell(
                onTap: () {
                  _pickupCancelBloc.bikRideCancel({"id":pickupId.toString()}, userToken);
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
                  child: StreamBuilder<ApiResponse<PickupCancelModel>>(
                    stream: _pickupCancelBloc.pickUpCancelStream,
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
                                msg: "Your pickup has been cancelled.",
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
                                msg: "Your pickup has been cancelled.",
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
                      return Text("Pickup Cancel", style: GoogleFonts.poppins(fontSize: screenWidth*0.038, fontWeight: FontWeight.w500,color: Colors.white));
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

//   void upDateMarkers() {
//     // List<Marker> updatedMarkers =[]; //new markers with updated position go here
//
//     // updatedMarkers =['updated the markers location here and also other properties you need.'];
//
//
//     /// Then call the SetState function.
//     /// I called the MarkersUpdate class inside the setState function.
//     /// You can do it your way but remember to call the setState function so that the updated markers reflect on your Flutter app.
//     /// Ps: I did not try the second way where the MarkerUpdate is called outside the setState buttechnically it should work.
//     setState(() {
//       updateMarkerAndCircle.(
//           Set<Marker>.from(markers), Set<Marker>.from(updatedMarkers));
//       // markers = [];
//       // markers = updatedMarkers;
//       //swap of markers so that on next marker update the previous marker would be the one which you updated now.
// // And even on the next app startup, it takes the updated markers to show on the map.
//     });
//   }
// print("location updated");
// print(snapshot.data.data.data.latitude);
// print(
// double.parse(snapshot.data.data.data.longitude));


// Container(
//   color: Colors.white,
//   height: screenHeight*0.385,
//   width: screenWidth,
//   margin: EdgeInsets.only(top: screenHeight*0.012,right: screenHeight*0.007,left: screenHeight*0.007,bottom: screenHeight*0.007),
//   padding: EdgeInsets.all(25.0),
//   child: Column(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//       Expanded(
//         flex: 1,
//         child: Container(
//           // color: Colors.orange,
//           width: screenWidth,
//           child: Row(
//             children: [
//               Text("Order Details",
//               style: TextStyle(
//                 fontSize: 19,
//                 fontWeight: FontWeight.w500,
//               ),),
//               Spacer(),
//               InkWell(
//                   onTap: (){
//                     Navigator.pop(context);
//                   },
//                   child: Icon(Icons.cancel_outlined))
//             ],
//           ),
//         ),
//       ),
//       Expanded(
//         flex: 1,
//         child: Divider(
//           color: Colors.orange,
//           height: screenHeight*0.03,
//           thickness: 2,
//         ),
//       ),
//       Expanded(
//         flex: 1,
//         child: Row(
//           children: [
//             Text("Order Number : ",
//               style: TextStyle(
//                 fontSize: 14,
//                 fontWeight: FontWeight.w500,
//               ),),
//             Text("${orderDetailsData.orderId}",
//               style: TextStyle(
//                 fontSize: 15,
//               ),),
//           ],
//         ),
//       ),
//       Expanded(
//         flex: 1,
//         child: Row(
//           children: [
//             Text("Order Amount : ",
//               style: TextStyle(
//                 fontSize: 14,
//                 fontWeight: FontWeight.w500,
//               ),),
//             Text("${orderDetailsData.transactionAmount}",
//               style: TextStyle(
//                 fontSize: 15,
//               ),),
//           ],
//         ),
//       ),
//       Expanded(
//         flex: 1,
//         child: Row(
//           children: [
//             Text("Date : ",
//               style: TextStyle(
//                 fontSize: 14,
//                 fontWeight: FontWeight.w500,
//               ),),
//             Text("${orderDetailsData.createdAt}",
//               style: TextStyle(
//                 fontSize: 15,
//               ),),
//           ],
//         ),
//       ),
//
//
//       Expanded(
//         flex: 2,
//         child: Row(
//           children: [
//             Text("Deliver to : ",
//               style: TextStyle(
//                 fontSize: 14,
//                 fontWeight: FontWeight.w500,
//               ),),
//             Flexible(
//               // flex: 5,
//               child: Text("${orderDetailsData.deliveryAddress}",
//                 style: TextStyle(
//                   fontSize: 14,
//                 ),),
//             ),
//           ],
//         ),
//       ),
//       Expanded(
//         flex: 1,
//         child: Row(
//           children: [
//             Text("Payment Status : ",
//               style: TextStyle(
//                 fontSize: 14,
//                 fontWeight: FontWeight.w500,
//               ),),
//             Text("${orderDetailsData.transactionStatus}",
//               style: TextStyle(
//                 fontSize: 15,
//                 color: (orderDetailsData.transactionStatus=="Success")? Colors.green : Colors.red
//               ),),
//           ],
//         ),
//       ),
//
//     ],
//   ),
// ),