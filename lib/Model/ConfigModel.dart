import '../ProfileChangeNotifier.dart';
import '../data/Config.dart';

class ConfigModel extends ProfileChangeNotifier {
  Config get config => profile.config;
  set config(Config config){
    profile.config = config;
    notifyListeners();
  }
}