import 'package:delivery_on_time/constants.dart';
import 'package:delivery_on_time/rideService/RideBookingDetails.dart';
import 'package:delivery_on_time/rideService/model/rideBookingListModel.dart';
import 'package:delivery_on_time/rideService/repository/bikeRideRepository.dart';
import 'package:delivery_on_time/rideService/rideDataClass.dart';
import 'package:delivery_on_time/rideService/rideTrackingPage.dart';
import 'package:delivery_on_time/screens/home_controller.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_shimmer/flutter_shimmer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
//import 'package:google_maps_place_picker/google_maps_place_picker.dart:google_maps_place_picker/src/models/pick_result.dart';
import 'package:jiffy/jiffy.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import '../constants.dart';


class RideBookingList extends StatefulWidget {
  @override
  _RideBookingListState createState() => _RideBookingListState();
}

class _RideBookingListState extends State<RideBookingList> {
  SharedPreferences prefs;
  String userToken = "";
  String userId = "";
  String userName = "";
  String userEmail = "";
  String userPhone = "";
  Map data;
  RideDataStore rideDataStore = new RideDataStore();
  PickResult pickresult = new PickResult();
  PickResult pickresultPick = new PickResult();




  Future<RideBookingListModel> _rideBookingListFuture;
  BikeRideRepository _bikeRideRepository;

  DateTime now = DateTime.now();
  bool checking = false;

  void check()
  {

    if(timecheck!=null)
      {
        checking = timecheck.isBefore(now);
        print(timecheck);
        print(checking);

      }



  }

  Future<void> createSharedPref() async {
    prefs = await SharedPreferences.getInstance();
    userToken = prefs.getString("user_token");
    userId = prefs.getString("user_id");
    userPhone = prefs.getString("user_phone");
    userName = prefs.getString("name");
    userEmail = prefs.getString("email");
    _rideBookingListFuture=_bikeRideRepository.rideBookingList(userToken);


    setState(() {});
  }


