import 'package:delivery_on_time/address_screens/addressAddPage.dart';
import 'package:delivery_on_time/address_screens/address_page.dart';
import 'package:delivery_on_time/address_screens/model/addressShowAllModel.dart';
import 'package:delivery_on_time/address_screens/repository/addressRepository.dart';
import 'package:delivery_on_time/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_shimmer/flutter_shimmer.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'mapAddressPick.dart';

class AddressListPage extends StatefulWidget {
  @override
  _AddressListPageState createState() => _AddressListPageState();
}

class _AddressListPageState extends State<AddressListPage> {
  // List<Data> data;
  String userToken = "";
  Map body;
  String userId = "";
  Future<AddressShowAllModel> _addressApi;
  double shopLat;
  double shopLong;


  Future<void> createSharedPref() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    print("address page");
    print(prefs.getString("user_token"));
    userId = prefs.getString("user_id");
    userToken = prefs.getString("user_token");
    shopLat = prefs.getDouble("shopLat");
    shopLong = prefs.getDouble("shopLong");
    body = {"userid": "$userId"};
    _addressApi = _addressRepository.addressShowAll(body, userToken);
    setState(() {});
  }

  Map _body;

  @override
  void initState() {
    super.initState();
    createSharedPref();
  }

  /*Map body = {"userid": "26"};
  String token = "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9."
      "eyJhdWQiOiIxIiwianRpIjoiYTJiYzljNWY5Yzgy"
      "NzY1NjI2NDE1Nzc0Y2U4NjVkNmRlNWRmNGNmZGEyYTFhZDh"
      "iN2E0MGFmMWZhMTgzZGM0NjY3ZDA0ZWM1NzcxOTU1ZDkiLCJpY"
      "XQiOjE2MDI5NDk2NDYsIm5iZiI6MTYwMjk0OTY0NiwiZXhwIjoxNj"
      "M0NDg1NjQ2LCJzdWIiOiIyNiIsInNjb3BlcyI6W119.hs1EhLfMfUxM"
      "ACFuLfMP73lPaeDmtvh4xDPpg84jqOJQa7-j9wbrRSLnsXe-FCFsIyyTS"
      "GYJ54lEnCbiLeK3XThpeA-2R7H5jcThHMcCvF8hAg6jr8esAelMyhh10HNvD"
      "dtkZs_Sg6Aa7TtiviQFo6jCQqJPNgsTsr_SRrrcC0WmYE_RnrGb6mBwW4_Lvv8"
      "Ab7F5Yuch6dDLvdEC-_P0jtjdqQZdL7UypSZEN0CqxfG5Z278X-IfpP7_aEOXIZs1"
      "Q1YgKLhvmoZeRefiuAOR3UTp7AReFJOlIwvynOkFPFvzHWKe8mtGekuNV477M7t0q3u"
      "SYwNqmvtZcAib6uSRKXcjGVxEIKh6btCfNvorNrbjjc-QzR6eLx13qdyB99OlUSYs2_xA1"
      "xDM4ARPdzPEeXaxmk1CXZBSaw4jlSVbAc6TloiaGLL_KXxeQmWQIlLgLtdXRM5_DtOcefDTA"
      "hVRHuc7RxFaaqO_N-qjzOadFP80SKdBehap8Bw0NK_xMIy05lSVcU70HGSaiFT4LHbwAlBnK8oK"
      "43D6VcqNDGBopwevi-su0zaeyDaoVkob5bAv4X-3r4pXP7c0d1-AN6DwzNFL4RZAqz2YB7oRn7jmAO"
      "4f1dPqPf7LVK4WBk3OAWpo8_lZBOsplUnFSf4mo-9F4zPFmrRRMmaNGGBaAWZMH98";*/
  AddressRepository _addressRepository = new AddressRepository();
  List val = [10, 20, 30, 40, 50];
  String _addressId="";
  String _address="";
  double addressLat=0.0;
  double addressLong=0.0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: Colors.deepOrange,
          onPressed: () {

            if(_addressId!=""){
              double totalDistance = calculateDistance(
                  shopLat,
                  shopLong,
                  addressLat,
                  addressLong);
              print(totalDistance);
              if(totalDistance<=10.0){
                Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AddressPage(addressId: _addressId,)));
                // print("ei to 6ele thik kore6s");
              }else{
                Fluttertoast.showToast(
                    msg: "Cart items are not deliverable at your selected address",
                    fontSize: 16,
                    backgroundColor: Colors.orange[100],
                    textColor: darkThemeBlue,
                    toastLength: Toast.LENGTH_LONG);
              }
            }
            else{
              Fluttertoast.showToast(
                  msg: "Please Select a Address",
                  fontSize: 16,
                  backgroundColor: Colors.orange[100],
                  textColor: darkThemeBlue,
                  toastLength: Toast.LENGTH_LONG);
            }
          },
          label: Container(
            height: 35.0,
            child: Center(
              child: Text(
                "  Checkout >>>  ",
                style:
                TextStyle(fontSize: screenWidth * 0.04, color: Colors.white),
              ),
            ),
          ),
        ),
        appBar: AppBar(
            backgroundColor: lightThemeBlue,
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
              "Select Address".toUpperCase(),
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: screenWidth * 0.04),
            )),
            actions: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.notifications,
                  color: Colors.white,
                ),
              ),
            ]),
        backgroundColor: darkThemeBlue,
        body: ListView(
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          children: [
            Container(
              height: 60.0,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              padding: EdgeInsets.all(10.0),
              margin: EdgeInsets.fromLTRB(5.0, 15.0, 5.0, 10.0),
              child: InkWell(
                onTap: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MapAddressPick1()));
                },
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Icon(
                        Icons.add,
                        color: lightThemeBlue,
                        size: 25.0,
                      ),
                    ),
                    Expanded(
                        flex: 9,
                        child: Text(
                          " Add New Address",
                          style: TextStyle(
                              color: lightThemeBlue,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ))
                  ],
                ),
              ),
            ),
            FutureBuilder<AddressShowAllModel>(
                future: _addressApi,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    // data=snapshot.data.data;
                    return ListView.builder(
                        physics: ScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: snapshot.data.data.length,
                        itemBuilder: (context, index) {
                          if(snapshot.data.data[index].longitude!=null && snapshot.data.data[index].longitude!=""){
                            return Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                BorderRadius.all(Radius.circular(12)),
                              ),
                              padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 15.0),
                              margin: EdgeInsets.fromLTRB(5.0, 3.0, 5.0, 3.0),
                              // height: 160,
                              child: Column(
                                children: [
                                  // RadioListTile(
                                  //   value: snapshot.data.data[index].id,
                                  //   groupValue: _addressId,
                                  //   onChanged: (value) {
                                  //     setState(() {
                                  //       _addressId = value;
                                  //       // _address="${snapshot.data.data[value].address}, ${snapshot.data.data[value].landmark}, ${snapshot.data.data[value].city}, ${snapshot.data.data[value].state}, ${snapshot.data.data[value].zip}";
                                  //       print(_address);
                                  //     });
                                  //   },
                                  //   title: Padding(
                                  //     padding: const EdgeInsets.fromLTRB(0.0,15.0,0.0,10.0),
                                  //     child: Text(
                                  //       "${snapshot.data.data[index].addressName}",
                                  //       style: TextStyle(
                                  //           color: Colors.lightBlue[900],
                                  //           fontSize: 16.0,
                                  //           fontWeight: FontWeight.w600),
                                  //     ),
                                  //   ),
                                  //   subtitle: Column(
                                  //     crossAxisAlignment: CrossAxisAlignment.start,
                                  //     children: [
                                  //       Text(
                                  //         "${snapshot.data.data[index].address}",
                                  //         style: TextStyle(
                                  //             color: lightThemeBlue,
                                  //             fontSize: 15.0,
                                  //             fontWeight: FontWeight.w400),
                                  //       ),
                                  //       SizedBox(
                                  //         height: 10,
                                  //       ),
                                  //       Text(
                                  //         "${snapshot.data.data[index].landmark}",
                                  //         style: TextStyle(
                                  //             color: lightThemeBlue,
                                  //             fontSize: 15.0,
                                  //             fontWeight: FontWeight.w500),
                                  //       ),
                                  //       Text(
                                  //         "${snapshot.data.data[index].city}, ${snapshot.data.data[index].state} - ${snapshot.data.data[index].zip}",
                                  //         style: TextStyle(
                                  //             color: lightThemeBlue,
                                  //             fontSize: 15.0,
                                  //             fontWeight: FontWeight.w500),
                                  //       ),
                                  //       // Text(
                                  //       //   "${snapshot.data.data[index].state}",
                                  //       //   style: TextStyle(
                                  //       //       color: lightThemeBlue,
                                  //       //       fontSize: 15.0,
                                  //       //       fontWeight: FontWeight.w500),
                                  //       // ),
                                  //       // Text(
                                  //       //   "${snapshot.data.data[index].zip}",
                                  //       //   style: TextStyle(
                                  //       //       color: lightThemeBlue,
                                  //       //       fontSize: 15.0,
                                  //       //       fontWeight: FontWeight.w600),
                                  //       // ),
                                  //
                                  //     ],
                                  //   ),
                                  // ),

                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Radio(
                                          value: snapshot.data.data[index].id,
                                          groupValue: _addressId,
                                          onChanged: (value) {
                                            setState(() {
                                              _addressId = value;
                                              addressLat = double.parse(snapshot.data.data[index].latitude??"$userLat");
                                              addressLong = double.parse(snapshot.data.data[index].longitude??"$userLong");
                                              // _address="${snapshot.data.data[value].address}, ${snapshot.data.data[value].landmark}, ${snapshot.data.data[value].city}, ${snapshot.data.data[value].state}, ${snapshot.data.data[value].zip}";
                                              print(_address);
                                            });
                                          },
                                        ),
                                      ),
                                      Expanded(
                                        flex: 8,
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0.0, 0.0, 8.0, 0.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "${snapshot.data.data[index].addressName}",
                                                style: TextStyle(
                                                    color: Colors.lightBlue[900],
                                                    fontSize: 16.0,
                                                    fontWeight: FontWeight.w600),
                                              ),

                                              /*Text("${snapshot.data.data[index].landmark}"),
                                            Text("${snapshot.data.data[index].city}"),
                                            Text("${snapshot.data.data[index].state}"),
                                            Text("${snapshot.data.data[index].zip}"),*/
                                            ],
                                          ),
                                        ),
                                      ),
                                      // Expanded(
                                      //     flex: 2,
                                      //     child: ButtonTheme(
                                      //       height: 25.0,
                                      //       // minWidth: 10.0,
                                      //       child: FlatButton(
                                      //         shape: RoundedRectangleBorder(
                                      //           side: BorderSide(
                                      //               color: orangeCol,
                                      //               width: 1.3,
                                      //               style: BorderStyle.solid),
                                      //           borderRadius:
                                      //               BorderRadius.circular(12.0),
                                      //         ),
                                      //         color: darkThemeBlue,
                                      //         textColor: Colors.white,
                                      //         child: Text(
                                      //           "Edit",
                                      //           style: TextStyle(
                                      //               color: lightThemeBlue),
                                      //         ),
                                      //       ),
                                      //     ))
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Container(),
                                      ),
                                      Expanded(
                                        flex: 8,
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              2.0, 0.0, 8.0, 5.0),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                            Text(
                                              "${snapshot.data.data[index].address}, ${snapshot.data.data[index].state} - ${snapshot.data.data[index].zip}",
                                              style: TextStyle(
                                                  color: lightThemeBlue,
                                                  fontSize: 15.0,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                                    "${snapshot.data.data[index].landmark}",
                                                    style: TextStyle(
                                                        color: lightThemeBlue,
                                                        fontSize: 15.0,
                                                        fontWeight: FontWeight.w400),
                                                  ),

                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );

                          }else
                            return Container();

                        });
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
                            margin: EdgeInsets.only(top: 30,bottom: 30),
                            height: 30,
                            isDisabledAvatar: false,
                            isRectBox: true,
                            colors: [
                              Colors.white
                            ],
                          );
                        }
                    );
                }),
          ],
        ),
      ),
    );
  }
}
