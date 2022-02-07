// ignore_for_file: file_names

import 'dart:async';
import 'dart:developer' as developer;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart' show AlwaysStoppedAnimation, BuildContext, CircularProgressIndicator, Color, Colors, Column, EdgeInsets, Expanded, FontWeight, Image, Key, MainAxisAlignment, MaterialPageRoute, MediaQuery, Navigator, Padding, Scaffold, SizedBox, Stack, StackFit, State, StatefulWidget, Text, TextStyle, Widget;
import 'package:flutter/services.dart';

import '../resources/Images.dart';
import '../resources/Strings.dart';
import 'Dashboard.dart';
import 'NoInternet.dart';

class HomeSplash extends StatefulWidget {
  const HomeSplash({Key? key}) : super(key: key);

  @override
  _HomeSplashState createState() => _HomeSplashState();
}

class _HomeSplashState extends State<HomeSplash> {

ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  @override
  void initState()  {
    super.initState();
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
       updateScreen();
  }

  Future<void> updateScreen() async {
     var connectivityResult = await (Connectivity().checkConnectivity());
     
          if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi || connectivityResult == ConnectivityResult.ethernet) {
            // I am connected to a mobile network.
            await Future.delayed(const Duration(seconds: 3), (){
              Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Dashboard()),
            );
            });
          } 
          else if (connectivityResult == ConnectivityResult.none) {
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
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        Scaffold(
          backgroundColor: const Color(0xFFFFFFFF),
          body: SizedBox(
            width: double.infinity,
            height: double.infinity,
            // ignore: unnecessary_new
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                // ignore: unnecessary_new
                new Expanded(
                  flex: 4,
                  // ignore: unnecessary_new
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                  Image.asset(
                    Images.logo,
                    width: MediaQuery.of(context).size.width-80,
                    height: 400,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 30.0),
                  ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    // ignore: prefer_const_literals_to_create_immutables
                    children: <Widget>[
                      const CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.white),
                        backgroundColor: Colors.red,
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 20.0),
                      ),
                      const Text(Language.loadingText,
                          style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.red)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}