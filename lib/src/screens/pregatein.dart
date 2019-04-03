import 'package:flutter/material.dart';
//import 'package:m_n_r/src/blocs/pregateinbloc.dart';
import 'package:m_n_r/src/blocs/bloc.dart';
import 'package:m_n_r/src/blocs/provider.dart';
import 'package:m_n_r/src/models/usermodel.dart';
import 'package:m_n_r/src/screens/imageCollector.dart';
import 'package:m_n_r/src/txtCss.dart';
import 'dart:io';
import 'package:m_n_r/src/models/pregateinmodel.dart';
import 'package:m_n_r/src/screens/initScreen.dart';
import 'package:m_n_r/src/blocs/commonVariables.dart';
import 'package:progress_indicators/progress_indicators.dart';


class PregateIn extends StatefulWidget {
  final LoginUserInfo loginInfo;
  PregateIn({Key key, @required this.loginInfo}) :super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return PregateInHome();
  }  
}

class PregateInHome extends State<PregateIn> with TxtCss {
  //final TxtCss txtCss = new TxtCss();
  // List<LookupItem> _contSizes, _contTypes, _elecCable, _airGuide, 
  //                  _hmc, _vent, _running, _condition;
  LookUp lookup = new LookUp();
  bool islookUphasdata = false;
  bool isRepairCodeshasdata = false;
  List lookUpRetrivedata;
  List lookUpRepairCodes;
  //List<LookupItem> _lookUps; 

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

  Future<List<LookupItem>> fillRepairCodes(String category) async {
    
    if (!isRepairCodeshasdata)
    {
    await lookup.fetchRepairCodes()
      .then((onValue) { lookUpRepairCodes = onValue; isRepairCodeshasdata = true;}, 
            onError: (e) {_showAlert(context, e.toString());})
      .catchError((onError) { _showAlert(context, onError.toString());}); //throw Exception(onError);});
    }
    // Based on Category it fetches the data
    List<LookupItem> _lookupitem = lookUpRepairCodes.where((lukups) => (lukups.lookupCategory == category )).toList();
       
    return _lookupitem;
  }
  
