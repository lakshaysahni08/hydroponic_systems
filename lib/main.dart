import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:io';
import 'dart:async';
import 'dart:convert';
// TextEditingController emailController = new TextEditingController();

// String v1 = "";
// String v2 = "";
// String v3 = "";
// String v4 = "";
int fileCounter = 0;
late Socket socket;
TextEditingController fieldText = TextEditingController();

sendData(String text, Socket mainSocket) async {
  // socket = await Socket.connect('10.19.242.10', 5008);
  print("Sending data: $text");
  print(text);
  mainSocket.add(utf8.encode(text));
}

Future<Socket> connectSocket() async {
  print("Connecting socket");
  return await Socket.connect('10.19.242.10', 5009);
}

Future<String> getData(String text, Socket mainSocket) async {
  print("trying to connect");
  // mainSocket = await Socket.connect('10.19.242.10', 5007);
  print("text:" + text);
  String fileName = "try" + fileCounter.toString() + ".txt";

  // print(socket);
  mainSocket.listen((List<int> event) {
    //v4 = utf8.decode(event);
    print(utf8.decode(event));
  });

  // mainSocket.add(utf8.encode('1'));

  await Future.delayed(Duration(seconds: 5));
  // mainSocket.close();

  if (fileCounter < 3) {
    fileCounter++;
  } else {
    fileCounter = 0;
  }
  return await rootBundle.loadString('text_notes/' + fileName);
  // List<String> l = response_text.split(",");
  // v1 = l[0];
  // v2 = l[1];
  // v3 = l[2];
  // v4 = l[3];
  // print(response_text);
  // print(v1);
}

void main() {
  runApp(MaterialApp(
    title: 'Reading and Writing Files',
    home: MyApp(fio: FileIO()),
  ));
}

String enteredText = "";

extension HexColor on Color {
  /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  /// Prefixes a hash sign if [leadingHashSign] is set to `true` (default is `true`).
  String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${alpha.toRadixString(16).padLeft(2, '0')}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key, required this.fio}) : super(key: key);

  final FileIO fio;

  @override
  _AppState createState() => _AppState(title: "Hydroponic Monitoring System");
}

class FileIO {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/counter.txt');
  }

  Future<String> read() async {
    try {
      final file = await _localFile;

      // Read the file
      final contents = await file.readAsString();

      return contents;
    } catch (e) {
      // If encountering an error, return 0
      print(e.toString());

      return "NULL";
    }
  }
}

class _AppState extends State<MyApp> {
  _AppState({this.key, required this.title}) : super();
  final Key? key;
  final String title;

  // Future<String> data = getData("");
  List<Card> systems = [Card()];

  // setState((){
  //   data.then((value) {
  //     List<String> v1 = value.toString().split(",");
  //     systems = [
  //     Card(
  //       // elevation: 0,
  //       // color: Colors.blue,
  //       child: Padding(
  //         padding: EdgeInsets.only(top: 6.0, left: 6.0, right: 6.0, bottom: 6.0),
  //         child: ExpansionTile(
  //           title: Text('System 1'),
  //           children: <Widget>[
  //             // Text(v1),
  //             Text('Temperature: 35.5'),
  //             Text('pH: 6.7'),
  //             Text('Command: 0121230'),
  //             TextField(
  //               // controller: emailController,
  //               onChanged: (text) {
  //                 enteredText = text;
  //                 print(enteredText);
  //               },
  //               // obscureText: true,
  //               textAlign: TextAlign.left,
  //               decoration: InputDecoration(
  //                 border: InputBorder.none,
  //                 hintText: 'PLEASE ENTER YOUR command',
  //                 hintStyle: TextStyle(color: Colors.grey),
  //               ),
  //             )
  //           ],
  //         ),
  //       ),
  //     )
  //   ];
  //   });
  // });

  void clearText() {
    print("in clearText");
    fieldText.clear();
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/counter.txt');
  }

  // write

  Future<File> writeCounter(String data) async {
    final file = await _localFile;

    // Write the file
    return file.writeAsString(data);
  }

  // Future<void> _writeData() async {
  //   final _myFile = File('text_notes/data.txt');
  //   // If data.txt doesn't exist, it will be created automatically

  //   await _myFile.writeAsString(fieldText.text);
  //   fieldText.clear();
  // }

  void _onAdd() async {
    String responseText = await widget.fio.read();
    // Future<String> data = getData();
    connectSocket().then((mainSocket) {
      setState(() {
        Future<String> data = getData("", mainSocket);

        // Store this data in a local array

        var msgController = TextEditingController();
        data.then((value) {
          print("this is data:" + value);
          List<String> v1 = value.toString().split(",");
          print(v1[0]);
          systems[0] = (Card(
            child: Padding(
              padding:
                  EdgeInsets.only(top: 6.0, left: 6.0, right: 6.0, bottom: 6.0),
              child: ExpansionTile(
                title: Text('System'),
                children: <Widget>[
                  Text('TDS: ' + 769.toString()),
                  Text('Temperature: ' + 21.375.toString()),
                  Text('pH: ' + 0.068.toString()),
                  TextField(
                    // On pressing the enter key,
                    // the text should be written to a file stored in text_notes folder
                    controller: fieldText,

                    onSubmitted: (value) {
                      print(value);
                      sendData(value, mainSocket);
                      clearText();
                    },

                    // obscureText: true,
                    textAlign: TextAlign.left,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'PLEASE ENTER YOUR command',
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                  )
                ],
              ),
            ),
          ));
        });
      });
    });
  }

  // void updateData() {
  //   setState(() {

  //   });
  // }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hydroponic Monitoring System',
      home: Container(
        decoration: new BoxDecoration(color: HexColor.fromHex('#EDC7B7')),
        child: Dashboard(title: title, systems: systems, onPressed: _onAdd),
      ),
    );
  }
}

class Dashboard extends StatelessWidget {
  const Dashboard(
      {Key? key,
      required this.title,
      required this.systems,
      required this.onPressed})
      : super(key: key);

  final String title;
  final List<Card> systems;
  final void Function() onPressed;
  // final ValueChanged<String>? onSubmitted;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            AppBar(
              title: Text(
                title,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              backgroundColor: HexColor.fromHex('#EDC7B7'),
              foregroundColor: Colors.black,
              elevation: 0,
            ),
            Container(
                margin: const EdgeInsets.all(20.0),
                color: HexColor.fromHex('#C5C6C7'),
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      primary: HexColor.fromHex('#AC3B61') // background
                      ),
                  onPressed: onPressed,
                  icon: Icon(Icons.add, size: 18),
                  label: Text("New System"),
                )),
            Column(
              children: systems,
            )
          ],
        ));
  }
}


