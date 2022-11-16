// import 'package:delivery_on_time/constants.dart';
// import 'package:delivery_on_time/forgetPassword_screen/forgetPasswordOtpPage.dart';
// import 'package:delivery_on_time/help/api_response.dart';
// import 'package:delivery_on_time/login_screen/bloc/bikeRideCreateBloc.dart';
// import 'package:delivery_on_time/login_screen/bloc/loginByMailBloc.dart';
// import 'package:delivery_on_time/login_screen/model/loginByMailModel.dart';
// import 'package:delivery_on_time/login_screen/model/loginModel.dart';
// import 'package:delivery_on_time/registration_otp_screens/mobileNumberPage.dart';
// import 'package:delivery_on_time/screens/home.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_facebook_login/flutter_facebook_login.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:email_validator/email_validator.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert' as JSON;
//
// import '../customAlertDialog.dart';
//
//
//
//
// class Login extends StatefulWidget {
//
//   @override
//   _LoginState createState() => _LoginState();
// }
//
// class _LoginState extends State<Login> {
//
//   SharedPreferences prefs;
//   String DeviceID="";
//   final gooleSignIn = GoogleSignIn();
//   FirebaseAuth auth = FirebaseAuth.instance;
//   final facebookLogin = FacebookLogin();
//
//
//   final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
//   String _message = '';
//
//
//   _register() async {
//     //_firebaseMessaging.getToken().then((token) => print(token));
//     var tokenFirebase="";
//     _firebaseMessaging.getToken().then((token) async {
//       tokenFirebase=token;
//       print(token);
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       prefs.setString("device_id",tokenFirebase);
//       DeviceID=tokenFirebase;
//       print("sf");
//       String device_id = prefs.getString("device_id");
//       print(device_id);
//     });
//   }
//
//   void getMessage(){
//     _firebaseMessaging.configure(
//         onMessage: (Map<String, dynamic> message) async {
//           print('on message $message');
//           setState(() => _message = message["notification"]["title"]);
//         }, onResume: (Map<String, dynamic> message) async {
//       print('on resume $message');
//       setState(() => _message = message["notification"]["title"]);
//     }, onLaunch: (Map<String, dynamic> message) async {
//       print('on launch $message');
//       setState(() => _message = message["notification"]["title"]);
//     });
//   }
//
//
//   Future<void> createSharedPref() async {
//     prefs = await SharedPreferences.getInstance();
//     // DeviceID=prefs.getString("device_id");
//     // DeviceID="";
//   }
//   Future<void> managedSharedPref(LoginModel data) async {
//
//     prefs.setString("coupon_code", "");
//     prefs.setString("cart_id", "${data.cartId}");
//     prefs.setString("user_id", "${data.data.id}");
//     prefs.setString("name", "${data.data.name}");
//     // userName=data.data.name;
//     print("${data.data.name}");
//     prefs.setBool("user_login", true);
//     prefs.setString("email", "${data.data.email}");
//     prefs.setString("user_token", "${data.success.token}");
//     prefs.setString("user_phone", "${data.data.mobileNumber}");
//     prefs.setString("user_wallet_id", "${data.ewalletId}");
//     userLogin=true;
//   }
//   Future<void> managedSharedPrefLoginByMail(LoginByMailModel data) async {
//
//     prefs.setString("coupon_code", "");
//     prefs.setString("cart_id", "");
//     prefs.setString("user_id", "${data.data.data.id}");
//     prefs.setString("name", "${data.data.data.name}");
//     // userName=data.data.name;
//     print("${data.data.data.name}");
//     print("${data.data.data.email}");
//     prefs.setBool("user_login", true);
//     prefs.setString("email", "${data.data.data.email}");
//     prefs.setString("user_token", "${data.data.token}");
//     prefs.setString("user_phone", "${(data.data.data.mobileNumber)??""}");
//     userLogin=true;
//   }
//   navToAttachList(context) async {
//     Future.delayed(Duration.zero, () {
//       Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) {
//         return HomePage();
//       }));
//     });
//   }
//   TextEditingController _emailController = new TextEditingController();
//   TextEditingController _passwordController = new TextEditingController();
//
//   LoginBloc _loginBloc=new LoginBloc();
//   LoginByMailBloc _loginByMailBloc=new LoginByMailBloc();
//
//   @override
//   void initState() {
//     super.initState();
//     _firebaseMessaging.requestNotificationPermissions();
//     _register();
//     getMessage();
//     createSharedPref();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//
//     screenHeight= MediaQuery.of(context).size.height;
//     screenWidth= MediaQuery.of(context).size.width;
//     return SafeArea(
//       child: Scaffold(
//         backgroundColor: darkThemeBlue,
//         body: ListView(
//           shrinkWrap: true,
//           physics: ScrollPhysics(),
//           children: [
//
//             StreamBuilder<ApiResponse<LoginByMailModel>>(
//               stream: _loginByMailBloc.loginByMailStream,
//               builder: (context, snapshot) {
//                 if (snapshot.hasData) {
//                   switch (snapshot.data.status) {
//                     case Status.LOADING:
//                       return Container();
//                     // return CircularProgressIndicator(
//                     //     backgroundColor: circularBGCol,
//                     //     strokeWidth: strokeWidth,
//                     //     valueColor: AlwaysStoppedAnimation<Color>(circularStrokeCol)
//                     // );
//                     /*Loading(
//                               loadingMessage: snapshot.data.message,
//                             );*/
//                       break;
//                     case Status.COMPLETED:
//                       if (snapshot.data.data.success ==true)
//                       {
//                         print("complete");
//                         managedSharedPrefLoginByMail(snapshot.data.data);
//                         Navigator.pop(context);
//                         navToAttachList(context);
//                         Fluttertoast.showToast(
//                             msg: "Welcome ${snapshot.data.data.data.data.name}",
//                             fontSize: 16,
//                             backgroundColor: Colors.white,
//                             textColor: darkThemeBlue,
//                             toastLength: Toast.LENGTH_LONG);
//                       }else if(snapshot.data.data.success ==false){
//
//                         Navigator.pop(context);
//                         Fluttertoast.showToast(
//                             msg: "${snapshot.data.data.message}",
//                             fontSize: 16,
//                             backgroundColor: Colors.white,
//                             textColor: darkThemeBlue,
//                             toastLength: Toast.LENGTH_LONG);
//                       }
//                       break;
//                     case Status.ERROR:
//                       Navigator.pop(context);
//                       Fluttertoast.showToast(
//                           msg: "Invalid Email ID",
//                           fontSize: 16,
//                           backgroundColor: Colors.orange[100],
//                           textColor: darkThemeBlue,
//                           toastLength: Toast.LENGTH_LONG);
//                       //   Error(
//                       //   errorMessage: snapshot.data.message,
//                       // );
//                       break;
//                   }
//                 } else if (snapshot.hasError) {
//                   print("error");
//                 }
//
//                 return Container();
//               },
//             ),
//
//             // Delivery Logo.....
//
//             Container(
//               height: 85,
//               margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
//               child: Image.asset("assets/images/logos/delivery_icon.png"),
//             ),
//
//             // Heading Text.....
//
//             Text(
//               "DELIVERY ON TIME",
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                   color: textCol, fontSize: 12, fontWeight: font_bold),
//             ),
//
//             // Welcome Text.....
//
//             Padding(
//               padding: const EdgeInsets.fromLTRB(0, 40, 0, 10),
//               child: Text(
//                 "Welcome",
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 17,
//                   fontWeight: font_bold,
//                 ),
//               ),
//             ),
//
//             // details fetch StreamBuilder
//
//
//
//             // Sign in or up Text.....
//
//             Padding(
//               padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
//               child: Text(
//                 "Please Sign In or Sign Up to continue",
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 15,
//                   // fontWeight: font_bold,
//                 ),
//               ),
//             ),
//
//             // Email Text Field.....
//
//             Container(
//               height: 45.0,
//               alignment: Alignment.topCenter,
//               margin: EdgeInsets.fromLTRB(15, 25, 15, 10),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.all(Radius.circular(5.0)),
//               ),
//               child: TextField(
//                 textInputAction: TextInputAction.next,
//                 controller: _emailController,
//                 style: TextStyle(fontSize: 14.0),
//                 textAlignVertical: TextAlignVertical.top,
//                 keyboardType: TextInputType.emailAddress,
//                 decoration: InputDecoration(
//                     prefixIcon: Icon(Icons.person_outline),
//                     hintText: "User Email Id",
//                     hintStyle: TextStyle(
//                       color: Colors.grey,
//                       fontSize: 14.0,
//                     ),
//                     border: InputBorder.none),
//               ),
//             ),
//
//             //Password Text Field.....
//
//             Container(
//               height: 45.0,
//               alignment: Alignment.topCenter,
//               margin: EdgeInsets.fromLTRB(15, 5, 15, 15),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.all(Radius.circular(5.0)),
//               ),
//               child: TextField(
//                 textInputAction: TextInputAction.done,
//                 controller: _passwordController,
//                 style: TextStyle(fontSize: 14.0),
//                 textAlignVertical: TextAlignVertical.top,
//                 obscureText: true,
//                 obscuringCharacter: '*',
//                 decoration: InputDecoration(
//                     prefixIcon: Icon(Icons.lock_outline),
//                     hintText: " User Password",
//                     hintStyle: TextStyle(
//                       color: Colors.grey,
//                       fontSize: 14.0,
//                     ),
//                     border: InputBorder.none),
//               ),
//             ),
//
//             //Sign In Button.....
//
//             Padding(
//               padding: const EdgeInsets.fromLTRB(15, 5, 15, 15),
//               child: ButtonTheme(/*__To Enlarge Button Size__*/
//                 height: 50.0,
//                 child: RaisedButton(
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12.0),
//                   ),
//                   onPressed: () {
//                     if(_emailController.text=="" ||
//                         _passwordController.text=="")
//                     {
//                       Fluttertoast.showToast(
//                           msg: "Please Fill All Required Field",
//                           fontSize: 16,
//                           backgroundColor: Colors.orange[100],
//                           textColor: darkThemeBlue,
//                           toastLength: Toast.LENGTH_LONG);
//                     }else if(!EmailValidator.validate(_emailController.text)){
//                       Fluttertoast.showToast(
//                           msg: "Please Enter Correct Email ID",
//                           fontSize: 16,
//                           backgroundColor: Colors.orange[100],
//                           textColor: darkThemeBlue,
//                           toastLength: Toast.LENGTH_LONG);
//                     }else{
//                       Map body;
//                       body = {
//                         "email" : "${_emailController.text}",
//                         "password" : "${_passwordController.text}",
//                         "deviceid" : "$DeviceID"
//                       };
//                       _loginBloc.login(body);
//                     }
//
//                     print("${_emailController.text}");
//                     print("${_passwordController.text}");
//                   },
//                   color: orangeCol,
//                   textColor: Colors.white,
//                   child: StreamBuilder<ApiResponse<LoginModel>>(
//                     stream: _loginBloc.loginStream,
//                     builder: (context, snapshot) {
//                       if (snapshot.hasData) {
//                         switch (snapshot.data.status) {
//                           case Status.LOADING:
//                             return CircularProgressIndicator(
//                                 backgroundColor: circularBGCol,
//                                 strokeWidth: strokeWidth,
//                                 valueColor: AlwaysStoppedAnimation<Color>(circularStrokeCol)
//                             );
//                             /*Loading(
//                               loadingMessage: snapshot.data.message,
//                             );*/
//                             break;
//                           case Status.COMPLETED:
//                             if (snapshot.data.data.success != null)
//                             {
//                               print("complete");
//                               managedSharedPref(snapshot.data.data);
//                               navToAttachList(context);
//                               Fluttertoast.showToast(
//                                   msg: "Welcome ${snapshot.data.data.data.name}",
//                                   fontSize: 16,
//                                   backgroundColor: Colors.white,
//                                   textColor: darkThemeBlue,
//                                   toastLength: Toast.LENGTH_LONG);
//                             }
//                             break;
//                           case Status.ERROR:
//                             Fluttertoast.showToast(
//                                 msg: "Please Enter Correct Email ID and Password",
//                                 fontSize: 16,
//                                 backgroundColor: Colors.orange[100],
//                                 textColor: darkThemeBlue,
//                                 toastLength: Toast.LENGTH_LONG);
//                             //   Error(
//                             //   errorMessage: snapshot.data.message,
//                             // );
//                             break;
//                         }
//                       } else if (snapshot.hasError) {
//                         print("error");
//                       }
//
//                       return Text("Sign In",
//                           style: TextStyle(
//                               fontSize: 14,
//                               fontWeight: FontWeight.bold
//                           ));
//                     },
//                   ),
//
//                 ),
//               ),
//             ),
//
//             // Skip Text.....
//
//             InkWell(
//               onTap: (){
//                 Navigator.push(context,
//                     MaterialPageRoute(builder: (BuildContext context) {
//                       return HomePage();
//                     }));
//               },
//               child: Padding(
//               padding: const EdgeInsets.fromLTRB(0, 5, 0, 10),
//               child:  Text(
//                   "Skip Sign In for now >>>",
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                       color: textCol,
//                       fontSize: 13,
//                       fontWeight: FontWeight.bold
//                   ),
//                 ),
//               ),
//             ),
//
//             // Forgot Password Text.....
//
//             Padding(
//               padding: const EdgeInsets.fromLTRB(0, 5, 0, 10),
//               child: InkWell(
//                 onTap: (){
//                   /*Navigator.push(context,
//                       MaterialPageRoute(builder: (BuildContext context) {
//                         return MapHomePage();
//                         // return MyAppMap();
//                       }));*/
//                 },
//                 child: InkWell(
//                   onTap: (){
//                     Navigator.push(context,
//                         MaterialPageRoute(builder: (BuildContext context) {
//                           return ForgetPasswordOtpPage();
//                         }));
//                   },
//                   child: Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Text(
//                       "Forgot Password?",
//                       textAlign: TextAlign.center,
//                       style: TextStyle(
//                           color: textCol,
//                           fontSize: 13,
//                           fontWeight: FontWeight.bold
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//
//             // New Sign up Text.....
//
//             InkWell(
//               onTap: (){
//                 Navigator.push(context,
//                     MaterialPageRoute(builder: (BuildContext context) {
//                       return MobileNumberPage();
//                     }));
//               },
//               child: Padding(
//                   padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
//                   child: RichText(    // To Make Different Text Color in single line
//                     textAlign: TextAlign.center,
//                     text: TextSpan(
//                         text: "Don't have an account?",
//                         style: TextStyle(
//                             color: textCol,
//                             fontSize: 13,
//                             fontWeight: FontWeight.bold
//                         ),
//                         children: [
//                           TextSpan(
//                             text: " Sign Up",
//                             style: TextStyle(
//                                 color: orangeCol,
//                                 fontSize: 13,
//                                 fontWeight: FontWeight.bold
//                             ),
//                           ),
//                         ]
//                     ),
//                   )
//               ),
//             ),
//
//             // or connect with Text.....
//
//             Padding(
//               padding: const EdgeInsets.fromLTRB(0, 15, 0, 20),
//               child: Text(
//                 "or connect with",
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                     color: textCol,
//                     fontSize: 13,
//                     fontWeight: FontWeight.bold
//                 ),
//               ),
//             ),
//
//             // fb and google logo.....
//
//             Center(
//               child: Container(
//                 height: 40.0,
//                 width: 100.0,
//                 child: Row(
//                   children: [
//                     InkWell(
//                         onTap: (){
//                           Fluttertoast.showToast(
//                               msg: "Facebook Login Coming soon",
//                               fontSize: 16,
//                               backgroundColor: Colors.white,
//                               textColor: darkThemeBlue,
//                               toastLength: Toast.LENGTH_LONG);
//                           // loginWithFB();
//                           // signOutUser();
//                           // initiateFacebookLogin();
//                         },
//                         child: Image.asset("assets/images/logos/facebook.png")),
//                     SizedBox(width: 20.0,),
//                     InkWell(
//                         onTap: (){
//                           // Fluttertoast.showToast(
//                           //     msg: "Google login Coming soon",
//                           //     fontSize: 16,
//                           //     backgroundColor: Colors.white,
//                           //     textColor: darkThemeBlue,
//                           //     toastLength: Toast.LENGTH_LONG);
//                           // googleSignIn(context);
//                           // logout();
//                         },
//                         child: Image.asset("assets/images/logos/google-plus.png")),
//                   ],
//                 ),
//               ),
//             ),
//
//             SizedBox(height: 50.0,),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Future<bool> googleSignIn(context) async {
//     GoogleSignInAccount googleSignInAccount = await gooleSignIn.signIn();
//
//     if (googleSignInAccount != null) {
//       GoogleSignInAuthentication googleSignInAuthentication =
//       await googleSignInAccount.authentication;
//
//       AuthCredential credential = GoogleAuthProvider.credential(
//           idToken: googleSignInAuthentication.idToken,
//           accessToken: googleSignInAuthentication.accessToken);
//
//       // AuthResult result = await auth.signInWithCredential(credential);
//       // FirebaseUser user = await auth.currentUser();
//
//       User user = (await auth.signInWithCredential(credential)).user;
//       print(user.uid);
//       print(user.photoURL);
//       print(user.phoneNumber);
//       print(user.displayName);
//       print(user.metadata);
//       print(user.email);
//       print(user.emailVerified);
//
//       Map body={
//         "email": "${user.email}",
//         "password": "${user.uid}",
//         "name": "${user.displayName}"
//       };
//       print(body);
//       _loginByMailBloc.loginByMail(body);
//       Future.delayed(Duration.zero, () {
//         return showDialog(
//             context: context,
//             barrierDismissible: false,
//             builder: (context) {
//               return WillPopScope(
//                 onWillPop: () async => false,
//                 child: CustomDialog(
//                   backgroundColor: Colors.white60,
//                   clipBehavior: Clip.hardEdge,
//                   insetPadding: EdgeInsets.all(0),
//                   child: Padding(
//                     padding: const EdgeInsets.all(20.0),
//                     child: SizedBox(
//                       width: 50.0,
//                       height: 50.0,
//                       child: CircularProgressIndicator(
//                           backgroundColor: circularBGCol,
//                           strokeWidth: strokeWidth,
//                           valueColor:
//                           AlwaysStoppedAnimation<Color>(circularStrokeCol)),
//                     ),
//                   ),
//                 ),
//               );
//             });
//       });
//
//
//       return Future.value(true);
//     }
//   }
//
//   Future<bool> signOutUser() async {
//     User user = await auth.currentUser;
//     print(user.providerData[0].providerId);
//     if (user.providerData[0].providerId == 'google.com') {
//       await gooleSignIn.disconnect();
//     }else if (user.providerData[0].providerId == 'facebook.com') {
//       /// https://stackoverflow.com/questions/55958516/cannot-sign-out-from-facebook-using-flutter-with-firebase
//       // await fbLogin.logOut();
//     }
//     await auth.signOut();
//     return Future.value(true);
//   }
//
//   loginWithFB() async{
//
//     final result = await facebookLogin.logIn(['email']);
//
//     switch (result.status) {
//       case FacebookLoginStatus.loggedIn:
//         final token = result.accessToken.token;
//         final graphResponse = await http.get('https://graph.facebook.com/v2.12/me?fields=name,picture,email&access_token=${token}');
//         final Map profile = JSON.jsonDecode(graphResponse.body);
//         print(profile);
//         Map body={
//           "email": "${profile['email']}",
//           "password": "${profile['id']}",
//           "name": "${profile['name']}"
//         };
//         print(body);
//         print(profile['name']);
//         print(profile['id']);
//         Future.delayed(Duration.zero, () {
//           return showDialog(
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
//         });
//         _loginByMailBloc.loginByMail(body);
//         break;
//
//       case FacebookLoginStatus.cancelledByUser:
//         print("cancelled");
//         break;
//       case FacebookLoginStatus.error:
//         print("error");
//         break;
//     }
//
//   }
//
// }
//
