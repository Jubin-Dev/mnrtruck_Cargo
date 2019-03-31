import 'dart:async';
import 'package:m_n_r/src/blocs/validators.dart';
import 'package:rxdart/rxdart.dart';

class PreGateInBloc extends Object with Validators
// Or class Bloc extends Validators
{
  // final _emailController = StreamController<String>.broadcast();
  // final _passwordController = StreamController<String>.broadcast();
  // Above code can be replaced with below to access the submitbutton --> method "submit"

  final _contNoController = BehaviorSubject<String>();
  final _sizeController = BehaviorSubject<String>();
  final _typeController = BehaviorSubject<String>();
  final _elecCableController = BehaviorSubject<String>();
  final _airGuideController = BehaviorSubject<String>();
  final _hmcController = BehaviorSubject<String>();
  final _ventController = BehaviorSubject<String>();
  final _runningController = BehaviorSubject<String>();
  final _stickerController = BehaviorSubject<String>();
  final _displayController = BehaviorSubject<String>();
  final _conditionController = BehaviorSubject<String>();
  final _additionalReqController = BehaviorSubject<String>();


  // Stream data to variable
  Stream<String> get contNo => _contNoController.stream.transform(validateContNo);
  Stream<String> get cntSize => _sizeController.stream.transform(validatedropDown);
  Stream<String> get cntType => _typeController.transform(validatedropDown);
  Stream<String> get elecCable => _elecCableController.transform(validatedropDown);
  Stream<String> get airGuide => _contNoController.stream.transform(validatedropDown);
  Stream<String> get hmc => _sizeController.stream.transform(validatedropDown);
  Stream<String> get vent => _typeController.transform(validatedropDown);
  Stream<String> get running => _elecCableController.transform(validatedropDown);
  Stream<String> get stickerTemp => _contNoController.stream.transform(validateTxtFld);
  Stream<String> get displayTemp => _sizeController.stream.transform(validateTxtFld);
  Stream<String> get contCondition => _typeController.transform(validatedropDown);
  Stream<String> get additionalReq => _elecCableController.transform(validatedropDown);
  
  Stream<bool> get submitFirstValid => Observable.combineLatest9(
    contNo, cntSize, cntType, elecCable, airGuide, hmc,
    vent, running, stickerTemp, (c,s,t,e,a,h,v,r,b) => true);

  Stream<bool> get submitSecValid => Observable.combineLatest3(
    displayTemp, contCondition, additionalReq, 
    (x,y,z) => true);

  // Change Data 
  Function(String) get changeContNo => _contNoController.sink.add;
  Function(String) get changeSize => _sizeController.sink.add;
  Function(String) get changeType => _typeController.sink.add;
  Function(String) get changeElecCable => _elecCableController.sink.add;
  Function(String) get changeairGuide => _airGuideController.sink.add;
  Function(String) get changeHmc => _hmcController.sink.add;
  Function(String) get changeVent => _ventController.sink.add;
  Function(String) get changeRunning => _runningController.sink.add;
  Function(String) get changeSticker => _stickerController.sink.add;
  Function(String) get changeDisplay => _displayController.sink.add;
  Function(String) get changeCondition => _conditionController.sink.add;
  Function(String) get changeAddReq => _additionalReqController.sink.add;
  

  // String getBrCode()
  // {
  // String brCode = _branchCodeController.value;
  // return brCode;
  // }
  
  // String getYardCode()
  // {
  // String yardCode = _yardCodeController.value;
  // return yardCode;
  // }

  submit()
  {
    final validContNo = _contNoController.value;
    final validSize = _sizeController.value;
    final validType = _typeController.value;
    final validElecCable = _elecCableController.value;

    print('Email is : $validContNo');
    print('Password is : $validSize');
    print('Branch is : $validType');
    print('Yard is : $validElecCable');
  }

  dispose()
  {
   _contNoController.close(); 
   _sizeController.close();
   _typeController.close();
   _elecCableController.close();
   _airGuideController.close();
   _hmcController.close();
   _ventController.close();
   _runningController.close();
   _stickerController.close();
   _displayController.close();
   _conditionController.close();
   _additionalReqController.close();
  }

}

//final bloc = Bloc();