import 'dart:async';
import 'package:m_n_r/src/blocs/validators.dart';
import 'package:m_n_r/src/models/containerStatusModel.dart';
import 'package:m_n_r/src/models/reachStackerModel.dart';
import 'package:rxdart/rxdart.dart';
import 'package:m_n_r/src/models/usermodel.dart';
import 'package:m_n_r/src/models/pregateinmodel.dart';
import 'package:m_n_r/src/models/mastermodel.dart';
import 'package:m_n_r/src/models/surveymodel.dart';
import 'package:m_n_r/src/blocs/commonVariables.dart';

class Bloc extends Object with Validators
// Or class Bloc extends Validators
{
  // final _emailController = StreamController<String>.broadcast();
  // final _passwordController = StreamController<String>.broadcast();
  // Above code can be replaced with below to access the submitbutton --> method "submit"

  // Login screen
  final _compCodeController = BehaviorSubject<String>();
  final _emailController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();
  final _branchCodeController = BehaviorSubject<String>();
  final _yardCodeController = BehaviorSubject<String>();
  final _branch4YardCodeCtrl = BehaviorSubject<String>();

  // Pre Gate In screen
  final _contNoController = BehaviorSubject<String>();
  final _sizeController = BehaviorSubject<String>();
  final _typeController = BehaviorSubject<String>();
  final _truckNoController =BehaviorSubject<String>();
  final _truckCatgoryController =BehaviorSubject<String>();
  final _contStatusController =BehaviorSubject<String>();
  final _elecCableController = BehaviorSubject<String>();
  final _airGuideController = BehaviorSubject<String>();
  final _hmcController = BehaviorSubject<String>();
  final _ventController = BehaviorSubject<String>();
  final _runningController = BehaviorSubject<String>();
  final _stickerController = BehaviorSubject<String>();
  final _displayController = BehaviorSubject<String>();
  final _conditionController = BehaviorSubject<String>();
  final _additionalReqController = BehaviorSubject<String>();
  final _damageCodeController = BehaviorSubject<String>();
  final _repairCodeController = BehaviorSubject<String>();
  final _repairLocCodeController = BehaviorSubject<String>();
  final _preGateinDtlsController = BehaviorSubject<List<PreGateInDt>>();
  final _lookUpsController = BehaviorSubject<List<LookupItem>>();

  // Container Status Screen
  final _csContNoCtrl = BehaviorSubject<String>();
  final _csCurrContStatusCtrl = BehaviorSubject<String>();
  final _csContStatusCtrl = BehaviorSubject<String>();
  final _csRemarksCtrl =BehaviorSubject<String>();

  // Survey Screen
  final _surContNoCtrl =BehaviorSubject<String>();
  final _surContSizeCtrl =  BehaviorSubject<String>();
  final _surContTypeCtrl =BehaviorSubject<String>();
  final _surEIRNoCtrl =BehaviorSubject<String>();
  final _surYardLocCtrl = BehaviorSubject<String>();
  final _surRemarksCtrl = BehaviorSubject<String>();
  final _surAgentCtrl = BehaviorSubject<String>();
  final _surveyDetailsCtrl =BehaviorSubject<List<SurveyDetails>>();

  // Reach Stacker Screen
  final _rsContNoCtrl =BehaviorSubject<String>();
  final _rsContSizeCtrl =  BehaviorSubject<String>();
  final _rsContTypeCtrl =BehaviorSubject<String>();
  final _rsAgentCtrl = BehaviorSubject<String>();
  final _rsActivityCtrl =BehaviorSubject<String>();
  final _rsYardLocCtrl = BehaviorSubject<String>();


  // Stream data to variable
  //Login Screen
  Stream<String> get companyCode => _compCodeController.stream.transform(validateCode);
  Stream<String> get eMail => _emailController.stream.transform(validateEmail);
  Stream<String> get passWord => _passwordController.stream.transform(validatePassword);
  Stream<String> get branchCode => _branchCodeController.transform(validatedropDown);
  Stream<String> get yardCode => _yardCodeController.transform(validatedropDown);
  Stream<String> get branch4YardCode => _branchCodeController.transform(validatedropDown);
  Stream<bool> get submitValid => Observable.combineLatest4(eMail, passWord, branchCode, yardCode, (e,p,b,y) => true);
  
  //Pre Gate In screen
  Stream<String> get contNo => _contNoController.stream.transform(validateContNo);
  Stream<String> get cntSize => _sizeController.stream.transform(validatedropDown);
  Stream<String> get cntType => _typeController.transform(validatedropDown);
  Stream<String> get truckNo => _truckNoController.transform(validateTxtFld);
  Stream<String> get truckCatgory => _truckCatgoryController.transform(validatedropDown);
  Stream<String> get contStatus => _contStatusController.transform(validatedropDown);
  Stream<String> get elecCable => _elecCableController.transform(validatedropDown);
  Stream<String> get airGuide => _airGuideController.stream.transform(validatedropDown);
  Stream<String> get hmc => _hmcController.stream.transform(validatedropDown);
  Stream<String> get vent => _ventController.transform(validatedropDown);
  Stream<String> get running => _runningController.transform(validatedropDown);
  Stream<String> get stickerTemp => _stickerController.stream.transform(validateTxtFld);
  Stream<String> get displayTemp => _displayController.stream.transform(validateTxtFld);
  Stream<String> get contCondition => _conditionController.transform(validatedropDown);
  Stream<String> get additionalReq => _additionalReqController.transform(validatedropDown);
  Stream<String> get damageCode => _damageCodeController.stream.transform(validatedropDown);
  Stream<String> get repairCode => _repairCodeController.transform(validatedropDown);
  Stream<String> get repairLocation => _repairLocCodeController.transform(validatedropDown);
  Stream<List<PreGateInDt>> get preGateInDtls => _preGateinDtlsController.transform(validatePreGInDtls);
  Stream<List<LookupItem>> get lookUps => _lookUpsController.transform(validateLookUps);

  // Container Status Screen
  Stream<String> get csContNo => _csContNoCtrl.transform(validateContNo);
  Stream<String> get csCurrContStatus => _csCurrContStatusCtrl.transform(validateTxtFld);
  Stream<String> get csContStatus => _csContStatusCtrl.transform(validateTxtFld);
  Stream<String> get csRemarks => _csRemarksCtrl.transform(validateTxtFld);

  // Survey screen
  Stream<String> get surContNo => _surContNoCtrl.transform(validateContNo);
  Stream<String> get surContSize => _surContSizeCtrl.transform(validateTxtFld);
  Stream<String> get surContType => _surContTypeCtrl.transform(validateTxtFld);
  Stream<String> get surEIRNo => _surEIRNoCtrl.transform(validateTxtFld);
  Stream<String> get surAgent => _surAgentCtrl.transform(validateTxtFld);
  Stream<String> get surYardLoc => _surYardLocCtrl.transform(validateTxtFld);
  Stream<String> get surRemarks => _surRemarksCtrl.transform(validateTxtFld);
  Stream<List<SurveyDetails>> get surveyDetails => _surveyDetailsCtrl.transform(validateSurveyDtls);
  
  // Reach Stacker
  Stream<String> get rsContNo => _rsContNoCtrl.transform(validateContNo);
  Stream<String> get rsContSize => _rsContSizeCtrl.transform(validateTxtFld);
  Stream<String> get rsContType => _rsContTypeCtrl.transform(validateTxtFld);
  Stream<String> get rsAgentCode => _rsAgentCtrl.transform(validateTxtFld);
  Stream<String> get rsActivity => _rsActivityCtrl.transform(validateTxtFld);
  Stream<String> get rsYardLoc => _rsYardLocCtrl.transform(validateTxtFld);

  // PreGateIn fields 
  Stream<bool> get submitFirstValid => Observable.combineLatest9(
    contNo, cntSize, cntType, elecCable, airGuide, hmc,
    vent, running, stickerTemp, (c,s,t,e,a,h,v,r,b) => true);

  Stream<bool> get submitSecValid => Observable.combineLatest3(
    displayTemp, contCondition, additionalReq, 
    (x,y,z) => true);

  // Change Data 
  Function(String) get changeEmail => _emailController.sink.add;
  Function(String) get changePassword => _passwordController.sink.add;
  Function(String) get changeBranch => _branchCodeController.sink.add;
  Function(String) get changeYard => _yardCodeController.sink.add;
  // Pre Gate In screen 
  Function(String) get changeContNo => _contNoController.sink.add;
  Function(String) get changeSize => _sizeController.sink.add;
  Function(String) get changeType => _typeController.sink.add;
  Function(String) get changeTruckNo => _truckNoController.sink.add;
  Function(String) get changeTruckCatgory => _truckCatgoryController.sink.add;
  Function(String) get changeContStatus => _contStatusController.sink.add;
  Function(String) get changeElecCable => _elecCableController.sink.add;
  Function(String) get changeairGuide => _airGuideController.sink.add;
  Function(String) get changeHmc => _hmcController.sink.add;
  Function(String) get changeVent => _ventController.sink.add;
  Function(String) get changeRunning => _runningController.sink.add;
  Function(String) get changeSticker => _stickerController.sink.add;
  Function(String) get changeDisplay => _displayController.sink.add;
  Function(String) get changeCondition => _conditionController.sink.add;
  Function(String) get changeAddReq => _additionalReqController.sink.add;  
  Function(String) get changeDamageCode => _damageCodeController.sink.add;
  Function(String) get changeRepairCode => _repairCodeController.sink.add;
  Function(String) get changeRepairLoc => _repairLocCodeController.sink.add;
  Function(List<PreGateInDt>) get changePreGateInDtls => _preGateinDtlsController.sink.add;

  //Container Status Screen
  Function(String) get changecsContNo => _csContNoCtrl.sink.add;
  Function(String) get changecsCurrContStatus => _csCurrContStatusCtrl.sink.add;
  Function(String) get changecsContStatus => _csContStatusCtrl.sink.add;
  Function(String) get changecsRemarks => _csRemarksCtrl.sink.add;

  // Survey Screen
  Function(String) get changesurContNo => _surContNoCtrl.sink.add;
  Function(String) get changesurContSize => _surContSizeCtrl.sink.add;
  Function(String) get changesurContType => _surContTypeCtrl.sink.add;
  Function(String) get changesurERINo => _surEIRNoCtrl.sink.add;
  Function(String) get changesurAgent => _surAgentCtrl.sink.add;
  Function(String) get changesurYardLoc => _surYardLocCtrl.sink.add;
  Function(String) get changesurRemarks => _surRemarksCtrl.sink.add;
  Function(List<SurveyDetails>) get changesurveyDtls => _surveyDetailsCtrl.sink.add;

  // Reach Stacker Screen
  Function(String) get changersContNo => _rsContNoCtrl.sink.add;
  Function(String) get changersContSize => _rsContSizeCtrl.sink.add;
  Function(String) get changersContType => _rsContTypeCtrl.sink.add;
  Function(String) get changersAgentCode => _rsAgentCtrl.sink.add;
  Function(String) get changersActivity => _rsActivityCtrl.sink.add;
  Function(String) get changersYardLoc => _rsYardLocCtrl.sink.add;

  
  // loginScreen replicaes Yards upon Selection of Branches.
  replicateYardCodesData() {
    //Branch code changes...
    _branchCodeController.stream.listen((onData) 
    { _yardCodeController.sink.add(null);  _branch4YardCodeCtrl.sink.add(onData);});
  }

  addlookUps(List<LookupItem> lookUpItems){
    List<LookupItem> lookUps=[];
    if(_lookUpsController.hasValue)
    { lookUps.addAll(_lookUpsController.value); }  
    lookUps.addAll(lookUpItems);
    _lookUpsController.sink.add(lookUps);
  }

  Future<dynamic> containercheckSum() async {
    MasterData masterdata = new MasterData();
    //print('Entered container check sum');
    await masterdata.fetchContainerDetails(_contNoController.value)
          .then((onValue) {_sizeController.sink.add(onValue[0].contSize);
                           _typeController.sink.add(onValue[0].contType);
                           _sizeController.stream.listen((onData) {});
                           _typeController.stream.listen((onData) {});
                            return "SUCCESS"; }, 
                onError: (err) {throw Exception(err.toString());})
          .catchError((onError) { throw Exception(onError.toString());}); 
    //print('Completed checksum');
  }

  //Retrive description for the selected code at Damage repair summary.
  String retriveDescription(String code, String searchFor){
    String codeDescription = 'Not retrieved data';
    List<LookupItem> lookUps = [];
    List<LookupItem> lkupItem;
    if(_lookUpsController.hasValue)
    {
    lookUps.addAll(_lookUpsController.value);
      if(searchFor == 'Damage')
         lkupItem  = lookUps.where((lukups) => (lukups.lookupID == int.parse(code))).toList();
      else // searchCode == 'Repair'
        lkupItem  = lookUps.where((lukups) => (lukups.lookupCode == code)).toList();  

      codeDescription = lkupItem[0].lookupDescription;   
    }    //lookupDescription  
    
    return codeDescription;
  }

  addPGInDetail()
  {
    //final camFile = 'lib/img/camera.png';
    List<PreGateInDt> pgiDts=[];
    //List pgiDts;
    if(_preGateinDtlsController.hasValue)
    { pgiDts.addAll(_preGateinDtlsController.value);}
    
    PreGateInDt pgiD = new PreGateInDt(
      documentNo: '',
      damageCode: int.parse(_damageCodeController.value),
      repairCode: _repairCodeController.value,
      repairLocation: _repairLocCodeController.value,
      imageName: _damageCodeController.value + _repairCodeController.value + _repairLocCodeController.value,
      imageSource: StaticConst.camFile,
    );
    pgiDts.add(pgiD);
    _preGateinDtlsController.sink.add(pgiDts);
    _preGateinDtlsController.stream.listen((onData) { print(onData.length.toString()); } );
  }

  updatePGIDetails(PreGateInDt damageCode, String mode)
  {
    List<PreGateInDt> pgiDts=[] , pgiDtlsUpdates = [];
    
    //List pgiDts;
    if(_preGateinDtlsController.hasValue)
    { pgiDts.addAll(_preGateinDtlsController.value);
    
    for(PreGateInDt detail in _preGateinDtlsController.value)
    {
      if (damageCode.damageCode == detail.damageCode && 
          damageCode.repairCode == detail.repairCode &&
          damageCode.repairLocation == detail.repairLocation)
          {detail.imageSource = damageCode.imageSource;}
        else {pgiDtlsUpdates.add(detail);}
        
    }
    //pgiDts.add(pgiD);
    _preGateinDtlsController.sink.add((mode=='UPDATE') ? pgiDts : pgiDtlsUpdates);
    _preGateinDtlsController.stream.listen((onData) { print(onData.length.toString()); } );
    }
  }

  addSurDetail()
  {
    //final camFile = 'lib/img/camera.png';
    List<SurveyDetails> surDts=[];
    //List surDts;
    if(_surveyDetailsCtrl.hasValue)
    { surDts.addAll(_surveyDetailsCtrl.value);}
    
    SurveyDetails pgiD = new SurveyDetails(
      documentNo: '',
      damageCode: int.parse(_damageCodeController.value),
      repairCode: _repairCodeController.value,
      repairLocation: _repairLocCodeController.value,
      imageName: _damageCodeController.value + _repairCodeController.value + _repairLocCodeController.value,
      imageSource: StaticConst.camFile,
      isNetWorkImage: false,
    );
    surDts.add(pgiD);
    _surveyDetailsCtrl.sink.add(surDts);
    _surveyDetailsCtrl.stream.listen((onData) { print(onData.length.toString()); } );
  }

  updateSurDetails(SurveyDetails damageCode, String mode)
  {
    List<SurveyDetails> surDT=[] , surDtlsUpdates = [];
    
    //List surDT;
    if(_surveyDetailsCtrl.hasValue)
    { surDT.addAll(_surveyDetailsCtrl.value);
    
    for(SurveyDetails detail in _surveyDetailsCtrl.value)
    {
      if (damageCode.damageCode == detail.damageCode && 
          damageCode.repairCode == detail.repairCode &&
          damageCode.repairLocation == detail.repairLocation)
          {detail.imageSource = damageCode.imageSource;}
        else {surDtlsUpdates.add(detail);}
        
    }
    //surDT.add(pgiD);
    _surveyDetailsCtrl.sink.add((mode=='UPDATE') ? surDT : surDtlsUpdates);
    _surveyDetailsCtrl.stream.listen((onData) { print(onData.length.toString()); } );
    }
  }

  getPGIDetails()
  {
    List pgiDts=[];
    //List pgiDts;
    if(_preGateinDtlsController.hasValue)
    { for(PreGateInDt detail in _preGateinDtlsController.value)
      { pgiDts.add(detail.toJSon());}
    }
    return pgiDts;
  }

  getSurDetails()
  {
    List surDtls=[];
    if(_surveyDetailsCtrl.hasValue)
    { for(SurveyDetails detail in _surveyDetailsCtrl.value)
      { surDtls.add(detail.toJSon());}
    }
    return surDtls;
  }

  User getLoginUser()
  {
     User user = User(userID: _emailController.value,
        password: _passwordController.value,
        branchId: int.parse(_branchCodeController.value),
        yardCode: _yardCodeController.value,
        companyCode: 'pisut',
        );
      return user;
  }
  
  String getBranchCode()
  {
  String branchCode = _branchCodeController.value;
  return branchCode;
  }

  submit()
  {
    final validEmail = _emailController.value;
    final validPwd = _passwordController.value;
    final validBranch = _branchCodeController.value;
    final validYard = _yardCodeController.value;

    print('Email is : $validEmail');
    print('Password is : $validPwd');
    print('Branch is : $validBranch');
    print('Yard is : $validYard');
  }
  
  PreGateInHd getPreGateIn(LoginUserInfo loginUsr) {
  
    PreGateInHd pGIHd = PreGateInHd(documentNo: '',
              branchId: loginUsr.branchId, 
              containerNo: _contNoController.value,
              size: _sizeController.value,
              type: _typeController.value,
              truckNo: _truckNoController.value,
              truckCatgory: int.parse(_truckCatgoryController.value),
              contStatus: _contStatusController.value,
              electricalCable: int.parse(_elecCableController.value),
              hms:int.parse(_hmcController.value),
              airGuide: int.parse(_airGuideController.value),
              vent: int.parse(_ventController.value),
              isRunning: _runningController.value == 'YES' ? true : false,
              stickerTemp: int.parse(_stickerController.value),
              displayTemp: int.parse(_displayController.value),
              condition: int.parse(_conditionController.value),
              additionalRequirement: _additionalReqController.value,
              status: true,
              createdBy: loginUsr.userID,
              createdOn: DateTime.now().toString(),
              modifiedBy: loginUsr.userID,
              modifiedOn: '',
              preGateInDetails: _preGateinDtlsController.value);

    return pGIHd;
  }
  
  SurveyHeader getSurvey(LoginUserInfo loginUsr) {
  
    SurveyHeader surHD = SurveyHeader(
              documentNo: '',
              branchId: loginUsr.branchId, 
              containerNo: _surContNoCtrl.value,
              eIRNo: _surEIRNoCtrl.value,
              agentCode: _surAgentCtrl.value,
              yardCode: _surYardLocCtrl.value,
              remarks: _surRemarksCtrl.value,
              status: true,
              createdBy: loginUsr.userID,
              createdOn: DateTime.now().toString(),
              modifiedBy: loginUsr.userID,
              modifiedOn: '',
              surveyDetails: _surveyDetailsCtrl.value);

    return surHD;
  }  

  ContStatusModel getContStatusUpdate(){
    ContStatusModel csUpdate = new ContStatusModel(
      contNo: _csContNoCtrl.value,
      contStatus: _csContStatusCtrl.value,
      remarks: (_csRemarksCtrl.value.isEmpty || _csRemarksCtrl.value == '') ? 'NONE' : _csRemarksCtrl.value,
      );
    return csUpdate;
  }

  ReachStackerDetail getRSDetail(LoginUserInfo loginUsr, ReachStacker rsHD){

    ReachStackerDetail rsDtl = ReachStackerDetail(
    branchID: loginUsr.branchId,
    jobNo:'',
    transactionKey: rsHD.transactionKey,
    transactionNo: rsHD.transactionNo,
    containerNo:rsHD.containerNo,
    truckNo:rsHD.truckNo, 
    size:rsHD.size, 
    type:rsHD.type, 
    bookingBLNo:rsHD.bookingBLNo, 
    vesselCode:rsHD.vesselCode, 
    voyageNo:rsHD.voyageNo, 
    agentCode:rsHD.agentCode, 
    activity:_rsActivityCtrl.value,
    yardLocation: _rsYardLocCtrl.value,
    createdBy: loginUsr.userID,
    createdOn:DateTime.now().toString(),
    activityDescription:'');

    return rsDtl;
  
  }

  fetchRSPJobDetail(ReachStacker rsHD) async{
    _rsContNoCtrl.sink.add(rsHD.containerNo);
    _rsContSizeCtrl.sink.add(rsHD.size);
    _rsContTypeCtrl.sink.add(rsHD.type);
    _rsAgentCtrl.sink.add(rsHD.agentCode);

    _rsContNoCtrl.stream.listen((onData) {});
    _rsContSizeCtrl.stream.listen((onData) {});
    _rsContTypeCtrl.stream.listen((onData) {});
    _rsAgentCtrl.stream.listen((onData) {});

  }

  fetchPGI2Survey(LoginUserInfo loginUsr)
  async {
    SurveyHeader surHD = new SurveyHeader();
    await surHD.pGInList2Survey(loginUsr.branchId, loginUsr.preGInDocNo)
          .then((surHd) 
          { _surContNoCtrl.sink.add(surHd.containerNo);
            _surContTypeCtrl.sink.add(surHd.contType);
            _surContSizeCtrl.sink.add(surHd.contSize);
            _surEIRNoCtrl.sink.add(surHd.eIRNo);
            _surAgentCtrl.sink.add(surHd.agentCode);
            _surYardLocCtrl.sink.add(surHd.yardCode);
            _surRemarksCtrl.sink.add(surHd.remarks);
            List<SurveyDetails> surDtls = [];
            for(var item in surHd.surveyDetails){surDtls.add(item);}
            _surveyDetailsCtrl.sink.add(surDtls);

            _surContNoCtrl.stream.listen((onData) {});
            _surContTypeCtrl.stream.listen((onData) {});
            _surContSizeCtrl.stream.listen((onData) {});
            _surEIRNoCtrl.stream.listen((onData){});
            _surAgentCtrl.stream.listen((onData){});
            _surYardLocCtrl.stream.listen((onData){});
             _surRemarksCtrl.stream.listen((onData) {});
            _surveyDetailsCtrl.stream.listen((onData) {});
          }).catchError((onError) {throw onError;});
  }

  dispose()
  {
    // Login controllers
    _compCodeController.close();
    _emailController.close();
    _passwordController.close();
    _branchCodeController.close();
    _yardCodeController.close();
    _branch4YardCodeCtrl.close();
   
   // PreGateIn
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
   _damageCodeController.close();
   _repairCodeController.close();
   _repairLocCodeController.close();
   _preGateinDtlsController.close();
   _lookUpsController.close();

  //Container Status
  _csContNoCtrl.close();
  _csCurrContStatusCtrl.close();
  _csContStatusCtrl.close();
  _csRemarksCtrl.close();

  // Survey screen
  _surContNoCtrl.close();
  _surContSizeCtrl.close();
  _surContTypeCtrl.close();
  _surEIRNoCtrl.close();
  _surAgentCtrl.close();
  _surYardLocCtrl.close();
  _surRemarksCtrl.close();
  _surveyDetailsCtrl.close();

  }
}
//final bloc = Bloc();