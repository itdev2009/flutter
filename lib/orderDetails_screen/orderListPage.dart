import 'package:blinking_text/blinking_text.dart';
import 'package:delivery_on_time/constants.dart';
import 'package:delivery_on_time/orderDetails_screen/model/orderListModel.dart';
import 'package:delivery_on_time/orderDetails_screen/orderDetailsPage.dart';
import 'package:delivery_on_time/orderDetails_screen/repository/orderDetailsRepository.dart';
import 'package:delivery_on_time/ratingScreen/ratingPage.dart';
import 'package:delivery_on_time/tracking_screen/mapTrackingPage.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_shimmer/flutter_shimmer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class OrderListPage extends StatefulWidget {
  @override
  _OrderListPageState createState() => _OrderListPageState();
}

class _OrderListPageState extends State<OrderListPage> {
  SharedPreferences prefs;
  String userToken = "";
  String userId = "";
  String userName="";
  String userEmail="";
  String userPhone="";
  OrderDetailsRepository _orderDetailsRepository;
  Future<OrderListModel> _orderListApi;
  Map _body;
  var statusCol;

  Future<void> createSharedPref() async {
    prefs = await SharedPreferences.getInstance();
    userToken = prefs.getString("user_token");
    userId = prefs.getString("user_id");
    userPhone = prefs.getString("user_phone");
    userName = prefs.getString("name");
    userEmail = prefs.getString("email");

    _body = {"userid": "$userId"};
    _orderDetailsRepository = new OrderDetailsRepository();
    _orderListApi = _orderDetailsRepository.orderList(_body, userToken);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    createSharedPref();
  }

