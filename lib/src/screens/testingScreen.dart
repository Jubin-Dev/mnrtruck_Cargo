import 'package:flutter/material.dart';
import 'package:m_n_r/src/txtCss.dart';
import 'package:m_n_r/src/models/usermodel.dart';
import 'package:m_n_r/src/blocs/bloc.dart';
import 'package:m_n_r/src/blocs/provider.dart';

class TestScreeen extends StatefulWidget {
  
  final LoginUserInfo loginInfo;
  TestScreeen({Key key, @required this.loginInfo}) :super(key: key);  

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return TestHome();
  }
}

class TestHome extends State<TestScreeen> with TxtCss {

  @override
  Widget build(context){
    var bloc =Provider.of(context);
    return MaterialApp(
      title: 'Image Testing',
      home: Scaffold(
        appBar: AppBar(centerTitle: true,
        title: Text('Container Status Update', style: txtRoboBoldHiLightColor(30,Colors.white),),),
        //body: Image.network('https://picsum.photos/250?image=9'),
        //body: Image.network('http://dmsapi.logiconglobal.com/ImageStorage/PGILCH190300009/71200771BL20.jpg') ,
        
        body: containerStatusScreen(bloc),
      ),
    );
  }

  Widget containerStatusScreen(Bloc bloc) {
    return Row(children: <Widget>[
      Expanded(flex:2, child:Container()),
      Expanded(flex:6, child:_displayFeilds(bloc)),
      Expanded(flex:2, child:Container())      
    ],);
  }

  Widget _displayFeilds(Bloc bloc){
    return  SingleChildScrollView( child: 
      Container( //height: 400.00, width:600.00 ,
      alignment: Alignment.center,
      child: Column(
        children: <Widget>[

          Row(mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
            displayNetworkImage(),
            Expanded( child: new OutlineButton(  
              shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.vertical()),
              child: new Text("<< Back <<", style: txtRoboBoldHiLightColor(25, Colors.lightBlueAccent)),
              onPressed: () {Navigator.of(context).pop();},
              borderSide: BorderSide(color: Colors.blue),
              //shape: StadiumBorder(),
            )),
          ],),
        ],
      ),
    ));
  }

  Widget displayNetworkImage(){
    return Image.network('http://dmsapi.logiconglobal.com/ImageStorage/PGILCH190300008/71200771BL12.jpg',
                            fit: BoxFit.fill, height: 500, width: 400,);
    //return  Image.network("http://dmsapi.logiconglobal.com/ImageStorage/PGILCH190300009/71200771BL20.jpg") ;
    //return  NetworkImage(url:"http://dmsapi.logiconglobal.com/ImageStorage/PGILCH190300009/71200771BL20.jpg");
    
  }

}
