import 'package:delivery_on_time/constants.dart';
import 'package:delivery_on_time/orderDetails_screen/model/orderListModel.dart';
import 'package:delivery_on_time/ratingScreen/ratingPage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';


class OrderDetailsPage extends StatefulWidget {
  final Data orderData;
  final String userName;
  final String userEmail;
  final String userPhone;

  const OrderDetailsPage({Key key, this.orderData, this.userName, this.userEmail, this.userPhone}) : super(key: key);


  @override
  _OrderDetailsPageState createState() => _OrderDetailsPageState(this.orderData, this.userName, this.userEmail, this.userPhone);
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  final Data orderData;
  final String userName;
  final String userEmail;
  final String userPhone;

  _OrderDetailsPageState(this.orderData, this.userName, this.userEmail, this.userPhone);


  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: darkThemeBlue,
      bottomNavigationBar: Visibility(
        visible: orderData.carrierId!=null && orderData.vendor!=null && orderData.itemDetails!=null,
        child: Container(
          decoration: BoxDecoration(
              border: Border(
                top: BorderSide(width: 0.4, color: orangeCol),
              ),),
          width: screenWidth,
          height: 50,
          child: RaisedButton(
            onPressed: () {
              if(orderData.vendor!=null && orderData.itemDetails!=null){
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (BuildContext context) {
                      return RatingPage(
                        vendorId: orderData.vendor.vendorId.toString(),
                        courierId: orderData.carrierId.toString(),
                        productSkuId: orderData.itemDetails[0].skuId.toString(),
                      );
                    }));
              }
            },
            color: Colors.white.withOpacity(0),
            textColor: orangeCol,
            child: Text("Rate Order",
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.poppins(
                    fontSize: screenWidth*0.045,
                    color: Colors.white,
                    letterSpacing: 1,
                    fontWeight: FontWeight.w500)),
          ),
        ),
      ),
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
            "Order Details",
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
      body: Padding(
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
            Container(
              margin: EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 8.0),
              padding: EdgeInsets.fromLTRB(8.0, 16.0, 25.0, 16.0),
              height: 160,
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
                            Icons.location_pin,
                            color: orangeCol,
                            size: 17,
                          ),
                        ),
                        Expanded(
                            flex: 3,
                            child: VerticalDivider(
                              color: Colors.black,
                              indent: 3,
                              endIndent: 3,
                            )),
                        Expanded(
                          flex: 1,
                          child: Icon(
                            Icons.home,
                            color: orangeCol,
                            size: 17,
                          ),
                        ),
                        Expanded(
                          flex: 1,
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
                          child: Text("${(orderData.vendor!=null)?orderData.vendor.shopName:"Shop Name"}",
                              style: GoogleFonts.poppins(
                                  fontSize: 13.5,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600)),
                        ),
                        Expanded(
                            flex: 3,
                            child:  Padding(
                              padding: const EdgeInsets.only(top: 2.0),
                              child: Text("${(orderData.vendor!=null)?orderData.vendor.address:"Shop Address"}",
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400)),
                            ),
                                ),
                        Expanded(
                          flex: 1,
                          child: Text("Home",
                          style: GoogleFonts.poppins(
                              fontSize: 13.5,
                              color: Colors.black,
                              fontWeight: FontWeight.w600)),
                        ),
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 2.0),
                            child: Text("${orderData.deliveryAddress}",
                                overflow: TextOverflow.ellipsis,
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
            ),
            Visibility(
              visible: orderData.carrierMobileNumber!=null && (orderData.orderStatus=="Assigned" || orderData.orderStatus=="Enroute"),
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
                          Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Text("Name :",
                                    style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500)),
                              ),
                              Expanded(
                                flex: 4,
                                child: Text("${orderData.carrierName??"Courier Name"}",
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        color: Colors.black87,
                                        fontWeight: FontWeight.w500)),
                              ),

                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Text("Email :",
                                    style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500)),
                              ),
                              Expanded(
                                flex: 4,
                                child: Text("${orderData.carrierEmail??"Courier Email ID"}",
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        color: Colors.black87,
                                        fontWeight: FontWeight.w500)),
                              ),

                            ],
                          ),
                          Row(
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
                                child: Text("${orderData.carrierMobileNumber??"Courier Mobile Number"}",
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        color: Colors.black87,
                                        fontWeight: FontWeight.w500)),
                              ),

                            ],
                          )
                        ],
                      ),
                    ),
                    Expanded(
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
                            print(orderData.carrierMobileNumber);
                            launch('tel: ${orderData.carrierMobileNumber}');
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

                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 14.0),
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
                          Text("$userName",
                              style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w400)),
                          Text("$userEmail",
                              style: GoogleFonts.poppins(
                                  fontSize: 11.5,
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w400)),
                          Text("$userPhone",
                              style: GoogleFonts.poppins(
                                  fontSize: 11.5,
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w400)),

                        ],
                      )
                    ],
                  ),
                  (orderData.itemDetails != null)
                      ? Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(1.0, 12.0, 1.0, 12.0),
                        child: ListView.builder(
                            shrinkWrap: true,
                            physics: ScrollPhysics(),
                            itemCount: orderData.itemDetails.length,
                            itemBuilder: (context, index1) {
                              return Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 8,
                                      child: Text(
                                        "${orderData.itemDetails[index1].skuName}",
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.poppins(
                                            color: Colors.black87, fontWeight: FontWeight.w500, fontSize: 13),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: SizedBox(),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                        "× ${orderData.itemDetails[index1].quantity} ",
                                        textAlign: TextAlign.left,
                                        overflow: TextOverflow.visible,
                                        style: GoogleFonts.poppins(
                                            color: Colors.black87, fontWeight: FontWeight.w500, fontSize: 13),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Text(
                                        "₹ ${orderData.itemDetails[index1].unitPrice}",
                                        textAlign: TextAlign.end,
                                        overflow: TextOverflow.visible,
                                        style: GoogleFonts.poppins(
                                            color: Colors.black87, fontWeight: FontWeight.w500, fontSize: 13),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                      ),
                      Divider(
                        height: 0.5,
                        color: Colors.black26,
                      ),
                    ],
                  )
                      : Container(),

                  Padding(
                    padding: const EdgeInsets.fromLTRB(1.0, 8.0, 1.0, 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Text(
                              "Order Amount ",
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.poppins(color: Colors.black87, fontWeight: FontWeight.w400, fontSize: 12),
                            ),
                            Spacer(),
                            Text(
                              "Rs. ${orderData.orderAmount} ",
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.poppins(color: Colors.black87, fontWeight: FontWeight.w400, fontSize: 12),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              "Tax & GST ",
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.poppins(color: Colors.black87, fontWeight: FontWeight.w400, fontSize: 12),
                            ),
                            Spacer(),
                            Text(
                              "+  Rs. ${orderData.taxAmount} ",
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.poppins(color: Colors.black87, fontWeight: FontWeight.w400, fontSize: 12),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              "Delivery Charge ",
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.poppins(color: Colors.black87, fontWeight: FontWeight.w400, fontSize: 12),
                            ),
                            Spacer(),
                            Text(
                              "+  Rs. ${orderData.deliveryAmount} ",
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.poppins(color: Colors.black87, fontWeight: FontWeight.w400, fontSize: 12),
                            )
                          ],
                        ),
                        Visibility(
                          visible: orderData.couponCode!=null,
                          child: Row(
                            children: [
                              Text(
                                "Coupon Applied (${orderData.couponCode}) ",
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.poppins(color: Colors.black87, fontWeight: FontWeight.w400, fontSize: 12),
                              ),
                              Spacer(),
                              Text(
                                "-  Rs. ${(double.parse(orderData.amountBeforeDiscount.toString())-double.parse(orderData.transactionAmount.toString())).floorToDouble()} ",
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.poppins(color: Colors.black87, fontWeight: FontWeight.w400, fontSize: 12),
                              )
                            ],
                          ),
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
                          "Rs. ${orderData.transactionAmount} ",
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
      ),
    ));
  }
}
