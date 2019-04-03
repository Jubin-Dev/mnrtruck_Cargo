import 'package:flutter/material.dart';
import 'package:m_n_r/src/models/containerStatusModel.dart';
import 'package:m_n_r/src/models/pregateinmodel.dart';
import 'package:m_n_r/src/screens/initScreen.dart';
import 'package:m_n_r/src/txtCss.dart';
import 'package:m_n_r/src/models/usermodel.dart';
import 'package:m_n_r/src/blocs/bloc.dart';
import 'package:m_n_r/src/blocs/provider.dart';
import 'package:progress_indicators/progress_indicators.dart';

class ContainerStatus extends StatefulWidget {
  
  final LoginUserInfo loginInfo;
  ContainerStatus({Key key, @required this.loginInfo}) :super(key: key);  

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ContainerStatusHome();
  }
}

class ContainerStatusHome extends State<ContainerStatus> with TxtCss {

  LookUp lookup = new LookUp();
  bool islookUphasdata = false;
  bool isRepairCodeshasdata = false;
  List lookUpRetrivedata;
  List lookUpRepairCodes;

  Future<List<LookupItem>> fillLookups(String category) async {
    
    if (!islookUphasdata)
    {
    await lookup.fetchInitData()
      .then((onValue) { lookUpRetrivedata = onValue; islookUphasdata = true;}, 
            onError: (e) {_showAlert(context, e.toString());})
      .catchError((onError) { _showAlert(context, onError.toString());}); //throw Exception(onError);});
    }
    // Based on Category it fetches the data
    List<LookupItem> _lookupitem = lookUpRetrivedata.where((lukups) => 
                        (lukups.lookupCategory == category )).toList();

    return _lookupitem;
  }

  @override
  Widget build(context){
    var bloc = Provider.of(context);
    return MaterialApp(
      title: 'Container Status Update',
      home: Scaffold(
        appBar: AppBar(centerTitle: true,
        title: Text('Container Status Update', style: txtRoboBoldHiLightColor(25,Colors.white),),
          bottomOpacity: 2.0,
          backgroundColor: Color(0XFF0091EA),
          elevation: 10.0,
          leading: IconButton(icon: Icon(Icons.arrow_back), iconSize: 40.00,
                              tooltip: 'Go Home', 
                        onPressed: (){Navigator.push(context, new MaterialPageRoute(
                                      builder: (context) =>
                                      new InitScreen(loginInfo: widget.loginInfo),
                                      maintainState: false));},),
        ),
        body: containerStatusScreen(bloc),
      ),
    );
  }

  Widget containerStatusScreen(Bloc bloc) {
    return Row(children: <Widget>[
      Expanded(flex:2, child:Container()),
      Expanded(flex:8, child:_displayFeilds(bloc)),
      Expanded(flex:2, child:Container())      
    ],);
  }

