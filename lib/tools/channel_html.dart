import '../Global.dart';
import 'WebJS.dart';
class Channel {
  static Future<void> init()async {
    var queryParameters = WebJs.getUri();
    if(queryParameters != null){
      if(queryParameters['code'] != null) Global.codeInvite = queryParameters['code'];
      if(queryParameters['channel'] != null) Global.channelCode = queryParameters['channel'];
    }
  }
}