import 'package:delivery_on_time/help/api_base_helper.dart';
import 'package:delivery_on_time/walletScreen/model/walletAddMoneyModel.dart';
import 'package:delivery_on_time/walletScreen/model/walletBalanceModel.dart';
import 'package:delivery_on_time/walletScreen/model/walletTransactionModel.dart';

class WalletRepository{

  ApiBaseHelper _apiBaseHelper=new ApiBaseHelper();

  Future<WalletBalanceModel> walletBalance(Map _body, String token) async {
    final response= await _apiBaseHelper.postWithHeader("wallet/get/balance", _body, "Bearer $token");
    return WalletBalanceModel.fromJson(response);
  }
  Future<WalletAddMoneyModel> walletAddMoney(Map _body, String token) async {
    final response= await _apiBaseHelper.postWithHeader("wallet/add/amount", _body, "Bearer $token");
    return WalletAddMoneyModel.fromJson(response);
  }
  Future<WalletTransactionModel> walletTransactionsData(Map _body, String token) async {
    final response= await _apiBaseHelper.postWithHeader("wallet/transaction/history", _body, "Bearer $token");
    return WalletTransactionModel.fromJson(response);
  }
}