  Widget _displayFeilds(Bloc bloc){
    return  SingleChildScrollView( child: 
      Card( 
        elevation: 20.0,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child:Container(
             height: 400.00, width:600.00 ,
      alignment: Alignment.center,
      //  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0),),
      padding: EdgeInsets.all(15),      
      child: Column(
        children: <Widget>[
          txtfldContNo(bloc),
          SizedBox(height: 30.00),
          // txtFldCurrentContStatus(bloc),
          // SizedBox(height: 20.00),
          ddcontStatus(bloc),
          SizedBox(height: 10.00),
          txtFldremarks(bloc),
          SizedBox(height: 60.00),
          Row(mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
            SizedBox(width: 250),
            Expanded( child: new MaterialButton(  
               color: Colors.lightBlueAccent[700],
              shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.vertical()),
              child: new Text("Back", style: txtRoboBoldHiLightColor(25, Colors.white)),
              onPressed: () {Navigator.of(context).pop();},
              // borderSide: BorderSide(color: Colors.blue),
              //shape: StadiumBorder(),
            )),
            SizedBox(width: 20.0,),
            Expanded( child: new MaterialButton(
              color: Colors.lightBlueAccent[700],
              shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.vertical()),
              child: new Text("Save", style: txtRoboBoldHiLightColor(25, Colors.white)),
              onPressed: () {saveContainerStatusUpdate(bloc);},
              // borderSide: BorderSide(color: Colors.blue),
            )),
            SizedBox(width: 10.0,),
          ],),
        ],
      ),
    )));
  }

  Widget txtfldContNo(Bloc bloc){
    return StreamBuilder(
      stream: bloc.csContNo,
      builder: (context, snapshot) 
        { 
          return TextField(
            textCapitalization: TextCapitalization.characters,
            style: txtRoboStyle(20),
            onChanged: bloc.changecsContNo,  
            // onSubmitted: (valu) async { //_showAlert(context, valu);
            //                             await bloc.containercheckSum()
            //                             .then((onValue) {}, 
            //                             onError: (err) {_showAlert(context, err.toString());},)
            //                             .catchError((onError) {_showAlert(context, onError.toString());}); },
            decoration: InputDecoration(
            labelStyle: lblRoboStyle(20),
            // hintText: 'CONT0000000',
            labelText: 'Container No.',
            errorText: snapshot.error,
            ),
          );
        }
      
      );
    
  }

  Widget txtFldCurrentContStatus(Bloc bloc){
  return StreamBuilder(
    stream: bloc.csCurrContStatus,
    builder: (context, snapshot) 
      { 
        return TextField(
          style: txtRoboStyle(20),
          onChanged: bloc.changecsCurrContStatus,  
          decoration: InputDecoration(
          labelStyle: lblRoboStyle(20),
          hintText: 'DM, FL, EL....',
          labelText: 'Current Container Status:',
          errorText: snapshot.error,
          ),
        );
      }
    );    
  }

  Widget ddcontStatus(Bloc bloc){
    return StreamBuilder(
      stream: bloc.csContStatus,
      builder: (context, snapshot) 
        { 
          return FutureBuilder(
            future: fillLookups('ContainerStatus'),
            builder: (context, contStatus)
            { 
              if(contStatus.hasData)
              {       
              return DropdownButton<String>(
              items: contStatus.data
                    .map<DropdownMenuItem<String>>(
                      (LookupItem dropDownStringitem) {
                      return DropdownMenuItem<String>(
                        value: dropDownStringitem.lookupCode,
                        child: Text(dropDownStringitem.lookupDescription,
                                style: txtRoboStyle(20),)
                        );              },
              ).toList(),

              onChanged: bloc.changecsContStatus,
              value: snapshot.data,
              //value: bloc.getBrCode(),
              style: txtRoboStyle(20),
              hint: Text('Container Status:'),
              isExpanded: true,
              elevation: 8,
            );
              } else { return  JumpingDotsProgressIndicator(
  fontSize: 80.0,color: Colors.blue,
);}
            });
    });
  }

  Widget txtFldremarks(Bloc bloc){
    return StreamBuilder(
    stream: bloc.csRemarks,
    builder: (context, snapshot) { 
      return TextField(
        style: txtRoboStyle(20),
        onChanged: bloc.changecsRemarks, 
        keyboardType: TextInputType.multiline,
        maxLines: 2, 
        decoration: InputDecoration(
        labelStyle: lblRoboStyle(20),
        // hintText: 'remarks',
        labelText: 'Remarks:',
        errorText: snapshot.error,
        ),
      );
    }); 
  }

  void saveContainerStatusUpdate(Bloc bloc) async {
    ContStatusModel csUpdate = new ContStatusModel();
    csUpdate = bloc.getContStatusUpdate();
    await csUpdate.updateContainerStatus(csUpdate.contNo, csUpdate.contStatus, csUpdate.remarks, widget.loginInfo.userID)
    .then((isSuccess) { if(isSuccess) { _showAlert(context,'Successfuly Updated Container Status'); Navigator.of(context).pop(); }},
    onError: (e) {_showAlert(context, e.toString());} )
    .catchError((onError) {_showAlert(context, onError.toString());});                      
  }

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