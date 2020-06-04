

import 'package:flutter_spterp/api.dart';
import 'package:flutter_spterp/dao/uri.dart';
import 'package:flutter_spterp/util/user_util.dart';

/// 获取工程地址（任务单送货）地址
/// [eppCode] 工程代号
/// [compid]  企业代号
Future<List<dynamic>> getEppAddress(String eppCode) async {
  Map<String, dynamic> postMap = {
    'compid': await getEnterpriseId(),
    'eppCode': eppCode
  };
  Map<String, dynamic> sendMap = {};
  postMap.forEach((String key, Object value) {
    if (value != null && value != "null" && value != "") {
      sendMap[key] = value;
    }
  });

  return await post(URL.driver1["getEppAddress"], sendMap);
}

/// 司机定位接口 [id]小票id [location] 地址
Future driverLocation(int id, String location) async {
  Map<String, dynamic> postMap = {
    'compid': await getEnterpriseId(),
    'token': await getToken(),
    'id': id,
    'location': location,
  };
  Map<String, dynamic> sendMap = {};
  postMap.forEach((String key, Object value) {
    if (value != null && value != "null" && value != "") {
      sendMap[key] = value;
    }
  });

  return await post(URL.driver1["driverLocation"], sendMap);
}

/// 保存工程地址 [eppCode]工程代号 [address] 地址,
/// [addressType] 地址添加方式，0手动添加，1获取签收位置
Future saveEppAddress(String eppCode, String address, int addressType) async {
  Map<String, dynamic> postMap = {
    'compid': await getEnterpriseId(),
    'token': await getToken(),
    'eppCode': eppCode,
    'address': address,
    'addressType': addressType,
    'userName': await getUserName(),
  };
  Map<String, dynamic> sendMap = {};
  postMap.forEach((String key, Object value) {
    if (value != null && value != "null" && value != "") {
      sendMap[key] = value;
    }
  });

  return await post(URL.driver1["saveEppAddress"], sendMap);
}

/// 获取企业位置信息
Future getEnterpriseAddress() async {
  Map<String, dynamic> postMap = {
    'compid': await getEnterpriseId(),
    'token': await getToken(),
  };
  Map<String, dynamic> sendMap = {};
  postMap.forEach((String key, Object value) {
    if (value != null && value != "null" && value != "") {
      sendMap[key] = value;
    }
  });

  return await post(URL.erpEnterprise["getEnterpriseAddress"], sendMap);
}

