import 'dart:typed_data';

import 'package:delivery_on_time/help/api_response.dart';
import 'package:delivery_on_time/loginMobile_screen/loginByMobile.dart';
import 'package:delivery_on_time/loginMobile_screen/otpVerificationPage.dart';
import 'package:delivery_on_time/pickup_drop_screen/bloc/mapDistanceBloc.dart';
import 'package:delivery_on_time/pickup_drop_screen/model/mapDistanceModel.dart';
import 'package:delivery_on_time/rideService/model/rideBookingListModel.dart';
import 'package:delivery_on_time/rideService/repository/bikeRideRepository.dart';
import 'package:delivery_on_time/rideService/rideDataClass.dart';
import 'package:delivery_on_time/rideService/rideRouteScreen.dart';
import 'package:delivery_on_time/rideService/bikeRideMapLocation.dart';
import 'package:delivery_on_time/rideService/rideTrackingPage.dart';
import 'package:delivery_on_time/widgets/noInternetBackground.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';
import 'model/bikerAvailableModel.dart';


class RideStartingPage extends StatefulWidget {

  final RideDataStore rideDataStore;

  const RideStartingPage({Key key, this.rideDataStore}) : super(key: key);
  @override
  _RideStartingPageState createState() => _RideStartingPageState(rideDataStore);
}

class _RideStartingPageState extends State<RideStartingPage> {

  _RideStartingPageState(this._rideDataStore);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _phoneNumberController=new TextEditingController();
  TextEditingController _pickupTextController=new TextEditingController();
  TextEditingController _destinationTextController=new TextEditingController();

  RideDataStore _rideDataStore;
  bool mapApiCheck = false;
  MapDistanceBloc _mapDistanceBloc;

  Future<BikerAvailableModel> _bikeAvailableFuture;
  Future<BikerAvailableModel> _carsAvailableFuture;
  BikeRideRepository _bikeRideRepository;

  Uint8List bikeImage01;
  Uint8List bikeImage02;
  Uint8List carImage;
  Uint8List pickupIcon;
  Uint8List dropIcon;
  LocationData availableBikeLocation;

  GoogleMapController mapController;
  Map<MarkerId, Marker> markers = {};
  String googleAPiKey = mapAPIKey;
  CameraPosition initialCameraPosition;

  bool oneTimeBikerUpdate = true;
  bool pageLoadCheck =false;
  bool ridePriceAvailableCheck =false;
  bool rideCreateCheck = false;
  bool expiredToken = false;

  SharedPreferences prefs;
  String userToken;
  String userId;
  Map _bodyBikeAvailable;
  Map _bodyCarsAvailable;
  bool show = false;

  @override
  void initState() {
    super.initState();
    if(_rideDataStore!=null){
      print("data null naaii");
      print(_rideDataStore.toString());
      print(_rideDataStore.pickLng);
      print(_rideDataStore.dropLat);
      print(_rideDataStore.pickUpLocation);

      _pickupTextController.text=_rideDataStore.pickUpLocation!=null?_rideDataStore.pickUpLocation.formattedAddress:"";
      _destinationTextController.text=_rideDataStore.dropLocation!=null?_rideDataStore.dropLocation.formattedAddress:"";

    }else{
      print("data null");



      _rideDataStore = new RideDataStore();
    }

    _mapDistanceBloc = new MapDistanceBloc();
    _bikeRideRepository = new BikeRideRepository();
    createSharedPref();
    _getBikerMarkerImage();


    initialCameraPosition = CameraPosition(
        target: LatLng(userLat!=null?userLat:22.601775, userLong!=null?userLong:88.373685), zoom: 13);


  }

