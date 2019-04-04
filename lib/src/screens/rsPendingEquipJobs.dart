import 'package:flutter/material.dart';
import 'package:m_n_r/src/blocs/bloc.dart';
import 'package:m_n_r/src/blocs/provider.dart';
import 'package:m_n_r/src/models/usermodel.dart';
import 'package:m_n_r/src/screens/initScreen.dart';
import 'package:m_n_r/src/txtCss.dart';
import 'package:m_n_r/src/models/reachStackerModel.dart';
import 'package:m_n_r/src/screens/rsPendingJobDetails.dart';

class RSPendingEquipJobs extends StatefulWidget {

  final LoginUserInfo loginInfo;
  RSPendingEquipJobs({Key key, @required this.loginInfo}) :super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return RSPendingEquipJobsHome();
  }
}

class RSPendingEquipJobsHome extends State<RSPendingEquipJobs> with TxtCss {
  var sizeHW;

  Widget build(context) {

    var bloc =Provider.of(context);
    sizeHW = MediaQuery.of(context).size;

    return MaterialApp(
      title: 'Reach Staker Pending Jobs list',
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 10.0,
          bottomOpacity: 2.0,
          backgroundColor: Color(0XFF0091EA),
          title: Text('Reach Staker Pending Equipment Jobs', 
          style: txtRoboBoldHiLightColor(25, Colors.white),),
          leading:
            IconButton(icon: Icon(Icons.arrow_back), iconSize: 40.00, 
              onPressed: (){Navigator.push(context, new MaterialPageRoute(
                            builder: (context) =>
                            new InitScreen(loginInfo: widget.loginInfo),
                            maintainState: false));},),),          
              body: rsPendingJobs(context, bloc),
      ),
    );
  }

  Widget rsPendingJobs(BuildContext context, Bloc bloc) {
    return SingleChildScrollView(child: Container(
      child: Column(
        children: <Widget>[
          //Row(children: <Widget>[ Expanded(flex:10,child: _displayTblHeading() ),],),
          Row(children: <Widget>[ Expanded(flex:10, child: _displayDataTable(bloc),)],)  
        ],),
    ));
  }

  Widget _displayTblHeading(){
    return Container(alignment: Alignment.centerLeft,
          decoration: BoxDecoration(color: Colors.lightBlueAccent[200]), 
          child: Text('Equipment Jobs List',
                  style: txtRoboBoldHiLightColor(25,Colors.white,)),
    );
  }

  Widget _displayDataTable(Bloc bloc) {
    //return Container(height: ((48.5/100)*sizeHW.height), color: Colors.blueAccent,);
      NumScroller numscrl = new NumScroller(height:800.0, width: sizeHW.width, alignment: TextAlign.left,
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
        ],);
      },
    );
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

  getValue() => (controller.offset~/widget.height) + widget.min;

  @override
  Widget build(BuildContext context) {
    return new Container(
        decoration: const BoxDecoration(color: Colors.white),
        width: widget.width,
        height: widget.height,
        child: ListView(padding: EdgeInsets.all(2.0), 
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
    ReachStacker rsPEJobs = ReachStacker();
    double fntSize = 14.0;

    return FutureBuilder(
      future: rsPEJobs.fetchRSList(widget.loginUsrInfo.branchId),
      builder:(context, ssPEJdata) {
        List rsPEJList = ssPEJdata.hasData ? ssPEJdata.data : <ReachStacker>[];
        return Card(
          elevation: 10.0,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          // margin: EdgeInsets.only(bottom: 20.0),
          child:Container(
            padding: EdgeInsets.only(top: 40.0),
            height: 660.0,
                  child:
                    DataTable(
                        sortAscending: false,
                        columns: <DataColumn>[
                          DataColumn(label: Expanded(child: Text('Activity', style: lblRoboStyle(fntSize))), 
                            numeric: false, onSort: (i,b){},),
                          DataColumn(label: Expanded(child:Text('Truck No.', style: lblRoboStyle(fntSize))), 
                            numeric: false, onSort: (i,b){},),
                          DataColumn(label: Expanded(child:Text('Container No.', style: lblRoboStyle(fntSize))), 
                            numeric: false, onSort: (i,b){},),              
                          DataColumn(label: Expanded(child: Text('Size / Type', style: lblRoboStyle(fntSize))), 
                            numeric: false, onSort: (i,b){},),
                          // DataColumn(label: Expanded(child:Text('Type', style: lblRoboStyle(fntSize))), 
                          //   numeric: false, onSort: (i,b){},),
                          DataColumn(label: Expanded(child:Text('Agent', style: lblRoboStyle(fntSize))), 
                            numeric: false, onSort: (i,b){},),
                          DataColumn(label: Expanded(child:Text('Booking BL No.', style: lblRoboStyle(fntSize))), 
                            numeric: false, onSort: (i,b){},),
                          DataColumn(label: Expanded(child:Text('Vessel', style: lblRoboStyle(fntSize))), 
                            numeric: false, onSort: (i,b){},),
                          DataColumn(label: Expanded(child:Text('Voyage', style: lblRoboStyle(fntSize))), 
                              numeric: false, onSort: (i,b){},),                                                      
                          ],
                  rows: rsPEJList.map((rsPEJob) => DataRow(
                //onSelectChanged: (b){},
                //selected: false,
                cells: <DataCell>[
                  DataCell(SizedBox.fromSize(size: Size(125, 50),
                            child:Text(rsPEJob.activity, 
                            style: txtRoboStyle(fntSize), softWrap: true,)),
                            onTap: (){_showrsPendingJobDetails(context, widget.loginUsrInfo, rsPEJob);}),
                  DataCell(SizedBox.fromSize(size: Size(100, 50),
                            child:Text(rsPEJob.truckNo, style: txtRoboStyle(fntSize), softWrap: true))),
                  DataCell(SizedBox.fromSize(size: Size(125, 50),
                            child:Text(rsPEJob.containerNo, style: txtRoboULStyle(fntSize), softWrap: true)),
                            onTap: (){ _showrsPendingJobDetails(context, widget.loginUsrInfo, rsPEJob);}),
                  DataCell(SizedBox.fromSize(size: Size(50, 50),
                            child:Text(rsPEJob.size + ' / ' + rsPEJob.type, style: txtRoboStyle(fntSize), softWrap: true,))),
                  // DataCell(SizedBox.fromSize(size: Size(25, 50),
                  //           child:Text(rsPEJob.type, style: txtRoboStyle(fntSize), softWrap: true))),
                  DataCell(SizedBox.fromSize(size: Size(60, 50),
                            child:Text(rsPEJob.agentCode, style: txtRoboStyle(fntSize), softWrap: true))),
                  DataCell(SizedBox.fromSize(size: Size(150, 50),
                            child:Text(rsPEJob.bookingBLNo, style: txtRoboStyle(fntSize), softWrap: true,))),
                  DataCell(SizedBox.fromSize(size: Size(30, 50),
                            child:Text(rsPEJob.vesselCode, style: txtRoboStyle(fntSize), softWrap: true))),
                  DataCell(SizedBox.fromSize(size: Size(80, 50),
                            child:Text(rsPEJob.voyageNo, style: txtRoboStyle(fntSize), softWrap: true))),
                ]
          )).toList()
        )));
    });
  }

  _showrsPendingJobDetails(BuildContext context, LoginUserInfo loginUsrinfo, ReachStacker rsPendingJob)
  {  
    //print('Entering Pre Gate-In');
    Navigator.push(context, new MaterialPageRoute(
                                  builder: (context) =>
                                    new RSPendingJobDetails(loginInfo: loginUsrinfo, rsItem: rsPendingJob,)));
  }
}

