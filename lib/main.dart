import 'dart:io';

//import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:delivery_on_time/constants.dart';
import 'package:delivery_on_time/pickupDropPage/pickDropConfirmPage.dart';
import 'package:delivery_on_time/rideService/rideTrackingPage.dart';
import 'package:delivery_on_time/screens/home.dart';
import 'package:delivery_on_time/screens/homeStartingPage.dart';
import 'package:delivery_on_time/screens/home_controller.dart';
import 'package:delivery_on_time/screens/orderConfirmPage.dart';
import 'package:delivery_on_time/screens/splash_screen.dart';
import 'package:delivery_on_time/walletScreen/walletMoneyAddConfirmPage.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'loginMobile_screen/loginByMobile.dart';
import 'package:path_provider/path_provider.dart';

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  // // ignore: invalid_use_of_visible_for_testing_member
  // SharedPreferences.setMockInitialValues({});
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // Directory directory = await getApplicationDocumentsDirectory();
  // Hive.init(directory.path);
  // await handleBox();

  AwesomeNotifications().initialize(
      'resource://mipmap/launcher_icon',
      [
        NotificationChannel(
          channelKey: 'key2',
          channelName: 'High Importance Notifications New',
          channelDescription: "This channel is used for important notifications",
          // defaultColor: Color.alphaBlend(Colors.redAccent,Colors.redAccent),
          ledColor: Colors.white,
          //icon: 'resource://drawable/launcher_icon.png',
          playSound: false,
          enableLights:true,
          enableVibration: true,
          //defaultRingtoneType: DefaultRingtoneType.Notification,
          // importance: NotificationImportance.Max,
          //locked: true
        )
      ]
  );

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  Set keys = prefs.getKeys();

  // print("heelooo heelloo");

  // rideid = prefs.getInt('rideid');

  if (keys.contains("user_token")) {
    print("user_token exist" + prefs.getString("user_token"));
    if (prefs.getString("user_token") != "" && prefs.getString("user_token") != null) {
      // userLogin=prefs.getBool("user_login");
      print("login a6e");
      userLogin = true;
    }else{
      userLogin=false;
      print("login nei");

    }
  } else{
    prefs.setString("user_token", "");
    print("login nei nei");
    userLogin=false;
  }

  if (keys.contains("user_id")) {
    // print("user_id exist"+prefs.getString("user_id"));
  } else
    prefs.setString("user_id", "");

  if (keys.contains("cart_id")) {
    print("cart_id exist" + prefs.getString("cart_id"));
  } else {
    prefs.setString("cart_id", "");
    print("cart id create ${prefs.getString("cart_id")}");
  }

  runApp(MaterialApp(
      initialRoute: '/',
      routes: {
        '/login': (context) =>LoginByMobilePage(),
        '/home': (context) => HomePage(),
        '/homeController': (context) => HomeController(),
        // '/orderDetails': (context) => OrderDetailsPage(),
        '/orderConfirm' : (context) => OrderConfirmPage(),
        '/walletAddConfirm' : (context) => WalletMoneyAddConfirmPage(),
      },
      debugShowCheckedModeBanner: false,
      checkerboardOffscreenLayers: true,
      home: MyApp()));
}



// Future<void> handleBox() async{
//   final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
//   _firebaseMessaging.configure(
//     onMessage: (Map<String, dynamic> message) async {
//       print("onMessage: $message");
//
//       // await AwesomeNotifications().createNotification(
//       //     content: NotificationContent(
//       //       id: 1,
//       //       channelKey: 'key1',
//       //       title:'New order received',
//       //       body: 'New order received pls check the app.',
//       //       //icon: 'https://deliveryontime.me/images/logo-text.png',
//       //     )
//       // );
//
//     },
//     onBackgroundMessage: myBackgroundMessageHandler,
//     onLaunch: (Map<String, dynamic> message) async {
//       print("onLaunch: $message");
//     },
//     onResume: (Map<String, dynamic> message) async {
//       print("onResume: $message");
//     },
//   );
//   Box box = await Hive.openBox("fcm");
//   print("fcm........");
//   print(box.get("fcm"));
// }
//
// Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) async {
//   print("BG MESSAGE");
//   Directory directory = await getApplicationDocumentsDirectory();
//   Hive.init(directory.path);
//   Box box = await Hive.openBox("fcm");
//   box.put("fcm", "from Hive ${message.toString()}");
//   print("hello world");
//   if (message.containsKey('data')) {
//     // Handle data message
//     final dynamic data = message['data'];
//   }
//
//   if (message.containsKey('notification')) {
//     // Handle notification message
//     final dynamic notification = message['notification'];
//   }
// }


