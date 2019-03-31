import 'dart:ui';
import 'dart:io';
import 'package:http/http.dart' show Client;
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:m_n_r/src/blocs/commonVariables.dart';


class LookUp {
  Client client = Client();
  //List<LookUps> _lookups;
  List<LookupItem> _lookUpItems;

  Future<List<LookupItem>> fetchInitData()  async  {
    //final url = 'http://dmsapi.logiconglobal.com/api/master/lookup/list'; 
    // this above API is with table names
    final url = 'http://dmsapi.logiconglobal.com/api/master/lookup/lookuplist';
    final response = await client.get(url,headers: {"Accept": "application/json",
                                            "content-type": "application/json"});
    if (response.statusCode == 200) {
      List lookups = json.decode(response.body);
      _lookUpItems = lookups.map((data) => new LookupItem.fromJson(data)).toList();
      
      return _lookUpItems;
    } else { throw Exception('Failed to Look up Items');}  
  }

  // fetches repair Code and repair location codes
  Future<List<LookupItem>> fetchRepairCodes()  async  {

    final url = 'http://dmsapi.logiconglobal.com/api/mnr/lookup/list';
    final response = await client.get(url,headers: {"Accept": "application/json",
                                            "content-type": "application/json"});
    if (response.statusCode == 200) {
      List lookups = json.decode(response.body);
      _lookUpItems = lookups.map((data) => new LookupItem.fromJson(data)).toList();
      
      return _lookUpItems;
    } else { throw Exception('Failed to Repair Codes');}  
  }
}

class LookUps{
  //String tblName;
  List<LookupItem> values;
  
  //LookUps({this.tblName, this.items});
  LookUps({this.values});

  factory LookUps.fromJson(Map<dynamic, dynamic> json){
  return LookUps(
    //tblName: json['key'], 
    values: json['value'].map((data) => new LookupItem.fromJson(data['value'])).toList());}

}

class LookupItem {
  final int lookupID;
  final String lookupCode;
  final String lookupDescription;
  final String lookupCategory;

  LookupItem({this.lookupID, this.lookupCode, this.lookupDescription, this.lookupCategory});

  factory LookupItem.fromJson(Map<String, dynamic> json) {
    //print(json['lookupID'].toString() + ' / ' + json['lookupCategory'].toString());
    return LookupItem(lookupID:json['lookupID'],
                      lookupCode: json['lookupCode'],
                      lookupDescription: json['lookupDescription'],
                      lookupCategory:json['lookupCategory']);
  }

}

class DamageRepairSummary {
  String sNo;
  String damageLocation;
  String repairCode;
  Image image;

  DamageRepairSummary({this.sNo,this.damageLocation,this.repairCode,this.image});

  factory DamageRepairSummary.fromJson(Map<String, dynamic> json)
  {
    return DamageRepairSummary(
      sNo: json['sNo'],
      damageLocation: json['damageLocation'],
      repairCode: json['repairCode'],
      image: json['image']
    );
  }
}

class PreGateInHd {
  Client client = Client();
  String documentNo;
  int branchId;
  String containerNo, size, type, truckNo, contStatus;
  int truckCatgory; 
  int electricalCable;
  int hms;
  int airGuide;
  int vent;
  bool isRunning;
  int stickerTemp;
  int displayTemp;
  int condition;
  String additionalRequirement;
  bool status;
  String createdBy;
  String createdOn;
  String modifiedBy;
  String modifiedOn;
  List<PreGateInDt> preGateInDetails;

  PreGateInHd({ this.documentNo, this.branchId, this.containerNo, this.size, this.type, this.truckNo,
                this.truckCatgory, this.contStatus, this.electricalCable,
                this.hms, this.airGuide, this.vent, this.isRunning, this.stickerTemp, this.displayTemp,
                this.condition,this.additionalRequirement, this.status, this.createdBy, this.createdOn,
                this.modifiedBy, this.modifiedOn, this.preGateInDetails });
              

