import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:device_info/device_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
// import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:movie_fix/Module/cToast.dart';
import 'package:movie_fix/tools/MinioUtil.dart';
import 'Page/ShareVideoPage.dart';
import 'tools/MessageUtil.dart';
import 'Model/ConfigModel.dart';
import 'Model/GeneralModel.dart';
import 'Model/UserModel.dart';
import 'MyApp.dart';
import 'Page/LoginPage.dart';
import 'Page/PlayerPage.dart';
import 'tools/CustomRoute.dart';
import 'tools/Request.dart';
// import 'tools/WebJS.dart';
import 'package:openinstall_flutter_plugin/openinstall_flutter_plugin.dart';
import 'package:package_info/package_info.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

import 'WebViewExample.dart';
import 'data/Profile.dart';
import 'dart:ui' as ui;
import 'package:encrypt/encrypt.dart' as XYQ;
import 'package:crypto/crypto.dart';
import 'package:convert/convert.dart';

final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();
final GeneralModel generalModel = GeneralModel();
final ConfigModel configModel = ConfigModel();
final UserModel userModel = UserModel();
final OpeninstallFlutterPlugin _openinstallFlutterPlugin = OpeninstallFlutterPlugin();
class Global {
  static bool get isRelease => const bool.fromEnvironment("dart.vm.product");
  static late PackageInfo packageInfo;
  static late SharedPreferences _prefs;
  static late BuildContext mainContext;

  static Profile profile = Profile();
  static bool initMain = false;
  static const String mykey = 'cPdS+pz9B640l/4VxWuhzQ==';

  static String? deviceId;
  static String? platform;
  static String? codeInvite;
  static String? channelCode;
  static String? path;

