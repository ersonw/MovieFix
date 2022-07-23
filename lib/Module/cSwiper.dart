import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:movie_fix/data/SwiperData.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Global.dart';

class cSwiper extends StatefulWidget{
  List<SwiperData> swipers;

  cSwiper(this.swipers,{Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _cSwiper();
  }
}
class _cSwiper extends State<cSwiper>{
  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.black,
      margin: const EdgeInsets.only(top: 15,bottom: 15,left: 20,right: 20),
      height: 180,
      child: Swiper(
        loop: true,
        autoplay: true,
        itemCount: widget.swipers.length,
        itemBuilder: _buildSwiper,
        pagination: const SwiperPagination(),
        control: const SwiperControl(color: Colors.white),
      ),
    );
  }
  Widget _buildSwiper(BuildContext context, int index) {
    SwiperData _swiper = widget.swipers[index];
    return InkWell(
      onTap: () {
        handlerSwiper(_swiper);
      },
      child: Container(
        // height: 120,
        decoration: BoxDecoration(
          // color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(15)),
          image: DecorationImage(
            image: NetworkImage(_swiper.image),
            fit: BoxFit.fill,
            alignment: Alignment.center,
          ),
        ),
      ),
    );
  }
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
}