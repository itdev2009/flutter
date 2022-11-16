import 'package:delivery_on_time/constants.dart';
import 'package:delivery_on_time/customAlertDialog.dart';
import 'package:delivery_on_time/loginMobile_screen/loginByMobile.dart';
import 'package:delivery_on_time/orderDetails_screen/orderListPage.dart';
import 'package:delivery_on_time/pickupDropPage/pickDropOrderListPage.dart';
import 'package:delivery_on_time/profile_screen/profileManage.dart';
import 'package:delivery_on_time/rideService/rideBookingList.dart';
import 'package:delivery_on_time/walletScreen/walletPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';



class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  SharedPreferences prefs;
  String name="";
  String email="";
  String userId="";
  String userPhoto="";
  // final gooleSignIn = GoogleSignIn();
  FirebaseAuth auth = FirebaseAuth.instance;
  // final facebookLogin = FacebookLogin();

  Future<void> initDynamicLinks() async {
    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData dynamicLink) async {
          final Uri deepLink = dynamicLink?.link;
          if (deepLink != null) {
            handleSuccessLinkData(dynamicLink);
          }
        }, onError: (OnLinkErrorException e) async {
      print('onLinkError');
      print(e.message);
    }
    );
  }
  void handleSuccessLinkData(PendingDynamicLinkData dynamicLinkData) {
    final Uri deepLink = dynamicLinkData.link;
    print(">>>>>>>>>>>$deepLink");
    if(deepLink!=null){
      var isRefer=deepLink.pathSegments.contains("refer");
      if(isRefer){
        var code = deepLink.queryParameters["referralCode"];
        if(code!=null){
          print(">>>>$code");
          //navigate with code
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (
                  context) =>
              LoginByMobilePage()
            ),
          );
        }
      }
    }
  }

  Future<String> generateLink(String reffer_code) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://apps.deliveryontime.me',
        link: Uri.parse(
            'https://apps.deliveryontime.me/refer?referralCode=$reffer_code'),
        androidParameters: AndroidParameters(
          packageName: 'com.inceptory.delivery_on_time',
          minimumVersion: 0,
        ),
        socialMetaTagParameters: SocialMetaTagParameters(
            title: "Refer A Friend",
            description: "Refer And Earn",
            imageUrl: Uri.parse("https://www.istockphoto.com/vector/people-making-money-from-referral-refer-a-friend-or-referral-marketing-concept-gm1224324620-359947285")
        )
    );
    final Uri dynamicUrl = await parameters.buildUrl();
    final ShortDynamicLink shortenedLink =
    await DynamicLinkParameters.shortenUrl(
      dynamicUrl,
      DynamicLinkParametersOptions(
          shortDynamicLinkPathLength: ShortDynamicLinkPathLength.unguessable),
    );
    final Uri shortUrl = shortenedLink.shortUrl;
    String link = "${shortUrl.toString()}";
    print("ShortLink${shortUrl.toString()}", );
    await Share.share("Refer a friend $link",
      subject: "Refer And Earn",
    );

    return "https://apps.deliveryontime.me" + shortUrl.path;
  }

  void initState() {
    super.initState();
    createSharedPref();
    initDynamicLinks();
  }

  Future<void> createSharedPref() async {
    prefs = await SharedPreferences.getInstance();
    if(prefs.getString("user_token")=="" || prefs.getString("user_token")==null){
      Fluttertoast.showToast(
          msg: "Please Login First",
          fontSize: 16,
          backgroundColor: Colors.orange[100],
          textColor: darkThemeBlue,
          toastLength: Toast.LENGTH_LONG);
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) {
            return LoginByMobilePage();
          }));
    }
    userId=prefs.getString("user_id");
    userPhoto=prefs.getString("user_photo");
    name=prefs.getString("name");
    email=prefs.getString("email");
    print(prefs.getString("name"));
    setState(() {

    });
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: darkThemeBlue,
        body: ListView(
          shrinkWrap: true,
          children: [
            Container(
              // height: screenHeight * 0.26,
              child: Column(
                children: [
                  //Upper Container with Address and icons....
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: screenWidth * 0.35,
                        ),
                        //Address Text....
                        Text(
                          "PROFILE".toUpperCase(),
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: screenWidth * 0.044,
                              fontWeight: FontWeight.bold),
                        ),
                        //Bell Icon in Expanded....
                        SizedBox(
                          width: screenWidth * 0.24,
                        ),
                        Container(
                          alignment: Alignment.centerRight,
                          child: IconButton(
                            icon: Icon(
                              Icons.notifications_none,
                              color: Colors.white,
                              size: 25.0,
                            ),
                            onPressed: () {
                              // do something
                            },
                          ),
                        )
                      ],
                    ),
                  ),

                  // Profile Image and Name Email...
                  Container(
                    margin: EdgeInsets.fromLTRB(screenWidth * 0.09, 10, 0, 20),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: (){
                            // Future.delayed(Duration.zero, () {
                              showDialog(
                                  context: context,
                                  barrierDismissible: true,
                                  builder: (context) {
                                    return CustomDialog(
                                      backgroundColor: Colors.transparent,
                                      clipBehavior: Clip.hardEdge,
                                      insetPadding: EdgeInsets.all(0),
                                      child: Padding(
                                        padding: const EdgeInsets.all(00.0),
                                        child: SizedBox(
                                          width: screenWidth*0.8,
                                          height: screenWidth,
                                          child: InteractiveViewer(
                                            panEnabled: true, // Set it to false to prevent panning.
                                            boundaryMargin: EdgeInsets.all(50),
                                            minScale: 0.5,
                                            maxScale: 4,
                                            child: FadeInImage(
                                              // height: screenWidth * 0.7,
                                              // width: screenWidth * 0.7,
                                              image: NetworkImage(
                                                "${(userPhoto=="" || userPhoto=="null")?"${imageBaseURL}null":"$imageBaseURL$userPhoto"}",
                                              ),
                                              placeholder: AssetImage("assets/images/icons/profile.png"),
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  });
                            // });
                          },
                          child: Container(
                            // margin: EdgeInsets.only(top: 20,bottom: 20),
                            padding: EdgeInsets.all(3),
                            height: screenWidth * 0.22,
                            width: screenWidth * 0.22,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: Container(
                              height: screenWidth * 0.2,
                              width: screenWidth * 0.2,
                              clipBehavior: Clip.hardEdge,
                              decoration: BoxDecoration(
                                  color: Colors.orange,
                                  shape: BoxShape.circle),
                              child: FadeInImage(
                                height: screenWidth * 0.095,
                                width: screenWidth * 0.095,
                                image: NetworkImage(
                                  "${(userPhoto=="" || userPhoto=="null")?"${imageBaseURL}null":"$imageBaseURL$userPhoto"}",
                                ),
                                placeholder: AssetImage("assets/images/icons/profile.png"),
                                fit: BoxFit.fill,
                              ),
                              // child: Image.asset("asset/blank-profile-picture-973460_1280.webp")
                            ),
                          ),
                        ),

                        // CircleAvatar(
                        //   radius: screenWidth * 0.10,
                        //   backgroundColor: Colors.white,
                        //   child: CircleAvatar(
                        //     radius: screenWidth * 0.095,
                        //     backgroundImage:
                        //         NetworkImage("$imageBaseURL$userPhoto"),
                        //   ),
                        // ),
                        SizedBox(
                          width: screenWidth * 0.05,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${name??""}",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: screenWidth * 0.045,
                                  fontWeight: FontWeight.w600),
                            ),
                            SizedBox(
                              height: screenHeight * 0.01,
                            ),
                            Text(
                              "${email??""}",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: screenWidth * 0.035,
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: lightThemeBlue,
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(30.0)),
              ),
              // child: child,
            ),
            SizedBox(height: screenHeight*0.010,),
            Card(
              color: darkThemeBlue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0)),
              clipBehavior: Clip.hardEdge,
              child: Container(
                height: screenHeight*0.58,
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    SizedBox(height: screenHeight*0.015,),
                    Container(
                      margin: EdgeInsets.fromLTRB(screenWidth*0.03, 0, screenWidth*0.03 ,0),
                      height: screenHeight*0.135,
                      decoration: BoxDecoration(
                        color: orangeCol,
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 1,
                            child: InkWell(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                  // return OrderDetailsPage();
                                  return OrderListPage();
                                }));
                              },
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.sports_motorsports_outlined,
                                    color: Colors.white,
                                    size: screenWidth*0.08,),
                                    SizedBox(height: screenHeight*0.01,),
                                    Text("All Orders".toUpperCase(),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: screenWidth*0.03,
                                      fontWeight: FontWeight.w500
                                    ),),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: InkWell(
                              onTap: (){
                                print('WALLET CLICKED');
                                Navigator.push(context, MaterialPageRoute(
                                    builder: (context) => WalletPage()
                                ));
                                //     Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                //    return WalletPage();
                                //    }));
                              },


                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.account_balance_wallet_outlined,
                                      color: Colors.white,
                                      size: screenWidth*0.08,),
                                    SizedBox(height: screenHeight*0.01,),
                                    InkWell(
                                   //   onTap: (){

                                   //     print('WALLET CLICKED');
                                  //       Navigator.push(context, MaterialPageRoute(
                                  //           builder: (context) => PickDropOrderListPage()
                                  //      ));
                                   //     Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                      //    return WalletPage();
                                    //    }));
                                   //   },
                                      child: Text("WALLET".toUpperCase(),
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: screenWidth*0.03,
                                            fontWeight: FontWeight.w500

                                        ),),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: InkWell(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                  return PickDropOrderListPage();
                                }));
                                // Navigator.of(context).pushAndRemoveUntil(
                                //     MaterialPageRoute(builder: (context) => PickupOrderDetailsPage()),
                                //         (Route<dynamic> route) => route is HomeController
                                // ModalRoute.withName("/HomePage")
                                // );
                              },

                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [

                                    Container(
                                      height: screenHeight*0.04,
                                      margin: EdgeInsets.fromLTRB(0, 2, 0, 0),
                                      child: Image.asset("assets/images/logos/courier.png"),
                                    ),

                                    // Icon(Icons.location_on,
                                   //   color: Colors.white,
                                  //    size: screenWidth*0.08,),

                                    SizedBox(height: screenHeight*0.01,),
                                    InkWell(
                                     // onTap: (){
                                        // Navigator.pushAndRemoveUntil(
                                        //     context,
                                        //     MaterialPageRoute(builder: (BuildContext context) => PickDropConfirmPage()),
                                        //     ModalRoute.withName('/home')
                                        // );

                                        // Navigator.push(context, MaterialPageRoute(
                                        //     builder: (context) => MyAppMap()
                                        // ));
                                    //  },
                                      child: Text("All Pickup".toUpperCase(),
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: screenWidth*0.03,
                                            fontWeight: FontWeight.w500
                                        ),),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(screenWidth*0.03, screenWidth*0.03, screenWidth*0.03 ,0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                      child: ListView(
                        shrinkWrap: true,
                        physics: ScrollPhysics(),
                        children: [
                          Container(
                            margin: EdgeInsets.fromLTRB(
                                screenWidth*0.04,
                                screenWidth*0.04,
                                screenWidth*0.04,
                                screenWidth*0.03
                            ),

                            child: Text(
                              "My Account",
                              style: TextStyle(
                                  fontSize: screenWidth*0.04,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.all(screenWidth*0.03),
                            child: InkWell(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                  return ProfileManagePage();
                                  // return PictureUpload();
                                }));
                              },
                              child: Row(
                                children: [
                                  Icon(Icons.person_outline,
                                    color: orangeCol,),
                                  SizedBox(width: screenWidth*0.04,),
                                  Text(
                                    "Manage Profile",
                                    style: TextStyle(
                                      fontSize: screenWidth*0.04,
                                      color: Colors.black38,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          Container(
                            margin: EdgeInsets.all(screenWidth*0.03),
                            child: InkWell(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                  return WalletPage();
                                }));
                              },
                              child: Row(
                                children: [
                                  Icon(Icons.account_balance_wallet_outlined,
                                    color: orangeCol,),
                                  SizedBox(width: screenWidth*0.04,),
                                  Text(
                                    "Add Wallet up to 10% Cash Back",
                                    style: TextStyle(
                                      fontSize: screenWidth*0.04,
                                      color: Colors.black38,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.all(screenWidth*0.03),
                            child: InkWell(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                  return RideBookingList();
                                }));
                              },
                              child: Row(
                                children: [
                                  Icon(Icons.sports_motorsports_outlined,
                                    color: orangeCol,),
                                  SizedBox(width: screenWidth*0.04,),
                                  Text(
                                    "Your Trips",
                                    style: TextStyle(
                                      fontSize: screenWidth*0.04,
                                      color: Colors.black38,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.all(screenWidth*0.03),
                            child: InkWell(
                              onTap: (){
                                //  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                //    return PickDropOrderListPage();
                                //    }));
                                // Navigator.of(context).pushAndRemoveUntil(
                                //     MaterialPageRoute(builder: (context) => PickupOrderDetailsPage()),
                                //         (Route<dynamic> route) => route is HomeController
                                // ModalRoute.withName("/HomePage")
                                // );
                                generateLink(userId);
                                //Share.share('Check out this app! https://play.google.com/store/apps/details?id=com.inceptory.delivery_on_time');

                              },
                              child: Row(
                                children: [
                                  //  Icon(Icons.local_shipping,
                                  // color: orangeCol,),

                                  Container(
                                    height: screenHeight*0.031,
                                    margin: EdgeInsets.fromLTRB(0, 2, 0, 0),
                                    child: Image.asset("assets/images/icons/refer_earn_2.png",
                                    ),
                                  ),
                                  SizedBox(width: screenWidth*0.04,),
                                  Text(
                                    "Refer Your Friend",
                                    style: TextStyle(
                                      fontSize: screenWidth*0.04,
                                      color: Colors.black38,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          Visibility(
                            visible: false,
                            child: Container(
                              margin: EdgeInsets.all(screenWidth*0.03),
                              child: InkWell(
                                onTap: (){
                                //  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                                //    return PickDropOrderListPage();
                              //    }));
                                  // Navigator.of(context).pushAndRemoveUntil(
                                  //     MaterialPageRoute(builder: (context) => PickupOrderDetailsPage()),
                                  //         (Route<dynamic> route) => route is HomeController
                                    // ModalRoute.withName("/HomePage")
                                  // );

                                  Share.share('Check out this app! https://play.google.com/store/apps/details?id=com.inceptory.delivery_on_time');

                                },
                                child: Row(
                                  children: [
                                  //  Icon(Icons.local_shipping,
                                     // color: orangeCol,),

                                    Container(
                                      height: screenHeight*0.031,
                                      margin: EdgeInsets.fromLTRB(0, 2, 0, 0),
                                      child: Image.asset("assets/images/logos/dot.png"),
                                    ),
                                    SizedBox(width: screenWidth*0.04,),
                                    Text(
                                      "Share App Now",
                                      style: TextStyle(
                                        fontSize: screenWidth*0.04,
                                        color: Colors.black38,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          // Container(
                          //   margin: EdgeInsets.all(screenWidth*0.03),
                          //   child: Row(
                          //     children: [
                          //       Icon(Icons.payment,
                          //         color: orangeCol,),
                          //       SizedBox(width: screenWidth*0.04,),
                          //       Text(
                          //         "Payment",
                          //         style: TextStyle(
                          //           fontSize: screenWidth*0.04,
                          //           color: Colors.black38,
                          //         ),
                          //       ),
                          //     ],
                          //   ),
                          // ),


                          // Container(
                          //   margin: EdgeInsets.all(screenWidth*0.03),
                          //   child: InkWell(
                          //     onTap: (){
                          //       Navigator.push(context, MaterialPageRoute(
                          //           builder: (context) => PasswordChangePage()
                          //       ));
                          //     },
                          //     child: Row(
                          //       children: [
                          //         Icon(Icons.lock_outline,
                          //           color: orangeCol,),
                          //         SizedBox(width: screenWidth*0.04,),
                          //         Text(
                          //           "Change Password",
                          //           style: TextStyle(
                          //             fontSize: screenWidth*0.04,
                          //             color: Colors.black38,
                          //           ),
                          //         ),
                          //       ],
                          //     ),
                          //   ),
                          // ),



                          Container(
                            margin: EdgeInsets.all(screenWidth*0.03),
                            child: InkWell(
                              onTap: () async {
                                const url = 'https://wa.me/918800440394';
                                if (await canLaunch(url)) {
                                  await launch(url);
                               }
                                  else {
                               throw 'Could not launch $url';
                                }
                              },
                              child: Row(
                                children: [
                                  Icon(Icons.support_agent_outlined,
                                    color: orangeCol,),
                                  SizedBox(width: screenWidth*0.04,),
                                  Text(
                                    "Help and Support",
                                    style: TextStyle(
                                      fontSize: screenWidth*0.04,
                                      color: Colors.black38,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.all(screenWidth*0.03),
                            child: InkWell(

                              onTap: (){

                                showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: Text("Do you want to Logout?",
                                          style: GoogleFonts.poppins(fontWeight: FontWeight.w500, color: Colors.black, fontSize: 16),),
                                        // content: Column(
                                        //   mainAxisSize: MainAxisSize.min,
                                        //   children: <Widget>[
                                        //     Text(
                                        //       "Do you want to Logout?"
                                        //     ),
                                        //   ],
                                        // ),
                                        actions: <Widget>[
                                          FlatButton(
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                              child: Text("Yes, Logout"),
                                            ),
                                            textColor: Colors.white,
                                            color: orangeCol,
                                            shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(5.0)),
                                            onPressed: () async {
                                              print(prefs.getString("cart_id"));
                                              print(prefs.getKeys());
                                              // prefs.setString("cart_id", "");
                                              // prefs.setString("coupon_code", "");
                                              // prefs.setString("user_id", "");
                                              // prefs.setString("token", "");
                                              // prefs.setString("name", "");
                                              // prefs.setString("email", "");
                                              // prefs.setString("user_token", "");
                                              // prefs.setString("cart_item_number", "");
                                              // prefs.setString("user_photo", "null");
                                              // prefs.setBool("user_login", false);
                                              userLogin=false;
                                              prefs.clear();
                                              // signOutUser();
                                              // logout();
                                              // Navigator.pushReplacement(context,
                                              //     MaterialPageRoute(builder: (BuildContext context) {
                                              //       return Login();

                                              //     }));
                                              Navigator.of(context).pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);


                                            },
                                          ),
                                          FlatButton(
                                            child: Text("No"),
                                            textColor: Colors.white,
                                            color: orangeCol,
                                            shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(5.0)),
                                            onPressed: () async {
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ],
                                      );
                                    });
                              },
                              child: Row(
                                children: [
                                  Icon(Icons.exit_to_app,
                                    color: orangeCol,),
                                  SizedBox(width: screenWidth*0.04,),
                                  Text(
                                    "Logout",
                                    style: TextStyle(
                                      fontSize: screenWidth*0.04,
                                      color: Colors.black38,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                        ],
                      ),
                    ),
                    SizedBox(height: screenHeight*0.09,),

                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Future<bool> signOutUser() async {
  //   User user = await auth.currentUser;
  //   print(user.providerData[0].providerId);
  //   if (user.providerData[0].providerId == 'google.com') {
  //     await gooleSignIn.disconnect();
  //   }
  //   await auth.signOut();
  //   return Future.value(true);
  // }
  //
  // logout(){
  //   facebookLogin.logOut();
  // }

}