  Future<void> createSharedPref() async {
    prefs = await SharedPreferences.getInstance();
    userToken = prefs.getString("user_token");
    userId = prefs.getString("user_id");

    print('this is the user id :');
    print(userId);

    _bodyBikeAvailable = {
      "vehicle_type": "ALL",
      "maximum_distance": "5",
      "latitude": "${userLat!=null?userLat:22.601775}",
      "longitude": "${userLong!=null?userLong:88.373685}"
    };

    _bodyCarsAvailable = {
      "vehicle_type": "4W",
      "maximum_distance": "5",
      "latitude": "${userLat!=null?userLat:22.601775}",
      "longitude": "${userLong!=null?userLong:88.373685}"
    };
   //_bodyCarsAvailable['abc'] = 3;



   print('TEST MAP:');
   print(_bodyCarsAvailable);

    _bikeAvailableFuture = _bikeRideRepository.availableBike(_bodyBikeAvailable, userToken);
    //_carsAvailableFuture = _bikeRideRepository.availableBike(_bodyCarsAvailable, userToken);

    print(_bikeAvailableFuture);
    print(_carsAvailableFuture);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // appBar: CustomAppBarBikeRide(),
        backgroundColor: darkThemeBlue,
        body: FutureBuilder<BikerAvailableModel>(
            future: _bikeAvailableFuture,
            builder: (context, snapshot) {
             // print(snapshot.data.message);

              if(snapshot.connectionState == ConnectionState.waiting)
              {

                print('in waiting');
                return Container();
              }

              if(snapshot.connectionState == ConnectionState.none)
              {

                print('in none');
                return Container();
              }



             //  Future.delayed(Duration(seconds: 0), () {

             //  print('wait line');


               if(snapshot.data.message.toString().contains("Token has been expired")) {
                 print('token expired');
                 //  modalSheetToLogin();

               //  Navigator.pop(context);


                 userLogin=false;
                 prefs.clear();
                 // signOutUser();
                 // logout();
                 // Navigator.pushReplacement(context,
                 //     MaterialPageRoute(builder: (BuildContext context) {
                 //       return Login();

                 //     }));

                 Fluttertoast.showToast(
                     msg: "Your login session has expired, please re-login!",
                     fontSize: 14,
                     backgroundColor: Colors.orange[100],
                     textColor: darkThemeBlue,
                     toastLength: Toast.LENGTH_LONG);

                 //Navigator.of(context).pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);

                // Navigator.pop(context);

                 Future.delayed(Duration.zero, () {
                 //  Navigator. ...

                   Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context) => LoginByMobilePage() ), ModalRoute.withName('/home'));
                 });





                 expiredToken = true;

                 return Container();

                 //  Future.delayed(Duration(seconds: 1), () {
                 //  print('wait line');
                 //  });
               }
               if (snapshot.hasData && expiredToken == false) {
                 print('this line executes');
                 if (oneTimeBikerUpdate && snapshot.data.data.length > 0) {
                   for (int i = 0; i < snapshot.data.data.length; i++) {
                     Map<String, double> mapData = {
                       "latitude": double.parse(snapshot.data.data[i].latitude),
                       "longitude": double.parse(snapshot.data.data[i].longitude)
                     };

                     availableBikeLocation = new LocationData.fromMap(mapData);

                     _updateBikerMarkerAndCircle(
                         availableBikeLocation, snapshot.data.data[i].id.toString(),snapshot.data.data[i].vehicleType == '4W' ? carImage : (i % 2 == 0) ? bikeImage02 : bikeImage01);
                   }
                   Future.delayed(Duration.zero, () {
                     setState(() {
                       pageLoadCheck=true;
                     });
                   });
                   oneTimeBikerUpdate = false;
                 }

                 return SizedBox(
                   width: screenWidth,
                   height: screenHeight,
                   child: Stack(
                     //overflow: Overflow.visible,
                     clipBehavior: Clip.none,
                     children: [
                       Container(
                           margin: EdgeInsets.only(top: 97),
                           height: screenHeight * 0.5,
                           width: screenWidth,
                           child: GoogleMap(
                             myLocationEnabled: true,
                             compassEnabled: false,
                             myLocationButtonEnabled: false,
                             zoomControlsEnabled: false,
                             mapToolbarEnabled: false,
                             trafficEnabled: true,
                             indoorViewEnabled: false,
                             mapType: MapType.terrain,
                             initialCameraPosition: initialCameraPosition,
                             markers: Set<Marker>.of(markers.values),
                             onMapCreated: (GoogleMapController controller) {
                               mapController = controller;
                             },
                           )),
                       Positioned(
                         bottom: screenHeight * 0.33,
                         right: 18,
                         child: InkWell(
                           onTap: () {
                             mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
                                 target: LatLng(userLat!=null?userLat:22.601775, userLong!=null?userLong:88.373685), zoom: 13)));
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
                       Container(
                         height: 115.0,
                         child: Column(
                           children: [
                             //Upper Container with Address and icons....
                             Padding(
                               padding: const EdgeInsets.fromLTRB(15.0, 15.0, 13.0, 15.0),
                               child: Row(
                                 children: [
                                   Icon(
                                     Icons.location_on,
                                     color: Colors.white,
                                     size: 15,
                                   ),
                                   SizedBox(
                                     width: 4,
                                   ),

                                   //Address Text....
                                   Text(
                                     "Select Pickup Location",
                                     overflow: TextOverflow.visible,
                                     style: GoogleFonts.poppins(color: Colors.white, fontSize: 13),
                                   ),

                                 ],
                               ),
                             ),

                             //Search TextFiled Container....
                             Container(
                               height: 45.0,
                               alignment: Alignment.topCenter,
                               margin: EdgeInsets.fromLTRB(15, 0, 15, 10),
                               padding: EdgeInsets.fromLTRB(0, 0, 15, 0),
                               decoration: BoxDecoration(
                                 color: Colors.white,
                                 borderRadius: BorderRadius.all(Radius.circular(5.0)),
                               ),
                               child: TextField(
                                 readOnly: true,
                                 controller: _pickupTextController,
                                 style: TextStyle(fontSize: 14.0),
                                 textAlignVertical: TextAlignVertical.top,
                                 decoration: InputDecoration(
                                     prefixIcon: Icon(Icons.search,color: Colors.green,),
                                     hintText: "Search Pickup",
                                     hintStyle: GoogleFonts.poppins(
                                       color: Colors.grey,
                                       fontSize: 14.5,
                                     ),
                                     border: InputBorder.none),
                                 onTap: () {
                                   Navigator.pushReplacement(
                                       context,
                                       MaterialPageRoute(
                                           builder: (BuildContext context) => BikeRideMapLocation(
                                             locationType: "pickup",
                                             rideDataStore: _rideDataStore,
                                           )));
                                 },
                               ),
                             ),
                           ],
                         ),

                         // height: preferredSize.height,
                         // color: lightThemeBlue,
                         alignment: Alignment.center,
                         decoration: BoxDecoration(
                           color: lightThemeBlue,
                           borderRadius: BorderRadius.vertical(bottom: Radius.circular(20.0)),
                         ),
                         // child: child,
                       ),
                       Positioned(
                         bottom: 0,
                         child: Container(
                           padding: EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 15.0),
                           alignment: Alignment.center,
                           decoration: BoxDecoration(
                             color: darkThemeBlue,
                             borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
                           ),
                           height: screenHeight*0.3,
                           width: screenWidth,
                           child: Column(
                             children: [
                               //Upper Container with Address and icons....
                               Row(
                                 children: [
                                   Icon(
                                     Icons.location_on,
                                     color: Colors.white,
                                     size: 15,
                                   ),
                                   SizedBox(
                                     width: 4,
                                   ),

                                   //Address Text....
                                   Text(
                                     "Select Destination Location",
                                     overflow: TextOverflow.visible,
                                     style: GoogleFonts.poppins(color: Colors.white, fontSize: 13),
                                   ),

                                 ],
                               ),

                               //Search TextFiled Container....
                               Container(
                                 height: 45.0,
                                 alignment: Alignment.topCenter,
                                 margin: EdgeInsets.fromLTRB(0, 15, 0, 10),
                                 padding: EdgeInsets.fromLTRB(0, 0, 15, 0),
                                 decoration: BoxDecoration(
                                   color: Colors.white,
                                   borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                 ),
                                 child: TextField(
                                   readOnly: true,
                                   controller: _destinationTextController,
                                   style: TextStyle(fontSize: 14.0),
                                   textAlignVertical: TextAlignVertical.top,
                                   decoration: InputDecoration(
                                       prefixIcon: Icon(Icons.search,color: Colors.red,),
                                       hintText: "Search Destination",
                                       hintStyle: GoogleFonts.poppins(
                                         color: Colors.grey,
                                         fontSize: 14.5,
                                       ),
                                       border: InputBorder.none),
                                   onTap: () {
                                     Navigator.pushReplacement(
                                         context,
                                         MaterialPageRoute(
                                             builder: (BuildContext context) => BikeRideMapLocation(
                                               locationType: "destination",
                                               rideDataStore: _rideDataStore,
                                             )));

                                   },
                                 ),
                               ),

                               //Proceed Button.....
                               ButtonTheme(
                                 //__To Enlarge Button Size__
                                 height: 50.0,
                                 minWidth: screenWidth,
                                 child: RaisedButton(
                                   shape: RoundedRectangleBorder(
                                     borderRadius: BorderRadius.circular(12.0),
                                   ),
                                   onPressed: () {
                                     {
                                       if (userToken == "" || userToken==null) {
                                         modalSheetToLogin();
                                       }else if (_rideDataStore.pickUpLocation != null && _rideDataStore.dropLocation != null) {
                                         mapApiCheck = true;
                                         _mapDistanceBloc.mapDistanceCal(_rideDataStore.pickLat, _rideDataStore.pickLng,
                                             _rideDataStore.dropLat, _rideDataStore.dropLng);
                                       }else{
                                         Fluttertoast.showToast(
                                             msg: "Please Select Pickup and Drop Location",
                                             fontSize: 15,
                                             backgroundColor: Colors.orange[100],
                                             textColor: darkThemeBlue,
                                             toastLength: Toast.LENGTH_LONG);
                                       }
                                     }
                                   },
                                   color: orangeCol,
                                   textColor: Colors.white,
                                   child: StreamBuilder<ApiResponse<MapDistanceModel>>(
                                     stream: _mapDistanceBloc.mapDistanceStream,
                                     builder: (context, snapshot) {
                                       if (mapApiCheck) {
                                         if (snapshot.hasData) {
                                           switch (snapshot.data.status) {
                                             case Status.LOADING:
                                               return CircularProgressIndicator(
                                                   backgroundColor: circularBGCol,
                                                   strokeWidth: strokeWidth,
                                                   valueColor: AlwaysStoppedAnimation<Color>(circularStrokeCol));

                                               break;
                                             case Status.COMPLETED:
                                               {
                                                 if (snapshot.data.data.rows[0].elements[0].status == "ZERO_RESULTS") {
                                                   mapApiCheck = false;
                                                   Fluttertoast.showToast(
                                                       msg: "Please Select a Proper Pickup or Drop Place",
                                                       fontSize: 14,
                                                       backgroundColor: Colors.orange[100],
                                                       textColor: darkThemeBlue,
                                                       toastLength: Toast.LENGTH_LONG);
                                                 } else {
                                                   mapApiCheck = false;
                                                   int distance = snapshot.data.data.rows[0].elements[0].distance.value;
                                                   _rideDataStore.distance = distance / 1000;
                                                   _rideDataStore.travellingTime = snapshot.data.data.rows[0].elements[0].duration.text;
                                                   _rideDataStore.distanceText = snapshot.data.data.rows[0].elements[0].distance.text;

                                                   Future.delayed(Duration.zero, () {
                                                     Navigator.push(
                                                         context,
                                                         MaterialPageRoute(
                                                             builder: (BuildContext context) => RideRouteScreen(
                                                               userToken: userToken,
                                                               rideDataStore: _rideDataStore,
                                                               userId: userId,
                                                             )));
                                                   });
                                                 }
                                               }
                                               break;
                                             case Status.ERROR:
                                               mapApiCheck = false;
                                               Fluttertoast.showToast(
                                                   msg: "Please try again!",
                                                   fontSize: 14,
                                                   backgroundColor: Colors.orange[100],
                                                   textColor: darkThemeBlue,
                                                   toastLength: Toast.LENGTH_LONG);
                                               print(snapshot.data.message);
                                               break;
                                           }
                                         } else if (snapshot.hasError) {
                                           mapApiCheck = false;
                                           print(snapshot.error);
                                         }
                                       }
                                       return Text("Proceed",
                                           style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w500));
                                     },
                                   ),
                                 ),
                               ),

                               Visibility(
                                 visible: true,
                                 child: Container(

                                     color: Colors.white.withOpacity(0),

                                     child: FutureBuilder<RideBookingListModel>
                                       (
                                         future: _bikeRideRepository.rideHomerideBookingList(userToken),
                                         builder: (context,snapshot)
                                         {

                                           print('Entering builder');

                                           if(snapshot.connectionState == ConnectionState.waiting)
                                           {

                                             print('in waiting');
                                             return Container();
                                           }
                                           if(snapshot.hasError)
                                           {
                                             print(snapshot.error);
                                           }



                                           if(snapshot.hasData)
                                           {



                                             print('DATA PRESENT');
                                             print(snapshot.data.data.length);

                                             if(snapshot.data.data.length == 0){
                                               return Container();
                                             }
                                             print(snapshot.data.data[0].pickupAddress);
                                             print('printing snapshot data:');
                                             // print(snapshot.data.data.id);

                                             return Padding(
                                               padding: const EdgeInsets.only(top:10.0,right:16,left:16,),
                                               child: ClipRRect(
                                                 borderRadius: BorderRadius.circular(10),
                                                 child: SizedBox
                                                   (

                                                   height: 68,
                                                   width: 500,
                                                   child: ListView.builder(


                                                     itemCount: snapshot.data.data.length,

                                                     itemBuilder: (context,index){

                                                       double d = double.parse(snapshot.data.data[index].payableAmount);

                                                       if( snapshot.data.data[index].id == 181 )
                                                       {
                                                         return Container();
                                                       }

                                                       else{


                                                         return Container(
                                                           height: 68,
                                                           decoration: BoxDecoration(
                                                             color: Colors.white,
                                                           ),
                                                           child: Column(
                                                             crossAxisAlignment: CrossAxisAlignment.center,
                                                             children: [

                                                               Row(
                                                                 mainAxisAlignment: MainAxisAlignment.center,
                                                                 children: [

                                                                   /*

                                                                  Icon(Icons.arrow_right_alt_outlined),

                                                                  Text('${snapshot.data.data[index].actualDistance} km', style: GoogleFonts.poppins(color: Colors.black54),     ),

                                                                  Padding(
                                                                    padding: const EdgeInsets.only(left:15.0),
                                                                    child: Text('₹',  style: GoogleFonts.poppins(),  ),
                                                                  ),

                                                                  Padding(
                                                                    padding: const EdgeInsets.only(left:3.0),
                                                                    child: Text('${d}',  style: GoogleFonts.poppins(color: Colors.black54),),
                                                                  ),

                                                                  Padding(
                                                                    padding: const EdgeInsets.only(left:10.0,right:3,),
                                                                    child: Icon(Icons.timelapse),
                                                                  ),

                                                                  Text('${snapshot.data.data[index].status}', style: GoogleFonts.poppins(color: Colors.black54), ),




                                                                   */

                                                                   Padding(
                                                                     padding: const EdgeInsets.only(left:8.0,right:3.0,top:8,),
                                                                     child: CircleAvatar(

                                                                       radius: 26,

                                                                       backgroundColor: Colors.black26,

                                                                       child: Image.asset("assets/images/icons/bikeRide_icon/bike_image04.png"),

                                                                     ),
                                                                   ),

                                                                   Padding(
                                                                     padding: const EdgeInsets.only(left:3.0,top:4),
                                                                     child: Text('You have an ongoing ride',  style: GoogleFonts.poppins(color: Colors.black54),),
                                                                   ),

                                                                   Padding(
                                                                     padding: const EdgeInsets.only(left:8.0,right:3.0,top:8),
                                                                     child: SizedBox(

                                                                       height:30,

                                                                       child: TextButton(

                                                                         child: Text('   View   ', style: TextStyle(color: Colors.white,fontSize: 13)),

                                                                         style: TextButton.styleFrom(
                                                                           // primary: Colors.green,
                                                                           backgroundColor: Colors.green,
                                                                           //minimumSize: Size(55, 20),
                                                                           padding: EdgeInsets.all(0),
                                                                         ),

                                                                         onPressed: () {


                                                                           Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) { return RideTrackingPage(rideId: snapshot.data.data[index].id,userToken: userToken,); }));
                                                                         },
                                                                       ),
                                                                     ),
                                                                   ),





                                                                 ],

                                                               ),
                                                             ],
                                                           ),
                                                         );

                                                       }


                                                     },



                                                   ),
                                                 ),
                                               ),
                                             );
                                           }


                                           else{

                                             print('no trip is in transit');
                                           }

                                         }
                                     )

                                 ),
                               ),


                             ],
                           ),


                         ),
                       ),

                     ],
                   ),
                 );
               } else if (snapshot.hasError) {

                 print('error occured');
                 print(snapshot.error);
                 if(snapshot.error.toString().contains("No Internet connection")){
                   return Center(
                       child: Column(
                         children: [
                           SizedBox(
                             height: screenHeight * 0.2,
                           ),
                           NoInternetBackground(imageHeight: screenHeight*0.35,imageWidth: screenWidth*0.8,
                             onTapButton: (){
                               _bikeAvailableFuture = _bikeRideRepository.availableBike(_bodyBikeAvailable, userToken);
                               setState(() {});
                             },),
                           SizedBox(
                             height: screenHeight * 0.05,
                           ),
                         ],
                       ));
                 }
                 if(snapshot.error.toString().contains("Token has been expired"))
                 {
                   print('token expired');
                   modalSheetToLogin();
                 }
                 else
                   return Center(
                       child: Column(
                         children: [
                           SizedBox(
                             height: screenHeight * 0.2,
                           ),
                           Image.asset("assets/images/icons/sad_face.png",
                             height: screenHeight*0.1,
                           ),
                           SizedBox(
                             height: 20,
                           ),
                           Text(
                             "Oops! Something went wrong. please try again...",
                             style: TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w400),
                           ),
                           SizedBox(
                             height: 10,
                           ),
                           new FlatButton(
                               shape: RoundedRectangleBorder(
                                   side: BorderSide(color: Colors.deepOrange, width: 0.6, style: BorderStyle.solid),
                                   borderRadius: BorderRadius.circular(5)),
                               child: const Text(
                                 "Try Again",
                                 style: TextStyle(
                                     color: Colors.deepOrangeAccent, fontSize: 13.0, letterSpacing: 0.5, fontWeight: FontWeight.w400),
                               ),
                               onPressed: () {
                                 _bikeAvailableFuture = _bikeRideRepository.availableBike(_bodyBikeAvailable, userToken);
                                 setState(() {});
                               }),
                           SizedBox(
                             height: screenHeight * 0.2,
                           ),
                         ],
                       ));
               } else
                 return Center(
                   child: CircularProgressIndicator(
                       backgroundColor: circularBGCol, strokeWidth: 4, valueColor: AlwaysStoppedAnimation<Color>(circularStrokeCol)),
                 );


              //  });


            }),

      ),
    );
  }

  void _updateBikerMarkerAndCircle(LocationData newLocalData, String id, Uint8List imageData) {
    print("marker update");
    LatLng latlng = LatLng(newLocalData.latitude, newLocalData.longitude);
    MarkerId markerId = MarkerId(id);
    Future.delayed(Duration.zero, () {
      this.setState(() {
        markers[markerId] = Marker(
            markerId: markerId,
            position: latlng,
            rotation: newLocalData.latitude,
            draggable: false,
            zIndex: 2,
            flat: true,
            anchor: Offset(0.5, 0.5),
            icon: BitmapDescriptor.fromBytes(imageData));
      });
    });
  }

  Future<void> _getBikerMarkerImage() async {
    // ByteData byteData = await DefaultAssetBundle.of(context).load("assets/images/icons/bike_icon3.png");
    ByteData byteBikeIconData01 = await DefaultAssetBundle.of(context).load("assets/images/icons/bikeRide_icon/bike1.png");
    bikeImage01 = byteBikeIconData01.buffer.asUint8List();
    ByteData byteBikeIconData02 = await DefaultAssetBundle.of(context).load("assets/images/icons/bikeRide_icon/bike2.png");
    bikeImage02 = byteBikeIconData02.buffer.asUint8List();
    ByteData byteDataPickup = await DefaultAssetBundle.of(context).load("assets/images/icons/bikeRide_icon/pin_green_round.png");
    pickupIcon = byteDataPickup.buffer.asUint8List();
    ByteData byteDataDrop = await DefaultAssetBundle.of(context).load("assets/images/icons/bikeRide_icon/pin_red_round.png");
    dropIcon = byteDataDrop.buffer.asUint8List();
    ByteData byteDataCar = await DefaultAssetBundle.of(context).load("assets/images/icons/bikeRide_icon/car_png.png");
    carImage = byteDataCar.buffer.asUint8List();
  }

  modalSheetToLogin() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15.0),),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(18.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  "Please Login to Proceed",
                  style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: 6.0,
                ),
                Theme(
                  data: new ThemeData(
                    primaryColor: orangeCol,
                    primaryColorDark: Colors.black,
                  ),
                  child: TextFormField(
                    validator: (value)=> value.isEmpty?"*Phone Number Required":value.length<10?"*Please Enter Proper Phone Number":null,
                    controller: _phoneNumberController,
                    decoration: new InputDecoration(
                        labelText: "Enter Mobile Number",
                        prefixText: "+91 ",
                        prefixStyle: GoogleFonts.poppins(
                            fontSize: 13.0,
                            color: orangeCol,
                            fontWeight: FontWeight.w500
                        ),
                        labelStyle: GoogleFonts.poppins(
                            fontSize: 14.0,
                            color: Colors.black54,
                            fontWeight: FontWeight.w400
                        ),
                        fillColor: Colors.white,
                        focusColor: orangeCol,
                        hoverColor: orangeCol
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                      LengthLimitingTextInputFormatter(10),
                    ],
                    textInputAction: TextInputAction.done,
                    style: GoogleFonts.poppins(
                        fontSize: 13.0,
                        color: orangeCol,
                        fontWeight: FontWeight.w500
                    ),),
                ),
                SizedBox(
                  height: 16.0,
                ),
                InkWell(
                  onTap: (){
                    final FormState form = _formKey.currentState;
                    if (form.validate()) {
                      print('Form is valid');
                      Navigator.push(context,
                          MaterialPageRoute(builder: (BuildContext context) {
                            return OtpVerificationPage(phoneNumber: _phoneNumberController.text.trim(),
                              redirectPage: "bikeRide",);

                          }));
                    } else {
                      print('Form is invalid');
                    }
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
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [Color(0xffeb8a35), Color(0xffe36126)])),
                      child: Text(
                        'Continue',
                        style: GoogleFonts.poppins(fontSize: 15,fontWeight: FontWeight.w500, color: Colors.white),
                      )

                  ),
                ),
                // SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
              ],
            ),
          ),
        );
      },
    );
  }

}

