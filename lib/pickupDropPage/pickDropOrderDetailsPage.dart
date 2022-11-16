import 'package:delivery_on_time/constants.dart';
import 'package:delivery_on_time/pickup_drop_screen/model/pickUpDropOrderDetailsModel.dart';
import 'package:delivery_on_time/pickup_drop_screen/model/pickUpDropOrderDetailsModel.dart';
import 'package:delivery_on_time/pickup_drop_screen/model/pickUpDropOrderDetailsModel.dart';
import 'package:delivery_on_time/pickup_drop_screen/model/pickUpDropOrderDetailsModel.dart';
import 'package:delivery_on_time/pickup_drop_screen/repository/pickupDropRepository.dart';
import 'package:flutter/material.dart';
import 'package:delivery_on_time/pickup_drop_screen/model/pickDropOrderListModel.dart';
import 'package:flutter_shimmer/flutter_shimmer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';


class PickDropOrderDetailsPage extends StatefulWidget {
  final Data orderData;

  const PickDropOrderDetailsPage({Key key, this.orderData}) : super(key: key);

  @override
  _PickDropOrderDetailsPageState createState() => _PickDropOrderDetailsPageState(orderData);
}

class _PickDropOrderDetailsPageState extends State<PickDropOrderDetailsPage> {
  PickupDropRepository _pickupDropRepository;
  Future<PickUpDropOrderDetailsModel> _pickDropOrderDetailsApi;
  final Data orderData;
  SharedPreferences prefs;
  String userToken = "";
  _PickDropOrderDetailsPageState(this.orderData);

