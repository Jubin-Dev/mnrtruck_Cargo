
import 'package:http/http.dart' show Client;
import 'dart:convert';

class MasterData {
  Client client = Client();
  List<ContainerDetails> _contDetails =[];

  Future<List<ContainerDetails>> fetchContainerDetails(String contNo)  async  {
    final url = 'http://dmsapi.logiconglobal.com/api/master/container/getcontainertypesize/$contNo';
    final response = await client.get(url,headers: {"Accept": "application/json",
                                            "content-type": "application/json"});
    if (response.statusCode == 200) {
      _contDetails.add(ContainerDetails.fromJson(json.decode(response.body)));

      return _contDetails;
    } else { throw Exception(response.body);}  
  }
}

class ContainerDetails{
  String containerNo, contSize, contType;
  
  ContainerDetails({this.containerNo,this.contSize, this.contType});
  
  factory ContainerDetails.fromJson(Map<dynamic, dynamic> json){
  return ContainerDetails(
    containerNo: json['containerNo'],
    contSize: json['size'],
    contType: json['type'],
  );}
}