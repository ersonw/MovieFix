import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:movie_fix/data/User.dart';
import '../tools/CustomDialog.dart';
import '../tools/RequestApi.dart';
import '../Global.dart';
import 'Loading.dart';
import 'MessageUtil.dart';
import 'MinioUtil.dart';
class Request {
  static late Dio _dio;
  static init() {
    _dio = Dio(_getOptions());
    configModel.addListener(() {
      _dio.options.baseUrl = _getDomain();
    });
    userModel.addListener(() {
      _dio.options.headers['Token'] = userModel.hasToken() ? userModel.user.token : '';
    });
  }
  static _getDomain(){
    String domain = configModel.config.mainDomain;
    if(!domain.startsWith("http")){
      domain = 'http://$domain';
    }
    return domain;
  }
  static _getOptions(){
    /// 自定义Header
    Map<String, dynamic> httpHeaders = {
      'Token': userModel.hasToken() ? userModel.user.token : '',
    };
    return BaseOptions(
      baseUrl: _getDomain(),
      headers: httpHeaders,
      // contentType: Headers.jsonContentType,
      responseType: ResponseType.json,
      receiveDataWhenStatusError: false,
      connectTimeout: 30000,
      receiveTimeout: 3000,
    );
  }

  static Future<String?> _get(String path,Map<String, dynamic> params)async{
    // if(Global.initMain == true) Loading.show(Global.mainContext);
    try{
      Response response = await _dio.get(path,queryParameters: params, options: Options(
        headers: {
          'Token': userModel.hasToken() ? userModel.user.token : '',
          "Content-Type": "application/x-www-form-urlencoded",
        },
        responseType: ResponseType.json,
        receiveDataWhenStatusError: false,
        receiveTimeout: 30000,
      ));
      Loading.dismiss();
      if(response.statusCode == 200 && response.data != null){
        // print(response.data);
        Map<String, dynamic> data = response.data;
        if(data['message'] != null) CustomDialog.message(data['message']);
        if(data['code'] == 200 && data['data'] != null){
          return Global.decryptCode(data['data']);
        }
      }
    } on DioError catch(e) {
      Loading.dismiss();
      print(e.message);
      print(e);
      // if(e.response == null) {
      //   CustomDialog.message(e.message);
      // } else if(e.response.statusCode == 105){
      //   CustomDialog.message('未登录');
      // }else if(e.response.statusCode == 106){
      //   CustomDialog.message('登录已失效');
      // }else{
      //   CustomDialog.message(e.response.statusMessage);
      // }
    }
  }
  static Future<String?> _post(String path,Map<String, dynamic> data)async{
    // String s = Global.encryptCode(jsonEncode(data));
    // print(s);
    // print(Global.decryptCode(s));
    try{
      Response response = await _dio.post(path,data: Global.encryptCode(jsonEncode(data)), options: Options(
      // Response response = await _dio.post(path,data: data, options: Options(
        headers: {
          // "Content-Type": "application/json",
          'Token': userModel.hasToken() ? userModel.user.token : '',
        },
        responseType: ResponseType.json,
        receiveDataWhenStatusError: false,
        receiveTimeout: 30000,
      ));
      Loading.dismiss();
      if(response.statusCode == 200 && response.data != null){
        Map<String, dynamic> data = response.data;
        // print(data);
        if(data['message'] != null) CustomDialog.message(data['message']);
        if(data['code'] == 200 && data['data'] != null){
          return Global.decryptCode(data['data']);
        }
      }
    } on DioError catch(e) {
      Loading.dismiss();
      print(e.message);
      // if(e.response == null) {
      //   CustomDialog.message(e.message);
      // } else if(e.response.statusCode == 105){
      //   CustomDialog.message('未登录');
      // }else if(e.response.statusCode == 106){
      //   CustomDialog.message('登录已失效');
      // }else{
      //   CustomDialog.message(e.response.statusMessage);
      // }
    }
  }

