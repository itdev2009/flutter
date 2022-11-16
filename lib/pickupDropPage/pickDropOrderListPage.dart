import 'package:blinking_text/blinking_text.dart';
import 'package:delivery_on_time/pickupDropPage/pickDropOrderDetailsPage.dart';
import 'package:delivery_on_time/pickup_drop_screen/model/pickDropOrderListModel.dart';
import 'package:delivery_on_time/pickup_drop_screen/repository/pickupDropRepository.dart';
import 'package:delivery_on_time/tracking_screen/mapTrackingPickDropPage.dart';
import 'package:delivery_on_time/tracking_screen/newMapTrackingPickDropPage.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_shimmer/flutter_shimmer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../constants.dart';


class PickDropOrderListPage extends StatefulWidget {
  @override
  _PickDropOrderListPageState createState() => _PickDropOrderListPageState();
}

class _PickDropOrderListPageState extends State<PickDropOrderListPage> {

  SharedPreferences prefs;
  String userToken = "";
  PickupDropRepository _pickupDropRepository;
  Future<PickupDropOrderListModel> _pickDropOrderListApi;
  Map _body;
  var statusCol;

  Future<void> createSharedPref() async {
    prefs = await SharedPreferences.getInstance();
    userToken = prefs.getString("user_token");
    _pickDropOrderListApi = _pickupDropRepository.pickupDropOrderList(userToken);
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
                  "Pick & Drop Orders",
                  style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w500, fontSize: screenWidth * 0.041),
                )),
            actions: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.notifications,
                  color: Colors.white,
                  size: 0,
                ),
              ),
            ]),
        body: FutureBuilder<PickupDropOrderListModel>(
          future: _pickDropOrderListApi,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if(snapshot.data.data.length>0){
               // List<Data> orderList = snapshot.data.data.reversed.toList();
                List<Data> orderList = snapshot.data.data.toList();
                return ListView.builder(
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  itemCount: orderList.length,
                  itemBuilder: (context, index) {
                    Color orderStatusCol = (orderList[index].status == "ASSIGNED")
                        ? Colors.amber[900]
                        : (orderList[index].status == "ACCEPTED")
                        ? Colors.teal[800]
                        : (orderList[index].status == "DECLINED" || orderList[index].status == "CANCELLED" || orderList[index].status == "REJECTED")
                        ? Colors.red[900]
                        : (orderList[index].status == "ENROUTE" || orderList[index].status == "IN_TRANSIT"  )
                        ? Colors.orange[600]
                        : (orderList[index].status == "DELIVERED")
                        ? Colors.green[700]
                        : Colors.blue[900];
                    return Container(
                      margin: EdgeInsets.fromLTRB(10.0, 6.0, 10.0, 6.0),
                      padding: EdgeInsets.fromLTRB(13.0, 8.0, 13.0, 10.0),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                flex: 7,
                                child: Text(
                                  "${orderList[index].receiverName??"Receiver Name"}",
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.poppins(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 15),
                                ),
                              ),
                              Expanded(
                                flex: 4,
                                child: BlinkText(
                                  "${(orderList[index].status == null) ? "Pick & Drop Placed" : orderList[index].status}",
                                  beginColor: orderStatusCol,
                                  endColor: Colors.grey[200],
                                  times: 2,
                                  textAlign: TextAlign.end,
                                  duration: Duration(seconds: 2),
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.poppins(color: orderStatusCol, fontWeight: FontWeight.w500, fontSize: 14),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 8,
                                child: Text(
                                  "${orderList[index].receiverAddress??"Receiver Address"}",
                                  overflow: TextOverflow.visible,
                                  style: GoogleFonts.poppins(color: Colors.black87, fontWeight: FontWeight.w400, fontSize: 13),
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      "${orderList[index].transactionStatus??" "} ",
                                      style: GoogleFonts.poppins(fontWeight: FontWeight.w400, color: Colors.black, fontSize: 13),
                                    ),
                                    (orderList[index].transactionStatus=="Success" || orderList[index].transactionStatus=="Cod")?
                                    Icon(Icons.check_circle,
                                      color: Colors.green,
                                      size: 14,)
                                        :
                                    Icon(Icons.error,
                                      color: Colors.red,
                                      size: 14,),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: screenWidth*0.02,),
                          Text(
                            "${DateFormat.yMMMMEEEEd().format(DateFormat("yyyy-MM-dd").parse(orderList[index].createdAt, true))}",
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.poppins(color: Colors.black87, fontWeight: FontWeight.w400, fontSize: 13),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0.0, 4.0, 3.0, 3.0),
                            child: ExpandablePanel(
                              theme: ExpandableThemeData(
                                // alignment: Alignment.centerLeft,
                                iconColor: orangeCol,
                                iconPlacement: ExpandablePanelIconPlacement.right,
                                headerAlignment: ExpandablePanelHeaderAlignment.center,
                              ),
                              header: Text(
                                "₹ ${orderList[index].payableAmount} ",
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
                                          "Delivery Charge ",
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.poppins(color: Colors.black45, fontWeight: FontWeight.w400, fontSize: 12),
                                        ),
                                        Spacer(),
                                        Text(
                                          "Rs. ${orderList[index].payableAmount} ",
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.poppins(color: Colors.black45, fontWeight: FontWeight.w400, fontSize: 12),
                                        )
                                      ],
                                    ),
                                    SizedBox(height: 5,),
                                    Row(
                                      children: [
                                        Text(
                                          "Total Distance",
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.poppins(color: Colors.black45, fontWeight: FontWeight.w400, fontSize: 12),
                                        ),
                                        Spacer(),
                                        Text(
                                          "${orderList[index].distance} km.",
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

                          Divider(
                            height: 0.5,
                            color: Colors.black26,
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 8.0),
                            child: Row(
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
                                    "${orderList[index].productName}",
                                    textAlign: TextAlign.end,
                                    overflow: TextOverflow.visible,
                                    style: GoogleFonts.poppins(
                                        color: Colors.black54, fontWeight: FontWeight.w500, fontSize: 13),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
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
                                            return PickDropOrderDetailsPage(orderData: orderList[index]);
                                          }));
                                    },
                                    color: orangeCol,
                                    textColor: Colors.white,
                                    child: Text("Order Details", style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500)),
                                  ),
                                ),
                                Spacer(),
                                Visibility(
                                  visible: orderList[index].status=="ASSIGNED" || orderList[index].status=="ENROUTE" ||  orderList[index].status=="IN_TRANSIT" ,
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
                                        /*Navigator.push(context,
                                            MaterialPageRoute(builder: (BuildContext context) {
                                              return MapTrackingPickDropPage(orderList[index]);
                                            }));
*/
                                        Navigator.push(context,
                                            MaterialPageRoute(builder: (BuildContext context) {
                                              return NewMapTrackingPickDropPage(pickupId: orderList[index].id);
                                            }));
                                      },
                                      color: Colors.white,
                                      textColor: orangeCol,
                                      child: Text("Track Order",
                                          style: GoogleFonts.poppins(fontSize: 14, color: orangeCol, fontWeight: FontWeight.w500)),
                                    ),
                                  ),
                                ),
                                // Visibility(
                                //   visible: orderList[index].status=="Delivered",
                                //   child: Container(
                                //     height: 40.0,
                                //     width: screenWidth * 0.4,
                                //     // margin: const EdgeInsets.fromLTRB(0, 5, 0, 15),
                                //     clipBehavior: Clip.hardEdge,
                                //     decoration: BoxDecoration(
                                //         border: Border.all(color: orangeCol, width: 1), borderRadius: BorderRadius.circular(12.0)),
                                //     child: RaisedButton(
                                //       shape: RoundedRectangleBorder(
                                //         borderRadius: BorderRadius.circular(10.0),
                                //       ),
                                //       onPressed: () {
                                //         Navigator.push(context,
                                //             MaterialPageRoute(builder: (BuildContext context) {
                                //               return RatingPage(
                                //                 vendorId: orderList[index].vendor.vendorId,
                                //                 courierId: orderList[index].carrierId,
                                //                 productSkuId: orderList[index].itemDetails[0].skuId,
                                //               );
                                //             }));
                                //       },
                                //       color: Colors.white,
                                //       textColor: orangeCol,
                                //       child: Text("Rate Order",
                                //           style: GoogleFonts.poppins(fontSize: 14, color: orangeCol, fontWeight: FontWeight.w500)),
                                //     ),
                                //   ),
                                // ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
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
      ),
    );
  }
}
