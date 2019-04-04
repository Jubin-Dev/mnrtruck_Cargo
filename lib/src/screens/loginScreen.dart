import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:m_n_r/src/blocs/bloc.dart';
import 'package:m_n_r/src/blocs/provider.dart';
import 'package:m_n_r/src/models/usermodel.dart';
import 'package:m_n_r/src/screens/initScreen.dart';
import 'package:m_n_r/src/txtCss.dart';
//import 'package:connectivity/connectivity.dart';
// flutter: ">=0.1.4 <2.0.0"
//import 'package:rxdart/rxdart.dart';

class LoginScreen extends StatefulWidget{

   createState() {
    // TODO: implement createState
    return LoginScreenHome();
  }

  dispose() { this.dispose(); }
}

class LoginScreenHome extends State<LoginScreen>
{
 
  // initState()
  //  async {
  //   var connectivityResult = await (Connectivity().checkConnectivity());
  //   if (connectivityResult == ConnectivityResult.mobile) {
  //     // I am connected to a mobile network.
  //     print('Connected to a mobile network.');
  //   } else if (connectivityResult == ConnectivityResult.wifi) {
  //     // I am connected to a wifi network.
  //     print('Connected to a WIFI network.');
  //   }
  // }  

  LoginUserInfo _loginUserInfo;
  
  List<Branch> _branches = [];
  int selectedBranchID = 0;
  bool isGotBranchs= false;

  List<Yard> _yards = [];
  Yard selectedYard;
  int yardCodedata;
  int lastBranchIdFetchedYards =0;
  bool isGotYards;

  Future<List<Branch>> fetchBranchs(String compCode) async {
    print('entered Fetch  braches @ API for $compCode');
    var url = 'http://dmsapi.logiconglobal.com/api/master/branch/branchlist/$compCode';
    
    if (!isGotBranchs)
    {
      final response = await http.get(url, headers: {"Accept": "application/json",
                                                "content-type": "application/json"});
      if (response.statusCode == 200) {
        List branchs = json.decode(response.body);
        _branches = branchs.map((branch) => new Branch.fromJson(branch)).toList();
        isGotBranchs = true;
        print(' Fetched  braches @ API ');
        return _branches;
      } else
        throw Exception('Failed to load Branch');
    }
    else {return _branches;}
  }

  // sample to use incase of streams Stream<int> branchID argument
  Future<List<Yard>> fetchYards(int branchID) async {
    
    print('fetch yards for Last ID $lastBranchIdFetchedYards / $branchID');
    var url = 'http://dmsapi.logiconglobal.com/api/master/yard/branchyardlist/$branchID';
    var response = await http.get(url, headers: {"Accept": "application/json",
                                            "content-type": "application/json"});
    if (response.statusCode == 200)
    { 
      List yards = json.decode(response.body);
      print(response.body);
      _yards = yards.map((yard) => new Yard.fromJson(yard)).toList();
      lastBranchIdFetchedYards = branchID;
      print('yards Length: ' + yards.length.toString());
      return _yards;
    } else
      throw Exception('Failed to load Yard');      
  }

  Future<LoginUserInfo> checkUserLogin(User user) async {
    // print('entered userlogin @ API ');
    var usr = json.encode(user.toJSon());
    //var usr = usr.toJSon();
    print(usr);
    //String _loginVal ='{"userID":"admin","password":"s3t","branchId":240,"yardCode":"SCT EXP","companyCode":"sct"}';
    final response = await http.post('http://dmsapi.logiconglobal.com/api/auth/login/do', 
                                      body: usr,
                                      headers: {"Accept": "application/json",
                                                "content-type": "application/json"
                                                });
    if (response.statusCode == 200) {
      var logininfo = json.decode(response.body);
      _loginUserInfo = new LoginUserInfo.fromJSon(logininfo);
      //print(' Posted user info @ API ');
      return _loginUserInfo;
    } else
      throw Exception(' Login Failed! Invalid UserID or Password');
  }

