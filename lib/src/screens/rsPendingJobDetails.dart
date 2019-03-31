import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:m_n_r/src/models/pregateinmodel.dart';
import 'package:m_n_r/src/txtCss.dart';
import 'package:m_n_r/src/models/usermodel.dart';
import 'package:m_n_r/src/blocs/bloc.dart';
import 'package:m_n_r/src/blocs/provider.dart';
import 'package:http/http.dart' as http;
import 'package:m_n_r/src/models/reachStackerModel.dart';

class RSPendingJobDetails extends StatefulWidget {
  
  final LoginUserInfo loginInfo;
  final ReachStacker rsItem;
  RSPendingJobDetails({Key key, @required this.loginInfo, @required this.rsItem}) :super(key: key);  

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return RSPendingJobDetailsHome();
  }
}

class RSPendingJobDetailsHome extends State<RSPendingJobDetails> with TxtCss {

  LookUp lookup = new LookUp();
  bool islookUphasdata = false;
  bool isRepairCodeshasdata = false;
  List lookUpRetrivedata;
  List lookUpRepairCodes;

  Future<List<Yard>> fetchYards(int branchID) async {
    
    var url = 'http://dmsapi.logiconglobal.com/api/master/yard/branchyardlist/$branchID';
    var response = await http.get(url, headers: {"Accept": "application/json",
                                            "content-type": "application/json"});
    if (response.statusCode == 200)
    { 
      List yards = json.decode(response.body);
      print(response.body);
      List<Yard> _yards = yards.map((yard) => new Yard.fromJson(yard)).toList();

      print('yards Length: ' + yards.length.toString());
      return _yards;
    } else
      throw Exception('Failed to load Yard');      
  }

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
    var bloc =Provider.of(context);
    return MaterialApp(
      title: 'Reach Stacker Equipment Job Update',
      home: Scaffold(
        appBar: AppBar(centerTitle: true,
        title: Text('Reach Stacker Equipment Job Update', style: txtRoboBoldHiLightColor(30,Colors.white),),),
        body: rsPJDetail(bloc),
      ),
    );
  }

  Widget rsPJDetail(Bloc bloc) {
    return Row(children: <Widget>[
      Expanded(flex:2, child:Container()),
      Expanded(flex:6, child:_displayFeilds(bloc)),
      Expanded(flex:2, child:Container())      
    ],);
  }

  Widget _displayFeilds(Bloc bloc){
    
    bloc.fetchRSPJobDetail(widget.rsItem);

    return  SingleChildScrollView( child:
      Container( //height: 400.00, width:600.00 ,
      alignment: Alignment.center,
      decoration: BoxDecoration( border: Border.all(color: Colors.blueGrey ,width: 5)),
      padding: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          txtfldContNo(bloc),
          SizedBox(height: 10.00),
          ddcontSize(bloc),
          SizedBox(height: 10.00),
          ddcontType(bloc),
          SizedBox(height: 10.00),
          txtAgentCode(bloc),
          SizedBox(height: 10.00),
          txtActivity(bloc),
          SizedBox(height: 10.00),
          ddYardLoc(bloc),
          SizedBox(height: 10.00),

          Row(mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
            SizedBox(width: 250),
            Expanded( child: new OutlineButton(  
              shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.vertical()),
              child: new Text("<< Back <<", style: txtRoboBoldHiLightColor(25, Colors.lightBlueAccent)),
              onPressed: () {Navigator.of(context).pop();},
              borderSide: BorderSide(color: Colors.blue),
              //shape: StadiumBorder(),
            )),
            SizedBox(width: 20.0,),
            Expanded( child: new OutlineButton(
              shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.vertical()),
              child: new Text("Save", style: txtRoboBoldHiLightColor(25, Colors.lightBlueAccent)),
              onPressed: () { saveRSPendingJob(bloc); Navigator.of(context).pop();},
              borderSide: BorderSide(color: Colors.blue),
            )),
            SizedBox(width: 10.0,),
          ],),
        ],
      ),
    ));
  }

  Widget txtfldContNo(Bloc bloc){
    TextEditingController _controller = TextEditingController();
    return StreamBuilder(
      stream: bloc.rsContNo,
      builder: (context, snapshot) 
        { 
          _controller.value =
          _controller.value.copyWith(text: snapshot.data);
          return TextField(
            textCapitalization: TextCapitalization.characters,
            style: txtRoboStyle(20),
            onChanged: bloc.changersContNo,  
            controller: _controller,
            decoration: InputDecoration(
            labelStyle: lblRoboStyle(20),
            hintText: '',
            labelText: 'Container No.:',
            errorText: snapshot.error,
            
            ),
          );
        }
      
      );
    
  }
  
  Widget ddcontSize(Bloc bloc){
    return StreamBuilder(
      stream: bloc.rsContSize,
      builder: (context, snapshot) 
        { 
          return FutureBuilder(
            future: fillLookups('EquipmentSize'),
            builder: (context, contSizes)
            { 
              if(contSizes.hasData)
              {       
                return DropdownButton<String>(
              items: contSizes.data.map<DropdownMenuItem<String>>(
                                  (LookupItem dropDownStringitem) {
                                    return DropdownMenuItem<String>(
                                          value: dropDownStringitem.lookupCode,
                                          child: Text(dropDownStringitem.lookupDescription,
                                                  style: txtRoboStyle(20),)
                                          );
              },
              ).toList(),

              onChanged: bloc.changersContSize,
              value: snapshot.data,
              //value: bloc.getBrCode(),
              style: txtRoboStyle(20),
              hint: Text('Size:'),
              isExpanded: true,
              elevation: 8,
            );
              } else { return CircularProgressIndicator();}
            });
    });
  }

  Widget ddcontType(Bloc bloc){
    return StreamBuilder(
      stream: bloc.rsContType,
      builder: (context, snapshot) 
      { 
        return FutureBuilder(
          future: fillLookups('EquipmentType'),
          builder: (context, sslookUp)
          { 
            if(sslookUp.hasData)
            {               
              return DropdownButton<String>(
              items: sslookUp.data
                .map<DropdownMenuItem<String>>(
                  (LookupItem dropDownStringitem) {
                    return DropdownMenuItem<String>(
                      value: dropDownStringitem.lookupCode,
                      child: Text(dropDownStringitem.lookupDescription,
                              style: txtRoboStyle(20),)
                      );
                  },
              ).toList(),

              onChanged: bloc.changersContType,
              value: snapshot.data,
              //value: bloc.getBrCode(),
              style: txtRoboStyle(20),
              hint: Text('Type:'),
              isExpanded: true,
              elevation: 8,
            );
            } else {return CircularProgressIndicator();}
          });   
      });
  }

  Widget txtAgentCode(Bloc bloc){
    TextEditingController _controller = TextEditingController();
    return StreamBuilder(
    stream: bloc.rsAgentCode,
    builder: (context, snapshot) {
      _controller.value = _controller.value.copyWith(text: snapshot.data);
      return TextField(
        style: txtRoboStyle(20),
        onChanged: bloc.changersAgentCode,  
        controller: _controller,
        decoration: InputDecoration(
        labelStyle: lblRoboStyle(20),
        hintText: 'agent code',
        labelText: 'Agent Code:',
        errorText: snapshot.error,
        ),
      );
    }); 
  }

  Widget txtActivity(Bloc bloc){
  return StreamBuilder(
      stream: bloc.rsActivity,
      builder: (context, snapshot) 
      { 
        return FutureBuilder(
          future: fillLookups('TruckActivityIndicator'),
          builder: (context, sslookUp)
          { 
            if(sslookUp.hasData)
            {               
              return DropdownButton<String>(
              items: sslookUp.data
                .map<DropdownMenuItem<String>>(
                  (LookupItem dropDownStringitem) {
                    return DropdownMenuItem<String>(
                      value: dropDownStringitem.lookupID.toString(),
                      child: Text(dropDownStringitem.lookupDescription,
                              style: txtRoboStyle(20),)
                      );
                  },
              ).toList(),

              onChanged: bloc.changersActivity,
              value: snapshot.data,
              //value: bloc.getBrCode(),
              style: txtRoboStyle(20),
              hint: Text('Type:'),
              isExpanded: true,
              elevation: 8,
            );
            } else {return CircularProgressIndicator();}
          });   
      });
    }

  Widget ddYardLoc(Bloc bloc) {
    return StreamBuilder(
      stream: bloc.rsYardLoc,  
      builder: (context, snapshot) 
      { 
        //print('entered 2nd yard stream:');
        return FutureBuilder(
          future: fetchYards(widget.loginInfo.branchId),
          builder: (context, yardsData){
            if (yardsData.hasData)
            {
              return DropdownButton<String>(
                items: yardsData.data
                      .map<DropdownMenuItem<String>>(
                        (Yard dropDownStringitem) {
                          return DropdownMenuItem<String>(
                                value: dropDownStringitem.yardCode,
                                child: Text(dropDownStringitem.description,
                                        style: txtRoboStyle(20),)
                                );
                        },
                      ).toList(),
                onChanged: bloc.changersYardLoc, 
                value: snapshot.data,
                hint: Text('Yard location:'),
                style: lblRoboStyle(20),
                isExpanded: true,
                iconSize: 30.0,
                elevation: 8,
              );
            }
            else
            {
              return CircularProgressIndicator();
            }
          }
        );
      }
    );

  }

  void saveRSPendingJob(Bloc bloc) async {
    ReachStackerDetail rsDetails = new ReachStackerDetail();
    await rsDetails.saveRSPendingJob(bloc.getRSDetail(widget.loginInfo, widget.rsItem))
    .then((isSuccess) { if(isSuccess) { _showAlert(context,'Reach Stacker Equipment Saved'); Navigator.of(context).pop(); }},
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