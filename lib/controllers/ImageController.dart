import 'dart:convert';
import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vayuz_demo_project/models/ImageModel.dart';
import 'package:http/http.dart' as http;
import 'package:vayuz_demo_project/resources/API.dart';

class ImageController extends ControllerMVC{

  final ImageModel _imageModel = ImageModel();

  Future<void> fetchImage() async {
    final client = http.Client();
    final response = await client.get(
      Uri.parse(API.imageUrl),
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    );

    if(response.statusCode==200){
      //print(json.decode(response.body));
      var decodeddata = json.decode(response.body);
      
      SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.setString('image_data',
                json.encode(decodeddata["message"]));
    }
    else{
      Fluttertoast.showToast(
              msg: "Something is Fissy in Calling Image from Network");
    }
  }
}