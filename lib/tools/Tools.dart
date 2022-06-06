import '../data/SwiperData.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Global.dart';

handlerSwiper(SwiperData data){
  switch(data.type){
    case SwiperData.OPEN_WEB_OUTSIDE:
      launchUrl(Uri.parse(data.url));
      break;
    case SwiperData.OPEN_WEB_INSIDE:
      Global.openWebview(data.url, inline: true);
      break;
  }
}