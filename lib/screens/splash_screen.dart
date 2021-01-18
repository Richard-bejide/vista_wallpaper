import 'package:flutter/material.dart';
import 'package:vista_wallpaper/screens/home.dart';
import 'package:vista_wallpaper/utils/wallpapers.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:vista_wallpaper/screens/offline_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  List<Categories> categories;

  Future<void> fetchWallpaperCategoriesList() async {
    try {
      var response = await http.get(
          "https://wall.alphacoders.com/api2.0/get.php?auth=$authKey&method=category_list");
      var decodeResponse = jsonDecode(response.body);
      //print(decodeResponse);
      Data data = Data.fromJson(decodeResponse);
      categories = data.categories;
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Home(categories)));
    } catch (e) {
      print(e);
    }
  }

  Future<void> checkInternetConnection() async {
    bool result = await DataConnectionChecker().hasConnection;
    if (!result) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => OfflineScreen()));
    }
  }

  void initState() {
    super.initState();
    checkInternetConnection();
    fetchWallpaperCategoriesList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Center(
                child: Image.asset('images/vista_wallpaper.jpg',
                    height: 120.0, width: 120.0))));
  }
}
