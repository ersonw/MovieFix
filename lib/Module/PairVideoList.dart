import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../data/Video.dart';

import '../AssetsIcon.dart';
import '../Global.dart';
typedef TapCallback = Future<void> Function();
class PairVideoList extends StatelessWidget {
  final Video video;
  final TapCallback? callback;
  PairVideoList(this.video,{
    Key? key,
    this.callback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ()async{
        if(callback != null){
          await callback!();
        }
        Global.playerPage(video.id);
      },
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(6),
            alignment: Alignment.centerLeft,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  height: ((MediaQuery.of(context).size.height) / 7),
                  width: ((MediaQuery.of(context).size.width) / 2.2),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(9)),
                    image: DecorationImage(
                        fit: BoxFit.fill,
                        image: NetworkImage(video.picThumb)),
                  ),
                ),
                Container(
                  height: ((MediaQuery.of(context).size.height) / 7),
                  width: ((MediaQuery.of(context).size.width) / 2.2),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            height: ((MediaQuery.of(context).size.height) / 7) / 5,
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                fit: BoxFit.fill,
                                image: AssetImage(AssetsIcon.diamondTagBK),
                              ),
                            ),
                            child: Container(
                              alignment: Alignment.center,
                              margin: const EdgeInsets.only(left: 6,right: 6),
                              child: Row(
                                children: video.pay ? (video.price > 0 ? [
                                  Text('${video.price}'),
                                  const Padding(padding: EdgeInsets.only(left: 1)),
                                  Image.asset(AssetsIcon.diamondTag),
                                ] : [
                                  const Text('VIP',style: TextStyle(fontWeight: FontWeight.bold),)
                                ]
                                ) : [
                                  const Text('免费',style: TextStyle(fontWeight: FontWeight.bold),)
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        height: ((MediaQuery.of(context).size.height) / 7) / 5,
                        // width: MediaQuery.of(context).size.width / 6,
                        // margin: const EdgeInsets.only(bottom: 3),
                        decoration: BoxDecoration(
                          // color: Colors.black.withOpacity(0.1),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withOpacity(0.05),
                              Colors.black.withOpacity(0.15),
                              Colors.black.withOpacity(0.9),
                            ]
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(left: 3,right: 3),
                              child: Row(
                                // mainAxisSize: MainAxisSize.min,
                                children: [
                                  Image.asset(AssetsIcon.playIcon),
                                  Text(' ${Global.getNumbersToChinese(video.plays)}播放',style: TextStyle(fontSize: 12),)
                                ],
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 3,bottom: 3,left: 6,right: 6),
                              child: Text(Global.inSecondsTostring(video.vodDuration),style: TextStyle(fontSize: 12),),
                            ),
                          ],
                        ),
                      ),

                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            width: ((MediaQuery.of(context).size.width) / 2.2),
            child: Text(video.title,softWrap: false,overflow: TextOverflow.ellipsis,),
          ),
        ],
      ),
    );
  }
}
