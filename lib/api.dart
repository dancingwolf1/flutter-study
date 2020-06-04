import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_spterp/component/toast.dart';
import 'package:flutter_spterp/main.dart';
import 'package:flutter_spterp/route.dart';
import 'package:flutter_spterp/servicer/user_quit_event.dart';
import 'package:flutter_spterp/util/user_util.dart';
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

String downloadUrl = "http://downloads.hntxrj.com";
String baseUrl = 'https://api.hntxrj.com/v1';
//String baseUrl = 'http://47.104.84.140:8080';
//String baseUrl = 'http://192.168.31.88:9501';
String erpUrl = "https://dev.erp.hntxrj.com";
//String erpUrl = "http://192.168.31.198:8088";
//String erpUrl = "http://192.168.31.88:8088";
// 司机服务地址
//String driverUrl = "http://192.168.31.178:9222";
//String driverUrl = "http://192.168.31.88:9222";
String driverUrl = "http://driver.erp.hntxrj.com";
bool debug = true; // 控制是否打印调试内容

/// 删除为空的提交内容
Map<String, dynamic> removeNullFormData(Map<String, dynamic> postMap) {
  Map<String, dynamic> sendMap = {};
  postMap.forEach((String key, Object value) {
    if (value != null && value != "null" && value != "") {
      sendMap[key] = value;
    }
  });
  return sendMap;
}


Future<Object> post(url, data,
    {Map<String, dynamic> headers, bool resultStr, bool isForm = false}) async {
  if(headers == null){
    headers = <String, dynamic>{};
    headers["user-agent"]="erpPhone";
    headers["pid"]= -1;
  }else{
    headers["user-agent"]="erpPhone";
  }
  BaseOptions options = BaseOptions(
      method: 'post',
      contentType: ContentType.parse("application/x-www-form-urlencoded"),
      headers: headers);
  Dio dio = new Dio(options);
  if (isForm) {
    data = FormData.from(data);
  }
  Response resp = await dio.post(
    url,
    data: data,
  );
  if (debug) {
    print("url: $url\n请求参数:$data \n请求结果:$resp");
  }
  Map<String, dynamic> respMap =
  resp.data is String ? json.decode(resp.data) : resp.data;
  if (debug) {
    print("url: $url \n请求返回代号:${respMap['code']}\n请求参数:$data \n请求结果:$resp");
  }
  if (resp.statusCode != 200) {
    Toast.show("网络异常");
  }
  if (resp.statusCode == 500) {
    // TODO: 采集异常
  }
  if (respMap['code'] != 0) {
    Toast.show(respMap['msg']);
    throw new Exception(respMap['msg']);
  }
  if (resultStr != null && resultStr) {
    return respMap["data"];
  }
  try {
    return respMap["data"] is String
        ? json.decode(respMap["data"])
        : respMap["data"];
  } catch (v) {}
}

Future<Object> get(url, {data, headers, bool resultStr}) async {
  BaseOptions options = BaseOptions(
      method: 'get',
      headers: headers == null
          ? {
        'pid': -1,
      }
          : headers);
  Dio dio = new Dio(options);
  Response resp = await dio.get(
    url,
    queryParameters: data,
  );
  if (debug) {
    print("url: $url\n请求参数:$data \n请求结果:$resp");
  }
  Map<String, dynamic> respMap =
  resp.data is String ? json.decode(resp.data) : resp.data;
  if (debug) {
    print("url: $url \n请求返回代号:${respMap['code']}\n请求参数:$data \n请求结果:$resp");
  }
  if (resp.statusCode != 200) {
    Toast.show("网络异常");
  }
  if (resp.statusCode == 500) {
    // TODO: 采集异常
  }
  if (respMap['code'] == -10006) {
    SharedPreferences pref = await SharedPreferences.getInstance();

    pref.remove("user");
    pref.remove("agid");
    pref.remove("selectedEnterprise");
    pref.remove("authValue");
    String luyou =pref.getString("luyou");
    if(luyou =="2"){
      main();
      pref.setString("luyou", "1");
    }else{
      route();
      pref.setString("luyou", "2");
    }
  }
  if (respMap['code'] != 0) {
    Toast.show(respMap['msg']);
    throw new Exception(respMap['msg']);
  }
  if (resultStr != null && resultStr) {
    return respMap["data"];
  }
  return respMap["data"] is String
      ? json.decode(respMap["data"])
      : respMap["data"];
}

// 处理下载产品的get请求
Future<Object> getDownload(url, {data, headers, bool resultStr}) async {
  BaseOptions options = BaseOptions(
      method: 'get',
      headers: headers == null
          ? {
        'pid': -1,
      }
          : headers);
  Dio dio = new Dio(options);
  Response resp = await dio.get(
    url,
    queryParameters: data,
  );
  Map<String, dynamic> respMap =
  resp.data is String ? json.decode(resp.data) : resp.data;
  return respMap;
}

// 处理快捷方式
Future<Object> post1(url, data, {headers, bool resultStr}) async {
  BaseOptions options = BaseOptions(
      method: 'post',
      contentType: ContentType.parse("application/x-www-form-urlencoded"),
      headers: headers == null
          ? {
        'pid': -1,
      }
          : headers);
  Dio dio = new Dio(options);
  Response resp = await dio.post(
    url,
    data: data,
  );
  if (debug) {
    print("url: $url\n请求参数:$data \n请求结果:$resp");
  }
  Map<String, dynamic> respMap =
  resp.data is String ? json.decode(resp.data) : resp.data;
  if (debug) {
    print("url: $url \n请求返回代号:${respMap['code']}\n请求参数:$data \n请求结果:$resp");
  }
  if (resp.statusCode != 200) {
    Toast.show("网络异常");
  }
  if (resp.statusCode == 500) {
    // TODO: 采集异常
  }
  if (respMap['code'] == -10006) {
    SharedPreferences pref = await SharedPreferences.getInstance();

    pref.remove("user");
    pref.remove("agid");
    pref.remove("selectedEnterprise");
    pref.remove("authValue");
    String luyou =pref.getString("luyou");
    if(luyou =="2"){
      main();
      pref.setString("luyou", "1");
    }else{
      route();
      pref.setString("luyou", "2");
    }
  }
  if (respMap['code'] != 0) {
    Toast.show(respMap['msg']);
    throw new Exception(respMap['msg']);
  }
  if (resultStr != null && resultStr) {
    return respMap["data"];
  }
  if (respMap["data"] == "") {
    return [];
  }


  return respMap["data"].replaceAll('[', '').replaceAll(']', '').split(','); // 我会返回数组

/*  return respMap["data"] is String
      ? json.decode(respMap["data"])
      : respMap["data"];*/
}

// 自动生成合同编号
Future<Object> postResultString(url, data, {headers, bool resultStr}) async {
  BaseOptions options = BaseOptions(
      method: 'post',
      contentType: ContentType.parse("application/x-www-form-urlencoded"),
      headers: headers == null
          ? {
        'pid': -1,
      }
          : headers);
  Dio dio = new Dio(options);
  Response resp = await dio.post(
    url,
    data: data,
  );
  if (debug) {
    print("url: $url\n请求参数:$data \n请求结果:$resp");
  }
  Map<String, dynamic> respMap =
  resp.data is String ? json.decode(resp.data) : resp.data;
  if (debug) {
    print("url: $url \n请求返回代号:${respMap['code']}\n请求参数:$data \n请求结果:$resp");
  }
  if (resp.statusCode != 200) {
    Toast.show("网络异常");
  }
  if (resp.statusCode == 500) {
    // TODO: 采集异常
  }
  if (respMap['code'] != 0) {
    Toast.show(respMap['msg']);
    throw new Exception(respMap['msg']);
  }
  if (resultStr != null && resultStr) {
    return respMap["data"];
  }
  if (respMap["data"] == "") {
    return [];
  }

  return respMap["data"];
}

Future<Object> postForm(url, formDate, {headers, resultStr}) async {
  BaseOptions options = BaseOptions(
      method: 'post',
      headers: headers == null
          ? {
        'pid': -1,
      }
          : headers);
  Dio dio = new Dio(options);
  Response resp = await dio.post(url, data: formDate);
  Map<String, dynamic> respMap =
  resp.data is String ? json.decode(resp.data) : resp.data;
  if (debug) {
    print("url: $url \n请求返回代号:${respMap['code']}\n请求参数:$formDate \n请求结果:$resp");
  }
  if (resp.statusCode != 200) {
    Toast.show("网络异常");
  }
  if (resp.statusCode == 500) {
    // TODO: 采集异常
  }
  if (respMap['code'] != 0) {
    Toast.show(respMap['msg']);
    throw new Exception(respMap['msg']);
  }
  if (resultStr) {
    return respMap["data"];
  }

  return respMap["data"] is String
      ? json.decode(respMap["data"])
      : respMap["data"];
}

Future<Object> postFormJson(url, data, {headers, bool resultStr}) async {
  BaseOptions options = BaseOptions(
      method: 'post',
      contentType: ContentType.parse("application/json"),
      headers: headers == null
          ? {
        'pid': -1,
      }
          : headers);
  Dio dio = new Dio(options);
  Response resp = await dio.post(
    url,
    data: data,
  );
  if (debug) {
    print("url: $url\n请求参数:$data \n请求结果:$resp");
  }
  Map<String, dynamic> respMap =
  resp.data is String ? json.decode(resp.data) : resp.data;
  if (debug) {
    print("url: $url \n请求返回代号:${respMap['code']}\n请求参数:$data \n请求结果:$resp");
  }
  if (resp.statusCode != 200) {
    Toast.show("网络异常");
  }
  if (resp.statusCode == 500) {
    // TODO: 采集异常
  }
  if (respMap['code'] != 0) {
    Toast.show(respMap['msg']);
    throw new Exception(respMap['msg']);
  }
  if (resultStr != null && resultStr) {
    return respMap["data"];
  }
  return respMap["data"] is String
      ? json.decode(respMap["data"])
      : respMap["data"];
}

Future<Object> getJSON(url, {headers, resultStr, queryParameters}) async {
  BaseOptions options = BaseOptions(
      method: 'get',
      headers: headers == null
          ? {
        'pid': -1,
      }
          : headers);
  Dio dio = new Dio(options);
  Response resp = await dio.get(url, queryParameters: queryParameters);
  Map<String, dynamic> respMap =
  resp.data is String ? json.decode(resp.data) : resp.data;
  if (debug) {
    print(
        "url: $url \n请求返回代号:${respMap['code']}\n请求参数:$queryParameters \n请求结果:$resp");
  }
  if (resp.statusCode != 200) {
    Toast.show("网络异常");
  }
  if (resp.statusCode == 500) {
    // TODO: 采集异常
  }
  return respMap;
}

Future<List<dynamic>> postResultList(url, formDate,
    {headers, resultStr}) async {
  BaseOptions options = BaseOptions(
      method: 'post',
      contentType: ContentType.parse("application/x-www-form-urlencoded"),
      headers: headers == null
          ? {
        'pid': -1,
      }
          : headers);
  Dio dio = new Dio(options);
  Response resp = await dio.post(url, data: formDate);
  List<dynamic> resultList = json.decode(resp.data);
  if (debug) {
    print("url: $url\n请求参数:$formDate \n请求结果:$resp");
  }
  if (resp.statusCode != 200) {
    Toast.show("网络异常");
  }
  if (resp.statusCode == 500) {
    // TODO: 采集异常
  }
  return resultList;
}

/// 获取企业id
Future<String> getEnterpriseId() async {
  Map<String, dynamic> e = await getEnterprise();
  String eid = e['eid'] >= 10 ? e['eid'].toString() : "0" + e['eid'].toString();
  return eid;
}

Future<String> getUid() async {
  Map<String, dynamic> user = await getUser();

  String uid = user["uid"].toString();
  return uid;
}

Future<String> getUserName() async {
  Map<String, dynamic> user = await getUser();

  String username = user["username"].toString();
  return username;
}

Map<String, String> models = {
  "user": baseUrl + "/user",
  "journalism": baseUrl + "/journalism",
  "feedback": baseUrl + "/feedback",
  "enterprise": baseUrl + "/enterprise",
  "contract": erpUrl + "/api/contract",
  "epp": erpUrl + "/api/epp",
  "builder": erpUrl + "/api/builder",
  "placing": erpUrl + "/api/placing",
  "salesman": erpUrl + "/api/salesman",
  "public": erpUrl + "/api/public",
  "formula": erpUrl + "/api/formula",
  "taskPlan": erpUrl + "/api/taskPlan",
  "stock": erpUrl + "/api/stock",
  "vehicle": erpUrl + "/api/vehicle",
  "stirInfoSet": erpUrl + "/api/stirInfoSet",
  "weightType": erpUrl + "/api/public",
  "stockIn": erpUrl + "/api/stockIn",
  "matweigh": erpUrl + "/api/stockIn",
  "concrete": erpUrl + "/api/concrete",
  "consume": erpUrl + "/api/consume",
  "production": erpUrl + "/api/production",
  "stgIdMange": erpUrl + "/api/stgIdMange",
  "total": erpUrl + "/total",
  "laboratroy": erpUrl + "/api/laboratroy", // 尚未用到该接口
  "vehicleId": erpUrl + "/api/vehicleId",
  "laboratroy": erpUrl + "/laboratroy",
  "auth": erpUrl + "/auth",
  "baseAuth": baseUrl + "/auth",
  "accessories": erpUrl + "/api/parts",
  "construction": erpUrl + "/api/construction",
  "contractV2": erpUrl + "/contract",
  "produce": erpUrl + "/produce",
  "driver": erpUrl + "/driver",
  "statistic": baseUrl + "/statistic",
  "driver1": driverUrl + "/driver", // 司机模块
};

Map<String, String> driver1 = {
  //获取工程地址（任务单送货）地址
  "getEppAddress": models["driver1"] + "/getEppAddress",
  //保存工程地址
  "saveEppAddress": models["driver1"] + "/saveEppAddress",
  //保存工程地址
  "driverLocation": models["driver1"] + "/driverLocation",
  // 获取本企业所有司机最后的位置信息
  "getDriverLocals": models['driver1'] + "/getDriverLocals"
};

Map<String, String> driver = {
  "getDriverList": models["driver"] + "/getDriverList",
};
Map<String, String> contractV2 = {
  "addEppName": models["contractV2"] + "/spinsertUpDelSMEPPInfo",
};

Map<String, String> produce = {
  "addConstructionUnit": models["produce"] + "/insertUpDelBuilder",
  "getRealStock": models["produce"] + "/getRealStock"
};

Map<String, String> other = {
  // 检测更新/
  "checkUpadte": "http://downloads.hntxrj.com/version.json",
};

Map<String, String> baseAuth = {
  "getAuthValue": models['baseAuth'] + "/getAuthValue",
  "getAuthGroup": models['baseAuth'] + "/getAuthGroup",
  "getAuthGroupDropDown": models['baseAuth'] + "/getAuthGroupDropDown",
  "getMenuListByProject": models["baseAuth"] + "/getMenuListByProject",
  "openAuth": models["baseAuth"] + "/openAuth",
  "editAuthGroup": models["baseAuth"] + "/editAuthGroup",
  "saveAuthValue": models["baseAuth"] + "/saveAuthValue",
};

Map<String, String> laboratroy = {
  "getFormulaInfo": models['laboratroy'] + "/getFormulaInfo",
  "spinsertLMTaskTheoryFormula":
      models['laboratroy'] + "/spinsertLMTaskTheoryFormula",
  "spVerifyLMTaskTheoryFormula":
      models['laboratroy'] + "/spVerifyLMTaskTheoryFormula",
};

