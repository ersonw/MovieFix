import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:movie_fix/Page/LoginPage.dart';
import 'package:movie_fix/data/OssConfig.dart';
import 'package:movie_fix/data/User.dart';
import '../tools/CustomDialog.dart';
import '../tools/RequestApi.dart';
import '../Global.dart';
import 'CustomRoute.dart';
import 'Loading.dart';
import 'MessageUtil.dart';
import 'MinioUtil.dart';
class Request {
  static late Dio _dio;
  static init() {
    _dio = Dio(_getOptions());
    configModel.addListener(() {
      _dio.options.baseUrl =  _getDomain();
    });
    userModel.addListener(() {
      _dio.options.headers['Token'] = userModel.hasToken() ? userModel.user.token : '';
    });
  }
  static _getDomain(){
    if(kIsWeb==true && Global.isRelease) return '';
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
      connectTimeout: 300000,
      receiveTimeout: 300000,
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
        receiveTimeout: 300000,
      ));
      Loading.dismiss();
      if(response.statusCode == 200 && response.data != null){
        // print(response.data);
        Map<String, dynamic> data = response.data;
        if(data['message'] != null && data['message'] !='') {
          CustomDialog.message(data['message']);
          // print(path);
        }
        if(data['code'] == 200 && data['data'] != null){
          // print(data['data']);
          return Global.decryptCode(data['data']);
        }else if(data['code'] == 201){
          userModel.setToken('');
          if(Global.initMain) await Navigator.push(Global.mainContext, SlideRightRoute(page: const LoginPage()));
          // print(userModel.hasToken());
          if(userModel.hasToken() == false){
            tableChangeNotifier.index = 0;
          }
        }else{
          // throw '$path   ${data['code']}';
        }
      }
    } on DioError catch(e) {
      Loading.dismiss();
      print(e.message);
      // print('${e.requestOptions.baseUrl}${e.requestOptions.path}');
      // print(e.requestOptions.data ?? e.requestOptions.queryParameters);
      // print(e);
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
        receiveTimeout: 300000,
      ));
      Loading.dismiss();
      if(response.statusCode == 200 && response.data != null){
        Map<String, dynamic> data = response.data;
        // print(data);
        if(data['message'] != null && data['message'] !='') CustomDialog.message(data['message']);
        if(data['code'] == 200 && data['data'] != null){
          return Global.decryptCode(data['data']);
        }else if(data['code'] == 201){
          // print(path);
          userModel.setToken('');
          if(Global.initMain) await Navigator.push(Global.mainContext, SlideRightRoute(page: const LoginPage()));
          // print(userModel.hasToken());
          if(userModel.hasToken() == false){
            tableChangeNotifier.index = 0;
          }
        }
      }
    } on DioError catch(e) {
      Loading.dismiss();
      print(e.message);
      // print('${e.requestOptions.baseUrl}${e.requestOptions.path}');
      // print(e.requestOptions.data ?? e.requestOptions.queryParameters);
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

  static Future<Map<String, dynamic>> getConfig()async{
    String? result = await _get(RequestApi.config,{});
    if(result!=null){
      Map<String, dynamic> map = jsonDecode(result);
      return map;
    }
    return {};
  }
  static Future<Map<String, dynamic>> videoClass()async{
    String? result = await _get(RequestApi.videoClass,{});
    if(result!=null){
      Map<String, dynamic> map = jsonDecode(result);
      return map;
    }
    return {};
  }
  static Future<Map<String, dynamic>> videoClassList({int id=0, int page=1})async{
    String? result = await _get(RequestApi.videoClassList.replaceAll('{id}', '$id').replaceAll('{page}', '$page'),{});
    if(result!=null){
      Map<String, dynamic> map = jsonDecode(result);
      return map;
    }
    return {};
  }
  static Future<bool> invitation(String code)async{
    String? result = await _post(RequestApi.invitation,{ code: code });
    if(result!=null){
      Map<String, dynamic> map = jsonDecode(result);
      return map['state'] == true;
    }
    return false;
  }
  static Future<bool> channel(String code)async{
    String? result = await _post(RequestApi.channel,{ code: code });
    if(result!=null){
      Map<String, dynamic> map = jsonDecode(result);
      return map['state'] == true;
    }
    return false;
  }
  static Future<void> checkDeviceId()async{
    String? result = await _get(RequestApi.checkDeviceId.replaceAll('{deviceId}', Global.deviceId!),{});
    // print(result);
    if(result!=null){
      Map<String, dynamic> map = jsonDecode(result);
      // print(Global.deviceId);
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
  static Future<bool> userLogout()async{
    Loading.show();
    await _get(RequestApi.userLogout, {});
    // MessageUtil.reconnect();
    return true;
  }
  static Future<String?> userLoginSms(String phone)async{
    Loading.show();
    String? result = await _get(RequestApi.userLoginSms.replaceAll('{phone}', phone),{});

    if(result!=null){
      Map<String, dynamic> map = jsonDecode(result);
      return map['id'];
    }
    return null;
  }
  static Future<bool> userLoginPhone(String codeId,String code)async{
    String deviceId = Global.deviceId ?? 'unknown';
    String platform = Global.platform ?? 'Html5';
    Map<String, dynamic> data = {
      "deviceId": deviceId,
      "platform": platform,
      "codeId": codeId,
      "code": code
    };
    Loading.show();
    String? result = await _post(RequestApi.userLoginPhone, data);
    if(result!=null){
      Map<String, dynamic> map = jsonDecode(result);
      if(map['token'] != null) {
        // userModel.setToken(map['token']);
        userModel.user = User.formJson(map);
        MessageUtil.pause = false;
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
      return map['id'];
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
  static Future<bool> videoBuy(int id)async{
    Loading.show();
    String? result = await _get(RequestApi.videoBuy.replaceAll('{id}', '$id'), {});
    // Loading.dismiss();
    if(result != null && jsonDecode(result)['state'] != null){
      return true;
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
  static Future<bool> shortVideoUploadConfig()async{
    Loading.show();
    String? result = await _get(RequestApi.shortVideoUploadConfig, {});
    if(result != null){
      // print(result);
      Map<String, dynamic> map = jsonDecode(result);
      OssConfig config = OssConfig.fromJson(map);
      MinioUtil.config = config;
      MinioUtil.init();
      return true;
    }
    return false;
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
  static Future<Map<String, dynamic>> shortVideoFriend({int id=0,int page=0})async{
    // Loading.show();
    String? result = await _get(RequestApi.shortVideoFriend.replaceAll('{id}', '$id').replaceAll('{page}', '$page'), {});
    if(result != null){
      return jsonDecode(result);
    }
    return Map<String, dynamic>();
  }
  static Future<void> shortVideoHeartbeat(int id, int seek)async{
    await _post(RequestApi.shortVideoHeartbeat, {'id': id, 'seek': seek});
  }
  static Future<Map<String, dynamic>> shortVideoConcentration({int page=0})async{
    // Loading.show();
    String? result = await _get(RequestApi.shortVideoConcentration.replaceAll('{page}', '$page'), {});
    if(result != null){
      return jsonDecode(result);
    }
    return Map<String, dynamic>();
  }
  static Future<bool> shortVideoLike(int id)async{
    // Loading.show();
    String? result = await _get(RequestApi.shortVideoLike.replaceAll('{id}', '$id'), {});
    if(result != null){
      return jsonDecode(result)['state'];
    }
    return false;
  }
  static Future<bool> shortVideoUnlike(int id)async{
    // Loading.show();
    String? result = await _get(RequestApi.shortVideoUnlike.replaceAll('{id}', '$id'), {});
    // print(result);
    if(result != null){
      return jsonDecode(result)['state'];
    }
    return false;
  }
  static Future<bool> shortVideoFollow(int id)async{
    // Loading.show();
    String? result = await _get(RequestApi.shortVideoFollow.replaceAll('{id}', '$id'), {});
    // print(result);
    if(result != null){
      return jsonDecode(result)['state'];
    }
    return false;
  }
  static Future<bool> shortVideoUnfollow(int id)async{
    // Loading.show();
    String? result = await _get(RequestApi.shortVideoUnfollow.replaceAll('{id}', '$id'), {});
    // print(result);
    if(result != null){
      return jsonDecode(result)['state'];
    }
    return false;
  }

  static Future<Map<String, dynamic>> shortVideoComments(int id,{int page=0})async{
    // Loading.show();
    String? result = await _get(RequestApi.shortVideoComments.replaceAll('{id}', '$id').replaceAll('{page}', '$page'), {});
    if(result != null){
      return jsonDecode(result);
    }
    return Map<String, dynamic>();
  }
  static Future<Map<String, dynamic>> shortVideoCommentChildren(int id,{int page=0})async{
    // Loading.show();
    String? result = await _get(RequestApi.shortVideoCommentChildren.replaceAll('{id}', '$id').replaceAll('{page}', '$page'), {});
    if(result != null){
      return jsonDecode(result);
    }
    return Map<String, dynamic>();
  }
  static Future<Map<String, dynamic>> shortVideoComment(int videoId,String text, {int toId=0})async{
    Loading.show();
    Map<String, dynamic> data = {
      'id': videoId,
      'text': text,
      'toId': toId,
    };
    String? result = await _post(RequestApi.shortVideoComment, data);
    // print(result);
    if(result != null){
      return jsonDecode(result);
    }
    return {};
  }
  static Future<bool> shortVideoCommentLike(int id)async{
    Loading.show();
    String? result = await _get(RequestApi.shortVideoCommentLike.replaceAll('{id}', '$id'), {});
    if(result != null){
      return jsonDecode(result)['state'];
    }
    return false;
  }
  static Future<bool> shortVideoCommentUnlike(int id)async{
    Loading.show();
    String? result = await _get(RequestApi.shortVideoCommentUnlike.replaceAll('{id}', '$id'), {});
    if(result != null){
      return jsonDecode(result)['state'];
    }
    return false;
  }
  static Future<bool> shortVideoCommentDelete(int id)async{
    Loading.show();
    String? result = await _get(RequestApi.shortVideoCommentDelete.replaceAll('{id}', '$id'), {});
    if(result != null){
      return jsonDecode(result)['state'];
    }
    return false;
  }
  static Future<bool> shortVideoCommentReport(int id)async{
    Loading.show();
    String? result = await _get(RequestApi.shortVideoCommentReport.replaceAll('{id}', '$id'), {});
    if(result != null){
      return jsonDecode(result)['state'];
    }
    return false;
  }
  static Future<bool> shortVideoCommentPin(int id)async{
    Loading.show();
    String? result = await _get(RequestApi.shortVideoCommentPin.replaceAll('{id}', '$id'), {});
    if(result != null){
      return jsonDecode(result)['state'];
    }
    return false;
  }
  static Future<bool> shortVideoCommentUnpin(int id)async{
    Loading.show();
    String? result = await _get(RequestApi.shortVideoCommentUnpin.replaceAll('{id}', '$id'), {});
    if(result != null){
      return jsonDecode(result)['state'];
    }
    return false;
  }
  static Future<Map<String, dynamic>> gameScroll()async{
    // Loading.show();
    String? result = await _get(RequestApi.gameScroll, {});
    if(result != null){
      return jsonDecode(result);
    }
    return Map<String, dynamic>();
  }
  static Future<double> gameBalance()async{
    // Loading.show();
    String? result = await _get(RequestApi.gameBalance, {});
    if(result != null && jsonDecode(result)['balance'] != null){
      return jsonDecode(result)['balance'];
    }
    return 0.00;
  }
  static Future<String> getService()async{
    // Loading.show();
    String? result = await _get(RequestApi.getService, {});
    if(result != null && jsonDecode(result)['service'] != null){
      return jsonDecode(result)['service'];
    }
    return '';
  }
  static Future<Map<String, dynamic>> gamePublicity()async{
    // Loading.show();
    String? result = await _get(RequestApi.gamePublicity, {});
    if(result != null){
      return jsonDecode(result);
    }
    return Map<String, dynamic>();
  }
  static Future<void> gamePublicityReport({int id=0})async{
    await _get(RequestApi.gamePublicityReport.replaceAll('{id}', '$id'), {});
  }
  static Future<Map<String, dynamic>> videoPublicity()async{
    // Loading.show();
    String? result = await _get(RequestApi.videoPublicity, {});
    if(result != null){
      return jsonDecode(result);
    }
    return Map<String, dynamic>();
  }
  static Future<void> videoPublicityReport({int id=0})async{
    await _get(RequestApi.videoPublicityReport.replaceAll('{id}', '$id'), {});
  }
  static Future<void> videoPlayerPublicityReport({int id=0})async{
    await _get(RequestApi.videoPlayerPublicityReport.replaceAll('{id}', '$id'), {});
  }
  static Future<Map<String, dynamic>> gameList()async{
    // Loading.show();
    String? result = await _get(RequestApi.gameList, {});
    if(result != null){
      return jsonDecode(result);
    }
    return Map<String, dynamic>();
  }
  static Future<Map<String, dynamic>> gameRecords()async{
    // Loading.show();
    String? result = await _get(RequestApi.gameRecords, {});
    if(result != null){
      return jsonDecode(result);
    }
    return Map<String, dynamic>();
  }
  static Future<String?> gameEnter({int id=0})async{
    Loading.show();
    String? result = await _post(RequestApi.gameEnter, {'id': id});
    // print(result);
    if(result != null && jsonDecode(result)['gameUrl'] != null){
      return jsonDecode(result)['gameUrl'];
    }
    return null;
  }
  static Future<void> gameTest()async{
    await _get(RequestApi.gameTest, {});
  }
  static Future<Map<String, dynamic>> gameButtons()async{
    // Loading.show();
    String? result = await _get(RequestApi.gameButtons, {});
    // print(result);
    if(result != null){
      return jsonDecode(result);
    }
    return Map<String, dynamic>();
  }
  static Future<Map<String, dynamic>> gameButton({int id=0})async{
    // Loading.show();
    String? result = await _get(RequestApi.gameButton.replaceAll('{id}', '$id'), {});
    // print(result);
    if(result != null){
      return jsonDecode(result);
    }
    return Map<String, dynamic>();
  }
  static Future<String?> gamePayment( {int id=0,int toId=0})async{
    Loading.show();
    Map<String, dynamic> data = {
      'id': id,
      'toId': toId,
    };
    String? result = await _post(RequestApi.gamePayment, data);
    // print(result);
    if(result != null && jsonDecode(result)['url'] != null){
      return jsonDecode(result)['url'];
    }
    return null;
  }
  static Future<Map<String, dynamic>> gameOrder({int page=1})async{
    // Loading.show();
    String? result = await _get(RequestApi.gameOrder.replaceAll('{page}', '$page'), {});
    // print(result);
    if(result != null){
      return jsonDecode(result);
    }
    return Map<String, dynamic>();
  }
  static Future<Map<String, dynamic>> gameFunds({int page=1})async{
    // Loading.show();
    String? result = await _get(RequestApi.gameFunds.replaceAll('{page}', '$page'), {});
    // print(result);
    if(result != null){
      return jsonDecode(result);
    }
    return Map<String, dynamic>();
  }
  static Future<Map<String, dynamic>> gameCashOutBalance()async{
    // Loading.show();
    String? result = await _get(RequestApi.gameCashOutBalance, {});
    // print(result);
    if(result != null){
      return jsonDecode(result);
    }
    return Map<String, dynamic>();
  }
  static Future<Map<String, dynamic>> gameCashOutGetConfig()async{
    // Loading.show();
    String? result = await _get(RequestApi.gameCashOutGetConfig, {});
    // print(result);
    if(result != null){
      return jsonDecode(result);
    }
    return Map<String, dynamic>();
  }
  static Future<Map<String, dynamic>> gameCashOutGetCards({int page=1})async{
    // Loading.show();
    String? result = await _get(RequestApi.gameCashOutGetCards.replaceAll('{page}', '$page'), {});
    // print(result);
    if(result != null){
      return jsonDecode(result);
    }
    return Map<String, dynamic>();
  }
  static Future<Map<String, dynamic>> gameCashOutEditCard( {int id=0,String name='',String bank='',String card='',String address=''})async{
    Loading.show();
    Map<String, dynamic> data = {
      'id': id,
      'name': name,
      'bank': bank,
      'card': card,
      'address': address,
    };
    String? result = await _post(RequestApi.gameCashOutEditCard, data);
    // print(result);
    if(result != null){
      return jsonDecode(result);
    }
    return {};
  }
  static Future<bool> gameCashOutSetDefault( {int id=0})async{
    Loading.show();
    String? result = await _get(RequestApi.gameCashOutSetDefault.replaceAll('{id}', '$id'), {});
    // print(result);
    if(result != null && jsonDecode(result)['state'] != null){
      return jsonDecode(result)['state'];
    }
    return false;
  }
  static Future<bool> gameCashOutRemoveCard( {int id=0})async{
    Loading.show();
    String? result = await _get(RequestApi.gameCashOutRemoveCard.replaceAll('{id}', '$id'), {});
    // print(result);
    if(result != null && jsonDecode(result)['state'] != null){
      return jsonDecode(result)['state'];
    }
    return false;
  }
  static Future<Map<String, dynamic>> gameCashOutAddCard( {String name='',String bank='',String card='',String address=''})async{
    Loading.show();
    Map<String, dynamic> data = {
      'name': name,
      'bank': bank,
      'card': card,
      'address': address,
    };
    String? result = await _post(RequestApi.gameCashOutAddCard, data);
    // print(result);
    if(result != null){
      return jsonDecode(result);
    }
    return {};
  }
  static Future<bool> gameCashOut( {int id=0, int amount=0})async{
    Loading.show();
    Map<String, dynamic> data = {
      'id': id,
      'amount': amount,
    };
    String? result = await _post(RequestApi.gameCashOut, data);
    // print(result);
    if(result != null && jsonDecode(result)['state'] != null){
      return jsonDecode(result)['state'];
    }
    return false;
  }
  static Future<Map<String, dynamic>> gameCashOutRecords({int page=1})async{
    // Loading.show();
    String? result = await _get(RequestApi.gameCashOutRecords.replaceAll('{page}', '$page'), {});
    // print(result);
    if(result != null){
      return jsonDecode(result);
    }
    return Map<String, dynamic>();
  }
  static Future<Map<String, dynamic>> userProfileVideo({int page=1,int id=0})async{
    // Loading.show();
    String url = RequestApi.userProfileVideo.replaceAll('{page}', '$page').replaceAll('{id}', '$id');
    // print(url);
    // print(configModel.config.mainDomain);
    String? result = await _get(url, {});
    // print(result);
    if(result != null){
      return jsonDecode(result);
    }
    return Map<String, dynamic>();
  }
  static Future<Map<String, dynamic>> userProfileVideoLike({int page=1,int id=0})async{
    // Loading.show();
    String url = RequestApi.userProfileVideo.replaceAll('{page}', '$page').replaceAll('{id}', '$id');
    url = '$url/like';
    String? result = await _get(url, {});
    // print(url);
    if(result != null){
      return jsonDecode(result);
    }
    return Map<String, dynamic>();
  }
  static Future<Map<String, dynamic>> userProfile({int id=0})async{
    // Loading.show();
    String? result = await _get(RequestApi.userProfile.replaceAll('{id}', '$id'), {});
    // print(result);
    if(result != null){
      return jsonDecode(result);
    }
    return Map<String, dynamic>();
  }
  static Future<Map<String, dynamic>> userMyProfileVideo({int page=0})async{
    // Loading.show();
    String? result = await _get(RequestApi.userMyProfileVideo.replaceAll('{page}', '$page'), {});
    // print(result);
    if(result != null){
      return jsonDecode(result);
    }
    return Map<String, dynamic>();
  }
  static Future<Map<String, dynamic>> userShareConfig()async{
    // Loading.show();
    String? result = await _get(RequestApi.userShareConfig, {});
    // print(result);
    if(result != null){
      return jsonDecode(result);
    }
    return {};
  }
  static Future<bool> userShareReceive({String version='v1'})async{
    // Loading.show();
    String? result = await _get(RequestApi.userShareReceive+version, {});
    // print(result);
    if(result != null && jsonDecode(result)['state'] != null){
      return jsonDecode(result)['state'];
    }
    return false;
  }
  static Future<Map<String, dynamic>> userMyProfileVideoLike({int page=0})async{
    // Loading.show();
    String url = RequestApi.userMyProfileVideo.replaceAll('{page}', '$page');
    url = '$url/like';
    String? result = await _get(url, {});
    // print(result);
    if(result != null){
      return jsonDecode(result);
    }
    return Map<String, dynamic>();
  }
  static Future<Map<String, dynamic>> userMyProfile()async{
    // Loading.show();
    String? result = await _get(RequestApi.userMyProfile, {});
    // print(result);
    if(result != null){
      return jsonDecode(result);
    }
    return Map<String, dynamic>();
  }
  static Future<Map<String, dynamic>> userMyFollow({int page=1})async{
    // Loading.show();
    String? result = await _get(RequestApi.userMyFollow.replaceAll('{page}', '$page'), {});
    // print(result);
    if(result != null){
      return jsonDecode(result);
    }
    return Map<String, dynamic>();
  }
  static Future<Map<String, dynamic>> userMyFans({int page=1})async{
    // Loading.show();
    String? result = await _get(RequestApi.userMyFans.replaceAll('{page}', '$page'), {});
    // print(result);
    if(result != null){
      return jsonDecode(result);
    }
    return Map<String, dynamic>();
  }
  static Future<Map<String, dynamic>> userFollow({int page=1,int id=0,String text=''})async{
    // Loading.show();
    String url = RequestApi.userFollow.replaceAll('{id}', '$id').replaceAll('{page}', '$page');
    if(text.isNotEmpty) url = '$url/$text';
    String? result = await _get(url, {});
    // print(result);
    if(result != null){
      return jsonDecode(result);
    }
    return Map<String, dynamic>();
  }
  static Future<Map<String, dynamic>> userFans({int page=1,int id=0,String text=''})async{
    // Loading.show();
    String url = RequestApi.userFans.replaceAll('{id}', '$id').replaceAll('{page}', '$page');
    if(text.isNotEmpty) url = '$url/$text';
    String? result = await _get(url, {});
    // print(result);
    if(result != null){
      return jsonDecode(result);
    }
    return Map<String, dynamic>();
  }
  static Future<Map<String, dynamic>> myProfile()async{
    // Loading.show();
    String url = RequestApi.myProfile;
    // if(text.isNotEmpty) url = '$url/$text';
    String? result = await _get(url, {});
    // print(result);
    if(result != null){
      return jsonDecode(result);
    }
    return Map<String, dynamic>();
  }
  static Future<Map<String, dynamic>> myProfileEdit({Map<String, dynamic>? data})async{
    String url = RequestApi.myProfileEdit;
    String? result;
    if(data != null){
      Loading.show();
      result = await _post(url, data);
    }else{
      result = await _get(url, {});
    }
    // print(result);
    if(result != null){
      return jsonDecode(result);
    }
    return Map<String, dynamic>();
  }
  static Future<Map<String, dynamic>> myProfileEditAvatar(String path)async{
    // Loading.show();
    String url = RequestApi.myProfileEditAvatar;
    String? result = await _post(url, {'imagePath': path, 'oss': jsonEncode(MinioUtil.config)});
    // print(result);
    if(result != null){
      return jsonDecode(result);
    }
    return Map<String, dynamic>();
  }
  static Future<String?> myProfileEditPhoneSms(String phone)async{
    // Loading.show();
    String url = RequestApi.myProfileEditPhoneSms.replaceAll('{phone}', phone);
    // if(text.isNotEmpty) url = '$url/$text';
    String? result = await _get(url, {});
    // print(result);
    if(result != null){
      return jsonDecode(result)['id'];
    }
    return null;
  }
  static Future<bool> myProfileEditPhone({String codeId='',String code=''})async{
    Loading.show();
    String url = RequestApi.myProfileEditPhone;
    String? result = await _post(url, {'codeId': codeId, 'code': code});
    // print(result);
    if(result != null){
      return jsonDecode(result)['username'] != null;
    }
    return false;
  }
  static Future<String?> myProfileEditRestPasswordSms()async{
    // Loading.show();
    String url = RequestApi.myProfileEditRestPasswordSms;
    // if(text.isNotEmpty) url = '$url/$text';
    String? result = await _get(url, {});
    // print(result);
    if(result != null){
      return jsonDecode(result)['id'];
    }
    return null;
  }
  static Future<String?> myProfileBindPhoneSms(String phone)async{
    // Loading.show();
    String url = RequestApi.myProfileBindPhoneSms;
    // if(text.isNotEmpty) url = '$url/$text';
    String? result = await _post(url, { 'phone': phone});
    // print(result);
    if(result != null){
      return jsonDecode(result)['id'];
    }
    return null;
  }
  static Future<Map<String, dynamic>> myProfileBindPhone({String codeId='',String code='', String phone = '', int force = 0})async{
    // Loading.show();
    String url = RequestApi.myProfileBindPhone;
    // if(text.isNotEmpty) url = '$url/$text';
    Map<String, dynamic> data = {'codeId': codeId, 'code': code, 'phone': phone, 'toId': force};
    String? result = await _post(url, data);
    // print(result);
    if(result != null){
      return jsonDecode(result);
    }
    return {};
  }
  static Future<String?> myProfileEditRestPasswordVerify({String codeId='',String code=''})async{
    Loading.show();
    String url = RequestApi.myProfileEditRestPasswordVerify;
    String? result = await _post(url, {'codeId': codeId, 'code': code});
    // print(result);
    if(result != null){
      return jsonDecode(result)['salt'];
    }
    return null;
  }
  static Future<String?> myProfileEditChangePasswordVerify(String password)async{
    Loading.show();
    String url = RequestApi.myProfileEditChangePasswordVerify;
    String? result = await _post(url, {'password': Global.generateMd5(password)});
    // print(result);
    if(result != null){
      return jsonDecode(result)['salt'];
    }
    return null;
  }
  static Future<bool> myProfileEditRestPassword({String password='',String salt=''})async{
    Loading.show();
    String url = RequestApi.myProfileEditRestPassword;
    String? result = await _post(url, {'password': Global.generateMd5(password), 'salt': salt});
    // print(result);
    if(result != null){
      return jsonDecode(result)['state'];
    }
    return false;
  }

  static Future<int> diamondBalance()async{
    // Loading.show();
    String url = RequestApi.diamondBalance;
    String? result = await _get(url, {});
    // print(result);
    if(result != null){
      Map<String, dynamic> map = jsonDecode(result);
      if(map['balance'] != null){
        return map['balance'];
      }
    }
    return 0;
  }
  static Future<Map<String, dynamic>> diamondButtons()async{
    // Loading.show();
    String url = RequestApi.diamondButtons;
    String? result = await _get(url, {});
    // print(result);
    if(result != null){
      return jsonDecode(result);
    }
    return Map<String, dynamic>();
  }
  static Future<Map<String, dynamic>> diamondButton({int id=0})async{
    // Loading.show();
    String url = RequestApi.diamondButton.replaceAll('{id}', '$id');
    String? result = await _get(url, {});
    // print(result);
    if(result != null){
      return jsonDecode(result);
    }
    return Map<String, dynamic>();
  }
  static Future<String?> diamondPayment( {int id=0,int toId=0})async{
    Loading.show();
    Map<String, dynamic> data = {
      'id': id,
      'toId': toId,
    };
    String? result = await _post(RequestApi.diamondPayment, data);
    // print(result);
    if(result != null && jsonDecode(result)['url'] != null){
      return jsonDecode(result)['url'];
    }
    return null;
  }
  static Future<Map<String, dynamic>> diamondOrder({int page=1})async{
    // Loading.show();
    String? result = await _get(RequestApi.diamondOrder.replaceAll('{page}', '$page'), {});
    // print(result);
    if(result != null){
      return jsonDecode(result);
    }
    return Map<String, dynamic>();
  }
  static Future<Map<String, dynamic>> diamondFunds({int page=1})async{
    // Loading.show();
    String? result = await _get(RequestApi.diamondFunds.replaceAll('{page}', '$page'), {});
    // print(result);
    if(result != null){
      return jsonDecode(result);
    }
    return Map<String, dynamic>();
  }

  static Future<int> coinBalance()async{
    // Loading.show();
    String url = RequestApi.coinBalance;
    String? result = await _get(url, {});
    // print(result);
    if(result != null){
      Map<String, dynamic> map = jsonDecode(result);
      if(map['balance'] != null){
        return map['balance'];
      }
    }
    return 0;
  }
  static Future<Map<String, dynamic>> coinButtons()async{
    // Loading.show();
    String url = RequestApi.coinButtons;
    String? result = await _get(url, {});
    // print(result);
    if(result != null){
      return jsonDecode(result);
    }
    return Map<String, dynamic>();
  }
  static Future<Map<String, dynamic>> coinButton({int id=0})async{
    // Loading.show();
    String url = RequestApi.coinButton.replaceAll('{id}', '$id');
    String? result = await _get(url, {});
    // print(result);
    if(result != null){
      return jsonDecode(result);
    }
    return Map<String, dynamic>();
  }
  static Future<String?> coinPayment( {int id=0,int toId=0})async{
    Loading.show();
    Map<String, dynamic> data = {
      'id': id,
      'toId': toId,
    };
    String? result = await _post(RequestApi.coinPayment, data);
    // print(result);
    if(result != null && jsonDecode(result)['url'] != null){
      return jsonDecode(result)['url'];
    }
    return null;
  }
  static Future<Map<String, dynamic>> coinOrder({int page=1})async{
    // Loading.show();
    String? result = await _get(RequestApi.coinOrder.replaceAll('{page}', '$page'), {});
    // print(result);
    if(result != null){
      return jsonDecode(result);
    }
    return Map<String, dynamic>();
  }
  static Future<Map<String, dynamic>> coinFunds({int page=1})async{
    // Loading.show();
    String? result = await _get(RequestApi.coinFunds.replaceAll('{page}', '$page'), {});
    // print(result);
    if(result != null){
      return jsonDecode(result);
    }
    return Map<String, dynamic>();
  }

  static Future<double> cashBalance()async{
    // Loading.show();
    String url = RequestApi.cashBalance;
    String? result = await _get(url, {});
    // print(result);
    if(result != null){
      Map<String, dynamic> map = jsonDecode(result);
      if(map['balance'] != null){
        return map['balance'];
      }
    }
    return 0.00;
  }
  static Future<Map<String, dynamic>> cashButtons()async{
    // Loading.show();
    String url = RequestApi.cashButtons;
    String? result = await _get(url, {});
    // print(result);
    if(result != null){
      return jsonDecode(result);
    }
    return Map<String, dynamic>();
  }
  static Future<Map<String, dynamic>> cashButton({int id=0})async{
    // Loading.show();
    String url = RequestApi.cashButton.replaceAll('{id}', '$id');
    String? result = await _get(url, {});
    // print(result);
    if(result != null){
      return jsonDecode(result);
    }
    return Map<String, dynamic>();
  }
  static Future<String?> cashPayment( {int id=0,int toId=0})async{
    Loading.show();
    Map<String, dynamic> data = {
      'id': id,
      'toId': toId,
    };
    String? result = await _post(RequestApi.cashPayment, data);
    // print(result);
    if(result != null && jsonDecode(result)['url'] != null){
      return jsonDecode(result)['url'];
    }
    return null;
  }
  static Future<Map<String, dynamic>> cashOrder({int page=1})async{
    // Loading.show();
    String? result = await _get(RequestApi.cashOrder.replaceAll('{page}', '$page'), {});
    // print(result);
    if(result != null){
      return jsonDecode(result);
    }
    return Map<String, dynamic>();
  }
  static Future<Map<String, dynamic>> cashFunds({int page=1})async{
    // Loading.show();
    String? result = await _get(RequestApi.cashFunds.replaceAll('{page}', '$page'), {});
    // print(result);
    if(result != null){
      return jsonDecode(result);
    }
    return Map<String, dynamic>();
  }

  static Future<Map<String, dynamic>> membershipInfo()async{
    // Loading.show();
    String url = RequestApi.membershipInfo;
    String? result = await _get(url, {});
    // print(result);
    if(result != null){
      return jsonDecode(result);
    }
    return {};
  }
  static Future<Map<String, dynamic>> membershipButtons()async{
    // Loading.show();
    String url = RequestApi.membershipButtons;
    String? result = await _get(url, {});
    // print(result);
    if(result != null){
      return jsonDecode(result);
    }
    return Map<String, dynamic>();
  }
  static Future<Map<String, dynamic>> membershipButton({int id=0})async{
    // Loading.show();
    String url = RequestApi.membershipButton.replaceAll('{id}', '$id');
    String? result = await _get(url, {});
    // print(result);
    if(result != null){
      return jsonDecode(result);
    }
    return Map<String, dynamic>();
  }
  static Future<String?> membershipPayment( {int id=0,int toId=0})async{
    Loading.show();
    Map<String, dynamic> data = {
      'id': id,
      'toId': toId,
    };
    String? result = await _post(RequestApi.membershipPayment, data);
    // print(result);
    if(result != null && jsonDecode(result)['url'] != null){
      return jsonDecode(result)['url'];
    }
    return null;
  }
  static Future<Map<String, dynamic>> membershipOrder({int page=1})async{
    // Loading.show();
    String? result = await _get(RequestApi.membershipOrder.replaceAll('{page}', '$page'), {});
    // print(result);
    if(result != null){
      return jsonDecode(result);
    }
    return Map<String, dynamic>();
  }
  static Future<Map<String, dynamic>> membershipFunds({int page=1})async{
    // Loading.show();
    String? result = await _get(RequestApi.membershipFunds.replaceAll('{page}', '$page'), {});
    // print(result);
    if(result != null){
      return jsonDecode(result);
    }
    return Map<String, dynamic>();
  }
}