  static Future<void> checkDeviceId()async{
    String? result = await _get(RequestApi.checkDeviceId.replaceAll('{deviceId}', Global.deviceId!),{});
    if(result!=null){
      Map<String, dynamic> map = jsonDecode(result);
      if(map['token'] != null) {
        // userModel.setToken(map['token']);
        userModel.user = User.formJson(map);
        MessageUtil.rest();
      }
    }
  }
  static Future<bool> userLogin(String username, String password)async{
    Loading.show();
    String deviceId = Global.deviceId ?? 'unknown';
    String platform = Global.platform ?? 'Html5';
    Map<String, dynamic> data = {
      "deviceId": deviceId,
      "platform": platform,
      "username": username,
      "password": Global.generateMd5(password),
    };
    String? result = await _post(RequestApi.userLogin, data);
    if(result!=null){
      Map<String, dynamic> map = jsonDecode(result);
      if(map['token'] != null) {
        // userModel.setToken(map['token']);
        userModel.user = User.formJson(map);
        MessageUtil.reconnect();
        return true;
      }
    }
    return false;
  }
  static Future<String?> userRegisterSms(String phone)async{
    Loading.show();
    String? result = await _get(RequestApi.userRegisterSms.replaceAll('{phone}', phone),{});

    if(result!=null){
      Map<String, dynamic> map = jsonDecode(result);
      if(map['id'] != null) return map['id'];
    }
    return null;
  }
  static Future<bool> userRegister(String password,String codeId,String code)async{
    // String deviceId = Global.deviceId ?? 'unknown';
    // String platform = Global.platform ?? 'Html5';
    Loading.show();
    Map<String, dynamic> data = {
      // "deviceId": deviceId,
      // "platform": platform,
      "password": Global.generateMd5(password),
      "codeId": codeId,
      "code": code
    };
    String? result = await _post(RequestApi.userRegister, data);

    return result != null;
  }
  static Future<void> test()async{
    String? result = await _post(RequestApi.test.replaceAll('{text}', 'replace'), {'token': 'token'});
    if(result!=null){
      print(result);
    }
  }
  static Future<Map<String, dynamic>> searchLabelAnytime({bool showLoading=false})async{
    if(showLoading) Loading.show();
    String? result = await _get(RequestApi.searchLabelAnytime, {});
    // print(result);
    if(result != null){
      return jsonDecode(result);
    }
    return Map<String, dynamic>();
  }
  static Future<Map<String, dynamic>> videoCategoryTags()async{
    String? result = await _get(RequestApi.videoCategoryTags, {});
    // print(result);
    if(result != null){
      return jsonDecode(result);
    }
    return Map<String, dynamic>();
  }
  static Future<Map<String, dynamic>> videoCategoryList({int first=0,int second=0, int last=0,int page=1})async{
    String? result = await _get(RequestApi.videoCategoryList
        .replaceAll('{first}', '$first')
        .replaceAll('{second}', '$second')
        .replaceAll('{last}', '$last')
        .replaceAll('{page}', '$page'), {});
    // print(result);
    if(result != null){
      return jsonDecode(result);
    }
    return Map<String, dynamic>();
  }
  static Future<Map<String, dynamic>> searchLabelHot()async{
    // Loading.show(Global.mainContext);
    String? result = await _get(RequestApi.searchLabelHot, {});
    // Loading.dismiss(Global.mainContext);
    if(result != null){
      return jsonDecode(result);
    }
    return Map<String, dynamic>();
  }
  static Future<Map<String, dynamic>> searchMovie(String text)async{
    Loading.show();
    String? result = await _get(RequestApi.searchMovie.replaceAll('{text}', text), {});
    if(result != null){
      return jsonDecode(result);
    }
    return Map<String, dynamic>();
  }
  static Future<Map<String, dynamic>> searchResult(String id, {int page=1, bool showLoading=false})async{
    if(showLoading) Loading.show();
    String? result = await _get(RequestApi.searchResult.replaceAll('{page}', '$page').replaceAll('{id}', id), {});

    if(result != null){
      return jsonDecode(result);
    }
    return Map<String, dynamic>();
  }

  static Future<void> searchMovieCancel(String id)async{
   await _get(RequestApi.searchMovieCancel.replaceAll('{id}', id), {});
  }

