import 'package:flutter/material.dart';
import 'package:m_n_r/src/blocs/bloc.dart';
import 'package:m_n_r/src/blocs/provider.dart';
import 'package:m_n_r/src/models/usermodel.dart';
import 'package:m_n_r/src/screens/initScreen.dart';
import 'package:m_n_r/src/txtCss.dart';
import 'package:m_n_r/src/models/pregateinmodel.dart';
import 'package:m_n_r/src/screens/survey.dart';

class SurveyPGIn extends StatefulWidget {

  final LoginUserInfo loginInfo;
  SurveyPGIn({Key key, @required this.loginInfo}) :super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SurveyPGInHome();
  }
}

class SurveyPGInHome extends State<SurveyPGIn> with TxtCss {
  var sizeHW;

  Widget build(context) {

    var bloc =Provider.of(context);
    sizeHW = MediaQuery.of(context).size;

    return MaterialApp(
      title: 'Container Pre Gate-In List for Survey',
      home: Scaffold(
        appBar: AppBar(centerTitle: true,
          title: Text('Pre Gate-In List', 
                      style: txtRoboBoldHiLightColor(25, Colors.white),),
                      bottomOpacity: 2.0,
                      backgroundColor: Color(0XFF0091EA),
                      elevation: 10.0,
          actions: <Widget>[ 
            IconButton(icon: Icon(Icons.home), iconSize: 40.00, 
              onPressed: (){Navigator.push(context, new MaterialPageRoute(
                            builder: (context) =>
                            new InitScreen(loginInfo: widget.loginInfo),
                            maintainState: false));},),],),          
              body: surveyPGInScreen(context, bloc),
              floatingActionButton: new FloatingActionButton(
                backgroundColor: Colors.greenAccent[700],
                elevation: 10.0,
                highlightElevation: 20.0,
                isExtended: true,
                child: new Icon(Icons.add,color: Colors.white),
                tooltip: 'Add Survey',
                onPressed: (){_showSurveyScreen(context, widget.loginInfo);},),
                                // SizedBox(width: 20,)
              ),
      

    );
  }

Widget surveyPGInScreen(BuildContext context, Bloc bloc) {
    return SingleChildScrollView(child: Container(
      child: Column(
        children: <Widget>[
        //   Row( mainAxisAlignment: MainAxisAlignment.end,
        //     children: <Widget>[ FloatingActionButton( 
        //                           child: Text('+ Add Survey'), onPressed: (){_showSurveyScreen(context, widget.loginInfo);},),
        //                         SizedBox(width: 20,)],),
          // Row(children: <Widget>[ Expanded(flex:10,child: _displayTblHeading() ),],),
          Row(children: <Widget>[ Expanded(flex:10, child: _displayDataTable(bloc),)],)  
        ],),
    ));
  }

// Widget _displayTblHeading(){
//     return Container(alignment: Alignment.center,
//           decoration: BoxDecoration(color: Colors.lightBlueAccent[700]), 
//           child: Text('Pre Gate-In List',
//           style: txtRoboBoldHiLightColor(25,Colors.white,)),
//     );
//   }

  Widget _displayDataTable(Bloc bloc) {
    //return Container(height: ((48.5/100)*sizeHW.height), color: Colors.blueAccent,);
      NumScroller numscrl = new NumScroller(height:600.0, width: sizeHW.width, alignment: TextAlign.left,
                                            min:1, max:1000, bloc:bloc, loginUsrInfo: widget.loginInfo,);
      return numscrl;
  }
 
  // to pop up any message to the User
  void _showAlert(BuildContext context, String strVal) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return SimpleDialog(children: <Widget>[ 
          //showRadioBtn(context),
          Text(strVal,textAlign: TextAlign.center, style: txtRoboStyle(40),),
          Container(color: Colors.blueGrey,height: 1.0,),
          new FlatButton(child: new Text("Close",style: txtRoboStyle(25),),
                         onPressed: () {Navigator.of(context).pop();},
            )
          ],
        );
      },
    );
  }

  _showSurveyScreen(BuildContext context, LoginUserInfo loginUsrinfo)
  {  
    //print('Entering Pre Gate-In');
    Navigator.push(context, new MaterialPageRoute(builder: (context) =>
                            new Survey(loginInfo: loginUsrinfo)));
  }
}

