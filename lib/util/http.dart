import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_spterp/api.dart';
import 'package:flutter_spterp/component/toast.dart';

Future<Object> post(url, data,
    {headers, bool resultStr, bool isForm = false}) async {
  BaseOptions options = BaseOptions(
      method: 'post',
      contentType: ContentType.parse("application/x-www-form-urlencoded"),
      headers: headers == null
          ? {
              'pid': -1,
            }
          : headers);
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
  return respMap["data"] is String
      ? json.decode(respMap["data"])
      : respMap["data"];
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

  return respMap["data"] is String
      ? json.decode(respMap["data"])
      : respMap["data"];
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