  @override
  Widget build(context) {
    var preGInbloc = Provider.of(context);
    var sizeHW = MediaQuery.of(context).size;
    double gapHight = 5.0, lblFntSize = 17.00;   
      
    return MaterialApp(
      title: 'Pre Gate-In',
      home:Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(title: Text('Container PreGate-In',style: txtRoboBoldHiLightColor(25.0, Colors.white)), 
          centerTitle: true,bottomOpacity: 2.0,
          backgroundColor: Color(0XFF0091EA),
          elevation: 10.0,
                      actions: <Widget>[
                        IconButton(icon: Icon(Icons.home), iconSize: 40.00, 
                        onPressed: (){Navigator.push(context, new MaterialPageRoute(
                                      builder: (context) =>
                                      new InitScreen(loginInfo: widget.loginInfo),
                                      maintainState: false));},),
                        SizedBox(width: 20.00),              
                        IconButton(icon: Icon(Icons.save), iconSize: 40.00, 
                        onPressed: () { savePreGateIn(preGInbloc);})], ),
        body: new Stack(
          overflow: Overflow.clip,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:<Widget> [
              SingleChildScrollView(
                scrollDirection: Axis.vertical,
                
                child:Card(
                  elevation: 10.0,
                  child:
                    Container(
                  //width: 400.0,
                      width:((30/100) * sizeHW.width), //31.25% of original width
                      padding: EdgeInsets.only(left:3.0, right: 2.0),
                      decoration: new BoxDecoration(
                        color: Colors.white,
                      ),
                    child:
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          contNoFld(preGInbloc),
                          Row(children: <Widget>[
                            Expanded(child:contSize(preGInbloc)),
                            SizedBox(width: gapHight),
                            Expanded(child: contType(preGInbloc)),
                            ],),
                        //SizedBox(height: gapHight),
                        //Text('Reefer Unit',textAlign: TextAlign.left,style:lblRoboStyle(25.00)),
                        Row( children: <Widget>[
                            Expanded(child:Text('Truck No.',textAlign: TextAlign.left,style:lblRoboStyle(lblFntSize))),
                            SizedBox(width: gapHight,),
                            Expanded(child:truckNoFld(preGInbloc)),
                        ]),
                        Row( children: <Widget>[
                            Expanded(child:Text('Truck Category',textAlign: TextAlign.left,style:lblRoboStyle(lblFntSize))),
                            SizedBox(width: gapHight,),
                            Expanded(child:truckCategory(preGInbloc)),
                        ]),
                        Row( children: <Widget>[
                            Expanded(child:Text('Container Status',textAlign: TextAlign.left,style:lblRoboStyle(lblFntSize))),
                            SizedBox(width: gapHight,),
                            Expanded(child:contStatus(preGInbloc)),
                        ]),                                         
                        // Row( children: <Widget>[
                        //     Expanded(child:Text('Electrical Cable',textAlign: TextAlign.left,style:lblRoboStyle(lblFntSize))),
                        //     SizedBox(width: gapHight,),
                        //     Expanded(child:elecCable(preGInbloc)),
                        // ]),
                        Row( children: <Widget>[
                            Expanded(child:Text('Air Guide',textAlign: TextAlign.left,style:lblRoboStyle(lblFntSize))),
                            SizedBox(width: gapHight,),
                            Expanded(child:airGuide(preGInbloc)),
                        ]),                      
                        // Row( children: <Widget>[
                        //     Expanded(child:Text('H M C',textAlign: TextAlign.left,style:lblRoboStyle(lblFntSize))),
                        //     SizedBox(width: gapHight,),
                        //     Expanded(child:hmc(preGInbloc)),
                        // ]),
                        Row( children: <Widget>[
                            Expanded(child:Text('Vent',textAlign: TextAlign.left,style:lblRoboStyle(lblFntSize))),
                            SizedBox(width: gapHight,),
                            Expanded(child:vent(preGInbloc)),
                        ]),
                        Row( children: <Widget>[
                            Expanded(child:Text('Running',textAlign: TextAlign.left,style:lblRoboStyle(lblFntSize))),
                            SizedBox(width: gapHight,),
                            Expanded(child:running(preGInbloc)),
                        ]), 
                        Row( children: <Widget>[
                            Expanded(child:Text('Sticker Temp.',textAlign: TextAlign.left,style:lblRoboStyle(lblFntSize))),
                            SizedBox(width: gapHight,),
                            Expanded(child:stickerTempFld(preGInbloc)),
                        ]),
                        Row( children: <Widget>[
                            Expanded(child:Text('Display Temp.',textAlign: TextAlign.left,style:lblRoboStyle(lblFntSize))),
                            SizedBox(width: gapHight,),
                            Expanded(child:displayTempFld(preGInbloc)),
                          ]),
                        // Row( children: <Widget>[
                        //     Expanded(child:Text('Condition',textAlign: TextAlign.left,style:lblRoboStyle(lblFntSize))),
                        //     SizedBox(width: gapHight,),
                        //     Expanded(child:cntCondition(preGInbloc)),
                        // ]),
                        Row( children: <Widget>[
                            Expanded(child:Text('Additional Requirement',textAlign: TextAlign.left,style:lblRoboStyle(lblFntSize))),
                            SizedBox(width: gapHight,),
                            Expanded(child:additionalReq(preGInbloc)),
                        ]), 
                      ],
                    )
                ),
              )),
                // second column of the screen
              new Container(
                //width: 880.0,
                width: ((68.75/100)*sizeHW.width),
                child: 
                Column( children: <Widget>[
                  Expanded(flex: 4, child: 
                    GestureDetector(
                      onTap: () {
                        _showDialog(context, preGInbloc);
                      },
                      child: Container(                        
                        decoration: new BoxDecoration(
                              image: new DecorationImage(
                              image: new AssetImage('lib/img/emc-container.png'),
                              fit: BoxFit.contain,
                              ),
                      ),),
                    )
                  ),
                  Expanded(flex:0,child: 
                    Container(
                      
                      // elevation: 20.0,
                      // color: Colors.lightBlueAccent[700],
                      // clipBehavior: Clip.antiAliasWithSaveLayer,
                      alignment: Alignment.center,
                              decoration: BoxDecoration(color: Colors.lightBlueAccent[700],), 
                              child: Text('Damage Repair Summary',
                                      style: txtRoboBoldHiLightColor(25,Colors.white,)),
                            ),),
                  Expanded( flex: 4, child: 
                  // display scrollable datatable                    
                    new Container(
                          child: dispInGrid(preGInbloc),
                    ) 
                  )
                ])
              ),
            ])  
          ])
        )
    );
  }

  Widget contNoFld(Bloc bloc){
    return StreamBuilder(
      stream: bloc.contNo,
      builder: (context, snapshot) 
        { 
          return TextField(
            textCapitalization: TextCapitalization.characters,
            style: txtRoboStyle(20),
            onChanged: bloc.changeContNo,  
            onSubmitted: (valu) async { //_showAlert(context, valu);
                                        await bloc.containercheckSum()
                                        .then((onValue) {}, 
                                        onError: (err) {_showAlert(context, err.toString());},)
                                        .catchError((onError) {_showAlert(context, onError.toString());}); },
            decoration: InputDecoration(
            labelStyle: lblRoboStyle(20),
            hintText: 'CONT0000000',
            labelText: 'Container No.',
            errorText: snapshot.error,
            ),
          );
        }
      );
  }

  Widget contSize(Bloc bloc){
    return StreamBuilder(
      stream: bloc.cntSize,
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
              onChanged: bloc.changeSize,
              value: snapshot.data,
              //value: bloc.getBrCode(),
              style: txtRoboStyle(20),
              hint: Text('Size'),
              isExpanded: true,
              elevation: 8,
            );
              } else { return JumpingDotsProgressIndicator(
  fontSize: 30.0,color: Colors.blue,
);}
            });
    });
  }

  Widget contType(Bloc bloc){
    return StreamBuilder(
      stream: bloc.cntType,
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

              onChanged: bloc.changeType,
              value: snapshot.data,
              //value: bloc.getBrCode(),
              style: txtRoboStyle(20),
              hint: Text('Type'),
              isExpanded: true,
              elevation: 8,
            );
            } else {return JumpingDotsProgressIndicator(
  fontSize: 30.0,color: Colors.blue,
);}
          });   
      });
  }

 Widget truckNoFld(Bloc bloc){
    return StreamBuilder(
      stream: bloc.truckNo,
      builder: (context, snapshot) 
        { 
          return TextField(
            textCapitalization: TextCapitalization.none,
            style: txtRoboStyle(20),
            onChanged: bloc.changeTruckNo, 
            decoration: InputDecoration(
            labelStyle: lblRoboStyle(20),
            hintText: '',
            //labelText: 'Truck No.',
            errorText: snapshot.error,
              ),
            );
          }
      );
  }

  Widget truckCategory(Bloc bloc){
    return StreamBuilder(
      stream: bloc.truckCatgory,
      builder: (context, snapshot) 
        { 
        return FutureBuilder(
          future: fillLookups('TruckCategory'),
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
              onChanged: bloc.changeTruckCatgory,
              value: snapshot.data,
              //value: bloc.getBrCode(),
              style: txtRoboStyle(20),
              hint: Text('Category'),
              isExpanded: true,
              elevation: 8,
            );
            } else {return JumpingDotsProgressIndicator(
  fontSize: 30.0,color: Colors.blue,
);}
          });   
      });
  }

  Widget contStatus(Bloc bloc){
    return StreamBuilder(
      stream: bloc.contStatus,
      builder: (context, snapshot) 
        { 
        return FutureBuilder(
          future: fillLookups('ContainerStatus'),
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
              onChanged: bloc.changeContStatus,
              value: snapshot.data,
              //value: bloc.getBrCode(),
              style: txtRoboStyle(20),
              hint: Text('Status'),
              isExpanded: true,
              elevation: 8,
            );
            } else {return JumpingDotsProgressIndicator(
  fontSize: 30.0,color: Colors.blue,
);}
          });   
      });
  }

  Widget elecCable(Bloc bloc){
    return StreamBuilder(
      stream: bloc.elecCable,
      builder: (context, snapshot) 
        { 
        return FutureBuilder(
          future: fillLookups('ElectricalCable'),
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

              onChanged: bloc.changeElecCable,
              value: snapshot.data,
              //value: bloc.getBrCode(),
              style: txtRoboStyle(20),
              hint: Text('Elec Cable'),
              isExpanded: true,
              elevation: 8,
            );
            } else {return JumpingDotsProgressIndicator(
  fontSize: 30.0,color: Colors.blue,
);}
          });   
      });
  }

  Widget airGuide(Bloc bloc){
    return StreamBuilder(
      stream: bloc.airGuide,
      builder: (context, snapshot) 
        { 
        return FutureBuilder(
          future: fillLookups('AirGuide'),
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

              onChanged: bloc.changeairGuide,
              value: snapshot.data,
              //value: bloc.getBrCode(),
              style: txtRoboStyle(20),
              hint: Text('Air Giude'),
              isExpanded: true,
              elevation: 8,
            );
            } else {return JumpingDotsProgressIndicator(
  fontSize: 30.0,color: Colors.blue,
);}
          });       
    });
  }

  //HMC
  Widget hmc(Bloc bloc){
    return StreamBuilder(
      stream: bloc.hmc,
      builder: (context, snapshot) 
      { 
        return FutureBuilder(
          future: fillLookups('HMC'),
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

              onChanged: bloc.changeHmc,
              value: snapshot.data,
              //value: bloc.getBrCode(),
              style: txtRoboStyle(20),
              hint: Text('HMC'),
              isExpanded: true,
              elevation: 8,
            );
            } else {return JumpingDotsProgressIndicator(
  fontSize: 30.0,color: Colors.blue,
);}
          });
      });
  }

  Widget vent(Bloc bloc){
    return StreamBuilder(
      stream: bloc.vent,
      builder: (context, snapshot) 
        { 
        return FutureBuilder(
          future: fillLookups('Vent'),
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

              onChanged: bloc.changeVent,
              value: snapshot.data,
              //value: bloc.getBrCode(),
              style: txtRoboStyle(20),
              hint: Text('Vent'),
              isExpanded: true,
              elevation: 8,
            );
            } else {return JumpingDotsProgressIndicator(
  fontSize: 30.0,color: Colors.blue,
);}
          });
      });
  }

  Widget running(Bloc bloc) {
    return StreamBuilder(
      stream: bloc.running,
      builder: (context, snapshot) 
        { 
        final sslookUp = ['YES', 'NO'];
          return DropdownButton<String>(
            items: sslookUp.map((String dropDownStringitem) {
              return DropdownMenuItem<String>(
                    value: dropDownStringitem,
                    child: Text(dropDownStringitem,style: txtRoboStyle(20),),
                    
                    );
            },
            ).toList(),

        onChanged: bloc.changeRunning,
        value: snapshot.data,
        //value: bloc.getBrCode(),
        style: txtRoboStyle(20),
        hint: Text('running'),
        isExpanded: true,
        elevation: 8,
      );

      });
  }

  Widget stickerTempFld(Bloc bloc){
    return StreamBuilder(
      stream: bloc.stickerTemp,
      builder: (context, snapshot) 
        { 
          return TextField(
            style: txtRoboStyle(20),
            onChanged: bloc.changeSticker,
            keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),
            decoration: InputDecoration(
            labelStyle: txtRoboStyle(20),
            hintText: '5 degrees',
            //labelText: 'Sticker',
            errorText: snapshot.error,
            ),
          );
        }
      );
  }

  Widget displayTempFld(Bloc bloc){
    return StreamBuilder(
      stream: bloc.displayTemp,
      builder: (context, snapshot) 
        { 
          return TextField(
            style: txtRoboStyle(20),
            onChanged: bloc.changeDisplay,
            keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),
            decoration: InputDecoration(
            labelStyle: txtRoboStyle(20),
            hintText: '8 degrees',
            //labelText: 'Display',
            errorText: snapshot.error,
            ),
          );
        }
      
      );
  }

  //ContainerCondition
  Widget cntCondition(Bloc bloc){
    return StreamBuilder(
      stream: bloc.contCondition,  
      builder: (context, snapshot) 
      { 
        return FutureBuilder(
          future: fillLookups('ContainerCondition'),
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

              onChanged: bloc.changeCondition,
              value: snapshot.data,
              //value: bloc.getBrCode(),
              style: txtRoboStyle(20),
              hint: Text('Condition'),
              isExpanded: true,
              //iconSize: 35.0,
              elevation: 16,
            );
            } else {return JumpingDotsProgressIndicator(
  fontSize: 30.0,color: Colors.blue,
);}
          });
      });
  }

  Widget additionalReq(Bloc bloc){
    return StreamBuilder(
      stream: bloc.additionalReq,
      builder: (context, snapshot) 
        { 
          return TextField(
            style: txtRoboStyle(20),
            onChanged: bloc.changeAddReq,
            //keyboardType: TextInputType.emailAddress
            decoration: InputDecoration(
            labelStyle: txtRoboStyle(20),
            hintText: 'additional requirements',
            //labelText: 'Display',
            errorText: snapshot.error,
            ),
          );
        }
      );
  }

  Widget damageCodeList(Bloc bloc) {
      return StreamBuilder(
        stream: bloc.damageCode,  
        builder: (context, snapshot) 
        { 
          return FutureBuilder(
            future: fillLookups('DamageCode'),
            builder: (context, sslookUp)
            { 
              if(sslookUp.hasData)
              {              
                bloc.addlookUps(sslookUp.data);
                return Expanded(child:DropdownButton<String>(
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

                onChanged: bloc.changeDamageCode,
                value: snapshot.data,
                //value: bloc.getBrCode(),
                style: txtRoboStyle(20),
                hint: Text('Damage Code List'),
                isExpanded: true,
                iconSize: 40,
                elevation: 8,
              ));
              } else {return JumpingDotsProgressIndicator(
  fontSize: 30.0,color: Colors.blue,
);}
            });
        });
    }

  Widget repairCodeList(Bloc bloc) {
      return StreamBuilder(
        stream: bloc.repairCode,  
        builder: (context, snapshot) 
        { 
          return FutureBuilder(
            //future: fillRepairCodes('RepairCode'), RepairLocation
            future: fillRepairCodes('RepairCode'), 
            builder: (context, sslookUp)
            { 
              if(sslookUp.hasData)
              { bloc.addlookUps(sslookUp.data);              
                return Expanded(child: DropdownButton<String>(
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

                onChanged: bloc.changeRepairCode,
                value: snapshot.data,
                //value: bloc.getBrCode(),
                style: txtRoboStyle(20),
                hint: Text('Repair Code List'),
                isExpanded: true,
                iconSize: 40,              
                elevation: 8,
              ));
              } else {return JumpingDotsProgressIndicator(
  fontSize: 30.0,color: Colors.blue,
);}
            });
        });
    }

  Widget repairLocation(Bloc bloc) {
      return StreamBuilder(
        stream: bloc.repairLocation,  
        builder: (context, snapshot) 
        { 
          return FutureBuilder(
            future: fillRepairCodes('RepairLocation'),
            builder: (context, sslookUp)
            { 
              if(sslookUp.hasData)
              { bloc.addlookUps(sslookUp.data);               
                return Expanded(child: DropdownButton<String>(
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

                onChanged: bloc.changeRepairLoc,
                value: snapshot.data,
                //value: bloc.getBrCode(),
                style: txtRoboStyle(20),
                hint: Text('Repair Location List'),
                isExpanded: true,
                iconSize: 40,              
                elevation: 8,
              ));
              } else {return JumpingDotsProgressIndicator(
  fontSize: 30.0,color: Colors.blue,
);}
            });
        });
    }

  savePreGateIn(Bloc bloc) async {
    PreGateInHd pGIHd= new PreGateInHd();
    await pGIHd.savePGIn(bloc.getPreGateIn(widget.loginInfo))
    .then((isSuccess) { if(isSuccess) { _showAlert(context,'Pre Gate-In Saved'); Navigator.of(context).pop(); }},
    onError: (e) {_showAlert(context, e.toString());} )
    .catchError((onError) {_showAlert(context, onError.toString());});                      
  }
  
  void refreshGrid(BuildContext context, List<String> strVal) {
    damageCodes = <DamageRepairSummary>[];
                      // DamageRepairSummary(sNo: strVal[0].toString(), 
                      //         damageLocation: strVal[1].toString(), 
                      //         repairCode: strVal[2].toString(), 
                      //         image: Image.asset(camFile, width:30.00))
                      //         ];
     //dispInGrid(); need to pass bloc asparamater
    Navigator.of(context).pop();
  }

  //Widget dispInGrid(List<String> dataVal)
  Widget dispInGrid(Bloc bloc) {
      //return Text('here is the problem', style: txtRoboStyle(fontSize: 20,color: Colors.brown),);
      NumScroller numscrl = new NumScroller(height:500.0, width:880.0, 
                                            alignment: TextAlign.left,
                                            min:1, max:1000, bloc:bloc,);
      return numscrl;
  } 
  
  Widget showPopUpList(BuildContext contxt, Bloc bloc) {
    return Container( width: 700, height: 250, 
        // decoration: BoxDecoration(border: Border.all(color: Colors.blueGrey), 
        //               shape: BoxShape.rectangle, borderRadius: BorderRadius.circular(5.0)),
        padding: EdgeInsets.only(left:10.00, right:5.00),
        //elevation: 24,
        child:
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(flex:0,child: 
              Container(alignment: Alignment.center,
                        decoration: BoxDecoration(color: Colors.lightBlueAccent[700],), 
                        child: Text('Damage Repair Summary'
                        ,style: txtRoboNormalHiLightColor(25,Colors.white),))),
            SizedBox(height: 20,),
            Container(child:damageCodeList(bloc)),
            SizedBox(height: 10,),
            Container(child:repairCodeList(bloc)),
            SizedBox(height: 10,),
            Container(child:repairLocation(bloc)),
            SizedBox(height: 10,),
            Row(mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
              SizedBox(width: 400),
              Expanded( child: new MaterialButton(
                color: Colors.lightBlueAccent[700],  
                // shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.vertical()),
                child: new Text("Close", style: txtRoboBoldHiLightColor(25, Colors.white)),
                onPressed: () {Navigator.of(contxt).pop();},
                // borderSide: BorderSide(color: Colors.blue),
                //shape: StadiumBorder(),
              )),
              SizedBox(width: 20.0,),
              Expanded( child: new MaterialButton(
                color: Colors.lightBlueAccent[700],
                // shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.vertical()),
                child: new Text("Save", style: txtRoboBoldHiLightColor(25, Colors.white)),
                onPressed: () {Navigator.of(contxt).pop(); bloc.addPGInDetail();},
                // borderSide: BorderSide(color: Colors.blue),
              )),
              SizedBox(width: 10.0,),
            ],),
          ],
      )
    );
  }

  void _showDialog(BuildContext context, Bloc bloc) {
    // flutter defined function
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        // return object of type Dialog
        return SimpleDialog(
          // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0),),
          children: <Widget>[ 
          //showRadioBtn(context),
          showPopUpList(context, bloc),
          // new FlatButton(child: new Text("Close",style: txtRoboBoldHiLightColor(25, Colors.blueAccent)),
          //                onPressed: () {Navigator.of(context).pop();},
          //)
        ],);
      },
    );
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

  void deleteCodes(Bloc bloc, PreGateInDt damagecode) async {
    // delete selected code...
    await bloc.updatePGIDetails(damagecode,'DELETE');
  }

  void showImage(BuildContext context, Bloc bloc, PreGateInDt damagecode) {
    // flutter defined function
    print(damagecode.repairCode + ' / ' + damagecode.imageSource.toString());
    print(damagecode.repairCode + ' / ' + Image.asset(StaticConst.camFile).toString()); 
    
    //if(damagecode.image.toString() == Image.asset(camFile).toString())
    if(damagecode.imageSource == StaticConst.camFile)
    {
    clickPhoto(context, bloc, damagecode);
    }
    else
    {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return SimpleDialog(children: <Widget>[ 
          //showRadioBtn(context),
          Card(elevation: 10,
               child: Image.asset(damagecode.imageSource)),  
          //Container(color: Colors.blueGrey,height: 20.0, child: Text(damagecode.repairCode)),
          new FlatButton(child: new Text("Close",style: txtRoboStyle(20),),
                         onPressed: () {Navigator.of(context).pop();},
          )
        ],);
      },
    );
    }
  }
  clickPhoto(BuildContext context, Bloc bloc, PreGateInDt damagecode) async{
   
    pic = await Navigator.push(context, new MaterialPageRoute(
          builder: (context) => new ImageCollector()));
    if(pic.path.isNotEmpty) {
    damagecode.imageSource = pic.path;
    await bloc.updatePGIDetails(damagecode,'UPDATE');  }
  }
}
class NumScroller extends StatefulWidget{
  final int max,min;
  final double height,width;
  final TextAlign alignment;
  final bloc;

