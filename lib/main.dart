import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ride_app/homepage.dart';
import 'package:ride_app/intro_page.dart';
import 'package:ride_app/socket.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => SocketHelper(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const IntroPage()
    );
  }
}