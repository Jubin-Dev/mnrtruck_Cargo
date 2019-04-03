import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:m_n_r/src/blocs/bloc.dart';
import 'package:m_n_r/src/blocs/commonVariables.dart';
import 'package:m_n_r/src/blocs/provider.dart';
import 'package:m_n_r/src/models/usermodel.dart';
import 'package:m_n_r/src/screens/initScreen.dart';
import 'package:m_n_r/src/txtCss.dart';
import 'package:m_n_r/src/models/pregateinmodel.dart';
import 'package:m_n_r/src/screens/imageCollector.dart';
import 'package:m_n_r/src/models/surveymodel.dart';
import 'package:progress_indicators/progress_indicators.dart';

class Survey extends StatefulWidget {

  final LoginUserInfo loginInfo;
  Survey({Key key, @required this.loginInfo}) :super(key: key);  

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SurveyHome();
  }
}

class SurveyHome extends State<Survey> with TxtCss {
  var sizeHW;
  
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
    List<LookupItem> _lookupitem;

    if (!islookUphasdata)
    {
    await lookup.fetchInitData()
      .then((onValue) { lookUpRetrivedata = onValue; islookUphasdata = true;}, 
            onError: (e) {_showAlert(context, e.toString());})
      .catchError((onError) { _showAlert(context, onError.toString());}); //throw Exception(onError);});
    }
    
    (category == 'ALL') ?
      _lookupitem =lookUpRetrivedata.toList()
    :
      // Based on Category it fetches the data
      _lookupitem = lookUpRetrivedata.where((lukups) => 
                        (lukups.lookupCategory == category )).toList();

