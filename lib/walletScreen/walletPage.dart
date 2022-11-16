import 'package:delivery_on_time/constants.dart';
import 'package:delivery_on_time/walletScreen/model/walletBalanceModel.dart';
import 'package:delivery_on_time/walletScreen/repository/walletRepository.dart';
import 'package:delivery_on_time/walletScreen/walletMoneyAddPage.dart';
import 'package:delivery_on_time/walletScreen/walletTransactionPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_shimmer/flutter_shimmer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';


class WalletPage extends StatefulWidget {
//    9DAAFCI7202LIZD
//    AAFCI7202L
  @override
  _WalletPageState createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {


  WalletRepository _walletRepository;
  Future<WalletBalanceModel> _futureWalletBalance;

  SharedPreferences prefs;
  String userId="";
  String userToken="";


  Future<void> createSharedPref() async {
    prefs = await SharedPreferences.getInstance();
    userId=prefs.getString("user_id");
    userToken=prefs.getString("user_token");
    Map _body={
      "user_id":"$userId"
    };
    _futureWalletBalance=_walletRepository.walletBalance(_body,userToken);
    setState(() {

    });
  }

  @override
  void initState() {
    super.initState();
    _walletRepository=new WalletRepository();
    createSharedPref();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          backgroundColor: darkerThemeBlue,
          appBar: AppBar(
            backgroundColor: lightThemeBlue,
            title: Text(
              "WALLET",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                color: Colors.white,
                fontSize: 15
              ),
            ),
            centerTitle: true,
          ),
          body: Column(
            children: [
              FutureBuilder<WalletBalanceModel>(
                future: _futureWalletBalance,
                builder: (context, snapshot){

                  if(snapshot.hasData){
                    return Container(
                      height: 170,
                      child: Stack(
                        //overflow: Overflow.visible,
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            height: 150,
                            width: screenWidth,
                            color: darkThemeBlue,
                            padding: const EdgeInsets.fromLTRB(20.0,0.0,16.0,8.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 25,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${snapshot.data.data.ewalletBalance}",
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w500,
                                          color: orangeCol,
                                          fontSize: 38
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(5.0,12.0,2.0,0.0),
                                      child: Text(
                                        "Rupees",
                                        style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w600,
                                            color: orangeCol,
                                            fontSize: 12
                                        ),
                                      ),
                                    ),
                                    Spacer(),
                                    InkWell(
                                      onTap: (){
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => WalletTransactionPage()));
                                      },
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            "Transactions",
                                            style: GoogleFonts.poppins(
                                                fontWeight: FontWeight.w400,
                                                color: textCol,
                                                fontSize: 12
                                            ),),
                                          Icon(
                                            Icons.arrow_right_alt,
                                            size: 40,
                                            color: textCol,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 0,
                                ),
                                Text(
                                  "Current Balance",
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w400,
                                      color: textCol,
                                      fontSize: 12
                                  ),
                                ),

                              ],
                            ),
                          ),
                          Positioned(
                            top: 120,
                            left: screenWidth*0.75,
                            child: InkWell(
                              onTap: (){
                                print("taaapp");
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => WalletMoneyAddPage(walletBalance: snapshot.data.data.ewalletBalance,)));
                              },
                              child: Container(
                                height: 60,
                                width: 60,
                                clipBehavior: Clip.hardEdge,
                                decoration: new BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage("assets/images/icons/plus.png"),
                                  ),
                                  // color: Colors.red[400],
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),


                            // Icon(
                            //   Icons.add_circle,
                            //   color: Colors.red[400],
                            //   size: 70,
                            // )
                          ),
                        ],
                      ),
                    );
                  }else if(snapshot.hasError){
                    print(snapshot.error);
                    return Text("NO data");
                  }else
                    return VideoShimmer(
                      isRectBox: true,
                      padding: EdgeInsets.all(0.0),
                      margin: EdgeInsets.only(top: 15,bottom: 20),
                    );
                },

              ),
              Padding(
                padding: EdgeInsets.fromLTRB(20.0,0.0,20.0,8.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "ACTIVITY",
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                        color: textCol,
                        fontSize: 15
                    ),),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10.0,0.0,10.0,0.0),
                  child: WalletTransactionsList(),
                ),
              )


            ],
          ),
        ));
  }
}