  Future<void> createSharedPref() async {
    prefs = await SharedPreferences.getInstance();
    userToken = prefs.getString("user_token");
    _pickDropOrderDetailsApi = _pickupDropRepository.pickupDropOrderdetails(userToken,orderData.id);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _pickupDropRepository=new PickupDropRepository();
    createSharedPref();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          backgroundColor: darkThemeBlue,
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
              title: Center(
                  child: Text(
                    "Pick & Drop Order Details",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: screenWidth * 0.045),
                  )),
              actions: <Widget>[
                IconButton(
                  color: Colors.white,
                  icon: Icon(
                    Icons.notifications,
                    color: Colors.white,
                    size: 0,
                  ),
                ),
              ]),
          body:  Padding(
            padding: const EdgeInsets.fromLTRB(8.0,8.0,8.0,0.0),
            child: ListView(
              physics: BouncingScrollPhysics(),
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("ORDER #${orderData.id}  ", style: GoogleFonts.poppins(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w600)),
                      (orderData.transactionStatus=="Success" || orderData.transactionStatus=="Cod")?
                      Icon(Icons.check_circle,
                        color: Colors.green,
                        size: 18,)
                          :
                      Icon(Icons.error,
                        color: Colors.red,
                        size: 17,),
                    ],
                  ),
                ),
                Center(
                  child: Text("Order Placed on ${DateFormat.yMMMMEEEEd().format(DateFormat("yyyy-MM-dd").parse(orderData.createdAt, true))}  ",
                      style: GoogleFonts.poppins(fontSize: 13, color: textCol, fontWeight: FontWeight.w400)),
                ),
                /*Container(
                  margin: EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 8.0),
                  padding: EdgeInsets.fromLTRB(8.0, 16.0, 25.0, 16.0),
                  height: 210,
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(12.0), color: Colors.white),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Column(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Icon(
                                Icons.location_history,
                                color: orangeCol,
                                size: 17,
                              ),
                            ),
                            Expanded(
                                flex: 4,
                                child: VerticalDivider(
                                  color: Colors.black,
                                  indent: 3,
                                  endIndent: 3,
                                )),
                            Expanded(
                              flex: 1,
                              child: Icon(
                                Icons.location_pin,
                                color: orangeCol,
                                size: 17,
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Container(),
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 8,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 1,
                              child: Text("${orderData.senderName??"Sender Name"}",
                                  style: GoogleFonts.poppins(
                                      fontSize: 13.5,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600)),
                            ),
                            Expanded(
                              flex: 1,
                              child: Text("${orderData.senderMobile??"Sender Mobile"}",
                                  style: GoogleFonts.poppins(
                                      fontSize: 13,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500)),
                            ),
                            Expanded(
                              flex: 3,
                              child:  Padding(
                                padding: const EdgeInsets.only(top: 2.0),
                                child: Text("${orderData.senderAddress??"Sender Address"}",
                                    overflow: TextOverflow.fade,
                                    style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w400)),
                              ),
                            ),

                            Expanded(
                              flex: 1,
                              child: Text("${orderData.receiverName??"Receiver Name"}",
                                  style: GoogleFonts.poppins(
                                      fontSize: 13.5,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600)),
                            ),
                            Expanded(
                              flex: 1,
                              child: Text("${orderData.receiverMobile??"Receiver Mobile"}",
                                  style: GoogleFonts.poppins(
                                      fontSize: 13,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500)),
                            ),
                            Expanded(
                              flex: 2,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 2.0),
                                child: Text("${orderData.receiverAddress??"Receiver Address"}",
                                    overflow: TextOverflow.fade,
                                    style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w400)),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),*/
                Container(
                  margin: EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 8.0),
                  padding: EdgeInsets.fromLTRB(8.0, 10.0, 8.0, 10.0),
                  height: 230,
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(12.0), color: Colors.white),
                  child: ListView(
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    children: [
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top:5.0,bottom: 0.0,),
                                    child: Align(
                                      alignment: Alignment.topLeft,
                                      child: Icon(
                                        Icons.location_history,
                                        color: orangeCol,
                                        size: 17,
                                      ),
                                    ),

                                  ),
                                  const Padding(
                                    padding: EdgeInsets.only(left: 5.0, top: 10.0,bottom: 0.0),
                                    child: SizedBox(
                                      height: 120,
                                      width: 5,
                                      child: VerticalDivider(
                                        color: Colors.black,
                                        thickness: 1,
                                      ),
                                    ),
                                  ),

                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom:45.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Align(
                                      alignment: Alignment.topLeft,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(left: 8.0, top: 0.0,),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Align(
                                                  alignment: Alignment.centerLeft,
                                                  child: ConstrainedBox(
                                                    constraints: const BoxConstraints(
                                                      maxWidth: 300,
                                                    ),
                                                    child:Container(
                                                      child: Text(
                                                          "${orderData.senderName??"Sender Name"}",
                                                          textAlign: TextAlign.start,
                                                          overflow: TextOverflow.ellipsis,
                                                          style: GoogleFonts.poppins(
                                                              fontSize: 13.5,
                                                              color: Colors.black,
                                                              fontWeight: FontWeight.w600)),
                                                    ),
                                                  ),


                                                ),


                                              ],
                                            ),
                                          ),


                                        ],
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.topLeft,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(left: 8.0, top: 2.0,),
                                            child: Row(mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Align(
                                                  alignment: Alignment.centerLeft,
                                                  child: Text("${orderData.senderMobile??"Sender Mobile"}",
                                                      textAlign: TextAlign.start,
                                                      overflow: TextOverflow.ellipsis,
                                                      style: GoogleFonts.poppins(
                                                          fontSize: 13,
                                                          color: Colors.black,
                                                          fontWeight: FontWeight.w500)),

                                                ),

                                              ],
                                            ),
                                          ),


                                        ],
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.topLeft,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(left: 8.0, top: 3.0,),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Align(
                                                  alignment: Alignment.centerLeft,
                                                  child: ConstrainedBox(
                                                    constraints: const BoxConstraints(
                                                      maxWidth: 300,
                                                    ),
                                                    child:Container(
                                                      child: Text(
                                                          "${orderData.senderAddress??"Sender Address"}",
                                                          textAlign: TextAlign.start,
                                                          overflow: TextOverflow.ellipsis,
                                                          style: GoogleFonts.poppins(
                                                              fontSize: 12,
                                                              color: Colors.black,
                                                              fontWeight: FontWeight.w400)),
                                                    ),
                                                  ),


                                                ),


                                              ],
                                            ),
                                          ),


                                        ],
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.topLeft,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(left: 8.0, top: 3.0,),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Align(
                                                  alignment: Alignment.centerLeft,
                                                  child: ConstrainedBox(
                                                    constraints: const BoxConstraints(
                                                      maxWidth: 300,
                                                    ),
                                                    child:Container(
                                                      child: Text(
                                                          "Landmark:${orderData.senderLandmark??""}",
                                                          textAlign: TextAlign.start,
                                                          overflow: TextOverflow.ellipsis,
                                                          style: GoogleFonts.poppins(
                                                              fontSize: 12,
                                                              color: Colors.black,
                                                              fontWeight: FontWeight.w400)),
                                                    ),
                                                  ),


                                                ),


                                              ],
                                            ),
                                          ),


                                        ],
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.topLeft,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(left: 8.0, top: 3.0,),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Align(
                                                  alignment: Alignment.centerLeft,
                                                  child: ConstrainedBox(
                                                    constraints: const BoxConstraints(
                                                      maxWidth: 300,
                                                    ),
                                                    child:Container(
                                                      child: Text(
                                                          "Remark:${orderData.productRemarks??""}",
                                                          textAlign: TextAlign.start,
                                                          overflow: TextOverflow.ellipsis,
                                                          style: GoogleFonts.poppins(
                                                              fontSize: 12,
                                                              color: Colors.black,
                                                              fontWeight: FontWeight.w400)),
                                                    ),
                                                  ),


                                                ),


                                              ],
                                            ),
                                          ),


                                        ],
                                      ),
                                    ),

                                  ],
                                ),
                              ),
                            ],
                          ),
                          FutureBuilder<PickUpDropOrderDetailsModel>(
                            future: _pickDropOrderDetailsApi,
                            builder: (context, AsyncSnapshot snapshot) {
                              if (snapshot.hasData) {
                                if(snapshot.data.data.length>0){
                                  return  ListView.builder(
                                      padding: EdgeInsets.zero,
                                      shrinkWrap: true,
                                      scrollDirection: Axis.vertical,
                                      physics: const ClampingScrollPhysics(),
                                      itemCount: snapshot.data.data[0].receiverDetails.length,
                                      itemBuilder: (BuildContext context, int index) {
                                        return Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(top:8.0,bottom:8.0),
                                              child: Row(
                                                children: [
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Padding(
                                                        padding: const EdgeInsets
                                                            .only(
                                                          bottom: 85.0,),
                                                        child: Icon(
                                                          Icons.location_pin,
                                                          color: orangeCol,
                                                          size: 17,
                                                        ),
                                                      ),


                                                    ],
                                                  ),
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Padding(
                                                        padding: const EdgeInsets.only(left:8.0),
                                                        child: Row(
                                                          children: [
                                                            ConstrainedBox(
                                                              constraints: const BoxConstraints(
                                                                maxWidth: 230,
                                                              ),
                                                              child:Container(
                                                                width:230,
                                                                child: Text(
                                                                    "${snapshot.data.data[0].receiverDetails[index].receiverName??"Receiver name"}",
                                                                    textAlign: TextAlign.start,
                                                                    overflow: TextOverflow.ellipsis,
                                                                    style: GoogleFonts.poppins(
                                                                        fontSize: 13.5,
                                                                        color: Colors.black,
                                                                        fontWeight: FontWeight.w600)),
                                                              ),
                                                            ),
                                                            const SizedBox(width: 15),
                                                            Text(
                                                                "${snapshot.data.data[0].receiverDetails[index].status??"Status"}",
                                                                textAlign: TextAlign.start,
                                                                overflow: TextOverflow.ellipsis,
                                                                style: GoogleFonts.poppins(
                                                                    fontSize: 10.5,
                                                                    color: Colors.grey,
                                                                    fontWeight: FontWeight.w600))

                                                          ],
                                                        ),
                                                      ),

                                                      Align(
                                                        alignment: Alignment.topLeft,
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                          children: [
                                                            Padding(
                                                              padding: const EdgeInsets.only(left: 8.0, top: 2.0,),
                                                              child: Row(mainAxisAlignment: MainAxisAlignment.start,
                                                                children: [
                                                                  Container(
                                                                    width:230,
                                                                    child: Align(
                                                                      alignment: Alignment.centerLeft,
                                                                      child: Text("${snapshot.data.data[0].receiverDetails[index].receiverMobile??"+91"}",
                                                                          textAlign: TextAlign.start,
                                                                          overflow: TextOverflow.ellipsis,
                                                                          style: GoogleFonts.poppins(
                                                                              fontSize: 13,
                                                                              color: Colors.black,
                                                                              fontWeight: FontWeight.w500)),

                                                                    ),
                                                                  ),
                                                                  const SizedBox(width: 19),
                                                                  GestureDetector(
                                                                    onTap: () async {
                                                                      await showDialog(
                                                                          context: context,
                                                                          builder: (_) => imageDialog('Pickup Drop Image', "$imageBaseURL${snapshot.data.data[0].receiverDetails[index].image}", context));

                                                                    },
                                                                    child: Container(
                                                                      height:30.0,
                                                                      width:40.0,
                                                                      child: FadeInImage(
                                                                        image: NetworkImage(
                                                                          "$imageBaseURL${snapshot.data.data[0].receiverDetails[index].image}",
                                                                        ),
                                                                        placeholder: AssetImage("assets/images/placeHolder/square_white.png"),
                                                                        fit: BoxFit.fill,
                                                                      ),
                                                                    ),
                                                                  ),

                                                                  /*Align(alignment: Alignment.topCenter,
                                                                    child:  Padding(
                                                                      padding: const EdgeInsets.only(left: 0.0,top: 6.0),
                                                                      child: Image.asset("assets/images/food_images/snacksShop.png",
                                                                        width: 30.0,
                                                                        height: 30.0,),
                                                                    ),
                                                                  ),*/

                                                                ],
                                                              ),
                                                            ),


                                                          ],
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.only(left:8.0),
                                                        child: Align(
                                                          alignment: Alignment.centerLeft,
                                                          child: ConstrainedBox(
                                                            constraints: const BoxConstraints(
                                                              maxWidth: 300,
                                                            ),
                                                            child:Container(
                                                              child: Text(
                                                                  "${snapshot.data.data[0].receiverDetails[index].receiverAddress??"Receiver Address"}",
                                                                  textAlign: TextAlign.start,
                                                                  overflow: TextOverflow.ellipsis,
                                                                  style: GoogleFonts.poppins(
                                                                      fontSize: 12,
                                                                      color: Colors.black,
                                                                      fontWeight: FontWeight.w400)),
                                                            ),
                                                          ),


                                                        ),
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.only(left:8.0),
                                                        child: Align(
                                                          alignment: Alignment.centerLeft,
                                                          child: ConstrainedBox(
                                                            constraints: const BoxConstraints(
                                                              maxWidth: 300,
                                                            ),
                                                            child:Container(
                                                              child: Text(
                                                                  "Landmark: ${snapshot.data.data[0].receiverDetails[index].receiverLandmark??"--- "}",
                                                                  textAlign: TextAlign.start,
                                                                  overflow: TextOverflow.ellipsis,
                                                                  style: GoogleFonts.poppins(
                                                                      fontSize: 12,
                                                                      color: Colors.black,
                                                                      fontWeight: FontWeight.w400)),
                                                            ),
                                                          ),


                                                        ),
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.only(left:8.0),
                                                        child: Align(
                                                          alignment: Alignment.centerLeft,
                                                          child: ConstrainedBox(
                                                            constraints: const BoxConstraints(
                                                              maxWidth: 300,
                                                            ),
                                                            child:Container(
                                                              child: Text(
                                                                  "Remark: ${snapshot.data.data[0].receiverDetails[index].remarks??"---"}",
                                                                  textAlign: TextAlign.start,
                                                                  overflow: TextOverflow.ellipsis,
                                                                  style: GoogleFonts.poppins(
                                                                      fontSize: 12,
                                                                      color: Colors.black,
                                                                      fontWeight: FontWeight.w400)),
                                                            ),
                                                          ),


                                                        ),
                                                      ),

                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        );
                                      });
                                }else{
                                  return Center(child: Text("You don't have any pickup order",style: GoogleFonts.poppins(
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

                        ],
                      ),
                    ],
                  ),

                ),
                Visibility(
                  visible: orderData.carrier!=null /*&& (orderData.status=="ASSIGNED" || orderData.status=="ENROUTE" || orderData.status=="IN_TRANSIT")*/,
                  child: Container(
                    margin: EdgeInsets.fromLTRB(0.0, 4.0, 0.0, 4.0),
                    padding: EdgeInsets.all(12.0),
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(12.0), color: Colors.white),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Delivery Partner Details",
                                  style: GoogleFonts.poppins(
                                      fontSize: 13,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600)),
                              SizedBox(
                                height: 5,
                              ),
                              Visibility(
                                visible: orderData.status== "CANCELLED"  ||  orderData.status=="DELIVERED" || orderData.status=="REJECTED" || orderData.status=="DECLINED" || orderData.status=="PENDING" ? false: true,

                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Text("Mobile :",
                                          style: GoogleFonts.poppins(
                                              fontSize: 12,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500)),
                                    ),
                                    Expanded(
                                      flex: 4,
                                      child: Text("${(orderData.carrier)!=null?orderData.carrier.mobileNumber:"Courier Mobile Number"}",
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.poppins(
                                              fontSize: 12,
                                              color: Colors.black87,
                                              fontWeight: FontWeight.w500)),
                                    ),

                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Text("Vehicle Type :",
                                        style: GoogleFonts.poppins(
                                            fontSize: 12,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500)),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Text("${(orderData.carrier)!=null?orderData.carrier.vehicleType:"vehicleType"}",
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.poppins(
                                            fontSize: 12,
                                            color: Colors.black87,
                                            fontWeight: FontWeight.w500)),
                                  ),

                                ],
                              ),

                            ],
                          ),
                        ),
                        Visibility(
                          visible: orderData.status== "CANCELLED"  ||  orderData.status=="DELIVERED" || orderData.status=="REJECTED" || orderData.status=="DECLINED" || orderData.status=="PENDING" ? false: true,
                          child: Expanded(
                            flex: 1,
                            child: ButtonTheme(
                              /*__To Enlarge Button Size__*/
                              height: 30.0,
                              minWidth: 70.0,
                              child: RaisedButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                onPressed: () {
                                  print(orderData.carrier.mobileNumber);
                                  launch('tel: ${orderData.carrier.mobileNumber}');
                                },
                                color: orangeCol,
                                textColor: Colors.white,
                                child: Row(
                                  children: [
                                    Icon(Icons.call,size: 13,),
                                    SizedBox(
                                      width: 2,
                                    ),
                                    Text("Call", style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w500)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),

                      ],
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 15.0),
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
                                  fontSize: 13.5,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600)),
                          Spacer(),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text("${orderData.senderName}",
                                  style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400)),
                              Text("${orderData.senderMobile}",
                                  style: GoogleFonts.poppins(
                                      fontSize: 11.8,
                                      color: Colors.black54,
                                      fontWeight: FontWeight.w400)),
                            ],
                          )
                        ],
                      ),

                      Padding(
                        padding: const EdgeInsets.fromLTRB(1.0, 12.0, 1.0, 10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            (orderData.expectedDeliveryTime!=null)?
                            Row(
                              children: [
                                Text(
                                  "Expected Delivery Date ",
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.poppins(color: Colors.black87, fontWeight: FontWeight.w400, fontSize: 12),
                                ),
                                Spacer(),
                                Text(
                                  "${DateFormat.yMEd().add_jms().format(DateFormat("yyyy-MM-dd HH:mm:ss").parse(orderData.expectedDeliveryTime, true))}",
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.poppins(color: Colors.black87, fontWeight: FontWeight.w400, fontSize: 12.5),
                                )
                              ],
                            )
                                :Container(),
                            Row(
                              children: [
                                Text(
                                  "Delivery Distance ",
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.poppins(color: Colors.black87, fontWeight: FontWeight.w400, fontSize: 12),
                                ),
                                Spacer(),
                                Text(
                                  "${orderData.distance} km.",
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.poppins(color: Colors.black87, fontWeight: FontWeight.w400, fontSize: 12.5),
                                )
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    "Product Details",
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.poppins(
                                        color: Colors.black54, fontWeight: FontWeight.w500, fontSize: 13),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    "${orderData.productName}",
                                    textAlign: TextAlign.end,
                                    overflow: TextOverflow.visible,
                                    style: GoogleFonts.poppins(
                                        color: Colors.black54, fontWeight: FontWeight.w500, fontSize: 13),
                                  ),
                                ),
                              ],
                            ),

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
                              "Order Amount ",
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.poppins(color: orangeCol, fontWeight: FontWeight.w600, fontSize: 12.5),
                            ),
                            Spacer(),
                            Text(
                              "Rs. ${orderData.payableAmount} ",
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.poppins(color: orangeCol, fontWeight: FontWeight.w600, fontSize: 14),
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
            ),
          )



        ));
  }
  Widget imageDialog(text, path, context) {
    return Dialog(
      // backgroundColor: Colors.transparent,
      // elevation: 0,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$text',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Icon(Icons.close_rounded),
                  color: Colors.redAccent,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Container(
              width: 220,
              height: 200,
              child: FadeInImage(
                image: NetworkImage(
                  path
                ),
                placeholder: AssetImage("assets/images/placeHolder/square_white.png"),
                fit: BoxFit.fill,
              )
            ),
          ),
        ],
      ),
    );}
}
