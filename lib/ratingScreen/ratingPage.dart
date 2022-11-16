import 'package:delivery_on_time/constants.dart';
import 'package:delivery_on_time/help/api_response.dart';
import 'package:delivery_on_time/ratingScreen/bloc/ratingBloc.dart';
import 'package:delivery_on_time/ratingScreen/model/ratingModel.dart';
import 'package:delivery_on_time/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RatingPage extends StatefulWidget {

  final String vendorId;
  final String courierId;
  final String productSkuId;


  const RatingPage({Key key, this.vendorId, this.courierId, this.productSkuId}) : super(key: key);
  @override
  _RatingPageState createState() => _RatingPageState(this.vendorId, this.courierId, this.productSkuId);
}

class _RatingPageState extends State<RatingPage> {

  final String vendorId;
  final String courierId;
  final String productSkuId;

  _RatingPageState(this.vendorId, this.courierId, this.productSkuId);

  double _vendorRating=0;
  double _deliveryBoyRating=0;
  double _productRating=0;

  SharedPreferences prefs;
  RatingBloc _ratingBloc;
  String userToken;
  String userId;



  Future<void> createSharedPref() async {
    prefs = await SharedPreferences.getInstance();
    userId=prefs.getString("user_id");
    userToken=prefs.getString("user_token");
    // DeviceID="";
  }

