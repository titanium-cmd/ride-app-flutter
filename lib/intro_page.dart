import 'package:flutter/material.dart';
import 'package:ride_app/homepage.dart';

class IntroPage extends StatelessWidget {
  const IntroPage({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController _roleController = TextEditingController();
    final TextEditingController _idController = TextEditingController();
    return Scaffold(
      body: Center(
        child: Form(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 35),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: _roleController,
                  decoration: const InputDecoration(
                    hintText: 'Enter role'
                  ),
                ),
                TextFormField(
                  controller: _idController,
                  decoration: const InputDecoration(
                    hintText: 'Enter id'
                  ),
                ),
              TextButton(
                child: const Text('Continue', style: TextStyle(color: Colors.white),),
                onPressed: (){
                  Navigator.push(
                    context, 
                    MaterialPageRoute(builder: ((context) => HomePage(
                      id: int.parse(_idController.text), role: _roleController.text
                      ))
                    )
                  );
                }, 
                style: TextButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 18)
                ),
              )
              ],
            ),
          )
        )
      ),
    );
  }
}