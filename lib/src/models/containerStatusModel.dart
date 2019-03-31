import 'package:http/http.dart' show Client;
import 'dart:convert';

class ContStatusModel {
  Client client = new Client();
  
  String contNo, contCurrentStatus, contStatus, remarks;

  ContStatusModel({this.contNo, this.contCurrentStatus, this.contStatus, this.remarks});

  Map<String, dynamic> toJson() => {
    'containerNo': contNo,
    'containerCurrentStatus': contCurrentStatus,
    'containerStatus': contStatus,
    'remarks':remarks,
  };  

  Future updateContainerStatus(String contNo, String status, String remarks, String userID) async{
    
    // //api/Master/Container/updatecontainerstatus/AKLU6504276/SOUND/NONE/ADMIN
    // remarks = (remarks.isEmpty || remarks == '') ? 'NONE' : remarks;

    String root = 'http://dmsapi.logiconglobal.com';  // Network Server for live 
    String url = '$root/api/Master/Container/updatecontainerstatus/$contNo/$status/$remarks/$userID';
    bool respVal = false;

    var future = client.get(url,
                  headers: {"Accept": "application/json", "content-type": "application/json" });
    print(url);
    final response = await future;
    print(response.body);
    if (response.statusCode == 200) {
      var isRSPJSuccess = json.decode(response.body);
      //print(' Posted pregatein info @ API ');
      respVal = isRSPJSuccess ? true : false;
    } else
      throw Exception('Failed to Update Container Status');  

    return respVal;
  }


}
