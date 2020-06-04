

import 'package:flutter_spterp/api.dart';

class URL {
  final Map<String, String> URLS = null;

  ///base项目接口
  static Map<String, String> baseModels = {
    "user": baseUrl + "/user",
    "journalism": baseUrl + "/journalism",
    "feedback": baseUrl + "/feedback",
    "enterprise": baseUrl + "/enterprise",
    "baseAuth": baseUrl + "/auth",
  };

  ///erp项目接口
  static Map<String, String> erpModels = {
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
    "WeightType": erpUrl + "/api/public",
    "stockIn": erpUrl + "/api/stockIn",
    "matweigh": erpUrl + "/api/stockIn",
    "concrete": erpUrl + "/api/concrete",
    "consume": erpUrl + "/api/consume",
    "production": erpUrl + "/api/production",
    "stgIdMange": erpUrl + "/api/stgIdMange",
    "total": erpUrl + "/total",
    "vehicleId": erpUrl + "/api/vehicleId",
    "laboratroy": erpUrl + "/laboratroy",
    "auth": erpUrl + "/auth",
    "accessories": erpUrl + "/api/parts",
    "construction": erpUrl + "/api/construction",
    "contractV2": erpUrl + "/contract",
    "produce": erpUrl + "/produce",
    "driver": erpUrl + "/driver",
    "erpEnterprise": erpUrl + "/api/enterprise",
  };

  ///司机项目接口
  static Map<String, String> driverModels = {
    "driver1": driverUrl + "/driver",
  };

   static Map<String, String> driver1 = {
    //获取工程地址（任务单送货）地址
    "getEppAddress": driverModels["driver1"] + "/getEppAddress",
    //保存工程地址
    "saveEppAddress": driverModels["driver1"] + "/saveEppAddress",
    //保存工程地址
    "driverLocation": driverModels["driver1"] + "/driverLocation",
  };

   static Map<String, String> driver = {
    "getDriverList": erpModels["driver"] + "/getDriverList",
    "getTaskSaleInvoiceList": erpModels['driver'] + "/getTaskSaleInvoiceList",
    "getJumpVehicleList": erpModels['driver'] + "/getJumpVehicleList",
    "taskSaleInvoiceReceipt": erpModels['driver'] + "/taskSaleInvoiceReceipt",
    "uploadTaskSaleInvoiceReceiptSign":
        erpModels['driver'] + "/uploadTaskSaleInvoiceReceiptSign",
    "getDriverName": erpModels['driver'] + "/getDriverName",
    "getTaskSaleInvoiceSum": erpModels['driver'] + "/getTaskSaleInvoiceSum",
    "getStatisticData": erpModels['driver'] + "/getTaskSaleInvoiceSum",
    "getDriverWorkTime": erpModels['driver'] + "/getDriverWorkTime",
    "saveDriverWorkTime": erpModels['driver'] + "/saveDriverWorkTime",
    "getTaskSaleInvoiceDetail": erpModels['driver'] + "/getTaskSaleInvoiceDetail",
    "saveTaskSaleInvoiceReceiptSign": erpModels['driver'] + "/saveTaskSaleInvoiceReceiptSign",
     "updateVehicleStatus": erpModels['driver'] + '/updateVehicleStatus',
   };


   static Map<String, String> contractV2 = {
    "addEppName": erpModels["contractV2"] + "/spinsertUpDelSMEPPInfo",
  };

   static Map<String, String> produce = {
    "addConstructionUnit": erpModels["produce"] + "/insertUpDelBuilder",
    "getRealStock": erpModels["produce"] + "/getRealStock"
  };
   //公司相关uri
  static Map<String, String> erpEnterprise = {
    "getEnterpriseAddress": erpModels["erpEnterprise"] + "/getEnterpriseAddress",
  };

   static Map<String, String> other = {
    // 检测更新/
    "checkUpadte": "http://downloads.hntxrj.com/car_version.json",
  };

   static Map<String, String> baseAuth = {
    "getAuthValue": baseModels['baseAuth'] + "/getAuthValue",
    "getAuthGroup": baseModels['baseAuth'] + "/getAuthGroup",
    "getAuthGroupDropDown": baseModels['baseAuth'] + "/getAuthGroupDropDown",
    "getMenuListByProject": baseModels["baseAuth"] + "/getMenuListByProject",
    "openAuth": baseModels["baseAuth"] + "/openAuth",
    "editAuthGroup": baseModels["baseAuth"] + "/editAuthGroup",
    "saveAuthValue": baseModels["baseAuth"] + "/saveAuthValue",
  };

