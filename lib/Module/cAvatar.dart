import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_fix/Global.dart';
import 'package:movie_fix/data/User.dart';
import 'package:movie_fix/tools/Tools.dart';

import '../AssetsMembership.dart';

class cAvatar extends StatelessWidget {
  // ImageProvider<Object> image;
  User? user;
  double size;

  cAvatar({Key? key, this.size = 60, this.user}) : super(key: key);

  _buildPicture() {
    if (this.user == null) {
      return buildHeaderPicture(self: true);
    }
    return buildHeaderPicture(avatar: user?.avatar);
  }

  _buildColor() {
    User _user;
    if (this.user == null) {
      _user = userModel.user;
    } else {
      _user = this.user!;
    }
    if (_user.member == false) return Colors.white;
    switch (_user.level) {
      case 1:
      case 2:
      case 3:
        return Color(0xffe89e7d);
      case 4:
      case 5:
      case 6:
        return Color(0xffb7b2d9);
      case 7:
      case 8:
      case 9:
      case 10:
      case 11:
        return Color(0xffeec660);
      case 12:
      case 13:
      case 14:
      case 15:
      case 16:
      case 17:
      case 18:
      case 19:
      case 20:
      case 21:
        return Color(0xffa497e9);
      default:
        return Colors.white;
    }
  }

  _buildIcon() {
    User _user;
    if (this.user == null) {
      _user = userModel.user;
    } else {
      _user = this.user!;
    }
    if (_user.member == false) return Container();
    String icon = '';
    switch (_user.level) {
      case 1:
        icon = AssetsMembership.bronze1;
        break;
      case 2:
        icon = AssetsMembership.bronze2;
        break;
      case 3:
        icon = AssetsMembership.bronze3;
        break;
      case 4:
        icon = AssetsMembership.silver1;
        break;
      case 5:
        icon = AssetsMembership.silver2;
        break;
      case 6:
        icon = AssetsMembership.silver3;
        break;
      case 7:
        icon = AssetsMembership.gold1;
        break;
      case 8:
        icon = AssetsMembership.gold2;
        break;
      case 9:
        icon = AssetsMembership.gold3;
        break;
      case 10:
        icon = AssetsMembership.gold4;
        break;
      case 11:
        icon = AssetsMembership.gold5;
        break;
      case 12:
        icon = AssetsMembership.diamond1;
        break;
      case 13:
        icon = AssetsMembership.diamond2;
        break;
      case 14:
        icon = AssetsMembership.diamond3;
        break;
      case 15:
        icon = AssetsMembership.diamond4;
        break;
      case 16:
        icon = AssetsMembership.diamond5;
        break;
      case 17:
        icon = AssetsMembership.glory1;
        break;
      case 18:
        icon = AssetsMembership.glory2;
        break;
      case 19:
        icon = AssetsMembership.glory3;
        break;
      case 20:
        icon = AssetsMembership.glory4;
        break;
      case 21:
        icon = AssetsMembership.glory5;
        break;
      default:
        return Container();
    }
    return Image.asset(icon);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 15, bottom: 15),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Stack(
            alignment: Alignment.topCenter,
            children: [
              SizedBox(
                width: size,
                height: size + 12,
              ),
              Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(60)),
                  // border: Border.all(width: 2,color: Colors.white),
                  border: Border.all(width: 2, color: _buildColor()),
                  image: DecorationImage(
                    image: _buildPicture(),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ],
          ),
          _buildIcon(),
        ],
      ),
    );
  }
}