Map<String, String> total = {
  "phoneStatistics": models['total'] + "/phoneStatistics"
};
Map<String, String> production = {
  "getProductionStatistics": models['production'] + "/getProductionStatistics",
  "getProductionStatisticstotalPreNum":
      models['production'] + "/getProductionStatisticstotalPreNum",
};
Map<String, String> vehicleId = {
  "getVehicleId": models['vehicleId'] + "/getVehicleId",
};
Map<String, String> consume = {
  "getTaskConsumeList": models['consume'] + "/getTaskConsumeList",
  "getConsumptionTotal": models['consume'] + "/getConsumptionTotal",
  "getFormulaDetails": models['consume'] + "/getFormulaDetails",
  "getMatTotal": models['consume'] + "/getMatTotal",
  "getConsumeClose": models['consume'] + "/getConsumeClose",
  "getProductDatail": models['consume'] + "/getProductDatail",
  "getErroPan": models['consume'] + "/getErroPan",
};
Map<String, String> weightType = {
  "getweightType": models['weightType'] + "/getDropDown"
};
Map<String, String> stirInfoSet = {
  "getStirInfoSet": models['stirInfoSet'] + "/getStirInfoSet"
};
Map<String, String> vehicle = {
  "getVehicleWorkloadDetail": models['vehicle'] + "/getVehicleWorkloadDetail",
  "getVehicleWorkloadSummary": models['vehicle'] + "/getVehicleWorkloadSummary",
  "getVehicleWorkTowingPumpDetail":
      models['vehicle'] + "/getVehicleWorkTowingPumpDetail",
  "getVehicleWorkTowingPumpCount":
      models['vehicle'] + "/getVehicleWorkTowingPumpCount",
  "getDriverTransportationDetails":
      models['vehicle'] + "/getDriverTransportationDetails",
  "getDriverTransportationCount":
      models['vehicle'] + "/getDriverTransportationCount",
  "getDriverDragPumpCount": models['vehicle'] + "/getDriverDragPumpCount",
  "getPumpTruckCount": models['vehicle'] + "/getPumpTruckCount",
  "getPumpOperatorTruckCount": models['vehicle'] + "/getPumpOperatorTruckCount",
  "getPumpTruckDetails": models['vehicle'] + "/getPumpTruckDetails",
  "getWorkloadStatistics": models['vehicle'] + "/getWorkloadStatistics",
  "getVehicleWorkloadSummaryCount":
      models['vehicle'] + "/getVehicleWorkloadSummaryCount",
  "getDriverTransportationSum":
      models['vehicle'] + "/getDriverTransportationSum",
  "getPumpTruckSum": models['vehicle'] + "/getPumpTruckSum",
  "getPumpTruckWorkloadStatistics":
      models['vehicle'] + "/getPumpTruckWorkloadStatistics",
  "getPumpTruckSum": models['vehicle'] + "/getPumpTruckSum",
  "getDriverTransportationSum":
      models['vehicle'] + "/getDriverTransportationSum",
  "getDriverTransportationCarNumList":
      models['vehicle'] + "/getDriverTransportationCarNumList",
  "stock": models['vehicle'] + "/api/stock",
  "stockIn": models['vehicle'] + "/api/stockIn",
  "getVehicleId": models['vehicle'] + "/api/getVehicleId",
};
Map<String, String> stockIn = {
  "getMatStatistics": models['stockIn'] + "/getMatStatistics",
  "getMatDetailsList": models['stockIn'] + "/getMatDetailsList",
  "getMaterialCount": models['stockIn'] + "/getMaterialCount",
  "getStockInDetails": models['stockIn'] + "/getStockInDetails",
  "getStockInCollectClose": models['stockIn'] + "/getStockInCollectClose",
  "getMatStatisticsClose": models['stockIn'] + "/getMatStatisticsClose",
  "getStockInSelectClose": models['stockIn'] + "/getStockInSelectClose",
  "getWeightByMatParent": models['stockIn'] + "/getWeightByMatParent",
  "stock": models['stockIn'] + "/api/stock",
  "vehicle": models['stockIn'] + "/api/vehicle",
  "stirInfoSet": models['stockIn'] + "/api/stirInfoSet",
  "weightType": models['stockIn'] + "/api/public",
};
Map<String, String> stock = {
  "getStirIds": models['stock'] + "/getStirIds",
  "getStock": models['stock'] + "/getStock",
};

Map<String, String> userModel = {
  "login": models['user'] + "/login",
  "updatePassword": models['user'] + "/updatePassword",
  "userHeader": models['user'] + "/setHeader",
  "getUserFavorite": models['user'] + "/getUserFavorite",
  "setUserFavorite": models['user'] + "/setUserFavorite",
  "userList": models['user'] + "/userList",
  "addUser": models['user'] + "/addUser",
  "setUserAuth": models['user'] + "/setUserAuth",
  "editUser": models['user'] + "/editUser",
  "initUser": models['user'] + "/initUser",
  "details": models['user'] + "/details",
  "getBindDriver": models['user'] + "/getBindDriver",
  "bindDriver": models['user'] + "/bindDriver",
  "loginCount": models['statistic'] + "/userLogin"
};
Map<String, String> journalismModel = {
  "journalismList": models['journalism'] + "/selectJournalism",
  "getJournalismDetail": models['journalism'] + "/getJournalism",
};

Map<String, String> feedbackModel = {
  "feedbackHeader": models['feedback'] + "/uploadPicture",
  "addFeedback": models['feedback'] + "/addFeedback",
};
Map<String, String> enterprise = {
  "uploadPicture": models['enterprise'] + "/uploadPicture",
  "saveCollectionCode": models['enterprise'] + "/saveCollectionCode",
  "selectEnterprise": models['enterprise'] + "/getEnterprise",
};
Map<String, String> contractModel = {
  "contractList": models['contract'] + "/getContractList",
  "getContractDetail": models['contract'] + "/getContractDetail",
  "verifyContract": models['contract'] + "/verifyContract",
  "getContractGradePrice": models['contract'] + "/getContractGradePrice",
  "getContractPriceMarkup": models['contract'] + "/getContractPriceMarkup",
  "getContractPumpPrice": models['contract'] + "/getContractPumpPrice",
  "getContractDistanceSet": models['contract'] + "/getContractDistanceSet",
  "getContractTypeDropDown": models['contract'] + "/getContractTypeDropDown",
  "getPriceTypeDropDown": models['contract'] + "/getPriceTypeDropDown",
  "addContract": models['contract'] + "/addContract",
  "TaskList": models['taskPlan'] + "/taskPlanList",
  "getStgIdDropDown": models['contract'] + "/getStgIdDropDown",
  "saveContractGradePrice": models['contract'] + "/saveContractGradePrice",
  "getPriceMarkupDropDown": models['contract'] + "/getPriceMarkupDropDown",
  "saveContractPriceMarkup": models['contract'] + "/saveContractPriceMarkup",
  "saveContractDistance": models['contract'] + "/saveContractDistance",
  "taskPlan": models['contract'] + "/taskPlan",
  "selectPumpTruckList": models['contract'] + "/selectPumpTruckList",
  "insertPumpTruck": models['contract'] + "/insertPumpTruck",
  "getAdjunct": models['contract'] + "/getAdjunct",
  "delAdjunct": models['contract'] + "/delAdjunct",
  "adjunct": models['contract'] + "/adjunct",
  "uploadAdjunct": models['contract'] + "/uploadAdjunct",
  "makeAutoContractId": models['contract'] + "/makeAutoContractId",
};
Map<String, String> concrete = {
  "getConcreteCount": models['concrete'] + "/getConcreteCount",
  "getConcreteSum": models['concrete'] + "/getConcreteSum"
};

Map<String, String> stgIdMange = {
  "getConcreteLabelingManagement": models['stgIdMange'] + "/getStgIdManage",
};

Map<String, String> construction = {
  "getInvitationCode": models['construction'] + "/getInvitationCode",
  "getInvitationList": models['construction'] + "/getInvitationList",
  "updateUseStatus": models['construction'] + "/updateUseStatus",
};
Map<String, String> matweigh = {
  "getWeightByMat": models['matweigh'] + "/getWeightByMat",
  "getWeightByVechicId": models['matweigh'] + "/getWeightByVechicId",
  "getWeightByStoName": models['matweigh'] + "/getWeightByStoName",
  "getWeightBySupName": models['matweigh'] + "/getWeightBySupName",
  "getWeightByEmpName": models['matweigh'] + "/getWeightByEmpName",
  "getSynthesizeByMat": models['matweigh'] + "/getSynthesizeByMat",
  "getWeightClose": models['matweigh'] + "/getWeightClose",
};
Map<String, String> taskPlan = {
  "getTaskSaleInvoiceDetail": models['taskPlan'] + "/getTaskSaleInvoiceDetail",
  "getTaskSaleInvoiceList": models['taskPlan'] + "/getTaskSaleInvoiceList",
  "getTaskSaleInvoiceExamine":
      models['taskPlan'] + "/getTaskSaleInvoiceExamine",
  "getDriverShiftLED": models['taskPlan'] + "/getDriverShiftLED",
  "getDriverShiftList": models['taskPlan'] + '/getDriverShiftList',
  "getDriverShiftUpdate": models['taskPlan'] + '/getDriverShiftUpdate',
  "getDriverShiftInsert": models['taskPlan'] + '/getDriverShiftInsert',
  "getPersonalName": models['taskPlan'] + '/getPersonalName',
  "getProductionRatio": models['taskPlan'] + '/getProductionRatio',
  "getTheoreticalproportioning":
      models['taskPlan'] + '/getTheoreticalproportioning',
  "getVirtualRatio": models['taskPlan'] + '/getVirtualRatio',
  "makeAutoTaskPlanId": models['taskPlan'] + '/makeAutoTaskPlanId',
  "isExistence": models['taskPlan'] + '/isExistence',
  "getPriceMarkup": models['taskPlan'] + '/getPriceMarkup',
  "addTaskPriceMarkup": models['taskPlan'] + '/addTaskPriceMarkup',
};

Map<String, String> taskModel = {
  "taskList": models['taskPlan'] + "/taskPlanList",
  "getTaskDetail": models['taskPlan'] + "/getTaskPlanDetail",
  "addTask": models['taskPlan'] + "/addTaskPlan",
  "review": models['taskPlan'] + "/verifyTaskPlan",
  "getSendCarList": models['taskPlan'] + "/getSendCarList",
  "getSendCarDistance": models['taskPlan'] + "/getSendCarDistance",
  "getSendCarTodayNum": models['taskPlan'] + "/getSendCarTodayNum",
  "getSendCarCountNum": models['taskPlan'] + "/getSendCarCountNum",
  "totalProductNum": models['taskPlan'] + "/totalProductNum",
  "totalScraoNum": models['taskPlan'] + "/totalScraoNum",
  "getSquareQuantitySum": models['taskPlan'] + "/getSquareQuantitySum",
  "phoneStatistics": models['taskPlan'] + "/phoneStatistics",
};

Map<String, String> eppModel = {"getDropDown": models['epp'] + "/getDropDown"};

Map<String, String> builderModel = {
  "getDropDown": models['builder'] + "/getDropDown"
};
Map<String, String> placingModel = {
  "getDropDown": models['placing'] + "/getDropDown"
};
Map<String, String> salesmanModel = {
  "getDropDown": models['salesman'] + "/getDropDown"
};
Map<String, String> publicModel = {
  "getDropDown": models['public'] + "/getDropDown"
};
Map<String, String> formulaModel = {
  "getFormulaList": models['formula'] + "/getFormulaList",
  "getFormulaByTaskId": models['formula'] + "/getFormulaByTaskId",
  "getFormulaInfo": models['formula'] + "/getFormulaInfo"
};
Map<String, String> accessories = {
  "getAccessoriesList": models['accessories'] + "/getPartsList",
  "getBuyerList": models['accessories'] + "/getBuyerList",
  "getDepartmentList": models['accessories'] + "/getDepartmentList",
  "getRequestStatusList": models['accessories'] + "/getRequestStatusList",
  "addWmConFigureApply": models['accessories'] + "/addWmConFigureApply",
  "getMnemonicCodeList": models['accessories'] + "/getMnemonicCodeList",
  "getRequestNumberDetail": models['accessories'] + "/getRequestNumberDetail",
  "editWmConFigureApply": models['accessories'] + "/editWmConFigureApply",
  "editRequestStatus": models['accessories'] + "/editRequestStatus",
  "cancelRequestStatus": models['accessories'] + "/cancelRequestStatus",
};
// user model
/// 用户登录
Future<Map<String, dynamic>> login(String phone, String password) async {
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  String version = packageInfo.version;
  String buildNumber = packageInfo.buildNumber;
  version ="$version+$buildNumber";
  Map<String, dynamic> userMap =
  await post(userModel['login'], {"phone": phone, "password": password,"version":version});

  // 保存user
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString("user", json.encode(userMap));

  //用户每登录一次向用户统计表中插入一条数据
  Map<String, dynamic> statisticMap = {
    "compid": await getEnterpriseId(),
    "uid": await getUid(),
    "appCode": 1
  };
  post(userModel['loginCount'], statisticMap);
  verifyEquipment();
  return userMap;
}

// 验证是否在多个设备中登录.
void verifyEquipment(){
  //每秒向后台发送一个请求验证token是否有效
  Timer intervalTime = Timer(Duration(milliseconds: 0), () {});
  intervalTime=Timer.periodic(Duration(seconds: 5), (timer) async{
    String token;
    Map<String, dynamic> userCheck;
    try{
      token=await getToken();
      userCheck = await tokenUse(token);
      if(userCheck["code"] == -20006){
        //发送订阅消息退出登录.
        eventBus.fire(UserQuitEvent());
      }
    }catch(c){
      // 获取token异常.
      intervalTime.cancel();
      eventBus.fire(UserQuitEvent());
    }
    if(userCheck==null){
      // 使用回调函数进行退出登录.
      intervalTime.cancel();
    }
  });
}
/// 验证token是否有效
Future<Map<String, dynamic>> tokenUse(String token) async {
  Map<String, dynamic> headers = {
    "pid": 2,
    "enterprise": await getEnterpriseId(),
    "token": await getToken(),
  };
  Map<String, dynamic> status = await post(userModel['tokenCheck'],
      {"token": token},
      headers: headers);
  return status;
}
/// 上传头像
/// formDate 图片
Future<Map<String, dynamic>> userHeader(FormData formData) async {
  Map<String, dynamic> headers = {
    "pid": 2,
    "enterprise": await getEnterpriseId(),
    "token": await getToken(),
  };
  Map<String, dynamic> userMap = await postForm(
      userModel['userHeader'], formData,
      headers: headers, resultStr: false);
  return userMap;
}

/// 修改密码
/// oldPassword 老密码
/// newPassword 新密码
Future<Map<String, dynamic>> updatePassword(
  String oldPassword,
  String newPassword,
  String token,
) async {
  Map<String, dynamic> headers = {
    "pid": 2,
    "enterprise": await getEnterpriseId(),
    "token": await getToken(),
  };
  Map<String, dynamic> userMap = await post(userModel['updatePassword'],
      {"oldPassword": oldPassword, "newPassword": newPassword, "token": token},
      headers: headers);

  return userMap;
}

/// 新闻列表
/// @param page         页码
/// @param pageSize     每页数量
Future<Map<String, dynamic>> journalismlist(int page, {int pageSize}) async {
  Map<String, dynamic> headers = {
    "pid": 2,
    "enterprise": await getEnterpriseId(),
    "token": await getToken(),
  };

  Map<String, dynamic> postMap = {
    'page': page,
    'pageSize': pageSize == null ? 10 : pageSize
  };
  Map<String, dynamic> sendMap = {};

  sendMap = removeNullFormData(postMap);
  Map<String, dynamic> journalismMap =
      await post(journalismModel['journalismList'], sendMap, headers: headers);

  return journalismMap;
}

/// 新闻详情
/// id 新闻id
Future<Map<String, dynamic>> getJournalismDetail(int id) async {
  Map<String, dynamic> headers = {
    "pid": 2,
    "enterprise": await getEnterpriseId(),
    "token": await getToken(),
  };

  Map<String, dynamic> postMap = {
    'id': id,
  };
  Map<String, dynamic> sendMap = {};

  sendMap = removeNullFormData(postMap);
  Map<String, dynamic> journalismMap = await post(
      journalismModel['getJournalismDetail'], sendMap,
      headers: headers);

  return journalismMap;
}

///查询企业id
Future<Map<String, dynamic>> selectEnterprise(int eid) async {
  Map<String, dynamic> headers = {
    "pid": 2,
    "enterprise": await getEnterpriseId(),
    "token": await getToken(),
  };

  Map<String, dynamic> postMap = {
    'eid': eid,
  };
  Map<String, dynamic> sendMap = {};

  sendMap = removeNullFormData(postMap);
  Map<String, dynamic> enterpriseId =
      await post(enterprise['selectEnterprise'], sendMap, headers: headers);

  return enterpriseId;
}

