import 'dart:async';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

class ImageCollector extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _ImgCollector();
}

class _ImgCollector extends State<ImageCollector>
{
  File pic;

  Future getImage() async
  {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      pic = image;
    });
    //print (pic.toString());
    if(pic != null) { Navigator.of(context).pop(pic);}
  }

  @override
  Widget build(BuildContext context){
    return MaterialApp(
            title: 'Expected Repair Pictures',
            home: Scaffold(
              appBar: new AppBar(title: new Text('Image Picker'),
               centerTitle: true, 
               backgroundColor: Color(0XFF0091EA),
               bottomOpacity: 2.0,
               elevation: 10.0,
                leading:  IconButton(onPressed: () {Navigator.of(context).pop(pic);}, 
                icon: Icon(Icons.arrow_back))  ),
              body: new Center(child: pic == null ? Text('No Image selected') : new Image.file(pic),),
              floatingActionButton: FloatingActionButton(onPressed: getImage, tooltip: 'Image Pick', child: Icon(Icons.camera_alt),),
            ),
        );
      }
    }