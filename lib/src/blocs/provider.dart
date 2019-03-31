import 'package:flutter/material.dart';
//import 'bloc.dart';
import 'package:m_n_r/src/blocs/bloc.dart';
//import 'package:m_n_r/src/blocs/pregateinbloc.dart';

class Provider extends InheritedWidget
{
  final bloc = Bloc();

  Provider({Key key,Widget child}) :super(key:key, child: child);

  bool updateShouldNotify(_) => true;

  static Bloc of(BuildContext context)
  {
    return (context.inheritFromWidgetOfExactType(Provider) as Provider).bloc;    
  }
}

// class GateInProvider extends InheritedWidget
// {
//   final preGateinbloc = PreGateInBloc();

//   GateInProvider({Key key, Widget child}) :super(key:key,child:child);

//   bool updateShouldNotify(_) => true;

//   static PreGateInBloc of(BuildContext context)
//   {
//     return (context.inheritFromWidgetOfExactType(GateInProvider) as GateInProvider).preGateinbloc;
//   }

// }