/// 合同列表查询
/// @param startTime    签订日期 开始时间
/// @param endTime      签订日期 结束时间
/// @param contractCode 合同编号
/// @param eppCode      工程代号
/// @param buildCode    施工单位代号
/// @param salesMan     销售员代号
/// @param page         页码
/// @param pageSize     每页数量
/// @return 合同列表
Future<Map<String, dynamic>> contractList(int page,
    {String startTime,
    String endTime,
    String contractCode,
    String eppCode,
    String buildCode,
    String salesMan,
    int pageSize,
    eppName,
    builderName,
    taskId,
    taskStatus,
      verifyStatus,
    }) async {
  Map<String, dynamic> postMap = {
    'startTime': startTime,
    'endTime': endTime,
    'contractCode': contractCode,
    'eppCode': eppCode,
    'eppName': eppName,
    'buildCode': buildCode,
    'salesMan': salesMan,
    'compid': await getEnterpriseId(),
    'page': page,
    'pageSize': pageSize == null ? 20 : pageSize,
    'verifyStatus':verifyStatus
  };

  Map<String, dynamic> sendMap = {};

  sendMap = removeNullFormData(postMap);
  return await post(contractModel['contractList'], sendMap);
}

/*获取开具生产配比列表
* @param eppName taskStatus 任务单状态
* @param eppName eppName 工程名称
* @param eppName placing 出售
* @param eppName taskId 任务id
* @param eppName startTime 开始时间
* @param eppName endTime 结束时间
* @param eppName compid 企业id
* @param eppName builderName 施工单位名
* @param eppName formulaStatus 配比状态
* @param eppName opid 创建人id
* */
Future<Map<String, dynamic>> getFormulaList(
  int page, {
  String taskStatus,
  String eppCode,
  String placing,
  String taskId,
  String startTime,
  String endTime,
  String compid,
  String builderCode,
  int formulaStatus,
  String opid,
  int pageSize,
}) async {
  Map<String, dynamic> postMap = {
    'taskStatus': taskStatus,
    'eppCode': eppCode,
    'placing': placing,
    'taskId': taskId,
    'startTime': startTime,
    'endTime': endTime,
    'compid': await getEnterpriseId(),
    'builderCode': builderCode,
    'formulaStatus': formulaStatus,
    'opid': opid,
    'page': page,
    'pageSize': pageSize == null ? 10 : pageSize
  };
  Map<String, dynamic> sendMap = {};

  sendMap = removeNullFormData(postMap);
  return await post(formulaModel['getFormulaList'], sendMap);
}

/*开具生产配比配比详情
*  taskId 任务id
*  compid 企业id
*  */
Future<Map<String, dynamic>> getFormulaByTaskId(String taskId,
    {String compid}) async {
  Map<String, dynamic> postMap = {
    'compid': await getEnterpriseId(),
    'taskId': taskId
  };
  Map<String, dynamic> sendMap = {};

  sendMap = removeNullFormData(postMap);

  return await post(formulaModel['getFormulaByTaskId'], sendMap);
}

/*开具生产配比线号数据
* compid 企业id
* taskid 任务id
* stirid 线号id*/
Future<Map<String, dynamic>> getFormulaInfo(String taskId, String stirId,
    {String compid}) async {
  Map<String, dynamic> postMap = {
    'compid': await getEnterpriseId(),
    'taskId': taskId,
    'stirId': stirId
  };
  Map<String, dynamic> sendMap = {};

  sendMap = removeNullFormData(postMap);

  return await post(formulaModel['getFormulaInfo'], sendMap);
}

/// 任务单列表查询
/// @param startTime    签订日期 开始时间
/// @param endTime      签订日期 结束时间
/// @param eppCode      工程代号
/// @param buildCode    施工单位代号
/// @param placing      浇筑部位
/// @param taskId       任务单号
/// @param page         页码
/// @param pageSize     每页数量
/// @return 任务单列表
Future<Map<String, dynamic>> taskList(int page,
    {String beginTime,
    String endTime,
    String eppCode,
    String buildCode,
    String placing,
    String taskId,
    String taskStatus,
    int pageSize}) async {
  Map<String, dynamic> postMap = {
    'beginTime': beginTime,
    'endTime': endTime,
    'eppCode': eppCode,
    'builderCode': buildCode,
    'placing': placing,
    'taskId': taskId,
    'taskStatus': taskStatus,
    'compid': await getEnterpriseId(),
    'page': page,
    'pageSize': pageSize == null ? 10 : pageSize
  };

  Map<String, dynamic> sendMap = {};

  sendMap = removeNullFormData(postMap);

  return await post(taskModel['taskList'], sendMap);
}

/// 添加任务单
/// @param taskId 任务单号
/// @param compid 站别代号
/// @param preTime 预计时间
/// @param preNum 预计方量
/// @param contractUid 合同UID号
/// @param cContractCode 子合同号
/// @param eppCode 工程代号
/// @param builderCode 施工单位代号
/// @param slump 塌落度
/// @param stgId 标号(强度)
/// 以上为必填参数
/// 下列为选填参数
/// @param attribute 砼标号特性
/// @param placing 浇筑部位
/// @param placeStyle 浇筑方式
/// @param address 交货地址
/// @param technicalRequirements 技术要求
/// @param preCarNum 预计车量
/// @param linkMan 现场联系人
/// @param linkTel 联系电话
/// @param stoneyAsk 石料要求
/// @param stoneDia 石子粒径
/// @param cementvariety 水泥品种
/// @param grade 抗折等级
/// @param preRemark 预计备注
/// @param distance 区间距离
Future<Map<String, dynamic>> addTask(
    String preTime,
    double preNum,
    String contractUid,
    String cContractCode,
    String eppCode,
    String builderCode,
    String slump,
    String stgId,
    String attribute,
    String placing,
    String placeStyle,
    String address,
    String technicalRequirements,
    int preCarNum,
    String linkMan,
    String linkTel,
    String stoneAsk,
    String stoneDia,
    String cementVariety,
    String grade,
    String preRemark,
    double distance,
    {String taskId}) async {
  Map<String, dynamic> postMap = {};
  if (taskId != "" && taskId != null) {
    postMap = {
      'taskId': taskId,
      'preTime': preTime,
      'preNum': preNum,
      'contractUid': contractUid,
      'cContractCode': cContractCode,
      'eppCode': eppCode,
      'builderCode': builderCode,
      'slump': slump,
      'stgId': stgId,
      'attribute': attribute,
      'placing': placing,
      'placeStyle': placeStyle,
      'address': address,
      'technicalRequirements': technicalRequirements,
      'preCarNum': preCarNum,
      'linkMan': linkMan,
      'linkTel': linkTel,
      'stoneAsk': stoneAsk,
      'stoneDia': stoneDia,
      'cementVariety': cementVariety,
      'grade': grade,
      'preRemark': preRemark,
      'distance': distance,
      'compid': await getEnterpriseId(),
    };
  } else {
    postMap = {
      'preTime': preTime,
      'preNum': preNum,
      'contractUid': contractUid,
      'cContractCode': cContractCode,
      'eppCode': eppCode,
      'builderCode': builderCode,
      'slump': slump,
      'stgId': stgId,
      'attribute': attribute,
      'placing': placing,
      'placeStyle': placeStyle,
      'address': address,
      'technicalRequirements': technicalRequirements,
      'preCarNum': preCarNum,
      'linkMan': linkMan,
      'linkTel': linkTel,
      'stoneAsk': stoneAsk,
      'stoneDia': stoneDia,
      'cementVariety': cementVariety,
      'grade': grade,
      'preRemark': preRemark,
      'distance': distance,
      'compid': await getEnterpriseId(),
    };
  }

  Map<String, dynamic> sendMap = {};

  sendMap = removeNullFormData(postMap);

  return await post(taskModel['addTask'], sendMap);
}

/// 审核任务单或取消任务单的审核状态
/// @param taskId 任务单id
/// @param compid 企业id
/// @param verifyStatus 审核状态
Future<Map<String, dynamic>> auditTask(
    String taskId, String verifyStatus) async {
  Map<String, dynamic> postMap = {
    'taskId': taskId,
    'compid': await getEnterpriseId(),
    'verifyStatus': verifyStatus
  };
  Map<String, dynamic> sendMap = {};

  sendMap = removeNullFormData(postMap);

  return await post(taskModel['review'], sendMap);
}

///  获取工程名称下拉
///
///  @param eppName  工程名称模糊查询
///  @param page     页码
///  @param pageSize 每页数量
///  @return 带分页工程下拉列表
Future<Map<String, dynamic>> getEppDropDown(int page,
    {String eppName, int pageSize}) async {
  Map<String, dynamic> postMap = {
    'eppName': eppName,
    'compid': await getEnterpriseId(),
    'page': page,
    'pageSize': pageSize == null ? 10 : pageSize
  };

  Map<String, dynamic> sendMap = {};

  postMap.forEach((String key, Object value) {
    if (value != null && value != "null") {
      sendMap[key] = value;
    }
  });

  return await post(eppModel['getDropDown'], sendMap);
}

/*
 *  申请人列表
 * @param compid       企业
 * @param page         分页
 * @param pageSize     每页显示条数
 * @return        申请人列表
 * */
Future<Map<String, dynamic>> getBuyerList(int page,
    {String eppName, int pageSize}) async {
  Map<String, dynamic> postMap = {
    'compid': await getEnterpriseId(),
    'page': page,
    'pageSize': pageSize == null ? 10 : pageSize
  };

  Map<String, dynamic> sendMap = {};

  postMap.forEach((String key, Object value) {
    if (value != null && value != "null") {
      sendMap[key] = value;
    }
  });

  return await post(accessories['getBuyerList'], sendMap);
}

/// 部门列表
/// @param compid       企业
///@param page         分页
/// @param pageSize     每页显示条数
///@return        部门列表

Future<Map<String, dynamic>> getDepartmentList(int page,
    {String eppName, int pageSize}) async {
  Map<String, dynamic> postMap = {
    'compid': await getEnterpriseId(),
    'page': page,
    'pageSize': pageSize == null ? 10 : pageSize
  };

  Map<String, dynamic> sendMap = {};

  postMap.forEach((String key, Object value) {
    if (value != null && value != "null") {
      sendMap[key] = value;
    }
  });

  return await post(accessories['getDepartmentList'], sendMap);
}

///申请单状态
///@param page         分页
///@param pageSize     每页显示条数

Future<Map<String, dynamic>> getRequestStatusList(int page,
    {String eppName, int pageSize}) async {
  Map<String, dynamic> postMap = {
    'compid': await getEnterpriseId(),
    'page': page,
    'pageSize': pageSize == null ? 10 : pageSize
  };

  Map<String, dynamic> sendMap = {};

  postMap.forEach((String key, Object value) {
    if (value != null && value != "null") {
      sendMap[key] = value;
    }
  });

  return await post(accessories['getRequestStatusList'], sendMap);
}

///助记码
///@param page         分页
///@param pageSize     每页显示条数
Future<Map<String, dynamic>> getMnemonicCodeList(int page,
    {String eppName, int pageSize}) async {
  Map<String, dynamic> postMap = {
    'compid': await getEnterpriseId(),
    'page': page,
    'pageSize': pageSize == null ? 10 : pageSize
  };

  Map<String, dynamic> sendMap = {};

  postMap.forEach((String key, Object value) {
    if (value != null && value != "null") {
      sendMap[key] = value;
    }
  });

  return await post(accessories['getMnemonicCodeList'], sendMap);
}

/// 获取施工单位下拉
///
/// @param builderName 施工单位名称
/// @param compid      企业id
/// @param page        页码
/// @param pageSize    每页数量
/// @return 施工单位下拉对象
Future<Map<String, dynamic>> getBuilderDropDown(int page,
    {int pageSize, String builderName}) async {
  Map<String, dynamic> postMap = {
    'builderName': builderName,
    'compid': await getEnterpriseId(),
    'page': page,
    'pageSize': pageSize == null ? 10 : pageSize
  };

  Map<String, dynamic> sendMap = {};

  postMap.forEach((String key, Object value) {
    if (value != null && value != "null") {
      sendMap[key] = value;
    }
  });
  return await post(builderModel['getDropDown'], sendMap);
}

/// 获取浇灌部位下拉
///
/// @param placing 施工单位名称
/// @param compid      企业id
/// @param page        页码
/// @param pageSize    每页数量
/// @return 浇灌部位下拉对象
Future<Map<String, dynamic>> getPlacingDropDown(int page,
    {int pageSize, String placing}) async {
  Map<String, dynamic> postMap = {
    'placing': placing,
    'compid': await getEnterpriseId(),
    'page': page,
    'pageSize': pageSize == null ? 10 : pageSize
  };

  Map<String, dynamic> sendMap = {};

  postMap.forEach((String key, Object value) {
    if (value != null && value != "null") {
      sendMap[key] = value;
    }
  });
  return await post(placingModel['getDropDown'], sendMap);
}

/// 获取销售员下拉
///
/// @param salesName 销售员名称
/// @param compid    企业id
/// @param page      分页
/// @param pageSize  每页数量
/// @return 销售员下拉对象
Future<Map<String, dynamic>> getSalesDropDown(int page,
    {int pageSize, String salesName}) async {
  Map<String, dynamic> postMap = {
    'salesName': salesName,
    'compid': await getEnterpriseId(),
    'page': page,
    'pageSize': pageSize == null ? 10 : pageSize
  };

  Map<String, dynamic> sendMap = {};

  postMap.forEach((String key, Object value) {
    if (value != null && value != "null") {
      sendMap[key] = value;
    }
  });
  return await post(salesmanModel['getDropDown'], sendMap);
}

/// 获取任务单详情
/// @param taskId  任务单id
/// @param compid 企业id
/// @return 任务单数据
Future<Map<String, dynamic>> getTaskDetail(String taskId) async {
  Map<String, dynamic> postMap = {
    'taskId': taskId,
    'compid': await getEnterpriseId(),
  };
  Map<String, dynamic> sendMap = {};
  postMap.forEach((String key, Object value) {
    if (value != null && value != "null") {
      sendMap[key] = value;
    }
  });
  return await post(taskModel['getTaskDetail'], sendMap);
}

Future<Map<String, dynamic>> getProductDatail(int stirid) async {
  Map<String, dynamic> postMap = {
    'compid': await getEnterpriseId(),
    'stirid': stirid,
  };
  Map<String, dynamic> sendMap = {};
  postMap.forEach((String key, Object value) {
    if (value != null && value != "null") {
      sendMap[key] = value;
    }
  });
  return await post(consume['getProductDatail'], sendMap);
}

/// 获取砼标号详情
/// @param taskId  任务单id
/// @param compid 企业id
/// @param  grade 砼标号等级
/// @return 任务单数据
Future<Map<String, dynamic>> getConcretDetail(String stgId,String grade) async {
  Map<String, dynamic> postMap = {
    'stgId': stgId,
    'grade': grade,
    'compid': await getEnterpriseId(),
  };
  Map<String, dynamic> sendMap = {};
  postMap.forEach((String key, Object value) {
    if (value != null && value != "null") {
      sendMap[key] = value;
    }
  });
  return await post(taskModel['getStgIdManage'], sendMap);
}
/// 编辑砼标号详情
/// @param taskId  任务单id
/// @param grade  砼标号等级
/// @param pumpPrice  泵送价格
/// @param notPumpPrice  非泵送价格
/// @param towerCranePrice  塔吊价格
/// @param compid 企业id
/// @return 任务单数据
Future<Map<String, dynamic>> editConcreteLabeling(String stgId,String grade,
    String pumpPrice, String notPumpPrice, String towerCranePrice) async {
  Map<String, dynamic> postMap = {
    'stgId': stgId,
    'grade': grade,
    'pumpPrice': pumpPrice,
    'notPumpPrice': notPumpPrice,
    'towerCranePrice': towerCranePrice,
    'compid': await getEnterpriseId(),
  };
  Map<String, dynamic> sendMap = {};
  postMap.forEach((String key, Object value) {
    if (value != null && value != "null") {
      sendMap[key] = value;
    }
  });
  return await post(taskModel['updateStgIdManage'], sendMap);
}


/// 获取配件详情
/// @param   任务单id
/// @param compid 企业id
/// @return 任务单数据
Future<Map<String, dynamic>> getRequestNumberDetail(
    String requestNumber) async {
  Map<String, dynamic> postMap = {
    'requestNumber': requestNumber,
    'compid': await getEnterpriseId(),
  };
  Map<String, dynamic> sendMap = {};
  postMap.forEach((String key, Object value) {
    if (value != null && value != "null") {
      sendMap[key] = value;
    }
  });
  return await post(accessories['getRequestNumberDetail'], sendMap);
}

