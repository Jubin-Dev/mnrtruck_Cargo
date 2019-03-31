import 'package:flutter/material.dart';
import 'package:m_n_r/src/blocs/bloc.dart';
import 'package:m_n_r/src/blocs/provider.dart';

class Surveyold extends StatelessWidget{

  final _eorType = ['STRUCTURL','OTHERS'];
  final _cntModel = ['STL','OTHERS'];
  final _yardLoc = ['YARD A','YARD B'];

  final _misAligned = ['misaligned','Straighten & Weld','Re-Align','Fixed'];
  final _cracked = ['cracked',"Weld","Patch","Refurb"];
  final _wearntear = ['WEAR AND TEAR',"Partial Refurb","Remove & Refit","Previous MAintenace"];
  final _bent = ['BENT','STRAIGHTEN','REPLACMENT','Bent One'];

  textStyle(double txtSize) {

      return new TextStyle(color: Colors.blue, 
                          fontSize: txtSize,
                          fontStyle: FontStyle.normal,
                          fontFamily: 'roboto', 
                          fontWeight: FontWeight.normal);
  }

  @override
  Widget build(context){
    final preGInbloc= Provider.of(context);
    final sizeHW = MediaQuery.of(context).size;

    return MaterialApp(
      title: 'Survey',
      home:Scaffold(
        appBar: AppBar(centerTitle: true, title: Text('Container Survey'),),
        body: Stack( 
          children: <Widget>[
            Column( children: <Widget>[
              new SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: 
                new Container( 
                  //height: 300.00, // First row
                  height: ((40/100)*sizeHW.height),
                  //color: Colors.indigoAccent,
                  child:                
                  Row(children:<Widget>[
                  //Expanded( // First Block
                  //flex:7,
                  //  child: 
                    Container(
                      //width: 900.00,            
                      width: ((70.31/100)*sizeHW.width),
                      decoration: new BoxDecoration(
                                image: new DecorationImage(
                                  image: new AssetImage('lib/img/container.jpg'),
                                  fit: BoxFit.fill,
                                ),
                      ),
                      
                      child: new Center( child:  Opacity(
                        opacity: 0.0,
                        child: GestureDetector(
                        onTap: () {
                          _showDialog(context);
                        },
                        child: FittedBox(fit:BoxFit.fitHeight,
                          child: Column( children:<Widget>[
                            Row( children: <Widget>[Expanded(child:Text("RED GREEN BLUE",style: textStyle(25),),)],),
                            Row( children: <Widget>[Expanded(child:Text("RED GREEN BLUE",style: textStyle(25),),)],),                     
                            Row( children: <Widget>[Expanded(child:Text("RED GREEN BLUE",style: textStyle(25),),)],),
                            Row( children: <Widget>[Expanded(child:Text("RED GREEN BLUE",style: textStyle(25),),)],),                     
                            Row( children: <Widget>[Expanded(child:Text("RED GREEN BLUE",style: textStyle(25),),)],),
                            Row( children: <Widget>[Expanded(child:Text("RED GREEN BLUE",style: textStyle(25),),)],),                     
                            Row( children: <Widget>[Expanded(child:Text("RED GREEN BLUE",style: textStyle(25),),)],),
                            Row( children: <Widget>[Expanded(child:Text("RED GREEN BLUE",style: textStyle(25),),)],),                     
                            Row( children: <Widget>[Expanded(child:Text("RED GREEN BLUE",style: textStyle(25),),)],),
                            Row( children: <Widget>[Expanded(child:Text("RED GREEN BLUE",style: textStyle(25),),)],),                     

                            // Text("RED GREEN BLUE"), Text("RED GREEN BLUE"), 
                            // Text("RED GREEN BLUE"),Text("RED GREEN BLUE"),Text("RED GREEN BLUE"),
                          ]),
                        )
                      ))
                    ),  
                    ),
                  //),
                  // Expanded( //Second block
                  //  flex:3,
                  //  child:    
                    Container(
                        //height:300.00,
                        //width: 380.00,
                        width:((29.6875/100)*sizeHW.width),
                          //constraints: BoxConstraints(maxWidth:1280.0, maxHeight:290.0,),
                          //constraints: BoxConstraints(maxWidth:sizeHW.width, maxHeight:290.0,),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,                      
                            children: <Widget>[
                              new SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                                child: 
                              Column(children: <Widget>[        
                                  Row( children: <Widget>[
                                      Expanded(flex:4,child:Text(' Container No.',textAlign: TextAlign.left,style:textStyle(15.00))),
                                      Expanded(flex:1,child:IconButton(icon: new Icon(Icons.search),onPressed: (){_showDialog(context);},)),
                                  ]),
                                  Row( children: <Widget>[
                                      Expanded(flex:4,child:Text(' E O R Type',textAlign: TextAlign.left,style:textStyle(15.00))),
                                      Expanded(flex:6,child:eorType(preGInbloc)),
                                  ]),
                                  Row( children: <Widget>[
                                      Expanded(flex:4,child:Text(' Container Model',textAlign: TextAlign.left,style:textStyle(15.00))),
                                      Expanded(flex:6,child:contModel(preGInbloc)),
                                  ]),
                                  Row( children: <Widget>[
                                      Expanded(flex:4,child:Text(' Agent Code',textAlign: TextAlign.left,style:textStyle(15.00))),
                                      Expanded(flex:1,child:IconButton(icon: new Icon(Icons.search),onPressed: (){},)),
                                      Expanded(flex:6,child:agentCode(preGInbloc)),
                                  ]),
                                  Row( children: <Widget>[
                                      Expanded(flex:4,child:Text(' Yard Location',textAlign: TextAlign.left,style:textStyle(15.00))),
                                      Expanded(flex:6,child:yardLoc(preGInbloc)),
                                  ]),
                                  Row( children: <Widget>[
                                    Expanded(flex:4, child: Text(' Remarks',textAlign: TextAlign.left,style:textStyle(15.00))),
                                    Expanded(flex:6, child: remarks(preGInbloc)),
                                ]),   
                                ],),
                              )
                            ]
                          )
                        ), 
                  //)
                  ],)
                ),
              ),
              //Expanded(flex:1,child: 
              new Container( child: 
              // SingleChildScrollView( 
              //   scrollDirection: Axis.vertical,
              //   child: 
              Column( children: <Widget>[
                Container( //height: 50,
                          height: ((6.65/100)*sizeHW.height),
                          padding: EdgeInsets.only(left: 3.0),
                          alignment: Alignment.centerLeft,
                          decoration: BoxDecoration(color: Colors.lightBlueAccent[200]), 
                          child: Text(' Damage Repair Summary',
                                  style: TextStyle(fontSize: 25,color: Colors.white),),
                ),
              //),
              // Expanded( // Second Row, full container
              //   flex: 9,
              //   child:          
                Container( 
                  //height: 274.00,
                  height: ((36.44/100)*sizeHW.height),
                  child:          
                  dispInGrid(),
                ),
              ],),
              ),
            ],),        
          ]
        ))
    );
  }

  Widget contNoFld(Bloc bloc){
    return StreamBuilder(
      stream: bloc.contNo,
      builder: (context, snapshot) 
        { 
          return TextField(
            textCapitalization: TextCapitalization.characters,
            style: textStyle(15),
            onChanged: bloc.changeContNo,
            //keyboardType: TextInputType.emailAddress
            decoration: InputDecoration(
            labelStyle: textStyle(15),
            hintText: 'PICK4658946',
            //labelText: 'Container No.:',
            errorText: snapshot.error,
            ),
          );
        }
      
      );
    
  }

  Widget eorType(Bloc bloc){
    return StreamBuilder(
      stream: bloc.elecCable,
      builder: (context, snapshot) 
        { 
          return DropdownButton<String>(
            items: _eorType.map((String dropDownStringitem) {
              return DropdownMenuItem<String>(
                    value: dropDownStringitem,
                    child: Text(dropDownStringitem),
                    
                    );
            },
            ).toList(),

            onChanged: bloc.changeElecCable,
            value: snapshot.data,
            //value: bloc.getBrCode(),
            style: textStyle(15),
            hint: Text('SOUND'),
            elevation: 8,
          );
        }
      );
  }

  Widget contModel(Bloc bloc){
    return StreamBuilder(
      stream: bloc.airGuide,
      builder: (context, snapshot) 
        { 
          return DropdownButton<String>(
            items: _cntModel.map((String dropDownStringitem) {
              return DropdownMenuItem<String>(
                    value: dropDownStringitem,
                    child: Text(dropDownStringitem),
                    
                    );
            },
            ).toList(),

            onChanged: bloc.changeairGuide,
            value: snapshot.data,
            //value: bloc.getBrCode(),
            style: textStyle(15),
            hint: Text('SOUND'),
            elevation: 8,
          );
        }
      );
  }

  Widget yardLoc(Bloc bloc){
    return StreamBuilder(
      stream: bloc.hmc,
      builder: (context, snapshot) 
        { 
          return DropdownButton<String>(
            items: _yardLoc.map((String dropDownStringitem) {
              return DropdownMenuItem<String>(
                    value: dropDownStringitem,
                    child: Text(dropDownStringitem),
                    
                    );
            },
            ).toList(),

            onChanged: bloc.changeHmc,
            value: snapshot.data,
            //value: bloc.getBrCode(),
            style: textStyle(15),
            hint: Text('OPEN'),
            elevation: 8,
          );
        }
      );
  }

  Widget agentCode(Bloc bloc){
    return StreamBuilder(
      stream: bloc.stickerTemp,
      builder: (context, snapshot) 
        { 
          return TextField(
            style: textStyle(20),
            onChanged: bloc.changeSticker,
            //keyboardType: TextInputType.emailAddress
            decoration: InputDecoration(
            labelStyle: textStyle(20),
            hintText: 'MEARSK',
            //labelText: 'Sticker',
            errorText: snapshot.error,
            ),
          );
        }
      );
  }

  Widget remarks(Bloc bloc){
    return StreamBuilder(
      stream: bloc.displayTemp,
      builder: (context, snapshot) 
        { 
          return TextField(
            style: textStyle(20),
            onChanged: bloc.changeDisplay,
            //keyboardType: TextInputType.emailAddress
            decoration: InputDecoration(
            labelStyle: textStyle(20),
            hintText: '8 degrees',
            //labelText: 'Display',
            errorText: snapshot.error,
            ),
          );
        }
      
      );
    
  }

  Widget submitButton(Bloc bloc){
    return StreamBuilder(
      stream: bloc.submitFirstValid,
      builder: (context, snapshot) 
      {
        return RaisedButton(
          child: Text('Login'),
          color: Colors.indigo,
          disabledColor: Colors.red,
          textColor: Colors.grey,
                    
          onPressed: !snapshot.hasData ? null : () 
                                { bloc.submit();
                                  // Navigator.push(context, new MaterialPageRoute(
                                  // builder: (context) => new Init_screen()));
                                },
        );
      },  
    );
  }

  void refreshGrid(BuildContext context, List<String> strVal){
    damageRepairSums = <DamageRepairSummary>[
                      DamageRepairSummary(sNo: strVal[0].toString(), damageCode: strVal[1].toString(), 
                              repairLocation: strVal[2].toString(), repairCode: strVal[3].toString()),
                              ];
    dispInGrid();
    Navigator.of(context).pop();
  }

  //Widget dispInGrid(List<String> dataVal)
  Widget dispInGrid(){
      //return Text('here is the problem', style: TextStyle(fontSize: 20,color: Colors.brown),);
      NumScroller numscrl = new NumScroller(height:350.0, width:1280.0, 
                                            alignment: TextAlign.left,
                                            min:1, max:1000,);
      return numscrl;
  } 
  
  Widget showRadioBtn(BuildContext contxt){
    return Container( 
        child:
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            ListTile(
              //leading: new Icon(Icons.radio),
              title: new Text('LEFT SIDE SECTION 2', style: TextStyle(fontWeight: FontWeight.bold, 
                                            fontSize: 25.0, color: Colors.blueAccent)),
              dense: true,
              contentPadding: EdgeInsets.all(10.5),
            ),
            RadioListTile(
              value: 'Misaligned',
              groupValue: 'Misaligned Group',
              onChanged:  (b){_showSubDialog(contxt,_misAligned); },
              activeColor: Colors.blue,
              title: new Text('MISALIGNED', style: TextStyle(fontWeight: FontWeight.bold, 
                                            fontSize: 20.0, color: Colors.blueAccent)),
              dense: true,
              controlAffinity: ListTileControlAffinity.trailing,
            ),
            RadioListTile(
              value: 'Delamination',
              groupValue: 'Delamination Group',
              onChanged:  (b){},
              activeColor: Colors.blue,
              title: new Text('WEAR AND TEAR', style: TextStyle(fontWeight: FontWeight.bold, 
                                            fontSize: 20.0, color: Colors.blueAccent)),
              dense: true,
              controlAffinity: ListTileControlAffinity.trailing,
            ),
            RadioListTile(
              value: 'Cracked',
              groupValue: 'Cracked Group',
              onChanged:  (b){},
              activeColor: Colors.blue,
              title: new Text('CRACKED', style: TextStyle(fontWeight: FontWeight.bold, 
                                            fontSize: 20.0, color: Colors.blueAccent)),
              dense: true,
              controlAffinity: ListTileControlAffinity.trailing,
            ),
            RadioListTile(
              value: 'Bent',
              groupValue: 'Bent Group',
              onChanged: (b){},
              activeColor: Colors.blue,
              title: new Text('BENT', style: TextStyle(fontWeight: FontWeight.bold, 
                                            fontSize: 20.0, color: Colors.blueAccent)),
              dense: true,
              controlAffinity: ListTileControlAffinity.trailing,
            ),
            // new FlatButton( to go back...
            //   child: new Text("Close"),
            //   onPressed: () {Navigator.of(contxt).pop();}
            // ),
          ],
      )
    );
  }

  Widget showListTile(BuildContext contxt){
    return Container( 
        child:
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            ListTile(
              //leading: new Icon(Icons.radio),
              title: new Text('LEFT SIDE SECTION 2', style: TextStyle(fontWeight: FontWeight.bold, 
                                            fontSize: 25.0, color: Colors.blueAccent)),
              dense: true,
              contentPadding: EdgeInsets.all(10.5),
            ),
            ListTile(
              onTap: (){_showSubMenu(contxt, _misAligned);},
              //subtitle: new IconButton(icon: new Icon(Icons.radio),onPressed: (){},),
              title: new Text('MISALIGNED', style: TextStyle(fontWeight: FontWeight.bold, 
                                            fontSize: 20.0, color: Colors.blueAccent)),
              dense: true,
              
            ),

            ListTile(
              onTap: (){_showSubMenu(contxt, _wearntear);},
              title: new Text('WEAR AND TEAR', style: TextStyle(fontWeight: FontWeight.bold, 
                                            fontSize: 20.0, color: Colors.blueAccent)),
              dense: true,
            ),
            ListTile(
              onTap: (){_showSubMenu(contxt, _cracked);},
              title: new Text('CRACKED', style: TextStyle(fontWeight: FontWeight.bold, 
                                            fontSize: 20.0, color: Colors.blueAccent)),
              dense: true,
            ),
            ListTile(
              onTap: (){_showSubMenu(contxt, _bent);},
              title: new Text('BENT', style: TextStyle(fontWeight: FontWeight.bold, 
                                            fontSize: 20.0, color: Colors.blueAccent)),
              dense: true,
            ),
            // new FlatButton( to go back...
            //   child: new Text("Close"),
            //   onPressed: () {Navigator.of(contxt).pop();}
            // ),
          ],
      )
    );
  }

  _showSubDialog(BuildContext contxt, List<String> menuItems){
    return Container( 
        child:
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            ListTile(
              //leading: new Icon(Icons.radio),
              title: new Text(menuItems[0].toUpperCase() , style: TextStyle(fontWeight: FontWeight.bold, 
                                            fontSize: 20.0, color: Colors.blueAccent)),
              dense: true,
              contentPadding: EdgeInsets.all(10.5),
            ),
            ListTile(
              title: new Text(menuItems[1].toUpperCase()  , style: TextStyle(fontWeight: FontWeight.normal, 
                                            fontSize: 20.0, color: Colors.blueAccent)),
              onTap: (){refreshGrid(contxt,['1',menuItems[0].toUpperCase(),'LEFT SIDE SECTION 2',menuItems[1].toUpperCase(),]);},
              dense: true,
            ),
            ListTile(
              title: new Text(menuItems[2].toUpperCase() , style: TextStyle(fontWeight: FontWeight.normal, 
                                            fontSize: 20.0, color: Colors.blueAccent)),
              onTap: (){refreshGrid(contxt,['1',menuItems[0].toUpperCase(),'LEFT SIDE SECTION 2',menuItems[2].toUpperCase(),]);},
              dense: true,
            ),
            ListTile(
              title: new Text(menuItems[3].toUpperCase() , style: TextStyle(fontWeight: FontWeight.normal, 
                                            fontSize: 20.0, color: Colors.blueAccent)),
              onTap: (){refreshGrid(contxt,['1',menuItems[0].toUpperCase(),'LEFT SIDE SECTION 2',menuItems[3].toUpperCase(),]);},
              dense: true,
            ),
          ],
      )
    );
  }

  _showSubMenu(BuildContext context, List<String> strVal){
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return SimpleDialog(children: <Widget>[ 
          //showRadioBtn(context),
          _showSubDialog(context,strVal),
          new FlatButton(child: new Text("Close",style: textStyle(25),),
                         onPressed: () {Navigator.of(context).pop();},
          )
        ],);
      }
    );  
  }

  void _showDialog(BuildContext context) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return SimpleDialog(children: <Widget>[ 
          //showRadioBtn(context),
          showListTile(context),
          new FlatButton(child: new Text("Close",style: textStyle(25),),
                         onPressed: () {Navigator.of(context).pop();},
          )
        ],);
        //return Dialog( child: showRadioBtn(),);
        // return AlertDialog(
        //   title: new Text("Alert Dialog title"),
        //   content: new Text("Alert Dialog body"),
        //   actions: <Widget>[
        //     // usually buttons at the bottom of the dialog
        //     showRadioBtn(),
        //     new FlatButton(
        //       child: new Text("Close"),
        //       onPressed: () {
        //         Navigator.of(context).pop();
        //       },
        //     ),
        //   ],
        // );
      },
    );
  }
}

