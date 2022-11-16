import 'package:delivery_on_time/cart_screen/bloc/couponApplyBloc.dart';
import 'package:delivery_on_time/cart_screen/cartPage.dart';
import 'package:delivery_on_time/cart_screen/cart_page.dart';
import 'package:delivery_on_time/cart_screen/model/couponApplyModel.dart';
import 'package:delivery_on_time/constants.dart';
import 'package:delivery_on_time/customAlertDialog.dart';
import 'package:delivery_on_time/help/api_response.dart';
import 'package:delivery_on_time/restaurants_screen/model/allCouponModel.dart';
import 'package:delivery_on_time/restaurants_screen/repository/foodHomeRepository.dart';
import 'package:delivery_on_time/screens/couponShapeBorder.dart';
import 'package:delivery_on_time/utility/Error.dart';
import 'package:flutter/material.dart';
import 'package:flutter_shimmer/flutter_shimmer.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PromoCodePage extends StatefulWidget {
  @override
  _PromoCodePageState createState() => _PromoCodePageState();
}

class _PromoCodePageState extends State<PromoCodePage> {

  TextEditingController _couponController = new TextEditingController();

  SharedPreferences prefs;
  String userId;
  String userToken;
  String vendorId;
  String parentCategoryId;
  String cartAmount;
  String appliedCouponCode="";

  CouponApplyBloc _couponApplyBloc;
  Future<AllCouponModel> _allCouponApi;
  FoodHomeRepository _foodHomeRepo = new FoodHomeRepository();


