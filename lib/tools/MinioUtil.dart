import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'Loading.dart';
import 'minio/minio.dart';
import 'minio/io.dart';
// import 'minio/src/minio.dart';
class MinioUtil {
  static late final minio;
  static void init(){
    minio = Minio(
      endPoint: 'minio.telebott.com',
      // port: 9000,
      accessKey: 'LTAI935qVCSkHsdW',
      secretKey: 'xgEAayhKS3FYYmpJFUWg85PkbZVJSr',
      useSSL: false,
    );
  }
  static Future<bool> put(String key, String path,{void Function(double value)? callback})async{
    // Stream<Uint8List> stream = Stream<Uint8List>.value(File(path).readAsBytesSync());
    // int length = File(path).readAsBytesSync().length;
    // int uploaded = 0;
    Loading.show();
    await minio.putObject(
      'upload',
      key,
      Stream<Uint8List>.value(File(path).readAsBytesSync()),
      onProgress: (bytes) {
        // uploaded += int.parse('$bytes');
        // print('$uploaded bytes uploaded');
      },
    );
    Loading.dismiss();
    return true;
    // final acl = await minio.getObjectACL('upload', key);
    // print('${acl.owner}');
    // return false;
    // final stat = await minio.statObject('upload', key);
    // return stat.size == File(path).lengthSync();
  }
}