

import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class OfferPage extends StatefulWidget {
  const OfferPage({Key key}) : super(key: key);

  @override
  State<OfferPage> createState() => _OfferPageState();
}

class _OfferPageState extends State<OfferPage> {


  bool accepted = false;

   callremoteapi(){


     Stream<String> remoteApi = (() async* {

       print('ENTERED STREAM');

       const url = "http://jsonplaceholder.typicode.com/todos/1";


       while (accepted == false) {
         try {

           var response = await Dio().get(url);

           if (response.statusCode == 200) {

             //model data call here
             yield response.data.toString() +
                 DateTime.now().millisecondsSinceEpoch.toString();




             setState(() {

             });

           }

           //Pause of 1 second after each request
           await Future.delayed(const Duration(seconds: 1));

         } catch (e) {
           print(e);
         }
       }
     })();

  }

  @override
  void initState()
  {

    super.initState();

    Timer.periodic(Duration(seconds: 1), (timer) {
          callremoteapi();

    });


  }




  @override
  Widget build(BuildContext context) {


    return Scaffold(

      body: StreamBuilder<String>(
        stream: callremoteapi(),
        builder: (
            BuildContext context,
            AsyncSnapshot<String> snapshot,
            ) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.connectionState == ConnectionState.active ||
              snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return const Text('Error');
            } else if (snapshot.hasData) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(
                    snapshot.data.toString(),
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            } else {
              return const Center(child: Text('Empty data'));
            }
          } else {
            return Center(child: Text('State: ${snapshot.connectionState}'));
          }
        },
      ),
    );



  }
}