class NumScroller extends StatefulWidget{
  final int max,min;
  final double height,width;
  final TextAlign alignment;

  NumScroller({this.height,this.width,this.alignment,this.min,this.max, initialOffset});

  @override
  NumScrollerState createState() {
    return new NumScrollerState();
  }
}

class NumScrollerState extends State<NumScroller> {
  final ScrollController controller = ScrollController();

  //https://stackoverflow.com/questions/53190644/flutter-datatable-tap-on-row
  // try for displaing check box
  // static List<DataCell> _dataCells =
  //     ['A', 'B', 'C'].map((c) => DataCell(c=='A' ? Checkbox(value: true, onChanged: (b) {},) : Text(c))).toList();
  //     //['A', 'B', 'C'].map((c) => DataCell(Text(c))).toList();
  // final List<DataRow> _sampleDataRows =
  //     [1, 2, 3, 4, 5, 6, 7, 8, 9,10,11].map((i) => DataRow(cells: _dataCells)).toList();
  // final List<DataColumn> _dataColumns =
  //     [1, 2, 3].map((i) => DataColumn(label: Text(i==1 ? 'Select' : i == 2 ? 'Damage Code' : 'Repair Code'))).toList();

  getValue() => (controller.offset~/widget.height) + widget.min;

  @override
  Widget build(BuildContext context) {
    return new Container(
        decoration: const BoxDecoration(color: Colors.white),
        width: widget.width,
        height: widget.height,
        child: ListView(padding: EdgeInsets.all(20.0), 
          addRepaintBoundaries: true,
          children: <Widget>[
            SingleChildScrollView(
              //scrollDirection: Axis.vertical,
              child: 
                DataTable(
                  //sortColumnIndex: 1,
                  sortAscending: true,             
                  columns: <DataColumn>[
                    DataColumn(
                      label: Expanded(flex:3, child: Text('S.No.', 
                            style: TextStyle(fontSize: 20.00, 
                                            fontFamily: 'Raleway', 
                                            color: Colors.brown)), 
                              ),
                      numeric: false,
                      onSort: (i,b){},
                    ),                         
                    DataColumn(
                      label: Expanded(flex:3, child: Text('Damage Code', 
                            style: TextStyle(fontSize: 20.00, 
                                            fontFamily: 'Raleway', 
                                            color: Colors.brown)), 
                              ),
                      numeric: false,
                      onSort: (i,b){},
                    ),
                    DataColumn(
                      label: Expanded(flex:3, child: Text('Repair Location', 
                            style: TextStyle(fontSize: 20.00, 
                                            fontFamily: 'Raleway', 
                                            color: Colors.brown)), 
                              ),                      numeric: false,
                      onSort: (i,b){},

                    ),
                      DataColumn(
                      label: Expanded(flex:4, child: Text('Repair Code', 
                            style: TextStyle(fontSize: 20.00, 
                                            fontFamily: 'Raleway', 
                                            color: Colors.brown)), 
                              ),                      numeric: false,
                      onSort: (i,b){},

                    ),
                  ],
                  rows: damageRepairSums.map((damageRepairSum) => DataRow(
                        //onSelectChanged: (b){},
                        //selected: false,
                        cells: <DataCell>[
                          DataCell(Text(damageRepairSum.sNo)),
                          DataCell(Text(damageRepairSum.damageCode)),
                          DataCell(Text(damageRepairSum.repairLocation)),
                          DataCell(Text(damageRepairSum.repairCode)),
                        ]
                  )).toList()
                  //Rows manually display no of columns
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
                ),
            ),
          ],//),
          //itemCount: widget.max - widget.min+1,
          controller: controller,
          physics: PageScrollPhysics(),
          itemExtent: widget.height,
      )
    );
  }
}

