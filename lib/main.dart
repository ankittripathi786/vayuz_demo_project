import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'views/HomeSplash.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
     const GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeSplash(),
    ),
  );
}
