import 'package:flutter/material.dart';
import 'package:ride_app/utils.dart';
import 'package:socket_io_client/socket_io_client.dart';

class HomePage extends StatefulWidget {
  final int id;
  final String role;
  const HomePage({ Key? key, required this.id, required this.role }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Socket socket;
  Map resDet = {};
  String status = 'pending';
  String response = "connecting to socket...";
  
  @override
  void initState() {
    initializeSockets();
    super.initState();
  }
  
  void customerDispatchRide(){
    socket.emit(CUSTOMER_RIDE_DISPATCH,
      {
        "distance": 5000,
        "time": 20,
        "pickup_longitude": -0.1869644,
        "pickup_latitude": 5.6037168,
        "drop_off_latitude": 5.6037168,
        "drop_off_longitude": -0.1869644,
      }
    );
    socket.on(CUSTOMER_RIDE_DISPATCH, (res){
      debugPrint(res.toString());
      setState(() {
        response = res['message'].toString();
        status = 'pending';
      });
    });
  }

  void updateDriverLocation(){
    socket.emit(DRIVER_LOCATION_UPDATE, {
      "longitude": -0.1869644,
      "latitude": 5.6037168,
    });
    socket.on(DRIVER_LOCATION_UPDATE, (data){
      debugPrint('res:: '+data.toString());
      setState(() {
        response = data['success'].toString();
      });
    });
  }

  void acceptRide(){
    // debugPrint('accept ride resData:: '+resDet.toString());
    socket.emit(DRIVER_RIDE_ACCEPTANCE, {
      "client_socket_id": resDet['client_socket_id'],
      "user_id": resDet['user_id'],
      "ride_id":resDet['ride_id']
    });
  }

  void startRide(){
    socket.emit(RIDE_INITIATION, {
      "ride_id": resDet['ride_id']
    });
    socket.on(RIDE_INITIATION, (data){
      debugPrint('res:: '+data.toString());
      setState(() {
        response = data['success'].toString();
      });
    });
  }

  void endRide(){
    socket.emit(RIDE_COMPLETION, {
      "ride_id": resDet['ride_id']
    });
    socket.on(RIDE_COMPLETION, (data){
      debugPrint('res:: '+data.toString());
      setState(() {
        response = data['success'].toString();
      });
    });
  }

  void cancelRide(){
    socket.emit(RIDE_CANCELLATION, {
      "ride_id": resDet['ride_id']
    });
    socket.on(RIDE_CANCELLATION, (data){
      debugPrint('res:: '+data.toString());
      setState(() {
        response = data['success'].toString();
      });
    });
  }

  void initializeSockets(){
    try {
      String driverToken = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJwYXlsb2FkIjp7InVzZXJfaWQiOjEwLCJwaG9uZV9udW1iZXIiOiIyMzMyMDQ5Mjc1OTAiLCJyb2xlIjoiZHJpdmVyIn0sImlhdCI6MTY0NzE4NDE2MiwiZXhwIjoxNjQ3NDQzMzYyfQ.ZLWsLjWkKhZkvQmRSZnv-gyXTEuvx6e48yVv25C2GLc';
      String customerToken = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJwYXlsb2FkIjp7InVzZXJfaWQiOjEsInBob25lX251bWJlciI6IjIzMzI0NTQzNjc1NyIsInJvbGUiOiJjdXN0b21lciJ9LCJpYXQiOjE2NDcxMjM5MzQsImV4cCI6MTY0NzM4MzEzNH0.SyAsYHh0ZNv0YABuFt7SP1bkp2yL8bgUdKgrGIg26LM';
      socket = io("https://kickz-staging.herokuapp.com", <String, dynamic>{
        "transports": ["websocket"],
        "autoConnect": false,
        "extraHeaders": { "Authorization": "Bearer ${widget.role == 'driver' ? driverToken : customerToken }" }
      });
      socket.on('unauthorized', (error){
        debugPrint(error);
        if (error.data.type == 'UnauthorizedError' || error.data.code == 'invalid_token') {
          // redirect user to login page perhaps?
          setState(() {
            response = 'User token has expired';
          });
        }
      });
      socket.connect();  //connect the Socket.IO Client to the Server
      //SOCKET EVENTS
      // --> listening for connection 
      socket.on('connect', (data) {
        debugPrint('connected');
        setState(() {
          status = 'success';
          response = '${widget.role} socket connected';
        });
      });

      socket.on(RIDE_ON_DISPATCH, (data){
        debugPrint('dispatch: '+data.toString());
        setState(() {
          response = 'DISPATCH: New location shared on this room';
        });
      });

      socket.on(RIDE_CANCELLATION, (data){

      });

      socket.on(RIDE_ON_TRIP, (data){
        debugPrint('ontrip: '+data.toString());
        setState(() {
          response = 'ONTRIP: New location shared on this room';
        });
      });

      socket.on(DRIVER_RIDE_ACCEPTANCE, (data){
        debugPrint('driver acceptance: '+ data.toString());
        setState(() {
          resDet = data;
          status = 'success';
          response = widget.role == 'driver' ? 
          'You are assigned to a customer':'A driver has been assigned to you.';
        });
      });
      
      socket.on(RIDE_REQUEST_DRIVER_NOTIFICATION, (data){
        debugPrint('notification init: ${data.toString()}');
        setState(() {
          status = 'pending';
          response = 'A new ride request available. Accept ride';
          resDet = data;
        });
      });
      //listens when the client is disconnected from the Server 
      socket.on('disconnect', (data) {
        debugPrint('disconnect" '+data);
      });
    } catch (e) {
      debugPrint('err ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController _promoCodeController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.role} dashboard -- id:${widget.id}'),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _promoCodeController,
                decoration: const InputDecoration(
                  hintText: 'Enter promo code if any'
                ),
              ),
              Text(response, style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold,
                  color: status == 'success' ? Colors.green 
                  : status == 'failed' ? Colors.red :
                  Colors.amber 
                )
              ),
              const SizedBox(height: 20),
              TextButton(
                child: const Text('customer ride dispatch', style: TextStyle(color: Colors.white),),
                onPressed: (){
                  customerDispatchRide();
                }, 
                style: TextButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 18)
                ),
              ),
              const SizedBox(height: 20),
              TextButton(
                child: const Text('end ride', style: TextStyle(color: Colors.white),),
                onPressed: (){
                  endRide();
                }, 
                style: TextButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 18)
                ),
              ),
              const SizedBox(height: 20),
              TextButton(
                child: const Text('cancel ride', style: TextStyle(color: Colors.white),),
                onPressed: (){
                  cancelRide();
                }, 
                style: TextButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 18)
                ),
              ),
              const SizedBox(height: 20),
              TextButton(
                child: const Text('update location', style: TextStyle(color: Colors.white),),
                onPressed: (){
                  updateDriverLocation();
                }, 
                style: TextButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 18)
                ),
              ),
              const SizedBox(height: 20),
              TextButton(
                child: const Text('start ride', style: TextStyle(color: Colors.white),),
                onPressed: (){
                  startRide();
                }, 
                style: TextButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 18)
                ),
              ),
              const SizedBox(height: 20),
              TextButton(
                child: const Text('accept ride', style: TextStyle(color: Colors.white),),
                onPressed: (){
                  acceptRide();
                }, 
                style: TextButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 18)
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}