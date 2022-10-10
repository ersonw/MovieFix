import 'package:movie_fix/data/Button.dart';
import 'package:movie_fix/data/ButtonConfig.dart';

import '../ProfileChangeNotifier.dart';

class ButtonModel extends ProfileChangeNotifier {
  ButtonConfig get config => profile.buttonConfig;
  List<Button> get diamond => config.diamond;
  List<Button> get coin => config.coin;
  List<Button> get balance => config.balance;
  List<Button> get game => config.game;
  set diamond(List<Button> diamond) {
    profile.buttonConfig.diamond = diamond;
    notifyListeners();
  }
  set coin(List<Button> coin) {
    profile.buttonConfig.coin = coin;
    notifyListeners();
  }
  set balance(List<Button> balance) {
    profile.buttonConfig.balance = balance;
    notifyListeners();
  }
  set game(List<Button> game) {
    profile.buttonConfig.game = game;
    notifyListeners();
  }
  set config(ButtonConfig config){
    profile.buttonConfig = config;
    notifyListeners();
  }
}