/// 获取合同详情
///
/// @param contractUid 合同uid
/// @param compid      企业id
/// @return 合同详情
Future<Map<String, dynamic>> getContractDetail(
    String contractUid, String contractDetailCode) async {
  Map<String, dynamic> postMap = {
    'contractUid': contractUid,
    'contractDetailCode': contractDetailCode,
    'compid': await getEnterpriseId(),
  };

  Map<String, dynamic> sendMap = {};

  postMap.forEach((String key, Object value) {
    if (value != null && value != "null") {
      sendMap[key] = value;
    }
  });
  return await post(contractModel['getContractDetail'], sendMap);
}

/// 审核/取消审核 合同
///
/// @param contractUid  合同代号
/// @param compid       企业id
/// @param opId         操作员代号
/// @param verifyStatus 审核状态
/// @return 结果
Future<Map<String, dynamic>> verifyContract(
    String contractUid, int verifyStatus) async {
  Map<String, dynamic> postMap = {
    'contractUid': contractUid,
    'opId': (await getUid()).toString(),
    'verifyStatus': verifyStatus,
    'compid': await getEnterpriseId(),
  };

  Map<String, dynamic> sendMap = {};

  postMap.forEach((String key, Object value) {
    if (value != null && value != "null") {
      sendMap[key] = value;
    }
  });
  return await post(contractModel['verifyContract'], sendMap);
}

/// 获取合同砼价格列表
///
/// @param contractUid 合同uid
/// @param contractDetailCode 子合同代号
/// @return 砼价格列表
Future<List<dynamic>> getContractGradePrice(
  String contractUid,
  String contractDetailCode,
) async {
  Map<String, dynamic> postMap = {
    'contractUid': contractUid,
    'contractDetailCode': contractDetailCode,
    'compid': await getEnterpriseId(),
  };

  Map<String, dynamic> sendMap = {};

  postMap.forEach((String key, Object value) {
    if (value != null && value != "null") {
      sendMap[key] = value;
    }
  });
  return await post(contractModel['getContractGradePrice'], sendMap);
}

/// 获取合同砼价格列表
///
/// @param contractUid 合同uid
/// @param contractDetailCode 子合同代号
/// @return 砼价格列表
Future<List<dynamic>> getContractPriceMarkup(
  String contractUid,
  String contractDetailCode,
) async {
  Map<String, dynamic> postMap = {
    'contractUid': contractUid,
    'contractDetailCode': contractDetailCode,
    'compid': await getEnterpriseId(),
  };

  Map<String, dynamic> sendMap = {};

  postMap.forEach((String key, Object value) {
    if (value != null && value != "null") {
      sendMap[key] = value;
    }
  });
  return await post(contractModel['getContractPriceMarkup'], sendMap);
}

/// 获取合同泵车价格
///
/// @param contractUid 合同uid
/// @param contractDetailCode 子合同代号
/// @return 砼价格列表
Future<List<dynamic>> getContractPumpPrice(
  String contractUid,
  String contractDetailCode,
) async {
  Map<String, dynamic> postMap = {
    'contractUid': contractUid,
    'contractDetailCode': contractDetailCode,
    'compid': await getEnterpriseId(),
  };

  Map<String, dynamic> sendMap = {};

  postMap.forEach((String key, Object value) {
    if (value != null && value != "null") {
      sendMap[key] = value;
    }
  });
  return await post(contractModel['getContractPumpPrice'], sendMap);
}

/// 获取合同运距
///
/// @param contractUid 合同uid
/// @param contractDetailCode 子合同代号
/// @return 砼价格列表
Future<List<dynamic>> getContractDistanceSet(
  String contractUid,
  String contractDetailCode,
) async {
  Map<String, dynamic> postMap = {
    'contractUid': contractUid,
    'contractDetailCode': contractDetailCode,
    'compid': await getEnterpriseId(),
  };

  Map<String, dynamic> sendMap = {};

  postMap.forEach((String key, Object value) {
    if (value != null && value != "null") {
      sendMap[key] = value;
    }
  });
  return await post(contractModel['getContractDistanceSet'], sendMap);
}

/// 获取合同类别
///
/// @return 合同类别下拉
Future<List<dynamic>> getContractTypeDropDown() async {
  Map<String, dynamic> postMap = {
    'compid': await getEnterpriseId(),
  };

  Map<String, dynamic> sendMap = {};

  postMap.forEach((String key, Object value) {
    if (value != null && value != "null") {
      sendMap[key] = value;
    }
  });
  return await post(contractModel['getContractTypeDropDown'], sendMap);
}

/// 合同价格执行方式
///
/// @return 合同价格执行方式下拉
Future<List<dynamic>> getPriceTypeDropDown() async {
  Map<String, dynamic> postMap = {
    'compid': await getEnterpriseId(),
  };

  Map<String, dynamic> sendMap = {};
  postMap.forEach((String key, Object value) {
    if (value != null && value != "null") {
      sendMap[key] = value;
    }
  });
  return await post(contractModel['getPriceTypeDropDown'], sendMap);
}

/// 公共信息下拉
/// @param classId 类别代号
/// @return 公共信息下拉
Future<List<dynamic>> getDropDown(int classId) async {
  Map<String, dynamic> sendMap = {
    "classId": classId,
    "compid": await getEnterpriseId(),
  };
  return await post(publicModel['getDropDown'], sendMap);
}

Future<Map<String, dynamic>> addContract(
  String contractId,
  String salesman,
  int signDate,
  int effectDate, // 到期日期
  int contractType,
  int priceStyle,
  String eppCode,
  String builderCode,
  double contractNum,
  double preNum,
  double preMoney,
  String remarks,
) async {
  Map<String, dynamic> postMap = {
    'contractId': contractId,
    'salesman': salesman,
    'signDate': signDate,
    'effectDate': effectDate,
    'contractType': contractType,
    'priceStyle': priceStyle,
    'eppCode': eppCode,
    'builderCode': builderCode,
    'contractNum': contractNum,
    'preNum': preNum,
    'preMoney': preMoney,
    'remarks': remarks,
    'compid': await getEnterpriseId(),
  };

  Map<String, dynamic> sendMap = {};

  postMap.forEach((String key, Object value) {
    if (value != null && value != "null") {
      sendMap[key] = value;
    }
  });
  return await post(contractModel['addContract'], sendMap);
}

/// 获取砼标号下拉
/// @return 砼标号下拉
Future<List<dynamic>> getStgIdDropDown() async {
  Map<String, dynamic> sendMap = {
    "compid": await getEnterpriseId(),
  };
  return await post(contractModel['getStgIdDropDown'], sendMap);
}

/// 编辑砼价格
Future<Map<String, dynamic>> saveContractGradePrice(
  String contractUid,
  String contractDetailCode,
  String gradePrice,
) async {
  Map<String, dynamic> postMap = {
    'contractUid': contractUid,
    'contractDetailCode': contractDetailCode,
    'gradePrice': gradePrice,
    'compid': await getEnterpriseId(),
  };

  Map<String, dynamic> sendMap = {};

  postMap.forEach((String key, Object value) {
    if (value != null && value != "null") {
      sendMap[key] = value;
    }
  });
  return await post(contractModel['saveContractGradePrice'], sendMap);
}

/// 编辑特殊材料
Future<Map<String, dynamic>> saveContractPriceMarkup(
  String contractUid,
  String contractDetailCode,
  String selectedStgs,
) async {
  Map<String, dynamic> postMap = {
    'contractUid': contractUid,
    'contractDetailCode': contractDetailCode,
    'priceMarkup': selectedStgs,
    'compid': await getEnterpriseId(),
  };

  Map<String, dynamic> sendMap = {};

  postMap.forEach((String key, Object value) {
    if (value != null && value != "null") {
      sendMap[key] = value;
    }
  });
  return await post(contractModel['saveContractPriceMarkup'], sendMap);
}

/// 获取特殊材料下拉
/// @return 砼标号下拉
Future<List<dynamic>> getPriceMarkupDropDown() async {
  Map<String, dynamic> sendMap = {
    "compid": await getEnterpriseId(),
  };
  return await post(contractModel['getPriceMarkupDropDown'], sendMap);
}

/// 获取线号
/// @param compid
/// return 获取楼号
/// getStirIds
Future<List<dynamic>> getStirIds() async {
  Map<String, dynamic> sendMap = {
    "compid": await getEnterpriseId(),
  };
  return await post(stock['getStirIds'], sendMap);
}

/// 获取实时库存的对应线号的信息
/// @param compid
/// @param stirId
Future<List<dynamic>> getStock(String stirId) async {
  Map<String, dynamic> postMap = {
    'stirId': stirId,
    'compid': await getEnterpriseId(),
    "token": await getToken(),
  };

  Map<String, dynamic> sendMap = {};

  postMap.forEach((String key, Object value) {
    if (value != null && value != "null") {
      sendMap[key] = value;
    }
  });

  return await post(produce["getRealStock"], sendMap);
}

/// 获取今日预计产量
/// @param compid
/// @param stirId
Future<List<dynamic>> getProductionToday() async {
  Map<String, dynamic> postMap = {
    'compid': await getEnterpriseId(),
    'beginTime': DateTime.parse(
        DateTime.now().toLocal().toString().substring(0, 10) + " 00:00:00"),
    'endTime': DateTime.parse(
        DateTime.now().toLocal().toString().substring(0, 10) + " 23:59:59"),
  };

  Map<String, dynamic> sendMap = {};

  postMap.forEach((String key, Object value) {
    if (value != null && value != "null") {
      sendMap[key] = value;
    }
  });
  return await postResultList(taskModel['phoneStatistics'], sendMap);
}

/// 获取今日任务
/// @param compid
/// @param stirId
Future<List<dynamic>> getMissionToday() async {
  Map<String, dynamic> postMap = {
    'type': 1,
    'compid': await getEnterpriseId(),
    'beginTime': DateTime.parse(
        DateTime.now().toLocal().toString().substring(0, 10) + " 00:00:00"),
    'endTime': DateTime.parse(
        DateTime.now().toLocal().toString().substring(0, 10) + " 23:59:59"),
    'token': await getToken()
  };

  Map<String, dynamic> sendMap = {};

  postMap.forEach((String key, Object value) {
    if (value != null && value != "null") {
      sendMap[key] = value;
    }
  });
  return await postResultList(total['phoneStatistics'], sendMap);
}

// 搅拌车工作量统计
/// 搅拌车砼运输明细
/// @param compid
/// @param eppCode
/// @param placing
/// @param taskId
/// @param vehicleId
/// @param beginTime
/// @param page
/// @param pageSize
Future<Map<String, dynamic>> getVehicleWorkloadDetail(int page,
    {String personalName,
    String eppCode,
    String placing,
    String vehicleId,
    String taskId,
    String beginTime,
    String endTime,
    int pageSize}) async {
  Map<String, dynamic> postMap = {
    'compid': await getEnterpriseId(),
    'personalName': personalName,
    'eppCode': eppCode,
    'placing': placing,
    'vehicleId': vehicleId,
    'taskId': taskId,
    'beginTime': beginTime,
    'endTime': endTime,
    'page': page,
    'pageSize': pageSize == null ? 10 : pageSize
  };
  Map<String, dynamic> sendMap = {};
  sendMap = removeNullFormData(postMap);
  return await post(vehicle['getVehicleWorkloadDetail'], sendMap);
}

/// 搅拌车砼运输汇总
/// @param compid
/// @param eppCode
/// @param placing
/// @param taskId
/// @param vehicleId
/// @param beginTime
/// @param page
/// @param pageSize

Future<Map<String, dynamic>> getVehicleWorkloadSummary(int page,
    {String personalName,
    String eppCode,
    String placing,
    String vehicleId,
    String taskId,
    String beginTime,
    String endTime,
    int pageSize}) async {
  Map<String, dynamic> postMap = {
    'compid': await getEnterpriseId(),
    'personalName': personalName,
    'eppCode': eppCode,
    'placing': placing,
    'vehicleId': vehicleId,
    'taskId': taskId,
    'beginTime': beginTime,
    'endTime': endTime,
    'page': page,
    'pageSize': pageSize == null ? 20 : pageSize
  };
  Map<String, dynamic> sendMap = {};
  sendMap = removeNullFormData(postMap);
  return await post(vehicle['getVehicleWorkloadSummary'], sendMap);
}

/// 问题反馈上传图片
/// formData 图片
Future<String> feedbackHeader(FormData formData) async {
  Map<String, dynamic> headers = {
    "pid": 2,
    "enterprise": await getEnterpriseId(),
    "token": await getToken(),
  };
  return await postForm(feedbackModel['feedbackHeader'], formData,
      headers: headers, resultStr: true);
}

///上传收款码
Future<String> uploadPicture(FormData formData) async {
  Map<String, dynamic> headers = {
    "pid": 2,
    "enterprise": await getEnterpriseId(),
    "token": await getToken(),
  };
  return await postForm(enterprise['uploadPicture'], formData,
      headers: headers, resultStr: true);
}

/// 添加问题反馈
Future<Map<String, dynamic>> addFeedback(
    String fbIssue, String fbPictures, String linkTel) async {
  Map<String, dynamic> headers = {
    "pid": 2,
    "enterprise": await getEnterpriseId(),
    "token": await getToken(),
  };

  Map<String, dynamic> postMap = {
    'fbIssue': fbIssue,
    'fbPictures': fbPictures,
    'linkTel': linkTel,
    'uid': await getUid(),
    'pid': 2,
  };

  Map<String, dynamic> feedback = {};

  postMap.forEach((String key, Object value) {
    if (value != null && value != "null") {
      feedback[key] = value;
    }
  });

  return await post(feedbackModel['addFeedback'], feedback, headers: headers);
}

Future<Map<String, dynamic>> saveCollectionCode(
    int eid, String fbPictures, int type) async {
  Map<String, dynamic> headers = {
    "pid": 2,
    "enterprise": await getEnterpriseId(),
    "token": await getToken(),
  };

  Map<String, dynamic> postMap = {
    'eid': eid,
    'imageFile': fbPictures,
    'type': type
  };

  Map<String, dynamic> feedback = {};

  postMap.forEach((String key, Object value) {
    if (value != null && value != "null") {
      feedback[key] = value;
    }
  });

  return await post(enterprise['saveCollectionCode'], feedback,
      headers: headers);
}

/// 搅拌车拖水拖泵明细
/// @param compid
/// @param eppCode
/// @param placing
/// @param taskId
/// @param vehicleId
/// @param beginTime
/// @param page
/// @param pageSize
Future<Map<String, dynamic>> getVehicleWorkTowingPumpDetail(int page,
    {String personalName,
    String eppCode,
    String placing,
    String taskId,
    String vehicleId,
    String beginTime,
    String endTime,
    int pageSize}) async {
  Map<String, dynamic> postMap = {
    'compid': await getEnterpriseId(),
    'personalName': personalName,
    'eppCode': eppCode,
    'placing': placing,
    'taskId': taskId,
    'vehicleId': vehicleId,
    'beginTime': beginTime,
    'endTime': endTime,
    'page': page,
    'pageSize': pageSize == null ? 10 : pageSize
  };
  Map<String, dynamic> sendMap = {};
  sendMap = removeNullFormData(postMap);
  return await post(vehicle['getVehicleWorkTowingPumpDetail'], sendMap);
}

/// 搅拌车拖水拖泵汇总
/// @param compid
/// @param eppCode
/// @param placing
/// @param taskId
/// @param vehicleId
/// @param beginTime
/// @param page
/// @param pageSize
Future<Map<String, dynamic>> getVehicleWorkTowingPumpCount(int page,
    {String personalName,
    String eppCode,
    String placing,
    String taskId,
    String vehicleId,
    String beginTime,
    String endTime,
    int pageSize}) async {
  Map<String, dynamic> postMap = {
    'compid': await getEnterpriseId(),
    'personalName': personalName,
    'eppCode': eppCode,
    'placing': placing,
    'taskId': taskId,
    'vehicleId': vehicleId,
    'beginTime': beginTime,
    'endTime': endTime,
    'page': page,
    'pageSize': pageSize == null ? 20 : pageSize
  };
  Map<String, dynamic> sendMap = {};
  sendMap = removeNullFormData(postMap);
  return await post(vehicle['getVehicleWorkTowingPumpCount'], sendMap);
}

/// 司机砼运输明细

