import 'package:flutter/material.dart';

void main() => runApp(BatteryPage());

class BatteryPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return BatteryPageState();
  }
}

class BatteryPageState extends State<BatteryPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '배터리 채널 데모 V1',
      home: Scaffold(
        appBar: AppBar(title: Text('배터리 채널 데모 V1'),),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('배터리 잔량: 모름'),
              ElevatedButton(onPressed: _refresh, child: Text('가져오기'))
            ],
          ),
        ),
      ),
    );
  }

  void _refresh() {
    print('refresh battery level');
  }
}