  static Future<Map<String, dynamic>> videoPlayer(int id)async{
    String? result = await _get(RequestApi.videoPlayer.replaceAll('{id}', '$id'), {});
    if(result != null){
      return jsonDecode(result);
    }
    return Map<String, dynamic>();
  }
  static Future<Map<String, dynamic>> videoComments(int id, {int page = 1})async{
    // Loading.show();
    String? result = await _get(RequestApi.videoComments.replaceAll('{page}', '$page').replaceAll('{id}', '$id'), {});
    if(result != null){
      return jsonDecode(result);
    }
    return Map<String, dynamic>();
  }
  static Future<bool> videoCommentDelete(int id)async{
    Loading.show();
    String? result = await _get(RequestApi.videoCommentDelete.replaceAll('{id}', '$id'), {});
    if(result != null){
      Map<String, dynamic> map = jsonDecode(result);
      if(map['error'] != null){
        if(map['error'] == 'login'){
          Global.loginPage();
        }
      }
      if(map['delete'] != null) return map['delete'];
    }
    return false;
  }
  static Future<bool> videoCommentLike(int id)async{
    Loading.show();
    String? result = await _get(RequestApi.videoCommentLike.replaceAll('{id}', '$id'), {});
    if(result != null){
      Map<String, dynamic> map = jsonDecode(result);
      if(map['error'] != null){
        if(map['error'] == 'login'){
          Global.loginPage();
        }
      }
      if(map['like'] != null) return map['like'];
    }
    return false;
  }
  static Future<bool> videoComment(int id, String text, {int toId = 0, int seek = 0})async{
    Loading.show();
    String? result = await _post(RequestApi.videoComment, {'id': id, 'text': text, 'toId': toId, 'seek': seek});
    // Loading.dismiss();
    // print(result);
    if(result != null){
      Map<String, dynamic> map = jsonDecode(result);
      if(map['error'] != null && map['error'] == 'login'){
        Global.loginPage();
      }else{
        if(map['state'] == 'ok'){
          return true;
        }
      }
    }
    return false;
  }
  static Future<Map<String, dynamic>> videoShare(int id)async{
    String? result = await _get(RequestApi.videoShare.replaceAll('{id}', '$id'), {});
    if(result != null){
      return jsonDecode(result);
    }
    return Map<String, dynamic>();
  }
  static Future<Map<String, dynamic>> videoAnytime()async{
    String? result = await _get(RequestApi.videoAnytime, {});
    if(result != null){
      return jsonDecode(result);
    }
    return Map<String, dynamic>();
  }
  static Future<bool> videoLike(int id)async{
    Loading.show();
    String? result = await _get(RequestApi.videoLike.replaceAll('{id}', '$id'), {});
    // Loading.dismiss();
    if(result != null && jsonDecode(result)['like'] != null){
      return jsonDecode(result)['like'];
    }
    return false;
  }
  static Future<void> videoHeartbeat(int id, int seek)async{
    await _post(RequestApi.videoHeartbeat, {'id': id, 'seek': seek});
  }

  static Future<Map<String, dynamic>> videoConcentrations()async{
    // Loading.show();
    String? result = await _get(RequestApi.videoConcentrations, {});
    if(result != null){
      return jsonDecode(result);
    }
    return Map<String, dynamic>();
  }
  static Future<Map<String, dynamic>> videoConcentrationsAnytime(int id)async{
    Loading.show();
    String? result = await _get(RequestApi.videoConcentrationsAnytime.replaceAll('{id}', '$id'), {});
    if(result != null){
      return jsonDecode(result);
    }
    return Map<String, dynamic>();
  }
  static Future<Map<String, dynamic>> videoConcentration(int id,{int page=1})async{
    // Loading.show();
    String? result = await _get(RequestApi.videoConcentration.replaceAll('{id}', '$id').replaceAll('{page}', '$page'), {});
    if(result != null){
      return jsonDecode(result);
    }
    return Map<String, dynamic>();
  }
  static Future<Map<String, dynamic>> videoMembership(int page)async{
    // Loading.show();
    String? result = await _get(RequestApi.videoMembership.replaceAll('{page}', '$page'), {});
    if(result != null){
      return jsonDecode(result);
    }
    return Map<String, dynamic>();
  }
  static Future<Map<String, dynamic>> videoDiamond(int page)async{
    // Loading.show();
    String? result = await _get(RequestApi.videoDiamond.replaceAll('{page}', '$page'), {});
    if(result != null){
      return jsonDecode(result);
    }
    return Map<String, dynamic>();
  }
  static Future<Map<String, dynamic>> videoRank({int first=0,int second=0})async{
    // Loading.show();
    String? result = await _get(RequestApi.videoRank.replaceAll('{first}', '$first').replaceAll('{second}', '$second'), {});
    if(result != null){
      return jsonDecode(result);
    }
    return Map<String, dynamic>();
  }
  static Future<bool> shortVideoUpload(String filePath, String imagePath,
      {int duration=0, String text=''})async{
    String? fp;
    String? ip;
    if(!filePath.startsWith('http')){
      fp = filePath;
    }
    if(!imagePath.startsWith('http')){
      ip = imagePath;
    }
    Loading.show();
    Map<String, dynamic> data = {
      "filePath": filePath,
      "imagePath": imagePath,
      "text": text,
      "duration": duration,
      "files": jsonEncode({
        "filePath": fp?? filePath,
        "imagePath": ip?? imagePath,
        'ossConfig': MinioUtil.config
      }),
    };
    String? result = await _post(RequestApi.shortVideoUpload, data);
    // print(result);
    if(result != null) {
      Map<String,dynamic> map = jsonDecode(result);
      // print(map['upload'] == true);
      // print(map['upload']);
      if(map['upload'] != null) return map['upload'];
    }
    return false;
  }
}