///@param compid       企业
///@param eppCode      工程名称
///@param placing      浇筑部位
///@param taskId       任务单号
///@param vehicleID    车号
///@param personalName 司机
///@param beginTime    开始时间
///@param endTime      结束时间
///@param page         分页
///@param pageSize

Future<Map<String, dynamic>> getDriverTransportationDetails(
  int page, {
  String eppCode,
  String placing,
  String taskId,
  String vehicleId,
  String personalName,
  String beginTime,
  String endTime,
  int pageSize,
}) async {
  Map<String, dynamic> postMap = {
    'page': page,
    'compid': await getEnterpriseId(),
    'eppCode': eppCode,
    'placing': placing,
    'taskId': taskId,
    'vehicleId': vehicleId,
    'personalName': personalName,
    'beginTime': beginTime,
    'endTime': endTime,
    'pageSize': pageSize == null ? 10 : pageSize
  };

  Map<String, dynamic> sendMap = {};

  sendMap = removeNullFormData(postMap);

  return await post(vehicle['getDriverTransportationDetails'], sendMap);
}

/// 司机砼运输汇总

///@param compid       企业
///@param eppCode      工程名称
///@param placing      浇筑部位
///@param taskId       任务单号
///@param vehicleID    车号
///@param personalName 司机
///@param beginTime    开始时间
///@param endTime      结束时间
///@param page         分页
///@param pageSize

Future<Map<String, dynamic>> getDriverTransportationCount(
  int page, {
  String eppCode,
  String placing,
  String taskId,
  String vehicleId,
  String personalName,
  String beginTime,
  String endTime,
  int pageSize,
}) async {
  Map<String, dynamic> postMap = {
    'page': page,
    'compid': await getEnterpriseId(),
    'eppCode': eppCode,
    'placing': placing,
    'taskId': taskId,
    'vehicleId': vehicleId,
    'personalName': personalName,
    'beginTime': beginTime,
    'endTime': endTime,
    'pageSize': pageSize == null ? 20 : pageSize
  };

  Map<String, dynamic> sendMap = {};

  sendMap = removeNullFormData(postMap);

  return await post(vehicle['getDriverTransportationCount'], sendMap);
}

/// 司机砼运输砼产量合计

///@param compid       企业
///@param eppCode      工程名称
///@param placing      浇筑部位
///@param taskId       任务单号
///@param vehicleID    车号
///@param personalName 司机
///@param beginTime    开始时间
///@param endTime      结束时间
///@param page         分页
///@param pageSize

Future<Map<String, dynamic>> getDriverTransportationSum({
  String eppCode,
  String placing,
  String taskId,
  String vehicleId,
  String personalName,
  String beginTime,
  String endTime,
  int pageSize,
}) async {
  Map<String, dynamic> postMap = {
    'compid': await getEnterpriseId(),
    'eppCode': eppCode,
    'placing': placing,
    'taskId': taskId,
    'vehicleID': vehicleId,
    'personalName': personalName,
    'beginTime': beginTime,
    'endTime': endTime,
    'pageSize': pageSize == null ? 20 : pageSize
  };

  Map<String, dynamic> sendMap = {};

  sendMap = removeNullFormData(postMap);
  return await post(vehicle["getDriverTransportationSum"], sendMap);
}

/// 司机砼运输车数合计

///@param compid       企业
///@param eppCode      工程名称
///@param placing      浇筑部位
///@param taskId       任务单号
///@param vehicleID    车号
///@param personalName 司机
///@param beginTime    开始时间
///@param endTime      结束时间
///@param page         分页
///@param pageSize

Future<Map<String, dynamic>> getDriverTransportationCarNumList({
  String eppCode,
  String placing,
  String taskId,
  String vehicleId,
  String personalName,
  String beginTime,
  String endTime,
  int pageSize,
}) async {
  Map<String, dynamic> postMap = {
    'compid': await getEnterpriseId(),
    'eppCode': eppCode,
    'placing': placing,
    'taskId': taskId,
    'vehicleId': vehicleId,
    'personalName': personalName,
    'beginTime': beginTime,
    'endTime': endTime,
    'pageSize': pageSize == null ? 20 : pageSize
  };

  Map<String, dynamic> sendMap = {};

  sendMap = removeNullFormData(postMap);
  return await post(vehicle["getDriverTransportationCarNumList"], sendMap);
}

/// 司机拖水拖泵汇总
///@param compid       企业
///@param eppCode      工程名称
///@param placing      浇筑部位
///@param taskId       任务单号
///@param vehicleID    车号
///@param personalName 司机
///@param beginTime    开始时间
///@param endTime      结束时间
///@param page         分页
///@param pageSize
Future<Map<String, dynamic>> getDriverDragPumpCount(
  int page, {
  String eppCode,
  String placing,
  String taskId,
  String vehicleId,
  String personalName,
  String beginTime,
  String endTime,
  int pageSize,
}) async {
  Map<String, dynamic> postMap = {
    'page': page,
    'compid': await getEnterpriseId(),
    'eppCode': eppCode,
    'placing': placing,
    'taskId': taskId,
    'vehicleId': vehicleId,
    'personalName': personalName,
    'beginTime': beginTime,
    'endTime': endTime,
    'pageSize': pageSize == null ? 20 : pageSize
  };
  Map<String, dynamic> sendMap = {};
  sendMap = removeNullFormData(postMap);

  return await post(vehicle['getDriverDragPumpCount'], sendMap);
}

/// 泵车汇总统计
///@param compid       企业
///@param eppCode     工程代号
///@param personalName 司机
///@param stirId       楼号
///@param vehicleId   车号
///@param beginTime    开始时间
///@param endTime      结束时间
///@param page         分页
///@param pageSize    每页显示条数

Future<Map<String, dynamic>> getPumpTruckCount(
  int page, {
  String eppCode,
  String personalName,
  String stirId,
  String vehicleId,
  String beginTime,
  String endTime,
  int pageSize,
}) async {
  Map<String, dynamic> postMap = {
    'page': page,
    'compid': await getEnterpriseId(),
    'eppCode': eppCode,
    'personalName': personalName,
    'stirId': stirId,
    'vehicleId': vehicleId,
    'beginTime': beginTime,
    'endTime': endTime,
    'pageSize': pageSize == null ? 20 : pageSize
  };
  Map<String, dynamic> sendMap = {};
  sendMap = removeNullFormData(postMap);

  return await post(vehicle['getPumpTruckCount'], sendMap);
}

/// 泵工汇总统计
///@param compid       企业
/// @param eppCode      工程名称
/// @param personalName 司机
/// @param stirId       楼号
/// @param vehicleId   车号
/// @param beginTime    开始时间
/// @param endTime      结束时间
/// @param page         分页
/// @param pageSize    每页显示条数
Future<Map<String, dynamic>> getPumpOperatorTruckCount(
  int page, {
  String eppCode,
  String personalName,
  String stirId,
  String vehicleId,
  String beginTime,
  String endTime,
  int pageSize,
}) async {
  Map<String, dynamic> postMap = {
    'page': page,
    'compid': await getEnterpriseId(),
    'eppCode': eppCode,
    'personalName': personalName,
    'stirId': stirId,
    'vehicleId': vehicleId,
    'beginTime': beginTime,
    'endTime': endTime,
    'pageSize': pageSize == null ? 20 : pageSize
  };
  Map<String, dynamic> sendMap = {};
  sendMap = removeNullFormData(postMap);
  return await post(vehicle['getPumpOperatorTruckCount'], sendMap);
}

/// 泵工汇总统计合计
///@param compid       企业
/// @param eppCode      工程名称
/// @param personalName 司机
/// @param stirId       楼号
/// @param vehicleId   车号
/// @param beginTime    开始时间
/// @param endTime      结束时间
/// @param page         分页
/// @param pageSize    每页显示条数
Future<Map<String, dynamic>> getPumpTruckSum({
  String eppCode,
  String personalName,
  String stirId,
  String vehicleId,
  String beginTime,
  String endTime,
  int pageSize,
}) async {
  Map<String, dynamic> postMap = {
    'compid': await getEnterpriseId(),
    'eppCode': eppCode,
    'personalName': personalName,
    'stirId': stirId,
    'vehicleId': vehicleId,
    'beginTime': beginTime,
    'endTime': endTime,
    'pageSize': pageSize == null ? 20 : pageSize
  };
  Map<String, dynamic> sendMap = {};
  sendMap = removeNullFormData(postMap);
  return await post(vehicle['getPumpTruckSum'], sendMap);
}

/// 泵车明细
/// @param compid       企业
/// @param eppCode      工程名称
/// @param personalName 司机
/// @param stirId       楼号
/// @param vehicleId    车号
/// @param beginTime    开始时间
/// @param endTime      结束时间
/// @param page         分页
/// @param pageSize     每页显示条数

Future<Map<String, dynamic>> getPumpTruckDetails(
  int page, {
  String eppCode,
  String personalName,
  String stirId,
  String vehicleId,
  String beginTime,
  String endTime,
  int pageSize,
}) async {
  Map<String, dynamic> postMap = {
    'page': page,
    'compid': await getEnterpriseId(),
    'eppCode': eppCode,
    'personalName': personalName,
    'stirId': stirId,
    'vehicleId': vehicleId,
    'beginTime': beginTime,
    'endTime': endTime,
    'pageSize': pageSize == null ? 20 : pageSize
  };
  Map<String, dynamic> sendMap = {};
  sendMap = removeNullFormData(postMap);
  return await post(vehicle['getPumpTruckDetails'], sendMap);
}

/// 选择楼号
/// @param compid 企业
Future<List<dynamic>> getBuildingNumber() async {
  Map<String, dynamic> postMap = {
    'compid': await getEnterpriseId(),
  };
  Map<String, dynamic> sendMap = {};
  sendMap = removeNullFormData(postMap);
  return await post(stirInfoSet['getStirInfoSet'], sendMap);
}

/// 搅拌车过磅查询
/// compid
/// eppCode
/// empname
/// weightType
/// beginTime
/// endTime
/// page
/// pageSize
Future<Map<String, dynamic>> getWorkloadStatistics(
    {String eppCode,
    String empName,
    String weightType,
    String beginTime,
    String endTime,
    int page,
    int pageSize}) async {
  Map<String, dynamic> postMap = {
    'compid': await getEnterpriseId(),
    'eppCode': eppCode,
    'empNameb': empName,
    'weightType': weightType,
    'beginTime': beginTime,
    'endTime': endTime,
    'page': page,
    'pageSize': pageSize == null ? 10 : pageSize
  };
  Map<String, dynamic> sendMap = {};
  sendMap = removeNullFormData(postMap);
  return await post(vehicle['getWorkloadStatistics'], sendMap);
}

/// 选择过磅类型
Future<List<dynamic>> getweightType() async {
  Map<String, dynamic> postMap = {
    'classId': 53,
    'compid': await getEnterpriseId(),
  };
  Map<String, dynamic> sendMap = {};
  sendMap = removeNullFormData(postMap);
  return await post(weightType['getweightType'], sendMap);
}

/// 搅拌车砼运输汇总合计
/// @param compid
/// @param eppCode
/// @param placing
/// @param taskId
/// @param vehicleId
/// @param beginTime
/// @param page
/// @param pageSize

Future<Map<String, dynamic>> getVehicleWorkloadSummaryCount(int page,
    {String personalName,
    String eppCode,
    String placing,
    String taskId,
    String vehicleId,
    String beginTime,
    String endTime,
    int pageSize}) async {
  Map<String, dynamic> postMap = {
    'compid': await getEnterpriseId(),
    'personalName': personalName,
    'eppCode': eppCode,
    'placing': placing,
    'taskId': taskId,
    'vehicleId': vehicleId,
    'beginTime': beginTime,
    'endTime': endTime,
    'page': page,
    'pageSize': pageSize == null ? 20 : pageSize
  };
  Map<String, dynamic> sendMap = {};
  sendMap = removeNullFormData(postMap);

  return await post(vehicle['getVehicleWorkloadSummaryCount'], sendMap);
}

/// 工作方量统计
/// @param compid       企业
/// @param eppCode      工程代号
/// @param personalName 司机
/// @param stirId       楼号
/// @param vehicleId    车号
/// @param beginTime    开始时间
/// @param endTime      结束时间
/// @param page         分页
/// @param pageSize     每页显示条数

Future<Map<String, dynamic>> getPumpTruckWorkloadStatistics(
  int page, {
  String eppCode,
  String personalName,
  String stirId,
  String vehicleId,
  String beginTime,
  String endTime,
  int pageSize,
}) async {
  Map<String, dynamic> postMap = {
    'page': page,
    'compid': await getEnterpriseId(),
    'eppCode': eppCode,
    'personalName': personalName,
    'stirId': stirId,
    'vehicleId': vehicleId,
    'beginTime': beginTime,
    'endTime': endTime,
    'pageSize': pageSize == null ? 20 : pageSize
  };
  Map<String, dynamic> sendMap = {};
  sendMap = removeNullFormData(postMap);
  return await post(vehicle['getPumpTruckWorkloadStatistics'], sendMap);
}

Future<Map<String, dynamic>> stockInList(int page,
    {String beginTime,
    String endTime,
    String vehicleId,
    String supName,
    String matName,
    String pageSize,
    String saleType}) async {
  Map<String, dynamic> postMap = {
    'page': page,
    'compid': await getEnterpriseId(),
    'beginTime': beginTime,
    'endTime': endTime,
    'vehicleId': vehicleId,
    'supName': supName,
    'matName': matName,
    'page': page,
    'saleType': saleType,
    'pageSize': pageSize == null ? 10 : pageSize
  };

  /// 原材料过磅查询
  Map<String, dynamic> sendMap = {};

  sendMap = removeNullFormData(postMap);
  return await post(stockIn["getStockInDetails"], sendMap);
}

/// 原材料汇总统计
Future<Map<String, dynamic>> getMatStatistics(int page,
    {String vehicleId,
    String matSpecs,
    String supName,
    String beginTime,
    String endTime,
    int pageSize,
    String matName}) async {
  Map<String, dynamic> postMap = {
    'page': page,
    'supName': supName,
    'compid': await getEnterpriseId(),
    'beginTime': beginTime,
    'endTime': endTime,
    'pageSize': pageSize == null ? 18 : pageSize,
    'MatName': matName,
    'matSpecs': matSpecs
  };

  Map<String, dynamic> sendMap = {};

  postMap.forEach((String key, Object value) {
    if (value != null && value != "null") {
      sendMap[key] = value;
    }
  });
  return await post(stockIn['getMatStatistics'], sendMap);
}

/// 原材料明细汇总
Future<Map<String, dynamic>> getMatDetailsList(int page,
    {String vehicleId,
    String matSpecs,
    String supName,
    String beginTime,
    String endTime,
    int pageSize,
    String matName}) async {
  Map<String, dynamic> postMap = {
    'page': page,
    'supName': supName,
    'compid': await getEnterpriseId(),
    'beginTime': beginTime,
    'endTime': endTime,
    'pageSize': pageSize == null ? 18 : pageSize,
    'MatName': matName,
    'vehicleId': vehicleId,
    'matSpecs': matSpecs
  };

  Map<String, dynamic> sendMap = {};

  postMap.forEach((String key, Object value) {
    if (value != null && value != "null") {
      sendMap[key] = value;
    }
  });
  return await post(stockIn['getMatDetailsList'], sendMap);
}

/// 材料入库汇总
Future<Map<String, dynamic>> getMaterialCount(int page,
    {String vehicleId,
    String matSpecs,
    String supName,
    String beginTime,
    String endTime,
    int pageSize,
    String matName}) async {
  Map<String, dynamic> postMap = {
    'vehicleId': vehicleId,
    'page': page,
    'supName': supName,
    'compid': await getEnterpriseId(),
    'beginTime': beginTime,
    'endTime': endTime,
    'pageSize': pageSize == null ? 18 : pageSize,
    'MatName': matName,
    'matSpecs': matSpecs,
  };

  Map<String, dynamic> sendMap = {};

  postMap.forEach((String key, Object value) {
    if (value != null && value != "null") {
      sendMap[key] = value;
    }
  });
  return await post(stockIn['getMaterialCount'], sendMap);
}

