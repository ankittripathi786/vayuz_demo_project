import 'dart:async';
import 'package:flutter/material.dart';
import 'views/HomeSplash.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
     const MaterialApp(
      
      debugShowCheckedModeBanner: false,
      home: HomeSplash(),
    ),
  );
}
