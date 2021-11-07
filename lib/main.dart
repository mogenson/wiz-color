import 'package:flutter/material.dart';
import 'package:flutter_circle_color_picker/flutter_circle_color_picker.dart';
import 'dart:io';
import 'dart:convert';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Color _currentColor = Colors.pink;
  final _controller = CircleColorPickerController(
    initialColor: Colors.pink,
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wiz Color',
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: _currentColor,
          title: Text('Wiz Color'),
          centerTitle: true,
        ),
        body: Center(
          child: CircleColorPicker(
            controller: _controller,
            onChanged: (color) {
              setState(() => _currentColor = color);
            },
            onEnded: (color) {
              final command =
                  '{"method":"setPilot","params":{"r":${color.red},"g":${color.green},"b":${color.blue}}}';
              print(command);
              RawDatagramSocket.bind(InternetAddress.anyIPv4, 38899)
                  .then((socket) {
                socket.broadcastEnabled = true;
                socket.send(utf8.encode(command),
                    InternetAddress('255.255.255.255'), 38899);
                socket.close();
              });
            },
          ),
        ),
      ),
    );
  }
}