class DamageRepairSummary{
  String sNo;
  String damageCode;
  String repairLocation;
  String repairCode;

  DamageRepairSummary({this.sNo,this.damageCode,this.repairLocation,this.repairCode});

}

var damageRepairSums = <DamageRepairSummary>[
  DamageRepairSummary(sNo: '1', damageCode: 'WARE AND TARE DMG', repairLocation: 'LEFT SIDE SELECTION 2', repairCode: 'STRAIGHTEN'),
  DamageRepairSummary(sNo: '2', damageCode: 'WARE AND TARE DMG',repairLocation: 'FLOOR LEFT SELECTION', repairCode: 'REPAIR OF FLOOR PANEL'),
  DamageRepairSummary(sNo: '3',damageCode: 'WARE AND TARE DMG',repairLocation: 'DOOR HANDLE', repairCode: 'REPAIR HANDLE'),
 // DamageRepairSummary(sNo: '4',damageCode: 'WARE AND TARE DMG', repairLocation: 'LEFT SIDE SELECTION 2', repairCode: 'STRAIGHTEN'),
 // DamageRepairSummary(sNo: '5',damageCode: 'WARE AND TARE DMG',repairLocation: 'FLOOR LEFT SELECTION', repairCode: 'REPAIR OF FLOOR PANEL'),
  // DamageRepairSummary(sNo: '6',damageCode: 'WARE AND TARE DMG',repairLocation: 'DOOR HANDLE', repairCode: 'REPAIR HANDLE'),
  // DamageRepairSummary(sNo: '7',damageCode: 'WARE AND TARE DMG', repairLocation: 'LEFT SIDE SELECTION 2', repairCode: 'STRAIGHTEN'),
  // DamageRepairSummary(sNo: '8',damageCode: 'WARE AND TARE DMG',repairLocation: 'FLOOR LEFT SELECTION', repairCode: 'REPAIR OF FLOOR PANEL'),
  // DamageRepairSummary(sNo: '9',damageCode: 'WARE AND TARE DMG',repairLocation: 'DOOR HANDLE', repairCode: 'REPAIR HANDLE'), 
  ];