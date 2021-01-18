import 'package:flutter/material.dart';
import 'package:vista_wallpaper/screens/full_image_screen.dart';
import 'package:vista_wallpaper/utils/wallpapers.dart';

class CustomGridView extends StatelessWidget {
  Function fetchMoreFunction;
  List<Wallpapers> wallpapersList;
  CustomGridView({this.fetchMoreFunction, this.wallpapersList});
  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: NotificationListener<ScrollEndNotification>(
      onNotification: (scrollEnd) {
        var metrics = scrollEnd.metrics;
        if (metrics.atEdge) {
          if (metrics.pixels == 0) {
            //scroll at top of gridView
          } else {
            fetchMoreFunction(); //scroll at bottom of gridView

          }
        }
        return true;
      },
      child: GridView.builder(
          itemCount: wallpapersList.length,
          itemBuilder: (context, i) => Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              child: Material(
                elevation: 8.0,
                child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => FullImageScreen(
                                    fullImage: wallpapersList[i].imageThumbnail,
                                    imageName: wallpapersList[i].imageName,
                                    imageType: wallpapersList[i].imageType,
                                  )));
                    },
                    child: FadeInImage(
                      image: NetworkImage(wallpapersList[i].imageThumbnail),
                      fit: BoxFit.cover,
                      placeholder: AssetImage("images/placeholder.jpg"),
                    )),
              )),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 3.0,
              mainAxisSpacing: 3.0,
              childAspectRatio: 1)),
    ));
  }
}
