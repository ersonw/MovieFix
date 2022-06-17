// import 'dart:convert';
// import 'dart:math';
// import 'package:http/http.dart';
// import 'package:movies/data/OssConfig.dart';
// import 'package:movies/global.dart';
// import 'package:movies/model/ConfigModel.dart';
// import 'package:xml2json/xml2json.dart';
// import 'package:movies/HttpManager.dart';
// import 'package:movies/network/NWApi.dart';
// import 'package:movies/network/NWMethod.dart';
// import 'package:oss_dart/oss_dart.dart';
// import 'dart:io';
// class UploadOssUtil {
//   static final ConfigModel _configModel = ConfigModel();
//   // static OssConfig config = _configModel.ossConfig;
//   static Future<String?> upload(File file, String fileKey)async {
//     OssConfig config = _configModel.ossConfig;
//     if(config.bucketName == null || config.endpoint == null) return null;
//     OssClient client = OssClient(bucketName: config.bucketName,endpoint: config.endpoint,tokenGetter: getStsAccount);
//     fileKey = 'upload/$fileKey';
//     List<int> fileData = file.readAsBytesSync();//上传文件的二进制
//     // String fileKey = 'ABC.text';//上传文件名
//     Response  response = await client.putObject(fileData, fileKey);
//     // print(response.request.url);
//     if(response.statusCode == 200){
//       // return (config.ossName ?? 'http://${client.bucketName}.${client.endpoint}')+'/$fileKey';
//       // return (response.request.url.toString()).replaceAll(config.endpoint!, 'oss-accelerate.aliyuncs.com');
//       String url = response.request.url.toString();
//       if(config.endpoint != null && config.ossName != null){
//         url = url.replaceAll('${config.bucketName}.${config.endpoint}', '${config.ossName}');
//       }
//       return url;
//     }
//     print(response.body);
//     return null;
//     //获取文件
//     // response = await client.getObject(fileKey);
//     //分片上传
//     //First get uploadId
//     // client.headers['x-oss-storage-class'] = 'Archive';
//     // response = await client.initiateMultipartUpload(fileKey);
//     // print(response.statusCode);
//     // Map<String, dynamic> ret = await getJson(response.body);
//     // print(ret['Error']['Message']);
//
//     // return;
//     // if(ret['']){
//     //
//     // }
//     // String uploadId = '';
//     // //Second upload part
//     // num partNum = 1;//上传分块的序号
//     // var etag = await client.uploadPart(fileData,fileKey,uploadId,partNum);
//     // //Third complate multiUpload
//     // List etags = [etag];//所有区块上传完成后返回的etag，按顺序排列
//     // response = await client.completeMultipartUpload(etags, fileKey, uploadId);
//     //response 是阿里云返回的xml格式的数据，需要单独解析
//     // print(response.body);
//   }
//   static String generateRandomString(int length) {
//     final _random = Random();
//     const _availableChars =
//         'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
//     final randomString = List.generate(length,
//             (index) => _availableChars[_random.nextInt(_availableChars.length)])
//         .join();
//
//     return randomString;
//   }
//   static Future<Map<String, dynamic>> getJson(String val) async{
//     final Xml2Json _xml2json = Xml2Json();
//     _xml2json.parse(val);
//     return jsonDecode(await _xml2json.toBadgerfish());
//   }
//   static Future<Map<String, dynamic>> getStsAccount()async{
//     var data = await DioManager().requestAsync(NWMethod.GET, NWApi.getStsAccount, {});
//     Map<String, dynamic> map = json.decode(data!);
//     // print(map);
//     return map;
//   }
// }