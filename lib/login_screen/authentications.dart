// import 'package:delivery_on_time/login_screen/bloc/loginByMailBloc.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_facebook_login/flutter_facebook_login.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert' as JSON;
//
// // FirebaseAuth auth = FirebaseAuth.instance;
// // final gooleSignIn = GoogleSignIn();
// // final fbLogin = FacebookLogin();
//
// // https://codesundar.com/flutter-facebook-login/
//
// Map userProfile;
// final facebookLogin = FacebookLogin();
// LoginByMailBloc _loginByMailBloc=new LoginByMailBloc();
//
//
// loginWithFB() async{
//
//   final result = await facebookLogin.logIn(['email']);
//
//   switch (result.status) {
//     case FacebookLoginStatus.loggedIn:
//       final token = result.accessToken.token;
//       final graphResponse = await http.get('https://graph.facebook.com/v2.12/me?fields=name,picture,email&access_token=${token}');
//       final Map profile = JSON.jsonDecode(graphResponse.body);
//       print(profile);
//       Map body={
//         "email": "${profile['email']}",
//         "password": "${profile['id']}",
//         "name": "${profile['name']}"
//       };
//       print(body);
//       print(profile['name']);
//       print(profile['id']);
//       _loginByMailBloc.loginByMail(body);
//       break;
//
//     case FacebookLoginStatus.cancelledByUser:
//       print("cancelled");
//       break;
//     case FacebookLoginStatus.error:
//       print("error");
//       break;
//   }
//
// }
//
// logout(){
//   facebookLogin.logOut();
// }
//
// // a simple sialog to be visible everytime some error occurs
// showErrDialog(BuildContext context, String err) {
//   // to hide the keyboard, if it is still p
//   FocusScope.of(context).requestFocus(new FocusNode());
//   return showDialog(
//     context: context,
//     child: AlertDialog(
//       title: Text("Error"),
//       content: Text(err),
//       actions: <Widget>[
//         OutlineButton(
//           onPressed: () {
//             Navigator.pop(context);
//           },
//           child: Text("Ok"),
//         ),
//       ],
//     ),
//   );
// }
//
// // many unhandled google error exist
// // will push them soon
// Future<bool> googleSignIn() async {
//   GoogleSignInAccount googleSignInAccount = await gooleSignIn.signIn();
//
//   if (googleSignInAccount != null) {
//     GoogleSignInAuthentication googleSignInAuthentication =
//     await googleSignInAccount.authentication;
//
//     AuthCredential credential = GoogleAuthProvider.credential(
//         idToken: googleSignInAuthentication.idToken,
//         accessToken: googleSignInAuthentication.accessToken);
//
//     // AuthResult result = await auth.signInWithCredential(credential);
//     // FirebaseUser user = await auth.currentUser();
//
//     User user = (await auth.signInWithCredential(credential)).user;
//     print(user.uid);
//     print(user.photoURL);
//     print(user.phoneNumber);
//     print(user.displayName);
//     print(user.metadata);
//     print(user.email);
//     print(user.emailVerified);
//
//     Map body={
//       "email": "${user.email}",
//       "password": "${user.uid}",
//       "name": "${user.displayName}"
//     };
//     print(body);
//     _loginByMailBloc.loginByMail(body);
//
//     return Future.value(true);
//   }
// }
//
//
// // Future<bool> signOutUser() async {
// //   User user = await auth.currentUser;
// //   print(user.providerData[0].providerId);
// //   if (user.providerData[0].providerId == 'google.com') {
// //     await gooleSignIn.disconnect();
// //   }else if (user.providerData[0].providerId == 'facebook.com') {
// //     /// https://stackoverflow.com/questions/55958516/cannot-sign-out-from-facebook-using-flutter-with-firebase
// //     // await fbLogin.logOut();
// //   }
// //   await auth.signOut();
// //   return Future.value(true);
// // }
//
//
// /// https://medium.com/flutter-community/flutter-facebook-login-77fcd187242
//
// /*void initiateFacebookLogin() async {
//   var facebookLogin = FacebookLogin();
//   var facebookLoginResult =
//   await facebookLogin.logIn(['email','public profile']);
//   switch (facebookLoginResult.status) {
//     case FacebookLoginStatus.error:
//       print("Error");
//       break;
//     case FacebookLoginStatus.cancelledByUser:
//       print("CancelledByUser");
//       break;
//     case FacebookLoginStatus.loggedIn:
//       print("LoggedIn");
//
//       var graphResponse = await http.get(
//           'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email,picture&access_token=${facebookLoginResult
//               .accessToken.token}');
//
//       var profile = json.decode(graphResponse.body);
//       print(profile.toString());
//       break;
//   }
// }*/
//
//
//
// // Future signInFB() async {
// //
// //   fbLogin.logIn(['email','public profile']).then((result) {
// //     switch(result.status){
// //       case FacebookLoginStatus.loggedIn:
// //         FirebaseAuth.instance.signinwith
// //   }
// //   });
// //
// //   final FacebookLoginResult result = await fbLogin.logIn(["email"]);
// //   final String token = result.accessToken.token;
// //   final response = await       http.get('https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=${token}');
// //   final profile = jsonDecode(response.body);
// //   print(profile);
// //   return profile;
// // }
//
//
//
// // instead of returning true or false
// // returning user to directly access UserID
// /*Future<FirebaseUser> signin(
//     String email, String password, BuildContext context) async {
//   try {
//     AuthResult result =
//     await auth.signInWithEmailAndPassword(email: email, password: email);
//     FirebaseUser user = result.user;
//     // return Future.value(true);
//     return Future.value(user);
//   } catch (e) {
//     // simply passing error code as a message
//     print(e.code);
//     switch (e.code) {
//       case 'ERROR_INVALID_EMAIL':
//         showErrDialog(context, e.code);
//         break;
//       case 'ERROR_WRONG_PASSWORD':
//         showErrDialog(context, e.code);
//         break;
//       case 'ERROR_USER_NOT_FOUND':
//         showErrDialog(context, e.code);
//         break;
//       case 'ERROR_USER_DISABLED':
//         showErrDialog(context, e.code);
//         break;
//       case 'ERROR_TOO_MANY_REQUESTS':
//         showErrDialog(context, e.code);
//         break;
//       case 'ERROR_OPERATION_NOT_ALLOWED':
//         showErrDialog(context, e.code);
//         break;
//     }
//     // since we are not actually continuing after displaying errors
//     // the false value will not be returned
//     // hence we don't have to check the valur returned in from the signin function
//     // whenever we call it anywhere
//     return Future.value(null);
//   }
// }*/
//
// // change to Future<FirebaseUser> for returning a user
// /*Future<FirebaseUser> signUp(
//     String email, String password, BuildContext context) async {
//   try {
//     AuthResult result = await auth.createUserWithEmailAndPassword(
//         email: email, password: email);
//     FirebaseUser user = result.user;
//     return Future.value(user);
//     // return Future.value(true);
//   } catch (error) {
//     switch (error.code) {
//       case 'ERROR_EMAIL_ALREADY_IN_USE':
//         showErrDialog(context, "Email Already Exists");
//         break;
//       case 'ERROR_INVALID_EMAIL':
//         showErrDialog(context, "Invalid Email Address");
//         break;
//       case 'ERROR_WEAK_PASSWORD':
//         showErrDialog(context, "Please Choose a stronger password");
//         break;
//     }
//     return Future.value(null);
//   }
// }*/
//
