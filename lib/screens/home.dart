import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:vista_wallpaper/screens/search.dart';
import 'package:vista_wallpaper/screens/category.dart';
import 'package:vista_wallpaper/utils/wallpapers.dart';
import 'package:vista_wallpaper/utils/customGridView.dart';
import 'package:vista_wallpaper/utils/customFutureBuilder.dart';

class Home extends StatefulWidget {
  final List<Categories> categories;
  Home(this.categories);
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int pageCount = 1;
  List<Wallpapers> wallpapers;
  List<Wallpapers> moreWallpapers = []; 
  Future<List<Wallpapers>> cacheWallpapers;

  Future<List<Wallpapers>> fetchWallpapers() async {
    try {
      if (pageCount <= 10) {
        var response = await http.get(
            "https://wall.alphacoders.com/api2.0/get.php?auth=$authKey&method=random&info_level=2");
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
        SizedBox(
            height: 57.0,
            child: ListView.builder(
                itemCount: widget.categories.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, i) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CategoryPage(
                                  categoryID: widget.categories[i].id,
                                  appBarTitle:
                                      widget.categories[i].wallpaperName)));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Container(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(children: <Widget>[
                            Text(widget.categories[i].wallpaperName,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 15.0)),
                            Text(
                                '${widget.categories[i].totalWallpapers} wallpapers',
                                style: TextStyle(
                                    fontSize: 9.0, color: Colors.white))
                          ]),
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25.0),
                            border: Border.all(width: 0.5, color: Colors.grey)),
                      ),
                    ),
                  );
                })),
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
        appBar: AppBar(title: Text("Vista"), actions: [
          IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SearchPage()));
              })
        ]),
        body: CustomFutureBuilder(
          context: context,
          asyncTask: cacheWallpapers,
          displayUI: wallpapersUI,
        ));
  }
}
