import 'package:flutter/material.dart';
import 'package:m_n_r/src/app.dart';
//import 'src/screens/Init_screen.dart';
//import 'src/screens/login_screen.dart';

//void main() => runApp(App());

void main() { // 1
  runApp( // 2
    new MaterialApp( //3
    debugShowCheckedModeBanner: false,
      home: new App(), //4
      routes: <String, WidgetBuilder> { //5
        '/LoginApp': (BuildContext context) => new App(), //6
        //'/InitScreen' : (BuildContext context) => new login_screen_new() //7
        },
      )
    );
}