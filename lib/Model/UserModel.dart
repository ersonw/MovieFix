import '../ProfileChangeNotifier.dart';
import '../data/User.dart';

class UserModel extends ProfileChangeNotifier {
  User get user => profile.user;

  bool hasToken(){
    if(user != null && user.token != null && user.token.isNotEmpty){
      return true;
    }
    return false;
  }
  void setToken(String token){
    profile.user.token = token;
    notifyListeners();
  }
  set user(User user){
    if(user != null && profile.user != null && user.token != profile.user.token){
      profile.user = user;
      setToken(user.token);
    }else{
      profile.user = user;
    }
    // notifyListeners();
  }
}
