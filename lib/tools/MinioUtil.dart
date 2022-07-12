import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:movie_fix/data/OssConfig.dart';

import 'Loading.dart';
import 'minio/minio.dart';
import 'minio/io.dart';
// import 'minio/src/minio.dart';
class MinioUtil {
  static late final minio;
  static final OssConfig config = OssConfig(bucket: 'upload',
      endPoint: 'yyzz.io',accessKey: 'rxHm7z0t1c2Fd3zC',
    secretKey: 'E2dcqb8VizhLjPXD2agheXeo5aXKYgkE',
    // useSSL: false,
  );
  static void init(){

    minio = Minio(
      endPoint: config.endPoint,
      port: config.port,
      accessKey: config.accessKey,
      secretKey: config.secretKey,
      useSSL: config.useSSL,
      sessionToken: config.sessionToken,
      region: config.region,
      enableTrace: config.enableTrace,
    );
  }
  static Future<List<String>> _getDirFiles(String path) async{
    List<FileSystemEntity> files = Directory(path).listSync();
    List<String> result = [];
    for(FileSystemEntity f in files){
      if(f.statSync().type == FileSystemEntityType.file){
        // String pathName = (f.parent.path.split("/")).last;
        // String fileName = (f.path.split("/")).last;
        // print('$pathName/$fileName');
        result.add(f.path);
      }else if(f.statSync().type == FileSystemEntityType.directory){
        _getDirFiles(f.path);
      }
    }
    return result;
  }
  static Future<List<FilePath>> _getRemoteKeys(List<String> files, String path)async{
    List<FilePath> keys = [];
    for(String file in files){
      keys.add(FilePath(file,'$path${file.split(path)[1]}'));
    }
    return keys;
}
  // static Future<String?> putPicThumb(String key,String filePath,{void Function(double value)? callback})async{
  //
  // }
  static Future<String?> putM3u8(String filePath,{void Function(double value)? callback})async{
    File file = File(filePath);
    if(!file.existsSync()) return null;
    String pathName = (file.parent.path.split("/")).last;
    String fileName = (file.path.split("/")).last;
    List<FilePath> keys = await _getRemoteKeys(await _getDirFiles(file.parent.path), pathName);
    final int length = keys.length;
    if(callback != null){
      callback(0);
    }
    for(int i = 0; i < keys.length; i++) {
      FilePath key = keys[i];
      _put(key.key, key.path);
      if(callback != null){
        callback(double.parse((i / length).toStringAsFixed(2)));
      }
    }
    file.deleteSync(recursive: true);
    if(callback != null){
      callback(1);
    }
    return '$pathName/$fileName';
  }
  static Future<void> _put(String key, String path)async{
    // print('key:$key');
    // print('path:$path');
    File file = File(path);
    if(!file.existsSync()) return  ;
    await minio.putObject(
      config.bucket,
      key,
      Stream<Uint8List>.value(file.readAsBytesSync()),
      onProgress: (bytes) {
        // uploaded += int.parse('$bytes   ');
        // print('$uploaded bytes uploaded');
      },
    );
    // file.deleteSync();
  }
}
class FilePath {
  String path;
  String key;
  FilePath(this.path, this.key);
}