import 'package:flutter/material.dart';

class HelloTextPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor:Color(0xff2F2E40) ,
        title: Text('Hello',style: TextStyle(color: Colors.white),),
      ),
      body: Center(
        child: Text(
          'Hello',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
