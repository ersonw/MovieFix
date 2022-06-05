import '../ProfileChangeNotifier.dart';

class GeneralModel extends ProfileChangeNotifier {
  List<String> get words => profile.words;

  void updateWords(String word) {
    if(profile.words.contains(word)){
      profile.words.remove(word);
    }
    profile.words.insert(0,word);
    notifyListeners();
  }
  void clearWords() {
    profile.words.clear();
    notifyListeners();
  }
}