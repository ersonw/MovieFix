import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../data/CountryCode.dart';
import 'package:ncindexlistview/ncindexlistview.dart';
class CountryCodePage extends StatefulWidget {
  CountryCodePage({Key? key, this.callback}) : super(key: key);
  Function? callback;
  @override
  _CountryCodePage createState() => _CountryCodePage();

}
class _CountryCodePage extends State<CountryCodePage>{
  final List<String> _dataSource = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    CountryCode code = CountryCode(code: '+61',title: '澳大利亚');
    _dataSource.add(code.toString());
    code = CountryCode(code: '+850',title: '朝鲜');
    _dataSource.add(code.toString());
    code = CountryCode(code: '+33',title: '法国');
    _dataSource.add(code.toString());
    code = CountryCode(code: '+63',title: '菲律宾');
    _dataSource.add(code.toString());
    code = CountryCode(code: '+358',title: '芬兰');
    _dataSource.add(code.toString());
    code = CountryCode(code: '+82',title: '韩国');
    _dataSource.add(code.toString());
    code = CountryCode(code: '+60',title: '马来西亚');
    _dataSource.add(code.toString());
    code = CountryCode(code: '+1',title: '美国');
    _dataSource.add(code.toString());
    code = CountryCode(code: '+976',title: '蒙古');
    _dataSource.add(code.toString());
    code = CountryCode(code: '+81',title: '日本');
    _dataSource.add(code.toString());
    code = CountryCode(code: '+65',title: '新加坡');
    _dataSource.add(code.toString());
    code = CountryCode(code: '+64',title: '新西兰');
    _dataSource.add(code.toString());
    code = CountryCode(code: '+91',title: '印度');
    _dataSource.add(code.toString());
    code = CountryCode(code: '+62',title: '印度尼西亚');
    _dataSource.add(code.toString());
    code = CountryCode(code: '+44',title: '英国');
    _dataSource.add(code.toString());
    code = CountryCode(code: '+86',title: '中国大陆');
    _dataSource.add(code.toString());
    code = CountryCode(code: '+886',title: '中国香港');
    _dataSource.add(code.toString());
    code = CountryCode(code: '+853',title: '中国澳门');
    _dataSource.add(code.toString());
    code = CountryCode(code: '+852',title: '中国台湾');
    _dataSource.add(code.toString());

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // navigationBar: const CupertinoNavigationBar(),
      body:  NCIndexListView<String>(
        dataSource: _dataSource,
        getNameText: (s) {
          CountryCode code = CountryCode.formJson(jsonDecode(s));
          return code.title;
        },
        itemBuilder: (context, value) {
          CountryCode code = CountryCode.formJson(jsonDecode(value));
          return TextButton(
            onPressed: () {
              widget.callback!(code.code);
              Navigator.pop(context);
            },
            child: ListTile(
              title: Row(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 40),
                    child: Text(code.code),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 40),
                    child: Text(code.title),
                  ),
                ],
              ),
            ),
          );
        },
        itemHeight: 50,
      ),
    );
  }
}