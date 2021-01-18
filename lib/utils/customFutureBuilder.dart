import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

class CustomFutureBuilder extends StatelessWidget {
  BuildContext context;
  Future<List> asyncTask;
  Function displayUI;
  CustomFutureBuilder({@required this.context, this.asyncTask, this.displayUI});

  //error shown if snapshot.hasError returns true
  Padding errorData(AsyncSnapshot snapshot) {
    return Padding(
      padding: const EdgeInsets.only(left: 80.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('Something went wrong!', style: TextStyle(color: Colors.white)),
          SizedBox(
            height: 20.0,
          ),
          RaisedButton(
            child: Text("Try Again", style: TextStyle(color: Colors.white)),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        //Creates a widget that builds itself based on the latest snapshot of interaction with a [Future].
        future:
            asyncTask, //async task called everytime the build method is called
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return Text('Press button to start.');
            case ConnectionState.active:
            case ConnectionState.waiting:
              return Center(
                  child: SizedBox(
                      height: 30.0,
                      width: 30.0,
                      child: LoadingIndicator(
                        indicatorType: Indicator.lineScalePulseOut,
                        color: Colors.white,
                      )));
            case ConnectionState.done:
              if (snapshot.hasError) return errorData(snapshot);
              return displayUI();
          }
          return null;
        });
  }
}