  @override
  void initState() {
    super.initState();
    _bikeRideRepository= BikeRideRepository();
    createSharedPref();
    check();

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
        body: FutureBuilder<RideBookingListModel>(
          future: _rideBookingListFuture,
          builder: (context, snapshot) {
            if (snapshot.hasData){
              if(snapshot.data.data.length>0){
                return ListView.builder(
                  itemCount: snapshot.data.data.length,
                  padding: EdgeInsets.fromLTRB(0,0,0,0),
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.fromLTRB(10.0, 6.0, 10.0, 6.0),
                      padding: EdgeInsets.fromLTRB(13.0, 10.0, 13.0, 10.0),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                child: Image.asset(
                                  "assets/images/icons/bikeRide_icon/bikeRide_icon.png",
                                  height: 23,
                                  width: 23,
                                ),
                                radius: 20,
                                backgroundColor: Colors.orange[50],
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        "${DateFormat.yMMMMEEEEd().format(DateFormat("yyyy-MM-dd").parse(snapshot.data.data[index].createdAt, true))}",
                                        style: GoogleFonts.poppins(fontSize: 14, color: Colors.black, fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    "Booking No. : #0${snapshot.data.data[index].id}",
                                    style: GoogleFonts.poppins(fontSize: 12, color: Colors.black54, fontWeight: FontWeight.w400),
                                  ),

                                ],
                              ),
                              Spacer(),
                              Text(
                                "${snapshot.data.data[index].status}",
                                style: GoogleFonts.poppins(fontSize: 13, color: Colors.black, fontWeight: FontWeight.w400),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(50.0, 1.0, 3.0, 3.0),
                            child: ExpandablePanel(
                              theme: ExpandableThemeData(
                                // alignment: Alignment.centerLeft,
                                iconColor: orangeCol,
                                iconPlacement: ExpandablePanelIconPlacement.right,
                                headerAlignment: ExpandablePanelHeaderAlignment.center,
                              ),
                              header: Text(
                                "₹ ${snapshot.data.data[index].payableAmount} ",
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.poppins(color: orangeCol, fontWeight: FontWeight.w500, fontSize: 17),
                              ),
                              // collapsed: Text("hellooo2", softWrap: true, maxLines: 2, overflow: TextOverflow.ellipsis,),
                              expanded: Padding(
                                padding: const EdgeInsets.only(left: 10, bottom: 6,right: 5),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          "Ride Fare ",
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.poppins(color: Colors.black45, fontWeight: FontWeight.w400, fontSize: 12),
                                        ),
                                        Spacer(),
                                        Text(
                                          "Rs. ${snapshot.data.data[index].tripCharge} ",
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.poppins(color: Colors.black45, fontWeight: FontWeight.w400, fontSize: 12),
                                        )
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "Tax & GST ",
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.poppins(color: Colors.black45, fontWeight: FontWeight.w400, fontSize: 12),
                                        ),
                                        Spacer(),
                                        Text(
                                          "+  Rs. ${snapshot.data.data[index].tax} ",
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.poppins(color: Colors.black45, fontWeight: FontWeight.w400, fontSize: 12),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0.0, 4.0, 3.0, 3.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Divider(
                                  height: 0.5,
                                  color: Colors.black26,
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                SizedBox(
                                  height: 70,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Column(
                                          children: [
                                            Expanded(
                                              flex: 1,
                                              child: Image.asset("assets/images/icons/bikeRide_icon/pin_green_round.png",height: 15,width: 15,fit: BoxFit.contain,),
                                            ),
                                            Expanded(
                                                flex: 1,
                                                child: VerticalDivider(
                                                  color: Colors.black,
                                                  thickness: 0.8,
                                                  indent: 4,
                                                  endIndent: 4,
                                                )),
                                            Expanded(
                                              flex: 1,
                                              child: Image.asset("assets/images/icons/bikeRide_icon/pin_red_round.png",height: 15,width: 15,fit: BoxFit.contain,),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        flex: 7,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Expanded(
                                              flex: 1,
                                              child: Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text("${snapshot.data.data[index].pickupAddress}",
                                                    overflow: TextOverflow.ellipsis,
                                                    style: GoogleFonts.poppins(fontSize: 13, color: Colors.black, fontWeight: FontWeight.w400)),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: Divider(
                                                color: Colors.black45,
                                              ),
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text("${snapshot.data.data[index].dropAddress}",
                                                    overflow: TextOverflow.ellipsis,
                                                    style: GoogleFonts.poppins(fontSize: 13, color: Colors.black, fontWeight: FontWeight.w400)),
                                              ),
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
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                            child: Row(
                              children: [
                                ButtonTheme(
                                  /*__To Enlarge Button Size__*/
                                  height: 40.0,
                                  minWidth: screenWidth * 0.4,
                                  child: RaisedButton(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    onPressed: () {
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (BuildContext context) {
                                            return RideBookingDetails(userToken: userToken,rideId: snapshot.data.data[index].id,);
                                          }));
                                    },
                                    color: orangeCol,
                                    textColor: Colors.white,
                                    child: Text("Ride Details", style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500)),
                                  ),
                                ),
                                Spacer(),
                                Visibility(
                                 // visible: snapshot.data.data[index].status=="ASSIGNED" || snapshot.data.data[index].status=="IN_TRANSIT" || snapshot.data.data[index].status == "ACCEPTED",
                                  visible: true,
                                  child: Container(
                                    height: 40.0,
                                    width: screenWidth * 0.4,
                                    // margin: const EdgeInsets.fromLTRB(0, 5, 0, 15),
                                    clipBehavior: Clip.hardEdge,
                                    decoration: BoxDecoration(
                                        border: Border.all(color: orangeCol, width: 1), borderRadius: BorderRadius.circular(12.0)),
                                    child: RaisedButton(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10.0),
                                      ),
                                      onPressed: () {



                                        if(snapshot.data.data[index].status=="IN_TRANSIT"|| snapshot.data.data[index].status == "ACCEPTED") {
                                          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) { return RideTrackingPage(rideId: snapshot.data.data[index].id,userToken: userToken,); }));
                                        }

                                        else{

                                              print('Printing test data:');
                                              double picklat = double.parse(snapshot.data.data[index].pickupLatitude);
                                              print(picklat);

                                              rideDataStore.pickLat = picklat;
                                              userLat = double.parse(snapshot.data.data[index].pickupLatitude);
                                              userLong = double.parse(snapshot.data.data[index].pickupLongitude);
                                              rideDataStore.pickLng = double.parse(snapshot.data.data[index].pickupLongitude);
                                              rideDataStore.dropLat = double.parse(snapshot.data.data[index].dropLatitude);
                                              rideDataStore.dropLng = double.parse(snapshot.data.data[index].dropLongitude);

                                             // rideDataStore.pickUpLocation = PickResult.fromGeocodingResult(snapshot.data.data[index].pickupAddress)   ;
                                              //rideDataStore.dropLocation.formattedAddress = snapshot.data.data[index].dropAddress;
                                         // rideDataStore.dropLocation.formattedAddress = snapshot.data.data[index].dropAddress;
                                          pickresult.formattedAddress = snapshot.data.data[index].dropAddress;
                                          rideDataStore.dropLocation = pickresult;

                                          pickresultPick.formattedAddress = snapshot.data.data[index].pickupAddress;
                                          rideDataStore.pickUpLocation = pickresultPick;




                                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) {
                                                return HomeController(currentIndex: 0,rideDataStore: rideDataStore);
                                              }));

                                        }


                                        /*
                                           if(checking == true)
                                           {
                                             print('ENTERED REASSIGN');
                                             timecheck= DateTime.now();
                                             timecheck= Jiffy().add(minutes: 5);
                                             setState(() {
                                               checking = false;
                                             });

                                             data = {
                                               'id' : snapshot.data.data[index].id,
                                             };

                                             _bikeRideRepository.tripReassign(data, userToken);

                                           }



                                         */







                                      },
                                      color: Colors.white,
                                      textColor: orangeCol,
                                      child: Text( snapshot.data.data[index].status=="IN_TRANSIT"|| snapshot.data.data[index].status == "ACCEPTED"?  "Live Track": "Book Again",
                                          style: GoogleFonts.poppins(fontSize: 14, color: orangeCol, fontWeight: FontWeight.w500)),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                        ],
                      ),
                    );

                  },);
              }else{
                return Center(child: Text("You don't have any bike ride",style: GoogleFonts.poppins(
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



      ),
    );
  }
}
