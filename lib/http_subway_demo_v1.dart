import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(SubwayDemo());

class SubwayDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '지하철 실시간 정보',
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MainPageState();
  }
}

class MainPageState extends State<MainPage> {
  String _response = '...';
  String _url = 'http://swopenapi.seoul.go.kr/api/subway/sample/json/realtimeStationArrival/0/5/';
  static const String _defaultStation = '방배';
  TextEditingController _stationController = TextEditingController(text: _defaultStation);
  List<dynamic> _realtimeArrivalList = [];
  String _errorMessage = '에러입니다.';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _httpGet(_urlBuilder(_defaultStation));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('지하철 실시간 정보'),
      ),
      body: _isLoading? Center(child: CircularProgressIndicator(),):
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Padding(
                  child: Text('역 이름'),
                  padding: EdgeInsets.only(left: 20),
                ),
                SizedBox(width: 10,),
                Container(
                  width: 150,
                  child: TextField(
                    keyboardType: TextInputType.text,
                    maxLength: 20,
                    controller: _stationController,
                  ),

                ),
                SizedBox(width: 10,),
                ElevatedButton(onPressed: _onClick, child: Text('조회')),
              ],
            ),
            SizedBox(height: 10,),
            Padding(
              child: Text('도착 정보'),
              padding: EdgeInsets.only(left: 20),
            ),
            SizedBox(height: 10,),
            // Padding(padding: EdgeInsets.only(left: 20),child: Text(_response),)
            Flexible(
              child: GridView.count(
                crossAxisCount: 2,
                children: _buildCards(),
              ),
            )
          ],
        ),
    );
  }

  void _httpGet(String url) async {
    setState(() {
      _isLoading = true;
    });

    var response = await http.get(url);
    Map<String, dynamic> json = jsonDecode(response.body);
    Map<String, dynamic> errorMessage = json['errorMessage'];
    if (errorMessage != null && errorMessage['status'] == 200) {
      setState(() {
        _realtimeArrivalList = json['realtimeArrivalList'];
        _errorMessage = '';
        _isLoading = false;
      });
    } else {
      setState(() {
        _errorMessage = json['message'];
        _realtimeArrivalList = [];
        _isLoading = false;
      });
    }
  }

  void _onClick() {
    if (_stationController.text.isEmpty) {
      showDialog(
        context: context,
        //barrierDismissible - Dialog를 제외한 다른 화면 터치 x
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            // RoundedRectangleBorder - Dialog 화면 모서리 둥글게 조절
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            //Dialog Main Title
            title: Column(
              children: <Widget>[
                new Text("Dialog Title"),
              ],
            ),
            //
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "역 이름을 입력해주세요",
                ),
              ],
            ),
            actions: <Widget>[
              new TextButton(
                child: new Text("확인"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        }
      );
      return;
    }
    _httpGet(_urlBuilder(_stationController.text));
  }

  String _urlBuilder(String defaultStation) {
    return _url + defaultStation;
  }

  List<Card> _buildCards() {
    List<Card> cards = [];

    if (_realtimeArrivalList.length == 0) {
      Card card = Card(child: Text(_errorMessage),);
      cards.add(card);
      return cards;
    }

    for (Map<String, dynamic> info in _realtimeArrivalList) {
      Card card = Card(
        child: Column(
          children: [
            AspectRatio(
              aspectRatio: 18/11,
              child: Image.asset(
                'images/icon/subway.png',
                fit: BoxFit.fitHeight,
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.fromLTRB(16, 12, 16, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      info['trainLineNm'],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4,),
                    Text(
                      info['arvlMsg2'],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      );

      cards.add(card);
    }
    return cards;
  }
}

