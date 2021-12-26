import 'dart:io';

void main() {
  print("Hello Dart");

  int a = 100;
  int b = 200;
  int c = _getBigger(a, b);
  print('_getBigger(a, b) = $c');

  stdout.write('Enter name? ');
  String? input = stdin.readLineSync();
  print('Hello $input');

  File diary = new File('diary.txt');
  String contents = """
  2021.12.24 크리스마스 이브
  플러터 공부
  """;
  diary.writeAsStringSync(contents);

  List<String> diaryContents = diary.readAsLinesSync();
  for (String line in diaryContents) {
    print(line);
  }
}

int _getBigger(int a, int b) {
  if (a >= b) return a;
  return b;
}