import 'package:vista_wallpaper/utils/config.dart';

//obtain api key at  https://wall.alphacoders.com/api.php
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

class Images {
  List<Wallpapers> wallpapers;
  bool success;
  Images.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (success) {
      wallpapers = List<Wallpapers>();
      json['wallpapers'].forEach((v) {
        wallpapers
            .add(new Wallpapers.fromJson(v)); 
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

class Data {
  List<Categories> categories;
  bool success;
  Data.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (success) {
      categories = List<Categories>();
      json['categories'].forEach((v) {
        categories
            .add(new Categories.fromJson(v)); 
      });
    }
  }
}
