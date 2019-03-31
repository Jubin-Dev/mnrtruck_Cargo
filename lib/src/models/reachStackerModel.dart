import 'package:http/http.dart' show Client;
import 'dart:convert';


class ReachStacker{
  Client client = new Client();

  int branchID, transactionKey;
  String transactionNo, containerNo, truckNo, size, type, bookingBLNo, vesselCode, 
         voyageNo, agentCode, activity;

  ReachStacker({this.branchID, this.transactionKey, this.transactionNo, this.containerNo,
              this.truckNo, this.size, this.type, this.bookingBLNo, this.vesselCode,
              this.voyageNo, this.agentCode, this.activity});

  factory ReachStacker.fromjSon(Map<String, dynamic> jSon) 
  {
    return ReachStacker(
        branchID: jSon['branchID'], 
        transactionKey: jSon['transactionKey'],
        transactionNo: jSon['transactionNo'],
        containerNo:jSon['containerNo'],
        truckNo:jSon['truckNo'], 
        size:jSon['size'], 
        type:jSon['type'], 
        bookingBLNo:jSon['bookingBLNo'], 
        vesselCode:jSon['vesselCode'], 
        voyageNo:jSon['voyageNo'], 
        agentCode:jSon['agentCode'], 
        activity:jSon['activity'],
    );
  }              

  Future<List<ReachStacker>> fetchRSList(int branchID) async{

    String root = 'http://dmsapi.logiconglobal.com';  // Network Server for live 
    String url = '$root/api/icd/equipmentjobcard/getpendingequipmentjobs/$branchID';

    var future = client.get(url,
                  headers: {"Accept": "application/json", "content-type": "application/json" });
    final response = await future;
    if (response.statusCode == 200) {
      List rsList = json.decode(response.body);
      List<ReachStacker> rsEquipJobs = rsList.map((data) => new ReachStacker.fromjSon(data)).toList();
      
      return rsEquipJobs;
    } else { throw Exception('Failed to fetch Pending R.S Equipment Jobs');} 
  }

}

class ReachStackerDetail{

  Client client = new Client();

  int branchID, transactionKey;
  String jobNo, transactionNo, containerNo, truckNo, size, type, bookingBLNo, vesselCode, 
         createdBy, createdOn, activityDescription, voyageNo, agentCode, activity,
         yardLocation;
  
  ReachStackerDetail({ this.branchID, this.transactionKey, this.jobNo, this.transactionNo, this.containerNo,
              this.truckNo, this.size, this.type, this.bookingBLNo, this.vesselCode, this.createdBy,
              this.createdOn, this.activityDescription, this.yardLocation, this.voyageNo, this.agentCode, 
              this.activity});

  factory ReachStackerDetail.fromjSon(Map<String, dynamic> jSon) 
    {
      return ReachStackerDetail(
          transactionNo: jSon['transactionNo'],
          containerNo:jSon['containerNo'],
          truckNo:jSon['truckNo'], 
          size:jSon['size'], 
          type:jSon['type'], 
          bookingBLNo:jSon['bookingBLNo'], 
          vesselCode:jSon['vesselCode'], 
          voyageNo:jSon['voyageNo'], 
          agentCode:jSon['agentCode'], 
          activity:jSon['activity'],

      );
  }

  Map<String, dynamic> toJSon() => {
    'branchID':this.branchID,
    'jobNo':this.jobNo,
    'transactionKey':this.transactionKey,
    'trucktransactionNo': this.transactionNo,
    'containerNo':this.containerNo,
    'truckNo':this.truckNo, 
    'size':this.size, 
    'type':this.type, 
    'bookingBLNo':this.bookingBLNo, 
    'vesselCode':this.vesselCode, 
    'voyageNo':this.voyageNo, 
    'agentCode':this.agentCode, 
    'activity':this.activity,
    'yardLocation':this.yardLocation,
    'createdBy': this.createdBy,
    'createdOn':this.createdOn,
    'activityDescription':this.activityDescription,
  };

  Future<List<ReachStackerDetail>> fetchRSJobdetails(int branchID, String transNo, int transKey) async{

    String root = 'http://dmsapi.logiconglobal.com';  // Network Server for live 
    String url = '$root/api/icd/equipmentjobcard/generatependingequipmentjob/$branchID/$transNo/$transKey';

    var future = client.get(url,
                  headers: {"Accept": "application/json", "content-type": "application/json" });
    final response = await future;
    if (response.statusCode == 200) {
      List rsDetails = json.decode(response.body);
      List<ReachStackerDetail> rsEquipJobDeatils = rsDetails.map((data) => new ReachStackerDetail.fromjSon(data)).toList();
      
      return rsEquipJobDeatils;
    } else { throw Exception('Failed to fetch Pending R.S Equipment Jobs Detail');} 
  }

  Future saveRSPendingJob(ReachStackerDetail rsDetail) async {
    
    String root = 'http://dmsapi.logiconglobal.com';  // Network Server for live 
    String url = '$root/api/icd/equipmentjobcard/save';
    bool respVal = false;

    var rsDtl = json.encode(rsDetail.toJSon());
    print(rsDtl);
    var future = client.post(url, body: rsDtl,
                  headers: {"Accept": "application/json", "content-type": "application/json" });
    final response = await future;
    print(response.body);
    if (response.statusCode == 200) {
      var isRSPJSuccess = json.decode(response.body);
      //print(' Posted pregatein info @ API ');
      respVal = isRSPJSuccess ? true : false;
    } else
      throw Exception('Failed to save Reach Stacker Equipment Job');  

    return respVal;
  }
}