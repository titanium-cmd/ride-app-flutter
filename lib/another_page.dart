import 'package:flutter/material.dart';
import 'package:ride_app/socket.dart';
import 'package:socket_io_client/socket_io_client.dart';

class AnotherPage extends StatefulWidget {
  const AnotherPage({ Key? key }) : super(key: key);

  @override
  State<AnotherPage> createState() => _AnotherPageState();
}

class _AnotherPageState extends State<AnotherPage> {
  late Socket? socket;
  @override
  void initState() {
    socket = SocketHelper().connectSocket();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('another page: ${socket!.id}');
    return Scaffold(
      
    );
  }
}