  navToAttachList(context) async {
    Future.delayed(Duration.zero, () {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) {
        return HomePage();
      }));
    });
  }


  @override
  void initState() {
    super.initState();
    _ratingBloc=new RatingBloc();
    createSharedPref();
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // appBar: AppBar(
        //   automaticallyImplyLeading: false,
        //   title: Text("Rating"),
        //   centerTitle: true,
        //   backgroundColor: lightThemeBlue,
        // ),
        backgroundColor: darkThemeBlue,
        body: Padding(
          padding: const EdgeInsets.fromLTRB(20.0,0.0,20.0,0.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 10,
                ),

                Align(
                  alignment: Alignment.topRight,
                  child: InkWell(
                    onTap: (){
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10,bottom: 10),
                      child: Text("Skip >>",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13,
                          color: orangeCol,
                          fontWeight: FontWeight.w400
                        ),),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),

                Text("Your opinion matters to us!",
                  style: GoogleFonts.poppins(
                      fontSize: 22,
                      color: textCol,
                      fontWeight: FontWeight.w300
                  )

                  /*TextStyle(
                    fontSize: 22,
                    color: textCol,
                    letterSpacing: 0.7,
                    fontWeight: FontWeight.w400
                  ),*/),
                Padding(
                  padding: const EdgeInsets.fromLTRB(25.0,35.0,25.0,20.0),
                  child: Text("We are always trying to improve what we do  and your feedback is invaluable!",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      letterSpacing: 0.5,
                      color: textCol,
                    ),),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20.0,30.0,8.0,20.0),
                  child: Text("How Would You Rate Our App Experience?",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      color: textCol,
                    ),),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20.0,10.0,8.0,20.0),
                  child: Text("Food",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      color: Colors.white,
                    ),),
                ),

                _ratingBar(2,"product"),
                SizedBox(
                  height: 20.0,
                ),

                // _productRating != null
                //     ? RichText(    // To Make Different Text Color in single line
                //   text: TextSpan(
                //       text: "Food Rating : ",
                //       style: TextStyle(
                //           color: textCol,
                //           fontSize: 16,
                //           fontWeight: FontWeight.w600
                //       ),
                //       children: [
                //         TextSpan(
                //           text: "$_productRating",
                //           style: TextStyle(
                //               color: orangeCol,
                //               fontSize: 17,
                //               fontWeight: FontWeight.w400
                //           ),
                //         ),
                //       ]
                //   ),
                // )
                //     : Container(),

                Padding(
                  padding: const EdgeInsets.fromLTRB(20.0,20.0,8.0,20.0),
                  child: Text("Restaurant",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      color: Colors.white,
                    ),),
                ),

                _ratingBar(2,"vendor"),
                SizedBox(
                  height: 20.0,
                ),
                // _productRating != null
                //     ? RichText(    // To Make Different Text Color in single line
                //   text: TextSpan(
                //       text: "Food Rating : ",
                //       style: TextStyle(
                //           color: textCol,
                //           fontSize: 16,
                //           fontWeight: FontWeight.w600
                //       ),
                //       children: [
                //         TextSpan(
                //           text: "$_productRating",
                //           style: TextStyle(
                //               color: orangeCol,
                //               fontSize: 17,
                //               fontWeight: FontWeight.w400
                //           ),
                //         ),
                //       ]
                //   ),
                // )
                //     : Container(),

                Padding(
                  padding: const EdgeInsets.fromLTRB(20.0,20.0,8.0,20.0),
                  child: Text("Delivery partner",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      color: Colors.white,
                    ),),
                ),

                _ratingBar(1,"deliveryboy"),
                SizedBox(
                  height: 20.0,
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 5, 15, 15),
                  child: ButtonTheme(   /*__To Enlarge Button Size__*/
                    height: 50.0,
                    minWidth: screenWidth,
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      onPressed: () {

                        if(_vendorRating>0 && _productRating>0 && _deliveryBoyRating>0){
                          Map body={
                            "rating_given_by":"$userId",
                            "feedback": [
                              {
                                "rating":"$_vendorRating",
                                "feedback_type":"vendor",
                                "feedback_type_id":"$vendorId",
                                "feedback_message": "Restaurant was really nice"
                              },
                              {
                                "rating":"$_deliveryBoyRating",
                                "feedback_type":"deliveryboy",
                                "feedback_type_id":"$courierId",
                                "feedback_message": "He is professional"
                              },
                              {
                                "rating":"$_productRating",
                                "feedback_type":"product",
                                "feedback_type_id":"$productSkuId",
                                "feedback_message": "Food was really nice"
                              }
                            ]
                          };

                          _ratingBloc.rating(body, userToken);

                        }else{
                          Fluttertoast.showToast(
                              msg: "Please give all Rating",
                              fontSize: 16,
                              backgroundColor: Colors.orange[100],
                              textColor: darkThemeBlue,
                              toastLength: Toast.LENGTH_LONG);
                        }

                      },
                      color: orangeCol,
                      textColor: Colors.white,
                      child: StreamBuilder<ApiResponse<RatingModel>>(
                        stream: _ratingBloc.ratingStream,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            switch (snapshot.data.status) {
                              case Status.LOADING:
                                return CircularProgressIndicator(
                                    backgroundColor: circularBGCol,
                                    strokeWidth: strokeWidth,
                                    valueColor: AlwaysStoppedAnimation<Color>(circularStrokeCol)
                                );
                                /*Loading(
                              loadingMessage: snapshot.data.message,
                            );*/
                                break;
                              case Status.COMPLETED:
                                navToAttachList(context);
                                Fluttertoast.showToast(
                                    msg: "Thanks for your Feedback",
                                    fontSize: 16,
                                    backgroundColor: Colors.orange[100],
                                    textColor: darkThemeBlue,
                                    toastLength: Toast.LENGTH_LONG);
                                break;
                              case Status.ERROR:
                                Fluttertoast.showToast(
                                    msg: "Please give Rating Again",
                                    fontSize: 16,
                                    backgroundColor: Colors.orange[100],
                                    textColor: darkThemeBlue,
                                    toastLength: Toast.LENGTH_LONG);
                                //   Error(
                                //   errorMessage: snapshot.data.message,
                                // );
                                break;
                            }
                          } else if (snapshot.hasError) {
                            print(snapshot.error);
                          }

                          return Text("Submit",
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold
                              ));
                        },
                      ),

                    ),
                  ),
                ),


              ],
            ),
          ),
        ),
      ),
    );
  }

  //rating widget

  Widget _ratingBar(int mode, String type) {
    switch (mode) {
      case 1:
        return RatingBar.builder(
          glowColor: Colors.orange,
          initialRating: 0,
          minRating: 0,
          allowHalfRating: true,
          unratedColor: lightThemeBlue,
          itemCount: 5,
          itemSize: 40.0,
          itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
          itemBuilder: (context, _) => Icon(
            Icons.star_rate_rounded,
            color: Colors.amber[600],
          ),
          onRatingUpdate: (rating) {
            setState(() {
              if(type=="vendor")
                _vendorRating=rating;
              else if(type=="deliveryboy")
                _deliveryBoyRating=rating;
              else if(type=="product")
                _productRating=rating;
            });
          },
          updateOnDrag: true,
        );
      // case 2:
      //   return RatingBar(
      //     initialRating: 3,
      //     allowHalfRating: true,
      //     itemCount: 5,
      //     ratingWidget: RatingWidget(
      //       full: _image('assets/heart.png'),
      //       half: _image('assets/heart_half.png'),
      //       empty: _image('assets/heart_border.png'),
      //     ),
      //     itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
      //     onRatingUpdate: (rating) {
      //       setState(() {
      //         _rating = rating;
      //       });
      //     },
      //     updateOnDrag: true,
      //   );
      case 2:
        return RatingBar.builder(
          initialRating: 0,
          itemCount: 5,
          glowColor: Colors.orange,
          minRating: 0,
          allowHalfRating: true,
          unratedColor: lightThemeBlue,
          itemSize: 35.0,
          itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
          itemBuilder: (context, index) {
            switch (index) {
              case 0:
                return Icon(
                  Icons.sentiment_very_dissatisfied,
                  color: Colors.red[900],
                );
              case 1:
                return Icon(
                  Icons.sentiment_dissatisfied,
                  color: Colors.red,
                );
              case 2:
                return Icon(
                  Icons.sentiment_neutral,
                  color: Colors.amber,
                );
              case 3:
                return Icon(
                  Icons.sentiment_satisfied,
                  color: Colors.lightGreen,
                );
              case 4:
                return Icon(
                  Icons.sentiment_very_satisfied,
                  color: Colors.green[600],
                );
              default:
                return Container();
            }
          },
          onRatingUpdate: (rating) {
            setState(() {
              if(type=="vendor")
                _vendorRating=rating;
              else if(type=="deliveryboy")
                _deliveryBoyRating=rating;
              else if(type=="product")
                _productRating=rating;
            });
          },
          updateOnDrag: true,
        );
      default:
        return Container();
    }
  }

}