  Widget build(context)
  {
    var bloc= Provider.of(context);
    bloc.replicateYardCodesData();

    var sizeHW = MediaQuery.of(context).size;
    TxtCss txtCss = new TxtCss();

    return new
    //  MaterialApp(
    //   theme: ThemeData(
    //   backgroundColor: Color(0XFFE1F5FE),
    //   brightness: Brightness.light

    //   ),
    // home:
    Stack(
      children: <Widget>[
        Row(
           mainAxisAlignment: MainAxisAlignment.start,
           crossAxisAlignment: CrossAxisAlignment.start,
           children:<Widget> [
            new Container( 
               // first row first column display pic
                width: ((62/100) * sizeHW.width),   // display the container width of 62.5% of orizinal width (old value:800.0),
                decoration: new BoxDecoration(
                // borderRadius: BorderRadius.circular(20.0),
                image: new DecorationImage(
                   image: new AssetImage('lib/img/cargo-ship-boat-pngrepo-com.png'),
                     fit: BoxFit.contain,
                  ),
                  //color: Colors.lightBlue,
                ),
            ),
              SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: //Expanded( flex: 10, child:   //<expanded not working>         
                new Container(
                    alignment: Alignment.topLeft,
                    width: ((37/100) * sizeHW.width), //480.0,
                    child: Column( 
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(padding: EdgeInsets.only(top:100.00,left: 35.0), 
                                        alignment: Alignment.topLeft,
                                        child: Image.asset('lib/img/virgoleoSolutions.png'),),
                              Container(
                              alignment: Alignment.topLeft,
                              margin: const EdgeInsets.all(10.00),
                              child: Column( children: [
                                SizedBox(height:80.00),
                                Row(children:<Widget>[Expanded(child: uidField(bloc,txtCss),)]), 
                                SizedBox(height:20.00),
                                Row(children:<Widget>[Expanded(child: passwordField(bloc,txtCss))]), 
                                SizedBox(height:20.00),
                                Row(children:<Widget>[Expanded(child: branchCodeList(bloc,txtCss))]),                               
                                SizedBox(height:25.00),
                                Row(children:<Widget>[Expanded(child: yardCodeList(bloc,txtCss))]),
                                //yardCodeList(bloc, txtCss),
                                SizedBox(height:28.00), 
                                Row(children:<Widget>[Expanded(child: submitButton(bloc,txtCss))]),
                                //SizedBox(height:15.00),                                
                                // Row(
                                //   children: <Widget>[
                                //     Expanded(child: Text('Forgot password?',style: txtCss.txtRoboStyle(14.0), textAlign: TextAlign.right,))
                                //   ],
                                // ),

                                // sample code to display height and width of the Screen
                                // Row(
                                //   children: <Widget>[
                                //     Expanded(child: Text('Height: ' + sizeHW.height.toString(),style: TextStyle(fontSize: 20.0, color: Colors.brown),)),
                                //     Expanded(child: Text('Height: ' + ((31.25/100) * sizeHW.width).toString() + ' :- ' + sizeHW.height.toString(),style: TextStyle(fontSize: 20.0, color: Colors.brown),)),
                                     
                                //     Container(width:110.00),
                                //     Expanded(child: Text('width: ' + sizeHW.width.toString(),style: TextStyle(fontSize: 20.0, color: Colors.brown),))
                                //   ],
                                // ),
                                
                                //Container(margin: EdgeInsets.only(top: 20.0)),
                                 
                                ])
                              )
                            ],
                          )
                )
            )
          ],
      ),
    ]
    );
  }

  Widget uidField(Bloc bloc, TxtCss txtSS)
  {
    return StreamBuilder(
      stream: bloc.eMail,
      builder: (context, snapshot) 
        { 
          return TextField(
            style: txtSS.txtRoboStyle(20),
            onChanged: bloc.changeEmail,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next ,
            decoration: InputDecoration(
            suffixIcon: Icon(Icons.person),
            labelStyle: txtSS.lblRoboStyle(20.00),
            hintText: 'user id',
            labelText: 'User',
            errorText: snapshot.error,
            // border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
            ),
          );
        }
      
      );
    
  }

  Widget passwordField(Bloc bloc, TxtCss txtSS)
  {
    return StreamBuilder(
      stream: bloc.passWord,
      builder: (context, snapshot)
        {
          return TextField(
            style: txtSS.txtRoboStyle(20.00),
            onChanged: bloc.changePassword,
            textInputAction: TextInputAction.next,
            obscureText: true,
            decoration: InputDecoration(
              suffixIcon: Icon(Icons.lock),
              labelStyle: txtSS.lblRoboStyle(20.00),
              hintText: 'password',
              labelText: 'Password',
              errorText: snapshot.error,
              // border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
            ),
          );     
        },
    );
  }

  Widget branchCodeList(Bloc bloc, TxtCss txtSS)
   {
     return StreamBuilder(
      stream: bloc.branchCode,
      builder: (context, snapshot) 
      {
        return FutureBuilder(
          future: fetchBranchs('pisut'),
          builder: (context, branchsData)
          { 
            if (branchsData.hasData)
            {
            return 
            DropdownButtonHideUnderline(
              
            child: new DropdownButton<String>(
              isDense: true,
              items: branchsData.data
                .map<DropdownMenuItem<String>>(
                  (Branch dropDownStringitem){ 
                    return DropdownMenuItem<String>(
                      value: dropDownStringitem.branchID.toString(), 
                      child: Text(dropDownStringitem.branchCode, 
                              style: txtSS.txtRoboStyle(20),),);
                         },
                ).toList(),
              onChanged: bloc.changeBranch, 
              value: snapshot.data,
              style: txtSS.lblRoboStyle(20.00),
              hint: Text('Branch Code '),
              isExpanded: true,
              iconSize: 30.0,              
              elevation: 8,
             ) );
            } else { return LinearProgressIndicator(); }
          },
        );
        }
    );
  }

  Widget yardCodeList(Bloc bloc, TxtCss txtSS) 
  {
    return StreamBuilder(
      stream: bloc.branch4YardCode,
      builder: (context, ssBranchId) 
      { 
        //print('entered 1st yard stream:');
        if (ssBranchId.hasData)
        {
          yardCodedata = int.parse(ssBranchId.data); 
            return StreamBuilder(
              stream: bloc.yardCode,  
              builder: (context, snapshot) 
              { 
                //print('entered 2nd yard stream:');
                return FutureBuilder(
                  future: fetchYards(yardCodedata), //),  //int.parse(snapshot.data)), // fetchYards(int.parse(bloc.getBranchCode())), 
                  builder: (context, yardsData){
                    if (yardsData.hasData)
                    {
                      //print('Yard data' + yardsData.data); Note: this kind of statements giving error 
                      //print('Yard data available: ' + (yardsData.hasData ? 'true' : 'false'));
                      return DropdownButton<String>(
                        items: yardsData.data
                              .map<DropdownMenuItem<String>>(
                                (Yard dropDownStringitem) {
                                  return DropdownMenuItem<String>(
                                        value: dropDownStringitem.yardCode,
                                        child: Text(dropDownStringitem.description,
                                                style: txtSS.txtRoboStyle(20),)
                                        );
                                },
                              ).toList(),
                        onChanged: bloc.changeYard, 
                        value: snapshot.data,
                        hint: Text('Yard Code '),
                        style: txtSS.lblRoboStyle(20),
                        isExpanded: true,
                        iconSize: 30.0,
                        elevation: 8,
                      );
                    }
                    else
                    {
                      return LinearProgressIndicator();
                    }
                  }
                );
              }
            );
        } else { return LinearProgressIndicator();}
      }
    );
  }

  Widget submitButton(Bloc bloc, TxtCss txtSS)
  {
    return StreamBuilder(
      stream: bloc.submitValid,
      builder: (context, snapshot) 
      {
    return Container(
      height: 50.0,
            child:
              RaisedButton(
                  child: Text('Sign In',style: txtSS.btnTxtRoboStyle(25),),
                  color: Colors.indigo[600],
                  disabledColor: Colors.red[600],
                  textColor: Colors.white,
                  //shape: ,         
                  onPressed: !snapshot.hasData ? null : () 
                                async { 
                                  //LoginUserInfo logUser = 
                                  await checkUserLogin(bloc.getLoginUser())
                                  .then((onValue) { 
                                    if(onValue.message == 'SUCCESS')
                                  {   Navigator.push(context, new MaterialPageRoute(
                                      builder: (context) =>
                                      new InitScreen(loginInfo:onValue),
                                      maintainState: false));
                                    } else { _showSubMenu(context, 'Login Failed');}
                                  }, onError: (e) {_showSubMenu(context, e.toString());})
                                  .catchError((e) {_showSubMenu(context, e.error);}); 
                                  
                                  // if(logUser.message == 'SUCCESS')
                                  //    { _showSubMenu(context,'user: $logUser.userID / $logUser.message');
                                  //       // Navigator.push(context, new MaterialPageRoute(
                                  //       // builder: (context) =>
                                  //       // new InitScreen()));
                                  //     }
                                  // else { _showSubMenu(context, 'Login Failed');}

                                  // loginValidation(bloc); 
                                  // bloc.submit();
                                }
                      ) );
                  },  
              );
            }

  _showSubMenu(BuildContext context, String txtStr)
  {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return SimpleDialog(children: <Widget>[ 
          //showRadioBtn(context),
          Text(txtStr, style: TextStyle(fontFamily: 'roboto', fontSize: 30,), textAlign: TextAlign.center,),
          new FlatButton(child: new Text("Close", style: TextStyle(fontFamily: 'roboto', fontSize: 20,), textAlign: TextAlign.center,),
                         onPressed: () {Navigator.of(context).pop();},
          )
        ],);
      }
    );  
  }
  
}