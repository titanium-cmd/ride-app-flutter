import 'package:flutter/material.dart';
import 'package:ride_app/utils.dart';
import 'package:socket_io_client/socket_io_client.dart';

class SocketHelper extends ChangeNotifier{
  static late Socket socket;
  String _response = 'connecting to socket...';
  static Map resData = {};

  void setMessage(String msg) {
    _response = '';
    _response = msg;
    notifyListeners();
  }

  Map get getData => resData;
  
  String get response => _response;

  Socket? connectSocket({String? role}){
    try {
      String customerToken = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJwYXlsb2FkIjp7InVzZXJfaWQiOjEsInBob25lX251bWJlciI6IjIzMzU1NjUxMDU1NSIsInJvbGUiOiJjdXN0b21lciJ9LCJpYXQiOjE2NDc0NTE1NTEsImV4cCI6MTY0NzcxMDc1MX0.mUo7vnMIcnIFM191O1m3-TujSJaO1dknkzBgjE91_EE';
      socket = io("ws://10.0.2.2:4000", <String, dynamic>{
      // socket = io("https://kickz-staging.herokuapp.com", <String, dynamic>{
        "transports": ["websocket"],
        "autoConnect": false,
        // "extraHeaders": { "Authorization": "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJwYXlsb2FkIjp7InVzZXJfaWQiOjEsInBob25lX251bWJlciI6IjIzMzU1NjUxMDU1NSIsInJvbGUiOiJjdXN0b21lciJ9LCJpYXQiOjE2NDczNjc0OTQsImV4cCI6MTY0NzYyNjY5NH0.AjPj_95XSyyIdNI5REpM12RN4nrN6PkKDgwOjxkngsU" }
        "extraHeaders": { "Authorization": "Bearer $customerToken" }
      });
      
      socket.on('unauthorized', (error){
        debugPrint(error);
        if (error.data.type == 'UnauthorizedError' || error.data.code == 'invalid_token') {
          setMessage('User token has expired');
          notifyListeners();
        }
      });
      socket.connect();  //connect the Socket.IO Client to the Server
      //SOCKET EVENTS
      // --> listening for connection 
      socket.on('connect', (data) {
        debugPrint('connected');
        setMessage('socket connected');
        notifyListeners();
      });

      socket.on(rideOnDispatch, (data){
        debugPrint('dispatch: '+data.toString());
        setMessage('DISPATCH: New location shared on this room');
        notifyListeners();
      });

      socket.on(rideCancellation, (data){

      });

      socket.on(rideOnTrip, (data){
        debugPrint('ontrip: '+data.toString());
        _response = 'ONTRIP: New location shared on this room';
        notifyListeners();
      });

      //listens when the client is disconnected from the Server 
      socket.on('disconnect', (data) {
        notifyListeners();
        debugPrint('disconnect" '+data);
      });
      return socket;
    } catch (e) {
      debugPrint('err ${e.toString()}');
      return null;
    }
  }
}