int n = 2;
int rideid = rideId;
Future<dynamic> myBackgroundHandler(Map<String, dynamic> message) async{

  print('BG MESSAGE RECEIVED' );
  if(message['data']['title'] =='Sound') {
    //FlutterRingtonePlayer.playNotification();
  }

  SharedPreferences prefs = await SharedPreferences.getInstance();

  int rideid2 = prefs.getInt('rideid');


  //return _MyAppState()._showNotification(message);
  print(message);
  print(message['data']['trip_id']);
  print(rideId);

  int nx = int.parse(message['data']['trip_id']);
  print(rideid2);
  print(rideid);
  print(nx);
  var type=message['data']['type'];
  if(type=="driver_accept_trip"){
    if(nx==rideid2)
    {

      n = n+1;
      print(n)
      ;

      await AwesomeNotifications().createNotification(
          content: NotificationContent(
            id: n,
            channelKey: 'key2',
            title: ' ${message['data']['carrier_name']}',

            body: 'Driver is offering ₹${message['data']['offer_price']} for your ride',

            payload: {"trip_id": message['data']['trip_id'],
              "offer_price": message['data']['offer_price'],
            },


          ),
          actionButtons: [

            NotificationActionButton(
              label: 'Accept',
              enabled: true,
              buttonType: ActionButtonType.Default,
              key: 'Accept',
            ),


            NotificationActionButton(
              label: 'Decline',
              enabled: true,
              buttonType: ActionButtonType.Default,
              key: 'Decline',
            ),




          ]


      );

    }

    /*if(message['data']['title'] != null) {
  }
  else{
    await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: 1,
          channelKey: 'key1',
          title: ' ${message['notification']['title']}',

          body: '${message['notification']['body']}',
          customSound: "string",

        )
    );
  }*/
  }
  else if(type=="driver_assigned_trip"){
    if(nx==rideid2){
      n = n+1;
      await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: n,
          channelKey: 'key2',
          title: ' ${message['data']['carrier_name']}',

          body: '${message['data']['title']}',

          payload: {"trip_id": message['data']['trip_id'],
            "offer_price": message['data']['offer_price'],
          },


        ),
      );
      AwesomeNotifications().actionStream.listen((event) {
        MaterialPageRoute(builder: (BuildContext context) => RideTrackingPage(rideId: nx,userToken: prefs.getString("user_token")));
      });
    }

  }
  else{

  }










}





class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp>{
  String _message = '';

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  //bool diwalipromotion = false;


  _register() async {
    //_firebaseMessaging.getToken().then((token) => print(token));
    var tokenFirebase = "";
    _firebaseMessaging.getToken().then((token) async {
      tokenFirebase = token;
      print('this is the token:');
      print(token);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("device_id", tokenFirebase);
      print("sf");
      String device_id = prefs.getString("device_id");
      print(device_id);


      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) {
      //   return (userLogin==true)?HomeStartingPage():SplashScreenPage();
      // }));
    });
  }


  Future _showNotification(Map<String, dynamic> message) async {
    //print('BG MESSAGE RECEIVED' );
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
      'channel id',
      'channel name',
      'channel desc',
      importance: Importance.max,
      priority: Priority.high,
    );

    var platformChannelSpecifics =
    new NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      ' ${message['notification']['title']}',
      '${message['notification']['body']}',

      platformChannelSpecifics,
      payload: 'Default_Sound',
      // payload: '${message['notification']['image']}',
    );
  }

  Future selectNotification(String payload) async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _firebaseMessaging.requestNotificationPermissions();
    _register();



    var initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/launcher_icon');

    /*
    var initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: selectNotification);


     */


    _firebaseMessaging.configure(
      onBackgroundMessage: myBackgroundHandler,
      onMessage: (Map<String, dynamic> message) async {
        //print("onMessage: $message");
        print('message received');

        print(message);
        // showDialog(
        //     context: context,
        //     builder: (context) {
        //       return AlertDialog(
        //         title: Text('new message arived'),
        //         content: Text(
        //             'i want ${message['notification']['title']} for ${message['notification']['body']}'),
        //         actions: <Widget>[
        //           FlatButton(
        //             child: Text('Ok'),
        //             onPressed: () {
        //               Navigator.of(context).pop();
        //             },
        //           ),
        //         ],
        //       );
        //     });

        if(message['notification']['title'] != null) {

          //  FlutterRingtonePlayer.playNotification();

          //
          // if (message['notification']['title'] == 'Happy Diwali') {
          //
          //   //_showNotification(message);
          //   // setState(() {
          //   //   diwalipromotion =  true;
          //   // });
          //
          //   await AwesomeNotifications().createNotification(
          //       content: NotificationContent(
          //         id: 1,
          //         channelKey: 'key1',
          //         title: ' ${message['notification']['title']}',
          //
          //         body: '${message['notification']['body']}',
          //
          //         bigPicture: 'https://staging.deliveryontime.me/images/processed.png',
          //         //icon: 'https://deliveryontime.me/images/logo-text.png',
          //         notificationLayout: NotificationLayout.BigPicture,
          //       )
          //   );
          // }

          if(message['data']['image'] != null)
          {
            print('A');

            await AwesomeNotifications().createNotification(
                content: NotificationContent(
                  id: 12,
                  channelKey: 'key2',
                  title: ' ${message['notification']['title']}',

                  body: '${message['notification']['body']}',

                  bigPicture: '${message['data']['image']}',
                  //icon: 'https://deliveryontime.me/images/logo-text.png',
                  notificationLayout: NotificationLayout.BigPicture,
                )

            );

          }

          else{
            print('B');
            print(message);
            await AwesomeNotifications().createNotification(
                content: NotificationContent(
                  id: 12,
                  channelKey: 'key2',
                  title: ' ${message['notification']['title']}',

                  body: '${message['notification']['body']}',


                )
            );
          }

        }
        else{

        }


      },
    );

    // getMessage();

  }

  // void getMessage() {
  //   _firebaseMessaging.configure(onMessage: (Map<String, dynamic> message) async {
  //     print('on message $message');
  //     setState(() => _message = message["notification"]["title"]);
  //   }, onResume: (Map<String, dynamic> message) async {
  //     print('on resume $message');
  //     setState(() => _message = message["notification"]["title"]);
  //   }, onLaunch: (Map<String, dynamic> message) async {
  //     print('on launch $message');
  //     setState(() => _message = message["notification"]["title"]);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    /*return MaterialApp(
      home: IntroScreen(),
      debugShowCheckedModeBanner: false,
    );*/
    // return (userLogin == true) ? HomePage() : SplashScreenPage();
    return (userLogin==true)?HomeStartingPage():SplashScreenPage();
    // return Container(
    //   color: darkThemeBlue,
    // );
  }
}

