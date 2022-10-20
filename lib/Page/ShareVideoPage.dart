import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../Module/GeneralRefresh.dart';
import '../tools/Request.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../Global.dart';
import '../data/ShareVideo.dart';

class ShareVideoPage extends StatefulWidget {
  int id;
  String? title;
  bool touchClose;
  ShareVideoPage(this.id,{Key? key,this.touchClose = true,this.title}) : super(key: key);
  @override
  _ShareVideoPage createState() =>_ShareVideoPage();
}
class _ShareVideoPage extends State<ShareVideoPage> {
  ShareVideo video = ShareVideo();
  GlobalKey repaintKey = GlobalKey();

  @override
  void initState(){
    _getShare();
    super.initState();
  }
  _getShare()async{
    Map<String, dynamic> map = await Request.videoShare(widget.id);
    if (map['id'] != null) {
      video = ShareVideo.formJson(map);
      if(!mounted) return;
      setState(() {});
    }
  }
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: Stack(
          children: [
            GestureDetector(
              onDoubleTap: (){
                if(widget.touchClose){
                  Navigator.pop(context);
                }
              },
            ),
            _dialog(context),
          ],
        ),
      ),
    );
  }
  _dialog(BuildContext context){
    return video.id < 1 ? GeneralRefresh.getLoading() : Center(
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          RepaintBoundary(
            key: repaintKey,
            child: Container(
              width: (MediaQuery.of(context).size.width / 1),
              margin: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Color(0xff181921),
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  widget.title == null ? Container() : const Padding(padding: EdgeInsets.only(top: 10)),
                  widget.title == null ? Container() : Center(
                    child: Text(
                      widget.title!,
                    ),
                  ),
                  widget.title == null ? Container() : const Padding(padding: EdgeInsets.only(top: 10)),
                  widget.title == null ? Container() : Container(
                    width: MediaQuery.of(context).size.width,
                    height: 1,
                    color: Colors.white.withOpacity(0.5),
                  ),
                  widget.title == null ? Container() : const Padding(padding: EdgeInsets.only(top: 10)),
                  Container(
                    margin: const EdgeInsets.all(0.3),
                    height: MediaQuery.of(context).size.height / 4,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10),),
                        image: DecorationImage(
                          image: NetworkImage(video.picThumb ?? ''),
                          fit: BoxFit.fill,
                        )
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(10),
                    child: Text(video.title ?? '', softWrap: false, overflow: TextOverflow.ellipsis,),
                  ),
                  Container(
                    margin: const EdgeInsets.all(5),
                    child: Text(video.vodContent ?? '', softWrap: true, style: TextStyle(color: Colors.white.withOpacity(0.5)),),
                  ),
                  Center(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: QrImage(
                        data: video.shareUrl ?? '',
                        size: 170,
                        version: QrVersions.auto,
                        embeddedImageStyle: QrEmbeddedImageStyle(
                          size: const Size(30,30),
                        ),
                        // embeddedImage: ,
                      ),
                    ),
                  ),
                  const Padding(padding: EdgeInsets.only(top: 60)),
                ],
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                InkWell(
                  onTap: ()async{
                    if(kIsWeb == false){
                      if (await Global.requestPhotosPermission() == true || Platform.isIOS){
                        await Global.capturePng(repaintKey);
                        Navigator.pop(context);
                        Global.showWebColoredToast('保存成功！');
                      }
                    }else{
                      Global.showWebColoredToast('同时按下音量键与电源键截图哟！');
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xfffc8a7d),
                          Color(0xffff0010),
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      border: Border.all(width: 1,color: Colors.black.withOpacity(0.12)),
                    ),
                    child: Container(
                      margin: const EdgeInsets.only(left: 30, right: 30, top:10, bottom:10),
                      child: Row(
                        children: [
                          const Text('保存图片',),
                        ],
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: ()async{
                    // if(kIsWeb == false){
                    await Clipboard.setData(ClipboardData(text: video.shareUrl));
                    Navigator.pop(context);
                    Global.showWebColoredToast('复制成功！');
                    // }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xfffc8a7d),
                          Color(0xffff0010),
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      border: Border.all(width: 1,color: Colors.black.withOpacity(0.12)),
                    ),
                    child: Container(
                      margin: const EdgeInsets.only(left: 30, right: 30, top:10, bottom:10),
                      child: Row(
                        children: [
                          const Text('复制链接',),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      )
    );
  }
  @override
  void activate() {
    // TODO: implement activate
    super.activate();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