   static Map<String, String> laboratroy = {
    "getFormulaInfo": erpModels['laboratroy'] + "/getFormulaInfo",
    "spinsertLMTaskTheoryFormula":
    erpModels['laboratroy'] + "/spinsertLMTaskTheoryFormula",
    "spVerifyLMTaskTheoryFormula":
    erpModels['laboratroy'] + "/spVerifyLMTaskTheoryFormula",
  };

   static Map<String, String> total = {
    "phoneStatistics": erpModels['total'] + "/phoneStatistics"
  };
   static Map<String, String> production = {
    "getProductionStatistics": erpModels['production'] + "/getProductionStatistics",
    "getProductionStatisticstotalPreNum":
    erpModels['production'] + "/getProductionStatisticstotalPreNum",
  };
   static Map<String, String> vehicleId = {
    "getVehicleId": erpModels['vehicleId'] + "/getVehicleId",
  };
   static Map<String, String> consume = {
    "getTaskConsumeList": erpModels['consume'] + "/getTaskConsumeList",
    "getConsumptionTotal": erpModels['consume'] + "/getConsumptionTotal",
    "getFormulaDetails": erpModels['consume'] + "/getFormulaDetails",
    "getMatTotal": erpModels['consume'] + "/getMatTotal",
    "getConsumeClose": erpModels['consume'] + "/getConsumeClose",
    "getProductDatail": erpModels['consume'] + "/getProductDatail",
  };
   static Map<String, String> weightType = {
    "getweightType": erpModels['WeightType'] + "/getDropDown"
  };
   static Map<String, String> stirInfoSet = {
    "getStirInfoSet": erpModels['stirInfoSet'] + "/getStirInfoSet"
  };
   static Map<String, String> vehicle = {
    "getVehicleWorkloadDetail": erpModels['vehicle'] + "/getVehicleWorkloadDetail",
    "getVehicleWorkloadSummary": erpModels['vehicle'] + "/getVehicleWorkloadSummary",
    "getVehicleWorkTowingPumpDetail":
    erpModels['vehicle'] + "/getVehicleWorkTowingPumpDetail",
    "getVehicleWorkTowingPumpCount":
    erpModels['vehicle'] + "/getVehicleWorkTowingPumpCount",
    "getDriverTransportationDetails":
    erpModels['vehicle'] + "/getDriverTransportationDetails",
    "getDriverTransportationCount":
    erpModels['vehicle'] + "/getDriverTransportationCount",
    "getDriverDragPumpCount": erpModels['vehicle'] + "/getDriverDragPumpCount",
    "getPumpTruckCount": erpModels['vehicle'] + "/getPumpTruckCount",
    "getPumpOperatorTruckCount": erpModels['vehicle'] + "/getPumpOperatorTruckCount",
    "getPumpTruckDetails": erpModels['vehicle'] + "/getPumpTruckDetails",
    "getWorkloadStatistics": erpModels['vehicle'] + "/getWorkloadStatistics",
    "getVehicleWorkloadSummaryCount":
    erpModels['vehicle'] + "/getVehicleWorkloadSummaryCount",
    "getDriverTransportationSum":
    erpModels['vehicle'] + "/getDriverTransportationSum",
    "getPumpTruckSum": erpModels['vehicle'] + "/getPumpTruckSum",
    "getPumpTruckWorkloadStatistics":
    erpModels['vehicle'] + "/getPumpTruckWorkloadStatistics",
    "getPumpTruckSum": erpModels['vehicle'] + "/getPumpTruckSum",
    "getDriverTransportationSum":
    erpModels['vehicle'] + "/getDriverTransportationSum",
    "getDriverTransportationCarNumList":
    erpModels['vehicle'] + "/getDriverTransportationCarNumList",
    "stock": erpModels['vehicle'] + "/api/stock",
    "stockIn": erpModels['vehicle'] + "/api/stockIn",
    "getVehicleId": erpModels['vehicle'] + "/api/getVehicleId",
  };
   static Map<String, String> stockIn = {
    "getMatStatistics": erpModels['stockIn'] + "/getMatStatistics",
    "getMatDetailsList": erpModels['stockIn'] + "/getMatDetailsList",
    "getMaterialCount": erpModels['stockIn'] + "/getMaterialCount",
    "getStockInDetails": erpModels['stockIn'] + "/getStockInDetails",
    "getStockInCollectClose": erpModels['stockIn'] + "/getStockInCollectClose",
    "getMatStatisticsClose": erpModels['stockIn'] + "/getMatStatisticsClose",
    "getStockInSelectClose": erpModels['stockIn'] + "/getStockInSelectClose",
    "stock": erpModels['stockIn'] + "/api/stock",
    "vehicle": erpModels['stockIn'] + "/api/vehicle",
    "stirInfoSet": erpModels['stockIn'] + "/api/stirInfoSet",
    "WeightType": erpModels['stockIn'] + "/api/public",
  };
   static Map<String, String> stock = {
    "getStirIds": erpModels['stock'] + "/getStirIds",
    "getStock": erpModels['stock'] + "/getStock",
  };