/// 原材料明细汇总合计入库量
Future<Map<String, dynamic>> getStockInCollectClose(
    {String vehicleId,
    String matSpecs,
    String supName,
    String beginTime,
    String endTime,
    String matName}) async {
  Map<String, dynamic> postMap = {
    'supName': supName,
    'compid': await getEnterpriseId(),
    'beginTime': beginTime,
    'endTime': endTime,
    'matName': matName,
    'vehicleId': vehicleId,
    'matSpecs': matSpecs
  };

  Map<String, dynamic> sendMap = {};

  postMap.forEach((String key, Object value) {
    if (value != null && value != "null") {
      sendMap[key] = value;
    }
  });
  return await post(stockIn['getStockInCollectClose'], sendMap);
}

/// 原材料汇总统计合计购入量
Future<Map<String, dynamic>> getMatStatisticsClose(
    {String vehicleId,
    String matSpecs,
    String supName,
    String beginTime,
    String endTime,
    String matName}) async {
  Map<String, dynamic> postMap = {
    'supName': supName,
    'compid': await getEnterpriseId(),
    'beginTime': beginTime,
    'endTime': endTime,
    'matName': matName,
    'vehicleId': vehicleId,
    'matSpecs': matSpecs
  };

  Map<String, dynamic> sendMap = {};

  postMap.forEach((String key, Object value) {
    if (value != null && value != "null") {
      sendMap[key] = value;
    }
  });
  return await post(stockIn['getMatStatisticsClose'], sendMap);
}

/// 原材料过磅查询结算
Future<Map<String, dynamic>> getStockInSelectClose(
    {String vehicleId,
    String supName,
    String beginTime,
    String endTime,
    int pageSize,
    String matName,
    String saleType}) async {
  Map<String, dynamic> postMap = {
    'supName': supName,
    'compid': await getEnterpriseId(),
    'beginTime': beginTime,
    'endTime': endTime,
    'pageSize': pageSize == null ? 20 : pageSize,
    'vehicleId': vehicleId,
    'MatName': matName,
    'saleType': saleType
  };

  Map<String, dynamic> sendMap = {};

  postMap.forEach((String key, Object value) {
    if (value != null && value != "null") {
      sendMap[key] = value;
    }
  });
  return await post(stockIn['getStockInSelectClose'], sendMap);
}

///原材料过磅统计，材料名称
Future<Map<String, dynamic>> getWeightByMat({
  int page,
  int pageSize,
  String stoName,
  String empName,
  String supName,
  String vehicleId,
  String beginTime,
  String endTime,
}) async {
  Map<String, dynamic> postMap = {
    'compid': await getEnterpriseId(),
    'empName': empName,
    'stoName': stoName,
    'supName': supName,
    'vehicleId': vehicleId,
    'beginTime': beginTime,
    'endTime': endTime,
    'page': page,
    'pageSize': pageSize
  };
  Map<String, dynamic> sendMap = {};
  sendMap = removeNullFormData(postMap);
  return await post(matweigh['getWeightByMat'], sendMap);
}

///原材料过磅统计，车辆代号
Future<Map<String, dynamic>> getWeightByVechicId(int page,
    {String stoName,
    String empName,
    String supName,
    String vehicleId,
    int pageSize,
    String beginTime,
    String endTime}) async {
  Map<String, dynamic> postMap = {
    'compid': await getEnterpriseId(),
    'beginTime': beginTime,
    'endTime': endTime,
    'empName': empName,
    'stoName': stoName,
    'supName': supName,
    'vehicleId': vehicleId,
    'page': page,
    'pageSize': pageSize == null ? 20 : pageSize
  };
  Map<String, dynamic> sendMap = {};
  sendMap = removeNullFormData(postMap);
  return await post(matweigh['getWeightByVechicId'], sendMap);
}

///原材料过磅统计，供应商名
Future<Map<String, dynamic>> getWeightByStoName(int page,
    {String stoName,
    String empName,
    String supName,
    String vehicleId,
    int pageSize,
    String beginTime,
    String endTime}) async {
  Map<String, dynamic> postMap = {
    'compid': await getEnterpriseId(),
    'beginTime': beginTime,
    'endTime': endTime,
    'empName': empName,
    'stoName': stoName,
    'supName': supName,
    'vehicleId': vehicleId,
    'page': page,
    'pageSize': pageSize == null ? 10 : pageSize
  };
  Map<String, dynamic> sendMap = {};
  sendMap = removeNullFormData(postMap);
  return await post(matweigh['getWeightByStoName'], sendMap);
}

///原材料过磅统计，入库库位
Future<Map<String, dynamic>> getWeightBySupName(int page,
    {String stoName,
    String empName,
    String supName,
    String vehicleId,
    int pageSize,
    String beginTime,
    String endTime}) async {
  Map<String, dynamic> postMap = {
    'compid': await getEnterpriseId(),
    'beginTime': beginTime,
    'endTime': endTime,
    'empName': empName,
    'stoName': stoName,
    'supName': supName,
    'vehicleId': vehicleId,
    'page': page,
    'pageSize': pageSize == null ? 20 : pageSize
  };
  Map<String, dynamic> sendMap = {};
  sendMap = removeNullFormData(postMap);
  return await post(matweigh['getWeightBySupName'], sendMap);
}

///原材料过磅统计，过磅员
Future<Map<String, dynamic>> getWeightByEmpName(int page,
    {String stoName,
    String empName,
    String supName,
    String vehicleId,
    int pageSize,
    String beginTime,
    String endTime}) async {
  Map<String, dynamic> postMap = {
    'compid': await getEnterpriseId(),
    'beginTime': beginTime,
    'endTime': endTime,
    'empName': empName,
    'stoName': stoName,
    'supName': supName,
    'vehicleId': vehicleId,
    'page': page,
    'pageSize': pageSize == null ? 20 : pageSize
  };
  Map<String, dynamic> sendMap = {};
  sendMap = removeNullFormData(postMap);
  return await post(matweigh['getWeightByEmpName'], sendMap);
}

///原材料过磅统计，综合信息
Future<Map<String, dynamic>> getSynthesizeByMat(int page,
    {String stoName,
    String empName,
    String supName,
    String vehicleId,
    int pageSize,
    String beginTime,
    String endTime}) async {
  Map<String, dynamic> postMap = {
    'compid': await getEnterpriseId(),
    'empName': empName,
    'stoName': stoName,
    'supName': supName,
    'vehicleId': vehicleId,
    'beginTime': beginTime,
    'endTime': endTime,
    'page': page,
    'pageSize': pageSize == null ? 10 : pageSize
  };
  Map<String, dynamic> sendMap = {};
  sendMap = removeNullFormData(postMap);
  return await post(matweigh['getSynthesizeByMat'], sendMap);
}

///原材料过磅综合统计合计入库量
Future<Map<String, dynamic>> getWeightClose(
    {String stoName,
    String supName,
    String vehicleId,
    String beginTime,
    String endTime}) async {
  Map<String, dynamic> postMap = {
    'compid': await getEnterpriseId(),
    'beginTime': beginTime,
    'endTime': endTime,
    'stoName': stoName,
    'supName': supName,
    'vehicleId': vehicleId,
  };
  Map<String, dynamic> sendMap = {};
  sendMap = removeNullFormData(postMap);
  return await post(matweigh['getWeightClose'], sendMap);
}

///砼产量统计
Future<Map<String, dynamic>> getConcreteCount(int page,
    {String eppCode,
    String placing,
    String taskId,
    String beginTime,
    String endTime,
    int timeStatus,
    int pageSize}) async {
  Map<String, dynamic> postMap = {
    'compid': await getEnterpriseId(),
    'beginTime': beginTime,
    'endTime': endTime,
    'eppCode': eppCode,
    'placing': placing,
    'taskId': taskId,
    'timeStatus': timeStatus,
    'page': page,
    'pageSize': pageSize == null ? 10 : pageSize
  };
  Map<String, dynamic> sendMap = {};
  sendMap = removeNullFormData(postMap);
  return await post(concrete['getConcreteCount'], sendMap);
}

///砼产量统计合计汇总
Future<Map<String, dynamic>> getConcreteSum(
    {String eppCode,
    String placing,
    String taskId,
    String stgId,
    String beginTime,
    String endTime,
    int timeStatus}) async {
  Map<String, dynamic> postMap = {
    'compid': await getEnterpriseId(),
    'beginTime': beginTime,
    'endTime': endTime,
    'eppCode': eppCode,
    'placing': placing,
    'taskId': taskId,
    'stgId': stgId,
    'timeStatus': timeStatus,
  };
  Map<String, dynamic> sendMap = {};
  sendMap = removeNullFormData(postMap);

  return await post(concrete['getConcreteSum'], sendMap);
}

/// 任务单消耗汇总
Future<Map<String, dynamic>> getTaskConsumeList(
    {int page,
    int pageSize,
    String vehicleId,
    String taskId,
    String stirId,
    String stgId,
    String beginTime,
    String endTime}) async {
  Map<String, dynamic> postMap = {
    'page': page,
    'pageSize': pageSize == null ? 10 : pageSize,
    'compid': await getEnterpriseId(),
    'beginTime': beginTime,
    'endTime': endTime,
    'vehicleId': vehicleId,
    'stirId': stirId,
    'taskId': taskId,
    'stgId': stgId,
  };
  Map<String, dynamic> sendMap = {};
  sendMap = removeNullFormData(postMap);

  return await post(consume['getTaskConsumeList'], sendMap);
}

/// 标号消耗汇总
Future<Map<String, dynamic>> getConsumptionTotal(
    {int page,
    int pageSize,
    String vehicleId,
    String taskId,
    String stirId,
    String stgId,
    String beginTime,
    String endTime}) async {
  Map<String, dynamic> postMap = {
    'page': page,
    'pageSize': pageSize == null ? 10 : pageSize,
    'compid': await getEnterpriseId(),
    'beginTime': beginTime,
    'endTime': endTime,
    'vehicleId': vehicleId,
    'stirId': stirId,
    'taskId': taskId,
    'stgId': stgId,
  };
  Map<String, dynamic> sendMap = {};
  sendMap = removeNullFormData(postMap);
  return await post(consume['getConsumptionTotal'], sendMap);
}

/// 每盘配料明细
Future<Map<String, dynamic>> getFormulaDetails(
    {int page,
    int pageSize,
    String vehicleId,
    String taskId,
    String stirId,
    String stgId,
    String beginTime,
    String endTime}) async {
  Map<String, dynamic> postMap = {
    'page': page,
    'pageSize': pageSize == null ? 10 : pageSize,
    'compid': await getEnterpriseId(),
    'beginTime': beginTime,
    'endTime': endTime,
    'vehicleId': vehicleId,
    'stirId': stirId,
    'taskId': taskId,
    'stgId': stgId,
  };
  Map<String, dynamic> sendMap = {};
  sendMap = removeNullFormData(postMap);
  return await post(consume['getFormulaDetails'], sendMap);
}

/// 原材料统计汇总
Future<Map<String, dynamic>> getMatTotal(
    {int page,
    int pageSize,
    String vehicleId,
    String taskId,
    String stirId,
    String stgId,
    String beginTime,
    String endTime}) async {
  Map<String, dynamic> postMap = {
    'page': page,
    'pageSize': pageSize == null ? 10 : pageSize,
    'compid': await getEnterpriseId(),
    'beginTime': beginTime,
    'endTime': endTime,
    'vehicleId': vehicleId,
    'stirId': stirId,
    'taskId': taskId,
    'stgId': stgId,
  };
  Map<String, dynamic> sendMap = {};
  sendMap = removeNullFormData(postMap);

  return await post(consume['getMatTotal'], sendMap);
}

/// 生产消耗汇总合计方量
Future<Map<String, dynamic>> getConsumeClose(
    {String vehicleId,
    String taskId,
    String stirId,
    String stgId,
    String beginTime,
    String endTime}) async {
  Map<String, dynamic> postMap = {
    'compid': await getEnterpriseId(),
    'beginTime': beginTime,
    'endTime': endTime,
    'vehicleId': vehicleId,
    'stirId': stirId,
    'taskId': taskId,
    'stgId': stgId,
  };
  Map<String, dynamic> sendMap = {};
  sendMap = removeNullFormData(postMap);

  return await post(consume['getConsumeClose'], sendMap);
}

///生产计划统计
Future<Map<String, dynamic>> getProductionStatistics(int page,
    {String beginTime,
    String endTime,
    String taskStatus,
    String stgId,
    String eppCode,
    String builderCode,
    String placeStyle,
    int pageSize}) async {
  Map<String, dynamic> postMap = {
    'compid': await getEnterpriseId(),
    'page': page,
    'beginTime': beginTime,
    'endTime': endTime,
    'taskStatus': taskStatus,
    'stgId': stgId,
    'eppCode': eppCode,
    'builderCode': builderCode,
    'placeStyle': placeStyle,
    'pageSize': pageSize == null ? 10 : pageSize,
  };
  Map<String, dynamic> sendMap = {};
  sendMap = removeNullFormData(postMap);

  return await post(production['getProductionStatistics'], sendMap);
}

/// 获取小票签收列表

Future<Map<String, dynamic>> getTaskSaleInvoiceList(
    {String beginTime,
    String endTime,
    String eppCode,
    String builderCode,
    String taskId,
    String placing,
    var upStatus,
    int page,
    int pageSize}) async {
  Map<String, dynamic> postMap = {
    'compid': await getEnterpriseId(),
    'beginTime': beginTime,
    'endTime': endTime,
    'eppCode': eppCode,
    'builderCode': builderCode,
    'taskId': taskId,
    'page': page,
    'placing': placing,
    'upStatus': upStatus,
    'pageSize': pageSize == null ? 10 : pageSize,
  };
  Map<String, dynamic> sendMap = {};
  sendMap = removeNullFormData(postMap);
  return await post(taskPlan['getTaskSaleInvoiceList'], sendMap);
}

/// 获取小票详情
Future<Map<String, dynamic>> getTaskSaleInvoiceDetail({String id}) async {
  Map<String, dynamic> postMap = {
    'compid': await getEnterpriseId(),
    'id': id,
  };

  Map<String, dynamic> sendMap = {};

  sendMap = removeNullFormData(postMap);
  return await post(taskPlan['getTaskSaleInvoiceDetail'], sendMap);
}

//调度派车详情
Future<Map<String, dynamic>> getSendCarDistance(String taskId,
    {String compid}) async {
  Map<String, dynamic> postMap = {
    'compid': await getEnterpriseId(),
    'taskId': taskId
  };
  Map<String, dynamic> sendMap = {};
  sendMap = removeNullFormData(postMap);
  return await post(taskModel['getSendCarDistance'], sendMap);
}

//生产计划单计算
Future<Map<String, dynamic>> getProductionStatisticstotalPreNum(
    {String beginTime,
    String endTime,
    String taskStatus,
    String stgId,
    String eppCode,
    String builderCode,
    String placeStyle}) async {
  Map<String, dynamic> postMap = {
    'compid': await getEnterpriseId(),
    'beginTime': beginTime,
    'endTime': endTime,
    'taskStatus': taskStatus,
    'stgId': stgId,
    'eppCode': eppCode,
    'builderCode': builderCode,
    'placeStyle': placeStyle
  };
  Map<String, dynamic> sendMap = {};
  sendMap = removeNullFormData(postMap);

  return await post(production['getProductionStatisticstotalPreNum'], sendMap);
}

///砼标号管理
Future<Map<String, dynamic>> getConcreteLabelingManagement(int page,
    {String stgId, String grade, int pageSize}) async {
  Map<String, dynamic> postMap = {
    'compid': await getEnterpriseId(),
    'stgId': stgId,
    'grade': grade,
    'page': page,
    'pageSize': pageSize == null ? 10 : pageSize
  };
  Map<String, dynamic> sendMap = {};
  sendMap = removeNullFormData(postMap);

  return await post(stgIdMange['getConcreteLabelingManagement'], sendMap);
}

//调度派车列表
Future<Map<String, dynamic>> getSendCarList(
    int page, int recStatus, int taskStatus,
    {int pageSize}) async {
  Map<String, dynamic> postMap = {
    'compid': await getEnterpriseId(),
    'page': page,
    'pageSize': pageSize == null ? 10 : pageSize,
    'recStatus': recStatus,
    'taskStatus': taskStatus,
  };
  Map<String, dynamic> sendMap = {};
  sendMap = removeNullFormData(postMap);

  return await post(taskModel['getSendCarList'], sendMap);
}

/// 开具生产配比详情
Future<Map<String, dynamic>> getFormulaInfoEdit({
  String taskId,
  String stirId,
  String token,
}) async {
  Map<String, dynamic> postMap = {
    "taskId": taskId,
    "stirId": stirId,
    "compid": await getEnterpriseId(),
    "opid": (await getUid()).toString(),
    "token": await getToken(),
  };

  Map<String, dynamic> sendMap = {};

  sendMap = removeNullFormData(postMap);
  return await post(laboratroy['getFormulaInfo'], sendMap);
}