  Future<void> createSharedPref() async {
    prefs = await SharedPreferences.getInstance();
    userId = prefs.getString("user_id");
    userToken = prefs.getString("user_token");
    vendorId = prefs.getString("vendor_id");
    parentCategoryId = prefs.getString("parent_category_id");
    cartAmount=prefs.getString("Total_cart_amount");
    // appliedCouponCode=prefs.getString("coupon_code");
    // _couponController.text=appliedCouponCode;
    // Map _body = {"userid": "$userId"};
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    createSharedPref();
    _couponApplyBloc=new CouponApplyBloc();
    _allCouponApi=_foodHomeRepo.allCouponList();

  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      backgroundColor: lightThemeBlue,
      appBar: AppBar(
          backgroundColor: darkThemeBlue,
          leading: IconButton(
              onPressed: (){
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
              )),
          title: Center(
              child: Text(
                "Promo Code Offers",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: screenWidth * 0.045),
              )),
          actions: <Widget>[
            IconButton(
              onPressed: (){

              },
              icon: Icon(
                Icons.notifications,
                color: Colors.white,
              ),
            ),
          ]),
      body: Column(
        // shrinkWrap: true,
        // physics: NeverScrollableScrollPhysics(),
        children: [
          StreamBuilder<ApiResponse<CouponApplyModel>>(
            stream: _couponApplyBloc.couponApplyStream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                switch (snapshot.data.status) {
                  case Status.LOADING:
                    return Container();
                    break;
                  case Status.COMPLETED:
                    {
                      if(snapshot.data.data.data!=null){
                        prefs.setString("coupon_code", appliedCouponCode);
                        print("heheheheh applied");
                        Fluttertoast.showToast(
                            msg: "Coupon Applied",
                            fontSize: 16,
                            backgroundColor: Colors.orange[100],
                            textColor: darkThemeBlue,
                            toastLength: Toast.LENGTH_LONG);
                        Future.delayed(Duration.zero, (){
                          Navigator.pop(context);
                          Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (BuildContext context) {
                                return CartPageNew();
                              }));
                        });
                      }else{
                        Navigator.pop(context);
                        print("heheheheh apply hoy niii");
                        Fluttertoast.showToast(
                            msg: "Coupon is not valid for cart items",
                            fontSize: 16,
                            backgroundColor: Colors.orange[100],
                            textColor: darkThemeBlue,
                            toastLength: Toast.LENGTH_LONG);
                        Future.delayed(Duration.zero, (){
                        });
                      }
                    }
                    break;
                  case Status.ERROR:
                    Navigator.pop(context);
                    Fluttertoast.showToast(
                        msg: "Please try again",
                        fontSize: 16,
                        backgroundColor: Colors.orange[100],
                        textColor: darkThemeBlue,
                        toastLength: Toast.LENGTH_LONG);

                    return Error(
                      errorMessage: snapshot.data.message,
                    );
                    break;
                }
              } else if (snapshot.hasError) {
                print("error");
              }
              return  Container();
            },
          ),
          Container(
            height: 45.0,
            alignment: Alignment.topCenter,
            margin: EdgeInsets.fromLTRB(15, 25, 15, 10),
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(7.0)),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: TextField(
                    enableSuggestions: true,
                    controller: _couponController,
                    style: TextStyle(fontSize: 14.0),
                    textAlignVertical: TextAlignVertical.top,
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.local_offer_outlined,
                        color: Colors.grey[400],),
                        hintText: "Enter Promo Code Here",
                        hintStyle: GoogleFonts.poppins(
                          color: Colors.grey,
                          fontSize: 14.0,
                        ),
                        border: InputBorder.none),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: ButtonTheme(   /*__To Enlarge Button Size__*/
                    height: 45.0,
                    child: RaisedButton(
                      onPressed: () {
                        if(_couponController.text.trim()=="")
                        {
                          Fluttertoast.showToast(
                              msg: "Please Enter Coupon Code",
                              fontSize: 16,
                              backgroundColor: Colors.orange[100],
                              textColor: darkThemeBlue,
                              toastLength: Toast.LENGTH_LONG);
                        }else{
                          Map body;
                          body = {
                            "coupon_code":"${_couponController.text.trim()}",
                            "vendor_id":"$vendorId",
                            "category_id":"$parentCategoryId",
                            "cart_total_amount":"$cartAmount",
                            "user_id":"$userId"
                          };
                          appliedCouponCode=_couponController.text.trim();
                          _couponApplyBloc.couponApply(body, userToken);
                          showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (context) {
                                return WillPopScope(
                                  onWillPop: () async => false,
                                  child: CustomDialog(
                                    backgroundColor: Colors.white60,
                                    clipBehavior: Clip.hardEdge,
                                    insetPadding: EdgeInsets.all(0),
                                    child: Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: SizedBox(
                                        width: 50.0,
                                        height: 50.0,
                                        child: CircularProgressIndicator(
                                            backgroundColor: circularBGCol,
                                            strokeWidth: strokeWidth,
                                            valueColor:
                                            AlwaysStoppedAnimation<Color>(circularStrokeCol)),
                                      ),
                                    ),
                                  ),
                                );
                              });
                        }
                      },
                      color: orangeCol,
                      textColor: Colors.white,
                      child: Text("Apply",
                          style: GoogleFonts.poppins(
                              fontSize: screenWidth*0.035,
                              fontWeight: FontWeight.bold
                          )),
                    ),
                  ),
                )
              ],
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
          //   child: ButtonTheme(   /*__To Enlarge Button Size__*/
          //     height: 50.0,
          //     child: RaisedButton(
          //       shape: RoundedRectangleBorder(
          //         borderRadius: BorderRadius.circular(12.0),
          //       ),
          //       onPressed: () {
          //         if(_couponController.text.trim()=="")
          //         {
          //           Fluttertoast.showToast(
          //               msg: "Please Enter Coupon Code",
          //               fontSize: 16,
          //               backgroundColor: Colors.orange[100],
          //               textColor: darkThemeBlue,
          //               toastLength: Toast.LENGTH_LONG);
          //         }else{
          //           Map body;
          //           body = {
          //             "coupon_code":"${_couponController.text.trim()}",
          //             "vendor_id":"$vendorId",
          //             "category_id":"$parentCategoryId",
          //             "cart_total_amount":"$cartAmount",
          //             "user_id":"$userId"
          //           };
          //           _couponApplyBloc.couponApply(body, userToken);
          //           showDialog(
          //               context: context,
          //               barrierDismissible: false,
          //               builder: (context) {
          //                 return WillPopScope(
          //                   onWillPop: () async => false,
          //                   child: CustomDialog(
          //                     backgroundColor: Colors.white60,
          //                     clipBehavior: Clip.hardEdge,
          //                     insetPadding: EdgeInsets.all(0),
          //                     child: Padding(
          //                       padding: const EdgeInsets.all(20.0),
          //                       child: SizedBox(
          //                         width: 50.0,
          //                         height: 50.0,
          //                         child: CircularProgressIndicator(
          //                             backgroundColor: circularBGCol,
          //                             strokeWidth: strokeWidth,
          //                             valueColor:
          //                             AlwaysStoppedAnimation<Color>(circularStrokeCol)),
          //                       ),
          //                     ),
          //                   ),
          //                 );
          //               });
          //         }
          //       },
          //       color: orangeCol,
          //       textColor: Colors.white,
          //       child: Text("Apply Coupon",
          //               style: TextStyle(
          //                   fontSize: 15,
          //                   fontWeight: FontWeight.bold
          //               )),
          //     ),
          //   ),
          // ),
          Expanded(
            child: FutureBuilder<AllCouponModel>(
              future: _allCouponApi,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if(snapshot.data.data.isNotEmpty){
                    return ListView.builder(
                      physics: AlwaysScrollableScrollPhysics(),
                      padding: EdgeInsets.fromLTRB(screenWidth*0.03,screenWidth*0.01,screenWidth*0.03,20),
                      shrinkWrap: true,
                      itemCount: snapshot.data.data.length,
                      itemBuilder: (context, index){
                        return Card(
                          color: Color(0xff003f6b),
                          elevation: 2,
                          shape: CouponShapeBorder(),
                          child: Container(
                            margin: EdgeInsets.fromLTRB(2,0,2,0),
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                    colors: [Color(0xff082336), Color(0xff003f6b)])),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 7,
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(screenWidth*0.03,screenWidth*0.03,screenWidth*0.00,screenWidth*0.03),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(snapshot.data.data[index].couponCode, style: GoogleFonts.poppins(fontSize: screenWidth*0.045,color: Colors.white,fontWeight: FontWeight.w500),),
                                            Spacer(),
                                            InkWell(
                                              onTap: (){
                                                showDialog(
                                                    context: context,
                                                    barrierDismissible: true,
                                                    builder: (context) {
                                                      return AlertDialog(
                                                        // title: Text("Give the code?"),
                                                        content: SingleChildScrollView(
                                                          child: Column(
                                                            mainAxisSize: MainAxisSize.min,
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: <Widget>[
                                                              Row(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  Expanded(
                                                                    flex: 2,
                                                                    child: Container(),
                                                                  ),
                                                                  Expanded(
                                                                    flex: 6,
                                                                    child: Container(
                                                                      clipBehavior: Clip.hardEdge,
                                                                      decoration: BoxDecoration(
                                                                          color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(15))),
                                                                      child: FadeInImage(
                                                                        height: 180.0,
                                                                        width: 130.0,
                                                                        image: NetworkImage(
                                                                          "$imageBaseURL${snapshot.data.data[index].couponBannerUrl}",
                                                                        ),
                                                                        placeholder: AssetImage("assets/images/placeHolder/Offer/blue.png"),
                                                                        fit: BoxFit.fill,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    flex: 2,
                                                                    child: Align(
                                                                      alignment: Alignment.topRight,
                                                                      child: InkWell(
                                                                          child: Icon(Icons.cancel_outlined),
                                                                          onTap: () {
                                                                            Navigator.pop(context);
                                                                          }),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              Padding(
                                                                padding: const EdgeInsets.only(top: 10.0),
                                                                child: Text(
                                                                  "${snapshot.data.data[index].couponDescription}",
                                                                  style: TextStyle(color: Colors.black, fontSize: 15.0, fontWeight: FontWeight.bold),
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding: const EdgeInsets.only(top: 12.0),
                                                                child: Text(
                                                                  "Valid From : ${snapshot.data.data[index].couponValidFrom}",
                                                                  style: TextStyle(
                                                                    color: Colors.black,
                                                                    fontSize: 12.0,
                                                                    // fontWeight: FontWeight.bold
                                                                  ),
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding: const EdgeInsets.only(top: 5.0),
                                                                child: Text(
                                                                  "Valid To : ${snapshot.data.data[index].couponValidTo}",
                                                                  style: TextStyle(
                                                                    color: Colors.black,
                                                                    fontSize: 12.0,
                                                                    // fontWeight: FontWeight.bold
                                                                  ),
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding: const EdgeInsets.only(top: 10.0),
                                                                child: Row(
                                                                  children: [
                                                                    Text(
                                                                      "Vendors : ",
                                                                      style: TextStyle(
                                                                        color: Colors.black,
                                                                        fontSize: 12.0,
                                                                        // fontWeight: FontWeight.bold
                                                                      ),
                                                                    ),
                                                                    Flexible(
                                                                      child: Text(
                                                                        (snapshot.data.data[index].vendors.length > 0)
                                                                            ? "${snapshot.data.data[index].vendors[0].shopName}"
                                                                            : "For All Vendors",
                                                                        style: TextStyle(color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w500),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding: const EdgeInsets.only(top: 10.0),
                                                                child: Row(
                                                                  children: [
                                                                    Text(
                                                                      "Coupon Code : ",
                                                                      style: TextStyle(
                                                                        color: Colors.black,
                                                                        fontSize: 12.0,
                                                                        // fontWeight: FontWeight.bold
                                                                      ),
                                                                    ),
                                                                    Text(
                                                                      "${snapshot.data.data[index].couponCode}",
                                                                      style: TextStyle(color: Colors.black, fontSize: 14.0, fontWeight: FontWeight.bold),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              Divider(
                                                                color: Colors.red,
                                                              ),
                                                              Center(
                                                                child: new FlatButton(
                                                                    shape: RoundedRectangleBorder(
                                                                        side: BorderSide(color: Colors.deepOrange, width: 1, style: BorderStyle.solid),
                                                                        borderRadius: BorderRadius.circular(5)),
                                                                    child: const Text(
                                                                      "Apply Coupon Code",
                                                                      style: TextStyle(
                                                                        color: Colors.deepOrangeAccent,
                                                                        fontSize: 14.0,
                                                                        // fontWeight: FontWeight.bold
                                                                      ),
                                                                    ),
                                                                    onPressed: () {
                                                                      Map body;
                                                                      body = {
                                                                        "coupon_code":"${snapshot.data.data[index].couponCode}",
                                                                        "vendor_id":"$vendorId",
                                                                        "category_id":"$parentCategoryId",
                                                                        "cart_total_amount":"$cartAmount",
                                                                        "user_id":"$userId"
                                                                      };
                                                                      appliedCouponCode=snapshot.data.data[index].couponCode;
                                                                      Navigator.pop(context);
                                                                      _couponApplyBloc.couponApply(body, userToken);
                                                                      showDialog(
                                                                          context: context,
                                                                          barrierDismissible: false,
                                                                          builder: (context) {
                                                                            return WillPopScope(
                                                                              onWillPop: () async => false,
                                                                              child: CustomDialog(
                                                                                backgroundColor: Colors.white60,
                                                                                clipBehavior: Clip.hardEdge,
                                                                                insetPadding: EdgeInsets.all(0),
                                                                                child: Padding(
                                                                                  padding: const EdgeInsets.all(20.0),
                                                                                  child: SizedBox(
                                                                                    width: 50.0,
                                                                                    height: 50.0,
                                                                                    child: CircularProgressIndicator(
                                                                                        backgroundColor: circularBGCol,
                                                                                        strokeWidth: strokeWidth,
                                                                                        valueColor:
                                                                                        AlwaysStoppedAnimation<Color>(circularStrokeCol)),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            );
                                                                          });
                                                                    }),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                    });
                                              },
                                              child: Text("DETAILS    ", style: GoogleFonts.poppins(fontSize: screenWidth*0.03,color: Color.fromRGBO(249, 123, 65, 1.0),fontWeight: FontWeight.w400),)),

                                          ],
                                        ),
                                        SizedBox(height: 10,),
                                        Text("Expires", style: GoogleFonts.poppins(fontSize: screenWidth*0.03,color: Colors.white70),),
                                        Text("${snapshot.data.data[index].couponValidTo}", style: GoogleFonts.poppins(fontSize: screenWidth*0.035,color: Color.fromRGBO(232, 234, 236, 1.0),fontWeight: FontWeight.w500),),
                                        SizedBox(height: 5,),
                                        Text(snapshot.data.data[index].couponDescription, style: GoogleFonts.poppins(fontSize: screenWidth*0.037,color: Color.fromRGBO(249, 123, 65, 1.0),fontWeight: FontWeight.w400),),
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: InkWell(
                                    onTap: (){
                                      Map body;
                                      body = {
                                        "coupon_code":"${snapshot.data.data[index].couponCode}",
                                        "vendor_id":"$vendorId",
                                        "category_id":"$parentCategoryId",
                                        "cart_total_amount":"$cartAmount",
                                        "user_id":"$userId"
                                      };
                                      appliedCouponCode=snapshot.data.data[index].couponCode;
                                      _couponApplyBloc.couponApply(body, userToken);
                                      showDialog(
                                          context: context,
                                          barrierDismissible: false,
                                          builder: (context) {
                                            return WillPopScope(
                                              onWillPop: () async => false,
                                              child: CustomDialog(
                                                backgroundColor: Colors.white60,
                                                clipBehavior: Clip.hardEdge,
                                                insetPadding: EdgeInsets.all(0),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(20.0),
                                                  child: SizedBox(
                                                    width: 50.0,
                                                    height: 50.0,
                                                    child: CircularProgressIndicator(
                                                        backgroundColor: circularBGCol,
                                                        strokeWidth: strokeWidth,
                                                        valueColor:
                                                        AlwaysStoppedAnimation<Color>(circularStrokeCol)),
                                                  ),
                                                ),
                                              ),
                                            );
                                          });
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.only(right:screenWidth*0.00),
                                      child: Text("Apply Now",style: GoogleFonts.poppins(color: Colors.white,fontWeight: FontWeight.w400),textAlign: TextAlign.center,),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    );

                  }else{
                    return Column(
                      children: [
                        SizedBox(height: 20,),
                        Image.asset("assets/images/icons/sad.png",
                          height: screenHeight*0.25,
                        ),
                        // Icon(Icons.home_work_outlined,
                        //   color: Colors.black87,
                        //   size: screenWidth*0.2,
                        // ),
                        SizedBox(height: 5,),
                        Text(
                          'WE DON\'T HAVE ANY COUPON',
                          style: GoogleFonts.poppins(fontSize: screenWidth*0.05,fontWeight: FontWeight.w500, color: Colors.white),
                        ),
                      ],
                    );

                  }
                } else if (snapshot.hasError) {
                  return Text("No Data Found");
                } else
                  return ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: 6,
                      itemBuilder: (context, index){
                        return ListTileShimmer(
                          padding: EdgeInsets.only(top: 0,bottom: 0),
                          margin: EdgeInsets.only(top: 20,bottom: 20),
                          height: 20,
                          isDisabledAvatar: false,
                          isRectBox: true,
                          colors: [
                            Colors.white
                          ],
                        );
                      }
                  );
              },
            ),
          ),
        ],
      ),
    )
    );
  }
}