class NumScroller extends StatefulWidget{
  final int max,min;
  final double height,width;
  final TextAlign alignment;
  final bloc;
  final LoginUserInfo loginUsrInfo;

  NumScroller({this.height,this.width,this.alignment,this.min,this.max, 
                initialOffset, this.bloc, this.loginUsrInfo});

  @override
  NumScrollerState createState() {
    return new NumScrollerState();
  }
}

class NumScrollerState extends State<NumScroller> with TxtCss {
  final ScrollController controller = ScrollController();
  final sur = new SurveyPGInHome();

  getValue() => (controller.offset~/widget.height) + widget.min;

  @override
  Widget build(BuildContext context) {
    return new Container(
        decoration: const BoxDecoration(color: Colors.white),
        width: widget.width,
        height: widget.height,
        child: ListView(padding: EdgeInsets.all(5.0), 
          addRepaintBoundaries: true,
          children: <Widget>[
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child:
                dataTblDRCodeUpdate(widget.bloc),
            ),
          ],//),
          //itemCount: widget.max - widget.min+1,
          controller: controller,
          physics: PageScrollPhysics(),
          itemExtent: widget.height,
      )
    );
  }

  Widget dataTblDRCodeUpdate(Bloc bloc) {
    SurveyPGInHd sPGInHd = SurveyPGInHd();
    double fntSize = 20.0;

    return FutureBuilder(
      future: sPGInHd.surveyPGInList(widget.loginUsrInfo.branchId),
      builder:(context, ssPGInHdList) {
        List surPGInHdList = ssPGInHdList.hasData ? ssPGInHdList.data : <SurveyPGInHd>[];
        return Card(
          elevation: 30.0,
          clipBehavior: Clip.antiAlias,
          child:DataTable(
          sortAscending: false,
          columns: <DataColumn>[
            
            DataColumn(label: Expanded(child: Text('Document No.', style: lblRoboStyle(fntSize))), 
              numeric: false, onSort: (i,b){},),
            DataColumn(label: Expanded(child:Text('Container No.', style: lblRoboStyle(fntSize))), 
              numeric: false, onSort: (i,b){},),
            DataColumn(label: Expanded(child: Text('Size', style: lblRoboStyle(fntSize))), 
              numeric: false, onSort: (i,b){},),
            DataColumn(label: Expanded(child:Text('Type', style: lblRoboStyle(fntSize))), 
              numeric: false, onSort: (i,b){},),
            ],
          rows: surPGInHdList.map((sPGInHdlist) => DataRow(
          
                //onSelectChanged: (b){},
                //selected: false,
                cells: <DataCell>[
                  DataCell(SizedBox.fromSize(size: Size(200, 100),
                            child:Text(sPGInHdlist.documentNo, 
                            style: txtRoboULStyle(fntSize), softWrap: true,)),
                            onTap: (){ widget.loginUsrInfo.preGInDocNo = sPGInHdlist.documentNo ; sur._showSurveyScreen(context, widget.loginUsrInfo);}),
                  DataCell(SizedBox.fromSize(size: Size(200, 50),
                            child:Text(sPGInHdlist.containerNo, style: txtRoboStyle(fntSize), softWrap: true))),
                  DataCell(SizedBox.fromSize(size: Size(200, 50),
                            child:Text(sPGInHdlist.contSize, style: txtRoboStyle(fntSize), softWrap: true,))),
                  DataCell(SizedBox.fromSize(size: Size(200, 50),
                            child:Text(sPGInHdlist.contType, style: txtRoboStyle(fntSize), softWrap: true))),
                ]
          )).toList()
        ));
    });
  }

}