/// 小票签收审核
Future<Map<String, dynamic>> getTaskSaleInvoiceExamine(
    {int id, double qianNum, String saleFileImage}) async {
  Map<String, dynamic> postMap = {
    'compid': await getEnterpriseId(),
    'id': id,
    'qiannum': qianNum,
    'saleFileImage': saleFileImage,
    'opid': (await getUid()).toString(),
  };
  Map<String, dynamic> sendMap = {};
  sendMap = removeNullFormData(postMap);
  return await post(taskPlan['getTaskSaleInvoiceExamine'], sendMap);
}

/// 司机排班LED
Future<List<dynamic>> getDriverShiftLED(
    {String compid,
    String stirId,
    String vehicleStatus,
    String vehicleClass}) async {
  Map<String, dynamic> postMap = {
    'compid': await getEnterpriseId(),
    'stirId': stirId,
    'vehicleStatus': vehicleStatus,
    'vehicleClass': vehicleClass
  };
  Map<String, dynamic> sendMap = {};
  sendMap = removeNullFormData(postMap);
  return await post(taskPlan['getDriverShiftLED'], sendMap);
}

/// 开具配分比编辑
Future<List<dynamic>> spinsertLMTaskTheoryFormula({Map edit}) async {
  Map<String, dynamic> postMap = {};
  Map<String, dynamic> sendMap = {};
  sendMap = removeNullFormData(postMap);
  return await post(laboratroy['spinsertLMTaskTheoryFormula'], edit);
}

/// 开具配分比审核
Future<List<dynamic>> spVerifyLMTaskTheoryFormula({
  String taskId,
  String verifyStatus,
  String strId,
  String formulaCode,
  String token,
}) async {
  Map<String, dynamic> postMap = {
    'TaskId': taskId,
    'verifystatus': verifyStatus,
    'stirid': strId,
    'opid': (await getUid()).toString(),
    'token': await getToken(),
    'compid': await getEnterpriseId(),
  };
  Map<String, dynamic> sendMap = {};
  sendMap = removeNullFormData(postMap);
  return await post(laboratroy['spVerifyLMTaskTheoryFormula'], sendMap);
}

/// 编辑司机排班信息
Future<List<dynamic>> getDriverShiftUpdate(
    {String id,
    String personalCode,
    String vehicleId,
    String workClass,
    int workStarTime,
    int workOverTime,
    String remarks}) async {
  Map<String, dynamic> postMap = {
    'compid': await getEnterpriseId(),
    'id': id,
    'personalCode': personalCode,
    'vehicleId': vehicleId,
    'workClass': workClass,
    'workStarTime': workStarTime,
    'workOverTime': workOverTime,
    'remarks': remarks,
  };
  Map<String, dynamic> sendMap = {};
  sendMap = removeNullFormData(postMap);
  return await post(taskPlan['getDriverShiftUpdate'], sendMap);
}

/// 司机排班列表信息
Future<Map<String, dynamic>> getDriverShiftList({
  String vehicleId,
  String personalCode,
  String personalName,
  String workClass,
  String workStarTime,
  int beginTime,
  int endTime,
  int page,
  int pageSize,
}) async {
  Map<String, dynamic> postMap = {
    'vehicleId': vehicleId,
    'personalCode': personalCode,
    'personalName': personalName,
    'workClass': workClass,
    'workStarTime': workStarTime,
    'beginTime': beginTime,
    'endTime': endTime,
    'compid': await getEnterpriseId(),
    'page': page,
    'pageSize': pageSize == null ? 10 : pageSize,
  };
  Map<String, dynamic> sendMap = {};
  sendMap = removeNullFormData(postMap);

  return await post(taskPlan['getDriverShiftList'], sendMap);
}

/// 选择司机

Future<Map<String, dynamic>> getPersonalName() async {
  Map<String, dynamic> postMap = {
    'compid': await getEnterpriseId(),
  };

  Map<String, dynamic> sendMap = {};

  postMap.forEach((String key, Object value) {
    if (value != null && value != "null") {
      sendMap[key] = value;
    }
  });

  return await post(taskPlan['getPersonalName'], sendMap);
}

/// 选择车号
Future<Map<String, dynamic>> getVehicleId() async {
  Map<String, dynamic> postMap = {
    'compid': await getEnterpriseId(),
  };

  Map<String, dynamic> sendMap = {};
  postMap.forEach((String key, Object value) {
    if (value != null && value != "null") {
      sendMap[key] = value;
    }
  });
  return await post(vehicleId['getVehicleId'], sendMap);
}

/// 添加司机排班列表信息
/// 添加司机排班信息
Future<List<dynamic>> getDriverShiftInsert(
    {String opId,
    String personalCode,
    String vehicleId,
    String workClass,
    int workStarTime,
    int workOverTime,
    String remarks}) async {
  Map<String, dynamic> postMap = {
    'compid': await getEnterpriseId(),
    'opId': (await getUid()).toString(),
    'personalCode': personalCode,
    'vehicleId': vehicleId,
    'workClass': workClass,
    'workStarTime': workStarTime,
    'workOverTime': workOverTime,
    'remarks': remarks,
  };
  Map<String, dynamic> sendMap = {};
  sendMap = removeNullFormData(postMap);

  ///编辑


  /// 分支尚未合并只能使用该路径
  return await post(taskPlan['getDriverShiftInsert'], sendMap);
}

///添加合同运距
Future<String> saveContractDistance({
  String compid,
  String distance,
  String contractUid,
  String contractDetailCode,
  String remarks,
}) async {
  Map<String, dynamic> postMap = {
    'compid': await getEnterpriseId(),
    'remarks': remarks,
    'distance': distance,
    'contractUID': contractUid,
    'cContractCode': contractDetailCode
  };
  Map<String, dynamic> sendMap = {};
  sendMap = removeNullFormData(postMap);
  return await post(contractModel['saveContractDistance'], sendMap);
}

//调度派车正在生产
Future<Map<String, dynamic>> getSendCarCountNum({String compid}) async {
  Map<String, dynamic> postMap = {'compid': await getEnterpriseId()};
  Map<String, dynamic> sendMap = {};
  sendMap = removeNullFormData(postMap);
  return await post(taskModel['getSendCarCountNum'], sendMap);
}

//调度派车生产总数
Future<Map<String, dynamic>> totalProductNum(String taskId,
    {String compid}) async {
  Map<String, dynamic> postMap = {
    'compid': await getEnterpriseId(),
    'taskId': taskId,
  };
  Map<String, dynamic> sendMap = {};
  sendMap = removeNullFormData(postMap);
  return await post(taskModel['totalProductNum'], sendMap);
}

Future<Map<String, dynamic>> totalScraoNum(String taskId,
    {String compid}) async {
  Map<String, dynamic> postMap = {
    'compid': await getEnterpriseId(),
    'taskId': taskId,
  };
  Map<String, dynamic> sendMap = {};
  sendMap = removeNullFormData(postMap);
  return await post(taskModel['totalScraoNum'], sendMap);
}

//调度派车今日产量
Future<Map<String, dynamic>> getSendCarTodayNum() async {
  Map<String, dynamic> postMap = {'compid': await getEnterpriseId()};
  Map<String, dynamic> sendMap = {};
  sendMap = removeNullFormData(postMap);

  return await post(taskModel['getSendCarTodayNum'], sendMap);
}

//调度派车昨日方量本月方量
Future<List<dynamic>> phoneStatistics(
    {int type, String beginTime, String endTime, String compid}) async {
  Map<String, dynamic> postMap = {
    'compid': await getEnterpriseId(),
    'beginTime': beginTime,
    'endTime': endTime,
    'type': type,
    'token': await getToken()
  };
  Map<String, dynamic> sendMap = {};
  sendMap = removeNullFormData(postMap);
  return await postResultList(total['phoneStatistics'], sendMap);
}

/// 获得权限
Future<Map<String, dynamic>> getAuthValue({
  String token,
  String groupId,
}) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  Map<String, dynamic> postMap = {
    'token': await getToken(),
    'groupId': pref.getInt("agid") == null ? 0 : pref.getInt("agid")
  };
  Map<String, dynamic> sendMap = {};
  sendMap = removeNullFormData(postMap);
  return await post(baseAuth["getAuthValue"], sendMap, headers: {
    'enterprise': await getEnterpriseId(),
    'pid':2
  });
}

//返回是否有该权限
Future<bool> getPermission(String value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (prefs.getString('authValue') != null) {
    List serverPermission = prefs.getString('authValue').split(',');
    return serverPermission.contains(value.toString());
  }
  return false;
}


/// 泵车返回列表查询
Future<Map<String, dynamic>> selectPumpTruckList(int page, int pageSize,
    {String builderName}) async {
  Map<String, dynamic> postMap = {
    'compid': await getEnterpriseId(),
    'page': page,
    'pageSize': pageSize == null ? 10 : pageSize,
    'builderName': builderName
  };
  Map<String, dynamic> sendMap = {};
  sendMap = removeNullFormData(postMap);
  return await post(contractModel["selectPumpTruckList"], sendMap);
}

// 添加泵车类别价格
//　留用
Future<Map<String, dynamic>> insertPumpTruck(
    {String contractUID,
    String contractCode,
    String pumpType,
    String pumPrice,
    String tableExpense}) async {
  Map<String, dynamic> postMap = {
    'opid': (await getUid()).toString(),
    'compid': await getEnterpriseId(),
    'contractUID': contractUID,
    'contractCode': contractCode,
    'pumptype': pumpType,
    'pumPrice': pumPrice,
    'tableExpense': tableExpense,
  };
  Map<String, dynamic> sendMap = {};
  sendMap = removeNullFormData(postMap);

  return await post(contractModel['insertPumpTruck'], sendMap);
}

/// 获得快捷方式列表数组
Future<List<dynamic>> getUserFavorite() async {
  Map<String, dynamic> postMap = {};
  Map<String, dynamic> sendMap = {};
  sendMap = removeNullFormData(postMap);
  return await post1(userModel['getUserFavorite'], sendMap, headers: {
    'enterprise': await getEnterpriseId(),
     'pid': 2,
    'token': await getToken()
  });
}

/// 编辑快捷方式列表数组
setUserFavorite({String config}) async {
  Map<String, dynamic> postMap = {"config":config};
  Map<String, dynamic> sendMap = {};
  sendMap = removeNullFormData(postMap);

  return await post(userModel['setUserFavorite'], sendMap, headers: {
    'enterprise': await getEnterpriseId(),
     'pid': 2,
    'token': await getToken()
  });
}

Future<Object> checkUpdate() async {
  return await getJSON(other["checkUpadte"]);
}

// 查看用户列表

Future<Map<String, dynamic>> userList({
  int page,
  int pageSize,
  String username,
  String phoneNum,
  String email,
  String enterpriseId,
}) async {
  Map<String, dynamic> postMap = {
    'page': page,
    'pageSize': pageSize == null ? 10 : pageSize,
    'username': username,
    'phoneNum': phoneNum,
    'email': email,
    'enterpriseId': await getEnterpriseId(),
    'token': await getToken()
  };
  Map<String, dynamic> sendMap = {};
  postMap.forEach((String key, Object value) {
    if (value != null && value != "null" && value != "") {
      sendMap[key] = value;
    }
    if (value == null || value == "") {
      sendMap[key] = "";
    }
  });
  return await post(userModel['userList'], sendMap, headers: {
    'enterprise': await getEnterpriseId(),
     'pid': 2,
    'token': await getToken()
  });
}

// 添加用户
Future<Map<String, dynamic>> addUsers({
  String uid,
  String username,
  String password,
  String confirmPassword,
  String phone,
  String enterprise,
  String email,
  String eid,
  String epShortname,
  String agid,
  String agName,
  String bindSaleManName,
  String erpType,
  String authGroup,
  String status,
}) async {
  Map<String, dynamic> postMap = {
    'uid': 0,
    'username': username,
    'password': password,
    'confirmPassword': confirmPassword,
    'phone': phone,
    'enterprise': "",
    'email': email,
    'eid': 0,
    'epShortname': "",
    'agid': "",
    'agName': "",
    'bindSaleManName': bindSaleManName,
    'erpType': erpType,
    'authGroup': 0,
    'status': status,
  };
  Map<String, dynamic> sendMap = {};
  postMap.forEach((String key, Object value) {
    if (value != null && value != "null" && value != "") {
      sendMap[key] = value;
    }
    if (value == null || value == "") {
      sendMap[key] = "";
    }
  });
  return await post(userModel["addUser"], sendMap, headers: {
    'enterprise': await getEnterpriseId(),
     'pid': 2,
    'token': await getToken()
  });
}

// 获得指定企业权限列表
Future<List<dynamic>> getAuthGroupDropDown({String enterprise}) async {
  Map<String, dynamic> postMap = {
    'enterprise': await getEnterpriseId(),
    'token': await getToken(),
     'pid': 2,
  };
  Map<String, dynamic> sendMap = {};
  sendMap = removeNullFormData(postMap);

  return await post(baseAuth["getAuthGroupDropDown"], sendMap, headers: {
    'enterprise': await getEnterpriseId(),
     'pid': 2,
    'token': await getToken()
  });
}

// 设置用户权限
setUserAuth({Map obj}) async {
  return await postFormJson(userModel["setUserAuth"], obj, headers: {
    "pid": 2,
    "enterprise": await getEnterpriseId(),
    "token": await getToken(),
  });
}

// 用户编辑
//    https://api.hntxrj.com/user/editUser
Future<Map<String, dynamic>> editUser({
  String uid,
  String username,
  String phone,
  String email,
  String bindSaleManName,
  String erpType,
  String status,
}) async {
  Map<String, dynamic> postMap = {
    'uid': uid,
    'username': username,
    'phone': phone,
    'email': email,
    'bindSaleManName': bindSaleManName,
    'erpType': erpType,
    'status': status,
  };
  Map<String, dynamic> sendMap = {};
  sendMap = removeNullFormData(postMap);
  return await post(userModel['editUser'], postMap, headers: {
    'enterprise': await getEnterpriseId(),
    'pid':2,
    'token': await getToken()
  });
}

initUser({
  String uid,
  String password,
}) async {
  Map<String, dynamic> postMap = {
    'uid': uid,
    'password': password,
    'token': await getToken()
  };
  Map<String, dynamic> sendMap = {};
  sendMap = removeNullFormData(postMap);

  return await post(userModel['initUser'], sendMap, headers: {
    'enterprise': await getEnterpriseId(),
     'pid': 2,
    'token': await getToken()
  });
}

Future<List<dynamic>> getAdjunct(
    String contractUid, String ccontractCode) async {
  Map<String, dynamic> postMap = {
    "contractUid": contractUid,
    "ccontractCode": ccontractCode,
    "compid": await getEnterpriseId()
  };
  Map<String, dynamic> sendMap = {};
  sendMap = removeNullFormData(postMap);

  return await post(contractModel['getAdjunct'], sendMap, headers: {
    'enterprise': await getEnterpriseId(),
     'pid': 2,
    'token': await getToken()
  });
}

Future uploadAdjunct(String contractUid, String ccontractCode, int num,
    UploadFileInfo file) async {
  Map<String, dynamic> postMap = {
    "contractUid": contractUid,
    "ccontractCode": ccontractCode,
    "compid": await getEnterpriseId(),
    "num": num,
    "file": file
  };
  Map<String, dynamic> sendMap = {};
  sendMap = removeNullFormData(postMap);

  return await post(contractModel['uploadAdjunct'], sendMap,
      isForm: true,
      headers: {
        'enterprise': await getEnterpriseId(),
         'pid': 2,
        'token': await getToken()
      });
}

Future delAdjunct(String fileUid) async {
  return await get('${contractModel['delAdjunct']}/$fileUid', headers: {
    'enterprise': await getEnterpriseId(),
     'pid': 2,
    'token': await getToken()
  });
}

