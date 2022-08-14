import 'dart:ui';

import 'package:flutter/material.dart';

import '../AssetsMembership.dart';

class MembershipLevel {
  static String buildIcons(int level) {
    String icon = "";
    switch (level) {
      case 1:
        icon = AssetsMembership.bronze1Icon;
        break;
      case 2:
        icon = AssetsMembership.bronze2Icon;
        break;
      case 3:
        icon = AssetsMembership.bronze3Icon;
        break;
      case 4:
        icon = AssetsMembership.silver1Icon;
        break;
      case 5:
        icon = AssetsMembership.silver2Icon;
        break;
      case 6:
        icon = AssetsMembership.silver3Icon;
        break;
      case 7:
        icon = AssetsMembership.gold1Icon;
        break;
      case 8:
        icon = AssetsMembership.gold2Icon;
        break;
      case 9:
        icon = AssetsMembership.gold3Icon;
        break;
      case 10:
        icon = AssetsMembership.gold4Icon;
        break;
      case 11:
        icon = AssetsMembership.gold5Icon;
        break;
      case 12:
        icon = AssetsMembership.diamond1Icon;
        break;
      case 13:
        icon = AssetsMembership.diamond2Icon;
        break;
      case 14:
        icon = AssetsMembership.diamond3Icon;
        break;
      case 15:
        icon = AssetsMembership.diamond4Icon;
        break;
      case 16:
        icon = AssetsMembership.diamond5Icon;
        break;
      case 17:
        icon = AssetsMembership.glory1Icon;
        break;
      case 18:
        icon = AssetsMembership.glory2Icon;
        break;
      case 19:
        icon = AssetsMembership.glory3Icon;
        break;
      case 20:
        icon = AssetsMembership.glory4Icon;
        break;
      case 21:
        icon = AssetsMembership.glory5Icon;
        break;
      default:
        break;
      // return Container();
    }
    return icon;
  }

  static Color buildColor(int level) {
    switch (level) {
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
  static int buildGrade(int level) {
    switch (level) {
      case 1:
      case 2:
      case 3:
        return 1;
      case 4:
      case 5:
      case 6:
        return 2;
      case 7:
      case 8:
      case 9:
      case 10:
      case 11:
        return 3;
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
        return 4;
      default:
        return 0;
    }
  }
}
