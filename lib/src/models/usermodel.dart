// import 'package:http/http.dart' show get;
// import 'dart:convert';

class LoginUserInfo
{
  final String message;                //": "SUCCESS",
  final String role;                   //": "ADMIN",
  final String userID;                 //": "admin",
  final String companyCode;            //": "sct",
  final int branchId;                  //": 240,
  final String authToken;              //": "EF4A35B4-4A02-4FCD-BBA4-C4490A71D31F"
  String preGInDocNo;

  LoginUserInfo({this.message, this.role, this.userID, 
                this.companyCode, this.branchId, this.authToken, this.preGInDocNo});

  factory LoginUserInfo.fromJSon(Map<String, dynamic> json)
  {
     return new LoginUserInfo( 
      message: json['message'],
      role: json['role'],
      userID: json['userID'],
      companyCode: json['companyCode'],
      branchId: json['branchId'],
      authToken: json['authToken'],);
  }

}

class User
{
  final String userID;      //: "admin",
  final String password;    // ": "s3t",
  final int branchId;       //": 240,
  final String companyCode; // = 'sct';,
  final String yardCode;    //": "SCT EXP"
 

  User({this.userID,this.password,this.branchId,this.yardCode,this.companyCode});

  Map<String, dynamic> toJSon() =>
  { 
      'userID': userID,
      'password': password,
      'branchId': branchId,
      'yardCode': yardCode,
      'companyCode': companyCode
  };

}

class Branch {
  final int branchID;
  final String branchCode, branchName, companyCode;

  Branch({this.branchID, this.branchCode, this.branchName, this.companyCode});

  factory Branch.fromJson(Map<String, dynamic> json) {
    return Branch(
        branchID: json['branchID'],
        branchCode: json['branchCode'],
        branchName: json['branchName'],
        companyCode: json['companyCode']);
  }

  factory Branch.fromDb(Map<String, dynamic> json) {
    return Branch(
        branchID: json['branchID'],
        branchCode: json['branchCode'],
        branchName: json['branchName'],
        companyCode: json['companyCode']);
  }
}

class Yard{
  String yardCode;
  String description;

  Yard({this.yardCode,this.description});

  factory Yard.fromJson(Map<String, dynamic> json)
  {
    return Yard(yardCode: json['yardCode'],
          description: json['description']);
  }

}