  NumScroller({this.height,this.width,this.alignment,this.min,this.max, initialOffset, this.bloc});

  @override
  NumScrollerState createState() {
    return new NumScrollerState();
  }
}

class NumScrollerState extends State<NumScroller> with TxtCss {
  final ScrollController controller = ScrollController();
  final pgi = new PregateInHome();

  //https://stackoverflow.com/questions/53190644/flutter-datatable-tap-on-row
  // try for displaing check box

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
              child: dataTblDRCodeUpdate(widget.bloc),
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
    return StreamBuilder(
      stream: bloc.preGateInDtls,
      builder:(context, ssPGIDtls) {
        List damageCodesList = ssPGIDtls.hasData ? ssPGIDtls.data : <PreGateInDt>[];
        return Card(elevation: 10.0,
          child:DataTable(
          sortAscending: false,
          columns: <DataColumn>[
            DataColumn(label: Expanded(child: Text('Damage Code', style: lblRoboStyle(20))), 
              numeric: false, onSort: (i,b){},),
            DataColumn(label: Expanded(child:Text('Repair Code', style: lblRoboStyle(20))), 
              numeric: false, onSort: (i,b){},),
            DataColumn(label: Expanded(child:Text('Repair Location', style: lblRoboStyle(20))), 
              numeric: false, onSort: (i,b){},),
            DataColumn(label: Expanded(child: Text('Picture', style: lblRoboStyle(20))), 
              numeric: false, onSort: (i,b){},),
            DataColumn(label: Expanded(child: Text('', style: lblRoboStyle(20))), 
              numeric: false, onSort: (i,b){},),              
          ],
          rows: damageCodesList.map((damagecode) => DataRow(
                //onSelectChanged: (b){},
                //selected: false,
                cells: <DataCell>[
                  DataCell(SizedBox.fromSize(size: Size(150, 50),
                            child:Text(bloc.retriveDescription(damagecode.damageCode.toString(),'Damage'),softWrap: true,))),
                  DataCell(SizedBox.fromSize(size: Size(175, 50),
                            child:Text(bloc.retriveDescription(damagecode.repairCode, 'Repair'),softWrap: true))),
                  DataCell(SizedBox.fromSize(size: Size(175, 50),
                            child: Text(bloc.retriveDescription(damagecode.repairLocation, 'Repair'),softWrap: true))),
                  DataCell(SizedBox.fromSize(size: Size(70, 50),
                            child: Image.asset(damagecode.imageSource, alignment: Alignment.center,),),
                            onTap: (){pgi.showImage(context, bloc,damagecode);}) ,
                  DataCell(SizedBox.fromSize(size: Size(50, 50),
                            child: IconButton(icon: Icon(Icons.delete),color: Colors.redAccent,disabledColor: Colors.grey,tooltip: 'Delete', iconSize: 30,
                             onPressed: (){pgi.deleteCodes(bloc, damagecode);}))),
                ]
          )).toList()
        ));
          //Rows manually display no of 1 row, 2 columns
          // rows: <DataRow>[
          //   DataRow(
          //     cells: <DataCell>[
          //       DataCell(Text('LTS1')),
          //       DataCell(Text('DAMAGED'))
          //     ]
          //   )
          // ],
        // rows: _sampleDataRows,
        // columns: _dataColumns,

      });
  }

}

File pic;
//var camFile = 'lib/img/camera.png';
var damageCodes; // =  <DamageRepairSummary>[];
  // <DamageRepairSummary>[
  // DamageRepairSummary(sNo: '1', damageLocation: 'LTS1', repairCode: 'MISALIGNED', 
  //                     image: Image.asset(camFile,width: 30.00)),
  // DamageRepairSummary(sNo: '2', damageLocation: 'LTS2', repairCode: 'DELAMINATION', 
  //                     image: Image.asset(camFile,width: 30.00)),
  // DamageRepairSummary(sNo: '3', damageLocation: 'LTS1', repairCode: 'CRACKED', 
  //                     image: Image.asset(camFile, width:30.00)),
  // ];