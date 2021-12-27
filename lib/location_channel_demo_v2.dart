import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

void main() => runApp(LocationPage());

class LocationPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return LocationPageState();
  }
}

class LocationPageState extends State<LocationPage>{
  String _text = '현재 위치: 모름';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '현재 위치 채널 데모 V2',
      home: Scaffold(
        appBar: AppBar(title: Text('현재 위치 채널 데모 V2'),),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(_text),
              ElevatedButton(onPressed: _refresh, child: Text('가져오기'))
            ],
          ),
        ),
      ),
    );
  }

  void _refresh() async {
    print('refresh current location');

    String _newText;
    Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    String result = '(${position.latitude}, ${position.longitude})';
    _newText = '현재 위치는 $result';
    setState(() {
      _text = _newText;
    });
  }
}