   static Map<String, String> userModel = {
    "login": baseModels['user'] + "/login",
    "updatePassword": baseModels['user'] + "/updatePassword",
    "userHeader": baseModels['user'] + "/setHeader",
    "getUserFavorite": baseModels['user'] + "/getUserFavorite",
    "setUserFavorite": baseModels['user'] + "/setUserFavorite",
    "userList": baseModels['user'] + "/userList",
    "addUser": baseModels['user'] + "/addUser",
    "setUserAuth": baseModels['user'] + "/setUserAuth",
    "editUser": baseModels['user'] + "/editUser",
    "initUser": baseModels['user'] + "/initUser",
    "details": baseModels['user'] + "/details",
    "getBindDriver": baseModels['user'] + "/getBindDriver",
    "bindDriver": baseModels['user'] + "/bindDriver"
  };
   static Map<String, String> journalismModel = {
    "journalismList": baseModels['journalism'] + "/selectJournalism",
    "getJournalismDetail": baseModels['journalism'] + "/getJournalism",
  };

   static Map<String, String> feedbackModel = {
    "feedbackHeader": baseModels['feedback'] + "/uploadPicture",
    "addFeedback": baseModels['feedback'] + "/addFeedback",
  };
   static Map<String, String> enterprise = {
    "uploadPicture": baseModels['enterprise'] + "/uploadPicture",
    "saveCollectionCode": baseModels['enterprise'] + "/saveCollectionCode",
    "selectEnterprise": baseModels['enterprise'] + "/getEnterprise",
  };
   static Map<String, String> contractModel = {
    "contractList": erpModels['contract'] + "/getContractList",
    "getContractDetail": erpModels['contract'] + "/getContractDetail",
    "verifyContract": erpModels['contract'] + "/verifyContract",
    "getContractGradePrice": erpModels['contract'] + "/getContractGradePrice",
    "getContractPriceMarkup": erpModels['contract'] + "/getContractPriceMarkup",
    "getContractPumpPrice": erpModels['contract'] + "/getContractPumpPrice",
    "getContractDistanceSet": erpModels['contract'] + "/getContractDistanceSet",
    "getContractTypeDropDown": erpModels['contract'] + "/getContractTypeDropDown",
    "getPriceTypeDropDown": erpModels['contract'] + "/getPriceTypeDropDown",
    "addContract": erpModels['contract'] + "/addContract",
    "TaskList": erpModels['taskPlan'] + "/taskPlanList",
    "getStgIdDropDown": erpModels['contract'] + "/getStgIdDropDown",
    "saveContractGradePrice": erpModels['contract'] + "/saveContractGradePrice",
    "getPriceMarkupDropDown": erpModels['contract'] + "/getPriceMarkupDropDown",
    "saveContractPriceMarkup": erpModels['contract'] + "/saveContractPriceMarkup",
    "saveContractDistance": erpModels['contract'] + "/saveContractDistance",
    "taskPlan": erpModels['contract'] + "/taskPlan",
    "selectPumpTruckList": erpModels['contract'] + "/selectPumpTruckList",
    "insertPumpTruck": erpModels['contract'] + "/insertPumpTruck",
    "getAdjunct": erpModels['contract'] + "/getAdjunct",
    "delAdjunct": erpModels['contract'] + "/delAdjunct",
    "adjunct": erpModels['contract'] + "/adjunct",
    "uploadAdjunct": erpModels['contract'] + "/uploadAdjunct",
    "makeAutoContractId": erpModels['contract'] + "/makeAutoContractId",
  };
   static Map<String, String> concrete = {
    "getConcreteCount": erpModels['concrete'] + "/getConcreteCount",
    "getConcreteSum": erpModels['concrete'] + "/getConcreteSum"
  };

   static Map<String, String> stgIdMange = {
    "getConcreteLabelingManagement": erpModels['stgIdMange'] + "/getStgIdManage",
  };