class CustomAppBarBikeRide extends PreferredSize {

  @override
  Size get preferredSize => Size.fromHeight(120.0);

  @override
  Widget build(BuildContext context) {

    return Container(
      height: 120.0,
      child: Column(
        children: [
          //Upper Container with Address and icons....
          Padding(
            padding: const EdgeInsets.fromLTRB(15.0, 15.0, 13.0, 15.0),
            child: Row(
              children: [
                Icon(
                  Icons.location_on,
                  color: Colors.white,
                  size: 18,
                ),
                SizedBox(
                  width: 4,
                ),

                //Address Text....
                Text(
                  "Select Pickup Location",
                  overflow: TextOverflow.visible,
                  style: GoogleFonts.poppins(color: Colors.white, fontSize: 14),
                ),

              ],
            ),
          ),

          //Search TextFiled Container....
          Container(
            height: 45.0,
            alignment: Alignment.topCenter,
            margin: EdgeInsets.fromLTRB(15, 0, 15, 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
            ),
            child: TextField(
              readOnly: true,
              style: TextStyle(fontSize: 14.0),
              textAlignVertical: TextAlignVertical.top,
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search,color: Colors.green,),
                  hintText: "Search Pickup",
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 14.0,
                  ),
                  border: InputBorder.none),
              onTap: () {

              },
            ),
          ),
        ],
      ),

      // height: preferredSize.height,
      // color: lightThemeBlue,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: lightThemeBlue,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(30.0)),
      ),
      // child: child,
    );
  }
}
