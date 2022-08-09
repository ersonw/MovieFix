import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:movie_fix/Global.dart';
import 'package:movie_fix/Module/CropImageRoute.dart';
import 'package:movie_fix/tools/CustomRoute.dart';
import 'package:movie_fix/tools/Tools.dart';
import 'dart:io';

class AvatarPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _AvatarPage();
  }
}
class _AvatarPage extends State<AvatarPage>{
  final ImagePicker _picker = ImagePicker();
  String? avatar = userModel.user.avatar;
  _pick()async{
    final XFile? file = await _picker.pickImage(
        source: ImageSource.gallery,
      maxWidth: MediaQuery.of(context).size.width,
      maxHeight: MediaQuery.of(context).size.width,
    );
    // print(file?.path);
    // setState(() {
    //   avatar = file?.path;
    // });
    if(file == null) return;
    String _avatar = file.path;
    Navigator.push(
        context, FadeRoute(page: CropImageRoute(File(_avatar),callback: (value){
          setState(() {
            avatar = value;
          });
    },)));
  }
  _buildAvatar(){
    if(avatar == null){
      return buildHeaderPicture(self: true);
    }
    String _avatar = avatar!;
    if(_avatar.startsWith('http')){
      return buildHeaderPicture(avatar: avatar);
    }
    return FileImage(File(_avatar));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff181921),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 45,left: 15,),
            width: MediaQuery.of(context).size.width,
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(60)),
                    color: Colors.white.withOpacity(0.15),
                  ),
                  child: Container(
                    margin: const EdgeInsets.only(top: 6,bottom: 6,left: 6,right: 6),
                    child: Icon(Icons.close),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 30,bottom: 30),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: _buildAvatar(),
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(9)),
              color: Colors.white.withOpacity(0.15),
            ),
            child: Container(
              margin: const EdgeInsets.all(9),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    onTap: _pick,
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.1)))
                      ),
                      child: Container(
                        margin: const EdgeInsets.only(top: 3,bottom: 3),
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('更换头像'),
                            Icon(Icons.edit),
                          ],
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.1)))
                      ),
                      child: Container(
                        margin: const EdgeInsets.only(top: 3,bottom: 3),
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('保存头像'),
                            Icon(Icons.download_rounded),
                          ],
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.1)))
                      ),
                      child: Container(
                        margin: const EdgeInsets.only(top: 3,bottom: 3),
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('查看二维码'),
                            Icon(Icons.qr_code),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}