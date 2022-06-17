// import 'dart:io';
import 'package:minio/io.dart';
import 'package:minio/minio.dart';

class MinioUtil {
  static late final minio;
  static void init(){
    minio = Minio(
      endPoint: '172.21.72.31',
      port: 9000,
      accessKey: 'LTAI935qVCSkHsdW',
      secretKey: 'xgEAayhKS3FYYmpJFUWg85PkbZVJSr',
      useSSL: false,
    );
  }
  static Future<bool> put(String key, String path)async{
    await minio.fPutObject('upload', key, path);
    final stat = await minio.statObject('upload', key);
    // assert(stat.size == File('example/custed.png').lengthSync());
    return stat.size == File(path).lengthSync();
  }
}