import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:vista_wallpaper/utils/wallpapers.dart';
import 'package:vista_wallpaper/utils/customGridView.dart';
import 'package:vista_wallpaper/utils/customFutureBuilder.dart';

class CategoryPage extends StatefulWidget {
  final int categoryID;
  final String appBarTitle;
  CategoryPage({this.categoryID, this.appBarTitle});
  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  int pageCount = 1;
  List<Wallpapers> wallpapers;
  List<Wallpapers> moreWallpapers = [];
  String selectedSortMethod = "Newest";
  List<String> sortBy = ['Newest', 'Ratings', 'Views', 'Favorites'];
  Future<List<Wallpapers>> cacheWallpapers;

  DropdownButton<String> sortDropdown() {
    List<DropdownMenuItem<String>> dropdownItems = [];
    for (String i in sortBy) {
      var newItem = DropdownMenuItem(
          child:
              Text(i, style: (TextStyle(color: Colors.white, fontSize: 12.0))),
          value: i);
      dropdownItems.add(newItem);
    }
    return DropdownButton<String>(
        underline: Divider(color: Colors.black),
        dropdownColor: Colors.black,
        elevation: 10,
        value: selectedSortMethod,
        items: dropdownItems,
        onChanged: (value) {
          setState(() {
            selectedSortMethod = value;
            moreWallpapers = [];
            pageCount = 1;
            fetchWallpapers();
          });
        });
  }

  Future<List<Wallpapers>> fetchWallpapers() async {
    try {
      if (pageCount <= 10) {
        var response = await http.get(
            "https://wall.alphacoders.com/api2.0/get.php?auth=$authKey&method=category&id=${widget.categoryID}&page=$pageCount&sort=$selectedSortMethod&info_level=2");
        var decodeResponse = jsonDecode(response.body);
       // print(decodeResponse);
        Images images = Images.fromJson(decodeResponse);
        setState(() {
          wallpapers = images.wallpapers;
          wallpapers.forEach((element) {
            moreWallpapers.add(element);
          });
          pageCount++;
        });
      }
    } catch (e) {
      print(e);
    }
    return wallpapers;
  }

  @override
  void initState() {
    super.initState();
    cacheWallpapers = fetchWallpapers();
  }

  Column wallpapersUI() {
    return Column(
      children: [
        Container(alignment: Alignment.centerLeft, child: sortDropdown()),
        CustomGridView(
            fetchMoreFunction: fetchWallpapers, wallpapersList: moreWallpapers)
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    //double height = MediaQuery.of(context).size.height;
    // double width = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.appBarTitle),
        ),
        body: CustomFutureBuilder(
          context: context,
          asyncTask: cacheWallpapers,
          displayUI: wallpapersUI,
        ));
  }
}
