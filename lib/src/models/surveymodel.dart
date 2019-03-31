import 'dart:io';
import 'package:http/http.dart' show Client;
import 'dart:convert';
import 'dart:typed_data';

import 'package:m_n_r/src/blocs/commonVariables.dart';

class SurveyHeader {
  int branchId;
  String documentNo, containerNo, contSize, contType, agentCode, eIRNo, yardCode, 
  remarks, createdBy, modifiedBy, createdOn, modifiedOn;
  bool status;
  List surveyDetails = [];

  Client client = new Client();

  SurveyHeader({this.branchId, this.documentNo, this.containerNo, this.contSize, 
    this.contType, this.agentCode, 
    this.eIRNo, this.yardCode, this.remarks, this.createdBy, this.createdOn, 
    this.modifiedBy, this.modifiedOn, this.status, this.surveyDetails});

  factory SurveyHeader.fromJson(Map<String, dynamic> jSon) {
    return SurveyHeader(
      branchId: jSon['branchID'],
      documentNo: jSon['documentNo'],
      containerNo: jSon['containerNo'],
      contSize: jSon['size'],
      contType: jSon['type'],
      agentCode: jSon['agentCode'],
      eIRNo: jSon['eirNo'],
      yardCode: jSon['yardCode'],
      remarks: jSon['remarks'],
      status: jSon['status'],
      createdBy: jSon['createdBy'],
      createdOn: jSon['createdOn'],
      modifiedBy: jSon['modifiedBy'],
      modifiedOn: jSon['modifiedOn'],
      surveyDetails: jSon['surveyDetails'].map((json) => new SurveyDetails.fromJson(json)).toList(),
    );
  }

  Map<String, dynamic> toJSon() =>
  { 
    'documentNo': this.documentNo,
    'branchId': this.branchId,
    'containerNo': this.containerNo,
    'agentCode': this.agentCode, 
    'eIRNo': this.eIRNo, 
    'yardCode': this.yardCode, 
    'remarks': this.remarks,
    'status': this.status, 
    'createdBy': this.createdBy, 
    'createdOn': this.createdOn,
    'modifiedBy': this.modifiedBy, 
    'modifiedOn': this.modifiedOn, 
    'surveyDetails': this.surveyDetails.map((dtls) => dtls.toJSon()).toList(),
  };

  Future<bool> saveSurvey(SurveyHeader surHD) async{

    String root = 'http://dmsapi.logiconglobal.com';  // Network Server for live 
    String url = '$root/api/mnr/survey/save';
    bool respVal = false;

    var surv = json.encode(surHD.toJSon());
    print(surv);
    var future = client.post(url, body: surv,
                  headers: {"Accept": "application/json", "content-type": "application/json" });
    final response = await future;
    print(response.body);
    if (response.statusCode == 200) {
      var isSurveySuccess = json.decode(response.body);
      //print(' Posted pregatein info @ API ');
      respVal = isSurveySuccess ? true : false;
    } else
      throw Exception('Failed to save Container Survey');  

    return respVal;
  }

  Future<SurveyHeader> pGInList2Survey(int branchID, String documentNo) async{
    
    String root = 'http://dmsapi.logiconglobal.com';  // Network Server for live 
    String url = '$root/api/mnr/survey/generatesurveyforpregatein/$branchID/$documentNo';
    //List pgiHds = [];

    var future = client.get(url,
                  headers: {"Accept": "application/json", "content-type": "application/json" });
    final response = await future;
    if (response.statusCode == 200) {
      var pgiHds = json.decode(response.body);
      //SurveyHeader pgiHd2SurList = pgiHds.map((data) => new SurveyHeader.fromJson(data)); //.toList();
      SurveyHeader pgiHd2SurList = SurveyHeader.fromJson(pgiHds); //.toList();
      return pgiHd2SurList;
    } else { throw Exception('Failed to fetch Survey from Pre Gate In List');} 
  }    
}

class SurveyDetails {
  String documentNo, dmgCodeDesc, repairCode, repairCodeDesc, 
                repairLocation, repairLocDesc, imageName, imageSource;
  bool isNetWorkImage = false;
  int damageCode;

  SurveyDetails({ this.documentNo, this.damageCode, this.dmgCodeDesc, this.repairCode, this.repairCodeDesc,
                this.repairLocation, this.repairLocDesc, this.imageName, this.imageSource, this.isNetWorkImage});

  factory SurveyDetails.fromJson(Map<String, dynamic> json)
  {
    return SurveyDetails(
      documentNo: json['documentNo'],
      damageCode: json['damageCode'],      
      repairCode: json['repairCode'],
      repairLocation: json['repairLocation'],
      imageName: json['imageName'],
      imageSource: json['imageSource'] == '' ? StaticConst.camFile : json['imageSource'],
      isNetWorkImage: json['imageSource'] == '' ? false : true,
    );
  }

  Map<String, dynamic> toJSon() =>
  { 
    'documentNo': this.documentNo,
    'damageCode': this.damageCode,
    'repairCode': this.repairCode,
    'repairLocation': this.repairLocation,
    'imageName': this.imageName, 
    'imageSource': (StaticConst.camFile == this.imageSource) ? '' 
                    : isNetWorkImage ? this.imageSource : encode2Base64(this.imageSource),
  };

  //for my reference to save image in DataBase
  String encode2Base64(String imageFilePath) {
      File imageFile = new File(imageFilePath);
      List<int> imageBytes = imageFile.readAsBytesSync();
      String base64Image = base64.encode(imageBytes);
      return base64Image;
  }

  Uint8List decode4mBase64(String imageFilePath) {
    // File imageFile = new File(imageFilePath);
    // List<int> imageBytes = imageFile.readAsBytesSync();
    //String base64Image = base64.decode(imageBytes);
    Uint8List bytes = base64.decode(imageFilePath);
    return bytes;
  }

}