/*class StartPage extends StatefulWidget {
  @override
  StartPageState createState() => StartPageState();
}

class _StartPageState extends State<StartPage> {

  Future<void> createSharedPref() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    Set keys = prefs.getKeys();

    print("heelooo heelloo");

    if (keys.contains("user_login")) {
      print("user_login exist ${prefs.getBool("user_login")}");
    } else
      prefs.setBool("user_login", false);

    if (keys.contains("user_token")) {
      print("user_token exist"+prefs.getString("user_token"));
      if (prefs.getString("user_token") != "")
      {
        prefs.setBool("user_login", true);
        userLogin=true;
      }
    } else
      prefs.setString("user_token", "");

    if (keys.contains("user_id")) {
      print("user_id exist"+prefs.getString("user_id"));
    } else
      prefs.setString("user_id", "");

    if (keys.contains("cart_id")) {
      print("cart_id exist"+prefs.getString("cart_id"));
    } else
      prefs.setString("cart_id", "");

    if (keys.contains("token")) {
      print("token exist"+prefs.getString("token"));
    } else
      prefs.setString("token", "");

    if (keys.contains("name"+prefs.getString("name"))) {
      print("name exist");
    } else
      prefs.setString("name", "");
  }

  @override
  void initState() {
    super.initState();
    print("1st page init state");
    createSharedPref();

  }

  @override
  Widget build(BuildContext context) {


    return MaterialApp(
      debugShowCheckedModeBanner: false,
      checkerboardOffscreenLayers: true,
      home: SplashScreenPage(),
    );
  }
}*/

/*class StartPage extends StatelessWidget {
  SharedPreferences prefs;
  bool userCheck = false;

  Future<void> createSharedPref() async {
    prefs = await SharedPreferences.getInstance();
    Set keys = prefs.getKeys();
    if (keys.contains("user_id")) {
      print("user_id exist");
    } else
      prefs.setString("user_id", "");

    if (keys.contains("cart_id")) {
      print("cart_id exist");
    } else
      prefs.setString("cart_id", "");

    if (keys.contains("token")) {
      print("token exist");
    } else
      prefs.setString("token", "");

    if (keys.contains("name")) {
      print("name exist");
    } else
      prefs.setString("name", "");

    if (keys.contains("user_token")) {
      print("user_token exist");
      if (prefs.getString("user_token") != "") userCheck = true;
    } else
      prefs.setString("user_token", "");
  }

  @override
  Widget build(BuildContext context) {
    createSharedPref();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      checkerboardOffscreenLayers: true,
      home: userCheck ? HomePage() : Login(),
    );
  }
}*/

/*List keyList = ["user_id", "cart_id", "token", "name", "user_token"];
    for (int i = 0; i < keyList.length; i++) {
      if (keys.contains(keyList[i])) {
        print(
            "${keyList[i]} exist with value : ${prefs.getString("${keyList[i]}")} ");
      } else
        prefs.setString("${keyList[i]}", "");
    }

    if (prefs.getString("user_token") != ""){
      userCheck = true;
    }*/

/*if (keys.contains("user_login")) {
      print("user_login exist ${prefs.getBool("user_login")}");
      // userLogin=true;
    } else
      prefs.setBool("user_login", false);

    if (keys.contains("user_id")) {
      print("user_id exist"+prefs.getString("user_id"));
    } else
      prefs.setString("user_id", "");

    if (keys.contains("cart_id")) {
      print("cart_id exist"+prefs.getString("cart_id"));
    } else
      prefs.setString("cart_id", "");

    if (keys.contains("token")) {
      print("token exist"+prefs.getString("token"));
    } else
      prefs.setString("token", "");

    if (keys.contains("name"+prefs.getString("name"))) {
      print("name exist");
    } else
      prefs.setString("name", "");*/