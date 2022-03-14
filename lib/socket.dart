import 'package:flutter/material.dart';
import 'package:ride_app/utils.dart';
import 'package:socket_io_client/socket_io_client.dart';

class SocketHelper extends ChangeNotifier{
  static late Socket socket;
  String _response = 'connecting to socket...';

  void setMessage(String msg) {
    _response = '';
    _response = msg;
    notifyListeners();
  }
  String get response => _response;

  Socket? connectSocket(){
    try {
      String driverToken = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJwYXlsb2FkIjp7InVzZXJfaWQiOjEsInBob25lX251bWJlciI6IjIzMzI0NTQzNjc1NyIsInJvbGUiOiJjdXN0b21lciJ9LCJpYXQiOjE2NDcxMjM5MzQsImV4cCI6MTY0NzM4MzEzNH0.SyAsYHh0ZNv0YABuFt7SP1bkp2yL8bgUdKgrGIg26LM';
      String customerToken = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJwYXlsb2FkIjp7InVzZXJfaWQiOjEsInBob25lX251bWJlciI6IjIzMzI0NTQzNjc1NyIsInJvbGUiOiJjdXN0b21lciJ9LCJpYXQiOjE2NDcxMjM5MzQsImV4cCI6MTY0NzM4MzEzNH0.SyAsYHh0ZNv0YABuFt7SP1bkp2yL8bgUdKgrGIg26LM';
      // String driverToken = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJwYXlsb2FkIjp7InVzZXJfaWQiOjEwLCJwaG9uZV9udW1iZXIiOiIyMzMyMDQ5Mjc1OTAiLCJyb2xlIjoiZHJpdmVyIn0sImlhdCI6MTY0NzE4NDE2MiwiZXhwIjoxNjQ3NDQzMzYyfQ.ZLWsLjWkKhZkvQmRSZnv-gyXTEuvx6e48yVv25C2GLc';
      // String customerToken = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJwYXlsb2FkIjp7InVzZXJfaWQiOjEsInBob25lX251bWJlciI6IjIzMzI0NTQzNjc1NyIsInJvbGUiOiJjdXN0b21lciJ9LCJpYXQiOjE2NDcxMjM5MzQsImV4cCI6MTY0NzM4MzEzNH0.SyAsYHh0ZNv0YABuFt7SP1bkp2yL8bgUdKgrGIg26LM';
      socket = io("https://kickz-staging.herokuapp.com", <String, dynamic>{
        "transports": ["websocket"],
        "autoConnect": false,
        "extraHeaders": { "Authorization": "Bearer $driverToken}" }
      });
      
      socket.on('unauthorized', (error){
        debugPrint(error);
        if (error.data.type == 'UnauthorizedError' || error.data.code == 'invalid_token') {
          // redirect user to login page perhaps?
          // setState(() {
            setMessage('User token has expired');
          notifyListeners();
          // });
        }
      });
      socket.connect();  //connect the Socket.IO Client to the Server
      //SOCKET EVENTS
      // --> listening for connection 
      socket.on('connect', (data) {
        debugPrint('connected');
        // setState(() {
        //   status = 'success';
        setMessage('socket connected');
        // });
        notifyListeners();
      });

      socket.on(RIDE_ON_DISPATCH, (data){
        debugPrint('dispatch: '+data.toString());
        // setState(() {
          setMessage('DISPATCH: New location shared on this room');
        notifyListeners();
        // });
      });

      socket.on(RIDE_CANCELLATION, (data){

      });

      socket.on(RIDE_ON_TRIP, (data){
        debugPrint('ontrip: '+data.toString());
        // setState(() {
        _response = 'ONTRIP: New location shared on this room';
        notifyListeners();
        // });
      });

      socket.on(DRIVER_RIDE_ACCEPTANCE, (data){
        debugPrint('driver acceptance: '+ data.toString());
        // setState(() {
        //   resDet = data;
        //   status = 'success';
        // _response = role == 'driver' ? 'A driver would be assigned to you soon':'Hello World';
        notifyListeners();
        //   'You are assigned to a customer':'A driver has been assigned to you.';
        // });
      });
      
      socket.on(RIDE_REQUEST_DRIVER_NOTIFICATION, (data){
        debugPrint('notification init: ${data.toString()}');
        // setState(() {
        //   status = 'pending';
        _response = 'A new ride request available. Accept ride';
        notifyListeners();
        //   resDet = data;
        // });
      });
      //listens when the client is disconnected from the Server 
      socket.on('disconnect', (data) {
        _response = 'A new ride request available. Accept ride';
        notifyListeners();
        debugPrint('disconnect" '+data);
      });
      return socket;
    } catch (e) {
      debugPrint('err ${e.toString()}');
      return null;
    }
  }

  void add() {

    notifyListeners();
  }

  void removeAll() {

    notifyListeners();
  }
}