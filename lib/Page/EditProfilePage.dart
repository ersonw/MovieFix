import 'package:flutter/cupertino.dart';
import 'package:movie_fix/Module/GeneralRefresh.dart';
import 'package:movie_fix/tools/Tools.dart';

class EditProfilePage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _EditProfilePage();
  }
}
class _EditProfilePage extends State<EditProfilePage>{
  @override
  Widget build(BuildContext context) {
    return GeneralRefresh(
      title: '个人资料',
      body: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(60)),
                  image: DecorationImage(
                    image: buildHeaderPicture(self: true),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}