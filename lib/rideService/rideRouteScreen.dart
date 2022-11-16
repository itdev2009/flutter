import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'dart:typed_data';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:delivery_on_time/help/api_response.dart';
import 'package:delivery_on_time/rideService/bloc/bikeRideCreateBloc.dart';
import 'package:delivery_on_time/rideService/model/bikeRideRateModel.dart';
import 'package:delivery_on_time/rideService/repository/bikeRideRepository.dart';
import 'package:delivery_on_time/rideService/rideDataClass.dart';
import 'package:delivery_on_time/rideService/rideTrackingPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jiffy/jiffy.dart';
import 'package:location/location.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';
import 'bikeBookingConfirmPage.dart';
import 'model/bikeRideCreateModel.dart';
import 'model/bikerAvailableModel.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:pusher_client/pusher_client.dart';



class Overlay {
  static Widget show(BuildContext context) {

    final spinkit = SpinKitRipple(
      color: Colors.white,
      size: 400.0,
    );

    return Center(
      child: Container(
        child: spinkit,
        height: MediaQuery.of(context).size.height*0.6,
        width: MediaQuery.of(context).size.width,
        color: Colors.white.withOpacity(0),
      ),
    );
  }
}



class Loading {
  static Widget show(BuildContext context) {

    final spinkit =

    SpinKitFadingFour(

      color: Colors.green,
      size: 150.0,

    );

    return Center(
      child: Container(
        child: spinkit,
        height: MediaQuery.of(context).size.height*0.6,
        width: MediaQuery.of(context).size.width,
        color: Colors.white.withOpacity(0),
      ),
    );
  }
}



class RideRouteScreen extends StatefulWidget {
  final RideDataStore rideDataStore;
  final String userToken;
  final String userId;

  const RideRouteScreen({Key key, this.rideDataStore, this.userToken, this.userId}) : super(key: key);

  @override
  _RideRouteScreenState createState() => _RideRouteScreenState(rideDataStore);
}

class _RideRouteScreenState extends State<RideRouteScreen> {
  final RideDataStore rideDataStore;

  _RideRouteScreenState(this.rideDataStore);

  GoogleMapController mapController;
  Map<PolylineId, Polyline> polylines = {};
  Map<MarkerId, Marker> markers = {};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  String googleAPiKey = mapAPIKey;
  Uint8List bikeImage01;
  Uint8List bikeImage02;
  Uint8List pickupIcon;
  Uint8List carImage;
  Uint8List dropIcon;
  LocationData availableBikeLocation;
  bool oneTimeBikerUpdate = true;
  bool itsCarRide = false;
  bool selectcheck = false;
  bool pageLoadCheck =false;
  bool ridePriceAvailableCheck =false;
  bool rideCreateCheck = false;
  bool ready = false;
  bool show = false;
  String carfare = '';
  String bikefare = '';
  TextEditingController fareText = new TextEditingController();
  TextEditingController commentText = new TextEditingController();
  PusherClient pusher;
  Channel channel;
  bool properFare = false;
  int minCarFare = 0;
  int minBikeFare = 0;
  bool showoptions = false;
  String price;
  bool secondPhase = false;
  bool negative = false;
  bool positive = false;
  bool dataready = false;
  double _progress = 1;
  int n = 0;
  bool showLoading = false;
  String tripid_notification = '';
  String offerPrice_notification = '';
  String carrierid_notification = '';
  FocusNode myFocusNode;
  bool raisefareVisible = false;
  SharedPreferences prefs;
  bool sameId = false;



  Future<BikerAvailableModel> _bikeAvailableFuture;
  Future<BikeRideRateModel> _bikeRideRateFuture;
  Future<BikeRideRateModel> carRideRateFuture;
  BikeRideRepository _bikeRideRepository;
  BikRideCreateBloc _bikRideCreateBloc;

  CameraPosition initialCameraPosition;
  List history = [];
  final ScrollController _scrollController = ScrollController();

  List<DropdownMenuItem<String>> _dropdownMenuPaymentType;
  List<String> _dropdownPaymentType = [
    "Cash Payment",
    // "Online Payment",
  ];
  String _selectedPaymentType = "Cash Payment";


  Future<void> createSharedPref() async {
    prefs = await SharedPreferences.getInstance();
    //forcake = await SharedPreferences.getInstance();
   // userToken = prefs.getString("user_token");
   // itscake = forcake.getBool('cakeprefs');
   // print('CAKE VALUE ${itscake}');
   // _configApi = _configDetailsRepository.configDetails(userToken);

    setState(() {});
  }



  @override
  void initState() {
    super.initState();

    myFocusNode = FocusNode();

    createSharedPref();

    print("ride_request_accept_${widget.userId}");

    AwesomeNotifications().actionStream.listen((receivedNotification) {
      // prints the key of the NotificationActionButton pressed
      debugPrint('Notification key pressed: ${receivedNotification.buttonKeyPressed}');

      if(receivedNotification.buttonKeyPressed == 'Accept')
        {

          print(receivedNotification.toString());

          print(receivedNotification.payload['trip_id']);

          tripid_notification = receivedNotification.payload['trip_id'];
          offerPrice_notification = receivedNotification.payload['offer_price'];


          //Accept(tripid_notification,offerPrice_notification,carrierid_notification);

        }

      if(receivedNotification.buttonKeyPressed == 'Decline')
      {

       // print(receivedNotification.toString());

       // print(receivedNotification.payload['trip_id']);

       // tripid_notification = receivedNotification.payload['trip_id'];
        //offerPrice_notification = receivedNotification.payload['offer_price'];





        int n = history.length - 1;

        for(int i=0;i<=n;i++)
          {
            if(history[i]['rider_id'] == tripid_notification)
              {
                setState(() {
                  history[i]['show'] = false;
                });
              }

          }

      }

    });

    ridesuccess = false;

    initpusher();

    initialCameraPosition = CameraPosition(
        target: LatLng((rideDataStore.pickLat + rideDataStore.dropLat) / 2, (rideDataStore.pickLng + rideDataStore.dropLng) / 2), zoom: 12);

    _bikRideCreateBloc = BikRideCreateBloc();
    _bikeRideRepository = new BikeRideRepository();
    Map _bodyBikeAvailable = {
      "vehicle_type": "ALL",
      "maximum_distance": "5",
      "latitude": "${rideDataStore.pickLat}",
      "longitude": "${rideDataStore.pickLng}"
    };

    Map _bodyBikeRate = {
      "pickup_latitude": "${rideDataStore.pickLat}",
      "pickup_longitude": "${rideDataStore.pickLng}",
      "distance": "${rideDataStore.distance}",
      "vehicle_type": "2W"
    };

    Map _bodyCarRate = {
      "pickup_latitude": "${rideDataStore.pickLat}",
      "pickup_longitude": "${rideDataStore.pickLng}",
      "distance": "${rideDataStore.distance}",
      "vehicle_type": "4W"
    };


    _dropdownMenuPaymentType = buildDropDownMenuItems(_dropdownPaymentType);

    _bikeAvailableFuture = _bikeRideRepository.availableBike(_bodyBikeAvailable, widget.userToken);
    _bikeRideRateFuture = _bikeRideRepository.rideRate(_bodyBikeRate, widget.userToken);
    carRideRateFuture = _bikeRideRepository.rideRate(_bodyCarRate, widget.userToken);
    _getBikerMarkerImage();

    _getPolyline();
  }

