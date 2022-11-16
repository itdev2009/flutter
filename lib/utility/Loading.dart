import 'package:delivery_on_time/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  final String loadingMessage;

  const Loading({Key key, this.loadingMessage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
      AlertDialog(
      elevation: 0.0,
      backgroundColor: darkThemeBlue,
      content: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              loadingMessage,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.cyan,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 15),
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.cyan),
            ),
          ],
        ),
      ),
    );
  }
}