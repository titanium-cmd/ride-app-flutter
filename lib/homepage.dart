import 'package:flutter/material.dart';
import 'package:ride_app/socket.dart';
import 'package:ride_app/utils.dart';
import 'package:socket_io_client/socket_io_client.dart';

class HomePage extends StatefulWidget {
  const HomePage({ Key? key }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Socket? socket;
  Map resDet = SocketHelper().getData;
  String status = 'pending';
  String response = "connecting to socket...";
  
  @override
  void initState() {
    socket = SocketHelper().connectSocket();
    super.initState();
  }
  
  void rideRequest(){
    socket!.emit(customerRideRequest,
      {
        "vehicle_id":1,
        "pickup_longitude":-0.220942,
        "pickup_latitude":5.604452,
        "drop_off_latitude":5.554162300000001,
        "drop_off_longitude":-0.1843724,
        "distance":11096,
        "time":1490,
        "origin_description":
        "Onyankle Street, Ablenkpe",
        "destination_description":
        "Osu Presby Church Hall, Oxford Street, Accra, Ghana"
      }
    );
  }

  void cancelRide(){
    socket!.emit(rideCancellation, {
      "ride_id": resDet['ride_id']
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('dashboard -- socket id:${socket!.id}'),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(SocketHelper().response, style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold,
                  color: status == 'success' ? Colors.green 
                  : status == 'failed' ? Colors.red :
                  Colors.amber 
                )
              ),
              const SizedBox(height: 20),
              TextButton(
                child: const Text('customer ride request', style: TextStyle(color: Colors.white),),
                onPressed: (){
                  rideRequest();
                }, 
                style: TextButton.styleFrom(
                  backgroundColor: Colors.blue,
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
            ],
          ),
        ),
      ),
    );
  }
}