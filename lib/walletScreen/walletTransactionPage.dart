import 'package:delivery_on_time/constants.dart';
import 'package:delivery_on_time/walletScreen/model/walletTransactionModel.dart';
import 'package:delivery_on_time/walletScreen/repository/walletRepository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_shimmer/flutter_shimmer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class WalletTransactionPage extends StatefulWidget {
  @override
  _WalletTransactionPageState createState() => _WalletTransactionPageState();
}

class _WalletTransactionPageState extends State<WalletTransactionPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: darkThemeBlue,
        appBar: AppBar(
          backgroundColor: lightThemeBlue,
          title: Text(
            "WALLET TRANSACTIONS",
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: Colors.white, fontSize: 15),
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 10,
              ),
              Text(
                "  Transaction History",
                style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: Colors.white, fontSize: 16),
              ),
              SizedBox(
                height: 10,
              ),
              Expanded(child: WalletTransactionsList()),
            ],
          ),
        ),
      ),
    );
  }
}

class WalletTransactionsList extends StatefulWidget {
  @override
  _WalletTransactionsListState createState() => _WalletTransactionsListState();
}

class _WalletTransactionsListState extends State<WalletTransactionsList> {
  WalletRepository _walletRepository;
  Future<WalletTransactionModel> _futureWalletTransactions;

  SharedPreferences prefs;
  String userId = "";
  String userToken = "";
  Color statusCol = textCol;

  Future<void> createSharedPref() async {
    prefs = await SharedPreferences.getInstance();
    userId = prefs.getString("user_id");
    userToken = prefs.getString("user_token");
    Map _body = {"user_id": "$userId"};
    _futureWalletTransactions = _walletRepository.walletTransactionsData(_body, userToken);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _walletRepository = new WalletRepository();
    createSharedPref();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<WalletTransactionModel>(
      future: _futureWalletTransactions,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.message=="No record exist") {
            return Center(child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Text("You don't have any wallet transactions yet",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(fontWeight: FontWeight.w500, color: Colors.white, fontSize: 16),),
            ));
          } else {
            return ListView.builder(
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                itemCount: snapshot.data.data.length,
                itemBuilder: (context, index) {
                  // if (snapshot.data.data[index].transactionStatus == "Success") {
                  //   statusCol = Colors.green;
                  // } else {
                  //   statusCol = Colors.red;
                  // }

                  return Container(
                    padding: EdgeInsets.fromLTRB(8.0,8.0,8.0,12.0),
                    margin: EdgeInsets.fromLTRB(0.0,8.0,0.0,8.0),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(width: 0.2, color: Colors.green[200]),
                      ),),
                    width: screenWidth,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              height: 32,
                              width: 32,
                              clipBehavior: Clip.hardEdge,
                              decoration: new BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage((snapshot.data.data[index].transactionType=="Credit")?"assets/images/icons/transaction_icon/add.png":"assets/images/icons/transaction_icon/paid.png"),
                                ),
                                // color: Colors.red[400],
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 4,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                (snapshot.data.data[index].transactionFrom=="Order")?"Order Payment #${snapshot.data.data[index].orderId??"000"}":(snapshot.data.data[index].transactionFrom=="Pickup")?"Pickup & Drop Payment #${snapshot.data.data[index].orderId??"000"}":"Wallet Reload",
                                style: GoogleFonts.poppins(fontWeight: FontWeight.w500, color: Colors.white, fontSize: 14),
                              ),
                              Text(
                                "${DateFormat.yMMMMd().format(DateFormat("yyyy-MM-dd").parse(snapshot.data.data[index].createdAt, true))}",
                                style: GoogleFonts.poppins(fontWeight: FontWeight.w400, color: textCol, fontSize: 11),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              (snapshot.data.data[index].transactionType == "Credit")?
                              Text(
                                "+ Rs.${snapshot.data.data[index].transactionAmount}",
                                style: GoogleFonts.poppins(fontWeight: FontWeight.w500, color: Colors.green, fontSize: 14),
                              ):
                              Text(
                                "- Rs.${snapshot.data.data[index].transactionAmount}",
                                style: GoogleFonts.poppins(fontWeight: FontWeight.w500, color: Colors.red[700], fontSize: 14),
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "${snapshot.data.data[index].transactionStatus??" "} ",
                                    style: GoogleFonts.poppins(fontWeight: FontWeight.w400, color: Colors.white, fontSize: 13),
                                  ),
                                  (snapshot.data.data[index].transactionStatus=="Failed")?
                                  Icon(Icons.error,
                                    color: Colors.red,
                                    size: 14,)
                                      :
                                  Icon(Icons.check_circle,
                                    color: Colors.green,
                                    size: 14,),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                });

          }
        } else if (snapshot.hasError) {
          print(snapshot.error);
          return Text("No Data");
        } else
          return ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: 10,
              itemBuilder: (context, index){
                return ListTileShimmer(
                  padding: EdgeInsets.all(0.0),
                  margin: EdgeInsets.only(top: 20,bottom: 20),
                  colors: [
                    Colors.white
                  ],
                );
              }
          );
      },
    );
  }
}
