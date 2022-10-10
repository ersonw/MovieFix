
import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';

class TableChangeNotifier extends ChangeNotifier {
  int currentIndex = 0;
  int get index => currentIndex;
  set index(int index) {
    currentIndex = index;
    notifyListeners();
  }
  @override
  void notifyListeners() {
    super.notifyListeners(); //通知依赖的Widget更新
  }
}
