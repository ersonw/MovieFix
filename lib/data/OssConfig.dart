import 'dart:convert';

class OssConfig {
  static const int TYPE_UPLOAD_OSS_MINIO = 100;
  static const int TYPE_UPLOAD_OSS_ALIYUN = 101;
  int type = 100;
  String bucket = '';

  String endPoint = '';
  String accessKey = '';
  String secretKey = '';

  int? port;
  String? region;
  String? sessionToken;
  bool useSSL = true;
  bool enableTrace = false;
  OssConfig({this.type = TYPE_UPLOAD_OSS_MINIO,
  this.bucket='',this.endPoint='',this.accessKey='',
  this.secretKey='',this.port,this.region,this.sessionToken,
  this.useSSL=true,this.enableTrace=false});
  OssConfig.fromJson(Map<String, dynamic> json)
      : type = json['type'] ?? TYPE_UPLOAD_OSS_MINIO,
        endPoint = json['endPoint'] ?? '',
        accessKey = json['accessKey'] ?? '',
        secretKey = json['secretKey'] ?? '',
        port = json['port'],
        region = json['region'],
        sessionToken = json['sessionToken'],
        useSSL = json['useSSL'] ?? true,
        enableTrace = json['enableTrace'] ?? false;

  Map<String, dynamic> toJson() => {
        'type': type,
        'endPoint': endPoint,
        'accessKey': accessKey,
        'secretKey': secretKey,
        'port': port,
        'region': region,
        'sessionToken': sessionToken,
        'useSSL': useSSL,
        'enableTrace': enableTrace,
      };

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}
