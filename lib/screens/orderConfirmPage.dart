import 'package:delivery_on_time/constants.dart';
import 'package:delivery_on_time/orderDetails_screen/oderDetails_page.dart';
import 'package:delivery_on_time/orderDetails_screen/orderListPage.dart';
import 'package:delivery_on_time/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderConfirmPage extends StatefulWidget {
  @override
  _OrderConfirmPageState createState() => _OrderConfirmPageState();
}

class _OrderConfirmPageState extends State<OrderConfirmPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: darkThemeBlue,
            body: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(8.0,8.0,8.0,45),
                      child: Image.asset(
                        "assets/images/icons/like.png",
                        width: screenWidth * 0.4,
                        height: screenWidth * 0.4,
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Text(
                        "Order Placed Successfully!",
                        style: GoogleFonts.poppins(color: Colors.white, fontSize: screenWidth * 0.055,
                        fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      Text(
                        "Thank you",
                        style: GoogleFonts.poppins(color: textCol, fontSize: screenWidth * 0.04,
                            fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Text(
                        "We have received your order",
                        style: GoogleFonts.poppins(color: textCol, fontSize: screenWidth * 0.04,
                            fontWeight: FontWeight.w500),
                      ),

                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 40, 15, 10),
                    child: ButtonTheme(   /*__To Enlarge Button Size__*/
                      height: 50.0,
                      minWidth: screenWidth,
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (BuildContext context) {
                                return OrderListPage();
                              }));
                        },
                        color: orangeCol,
                        textColor: Colors.white,
                        child: Text("Order Details",
                            style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w500
                            )),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                        border: Border.all(color: orangeCol,
                        width: 2.5),
                        borderRadius: BorderRadius.circular(12.0)
                    ),
                    child: ButtonTheme(   /*__To Enlarge Button Size__*/
                      height: 50.0,
                      minWidth: screenWidth,
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (BuildContext context) {
                                return HomePage();
                              }));
                        },
                        color: Colors.white,
                        textColor: orangeCol,
                        child: Text("Back to Home",
                            style: GoogleFonts.poppins(
                                fontSize: 16,
                                color: orangeCol,
                                fontWeight: FontWeight.w500
                            )),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 10, 15, 15),
                    child: ButtonTheme(
                      /*__To Enlarge Button Size__*/
                      height: 50.0,
                      minWidth: screenWidth * 0.4,
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        onPressed: () async {
                          const url = 'https://wa.me/918800440394';
                         // if (await canLaunch(url)) {
                           await launch(url);
                         // } else {
                           // throw 'Could not launch $url';
                        //  }
                        },
                        color: orangeCol,
                        textColor: Colors.white,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset("assets/images/icons/support.png",height: 20,),
                            Text("   Support", style: GoogleFonts.poppins(fontSize: 16,
                                fontWeight: FontWeight.w500)),
                          ],
                        ),
                      ),
                    ),
                  ),


                ],
              ),
            )));
  }
}