/// 权限组列表
Future<Map<String, dynamic>> getAuthGroup(
  int page,
  int pageSize, {
  int enterpriseId,
  String token,
  String agName,
  int agStatus,
}) async {
  Map<String, dynamic> postMap = {
    'token': await getToken(),
    'enterprise': await getEnterpriseId(),
    'enterpriseId': await getEnterpriseId(),
    'page': page,
    'pageSize': pageSize == null ? 10 : pageSize,
    'agName': agName,
    'agStatus': agStatus
  };
  Map<String, dynamic> sendMap = {};
  sendMap = removeNullFormData(postMap);
  return await post(baseAuth["getAuthGroup"], sendMap, headers: {
    'enterpriseId': await getEnterpriseId(),
    'enterprise': await getEnterpriseId(),
    'pid': 2
  });
}

/// 查看用户
Future<Map<String, dynamic>> viewUser(
  String uid,
) async {
  Map<String, dynamic> postMap = {
    'uid': uid,
    'token': await getToken(),
  };
  Map<String, dynamic> sendMap = {};
  sendMap = removeNullFormData(postMap);
  return await post(userModel["details"], sendMap, headers: {
    'enterprise': await getEnterpriseId(),
    'token': await getToken(),
    'pid': 2
  });
}

/// 查询配件申请表

Future<Map<String, dynamic>> getAccessoriesList(
    {String beginTime,
    String endTime,
    String buyer,
    String requestNumber,
    String goodsName,
    String specification,
    String requestDep,
    String department,
    String requestStatus,
    int page,
    int pageSize}) async {
  Map<String, dynamic> postMap = {
    'compid': await getEnterpriseId(),
    'beginTime': beginTime,
    'endTime': endTime,
    'buyer': buyer,
    'requestNumber': requestNumber,
    'goodsName': goodsName,
    'specification': specification,
    'requestDep': requestDep,
    'department': department,
    'requestStatus': requestStatus,
    'page': page,
    'pageSize': pageSize == null ? 10 : pageSize
  };
  Map<String, dynamic> sendMap = {};
  sendMap = removeNullFormData(postMap);
  return await post(accessories['getAccessoriesList'], sendMap);
}

///添加配件申请表
Future<Map<String, dynamic>> addWmConFigureApply({
  String beginTime,
  String endTime,
  String requestMode,
  String department,
  String buyer,
  String goodsName,
  String specification,
  String num,
  String amount,
  String requestDep,
  String remarks,
  String opId,
}) async {
  Map<String, dynamic> postMap = {
    'compid': await getEnterpriseId(),
    'beginTime': beginTime,
    'endTime': endTime,
    'requestMode': requestMode,
    'department': department,
    'buyer': buyer,
    'goodsName': goodsName,
    'specification': specification,
    'num': num,
    'amount': amount,
    'requestDep': requestDep,
    'remarks': remarks,
    'opId': await getUserName()
  };
  Map<String, dynamic> sendMap = {};
  sendMap = removeNullFormData(postMap);
  return await post(accessories['addWmConFigureApply'], sendMap);
}
///编辑配件申请表

Future<Map<String, dynamic>> editWmConFigureApply({
  String beginTime,
  String endTime,
  String requestNumber,
  String requestMode,
  String department,
  String buyer,
  String goodsName,
  String specification,
  String num,
  String amount,
  String requestDep,
  String remarks,
  String opId,
  String createTime,
  String requestStatus,
}) async {
  Map<String, dynamic> postMap = {
    'compid': await getEnterpriseId(),
    'beginTime': beginTime,
    'endTime': endTime,
    'requestNumber': requestNumber,
    'requestMode': requestMode,
    'department': department,
    'buyer': buyer,
    'goodsName': goodsName,
    'specification': specification,
    'num': num,
    'amount': amount,
    'requestDep': requestDep,
    'remarks': remarks,
    'opId': await getUserName(),
    'createTime': createTime,
    'requestStatus': requestStatus,
  };
  Map<String, dynamic> sendMap = {};
  sendMap = removeNullFormData(postMap);
  return await post(accessories['editWmConFigureApply'], sendMap);
}

/// 申请配件审核
Future<List<dynamic>> editRequestStatus({
  String requestNumber,
  String requestStatus,
  String verifyIdOne,
}) async {
  Map<String, dynamic> postMap = {
    'compid': await getEnterpriseId(),
    'requestNumber': requestNumber,
    'requestStatus': requestStatus,
    'verifyIdOne': await getUserName(),
  };
  Map<String, dynamic> sendMap = {};
  sendMap = removeNullFormData(postMap);
  return await post(accessories['editRequestStatus'], sendMap);
}

/// 申请配件审核
Future<List<dynamic>> cancelRequestStatus({
  String requestNumber,
  String requestStatus,
  String verifyIdOne,
}) async {
  Map<String, dynamic> postMap = {
    'compid': await getEnterpriseId(),
    'requestNumber': requestNumber,
    'requestStatus': requestStatus,
    'verifyIdOne': await getUserName(),
  };
  Map<String, dynamic> sendMap = {};
  sendMap = removeNullFormData(postMap);
  return await post(accessories['cancelRequestStatus'], sendMap);
}

/// 产品链接

Future getProduct() async {
  Map<String, dynamic> postMap = {};
  Map<String, dynamic> sendMap = {};
  sendMap = removeNullFormData(postMap);

  return await getDownload("$downloadUrl/version.json");
}

/// 获得菜单列表

Future getMenuListByProject() async {
  Map<String, dynamic> postMap = {
     'pid': 2,
    'token': await getToken(),
  };
  Map<String, dynamic> sendMap = {};
  sendMap = removeNullFormData(postMap);
  return await post(baseAuth["getMenuListByProject"], sendMap, headers: {
    'enterprise': await getEnterpriseId(),
     'pid': 2,
    'token': await getToken(),
  });
}

/// 权限列表(编辑权限)

Future openAuth({String groupId}) async {
  Map<String, dynamic> postMap = {
     'pid': 2,
    'token': await getToken(),
    'groupId': groupId
  };
  Map<String, dynamic> sendMap = {};
  sendMap = removeNullFormData(postMap);
  return await post(baseAuth["openAuth"], sendMap, headers: {
    'enterprise': await getEnterpriseId(),
     'pid': 2,
    'token': await getToken(),
  });
}

/// 编辑权限组
Future editAuthGroup({
  String agName,
  String agStatus,
  String agid,
  String createTime,
  String enterprise,
  String enterpriseName,
  String project,
  String updateTime,
  String updateUser,
  String updateUserName,
}) async {
  Map<String, dynamic> postMap = {
    "agName": agName,
    "agStatus": agStatus,
    "agid": agid,
    "createTime": createTime,
    "enterprise": enterprise,
    "enterpriseName": enterpriseName,
    "project": project,
    "updateTime": updateTime,
    "updateUser": updateUser,
    "token": await getToken(),
    "_pid": 2
  };
  Map<String, dynamic> sendMap = {};
  sendMap = removeNullFormData(postMap);
  return await post(baseAuth["editAuthGroup"], sendMap, headers: {
    'enterprise': await getEnterpriseId(),
     'pid': 2,
    'token': await getToken(),
  });
}

// 任务单生产配比日志查询

Future<Map<String, dynamic>> getProductionRatio(int page,
    {int pageSize,
    String beginTime,
    String endTime,
    String formulaCode,
    String stgId,
    String stirId,
    String eppCode,
    String placing,
    String taskId}) async {
  Map<String, dynamic> postMap = {
    'page': page,
    'pageSize': pageSize == null ? 10 : pageSize,
    'beginTime': beginTime,
    'endTime': endTime,
    'formulaCode': formulaCode,
    'stgId': stirId,
    'stirId': stirId,
    'eppCode': eppCode,
    'placing': placing,
    'taskId': taskId,
    'compid': await getEnterpriseId(),
  };
  Map<String, dynamic> sendMap = {};
  sendMap = removeNullFormData(postMap);

  return await post(taskPlan["getProductionRatio"], sendMap, headers: {
    'enterprise': await getEnterpriseId(),
     'pid': 2,
    'token': await getToken()
  });
}

// 任务单理论配比日志查询
Future<Map<String, dynamic>> getTheoreticalproportioning(int page,
    {int pageSize,
    String beginTime,
    String endTime,
    String formulaCode,
    String stgId,
    String stirId,
    String eppCode,
    String placing,
    String taskId}) async {
  Map<String, dynamic> postMap = {
    'page': page,
    'pageSize': pageSize == null ? 10 : pageSize,
    'beginTime': beginTime,
    'endTime': endTime,
    'formulaCode': formulaCode,
    'stgId': stirId,
    'stirId': stirId,
    'eppCode': eppCode,
    'placing': placing,
    'taskId': taskId,
    'compid': await getEnterpriseId(),
  };
  Map<String, dynamic> sendMap = {};
  sendMap = removeNullFormData(postMap);
  return await post(taskPlan["getTheoreticalproportioning"], sendMap, headers: {
    'enterprise': await getEnterpriseId(),
     'pid': 2,
    'token': await getToken()
  });
}


// 保存权限

saveAuthValue(
  String authValues,
  String groupId,
) async {
  Map<String, dynamic> postMap = {
    'authValues': authValues,
    "groupId": groupId,
    "token": await getToken(),
    "pid": 2
  };

  return await post(baseAuth["saveAuthValue"], postMap, headers: {
    'enterprise': await getEnterpriseId(),
     'pid': 2,
    'token': await getToken()
  });
}

///生成邀请码
Future<Map<String, dynamic>> invitation(String buildCode) async {
  Map<String, dynamic> postMap = {
    'compid': await getEnterpriseId(),
    'opid': await getUid(),
    'buildCode': buildCode,
  };
  Map<String, dynamic> sendMap = {};
  sendMap = removeNullFormData(postMap);
  return await post(construction['getInvitationCode'], sendMap);
}

///施工方邀请码
///@param compid            企业
///@param build_code       施工方代码
///@param use_status        状态 已使用1、未使用0
///@param create_user       创建人
///@param beginTime         开始时间
///@param endTime           结束时间
///@param page              页码
///@param pageSize          每页数量
Future<Map<String, dynamic>> getInvitationList(int page,
    {int pageSize,
    String beginTime,
    String endTime,
    buildCode,
    useStatus}) async {
  Map<String, dynamic> postMap = {
    'compid': await getEnterpriseId(),
    'beginTime': beginTime,
    'buildCode': buildCode,
    'usestatus': useStatus,
    'endTime': endTime,
    'page': page,
    'pageSize': pageSize == null ? 10 : pageSize
  };
  Map<String, dynamic> sendMap = {};
  sendMap = removeNullFormData(postMap);

  return await post(construction['getInvitationList'], sendMap);
}

///作废邀请码
Future<Map<String, dynamic>> updateUseStatus(String buildInvitationCode) async {
  Map<String, dynamic> postMap = {
    'compid': await getEnterpriseId(),
    'buildInvitationCode': buildInvitationCode,
  };

  Map<String, dynamic> sendMap = {};

  postMap.forEach((String key, Object value) {
    if (value != null && value != "null") {
      sendMap[key] = value;
    }
  });
  return await post(construction['updateUseStatus'], sendMap);
}

/// 自动生成合同编号
Future<String> makeAutoContractId() async {
  Map<String, dynamic> postMap = {
    'compid': await getEnterpriseId(),
    'opid': await getUid(),
    'token': await getToken(),
  };
  Map<String, dynamic> sendMap = {};
  sendMap = removeNullFormData(postMap);
  return await postResultString(contractModel["makeAutoContractId"], sendMap);
}

/// 添加工程
Future<List<dynamic>> addEppName({
  String eppName,
  String shortName,
  String address,
  String linkMan,
  String linkTel,
  String remarks,
  String compid,
}) async {
  Map<String, dynamic> postMap = {
    'EPPName2': eppName,
    'shortName8': shortName,
    'Address3': address,
    'LinkMan4': linkMan,
    'LinkTel5': linkTel,
    'Remarks6': remarks,
    'compid': await getEnterpriseId(),
    'opid': await getUid(),
    'token': await getToken(),
    'mark': 0
  };
  Map<String, dynamic> sendMap = {};
  sendMap = removeNullFormData(postMap);
  return await post(contractV2["addEppName"], sendMap);
}

/// 添加施工单位
Future<List<dynamic>> addConstructionUnit({
  String builderName,
  String builderShortName,
  String address,
  String corporation,
  String fax,
  String linkTel,
}) async {
  Map<String, dynamic> postMap = {
    'builderName': builderName,
    'builderShortName': builderShortName,
    'address': address,
    'corporation': corporation,
    'fax': fax,
    'linkTel': linkTel,
    'compid': await getEnterpriseId(),
    'opid': await getUid(),
    'token': await getToken(),
    'mark': 0
  };
  Map<String, dynamic> sendMap = {};
  sendMap = removeNullFormData(postMap);
  return await post(produce["addConstructionUnit"], sendMap);
}

///     获取方量统计
///
///      @param compid    　企业
///      @param beginTime 　开始时间
///      @param endTime   　结束时间
///      @param page      　页数
///      @param pageSize  　每页显示多少条
Future<Map<String, dynamic>> getSquareQuantitySum(
    {String compid, String beginTime, String endTime, int type}) async {
  Map<String, dynamic> postMap = {
    'compid': await getEnterpriseId(),
    'beginTime': beginTime,
    'endTime': endTime,
    'type': type,
  };
  Map<String, dynamic> sendMap = {};
  sendMap = removeNullFormData(postMap);

  return await post(taskModel['getSquareQuantitySum'], sendMap);
}

/// 添加新的权限组
/// 编辑权限组
Future editAuthGroupV2({
  String agName,
  String agStatus,
  String agid,
  String createTime,
  String enterprise,
  String enterpriseName,
  String project,
  String updateTime,
  String updateUser,
  String updateUserName,
}) async {
  Map<String, dynamic> postMap = {
    "agName": agName,
    "agStatus": agStatus,
    "agid": agid,
    "createTime": createTime,
    "enterprise": await getEnterpriseId(),
    "enterpriseName": enterpriseName,
    "project": project,
    "updateTime": updateTime,
    "updateUser": (await getUid()).toString(),
    "token": await getToken(),
    "_pid": 2
  };
  Map<String, dynamic> sendMap = {};
  sendMap = removeNullFormData(postMap);
  return await post(baseAuth["editAuthGroup"], sendMap, headers: {
    'enterprise': await getEnterpriseId(),
     'pid': 2,
    'token': await getToken(),
  });
}

/// 获取用户绑定司机
Future<List<dynamic>> getDriverList() async {
  Map<String, dynamic> postMap = {'compid': await getEnterpriseId()};
  Map<String, dynamic> sendMap = {};
  sendMap = removeNullFormData(postMap);
  return await post(driver["getDriverList"], sendMap, headers: {
    'enterprise': await getEnterpriseId(),
     'pid': 2,
    'token': await getToken(),
  });
}

/// 绑定司机
Future<Map<String, dynamic>> bindDriver(int uid, String driverCode) async {
  Map<String, dynamic> postMap = {
    'compid': await getEnterpriseId(),
    'uid': uid,
    'driverCode': driverCode
  };
  Map<String, dynamic> sendMap = {};
  sendMap = removeNullFormData(postMap);

  return await post(userModel["bindDriver"], sendMap, headers: {
    'enterprise': await getEnterpriseId(),
     'pid': 2,
    'token': await getToken(),
  });
}
/// 超差盘数
Future<int> getErroPan(int beginTime, int endTime) async {
  Map<String, dynamic> postMap = {
    'compid': await getEnterpriseId(),
    'beginTime': beginTime,
    'endTime': endTime
  };
  Map<String, dynamic> sendMap = {};
  sendMap = removeNullFormData(postMap);

  return await post(consume["getErroPan"], sendMap);
}



/// 获得加价项目列表
Future<List<dynamic>> getPriceMarkup() async {
  Map<String, dynamic> postMap = {
    'compid': await getEnterpriseId(),
  };
  Map<String, dynamic> sendMap = {};
  postMap.forEach((String key, Object value) {
    if (value != null && value != "null" && value != "") {
      sendMap[key] = value;
    }
  });
  return await post(taskPlan['getPriceMarkup'], sendMap);
}

/// 保存加价项目
Future<List<dynamic>> addTaskPriceMarkup(String taskId,String ppCodes) async {
  Map<String, dynamic> postMap = {
    'compid': await getEnterpriseId(),
    'taskId':taskId,
    'ppCodes': ppCodes
  };
  Map<String, dynamic> sendMap = {};
  postMap.forEach((String key, Object value) {
    if (value != null && value != "null" && value != "") {
      sendMap[key] = value;
    }
  });
  return await post(taskPlan['addTaskPriceMarkup'], sendMap);
}