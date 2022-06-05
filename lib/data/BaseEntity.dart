class EntityFactory {
  static T generateOBJ<T>(json) {
    if (json == null) {
      return json;
    }
//可以在这里加入任何需要并且可以转换的类型，例如下面
//    else if (T.toString() == "LoginEntity") {
//      return LoginEntity.fromJson(json) as T;
//    }
    else {
      return json as T;
    }
  }
}
class BaseListEntity<T> {
  int code;
  String message;
  List<T> data;

  BaseListEntity({required this.code, required this.message, required this.data});

  factory BaseListEntity.fromJson(json) {
    List<T> mData = [];
    if (json['data'] != null) {
      //遍历data并转换为我们传进来的类型
      for (var v in (json['data'] as List)) {
        mData.add(EntityFactory.generateOBJ<T>(v));
      }
    }

    return BaseListEntity(
      code: json["code"],
      message: json["message"],
      data: mData,
    );
  }
}