   static Map<String, String> construction = {
    "getInvitationCode": erpModels['construction'] + "/getInvitationCode",
    "getInvitationList": erpModels['construction'] + "/getInvitationList",
    "updateusestatus": erpModels['construction'] + "/updateusestatus",
  };
   static Map<String, String> matweigh = {
    "getWeightByMat": erpModels['matweigh'] + "/getWeightByMat",
    "getWeightByVechicId": erpModels['matweigh'] + "/getWeightByVechicId",
    "getWeightByStoName": erpModels['matweigh'] + "/getWeightByStoName",
    "getWeightBySupName": erpModels['matweigh'] + "/getWeightBySupName",
    "getWeightByEmpName": erpModels['matweigh'] + "/getWeightByEmpName",
    "getSynthesizeByMat": erpModels['matweigh'] + "/getSynthesizeByMat",
    "getWeightClose": erpModels['matweigh'] + "/getWeightClose",
  };
   static Map<String, String> taskPlan = {
    "getTaskSaleInvoiceDetail": erpModels['taskPlan'] + "/getTaskSaleInvoiceDetail",
    "getTaskSaleInvoiceList": erpModels['taskPlan'] + "/getTaskSaleInvoiceList",
    "getTaskSaleInvoiceExamine":
    erpModels['taskPlan'] + "/getTaskSaleInvoiceExamine",
    "getDriverShiftLED": erpModels['taskPlan'] + "/getDriverShiftLED",
    "getDriverShiftList": erpModels['taskPlan'] + '/getDriverShiftList',
    "getDriverShiftUpdate": erpModels['taskPlan'] + '/getDriverShiftUpdate',
    "getDriverShiftInsert": erpModels['taskPlan'] + '/getDriverShiftInsert',
    "getPersonalName": erpModels['taskPlan'] + '/getPersonalName',
    "getProductionRatio": erpModels['taskPlan'] + '/getProductionRatio',
    "getTheoreticalproportioning":
    erpModels['taskPlan'] + '/getTheoreticalproportioning',
    "getVirtualRatio": erpModels['taskPlan'] + '/getVirtualRatio',
  };

   static Map<String, String> taskModel = {
    "taskList": erpModels['taskPlan'] + "/taskPlanList",
    "getTaskDetail": erpModels['taskPlan'] + "/getTaskPlanDetail",
    "addTask": erpModels['taskPlan'] + "/addTaskPlan",
    "review": erpModels['taskPlan'] + "/verifyTaskPlan",
    "getSendCarList": erpModels['taskPlan'] + "/getSendCarList",
    "getSendCarDistance": erpModels['taskPlan'] + "/getSendCarDistance",
    "getSendCarTodayNum": erpModels['taskPlan'] + "/getSendCarTodayNum",
    "getSendCarCountNum": erpModels['taskPlan'] + "/getSendCarCountNum",
    "totalProductNum": erpModels['taskPlan'] + "/totalProductNum",
    "totalScraoNum": erpModels['taskPlan'] + "/totalScraoNum",
    "getSquareQuantitySum": erpModels['taskPlan'] + "/getSquareQuantitySum",
    "phoneStatistics": erpModels['taskPlan'] + "/phoneStatistics",
    "getProductDriverShiftLED": erpModels['taskPlan'] + "/getProductDriverShiftLED",
  };

   static Map<String, String> eppModel = {"getDropDown": erpModels['epp'] + "/getDropDown"};

   static Map<String, String> builderModel = {
    "getDropDown": erpModels['builder'] + "/getDropDown"
  };
   static Map<String, String> placingModel = {
    "getDropDown": erpModels['placing'] + "/getDropDown"
  };
   static Map<String, String> salesmanModel = {
    "getDropDown": erpModels['salesman'] + "/getDropDown"
  };
   static Map<String, String> publicModel = {
    "getDropDown": erpModels['public'] + "/getDropDown"
  };
   static Map<String, String> formulaModel = {
    "getFormulaList": erpModels['formula'] + "/getFormulaList",
    "getFormulaByTaskId": erpModels['formula'] + "/getFormulaByTaskId",
    "getFormulaInfo": erpModels['formula'] + "/getFormulaInfo"
  };
   static Map<String, String> accessories = {
    "getAccessoriesList": erpModels['accessories'] + "/getPartsList",
    "getBuyerList": erpModels['accessories'] + "/getBuyerList",
    "getDepartmentList": erpModels['accessories'] + "/getDepartmentList",
    "getRequestStatusList": erpModels['accessories'] + "/getRequestStatusList",
    "addWmConFigureApply": erpModels['accessories'] + "/addWmConFigureApply",
    "getMnemonicCodeList": erpModels['accessories'] + "/getMnemonicCodeList",
    "getRequestNumberDetail": erpModels['accessories'] + "/getRequestNumberDetail",
    "editWmConFigureApply": erpModels['accessories'] + "/editWmConFigureApply",
    "editRequestStatus": erpModels['accessories'] + "/editRequestStatus",
    "cancelRequestStatus": erpModels['accessories'] + "/cancelRequestStatus",
  };



}
