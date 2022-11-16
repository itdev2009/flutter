

import 'package:delivery_on_time/constants.dart';
import 'package:delivery_on_time/help/api_response.dart';
import 'package:delivery_on_time/orderDetails_screen/model/orderListModel.dart' as olm;
import 'package:delivery_on_time/tracking_screen/bloc/mapTrackingBloc.dart';
import 'package:delivery_on_time/tracking_screen/bloc/mapTrackingblocOrg.dart';
import 'package:delivery_on_time/tracking_screen/model/mapTrackingModel.dart';
import 'package:delivery_on_time/tracking_screen/repository/mapTrackingRepository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

class MapTrackingPage extends StatefulWidget {
  final olm.Data orderData;

  MapTrackingPage(this.orderData);

  @override
  _MapTrackingPageState createState() => _MapTrackingPageState(orderData);
}

class _MapTrackingPageState extends State<MapTrackingPage> {
  final olm.Data orderDetailsData;

  Timer timer;

  _MapTrackingPageState(this.orderDetailsData);

  LocationData currentLocationUser;
  LocationData currentLocationDeliveryBoy;
  bool locUpdate = false;
  bool initdispose = true;

  StreamSubscription _locationSubscription;
  Location _locationTracker = Location();
  Marker marker;
  Circle circle;
  GoogleMapController _controller;
  List<Marker> markers;

  MapTrackingRepository _mapTrackingRepository;
  MapTrackingBlocOrg _mapTrackingBloc;
  Stream _trackingStream;
  Uint8List imageData;

  SharedPreferences prefs;
  String userToken = "";

  // StreamSubscription<HardwareButtons.HomeButtonEvent> _homeButtonSubscription;


  Future<void> createSharedPref() async {
    // Map body = {"transactionid": "${orderDetailsData.transactionId}"};
    Map body = {"carrier_id": "${orderDetailsData.carrierId}"};

    prefs = await SharedPreferences.getInstance();
    userToken = prefs.getString("user_token");
    _trackingStream = _mapTrackingBloc.mapTrackingStream;

    _mapTrackingBloc.mapTracking(orderDetailsData.carrierId.toString(), userToken);
    locUpdate = true;
    setUpTimedFetch(body);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _mapTrackingRepository = new MapTrackingRepository();
    _mapTrackingBloc = new MapTrackingBlocOrg();
    // _homeButtonSubscription = HardwareButtons.homeButtonEvents.listen((event) {
    //   FlutterAndroidPip.pip(aspectRatio: PipRational(7,9));
    // });
    createSharedPref();
  }

  setUpTimedFetch(Map _body) async {
    imageData = await getMarker();
    Map body = _body;
    if (initdispose) {
      timer = Timer.periodic(Duration(milliseconds: 10000), (timer) {
        setState(() {
          locUpdate = true;
          _mapTrackingBloc.mapTracking(orderDetailsData.carrierId.toString(), userToken);
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
          physics: NeverScrollableScrollPhysics(),
          children: [
            StreamBuilder<ApiResponse<MapTrackingModel>>(
              stream: _mapTrackingBloc.mapTrackingStream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  switch (snapshot.data.status) {
                    case Status.LOADING:
                      return Container();
                      break;
                    case Status.COMPLETED:
                      if (snapshot.data.data.data.longitude != null) {
                        if (locUpdate) {
                          try {
                            Map<String, double> mapData = {
                              "latitude": double.parse(snapshot.data.data.data.latitude),
                              "longitude": double.parse(snapshot.data.data.data.longitude)
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
                                    zoom: 18.00)));
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
                      /*return Error(
                        errorMessage: snapshot.data.message,
                      );*/
                      break;
                  }
                } else if (snapshot.hasError) {
                  print("error");
                }
                return Container();
              },
            ),
            Container(
              margin: EdgeInsets.only(top: screenHeight * 0.007, right: screenHeight * 0.007, left: screenHeight * 0.007),
              height: screenHeight * 0.7,
              width: screenWidth * 0.985,
              child: GoogleMap(
                myLocationEnabled: true,
                compassEnabled: false,
                myLocationButtonEnabled: false,
                zoomControlsEnabled: false,
                mapType: MapType.normal,
                initialCameraPosition: initialLocation,
                markers: Set.of((marker != null) ? [marker] : []),
                circles: Set.of((circle != null) ? [circle] : []),
                onMapCreated: (GoogleMapController controller) {
                  _controller = controller;
                },
              ),
            ),
            Container(
              // height: screenHeight * 0.386,
              color: darkThemeBlue,
              padding: EdgeInsets.fromLTRB(15.0, 15.0, 8.0, 1.0),
              child: ListView(
                shrinkWrap: true,
                physics: AlwaysScrollableScrollPhysics(),
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
                                    child: Text("Name :",
                                        style: GoogleFonts.poppins(fontSize: screenWidth*0.032, color: Colors.black, fontWeight: FontWeight.w500)),
                                  ),
                                  Expanded(
                                    flex: 4,
                                    child: Text("${orderDetailsData.carrierName ?? "Courier Name"}",
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.poppins(fontSize: screenWidth*0.032, color: Colors.black87, fontWeight: FontWeight.w500)),
                                  ),
                                ],
                              ),
                              // Row(
                              //   children: [
                              //     Expanded(
                              //       flex: 1,
                              //       child: Text("Email :",
                              //           style: GoogleFonts.poppins(fontSize: 12, color: Colors.black, fontWeight: FontWeight.w500)),
                              //     ),
                              //     Expanded(
                              //       flex: 4,
                              //       child: Text("${orderDetailsData.carrierEmail ?? "Courier Email ID"}",
                              //           overflow: TextOverflow.ellipsis,
                              //           style: GoogleFonts.poppins(fontSize: 12, color: Colors.black87, fontWeight: FontWeight.w500)),
                              //     ),
                              //   ],
                              // ),
                              Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Text("Mobile :",
                                        style: GoogleFonts.poppins(fontSize: screenWidth*0.032, color: Colors.black, fontWeight: FontWeight.w500)),
                                  ),
                                  Expanded(
                                    flex: 4,
                                    child: Text("${orderDetailsData.carrierMobileNumber ?? "Courier Mobile Number"}",
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.poppins(fontSize: screenWidth*0.032, color: Colors.black87, fontWeight: FontWeight.w500)),
                                  ),
                                ],
                              )
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
                                print(orderDetailsData.carrierMobileNumber);
                                launch('tel: ${orderDetailsData.carrierMobileNumber}');
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

