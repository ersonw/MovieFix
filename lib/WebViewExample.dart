import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewExample extends StatefulWidget {
  final String url;
  bool inline;
  bool bar;
  WebViewExample ({Key? key, required this.url, this.inline=false, this.bar = true}) : super(key: key);

  @override
  WebViewExampleState createState() => WebViewExampleState();
}

class WebViewExampleState extends State<WebViewExample> {
  @override
  void initState() {
    // print(widget.url);
    super.initState();
    // Enable virtual display.
    if(kIsWeb==false){
      if (Platform.isAndroid) WebView.platform = AndroidWebView();
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      // appBar: AppBar(backgroundColor: Colors.transparent, title: const Text('网页访问'),),
      // navigationBar: widget.inline == true ? const CupertinoNavigationBar(previousPageTitle: '',) : const CupertinoNavigationBar(),
      navigationBar: widget.bar ? const CupertinoNavigationBar() : null,
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        child: WebView(
          javascriptMode: widget.inline? JavascriptMode.unrestricted: JavascriptMode.disabled,
          initialUrl: widget.url,
        )
      ),
    );
  }
}