  Map<String, dynamic> toJSon() =>
  { 
    'documentNo': this.documentNo,
    'branchId': this.branchId,
    'containerNo': this.containerNo,
    'size': this.size, 
    'type': this.type, 
    'truckNo': this.truckNo,
    'truckCategory': this.truckCatgory,
    'containerStatus': this.contStatus,
    'electricalCable': this.electricalCable,
    'hmc': this.hms, 
    'airGuide': this.airGuide, 
    'vent': this.vent, 
    'running': this.isRunning, 
    'stickerTemp': this.stickerTemp, 
    'displayTemp': this.displayTemp,
    'condition': this.condition,
    'additionalRequirement': this.additionalRequirement, 
    'status': this.status, 
    'createdBy': this.createdBy, 
    'createdOn': this.createdOn,
    'modifiedBy': this.modifiedBy, 
    'modifiedOn': this.modifiedOn, 
    'preGateInDetails': this.preGateInDetails.map((dtls) => dtls.toJSon()).toList(),
  };

  Future<bool> savePGIn(PreGateInHd pGIhd) async{
    //String root = 'http://192.168.0.3:51003'; 
    //'http://localhost:51003';  // local server for testing 

    //String url = 'http://dmsapi.logiconglobal.com/api/icd/pregatein/save';

    String root = 'http://dmsapi.logiconglobal.com';  // Network Server for live 
    String url = '$root/api/icd/pregatein/save';
    bool respVal = false;

    var pgi = json.encode(pGIhd.toJSon());
    var future = client.post(url, body: pgi,
                  headers: {"Accept": "application/json", "content-type": "application/json" });
    final response = await future;
    //print(response.body);
    if (response.statusCode == 200) {
      var isPGInSucces = json.decode(response.body);
      //print(' Posted pregatein info @ API ');
      respVal = isPGInSucces ? true : false;
    } else
      throw Exception('Failed to save Pragate-In');  

      return respVal;
    }

}

class SurveyPGInHd
{
  Client client = new Client();
  String documentNo, containerNo , contSize, contType;

  SurveyPGInHd({this.documentNo, this.containerNo, this.contSize, this.contType});

  factory SurveyPGInHd.surPGInListfromJson(Map<String, dynamic> jSon) {
  return SurveyPGInHd(
    documentNo: jSon['documentNo'], 
    containerNo: jSon['containerNo'],
    contSize: jSon['size'],
    contType: jSon['type'],
    );
  }

  Future<List<SurveyPGInHd>> surveyPGInList(int branchID) async{

    String root = 'http://dmsapi.logiconglobal.com';  // Network Server for live 
    String url = '$root/api/icd/pregatein/list/$branchID';

    var future = client.get(url,
                  headers: {"Accept": "application/json", "content-type": "application/json" });
    final response = await future;
    if (response.statusCode == 200) {
      List pgiHds = json.decode(response.body);
      List<SurveyPGInHd> pgiHdList = pgiHds.map((data) => new SurveyPGInHd.surPGInListfromJson(data)).toList();
      
      return pgiHdList;
    } else { throw Exception('Failed to fetch Survey Pre Gate In List');} 
  }    
}

class PreGateInDt {
    String documentNo, dmgCodeDesc, repairCode, repairCodeDesc, 
                  repairLocation, repairLocDesc, imageName, imageSource;
    int damageCode;

    PreGateInDt({ this.documentNo, this.damageCode, this.dmgCodeDesc, this.repairCode, this.repairCodeDesc,
                  this.repairLocation, this.repairLocDesc, this.imageName, this.imageSource});

    factory PreGateInDt.fromJson(Map<String, dynamic> json)
    {
      return PreGateInDt(
        documentNo: json['documentNo'],
        damageCode: json['damageCode'],      
        repairCode: json['repairCode'],
        repairLocation: json['repairLocation'],
        imageName: json['imageName'],
        imageSource: json['imageSource'],
      );
    }

    Map<String, dynamic> toJSon() =>
    { 
      'documentNo': this.documentNo,
      'damageCode': this.damageCode,
      'repairCode': this.repairCode,
      'repairLocation': this.repairLocation,
      'imageName': this.imageName, 
      'imageSource': (StaticConst.camFile == this.imageSource) ? '' : encode2Base64(this.imageSource),
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