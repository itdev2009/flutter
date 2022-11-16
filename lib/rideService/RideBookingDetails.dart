import 'dart:typed_data';

import 'package:delivery_on_time/constants.dart';
import 'package:delivery_on_time/rideService/model/rideBookingDetailsModel.dart';
import 'package:delivery_on_time/rideService/repository/bikeRideRepository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_shimmer/flutter_shimmer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class RideBookingDetails extends StatefulWidget {
  final String userToken;
  final int rideId;

  const RideBookingDetails({Key key, this.userToken, this.rideId}) : super(key: key);

  @override
  _RideBookingDetailsState createState() => _RideBookingDetailsState();
}

class _RideBookingDetailsState extends State<RideBookingDetails> {
  Future<RideBookingDetailsModel> _rideBookingDetailsFuture;
  BikeRideRepository _bikeRideRepository;

  Map<PolylineId, Polyline> polylines = {};
  Map<MarkerId, Marker> markers = {};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  String googleAPiKey = mapAPIKey;
  Uint8List pickupIcon;
  Uint8List dropIcon;
  double distance;

  bool firstHit = true;

  @override
  void initState() {
    super.initState();
    _getBikerMarkerImage();
    _bikeRideRepository = BikeRideRepository();
    _rideBookingDetailsFuture = _bikeRideRepository.rideBookingDetails(widget.rideId, widget.userToken);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: lightThemeBlue,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
              )),
          title: Text(
            "Bike Rides",
            style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold, fontSize: screenWidth * 0.041),
          ),
          centerTitle: true,
        ),
        backgroundColor: darkThemeBlue,
        body: FutureBuilder<RideBookingDetailsModel>(
          future: _rideBookingDetailsFuture,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (firstHit) {
                /// origin marker
                _addMarker(LatLng(double.parse(snapshot.data.data.pickupLatitude), double.parse(snapshot.data.data.pickupLongitude)),
                    "origin", BitmapDescriptor.fromBytes(pickupIcon));

                /// destination marker
                _addMarker(LatLng(double.parse(snapshot.data.data.dropLatitude), double.parse(snapshot.data.data.dropLongitude)),
                    "destination", BitmapDescriptor.fromBytes(dropIcon));

                _getPolyline(double.parse(snapshot.data.data.pickupLatitude), double.parse(snapshot.data.data.pickupLongitude),
                    double.parse(snapshot.data.data.dropLatitude), double.parse(snapshot.data.data.dropLongitude));

                distance = double.parse(snapshot.data.data.projectedDistance);
                firstHit = false;
              }

              return ListView(
                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("BOOKING NUMBER #${snapshot.data.data.id}  ",
                            style: GoogleFonts.poppins(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w600)),
                        (snapshot.data.data.status == "ASSIGNED")
                            ? Icon(
                                Icons.check_circle,
                                color: Colors.green,
                                size: 18,
                              )
                            : Icon(
                                Icons.error,
                                color: Colors.red,
                                size: 17,
                              ),
                      ],
                    ),
                  ),

                  Container(
                    clipBehavior: Clip.hardEdge,
                    width: screenWidth,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(12.0), color: Colors.white),
                    padding: EdgeInsets.fromLTRB(12, 10, 12, 10),
                    margin: EdgeInsets.fromLTRB(0, 5, 0, 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Location Details",
                          style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: screenWidth * 0.038, color: Colors.black),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                            clipBehavior: Clip.hardEdge,
                            width: screenWidth,
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(12.0), color: Colors.white),
                            height: screenHeight * 0.25,
                            child: GoogleMap(
                              myLocationEnabled: false,
                              compassEnabled: false,
                              myLocationButtonEnabled: false,
                              zoomControlsEnabled: false,
                              mapToolbarEnabled: false,
                              liteModeEnabled: true,
                              // rotateGesturesEnabled: false,
                              // zoomGesturesEnabled: false,
                              // scrollGesturesEnabled: false,
                              mapType: MapType.normal,
                              initialCameraPosition: CameraPosition(
                                  target: LatLng(
                                      (double.parse(snapshot.data.data.pickupLatitude) + double.parse(snapshot.data.data.dropLatitude)) / 2,
                                      (double.parse(snapshot.data.data.pickupLongitude) + double.parse(snapshot.data.data.dropLongitude)) /
                                          2),
                                  zoom: (distance < 4)
                                      ? 13
                                      : (distance < 10)
                                          ? 11
                                          : (distance < 20)
                                              ? 10
                                              : (distance < 40)
                                                  ? 9
                                                  : (distance < 75)
                                                      ? 8
                                                      : (distance < 140)
                                                          ? 7
                                                          : (distance < 350)
                                                              ? 6
                                                              : (distance < 825)
                                                                  ? 5
                                                                  : 4),
                              polylines: Set<Polyline>.of(polylines.values),
                              markers: Set<Marker>.of(markers.values),
                              onMapCreated: (GoogleMapController controller) {
                                GoogleMapController mapController = controller;
                              },
                            )),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          // crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                                width: screenWidth * 0.08,
                                height: screenWidth * 0.08,
                                child: Image.asset(
                                  "assets/images/icons/bikeRide_icon/pick.png",
                                )),
                            SizedBox(
                              width: 15,
                            ),
                            Flexible(
                              fit: FlexFit.loose,
                              child: Text(
                                "${snapshot.data.data.pickupAddress}",
                                style: GoogleFonts.poppins(fontWeight: FontWeight.w400, fontSize: screenWidth * 0.040, color: Colors.black),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                                width: (screenWidth * 0.08) + 15,
                                height: 10,
                                ),
                            // SizedBox(
                            //   width: 15,
                            // ),
                            SizedBox(
                              width: screenWidth*0.72,
                              child: Divider(
                                height: 0.5,
                                color: Colors.black26,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                                width: screenWidth * 0.08,
                                height: screenWidth * 0.08,
                                child: Image.asset(
                                  "assets/images/icons/bikeRide_icon/drop.png",
                                  width: screenWidth * 0.08,
                                )),
                            SizedBox(
                              width: 15,
                            ),
                            Flexible(
                              fit: FlexFit.loose,
                              child: Text(
                                "${snapshot.data.data.dropAddress}",
                                style: GoogleFonts.poppins(fontWeight: FontWeight.w400, fontSize: screenWidth * 0.040, color: Colors.black),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  Container(
                    alignment: Alignment.centerLeft,
                    clipBehavior: Clip.hardEdge,
                    width: screenWidth,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(12.0), color: Colors.white),
                    padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                    margin: EdgeInsets.fromLTRB(0, 5, 0, 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Journey Details",
                          style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: screenWidth * 0.038, color: Colors.black),
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        Row(
                          children: [
                            Image.asset(
                              "assets/images/icons/bikeRide_icon/speed.png",
                              width: screenWidth * 0.08,
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Text(
                              "\u20B9",
                              style: TextStyle(fontSize: screenWidth * 0.038),
                            ),
                            Text(
                              " ${snapshot.data.data.payableAmount}",
                              style: GoogleFonts.poppins(fontWeight: FontWeight.w400, fontSize: screenWidth * 0.038, color: Colors.black),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                          children: [
                            Image.asset(
                              "assets/images/icons/bikeRide_icon/distance.png",
                              width: screenWidth * 0.08,
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Text(
                              "${snapshot.data.data.projectedDistance} km",
                              style: GoogleFonts.poppins(fontWeight: FontWeight.w400, fontSize: screenWidth * 0.038, color: Colors.black),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                          children: [
                            Image.asset(
                              "assets/images/icons/bikeRide_icon/cal.png",
                              width: screenWidth * 0.08,
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Text(
                              "${DateFormat.yMMMMEEEEd().format(DateFormat("yyyy-MM-dd").parse(snapshot.data.data.createdAt, true))}",
                              style: GoogleFonts.poppins(fontWeight: FontWeight.w400, fontSize: screenWidth * 0.038, color: Colors.black),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Visibility(
                  //   visible: snapshot.data.data.carrier.user.mobileNumber!=null && (snapshot.data.data.status=="ASSIGNED" || snapshot.data.data.status=="ENROUTE"),
                  //   child: Container(
                  //     padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                  //     margin: EdgeInsets.fromLTRB(0, 5, 0, 10),
                  //     clipBehavior: Clip.hardEdge,
                  //     decoration: BoxDecoration(borderRadius: BorderRadius.circular(12.0), color: Colors.white),
                  //     child: Row(
                  //       mainAxisAlignment: MainAxisAlignment.center,
                  //       children: [
                  //         Expanded(
                  //           flex: 3,
                  //           child: Column(
                  //             crossAxisAlignment: CrossAxisAlignment.start,
                  //             children: [
                  //               Text("Ride Partner Details",
                  //                   style: GoogleFonts.poppins(
                  //                       fontSize: screenWidth * 0.038,
                  //                       color: Colors.black,
                  //                       fontWeight: FontWeight.w600)),
                  //               SizedBox(
                  //                 height: 5,
                  //               ),
                  //               Row(
                  //                 children: [
                  //                   Expanded(
                  //                     flex: 1,
                  //                     child: Text("Name :",
                  //                         style: GoogleFonts.poppins(
                  //                             fontSize: 12,
                  //                             color: Colors.black,
                  //                             fontWeight: FontWeight.w500)),
                  //                   ),
                  //                   Expanded(
                  //                     flex: 4,
                  //                     child: Text("${snapshot.data.data.carrier.user.name??"Courier Name"}",
                  //                         overflow: TextOverflow.ellipsis,
                  //                         style: GoogleFonts.poppins(
                  //                             fontSize: 12,
                  //                             color: Colors.black87,
                  //                             fontWeight: FontWeight.w500)),
                  //                   ),
                  //
                  //                 ],
                  //               ),
                  //               Row(
                  //                 children: [
                  //                   Expanded(
                  //                     flex: 1,
                  //                     child: Text("Mobile :",
                  //                         style: GoogleFonts.poppins(
                  //                             fontSize: 12,
                  //                             color: Colors.black,
                  //                             fontWeight: FontWeight.w500)),
                  //                   ),
                  //                   Expanded(
                  //                     flex: 4,
                  //                     child: Text("${snapshot.data.data.carrier.user.mobileNumber??"Courier Mobile Number"}",
                  //                         overflow: TextOverflow.ellipsis,
                  //                         style: GoogleFonts.poppins(
                  //                             fontSize: 12,
                  //                             color: Colors.black87,
                  //                             fontWeight: FontWeight.w500)),
                  //                   ),
                  //
                  //                 ],
                  //               )
                  //             ],
                  //           ),
                  //         ),
                  //         Expanded(
                  //           flex: 1,
                  //           child: ButtonTheme(
                  //             /*__To Enlarge Button Size__*/
                  //             height: 30.0,
                  //             minWidth: 70.0,
                  //             child: RaisedButton(
                  //               shape: RoundedRectangleBorder(
                  //                 borderRadius: BorderRadius.circular(10.0),
                  //               ),
                  //               onPressed: () {
                  //                 print(snapshot.data.data.carrier.user.mobileNumber);
                  //                 launch('tel: ${snapshot.data.data.carrier.user.mobileNumber}');
                  //               },
                  //               color: orangeCol,
                  //               textColor: Colors.white,
                  //               child: Row(
                  //                 children: [
                  //                   Icon(Icons.call,size: 13,),
                  //                   SizedBox(
                  //                     width: 2,
                  //                   ),
                  //                   Text("Call", style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w500)),
                  //                 ],
                  //               ),
                  //             ),
                  //           ),
                  //         ),
                  //
                  //       ],
                  //     ),
                  //   ),
                  // ),

                  Container(
                    margin: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 15.0),
                    padding: EdgeInsets.all(12.0),
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(12.0), color: Colors.white),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Invoice Details",
                                style: GoogleFonts.poppins(
                                    fontSize: screenWidth * 0.038,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600)),
                            Spacer(),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text("$userName",
                                    style: GoogleFonts.poppins(
                                        fontSize: screenWidth * 0.035,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w400)),
                                // Text("$userEmail",
                                //     style: GoogleFonts.poppins(
                                //         fontSize: 11.5,
                                //         color: Colors.black54,
                                //         fontWeight: FontWeight.w400)),
                                Text("$userPhone",
                                    style: GoogleFonts.poppins(
                                        fontSize: screenWidth * 0.033,
                                        color: Colors.black54,
                                        fontWeight: FontWeight.w400)),

                              ],
                            )
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(1.0, 8.0, 1.0, 10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [

                              /*
                              Row(
                                children: [
                                  Text(
                                    "Ride Fare ",
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.poppins(color: Colors.black87, fontWeight: FontWeight.w400, fontSize: screenWidth * 0.036),
                                  ),
                                  Spacer(),
                                  Text(
                                    "Rs. ${snapshot.data.data.tripCharge} ",
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.poppins(color: Colors.black87, fontWeight: FontWeight.w400, fontSize: screenWidth * 0.036),
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    "Tax & GST ",
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.poppins(color: Colors.black87, fontWeight: FontWeight.w400, fontSize: screenWidth * 0.036),
                                  ),
                                  Spacer(),
                                  Text(
                                    "+  Rs. ${snapshot.data.data.tax} ",
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.poppins(color: Colors.black87, fontWeight: FontWeight.w400, fontSize: screenWidth * 0.036),
                                  )
                                ],
                              ),



                               */

                            ],
                          ),
                        ),
                        Divider(
                          height: 0.5,
                          color: Colors.black26,
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(1.0, 8.0, 1.0, 10.0),
                          child: Row(
                            children: [
                              Text(
                                "Total Trip Charge ",
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.poppins(color: orangeCol, fontWeight: FontWeight.w600, fontSize: screenWidth * 0.036),
                              ),
                              Spacer(),
                              Text(
                                "Rs. ${snapshot.data.data.payableAmount} ",
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.poppins(color: orangeCol, fontWeight: FontWeight.w600, fontSize: screenWidth * 0.036),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  ButtonTheme(
                    /*__To Enlarge Button Size__*/
                    height: 50.0,
                    minWidth: screenWidth * 0.4,
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
                          Image.asset("assets/images/icons/support.png",height: 20,),
                          Text("   Support", style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500)),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 15,),
                ],
              );
            } else if (snapshot.hasError) {
              print(snapshot.error);
              return Center(
                  child: Text(
                "Oops! Something Went Wrong",
                style: GoogleFonts.poppins(fontWeight: FontWeight.w500, fontSize: screenWidth * 0.042, color: Colors.white),
              ));
            } else {
              return ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: 6,
                  itemBuilder: (context, index) {
                    return ListTileShimmer(
                      padding: EdgeInsets.only(top: 0, bottom: 0),
                      margin: EdgeInsets.only(top: 20, bottom: 20),
                      height: 60,
                      isDisabledAvatar: true,
                      isRectBox: true,
                      colors: [Colors.white],
                    );
                  });
            }
          },
        ),
      ),
    );
  }

  Future<void> _getBikerMarkerImage() async {
    // ByteData byteDataPickup = await DefaultAssetBundle.of(context).load("assets/images/icons/bikeRide_icon/pin_green_round.png");
    // pickupIcon = byteDataPickup.buffer.asUint8List();
    // ByteData byteDataDrop = await DefaultAssetBundle.of(context).load("assets/images/icons/bikeRide_icon/pin_red_round.png");
    // dropIcon = byteDataDrop.buffer.asUint8List();
    ByteData byteDataPickup = await DefaultAssetBundle.of(context).load("assets/images/icons/bikeRide_icon/green_location.png");
    pickupIcon = byteDataPickup.buffer.asUint8List();
    ByteData byteDataDrop = await DefaultAssetBundle.of(context).load("assets/images/icons/bikeRide_icon/red_location.png");
    dropIcon = byteDataDrop.buffer.asUint8List();
  }

  _addMarker(LatLng position, String id, BitmapDescriptor descriptor) {
    MarkerId markerId = MarkerId(id);
    Marker marker = Marker(markerId: markerId, icon: descriptor, position: position);
    markers[markerId] = marker;
  }

  _addPolyLine() {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(polylineId: id, color: Color.fromRGBO(52, 52, 52, 1), points: polylineCoordinates, width: 2);
    polylines[id] = polyline;
    setState(() {});
  }

  _getPolyline(double pickLat, double pickLng, double dropLat, double dropLng) async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        mapAPIKey, PointLatLng(pickLat, pickLng), PointLatLng(dropLat, dropLng),
        travelMode: TravelMode.driving, wayPoints: [PolylineWayPoint(location: "")]);
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
    _addPolyLine();
  }
}