    return _lookupitem;
  }

  Future<List<LookupItem>> fillRepairCodes(String category) async {
    List<LookupItem> _lookupitem;

    if (!isRepairCodeshasdata)
    {
    await lookup.fetchRepairCodes()
      .then((onValue) { lookUpRepairCodes = onValue; isRepairCodeshasdata = true;}, 
            onError: (e) {_showAlert(context, e.toString());})
      .catchError((onError) { _showAlert(context, onError.toString());}); //throw Exception(onError);});
    }
    
    (category == 'ALL') ?
       _lookupitem = lookUpRepairCodes.toList()
    :
    // Based on Category it fetches the data
     _lookupitem = lookUpRepairCodes.where((lukups) => (lukups.lookupCategory == category )).toList();
    
      return _lookupitem;
  }
 
  Widget build(context) {

    var bloc =Provider.of(context);
    sizeHW = MediaQuery.of(context).size;

    //#JUBIN(3/4/19): made changes below screen for floating button to add survey
    // if (widget.loginInfo.preGInDocNo.isNotEmpty || widget.loginInfo.preGInDocNo != ''
    //     || widget.loginInfo.preGInDocNo != null)
    if (widget.loginInfo.preGInDocNo != null)
      { if (widget.loginInfo.preGInDocNo.isNotEmpty || widget.loginInfo.preGInDocNo != '')
        { getFillLookups(bloc); }
      }    //bloc.fetchPGI2Survey(widget.loginInfo); 

    return MaterialApp(
      title: 'Container Survey',
      home: Scaffold(
        appBar: AppBar(centerTitle: true,
          bottomOpacity: 2.0,
          backgroundColor: Color(0XFF0091EA),
          elevation: 10.0,
            actions: <Widget>[

                IconButton(icon: Icon(Icons.home), iconSize: 40.00, 
                    onPressed: (){Navigator.push(context, new MaterialPageRoute(
                      builder: (context) =>
                      new InitScreen(loginInfo: widget.loginInfo),
                      maintainState: false));},),

                IconButton(icon: Icon(Icons.save),iconSize: 40.00, 
                    onPressed: (){ saveSurvey(bloc);},),],
                  title: Text('Container Survey', style: txtRoboBoldHiLightColor(25, Colors.white),),),
                // floatingActionButton: FloatingActionButton(child: Text('Save', style: txtRoboNormalHiLightColor(20, Colors.white),),
                //                       onPressed: (){ saveSurvey(bloc);}, ),
                body: containerSurveyScreen(context, bloc),
      ),
    );
  }

  Widget containerSurveyScreen(BuildContext context, Bloc bloc) {
    return SingleChildScrollView(child: Card(elevation: 20.0,
    child:Container(
      child: Column(
        children: <Widget>[
          Row( children: <Widget>[
            Expanded(flex: 6, child: _displayPic(context, bloc)),
            Expanded(flex: 3, child: _displayFields(bloc)),
          ],),
          Row(children: <Widget>[ Expanded(flex:10,child: _displayTblHeading() ),],),
          Row(children: <Widget>[ Expanded(flex:10, child: _displayDataTable(bloc),)],)  
        ],),
     ) ));
  }

  Widget _displayPic(BuildContext context, Bloc bloc){
    return GestureDetector(
      onTap: () { _showDialog(context, bloc); },
      child: Container(
        width: ((70.31/100)*sizeHW.width),
        height: ((45/100)*sizeHW.height),
        decoration: new BoxDecoration(
          image: new DecorationImage(
            image: new AssetImage('lib/img/553675_orig.png'),
            fit: BoxFit.contain,
        ),),),
    );
  }
  
  Widget _displayFields(Bloc bloc) {
    return Container( 
          width: ((29.59/100)*sizeHW.width),
          height: ((45/100)*sizeHW.height),
          padding: EdgeInsets.only(right:10.0),
          child: 
            Column( mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[        
                Row(children: <Widget>[ Expanded(flex:4, child: Text('Container No.', style: lblRoboStyle(20)),), 
                                        Expanded(flex:6, child: contNoFld(bloc)),
                                        //Expanded(flex:1, child: IconButton(icon: new Icon(Icons.search),onPressed: (){},))
                                        ]),
                Row(children: <Widget>[ Expanded(flex:4, child: Text('Size / Type', style: lblRoboStyle(20)),), 
                                        Expanded(flex:3, child: contSize(bloc)), SizedBox(width: 10),
                                        Expanded(flex:3, child: contType(bloc))],),                                    
                Row(children: <Widget>[ Expanded(flex:4, child: Text('E.I.R. No.', style: lblRoboStyle(20)),), 
                                        Expanded(flex:6, child: txtEirNo(bloc))],),
                Row(children: <Widget>[ Expanded(flex:4, child: Text('Agent Code', style: lblRoboStyle(20)),), 
                                        Expanded(flex:6, child: agentCode(bloc)),
                                        //Expanded(flex:1, child: IconButton(icon: new Icon(Icons.search),onPressed: (){},))
                                        ],),
                Row(children: <Widget>[ Expanded(flex:4, child: Text('Yard Location', style: lblRoboStyle(20)),), 
                                        Expanded(flex:6, child: yardLoc(bloc))],),
                Row(children: <Widget>[ Expanded(flex:4, child: Text('Remarks', style: lblRoboStyle(20)),), 
                                        Expanded(flex:6, child: remarks(bloc))],),
              ],),
    );
  }
  
  Widget _displayTblHeading(){
    return Container(alignment: Alignment.center,
          decoration: BoxDecoration(color: Colors.lightBlueAccent[700]), 
          child: Text('  Damage Repair Summary',
                  style: txtRoboBoldHiLightColor(25,Colors.white,)),
    );
  }

  Widget _displayDataTable(Bloc bloc) {
    //return Container(height: ((48.5/100)*sizeHW.height), color: Colors.blueAccent,);
      NumScroller numscrl = new NumScroller(height:500.0, width: sizeHW.width, alignment: TextAlign.left,
                                            min:1, max:1000, bloc:bloc,);
      return numscrl;
  }
 
  Future<bool> getFillLookups(Bloc bloc) async{
    bool isFilled =false;
    await bloc.addlookUps(await fillLookups('ALL'));
    await bloc.addlookUps(await fillRepairCodes('ALL'));
    await bloc.fetchPGI2Survey(widget.loginInfo);
    isFilled = true;
    return isFilled;
  }

  Widget contNoFld(Bloc bloc){
    TextEditingController _controller = new TextEditingController();
    return StreamBuilder(
      stream: bloc.surContNo,
      builder: (context, snapshot) 
        { 
          _controller.value = _controller.value.copyWith( text: snapshot.data);
          return TextField(
            textCapitalization: TextCapitalization.characters,
            style: txtRoboStyle(20),
            onChanged: bloc.changesurContNo,
            controller: _controller,
            //keyboardType: TextInputType.emailAddress
            decoration: InputDecoration(
            labelStyle: txtRoboStyle(20),
            hintText: '',
            //labelText: 'Container No.:',
            //errorText: snapshot.error,
            ),
          );
        }
      );
  }

  Widget contSize(Bloc bloc){
    return StreamBuilder(
      stream: bloc.surContSize,
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

              onChanged: bloc.changesurContSize,
              value: snapshot.data,
              //value: bloc.getBrCode(),
              style: txtRoboStyle(20),
              hint: Text('Size'),
              isExpanded: true,
              elevation: 8,
            );
              } else { return JumpingDotsProgressIndicator(
                fontSize: 30.0,color: Colors.blue,);}
            });
    });
  }

  Widget contType(Bloc bloc){
    return StreamBuilder(
      stream: bloc.surContType,
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

              onChanged: bloc.changesurContType,
              value: snapshot.data,
              //value: bloc.getBrCode(),
              style: txtRoboStyle(20),
              hint: Text('Type'),
              isExpanded: true,
              elevation: 8,
            );
            } else {return JumpingDotsProgressIndicator(
              fontSize: 30.0,color: Colors.blue,);}
          });   
      });
  }

  Widget txtEirNo(Bloc bloc){
    TextEditingController _controller = new TextEditingController();
    return StreamBuilder(
      stream: bloc.surEIRNo,
      builder: (context, snapshot) 
        { 
          _controller.value = 
          _controller.value.copyWith(text: snapshot.data);
         return TextField(
            textCapitalization: TextCapitalization.characters,
            style: txtRoboStyle(20),
            onChanged: bloc.changesurERINo,
            controller: _controller,
            //keyboardType: TextInputType.emailAddress
            decoration: InputDecoration(
            labelStyle: txtRoboStyle(20),
            hintText: 'EIR no.',            
            //errorText: snapshot.error,
            ),
          );        }
      );
  }

  Widget yardLoc(Bloc bloc) {
    return StreamBuilder(
      stream: bloc.surYardLoc,  
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
                onChanged: bloc.changesurYardLoc, 
                value: snapshot.data,
                hint: Text('Yard location'),
                style: lblRoboStyle(20),
                isExpanded: true,
                iconSize: 30.0,
                elevation: 8,
              );
            }
            else
            {
              return JumpingDotsProgressIndicator(
              fontSize: 30.0,color: Colors.blue,);
            }
          }
        );
      }
    );

  }

  Widget agentCode(Bloc bloc){
    TextEditingController _controller = new TextEditingController();    
    return StreamBuilder(
      stream: bloc.surAgent,
      builder: (context, snapshot) 
        { 
          _controller.value = 
          _controller.value.copyWith(text: snapshot.data);          
          return TextField(
            style: txtRoboStyle(20),
            onChanged: bloc.changesurAgent,
            controller: _controller,
            //keyboardType: TextInputType.emailAddress
            decoration: InputDecoration(
            labelStyle: txtRoboStyle(20),
            hintText: '',
            labelText: 'Agent Code',
            //errorText: snapshot.error,
            ),
          );
        }
      );
  }

  Widget remarks(Bloc bloc){
  TextEditingController _controller = new TextEditingController();
          
  return StreamBuilder(
    stream: bloc.surRemarks,
    builder: (context, snapshot) 
      { 
        _controller.value = 
        _controller.value.copyWith(text: snapshot.data);        
        return TextField(
          style: txtRoboStyle(20),
          onChanged: bloc.changesurRemarks,
          controller: _controller,
          //keyboardType: TextInputType.emailAddress
          decoration: InputDecoration(
          labelStyle: txtRoboStyle(20),
          //hintText: '8 degrees',
          //labelText: 'Display',
          //errorText: snapshot.error,
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
              } else {return  JumpingDotsProgressIndicator(
                  fontSize: 30.0,color: Colors.blue,);}
            });
        });
    }
 
  Widget showPopUpList(BuildContext contxt, Bloc bloc) {
    return Container( width: 600, height: 250, 
        padding: EdgeInsets.only(left:10.00, right:5.00),
        child:
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(flex:1,child: 
              Container(alignment: Alignment.center,
                        decoration: BoxDecoration(color: Colors.lightBlueAccent[700],), 
                        child: Text('Damage Repair Summary',style: txtRoboNormalHiLightColor(25,Colors.white),))),
            SizedBox(height: 20,),
            Container(child:damageCodeList(bloc)),
            SizedBox(height: 10,),
            Container(child:repairCodeList(bloc)),
            SizedBox(height: 10,),
            Container(child:repairLocation(bloc)),
            SizedBox(height: 10,),
            Row(mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
              SizedBox(width: 350),
              Expanded( child: new MaterialButton(  
                color: Colors.lightBlueAccent[700],
                shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.vertical()),
                child: new Text("Close", style: txtRoboBoldHiLightColor(25, Colors.white)),
                onPressed: () {Navigator.of(contxt).pop();},
                // borderSide: BorderSide(color: Colors.blue),
                //shape: StadiumBorder(),
              )),
              SizedBox(width: 20.0,),
              Expanded( child: new MaterialButton(
                color: Colors.lightBlueAccent[700],
                shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.vertical()),
                child: new Text("Save", style: txtRoboBoldHiLightColor(25, Colors.white)),
                onPressed: () {Navigator.of(contxt).pop(); bloc.addSurDetail();},
                // borderSide: BorderSide(color: Colors.blue),
              )),
              SizedBox(width: 10.0,),
            ],),
          ],
      )
    );
  }

  // to pop up the List of damage repair summary
  void _showDialog(BuildContext context, Bloc bloc) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return SimpleDialog(children: <Widget>[ 
          //showRadioBtn(context),
          showPopUpList(context, bloc),
        ],);
      },
    );
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

  void deleteCodes(Bloc bloc, SurveyDetails damagecode) async {
    // delete selected code...
    await bloc.updateSurDetails(damagecode,'DELETE');
  }

  void showImage(BuildContext context, Bloc bloc, SurveyDetails damagecode) {
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
               child: damagecode.isNetWorkImage ?
               Image.network(damagecode.imageSource, fit: BoxFit.fill,) : 
               Image.asset(damagecode.imageSource)),  
          //Container(color: Colors.blueGrey,height: 20.0, child: Text(damagecode.repairCode)),
          new FlatButton(child: new Text("Close",style: txtRoboStyle(20),),
                         onPressed: () {Navigator.of(context).pop();},
          )
        ],);
      },
    );
    }
  }

  clickPhoto(BuildContext context, Bloc bloc, SurveyDetails damagecode) async{
   
    pic = await Navigator.push(context, new MaterialPageRoute(
          builder: (context) => new ImageCollector()));
    if(pic.path.isNotEmpty) {
    damagecode.imageSource = pic.path;
    await bloc.updateSurDetails(damagecode, 'UPDATE');  }
  }

  saveSurvey(Bloc bloc) async {
    SurveyHeader surHD= new SurveyHeader();
    await surHD.saveSurvey(bloc.getSurvey(widget.loginInfo))
    .then((isSuccess) { if(isSuccess) { _showAlert(context,'Survey Saved'); Navigator.of(context).pop(); }},
    onError: (e) {_showAlert(context, e.toString());} )
    .catchError((onError) {_showAlert(context, onError.toString());});                      
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
final sur = new SurveyHome();

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
    return StreamBuilder(
    stream: bloc.surveyDetails,
    builder:(context, ssSurDtls) {
      List damageCodesList = ssSurDtls.hasData ? ssSurDtls.data : <SurveyDetails>[];
      return DataTable(
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
                DataCell(SizedBox.fromSize(size: Size(200, 50),
                          child:Text(bloc.retriveDescription(damagecode.damageCode.toString(),'Damage'),softWrap: true,))),
                DataCell(SizedBox.fromSize(size: Size(200, 50),
                          child:Text(bloc.retriveDescription(damagecode.repairCode, 'Repair'),softWrap: true))),
                DataCell(SizedBox.fromSize(size: Size(200, 50),
                          child: Text(bloc.retriveDescription(damagecode.repairLocation, 'Repair'),softWrap: true))),
                DataCell(SizedBox.fromSize(size: Size(50, 50),
                  child: damagecode.isNetWorkImage ? 
                    Image.network(damagecode.imageSource) :
                    Image.asset(damagecode.imageSource, alignment: Alignment.centerRight,)), onTap: (){sur.showImage(context, bloc,damagecode);}),
                DataCell(SizedBox.fromSize(size: Size(50, 50),
                          child: IconButton(icon: Icon(Icons.delete),color: Colors.redAccent, iconSize: 30, onPressed: (){sur.deleteCodes(bloc, damagecode);}))),                
              ]
        )).toList()
      );
    });
  }

}

File pic;
//var camFile = 'lib/img/camera.png';
var damageCodes; // =  <DamageRepairSummary>[];
