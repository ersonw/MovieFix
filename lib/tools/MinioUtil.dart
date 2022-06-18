import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'Loading.dart';
import 'minio/minio.dart';
import 'minio/io.dart';
// import 'minio/src/minio.dart';
class MinioUtil {
  static late final minio;
  static const String bucket = 'upload';
  static void init(){
    minio = Minio(
      endPoint: 'minio.telebott.com',
      // port: 9000,
      accessKey: 'LTAI935qVCSkHsdW',
      secretKey: 'xgEAayhKS3FYYmpJFUWg85PkbZVJSr',
      useSSL: false,
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
    if(callback != null){
      callback(1);
    }
    return '$pathName/$fileName';
  }
  static Future<void> _put(String key, String path)async{
    // Loading.show();
    await minio.putObject(
      bucket,
      key,
      Stream<Uint8List>.value(File(path).readAsBytesSync()),
      onProgress: (bytes) {
        // uploaded += int.parse('$bytes');
        // print('$uploaded bytes uploaded');
      },
    );
    // Loading.dismiss();
  }
}
class FilePath {
  String path;
  String key;
  FilePath(this.path, this.key);
}