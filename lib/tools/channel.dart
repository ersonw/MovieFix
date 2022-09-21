import 'package:openinstall_flutter_plugin/openinstall_flutter_plugin.dart';
final OpeninstallFlutterPlugin _openinstallFlutterPlugin = OpeninstallFlutterPlugin();
class Channel {
  static Future<void> init()async{
    _openinstallFlutterPlugin.init(wakeupHandler);
    _openinstallFlutterPlugin.install(installHandler);
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
}