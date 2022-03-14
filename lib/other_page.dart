import 'package:flutter/material.dart';
import 'package:ride_app/another_page.dart';
import 'package:ride_app/socket.dart';
import 'package:socket_io_client/socket_io_client.dart';

class OtherPage extends StatefulWidget {
  const OtherPage({ Key? key }) : super(key: key);

  @override
  State<OtherPage> createState() => _OtherPageState();
}

class _OtherPageState extends State<OtherPage> {
  late Socket? socket;

  @override
  void initState() {
    socket = SocketHelper().connectSocket();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    debugPrint('other page: ${socket!.id}');
    return Scaffold(
      body: Center(child: TextButton(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (builder) => AnotherPage())), 
        child: const Text('Next Page')),
      ),
    );
  }
}