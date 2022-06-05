import'dart:html' as html;
class WebJs {
  static getUri(){
    var uri = Uri.dataFromString(html.window.location.href);
    return uri.queryParameters;
  }
}