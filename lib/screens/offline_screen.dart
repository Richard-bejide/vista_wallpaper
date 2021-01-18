import 'package:flutter/material.dart';
import 'package:vista_wallpaper/screens/splash_screen.dart';

class OfflineScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
            child: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('Not connected to the internet!',
                    style: TextStyle(fontSize: 25.0)),
                RaisedButton(
                    child: Text('Retry'),
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SplashScreen()));
                    })
              ]),
        )));
  }
}
