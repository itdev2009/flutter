import 'package:delivery_on_time/constants.dart';
import 'package:delivery_on_time/help/api_response.dart';
import 'package:delivery_on_time/pickup_drop_screen/model/pickupDropShowModel.dart' as pdsm;
import 'package:delivery_on_time/tracking_screen/bloc/mapTrackingPickDropBloc.dart';
import 'package:delivery_on_time/tracking_screen/model/mapTrackingPickDropModel.dart';
import 'package:delivery_on_time/tracking_screen/repository/mapTrackingRepository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:async';
import 'dart:typed_data';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapTrackingPickUpDropPage extends StatefulWidget {
  final String userToken;
  final String carrierId;
  final pdsm.Data pickUpDropData;

  const MapTrackingPickUpDropPage({Key key, this.carrierId,this.pickUpDropData,this.userToken}) : super(key: key);

  @override
  _MapTrackingPageState createState() => _MapTrackingPageState(carrierId,pickUpDropData,userToken);
}

class _MapTrackingPageState extends State<MapTrackingPickUpDropPage> {
  final String userToken;
  final String carrierId;
  final pdsm.Data pickUpDropData;


  Timer timer;


  _MapTrackingPageState(this.carrierId,this.pickUpDropData,this.userToken);

  var statusCol;

  LocationData currentLocationUser;
  LocationData currentLocationDeliveryBoy;
  bool locUpdate=false;
  bool initdispose=true;

  StreamSubscription _locationSubscription;
  Location _locationTracker = Location();
  Marker marker;
  Circle circle;
  GoogleMapController _controller;
  List<Marker> markers;

  MapTrackingRepository _mapTrackingRepository;
  MapTrackingPickDropBloc _mapTrackingPickDropBloc;
  Stream _trackingStream;
  Uint8List imageData;

  @override
  void initState() {
    super.initState();
    _mapTrackingRepository = new MapTrackingRepository();
    _mapTrackingPickDropBloc = new MapTrackingPickDropBloc();
    _trackingStream = _mapTrackingPickDropBloc.mapTrackingStream;
    _mapTrackingPickDropBloc.mapTrackingPickDrop(carrierId,userToken);
    locUpdate=true;
    setUpTimedFetch(carrierId);
    if(pickUpDropData.status=="ASSIGNED"){
      statusCol=Colors.orangeAccent;
    }else if(pickUpDropData.status=="DELIVERED"){
      statusCol=Colors.green;
    }else if(pickUpDropData.status=="PENDING"){
      statusCol=Colors.red[900];
    }else if(pickUpDropData.status=="IN_TRANSIT"){
      statusCol=Colors.teal[600];
    }
  }

  setUpTimedFetch(String carrierID) async {
    imageData = await getMarker();
    if(initdispose){
     timer= Timer.periodic(Duration(milliseconds: 5000), (timer) {
        setState(() {
          locUpdate=true;
          _mapTrackingPickDropBloc.mapTrackingPickDrop(carrierID,userToken);
        });
      });
    }

  }

  static final CameraPosition initialLocation = CameraPosition(
    target: LatLng(22.649375, 88.391528),
    zoom: 14.4746,
  );

  Future<Uint8List> getMarker() async {
    ByteData byteData = await DefaultAssetBundle.of(context)
        .load("assets/images/icons/bike_icon3.png");
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
    initdispose=false;
    timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: lightThemeBlue,
        /*appBar: AppBar(
          title: Text("Map"),
        ),*/
        body: Container(
          height: screenHeight,
          width: screenWidth,
          child: SingleChildScrollView (
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                StreamBuilder<ApiResponse<MapTrackingPickDropModel>>(
                  stream: _mapTrackingPickDropBloc.mapTrackingStream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      switch (snapshot.data.status) {
                        case Status.LOADING:
                          return Container();
                          break;
                        case Status.COMPLETED:
                          if(snapshot.data.data.data.longitude!=null){
                            if(locUpdate){

                              try {
                                Map<String, double> mapData = {
                                  "latitude":
                                  double.parse(snapshot.data.data.data.latitude),
                                  "longitude":
                                  double.parse(snapshot.data.data.data.longitude)
                                };
                                locUpdate=true;

                                currentLocationDeliveryBoy =
                                new LocationData.fromMap(mapData);

                                updateMarkerAndCircle(currentLocationDeliveryBoy, imageData);

                                if (_locationSubscription != null) {
                                  _locationSubscription.cancel();
                                }

                                _locationSubscription =
                                    _locationTracker.onLocationChanged.listen((newLocalData) {
                                      if (_controller != null) {
                                        _controller.animateCamera(CameraUpdate.newCameraPosition(
                                            new CameraPosition(
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
                              locUpdate=false;
                            }


                          }
                          else{
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
                  margin: EdgeInsets.only(top: screenHeight*0.007,right: screenHeight*0.007,left: screenHeight*0.007),
                  height: screenHeight * 0.55,
                  width: screenWidth * 0.985,
                  child: GoogleMap(
                    myLocationEnabled: true,
                    compassEnabled: true,
                    myLocationButtonEnabled: true,
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
                  color: Colors.white,
                  height: screenHeight*0.385,
                  width: screenWidth,
                  margin: EdgeInsets.only(top: screenHeight*0.012,right: screenHeight*0.007,left: screenHeight*0.007,bottom: screenHeight*0.007),
                  padding: EdgeInsets.all(25.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Container(
                          // color: Colors.orange,
                          width: screenWidth,
                          child: Row(
                            children: [
                              Text("Order Details",
                              style: TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.w500,
                              ),),
                              Spacer(),
                              InkWell(
                                  onTap: (){
                                    Navigator.pop(context);
                                  },
                                  child: Icon(Icons.cancel_outlined))
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Divider(
                          color: Colors.orange,
                          height: screenHeight*0.03,
                          thickness: 2,
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Row(
                          children: [
                            Text("Order Number : ",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),),
                            Text("${pickUpDropData.id}",
                              style: TextStyle(
                                fontSize: 15,
                              ),),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Row(
                          children: [
                            Text("Product Name : ",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),),
                            Flexible(
                              child: Text("${pickUpDropData.productName}",
                                style: TextStyle(
                                  fontSize: 13,
                                ),),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Row(
                          children: [
                            Text("Date : ",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),),
                            Text("${pickUpDropData.createdAt}",
                              style: TextStyle(
                                fontSize: 15,
                              ),),
                          ],
                        ),
                      ),


                      Expanded(
                        flex: 2,
                        child: Row(
                          children: [
                            Text("Deliver to : ",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),),
                            Flexible(
                              // flex: 5,
                              child: Text("${pickUpDropData.receiverAddress}",
                                style: TextStyle(
                                  fontSize: 14,
                                ),),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Row(
                          children: [
                            Text("Order Status : ",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),),
                            Text("${pickUpDropData.status}",
                              style: TextStyle(
                                fontSize: 14,
                                color: statusCol,

                              ),),
                          ],
                        ),
                      ),

                    ],
                  ),
                ),

              ],
            ),
          ),
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