  List<DropdownMenuItem<String>> buildDropDownMenuItems(List listItems) {
    List<DropdownMenuItem<String>> items = List();
    for (String listItem in listItems) {
      items.add(
        DropdownMenuItem(
          child: Text(listItem),
          value: listItem,
        ),
      );
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(

      child: Scaffold(
        bottomSheet: Visibility(
          visible: show,
          child: BottomSheet(
                onClosing: (){

                },

            builder: (context){


               return Container(
                 height: 190,
                 alignment: Alignment.center,
                 child: Column(
                   crossAxisAlignment:  CrossAxisAlignment.start,
                   children: [


                     Padding(
                       padding: const EdgeInsets.only(bottom:5.0,top:10),
                       child: Center(child: Text('Recommended Price : ${price}')),
                     ),

                     Center(
                       child: Padding(
                         padding: const EdgeInsets.only(bottom: 8, right: 55, left: 55 ),
                         child: TextField(
                           autofocus: true,
                           focusNode: myFocusNode,
                            keyboardType: TextInputType.number,
                           controller: fareText,

                           onSubmitted: (v){

                             setState(() {



                               int n= int.parse(fareText.text);

                               if(itsCarRide)
                                 {
                                   if(n<minCarFare)
                                     {
                                       fareText.clear();

                                       Fluttertoast.showToast(
                                           msg: "Please specify a reasonable fare!",
                                           fontSize: 14,
                                           backgroundColor: Colors.orange[100],
                                           textColor: darkThemeBlue,
                                           toastLength: Toast.LENGTH_LONG);
                                     }

                                   else{

                                     setState(() {

                                           show = false;

                                          properFare = true;

                                     });
                                   }
                                 }
                               else{

                                 if(n<minBikeFare)
                                   {
                                     fareText.clear();

                                     Fluttertoast.showToast(
                                         msg: "Please specify a reasonable fare!",
                                         fontSize: 14,
                                         backgroundColor: Colors.orange[100],
                                         textColor: darkThemeBlue,
                                         toastLength: Toast.LENGTH_LONG);

                                   }

                                 else{

                                   setState(() {
                                     show = false;
                                     properFare = true;

                                   });

                                 }
                               }


                             });

                           },


                         ),
                       ),
                     ),

                     /*
                     Padding(
                       padding: const EdgeInsets.all(8.0),
                       child: TextField(

                         controller: commentText,
                         decoration: InputDecoration(

                           hintText: 'Comments and wishes',
                           prefixIcon: Icon(Icons.comment),
                         ),
                       ),
                     ),
                        */

                     SizedBox(
                         height: 10
                     ),

                     Center(child: Text('Specify a reasonable fare')),

                     SizedBox(
                         height: 10
                     ),


                     Padding(
                       padding: const EdgeInsets.all(8.0),
                       child: ElevatedButton(

                         child: Text('Close'),
                         onPressed: ()
                         {


                           if(fareText.text.length == 0)
                             {

                               setState(() {

                                 show = false;

                               });

                             }






                           setState(() {



                             int n= int.parse(fareText.text);

                             if(itsCarRide)
                             {
                               if(n<minCarFare)
                               {
                                 fareText.clear();

                                 Fluttertoast.showToast(
                                     msg: "Please specify a reasonable fare!",
                                     fontSize: 14,
                                     backgroundColor: Colors.orange[100],
                                     textColor: darkThemeBlue,
                                     toastLength: Toast.LENGTH_LONG);
                               }

                               else{

                                 setState(() {
                                   show = false;

                                   properFare = true;

                                 });
                               }
                             }
                             else{

                               if(n<minBikeFare)
                               {
                                 fareText.clear();

                                 Fluttertoast.showToast(
                                     msg: "Please specify a reasonable fare!",
                                     fontSize: 14,
                                     backgroundColor: Colors.orange[100],
                                     textColor: darkThemeBlue,
                                     toastLength: Toast.LENGTH_LONG);

                               }

                               else{

                                 setState(() {

                                   show = false;

                                   properFare = true;

                                 });

                               }
                             }


                           });


                         },
                       ),
                     ),
                   ],
                 )
               );
            },






          ),
        ),
        backgroundColor: Colors.white,

        bottomNavigationBar: (pageLoadCheck)?
        Visibility(
          visible: secondPhase == false,
          child: Container(
            padding: EdgeInsets.fromLTRB(15.0, 8.0, 15.0, 8.0),
            decoration: BoxDecoration(border: Border(top: BorderSide(color: Colors.black45, width: 0.5)), color: Colors.white),
            height: 80,
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        height: 20.0,
                        width: screenWidth*0.4,
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.only(top: 0, left: 0, right: 0),
                        margin: EdgeInsets.only(top: 0, right: 0, bottom: 2),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 0),
                            child: DropdownButton(
                              isExpanded: true,
                              iconEnabledColor: Colors.black,
                              focusColor: Colors.black,
                              dropdownColor: Colors.white,
                              value: _selectedPaymentType,
                              items: _dropdownMenuPaymentType,
                              onChanged: (value){
                                _selectedPaymentType = value;
                                setState(() {});
                              },
                              style: GoogleFonts.poppins(fontWeight: FontWeight.w500, fontSize: screenWidth * 0.036, color: Colors.black),
                            ),
                          ),
                        )),
                    Text("Travel Time : ${rideDataStore.travellingTime}",
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(fontSize: 12.5, color: Colors.black, fontWeight: FontWeight.w400)),
                    Text("Distance : ${rideDataStore.distanceText}",
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(fontSize: 12.5, color: Colors.black, fontWeight: FontWeight.w400)),


                  ],
                ),
                Spacer(),
                // FlatButton(
                //   padding: EdgeInsets.fromLTRB(30.0, 8.0, 30.0, 8.0),
                //   shape: RoundedRectangleBorder(
                //       side: BorderSide(color: Colors.deepOrange, width: 1.5, style: BorderStyle.solid),
                //       borderRadius: BorderRadius.circular(5)),
                //   child: Text(
                //     "Book Ride",
                //     style: GoogleFonts.poppins(color: Colors.deepOrangeAccent, fontSize: 16.0, fontWeight: FontWeight.w600),
                //   ),
                // ),
                (ridePriceAvailableCheck)?
                ButtonTheme(//__To Enlarge Button Size__
                  padding: EdgeInsets.fromLTRB(30.0, 8.0, 30.0, 8.0),
                  height: 50.0,
                  minWidth: screenWidth*.35,
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    onPressed: () {
                      rideCreateCheck = true;

                  //    if(ready == true){
                  //   }



                      if(selectcheck == true)
                        {
                          if(properFare == true)
                            {
                                  setState(() {

                                    secondPhase = true;
                                    showoptions = false;

                                  });

                                  print('second phase activated');
                                 // channel.trigger('ride_request', {'offer': 200});

                                  double n = double.parse(fareText.text);

                                  if(itsCarRide == false)
                                  {


                                    Map _bodyRideCreate={
                                      "offer_price": n,
                                      "pickup_address": "${rideDataStore.pickUpLocation.formattedAddress}",
                                      "pickup_latitude": "${rideDataStore.pickLat}",
                                      "pickup_longitude": "${rideDataStore.pickLng}",
                                      "drop_address": "${rideDataStore.dropLocation.formattedAddress}",
                                      "drop_latitude": "${rideDataStore.dropLat}",
                                      "drop_longitude": "${rideDataStore.dropLng}",
                                      "projected_distance": "${rideDataStore.distance}",
                                      "payment_method": "CASH",
                                      "vehicle_type": "2W"
                                    };

                                    print(_bodyRideCreate);

                                    // _bikRideCreateBloc.bikRideCreate(_bodyRideCreate, widget.userToken);

                                    _bikeRideRepository.reqBooking(_bodyRideCreate, widget.userToken);

                                  }

                                  else{




                                    Map _bodyRideCreate={
                                      "offer_price": n,
                                      "pickup_address": "${rideDataStore.pickUpLocation.formattedAddress}",
                                      "pickup_latitude": "${rideDataStore.pickLat}",
                                      "pickup_longitude": "${rideDataStore.pickLng}",
                                      "drop_address": "${rideDataStore.dropLocation.formattedAddress}",
                                      "drop_latitude": "${rideDataStore.dropLat}",
                                      "drop_longitude": "${rideDataStore.dropLng}",
                                      "projected_distance": "${rideDataStore.distance}",
                                      "payment_method": "CASH",
                                      "vehicle_type": "4W"
                                    };

                                    print(_bodyRideCreate);

                                    // _bikRideCreateBloc.bikRideCreate(_bodyRideCreate, widget.userToken);
                                    _bikeRideRepository.reqBooking(_bodyRideCreate, widget.userToken);

                                  }


                            }

                          else{
                            Fluttertoast.showToast(
                                msg: "Please specify a reasonable fare!",
                                fontSize: 14,
                                backgroundColor: Colors.orange[100],
                                textColor: darkThemeBlue,
                                toastLength: Toast.LENGTH_LONG);
                          }



                        }

                      else{
                        Fluttertoast.showToast(
                            msg: "Please select a ride option!",
                            fontSize: 14,
                            backgroundColor: Colors.orange[100],
                            textColor: darkThemeBlue,
                            toastLength: Toast.LENGTH_LONG);
                      }



                    },
                    color: orangeCol,
                    textColor: Colors.white,

                    /*
                    child: StreamBuilder<ApiResponse<BikeRideCreateModel>>(
                      stream: _bikRideCreateBloc.bikeRideCreateStream,
                      builder: (context, snapshot) {
                        if (rideCreateCheck) {
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
                                    rideCreateCheck = false;

                                    DateTime now = DateTime.now();
                                    print(now.hour);
                                    timecheck = now;
                                    timecheck= Jiffy().add(minutes: 5);
                                    Future.delayed(Duration.zero,(){

                                      Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(builder: (BuildContext context) => BikeBookingConfirmPage()),
                                          ModalRoute.withName('/home')
                                      );
                                    });


                                }
                                break;
                              case Status.ERROR:
                                rideCreateCheck = false;
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
                            rideCreateCheck = false;
                            print(snapshot.error);
                          }
                        }
                        return Text("Book Ride",
                            style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w500));
                      },
                    ),



                     */

                   child: Text(
                       "Book Ride",
                       style: GoogleFonts.poppins(color: Colors.white, fontSize: 16.0, fontWeight: FontWeight.w600),
                     ),
                  ),

                ):Padding(
                  padding: EdgeInsets.fromLTRB(30.0, 0.0, 20.0, 15.0),
                  child: JumpingDotsProgressIndicator(
                    numberOfDots: 5,
                    fontSize: 22.0,
                    milliseconds: 250,
                    dotSpacing: 0.2,
                  ),
                ),
              ],
            ),
          ),
        ):SizedBox(
          height: 0,
          width: 0,),
        body: FutureBuilder<BikerAvailableModel>(
            future: _bikeAvailableFuture,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
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

                return Column(
                  children: [
                    Stack(
                      children: [







                        Container(
                            // margin: EdgeInsets.only(top: scr)eenHeight * 0.007, right: screenHeight * 0.007, left: screenHeight * 0.007),
                            height: screenHeight * 0.6,
                            // width: screenWidth * 0.985,
                            child: GoogleMap(
                              myLocationEnabled: false,
                              compassEnabled: false,
                              myLocationButtonEnabled: false,
                              zoomControlsEnabled: false,
                              mapToolbarEnabled: false,
                              trafficEnabled: false,
                              indoorViewEnabled: false,
                              mapType: MapType.normal,
                              initialCameraPosition: initialCameraPosition,
                              markers: Set<Marker>.of(markers.values),
                              polylines: Set<Polyline>.of(polylines.values),
                              onMapCreated: (GoogleMapController controller) {
                                mapController = controller;
                              },
                            )),




                        secondPhase == true && dataready == false? Overlay.show(context) : Container(),

                       showLoading==true? Loading.show(context):Container(),

                        Positioned(
                          top: 17,
                          left: 17,
                          child: InkWell(
                              onTap: () {
                                Navigator.pop(context);
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
                                  radius: 23,
                                  backgroundColor: Colors.white.withOpacity(0.8),
                                ),)
                          ),
                        ),


                      dataready == true && secondPhase == true?
                        Positioned(
                          top: 55,
                         // left: 17,


                          child: SingleChildScrollView(
                            child: SizedBox(
                              height:400,
                              width: MediaQuery.of(context).size.width * 1,
                              child: ListView.builder(

                               //physics: NeverScrollableScrollPhysics(),
                               shrinkWrap: true,
                               itemCount:history.length,
                               itemBuilder: (context,index){

                                 print('Entered item builder');

                                 int n =0;




                                 /*

                                Timer(Duration(seconds: 60), ()
                                    {
                                      if(history.length >= n)
                                        {
                                          setState(() {

                                            history.removeAt(n);
                                            n=n+1;
                                          });


                                        }
                                    }

                                );



                                  */
                                if(history[index]['show']==false)
                                  {

                                    return Container();

                                  }

                                  else{


                                  return Padding(
                                    padding: const EdgeInsets.only(top:2.0,bottom:2, left:8,right:8),
                                    child: Card(
                                      elevation: 20,
                                      color: Colors.white70,
                                      shadowColor: Colors.white.withOpacity(0) ,
                                      child: SingleChildScrollView(
                                        child: Container(


                                          child: Column(

                                            children: [

                                              LinearProgressIndicator(
                                                value: history[index]['progress'],
                                              ),

                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceAround,

                                                children: [

                                                  CircleAvatar(
                                                    radius: 22,
                                                    backgroundImage:NetworkImage('$imageBaseURL${history[index]['picture']}'),
                                                  ),

                                                  Text('${history[index]['name']}',style: TextStyle(fontSize: 15)),

                                                  Column(
                                                    children: [
                                                    //  Text(''),
                                                   //   Text(''),
                                                      Padding(
                                                        padding: const EdgeInsets.only(bottom:1.0),
                                                        child: Text('₹${history[index]['price']}',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500),),
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.only(bottom:2.0),
                                                        child: Text('${history[index]['vehicle_make']}',style: TextStyle(fontSize: 15)),
                                                       ),
                                                      Padding(
                                                        padding: const EdgeInsets.only(bottom:2.0),
                                                        child: Text('${history[index]['distance']}',style: TextStyle(fontSize: 15)),
                                                      ),
                                                    ],
                                                  ),


                                                ],
                                              ),

                                              /*
                                             Padding(
                                               padding: const EdgeInsets.only(right: 27.0),
                                               child: Row(

                                                 mainAxisAlignment: MainAxisAlignment.end,

                                                 children: [
                                                   Text('${history[index]['time_required']}',style: TextStyle(fontSize: 20)),
                                                 ],
                                               ),
                                             ),

                                             Padding(
                                               padding: const EdgeInsets.only(right: 27.0),
                                               child: Row(
                                                 mainAxisAlignment: MainAxisAlignment.end,

                                                 children: [
                                                   Text('${history[index]['distance']}',style: TextStyle(fontSize: 20)),
                                                 ],
                                               ),
                                             ),


                                 */




                                              Row(

                                                mainAxisAlignment: MainAxisAlignment.center,

                                                children: [

                                                  Padding(
                                                    padding: const EdgeInsets.only(left:4.0, right: 4.0, top:2.0, bottom: 4.0),
                                                    child: SizedBox(

                                                      height: 25,
                                                      width: 140,

                                                      child: TextButton(onPressed: ()
                                                      {

                                                        setState(() {
                                                         // history.removeAt(index);
                                                          history[index]['show'] = false;
                                                        });

                                                      },

                                                          child: Text('Decline', style: TextStyle(color: Colors.red)),

                                                          style: TextButton.styleFrom(
                                                            backgroundColor: Colors.white,
                                                            //minimumSize: Size(25, 20),
                                                            padding: EdgeInsets.zero,

                                                          )
                                                      ),
                                                    ),
                                                  ),


                                                      Padding(
                                                    padding: const EdgeInsets.only(left:4.0, right: 4.0, top:2.0, bottom: 4.0),
                                                    child: SizedBox(
                                                      height: 25,
                                                      width: 140,
                                                      child: TextButton(onPressed: ()
                                                      {
                                                        String rider_id = history[index]['rider_id'];
                                                        double n = double.parse(history[index]['price']);

                                                        String tripid = history[index]['trip_id'];

                                                        int trip_id = int.parse(tripid);

                                                        //String ride_Id = trip_id.toString();

                                                        Map _bodyRideCreate={
                                                          "id": trip_id,
                                                          "carrier_id": rider_id,
                                                          "offer_price": n,
                                                        };

                                                        print(_bodyRideCreate);

                                                        // _bikRideCreateBloc.bikRideCreate(_bodyRideCreate, widget.userToken);

                                                        _bikeRideRepository.acceptReq(_bodyRideCreate, widget.userToken);

                                                        setState(() {
                                                          showLoading = true;
                                                        });




                                                        Future.delayed(Duration(seconds: 3), () {

                                                          setState(() {
                                                            showLoading = false;

                                                          });

                                                          print('this is the success:');
                                                          print(ridesuccess);



                                                          if(ridesuccess == true)
                                                          {
                                                            pusher.unsubscribe('ride_booking');



                                                            Navigator.pushAndRemoveUntil(
                                                                context,
                                                                MaterialPageRoute(builder: (BuildContext context) => RideTrackingPage(rideId: trip_id,userToken: widget.userToken)),
                                                                ModalRoute.withName('/home')
                                                            );



                                                          }


                                                          else{

                                                            Fluttertoast.showToast(
                                                                msg: "There was some error, please try again!",
                                                                fontSize: 14,
                                                                backgroundColor: Colors
                                                                    .orange[100],
                                                                textColor: darkThemeBlue,
                                                                toastLength: Toast.LENGTH_LONG);


                                                          }



                                                        });




                                                      },

                                                          child: Text('Accept', style: TextStyle(color: Colors.white,)),

                                                          style: TextButton.styleFrom(
                                                            // primary: Colors.green,
                                                            backgroundColor: Colors.green,
                                                            //minimumSize: Size(55, 20),
                                                            padding: EdgeInsets.zero,
                                                          )
                                                      ),
                                                    ),
                                                  ),



                                                ],
                                              ),





                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );


                                }

                               },
                               /*
                                 extCard(
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
                                  ),),


                                */


                              ),
                            ),
                          ),
                        ):
                        Container(),








                        Visibility(
                          visible:secondPhase,
                          child: Positioned(
                            top: 5,
                            right: 7,
                            child: InkWell(

                                child: Card(
                                  elevation: 10,

                                  color: Colors.white.withOpacity(0),
                                  shadowColor: Colors.white.withOpacity(0) ,

                                child:  TextButton(

                                    onPressed: ()
                                {
                                  setState(() {
                                    secondPhase = false;
                                  });
                                }

                                    , child: Text('Cancel',style: TextStyle(fontSize: 17),)),

                                )
                            ),
                          ),
                        ),


                        Visibility(
                          visible: secondPhase == true && dataready == false,
                          child: Positioned(
                            top: 85,
                            left: 115,
                            child: InkWell(

                              child: Card(
                                elevation: 10,

                              //  shape: RoundedRectangleBorder(
                               //   borderRadius: BorderRadius.circular(50),
                              //  ),

                                color: Colors.white.withOpacity(0),
                              shadowColor: Colors.white.withOpacity(0) ,
                              child: Text('Finding drivers',style: TextStyle(fontSize: 23.5,color: Colors.black),),

                              )
                            ),
                          ),
                        ),

                        Positioned(
                          bottom: 20,
                          right: 18,
                          child: InkWell(
                            onTap: () {
                              mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
                                  target: LatLng((rideDataStore.pickLat + rideDataStore.dropLat) / 2,
                                      (rideDataStore.pickLng + rideDataStore.dropLng) / 2),
                                  zoom: 12)));
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
                      child: SingleChildScrollView(

                        controller: _scrollController,

                        physics: AlwaysScrollableScrollPhysics(),

                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  boxShadow: [BoxShadow(spreadRadius: 5, blurRadius: 15, offset: Offset(0, -2), color: Colors.black38)]),
                              child: Container(
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
                                            child: Text("${rideDataStore.pickUpLocation.formattedAddress}",
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
                                            child: Text("${rideDataStore.dropLocation.formattedAddress}",
                                                overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts.poppins(fontSize: 13, color: Colors.black, fontWeight: FontWeight.w400)),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),

                            secondPhase == false?
                            InkWell(
                              onTap: (){
                                setState(() {
                                  itsCarRide = false;
                                  selectcheck = true;
                                  showoptions = true;

                                  price = itsCarRide?carfare:bikefare;







                                  Future.delayed(Duration(milliseconds: 100), (){

                                    _scrollController.animateTo(
                                        _scrollController.position.maxScrollExtent,
                                        duration: Duration(milliseconds: 200),
                                        curve: Curves.easeInOut
                                    );

                                  });

                                });
                              },
                              child: Container(
                                padding: EdgeInsets.fromLTRB(15.0, 10.0, 18.0, 10.0),
                                color: selectcheck==true?itsCarRide==false?Colors.orange[200]:Colors.orange[50]:Colors.orange[50],
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      child: Image.asset(
                                        "assets/images/icons/bikeRide_icon/bikeRide_icon.png",
                                        height: 23,
                                        width: 23,
                                      ),
                                      radius: 20,
                                      backgroundColor: Colors.orange[100],
                                    ),
                                    Text(
                                      "    Bike Ride ",
                                      style: GoogleFonts.poppins(fontSize: 15, color: Colors.black, fontWeight: FontWeight.w500),
                                    ),
                                    Text(
                                      "12 mins",
                                      style: GoogleFonts.poppins(fontSize: 13, color: Colors.black54, fontWeight: FontWeight.w400),
                                    ),
                                    Spacer(),
                                    FutureBuilder<BikeRideRateModel>(
                                        future: _bikeRideRateFuture,
                                        builder: (context, snapshot1) {
                                          if (snapshot1.hasData) {
                                            if(snapshot1.data.message=="Success"){

                                            //  setState(() {
                                            //
                                           //   });

                                              bikefare = "Rs. ${snapshot1.data.data.payableAmount}";
                                              minBikeFare = snapshot1.data.data.min_negotiable_price;

                                              if(!ridePriceAvailableCheck){
                                                Future.delayed(Duration.zero, () {
                                                  setState(() {
                                                    ridePriceAvailableCheck=true;
                                                  });
                                                });
                                              }


                                              return Text(
                                                "Rs. ${snapshot1.data.data.payableAmount}",
                                                style: GoogleFonts.poppins(fontSize: 14, color: Colors.black, fontWeight: FontWeight.w500),
                                              );
                                            }else
                                              return Text(
                                                "NOT AVAILABLE",
                                                style: GoogleFonts.poppins(fontSize: 14, color: Colors.black, fontWeight: FontWeight.w500),
                                              );
                                          } else if (snapshot1.hasError) {
                                            print(snapshot1.error);
                                            return Text("No Data Found");
                                          } else
                                            return Center(
                                              child: JumpingDotsProgressIndicator(
                                                numberOfDots: 4,
                                                fontSize: 20.0,
                                              )
                                            );
                                        }),

                                  ],
                                ),
                              ),
                            )
                            :
                                Container(

                                  child: Column(
                                    children: [

                                      Padding(
                                        padding: const EdgeInsets.only(top:25.0),
                                        child: Center(child: Text('Current Fare', style: TextStyle(fontSize: 22, ),)),
                                      ),

                                      Padding(
                                        padding: const EdgeInsets.only(top:25.0, bottom:25),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [

                                            InkWell(

                                            onTap: (){

                                              setState(() {
                                                negative = true;
                                                positive = false;
                                              });

                                              int n = int.parse(fareText.text);
                                              n = n-10;


                                        if(itsCarRide) {

                                          if (n < minCarFare) {
                                            //fareText.clear();

                                            Fluttertoast.showToast(
                                                msg: "Please specify a reasonable fare!",
                                                fontSize: 14,
                                                backgroundColor: Colors
                                                    .orange[100],
                                                textColor: darkThemeBlue,
                                                toastLength: Toast.LENGTH_LONG);
                                               }

                                          else{
                                            setState(() {
                                              raisefareVisible = true;
                                              fareText.text = n.toString();
                                            });


                                          }
                                              }

                                        else{


                                          if (n < minBikeFare) {
                                            //fareText.clear();

                                            Fluttertoast.showToast(
                                                msg: "Please specify a reasonable fare!",
                                                fontSize: 14,
                                                backgroundColor: Colors
                                                    .orange[100],
                                                textColor: darkThemeBlue,
                                                toastLength: Toast.LENGTH_LONG);
                                          }

                                          else{

                                            setState(() {
                                              raisefareVisible = true;
                                              fareText.text = n.toString();
                                            });


                                          }

                                        }



                                            },
                                              child: Container(
                                                decoration: BoxDecoration(

                                                   borderRadius : BorderRadius.circular(12),

                                                  shape : BoxShape.rectangle,

                                                  border : Border.all(
                                                    color: negative == true? Colors.red: Colors.white,
                                                  ),

                                              ),

                                                child: Text('   -10   ',  style: TextStyle(color: negative == true? Colors.red: Colors.black, fontSize: 22, fontWeight: FontWeight.w500 ),),
                                              ),
                                            ),

                                            Center(child: Text(fareText.text, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),)),



                                            InkWell(

                                              onTap: (){

                                                setState(() {
                                                  positive = true;
                                                  negative = false;
                                                });

                                                int n = int.parse(fareText.text);
                                                n = n+10;


                                                if(itsCarRide) {

                                                  if (n < minCarFare) {
                                                    //fareText.clear();

                                                    Fluttertoast.showToast(
                                                        msg: "Please specify a reasonable fare!",
                                                        fontSize: 14,
                                                        backgroundColor: Colors
                                                            .orange[100],
                                                        textColor: darkThemeBlue,
                                                        toastLength: Toast.LENGTH_LONG);


                                                  }

                                                  else{
                                                    setState(() {
                                                      raisefareVisible = true;
                                                      fareText.text = n.toString();
                                                    });


                                                  }
                                                }

                                                else{


                                                  if (n < minBikeFare) {
                                                    //fareText.clear();

                                                    Fluttertoast.showToast(
                                                        msg: "Please specify a reasonable fare!",
                                                        fontSize: 14,
                                                        backgroundColor: Colors
                                                            .orange[100],
                                                        textColor: darkThemeBlue,
                                                        toastLength: Toast.LENGTH_LONG);
                                                  }

                                                  else{

                                                    setState(() {
                                                      raisefareVisible = true;
                                                      fareText.text = n.toString();
                                                    });


                                                  }

                                                }



                                              },
                                              child: Container(


                                                decoration: BoxDecoration(

                                                  borderRadius : BorderRadius.circular(12),

                                                  shape : BoxShape.rectangle,

                                                  border : Border.all(
                                                    color: positive == true? Colors.green: Colors.white,
                                                  ),

                                                ),

                                                child: Text('   +10   ',style: TextStyle(color: positive == true? Colors.green: Colors.black, fontSize: 22, fontWeight: FontWeight.w500 ),  ),
                                              ),
                                            ),



                                          ],

                                        ),
                                      ),

                                       InkWell(
                                         onTap: (){

                                            setState(() {
                                              raisefareVisible = false;
                                              showLoading = true;
                                            });



                                           double n = double.parse(fareText.text);

                                           int u = rideId;

                                           //String tripid = history[0]['trip_id'];

                                          // int trip_id = int.parse(tripid);



                             if(itsCarRide == false)
                           {
                               Map _bodyRideCreate={
                              "trip_id": u,
                              "customer_id": "${widget.userId}",
                              "offer_price": n,
                              "pickup_address": "${rideDataStore.pickUpLocation.formattedAddress}",
                              "pickup_latitude": "${rideDataStore.pickLat}",
                              "pickup_longitude": "${rideDataStore.pickLng}",
                              "drop_address": "${rideDataStore.dropLocation.formattedAddress}",
                              "drop_latitude": "${rideDataStore.dropLat}",
                              "drop_longitude": "${rideDataStore.dropLng}",
                              "projected_distance": "${rideDataStore.distance}",
                              "payment_method": "CASH",
                              "vehicle_type": "2W"
                            };

                               print(_bodyRideCreate);

                               _bikeRideRepository.offerMore(_bodyRideCreate, widget.userToken);

                          }

                                else{


                               Map _bodyRideCreate={
                                 "trip_id": u,
                                 "customer_id": "${widget.userId}",
                                 "offer_price": n,
                                 "pickup_address": "${rideDataStore.pickUpLocation.formattedAddress}",
                                 "pickup_latitude": "${rideDataStore.pickLat}",
                                 "pickup_longitude": "${rideDataStore.pickLng}",
                                 "drop_address": "${rideDataStore.dropLocation.formattedAddress}",
                                 "drop_latitude": "${rideDataStore.dropLat}",
                                 "drop_longitude": "${rideDataStore.dropLng}",
                                 "projected_distance": "${rideDataStore.distance}",
                                 "payment_method": "CASH",
                                 "vehicle_type": "4W"
                               };

                               print(_bodyRideCreate);

                               _bikeRideRepository.offerMore(_bodyRideCreate, widget.userToken);




                                }

                                            Future.delayed(Duration(milliseconds: 800), (){

                                              setState(() {
                                                showLoading = false;
                                              });



                                            });


                                            Fluttertoast.showToast(
                                               msg: "Offer Raised!",
                                               fontSize: 14,
                                               backgroundColor: Colors
                                                   .orange[100],
                                               textColor: darkThemeBlue,
                                               toastLength: Toast.LENGTH_LONG);





                                         },

                                         child: Visibility(
                                           visible: raisefareVisible,

                                           child: Container(

                                             height: MediaQuery.of(context).size.height*0.05,
                                             width : MediaQuery.of(context).size.width*0.5,

                                            decoration: BoxDecoration(

                                              color : Colors.blue,

                                              borderRadius : BorderRadius.circular(12),

                                              shape : BoxShape.rectangle,

                                              border : Border.all(
                                                color: positive == true? Colors.green: Colors.white,
                                              ),

                                            ),

                                            child: Center(child: Text('   Raise fare   ', style: TextStyle(color: Colors.white,fontSize: 22), )),
                                      ),
                                         ),
                                       ),

                                    ],
                                  ),

                                ),

                            secondPhase == false?
                            InkWell(
                              onTap: (){



                                setState(() {
                                  itsCarRide = true;
                                  selectcheck = true;

                                    showoptions = true;


                                  price = itsCarRide?carfare:bikefare;






                                  Future.delayed(Duration(milliseconds: 100), (){

                                    _scrollController.animateTo(
                                        _scrollController.position.maxScrollExtent,
                                        duration: Duration(milliseconds: 200),
                                        curve: Curves.easeInOut
                                    );

                                  });


                                });


                              },
                              child: Container(
                                padding: EdgeInsets.fromLTRB(15.0, 10.0, 18.0, 10.0),
                               color: itsCarRide==true?Colors.orange[200]:Colors.orange[50],
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      child: Image.asset(
                                        "assets/images/icons/bikeRide_icon/car_draw_png-2.png",
                                        height: 23,
                                        width: 23,
                                      ),
                                      radius: 20,
                                      backgroundColor: Colors.orange[100],
                                    ),
                                    Text(
                                      "    Car Ride ",
                                      style: GoogleFonts.poppins(fontSize: 15, color: Colors.black, fontWeight: FontWeight.w500),
                                    ),
                                    Text(
                                      "12 mins",
                                      style: GoogleFonts.poppins(fontSize: 13, color: Colors.black54, fontWeight: FontWeight.w400),
                                    ),
                                    Spacer(),
                                    FutureBuilder<BikeRideRateModel>(
                                        future: carRideRateFuture,
                                        builder: (context, snapshot1) {
                                          if (snapshot1.hasData) {
                                            if(snapshot1.data.message=="Success"){


                                                carfare  =  "Rs. ${snapshot1.data.data.payableAmount}";
                                                minCarFare = snapshot1.data.data.min_negotiable_price;



                                              if(!ridePriceAvailableCheck){
                                                Future.delayed(Duration.zero, () {
                                                  setState(() {
                                                    ridePriceAvailableCheck=true;
                                                  });
                                                });
                                              }



                                              return Text(
                                                "Rs. ${snapshot1.data.data.payableAmount}",
                                                style: GoogleFonts.poppins(fontSize: 14, color: Colors.black, fontWeight: FontWeight.w500),
                                              );


                                            }

                                            else
                                              return Text(
                                                "NOT AVAILABLE",
                                                style: GoogleFonts.poppins(fontSize: 14, color: Colors.black, fontWeight: FontWeight.w500),
                                              );
                                          } else if (snapshot1.hasError) {
                                            print('printing error:');
                                            print(snapshot1.error);
                                            return Text("Not Available");
                                          } else
                                            return Center(
                                                child: JumpingDotsProgressIndicator(
                                                  numberOfDots: 4,
                                                  fontSize: 20.0,
                                                )
                                            );
                                        }),

                                  ],
                                ),
                              ),
                            )
                            :
                                Container(

                                ),

                            Visibility(
                              visible: showoptions,
                              child: Padding(
                                padding: const EdgeInsets.only(top:16.0, left: 20),
                                child: Text('Recommended Price : ${price}'),
                              ),
                            ),

                            Visibility(
                              visible: showoptions,
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),


                                  child: SizedBox(
                                    height: 30,
                                    child: TextField(
                                      readOnly: true,
                                      onTap: (){

                                        myFocusNode.requestFocus();

                                        setState(() {
                                          show = true;
                                        });

                                      },
                                      controller: fareText,
                                      decoration: InputDecoration(
                                        hintText: 'Offer your fare',
                                       // contentPadding: EdgeInsets.all( 0),



                                        /*
                                        prefixIcon: SizedBox(
                                          height: 4,
                                          child: ImageIcon(

                                            AssetImage("assets/images/icons/bikeRide_icon/rs_icon.png"),

                                            size: 4,

                                          ),
                                        ),


                                         */


                                        prefixIcon: Image.asset('assets/images/icons/bikeRide_icon/rs_icon.png'
                                        ,height: 2,
                                        ),



                                    ),
                                ),
                                  ),
                              ),
                            ),


                          ],
                        ),
                      ),
                    )
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

  Future<void> initpusher() async {





    try {

      pusher = await new PusherClient(

       "502c53814ad841c820cf",
       //"8dc166fcff3cbe203ec4",
      // "3d94f86a81ecd54b955d",
        PusherOptions(
          cluster : 'ap2',
          //host: 'localhost',
          // encrypted: false,
          // auth: PusherAuth(
          //  'http://example.com/broadcasting/auth',
          // headers: {
          //'Authorization': 'Bearer $token',
          //},
          // ),

        ),



      );







    }
    catch(e)
    {
      print(e);
    }


    pusher.connect();

    pusher.onConnectionStateChange((state) {
      print("previousState: ${state.previousState}, currentState: ${state.currentState}");
    });

    pusher.onConnectionError((error) {
      print("error: ${error.message}");
    });

    channel = pusher.subscribe("ride_booking");
    channel.bind("ride_request_assigned_${widget.userId}",(PusherEvent event) {
      print(event.data);
      final data = json.decode(event.data);
      int rideId = data['data']['id'];
      print("rideId>>>$rideId");
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (BuildContext context) => RideTrackingPage(rideId: rideId,userToken: widget.userToken)),
          ModalRoute.withName('/home')
      );

    });

    channel.bind("ride_request_accept_${widget.userId}", (PusherEvent event) {



      print('printing event data');
      print(event.data);
      if(mounted)
        {
          final data = json.decode(event.data);
          print('this is the data');
          print(data['data']['price']);

          int nx = int.parse(data['data']['trip_id']);

          prefs.setInt('rideid', rideId);

          if(history.isNotEmpty)
            {
              setState(() {
                sameId = false;
              });

              for(int i =0;i<=history.length - 1; i++)
              {
                  if(data['data']['rider_id'] == history[i]['rider_id'])
                    {

                      setState(() {
                        history[i]['show'] = false;
                      });


                      /*
                      if(data['data']['price'] == history[i]['price'])
                        {

                          setState(() {
                            sameId = true;
                          });

                        }

                      else{

                      }


                       */








                    }

              }

            }



          if(nx ==  rideId && sameId == false)
            {

              history.add(
                  {
                    'price': data['data']['price'],
                    'name': data['data']['name'],
                    'picture': data['data']['picture'],
                    'distance': data['data']['distance'],
                    'time_required': data['data']['time_required'],
                    'progress': 1.0,
                    'trip_id' :  data['data']['trip_id'],
                    'rider_id' :  data['data']['rider_id'],
                    'vehicle_make': data['data']['vehicle_make'],
                    'show': true,
                  }
              );



              setState(() {
                history;
              });

              setState(() {
                dataready = true;
                n = history.length-1;
              });
              
              
            }
         




/*
          Timer.periodic(
            Duration(seconds: 1),
                (Timer timer) => setState(
                  () {
                if (history[n]['progress'] == 0) {
                  timer.cancel();
                } else {
                  history[n]['progress'] -= 0.016;
                }
              },
            ),
          );


          //(i=0,i<=n) if(n==0) if(n==1)



 */





          //for(int i=n;i<=n;i++)
          //  {




              if(n==0)
                {
                  print('Entered zero');
                  Timer.periodic(
                    Duration(seconds: 1),
                        (Timer timer) => setState(
                          () {
                        if (history[0]['progress'] <= 0) {

                          setState(() {
                            //history.removeAt(0);
                            history[0]['show'] = false;
                          });
                          timer.cancel();
                        } else {
                          setState(() {
                            history[0]['progress'] -= 0.016;
                          });

                        }
                      },
                    ),
                  );
                }





              if(n==1)
              {
                print('Entered one');
                Timer.periodic(
                  Duration(seconds: 1),
                      (Timer timer1) => setState(
                        () {
                      if (history[1]['progress'] <= 0) {

                        setState(() {
                         // history.removeAt(1);
                          history[1]['show'] = false;
                        });
                        timer1.cancel();

                      } else
                        {

                        setState(() {
                          history[1]['progress'] -= 0.016;
                        });

                      }
                    },
                  ),
                );
              }

          if(n==2)
          {
            print('Entered 2');
            Timer.periodic(
              Duration(seconds: 1),
                  (Timer timer1) => setState(
                    () {
                  if (history[2]['progress'] <= 0) {

                    setState(() {
                    //  history.removeAt(2);
                      history[2]['show'] = false;
                    });
                    timer1.cancel();

                  } else
                  {

                    setState(() {
                      history[2]['progress'] -= 0.016;
                    });

                  }
                },
              ),
            );
          }


          if(n==3)
          {
            print('Entered 3');
            Timer.periodic(
              Duration(seconds: 1),
                  (Timer timer1) => setState(
                    () {
                  if (history[3]['progress'] <= 0) {

                    setState(() {
                      //  history.removeAt(2);
                      history[3]['show'] = false;
                    });
                    timer1.cancel();

                  } else
                  {

                    setState(() {
                      history[3]['progress'] -= 0.016;
                    });

                  }
                },
              ),
            );
          }

          if(n==4)
          {
            print('Entered 4');
            Timer.periodic(
              Duration(seconds: 1),
                  (Timer timer1) => setState(
                    () {
                  if (history[4]['progress'] <= 0) {

                    setState(() {
                      //  history.removeAt(2);
                      history[4]['show'] = false;
                    });
                    timer1.cancel();

                  } else
                  {

                    setState(() {
                      history[4]['progress'] -= 0.016;
                    });

                  }
                },
              ),
            );
          }

          if(n==5)
          {
            print('Entered 5');
            Timer.periodic(
              Duration(seconds: 1),
                  (Timer timer1) => setState(
                    () {
                  if (history[5]['progress'] <= 0) {

                    setState(() {
                      //  history.removeAt(2);
                      history[5]['show'] = false;
                    });
                    timer1.cancel();

                  } else
                  {

                    setState(() {
                      history[5]['progress'] -= 0.016;
                    });

                  }
                },
              ),
            );
          }


          if(n==6)
          {
            print('Entered 6');
            Timer.periodic(
              Duration(seconds: 1),
                  (Timer timer1) => setState(
                    () {
                  if (history[6]['progress'] <= 0) {

                    setState(() {
                      //  history.removeAt(2);
                      history[6]['show'] = false;
                    });
                    timer1.cancel();

                  } else
                  {

                    setState(() {
                      history[6]['progress'] -= 0.016;
                    });

                  }
                },
              ),
            );
          }

          if(n==7)
          {
            print('Entered 7');
            Timer.periodic(
              Duration(seconds: 1),
                  (Timer timer1) => setState(
                    () {
                  if (history[7]['progress'] <= 0) {

                    setState(() {
                      //  history.removeAt(2);
                      history[7]['show'] = false;
                    });
                    timer1.cancel();

                  } else
                  {

                    setState(() {
                      history[7]['progress'] -= 0.016;
                    });

                  }
                },
              ),
            );
          }

          if(n==8)
          {
            print('Entered 8');
            Timer.periodic(
              Duration(seconds: 1),
                  (Timer timer1) => setState(
                    () {
                  if (history[8]['progress'] <= 0) {

                    setState(() {
                      //  history.removeAt(2);
                      history[8]['show'] = false;
                    });
                    timer1.cancel();

                  } else
                  {

                    setState(() {
                      history[8]['progress'] -= 0.016;
                    });

                  }
                },
              ),
            );
          }

          if(n==9)
          {
            print('Entered 9');
            Timer.periodic(
              Duration(seconds: 1),
                  (Timer timer1) => setState(
                    () {
                  if (history[9]['progress'] <= 0) {

                    setState(() {
                      //  history.removeAt(2);
                      history[9]['show'] = false;
                    });
                    timer1.cancel();

                  } else
                  {

                    setState(() {
                      history[9]['progress'] -= 0.016;
                    });

                  }
                },
              ),
            );
          }

          if(n==10)
          {
            print('Entered 10');
            Timer.periodic(
              Duration(seconds: 1),
                  (Timer timer1) => setState(
                    () {
                  if (history[10]['progress'] <= 0) {

                    setState(() {
                      //  history.removeAt(2);
                      history[10]['show'] = false;
                    });
                    timer1.cancel();

                  } else
                  {

                    setState(() {
                      history[10]['progress'] -= 0.016;
                    });

                  }
                },
              ),
            );
          }


          if(n==11)
          {
            print('Entered 11');
            Timer.periodic(
              Duration(seconds: 1),
                  (Timer timer1) => setState(
                    () {
                  if (history[11]['progress'] <= 0) {

                    setState(() {
                      //  history.removeAt(2);
                      history[11]['show'] = false;
                    });
                    timer1.cancel();

                  } else
                  {

                    setState(() {
                      history[11]['progress'] -= 0.016;
                    });

                  }
                },
              ),
            );
          }



          if(n==12)
          {
            print('Entered 12');
            Timer.periodic(
              Duration(seconds: 1),
                  (Timer timer1) => setState(
                    () {
                  if (history[12]['progress'] <= 0) {

                    setState(() {
                      //  history.removeAt(2);
                      history[12]['show'] = false;
                    });
                    timer1.cancel();

                  } else
                  {

                    setState(() {
                      history[12]['progress'] -= 0.016;
                    });

                  }
                },
              ),
            );
          }



          if(n==13)
          {
            print('Entered 13');
            Timer.periodic(
              Duration(seconds: 1),
                  (Timer timer1) => setState(
                    () {
                  if (history[13]['progress'] <= 0) {

                    setState(() {
                      //  history.removeAt(2);
                      history[13]['show'] = false;
                    });
                    timer1.cancel();

                  } else
                  {

                    setState(() {
                      history[13]['progress'] -= 0.016;
                    });

                  }
                },
              ),
            );
          }




          if(n==14)
          {
            print('Entered 14');
            Timer.periodic(
              Duration(seconds: 1),
                  (Timer timer1) => setState(
                    () {
                  if (history[14]['progress'] <= 0) {

                    setState(() {
                      //  history.removeAt(2);
                      history[14]['show'] = false;
                    });
                    timer1.cancel();

                  } else
                  {

                    setState(() {
                      history[14]['progress'] -= 0.016;
                    });

                  }
                },
              ),
            );
          }


          if(n==15)
          {
            print('Entered 15');
            Timer.periodic(
              Duration(seconds: 1),
                  (Timer timer1) => setState(
                    () {
                  if (history[15]['progress'] <= 0) {

                    setState(() {
                      //  history.removeAt(2);
                      history[15]['show'] = false;
                    });
                    timer1.cancel();

                  } else
                  {

                    setState(() {
                      history[15]['progress'] -= 0.016;
                    });

                  }
                },
              ),
            );
          }


          if(n==16)
          {
            print('Entered 16');
            Timer.periodic(
              Duration(seconds: 1),
                  (Timer timer1) => setState(
                    () {
                  if (history[16]['progress'] <= 0) {

                    setState(() {
                      //  history.removeAt(2);
                      history[16]['show'] = false;
                    });
                    timer1.cancel();

                  } else
                  {

                    setState(() {
                      history[16]['progress'] -= 0.016;
                    });

                  }
                },
              ),
            );
          }


          if(n==17)
          {
            print('Entered 17');
            Timer.periodic(
              Duration(seconds: 1),
                  (Timer timer1) => setState(
                    () {
                  if (history[17]['progress'] <= 0) {

                    setState(() {
                      //  history.removeAt(2);
                      history[17]['show'] = false;
                    });
                    timer1.cancel();

                  } else
                  {

                    setState(() {
                      history[17]['progress'] -= 0.016;
                    });

                  }
                },
              ),
            );
          }


          if(n==18)
          {
            print('Entered 18');
            Timer.periodic(
              Duration(seconds: 1),
                  (Timer timer1) => setState(
                    () {
                  if (history[18]['progress'] <= 0) {

                    setState(() {
                      //  history.removeAt(2);
                      history[18]['show'] = false;
                    });
                    timer1.cancel();

                  } else
                  {

                    setState(() {
                      history[18]['progress'] -= 0.016;
                    });

                  }
                },
              ),
            );
          }



          if(n==19)
          {
            print('Entered 19');
            Timer.periodic(
              Duration(seconds: 1),
                  (Timer timer1) => setState(
                    () {
                  if (history[19]['progress'] <= 0) {

                    setState(() {
                      //  history.removeAt(2);
                      history[19]['show'] = false;
                    });
                    timer1.cancel();

                  } else
                  {

                    setState(() {
                      history[19]['progress'] -= 0.016;
                    });

                  }
                },
              ),
            );
          }


          if(n==20)
          {
            print('Entered 20');
            Timer.periodic(
              Duration(seconds: 1),
                  (Timer timer1) => setState(
                    () {
                  if (history[20]['progress'] <= 0) {

                    setState(() {
                      //  history.removeAt(2);
                      history[20]['show'] = false;
                    });
                    timer1.cancel();

                  } else
                  {

                    setState(() {
                      history[20]['progress'] -= 0.016;
                    });

                  }
                },
              ),
            );
          }


          if(n==21)
          {
            print('Entered 21');
            Timer.periodic(
              Duration(seconds: 1),
                  (Timer timer1) => setState(
                    () {
                  if (history[21]['progress'] <= 0) {

                    setState(() {
                      //  history.removeAt(2);
                      history[21]['show'] = false;
                    });
                    timer1.cancel();

                  } else
                  {

                    setState(() {
                      history[21]['progress'] -= 0.016;
                    });

                  }
                },
              ),
            );
          }



          if(n==22)
          {
            print('Entered 22');
            Timer.periodic(
              Duration(seconds: 1),
                  (Timer timer1) => setState(
                    () {
                  if (history[22]['progress'] <= 0) {

                    setState(() {
                      //  history.removeAt(2);
                      history[22]['show'] = false;
                    });
                    timer1.cancel();

                  } else
                  {

                    setState(() {
                      history[22]['progress'] -= 0.016;
                    });

                  }
                },
              ),
            );
          }





          if(n==23)
          {
            print('Entered 23');
            Timer.periodic(
              Duration(seconds: 1),
                  (Timer timer1) => setState(
                    () {
                  if (history[23]['progress'] <= 0) {

                    setState(() {
                      //  history.removeAt(2);
                      history[23]['show'] = false;
                    });
                    timer1.cancel();

                  } else
                  {

                    setState(() {
                      history[23]['progress'] -= 0.016;
                    });

                  }
                },
              ),
            );
          }


          if(n==24)
          {
            print('Entered 24');
            Timer.periodic(
              Duration(seconds: 1),
                  (Timer timer1) => setState(
                    () {
                  if (history[24]['progress'] <= 0) {

                    setState(() {
                      //  history.removeAt(2);
                      history[24]['show'] = false;
                    });
                    timer1.cancel();

                  } else
                  {

                    setState(() {
                      history[24]['progress'] -= 0.016;
                    });

                  }
                },
              ),
            );
          }


          if(n==25)
          {
            print('Entered 25');
            Timer.periodic(
              Duration(seconds: 1),
                  (Timer timer1) => setState(
                    () {
                  if (history[25]['progress'] <= 0) {

                    setState(() {
                      //  history.removeAt(2);
                      history[25]['show'] = false;
                    });
                    timer1.cancel();

                  } else
                  {

                    setState(() {
                      history[25]['progress'] -= 0.016;
                    });

                  }
                },
              ),
            );
          }












          //  }




          print(history);
        }
    });

   // channel.trigger('ride_request', {'offer': 200});



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

    /// origin marker
    _addMarker(LatLng(rideDataStore.pickLat, rideDataStore.pickLng), "origin", BitmapDescriptor.fromBytes(pickupIcon));

    /// destination marker
    _addMarker(LatLng(rideDataStore.dropLat, rideDataStore.dropLng), "destination", BitmapDescriptor.fromBytes(dropIcon));
  }

  _addMarker(LatLng position, String id, BitmapDescriptor descriptor) {
    MarkerId markerId = MarkerId(id);
    Marker marker = Marker(markerId: markerId, icon: descriptor, position: position);
    markers[markerId] = marker;
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
    Polyline polyline = Polyline(polylineId: id, color: Color.fromRGBO(52,52,52,1), points: polylineCoordinates, width: 3);
    polylines[id] = polyline;
    setState(() {});
  }

  _getPolyline() async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        mapAPIKey, PointLatLng(rideDataStore.pickLat, rideDataStore.pickLng), PointLatLng(rideDataStore.dropLat, rideDataStore.dropLng),
        travelMode: TravelMode.driving, wayPoints: [PolylineWayPoint(location: "")]);
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
    _addPolyLine();
  }

  void Accept(String tripid,String offerprice, String riderid) {

    int trip_id = int.parse(tripid);

    //String ride_Id = trip_id.toString();
    String rider_id = riderid;

    double n = double.parse(offerprice);

    Map _bodyRideCreate={
      "id": trip_id,
      "carrier_id": rider_id,
      "offer_price": n,
    };

    print(_bodyRideCreate);

    // _bikRideCreateBloc.bikRideCreate(_bodyRideCreate, widget.userToken);

    _bikeRideRepository.acceptReq(_bodyRideCreate, widget.userToken);

    setState(() {
      showLoading = true;
    });




    Future.delayed(Duration(seconds: 3), () {

      setState(() {
        showLoading = false;

      });

      print('this is the success:');
      print(ridesuccess);



      if(ridesuccess == true)
      {
        pusher.unsubscribe('ride_booking');



        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (BuildContext context) => RideTrackingPage(rideId: trip_id,userToken: widget.userToken)),
            ModalRoute.withName('/home')
        );



      }


      else{

        Fluttertoast.showToast(
            msg: "There was some error, please try again!",
            fontSize: 14,
            backgroundColor: Colors
                .orange[100],
            textColor: darkThemeBlue,
            toastLength: Toast.LENGTH_LONG);


      }



    });







  }
}
