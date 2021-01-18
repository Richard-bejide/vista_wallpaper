import 'package:flutter/material.dart';
import 'package:fzwallpaper/fzwallpaper.dart';
import 'dart:io';
import 'package:http/http.dart' show get;
import 'package:path/path.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:hawk_fab_menu/hawk_fab_menu.dart';
import 'package:downloads_path_provider_28/downloads_path_provider_28.dart';

class FullImageScreen extends StatefulWidget {
  final String fullImage;
  final String imageName;
  final String imageType;
  FullImageScreen({this.fullImage, this.imageName, this.imageType});
  @override
  _FullImageScreenState createState() => _FullImageScreenState();
}

class _FullImageScreenState extends State<FullImageScreen> {
  String fullImage;
  String imageName;
  String imageType;
  bool downloading = false;
  Stream<String> progressString;
  String both = "Both Screen";
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  void snackBar(String message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
        elevation: 6.0,
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.red,
        content: Text(message)));
  }

  Future<Directory> _getDownloadDirectory() async {
    if (Platform.isAndroid) {
      return await DownloadsPathProvider.downloadsDirectory;
    }
  }

  Future<void> downloadFileFromUrl() async {
    setState(() {
      downloading = true;
    });
    try {
      var response = await get(fullImage);
      //Directory documentDirectory = await getApplicationDocumentsDirectory();
      // String path = documentDirectory.path;
      Directory directory = await _getDownloadDirectory();

      File file = File(join(directory.path, '$imageName.$imageType'));
      file.writeAsBytesSync(response.bodyBytes);
      snackBar('wallpaper has been downloaded!');
      setState(() {
        downloading = false;
      });
    } catch (e) {
      print(e);
    }
  }

  void setWallpaper() async {
    try {
      snackBar('Setting wallpaper... ');
      progressString = Fzwallpaper.imageDownloadProgress(fullImage);
      progressString.listen((data) {}, onDone: () async {
        snackBar('Your wallpaper has been set successfully!');
        both = await Fzwallpaper.bothScreen();
        setState(() {
          both = both;
        });
      }, onError: (error) {
        snackBar('error occured');
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    fullImage = widget.fullImage;
    imageName = widget.imageName;
    imageType = widget.imageType;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        body: HawkFabMenu(
            icon: AnimatedIcons.menu_arrow,
            fabColor: Colors.red,
            iconColor: Colors.white,
            items: [
              HawkFabMenuItem(
                label: 'Set as wallpaper',
                ontap: () {
                  setWallpaper();
                },
                icon: Icon(Icons.wallpaper),
                color: Colors.red,
                labelColor: Colors.red,
              ),
              HawkFabMenuItem(
                  label: 'Download',
                  ontap: () {
                    downloadFileFromUrl();
                  },
                  icon: Icon(Icons.download_rounded),
                  labelColor: Colors.red,
                  color: Colors.red,
                  labelBackgroundColor: Colors.white),
            ],
            body: Stack(fit: StackFit.expand, children: <Widget>[
              Align(
                alignment: Alignment.center,
                child: Container(
                    child: FadeInImage(
                        image: NetworkImage(fullImage),
                        fit: BoxFit.cover,
                        placeholder: AssetImage("images/placeholder.jpg"))),
              ),
              Align(
                alignment: Alignment.center,
                child: downloading
                    ? SizedBox(
                        height: 80.0,
                        width: 80.0,
                        child: LoadingIndicator(
                          indicatorType: Indicator.ballClipRotateMultiple,
                          color: Colors.white,
                        ))
                    : Center(),
              )
            ])));
  }
}

//file_size octets(bytes)
//query count (to check to total number of queries per month.note:free 150k queries per month)
//https://wall.alphacoders.com/api2.0/get.php?auth=4c02b7c97cb69edb39ed669d579bdc1a&method=query_count