  static Future init() async {
    WidgetsFlutterBinding.ensureInitialized();
    _prefs = await SharedPreferences.getInstance();
    var _profile = _prefs.getString("profile");
    // print(_profile);
    if (_profile != null) {
      profile = Profile.fromJson(jsonDecode(_profile));
    }
    path = await Global.getPhoneLocalPath();
    Request.init();
    if(kIsWeb == false) {
      await requestPhotosPermission();
      deviceId = await getUUID();
      platform = Platform.operatingSystem;
      // print(platform);
      _openinstallFlutterPlugin.init(wakeupHandler);
      _openinstallFlutterPlugin.install(installHandler);
      packageInfo = await PackageInfo.fromPlatform();
      // print(packageInfo.buildNumber);
      if(userModel.hasToken() == false){
        Request.checkDeviceId();
      }
    }else{
      // var queryParameters = WebJs.getUri();
      // if(queryParameters != null){
      //   if(queryParameters['code'] != null) Global.codeInvite = queryParameters['code'];
      //   if(queryParameters['channel'] != null) Global.channelCode = queryParameters['channel'];
      // }
    }
    print('$path');
    MessageUtil.init();
    MinioUtil.init();
    runApp(const MyApp());
  }
  static Future<void> shareVideo(int id) async {
    await Navigator.push(mainContext, DialogRouter(ShareVideoPage(id)));
  }
  static Future<void> loginPage()async{
    await Navigator.push(mainContext, SlideRightRoute(page: const LoginPage()));
  }
  static Future<void> playerPage(int id)async{
    await Navigator.push(mainContext, SlideRightRoute(page: PlayerPage(id)));
  }
  static void openWebview(String data, {bool? inline}){
    Navigator.push(
      mainContext,
      CupertinoPageRoute(
        title: inline== true ? '':'??????????????????????????????!',
        builder: (context) => WebViewExample(url: data, inline: inline,),
      ),
    );
  }
  static Future<void> installHandler(Map<String, dynamic> data) async {
    // print(data['channelCode']);
    // channelCode = '101';
    // if(null != data['bindData']){
    //   Map<String, dynamic> map = jsonDecode(data['bindData']);
    //   if(null != map['code']){
    //     codeInvite = map['code'];
    //     // _handlerInvite();
    //   }
    //   if(null != map['video']){
    //     if(int.tryParse(map['video']) != null){
    //       // playVideo(int.parse(map['video']));
    //     }
    //   }
    // }
    // if(null != data['channelCode'] && data['channelCode'].toString().isNotEmpty){
    //   if(configModel.config.firstTime == true){
    //     await Global.reportOpen(Global.REPORT_OPEN_APP);
    //   }
    //   // if(Platform.isIOS &&  configModel.config.channel == false){
    //   //   Config config = configModel.config;
    //   //   config.channel = true;
    //   //   configModel.config = config;
    //   //   await _init();
    //   //   await initSock();
    //   //   _initJPush();
    //   //   runApp(const MyAdaptingApp());
    //   // }
    //   channelCode = data['channelCode'];
    // }
    // handlerChannel();
  }
  static void handlerChannel() async{
    // if(channelCode == null || channelCode.isEmpty){
    //   return;
    // }
    // if(channelIs){
    //   return;
    // }
    // if(configModel.config.firstTime == true){
    //   await Global.reportOpen(Global.REPORT_FORM_CHANNEL);
    //   Config _config = configModel.config;
    //   _config.firstTime = false;
    //   configModel.config = _config;
    // }
    // Map<String,dynamic> map = {
    //   'code': channelCode
    // };
    // DioManager().request(NWMethod.POST, NWApi.joinChannel,
    //     params: {'data': jsonEncode(map)}, success: (data) {
    //       print("success data = $data");
    //       if (data != null) {
    //         map = jsonDecode(data);
    //         if(map['msg'] != null) showWebColoredToast(map['msg']);
    //         if(map['verify'] != null) channelIs = (map['verify']);
    //       }
    //     }, error: (error) {});
  }
  static Future<void> wakeupHandler(Map<String, dynamic> data) async {
    print(data);
    // if(null != data['bindData']){
    //   Map<String, dynamic> map = jsonDecode(data['bindData']);
    //   if(null != map['code']){
    //     codeInvite = map['code'];
    //     _handlerInvite();
    //   }
    //   if(null != map['video']){
    //     if(int.tryParse(map['video']) != null){
    //       playVideo(int.parse(map['video']));
    //     }
    //   }
    // }
    // if(null != data['channelCode']){
    //   channelCode = (data['channelCode']);
    // }
  }
  static Future<String> getUUID() async {
    String uid = '';
    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    try {
      if (Platform.isAndroid) {
        var build = await deviceInfoPlugin.androidInfo;
        uid = build.androidId;
        // print(uid);
        //UUID for Android
      } else if (Platform.isIOS) {
        var build = await deviceInfoPlugin.iosInfo;
        // List<String> name = [build.];
        print(build.name);
        uid = build.identifierForVendor;
        // uid = await FlutterUdid.udid;
      }else{
        uid = 'test';
      }
      return uid;
    } on PlatformException {
    }
    return uid;
  }
  static saveProfile() => _prefs.setString("profile", jsonEncode(profile.toJson()));
  // static Future<void> saveProfile()async{
  //   if(initMain == false) await init();
  //   _prefs.setString("profile", profile.toString());
  // }
  static String encryptCode(String text){
    final key = XYQ.Key.fromUtf8(mykey);
    // final iv = XYQ.IV.fromUtf8(myiv);
    final iv = XYQ.IV.fromSecureRandom(128);
    final encrypter = XYQ.Encrypter(XYQ.AES(key, mode: XYQ.AESMode.ecb));
    final encrypted = encrypter.encrypt(text, iv: iv);
    // return '$mykey#${encrypted.base64}';
    return encrypted.base64;
  }
  static String decryptCode(String text){
    String? ikey;
    if(text.contains('#')) {
      ikey = text.substring(0, text.indexOf('#'));
      // print(ikey);
      text = text.substring(text.indexOf('#')+1);
      // print(text);
    }
    final encrypted = XYQ.Encrypted.fromBase64(text);
    final key = XYQ.Key.fromUtf8(ikey ?? mykey);
    // final iv = XYQ.IV.fromUtf8(myiv);
    final iv = XYQ.IV.fromSecureRandom(128);
    final encrypter = XYQ.Encrypter(XYQ.AES(key, mode: XYQ.AESMode.ecb));
    return encrypter.decrypt(encrypted, iv: iv);
  }
  static Future<String?> getPhoneLocalPath() async {
    // final directory = Theme.of(mainContext).platform == TargetPlatform.android
    //     ? await getExternalStorageDirectory()
    //     : await getApplicationDocumentsDirectory();
    if(Platform.isAndroid){
      final directory=await getExternalStorageDirectory();
      return directory?.path;
    }else if(Platform.isIOS){
      final directory=await getApplicationDocumentsDirectory();
      return directory.path;
    }
    return null;
  }
  static void exportToDoc(String path) async{
    File file = File(await getVideoPath(path));
    if(file.existsSync()){
      ImageGallerySaver.saveFile(file.path);
      showWebColoredToast('????????????!');
    }
  }
  static Future<String> getVideoPath(String path) async{
    String? savePath = await getPhoneLocalPath();
    return '$savePath$path';
  }
  static Future<void> showWebColoredToast(String msg) async{
    print('Toast:$msg}');
    await Navigator.push(mainContext, DialogRouter(cToast(msg)));
    // Fluttertoast.showToast(
    //   msg: msg,
    //   toastLength: Toast.LENGTH_SHORT,
    //   // webBgColor: '#FFFFFF',
    //   // textColor: Colors.black,
    //   timeInSecForIosWeb: 5,
    // );
  }
  static Future<bool> requestPhotosPermission() async {
    //?????????????????????
    // var statusInternet = await Permission.interfaces.status;
    var statusPhotos = await Permission.photos.status;
    var statusCamera = await Permission.camera.status;
    var storageStatus = await Permission.storage.status;
    print("Android photos Status: " + statusPhotos.toString());
    if(statusPhotos != PermissionStatus.granted){
      statusPhotos = await Permission.photos.request();
    }
    print("Android camera Status: " + statusCamera.toString());
    if(statusCamera != PermissionStatus.granted){
      statusCamera = await Permission.camera.request();
    }
    print("Android storage Status: " + storageStatus.toString());
    if(storageStatus != PermissionStatus.granted){
      storageStatus = await Permission.storage.request();
    }
    if (statusPhotos == PermissionStatus.granted && statusCamera == PermissionStatus.granted && storageStatus == PermissionStatus.granted) {
      //????????????
      return true;
    } else {
      return false;
    }
  }
  static Future<String?> capturePng(GlobalKey repaintKey) async {
    try {
      // print('????????????');
      RenderRepaintBoundary boundary = repaintKey.currentContext?.findRenderObject()! as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage();
      ByteData byteData = (await image.toByteData(format: ui.ImageByteFormat.png))!;
      final result = await ImageGallerySaver.saveImage(byteData.buffer.asUint8List());
      // print(result);
      result != null ? Global.showWebColoredToast(Platform.isIOS ? (result['isSuccess'] == true ? '???????????????': '???????????????') : '???????????????${result['filePath']}') : print(result);
      return result['filePath'];
    } catch (e) {
      print(e);
    }
    return null;
  }
  static String getPriceNumber(int number,{bool fixed = false}) {
    double price = number / 100;
    // if (fixed) {
    //   price = price / 100;
    // }
    String result = fixed ? price.toStringAsFixed(2): price.toStringAsFixed(0);
    if(price < 0) return result;
    return '+$result';
  }
  static String getDateTime(int date) {
    if(date > 9999999999){
      date = date ~/ 1000;
    }
    int t = ((DateTime.now().millisecondsSinceEpoch ~/ 1000) - date);
    String str = '';
    if (t > 60) {
      t = t ~/ 60;
      if (t > 60) {
        t = t ~/ 60;
        if (t > 24) {
          t = t ~/ 24;
          if (t > 30) {
            t = t ~/ 30;
            if (t > 12) {
              t = t ~/ 12;
              str = '$t??????';
            } else {
              str = '$t??????';
            }
          } else {
            str = '$t??????';
          }
        } else {
          str = '$t?????????';
        }
      } else {
        str = '$t?????????';
      }
    } else {
      str = '$t??????';
    }
    return str;
  }
  static String getYearsOld(int date) {

    String str = '';
    if (date> 0) {
      int t = DateTime.now().year - DateTime.fromMillisecondsSinceEpoch(date).year;
      str = '$t???';
    } else {
      str = '0???';
    }
    return str;
  }
  static String inSecondsTostring(int seconds) {
    var d = Duration(seconds:seconds);
    List<String> parts = d.toString().split('.');
    return parts[0];
  }
  static String getTimeToString(int t){
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(t);
    return '${dateTime.year}-${dateTime.month}-${dateTime.day} ${dateTime.hour}:${dateTime.minute}';
  }
  static String getDateToString(int t){
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(t);
    return '${dateTime.year}-${dateTime.month}-${dateTime.day}';
  }
  static String getShortDateToString(int t){
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(t);
    return '${dateTime.month}-${dateTime.day}';
  }
  static String getNumbersToChinese(int n){
    if(n < 999){
      return '$n';
    }else{
      double d= n / 1000;
      if(d < 999){
        return '${d.toStringAsFixed(2)}K';
      }else{
          d= d / 1000;
          return '${d.toStringAsFixed(2)}M';
      }
      // double d= n / 10000;
      // if(d < 9999){
      //   return '${d.toStringAsFixed(2)}???';
      // }else{
      //   d= d / 10000;
      //   return '${d.toStringAsFixed(2)}???';
      // }
    }
  }
  static Future<Map<String, String>> getQueryString(String url)async{
    Map<String, String> map = <String, String>{};
    if(url.contains('?')){
      List<String> urls = url.split('?');
      if(urls.length > 1){
        url = urls[1];
        if(url.contains('&')){
          urls = url.split('&');
          for (int i =0;i< urls.length; i++){
            if(urls[i].contains('=')){
              List<String> temp = url.split('=');
              if(temp.length>1){
                map[temp[0]] = temp[1];
              }
            }
          }
        }else{
          List<String> temp = url.split('=');
          if(temp.length>1){
            map[temp[0]] = temp[1];
          }
        }
      }
    }
    return map;
  }
  static Size boundingTextSize(String text, TextStyle style, {int maxLines = 2 ^ 31, double maxWidth = double.infinity}) {
    if (text.isEmpty) {
      return Size.zero;
    }
    final TextPainter textPainter = TextPainter(
        textDirection: TextDirection.ltr,
        text: TextSpan(text: text, style: style),
        maxLines: maxLines)
      ..layout(maxWidth: maxWidth);
    return textPainter.size;
  }
  static String generateMd5(String data) {
    var content = Utf8Encoder().convert(data);
    var digest = md5.convert(content);
    // ?????????????????? digest.toString()
    return hex.encode(digest.bytes);
  }
  static Future<double> loadApplicationCache() async {
    /// ???????????????
    Directory directory = await getApplicationDocumentsDirectory();

    /// ??????????????????
    double value = await getTotalSizeOfFilesInDir(directory);
    return value;
  }
  static Future<double> getTotalSizeOfFilesInDir(final FileSystemEntity file) async {
    if (file is File) {
      int length = await file.length();
      return double.parse(length.toString());
    }
    if (file is Directory) {
      final List<FileSystemEntity>? children = file.listSync();
      double total = 0;
      if (children != null)
        for (final FileSystemEntity child in children) {
          total += await getTotalSizeOfFilesInDir(child);
        }
      return total;
    }
    return 0;
  }
  static String formatSize(double? value) {
    if (null == value) {
      return '0';
    }
    List<String> unitArr = ['B', 'K', 'M', 'G'];
    int index = 0;
    while (value! > 1024) {
      index++;
      value = (value / 1024);
    }
    String size = value.toStringAsFixed(2);
    return size + unitArr[index];
  }
  static Future<void> clearApplicationCache() async {
    Directory directory = await getApplicationDocumentsDirectory();
    //??????????????????
    await deleteDirectory(directory);
  }
  static Future<void> deleteDirectory(FileSystemEntity file) async {
    if (file is Directory) {
      final List<FileSystemEntity> children = file.listSync();
      for (final FileSystemEntity child in children) {
        await deleteDirectory(child);
      }
    }
    await file.delete();
  }
}
class DialogRouter extends PageRouteBuilder{

  final Widget page;

  DialogRouter(this.page)
      : super(
    opaque: false,
    // barrierColor: Colors.black54,
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) => child,
  );
}