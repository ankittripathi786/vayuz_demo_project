// ignore_for_file: file_names, use_key_in_widget_constructors

import 'dart:async';
import 'dart:convert';
import 'dart:io' show HttpHeaders, Platform;
import 'dart:developer' as developer;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vayuz_demo_project/controllers/ImageController.dart';
import 'package:vayuz_demo_project/views/ImageView.dart';

import 'package:http/http.dart' as http;
import '../resources/API.dart';
import 'NoInternet.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {

  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

 

  @override
  void initState() {
    super.initState();
     initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
       updateScreen();
  }

  Future<void> updateScreen() async {
     var connectivityResult = await (Connectivity().checkConnectivity());
     
        if (connectivityResult == ConnectivityResult.none) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const NoInternet()),
            );
          }
        
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      developer.log('Couldn\'t check connectivity status', error: e);
      return;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    setState(() {
      _connectionStatus = result;
    });
  }
   
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
          appBar: AppBar(title: const Text("Vayuz Dummy App"), centerTitle: true,),
      body: SafeArea(
        // ignore: avoid_unnecessary_containers
        child: Container(
          child: Center(child: ElevatedButton(
            style: ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20)),
            onPressed: () async {
              // ImageController().fetchImage();

                 final client = http.Client();
    final response = await client.get(
      Uri.parse(API.imageUrl)
      //headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    );

    if(response.statusCode==200){
      //print(json.decode(response.body));
      var decodeddata = json.decode(response.body);
      Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ImageView(decodeddata["message"])));
    }
    else{
      Fluttertoast.showToast(
              msg: "Something is Fissy in Calling Image from Network");
    }
              
            },
            child: const Text('Fetch API and Display Image'),
          ),),
        ),
      )
    );
  }
}
