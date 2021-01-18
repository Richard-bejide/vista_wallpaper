import 'package:vista_wallpaper/utils/config.dart';

//obtain api key from  https://wall.alphacoders.com/api.php
const String authKey = apiKey;

class Wallpapers {
  String imageThumbnail;
  String fullImage;
  String imageSize;
  String imageName;
  String imageType;
  Wallpapers.fromJson(Map<String, dynamic> json) {
    imageThumbnail = json['url_thumb'];
    fullImage = json['url_image'];
    imageSize = json['file_size'];
    imageName = json['id'];
    imageType = json['file_type'];
  }
}

//helps to create a list of wallpapers
class Images {
  List<Wallpapers> wallpapers;
  bool success;
  //Images({this.responseCode, this.results});
  Images.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (success) {
      wallpapers = List<Wallpapers>();
      json['wallpapers'].forEach((v) {
        wallpapers
            .add(new Wallpapers.fromJson(v)); //adds each result to results list
      });
    }
  }
}

class Categories {
  int id;
  int totalWallpapers;
  String wallpaperName;
  Categories.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    totalWallpapers = json['count'];
    wallpaperName = json['name'];
  }
}

//helps to create a list of categories
class Data {
  List<Categories> categories;
  bool success;
  //Images({this.responseCode, this.results});
  Data.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (success) {
      categories = List<Categories>();
      json['categories'].forEach((v) {
        categories
            .add(new Categories.fromJson(v)); //adds each result to results list
      });
    }
  }
}
