import 'dart:io';
import 'package:flutter/material.dart';
import 'package:m_n_r/src/screens/pregatein.dart';
import 'package:m_n_r/src/screens/surveyPGIList.dart';
import 'package:m_n_r/src/txtCss.dart';
import 'package:m_n_r/src/models/usermodel.dart';
import 'package:m_n_r/src/screens/containerstatus.dart';
import 'package:m_n_r/src/screens/rsPendingEquipJobs.dart';
import 'package:m_n_r/src/screens/testingScreen.dart';



class InitScreen extends StatelessWidget {

  final LoginUserInfo loginInfo;
  InitScreen({Key key, @required this.loginInfo}) :super(key: key);

  final TxtCss txtCss = new TxtCss();

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
        title: 'Container Operations',
        home:Scaffold(
          appBar: AppBar(centerTitle: true,
          bottomOpacity: 2.0,
          backgroundColor: Color(0XFF0091EA),
          elevation: 10.0,
                  actions: <Widget>[ 
                  IconButton(icon: new Image.asset("lib/img/logout.png"),color: Colors.white,tooltip: 'Exit MNR',iconSize: 40.0,
                  onPressed: (){exit(0);},)],
                  title: Text('Maintenance And Repair',style: txtCss.txtRoboBoldHiLightColor(25.0, Colors.white), textAlign: TextAlign.center,)),
          body: _dispItems(context,2),
        )
    );
  }

  Widget _dispItems(BuildContext context, int countVal)
  {
    var size = MediaQuery.of(context).size;

    /*24 is for notification bar on Android*/
    final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
    final double itemWidth = size.width / 2;

    return new Container(
      //decoration: new BoxDecoration(border: Border.all(color: Colors.yellowAccent,width:5.0),),
      margin: EdgeInsets.only(left:100.00, right: 100.00),
      alignment: Alignment.center,
      child: GridView.count(
      crossAxisSpacing: 50.0,
      mainAxisSpacing: 30.0,
      // Create a grid with <countVal> columns. If you change the scrollDirection to
      // horizontal, this would produce 2 rows.
        crossAxisCount: countVal,
        shrinkWrap: true,
        childAspectRatio: (itemWidth/itemHeight),
        controller: new ScrollController(keepScrollOffset: true),
        children:<Widget> [
          cardDisp(context,'Pre Gate-In','lib/img/Pregatein.jpg'),
          cardDisp(context,'Survey','lib/img/survey.png'),
          cardDisp(context,'Container Status','lib/img/containerSurvey.jpeg'),
          cardDisp(context,'Reach Stacker','lib/img/report.png'),
        ]
      )
    );
  }

  Widget cardDisp(BuildContext context,String screen, String imgName)
  {
    var size = MediaQuery.of(context).size;

    return Container( 
      //decoration: new BoxDecoration(border: Border.all(color: Colors.grey,width:1.0),),
      padding: EdgeInsets.only(left:50.00, right:50),
      child:
          Card(
            elevation: 20.0,
            // decoration: new BoxDecoration(border: Border.all(color: Colors.blueGrey,width:1.0),),
            //child: FittedBox(fit:BoxFit.fitHeight,
            child:
            Column(children: <Widget>[
                Card(clipBehavior: Clip.antiAlias,
                     elevation: 20.0, 
                     child: Image.asset(imgName,
                        height: ((16.75/100)* size.height), 
                        width: (((31.25/100)* size.width)-75.00), fit: BoxFit.fill,),
                ),

                ListTile(
                    //isThreeLine: true,
                    //contentPadding: EdgeInsets.only(top: 10),
                    title:Text(screen, style: txtCss.txtRoboBoldHiLightColor(35,Colors.lightBlue), textAlign: TextAlign.left,),
                    subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[ _screenTitle(screen), _screenSubTitle(screen)],), // _screenTitle(screen),
                    onTap: () 
                      { _showScreen(context, screen); },
                ),  
              ],
            )
         )
         //)
    );
  }

  _showScreen(BuildContext context, String screen)
  {
    switch (screen) {
      case 'Pre Gate-In':
      { _showPreGateIn(context);} break;
      case 'Survey':
      {_showSurvey(context);} break;
      case 'Container Status':
      {_showContainerStatus(context);}  break;
      default: _showPendingEquipJobsList(context);
    }    
  }

  Widget _screenTitle(String screen)
  {
    double fntSz = 16.0;

    switch (screen) {
      case 'Pre Gate-In':
        { return Text('Record the container pre gate in details.',style: txtCss.txtRoboBoldStyle(fntSz),) ;} break;
      case 'Survey':
        { return Text('Update the damage status of the container.',style: txtCss.txtRoboBoldStyle(fntSz),) ;} break;
      case 'Container Survey':
        { return Text('Record the container survey details.',style: txtCss.txtRoboBoldStyle(fntSz),) ;}  break;
      default:  
          return Text('Reach Stacker Equipment Job details.',style: txtCss.txtRoboBoldStyle(fntSz),);
    }
  }

  Widget _screenSubTitle(String screen)
  {
    double fntSz = 12.0;

    switch (screen) {
      case 'Pre Gate-In':
        { return Text('Share Container Photos to the MnR dept.', style: txtCss.txtRoboStyle(fntSz),) ;} break;
      case 'Survey':
        { return Text('Share Container Photos to the MnR dept.', style: txtCss.txtRoboStyle(fntSz),);} break;
      case 'Container Survey':
        { return Text('Share Container survey to the MnR dept.', style: txtCss.txtRoboStyle(fntSz),);} break;
      default:  
          return Text('Share Reach Stacker Update from MnR dept.', style: txtCss.txtRoboStyle(fntSz),);
    }    
  }
  
  _showPreGateIn(BuildContext context)
  {
    //print('Entering Pre Gate-In');
    Navigator.push(context, new MaterialPageRoute(
                                  builder: (context) =>
                                    new PregateIn(loginInfo: this.loginInfo)));
  }  

  _showSurvey(BuildContext context)
  {
    //print('Entering Survey');
    Navigator.push(context, new MaterialPageRoute(
                                  builder: (context) =>
                                    new SurveyPGIn(loginInfo: this.loginInfo)));
  }

  _showContainerStatus(BuildContext context)
  {
    //print('Entering Pre Gate-In');
    Navigator.push(context, new MaterialPageRoute(
                                  builder: (context) =>
                                    new ContainerStatus(loginInfo: this.loginInfo)));
  }
   _showPendingEquipJobsList(BuildContext context)
  {
    //print('Entering Survey');
    Navigator.push(context, new MaterialPageRoute(
                                  builder: (context) =>
                                    new   RSPendingEquipJobs(loginInfo: this.loginInfo)));
  }

  
     _showTesting(BuildContext context)
  {
    //print('Entering Survey');
    Navigator.push(context, new MaterialPageRoute(
                                  builder: (context) =>
                                    new TestScreeen(loginInfo: this.loginInfo)));
  }
}