  @override
  Widget build(BuildContext context) {
    /// 'Assigned','Accepted','Declined','Enroute','Delivered'
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
              "My Orders",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: screenWidth * 0.041),
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
        body: FutureBuilder<OrderListModel>(
          future: _orderListApi,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if(snapshot.data.data.length>0){
                List<Data> orderList = snapshot.data.data.reversed.toList();
                return ListView.builder(
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  itemCount: orderList.length,
                  itemBuilder: (context, index) {
                    Color orderStatusCol = (orderList[index].orderStatus == "Assigned")
                        ? Colors.amber[900]
                        :
                    (orderList[index].orderStatus == "Accepted")
                        ? Colors.teal[800]
                        : (orderList[index].orderStatus == "Declined" || orderList[index].orderStatus == "Cancelled")
                        ? Colors.red[900]
                        : (orderList[index].orderStatus == "Enroute")
                        ? Colors.orange[600]
                        : (orderList[index].orderStatus == "Delivered")
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
                                  "${(orderList[index].vendor != null) ? orderList[index].vendor.shopName : "Shop Name"}",
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.poppins(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 15),
                                ),
                              ),
                              Expanded(
                                flex: 4,
                                child: BlinkText(
                                  "${(orderList[index].orderStatus == null) ? "Order Placed" : orderList[index].orderStatus}",
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
                              Text(
                                "${(orderList[index].vendor != null) ? orderList[index].vendor.city : "City Name"}",
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.poppins(color: Colors.black87, fontWeight: FontWeight.w400, fontSize: 13),
                              ),
                              Spacer(),
                              Row(
                                mainAxisSize: MainAxisSize.min,
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
                            ],
                          ),
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
                                "₹ ${orderList[index].transactionAmount} ",
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
                                          "Order Amount ",
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.poppins(color: Colors.black45, fontWeight: FontWeight.w400, fontSize: 12),
                                        ),
                                        Spacer(),
                                        Text(
                                          "Rs. ${orderList[index].orderAmount} ",
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
                                          "+  Rs. ${orderList[index].taxAmount} ",
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.poppins(color: Colors.black45, fontWeight: FontWeight.w400, fontSize: 12),
                                        )
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "Delivery Charge ",
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.poppins(color: Colors.black45, fontWeight: FontWeight.w400, fontSize: 12),
                                        ),
                                        Spacer(),
                                        Text(
                                          "+  Rs. ${orderList[index].deliveryAmount} ",
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.poppins(color: Colors.black45, fontWeight: FontWeight.w400, fontSize: 12),
                                        )
                                      ],
                                    ),
                                    Visibility(
                                      visible: orderList[index].couponCode!=null,
                                      child: Row(
                                        children: [
                                          Text(
                                            "Coupon Applied (${orderList[index].couponCode}) ",
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.poppins(color: Colors.black45, fontWeight: FontWeight.w400, fontSize: 12),
                                          ),
                                          Spacer(),
                                          Text(
                                            "-  Rs. ${(double.parse(orderList[index].amountBeforeDiscount.toString())-double.parse(orderList[index].transactionAmount.toString())).floorToDouble()} ",
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.poppins(color: Colors.black45, fontWeight: FontWeight.w400, fontSize: 12),
                                          )
                                        ],
                                      ),
                                    ),


                                  ],
                                ),
                              ),
                            ),
                          ),
                          (orderList[index].itemDetails != null)
                              ? Column(
                            children: [
                              Divider(
                                height: 0.5,
                                color: Colors.black26,
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 8.0),
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    physics: ScrollPhysics(),
                                    itemCount: orderList[index].itemDetails.length,
                                    itemBuilder: (context, index1) {
                                      return Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              flex: 8,
                                              child: Text(
                                                "${orderList[index].itemDetails[index1].skuName}",
                                                overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts.poppins(
                                                    color: Colors.black54, fontWeight: FontWeight.w500, fontSize: 13),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: SizedBox(),
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: Text(
                                                "× ${orderList[index].itemDetails[index1].quantity} ",
                                                textAlign: TextAlign.left,
                                                overflow: TextOverflow.visible,
                                                style: GoogleFonts.poppins(
                                                    color: Colors.black54, fontWeight: FontWeight.w500, fontSize: 13),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 3,
                                              child: Text(
                                                "₹ ${orderList[index].itemDetails[index1].unitPrice}",
                                                textAlign: TextAlign.end,
                                                overflow: TextOverflow.visible,
                                                style: GoogleFonts.poppins(
                                                    color: Colors.black54, fontWeight: FontWeight.w500, fontSize: 13),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }),
                              ),
                            ],
                          )
                              : Container(),
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
                                            return OrderDetailsPage(orderData: orderList[index],
                                              userEmail: userEmail,
                                              userName: userName,
                                              userPhone: userPhone,);
                                          }));
                                    },
                                    color: orangeCol,
                                    textColor: Colors.white,
                                    child: Text("Order Details", style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500)),
                                  ),
                                ),
                                Spacer(),
                                Visibility(
                                  visible: orderList[index].orderStatus=="Assigned" || orderList[index].orderStatus=="Enroute",
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
                                        Navigator.push(context,
                                            MaterialPageRoute(builder: (BuildContext context) {
                                              return MapTrackingPage(orderList[index]);
                                            }));
                                      },
                                      color: Colors.white,
                                      textColor: orangeCol,
                                      child: Text("Track Order",
                                          style: GoogleFonts.poppins(fontSize: 14, color: orangeCol, fontWeight: FontWeight.w500)),
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible: orderList[index].orderStatus=="Delivered",
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
                                        Navigator.push(context,
                                            MaterialPageRoute(builder: (BuildContext context) {
                                              return RatingPage(
                                                vendorId: orderList[index].vendor.vendorId.toString(),
                                                courierId: orderList[index].carrierId.toString(),
                                                productSkuId: orderList[index].itemDetails[0].skuId.toString(),
                                              );
                                            }));
                                      },
                                      color: Colors.white,
                                      textColor: orangeCol,
                                      child: Text("Rate Order",
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
                  },
                );
              }else{
                return Center(child: Text("You don't have any order",style: GoogleFonts.poppins(
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
