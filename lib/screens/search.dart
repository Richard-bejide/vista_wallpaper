import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:vista_wallpaper/utils/wallpapers.dart';
import 'package:vista_wallpaper/utils/customGridView.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<String> sortBy = ['Newest', 'Ratings', 'Views', 'Favorites'];
  List<Wallpapers> wallpapers = [];
  String searchTerm;

  Future<void> fetchWallpapers() async {
    try {
      var response = await http.get(
          "https://wall.alphacoders.com/api2.0/get.php?auth=$authKey&method=search&term=$searchTerm");
      var decodeResponse = jsonDecode(response.body);
     // print(decodeResponse);
      Images images = Images.fromJson(decodeResponse);
      setState(() {
        wallpapers = images.wallpapers;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    //double height = MediaQuery.of(context).size.height;
    // double width = MediaQuery.of(context).size.width;
    return Scaffold(
        body: SafeArea(
            child: Column(
      children: [
        Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Row(children: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child:
                      Icon(Icons.arrow_back, size: 24.0, color: Colors.white)),
              Expanded(
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      searchTerm = value;
                    });
                  },
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'enter term...',
                    hintMaxLines: 128,
                    hintStyle: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              IconButton(
                  onPressed: () {
                    fetchWallpapers();
                  },
                  icon: Icon(
                    Icons.search,
                    size: 18.0,
                    color: Colors.white,
                  ))
            ])),
        wallpapers.isEmpty
            ? Center(
                child: Text('Nothing to show!',
                    style: TextStyle(color: Colors.grey)))
            : CustomGridView(
                wallpapersList: wallpapers,
              )
      ],
    )));
  }
}
