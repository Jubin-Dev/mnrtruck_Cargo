import 'dart:convert';
import 'package:http/http.dart' show Client;
import 'package:m_n_r/src/models/usermodel.dart';

final _root = 'http://dmsapi.logiconglobal.com/api/master';

class MasterAPIprovider {
  Client client =Client();

  fetchBranches() async  {
    final response = await client
          .get('$_root/branch/branchlist/sct');
    final branchs = json.decode(response.body);

    return branchs;
  }
  
  fetchYards(int branchId) async {
    final response = await client
          .get('$_root/yard/branchyardlist/$branchId');
    final parsedJsonyards = json.decode(response.body);

    return Yard.fromJson(parsedJsonyards);
  }
}