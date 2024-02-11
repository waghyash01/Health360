import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'Doctor.dart';
import 'grid.dart';
import 'list.dart';
import 'newuser.dart';
import 'patient.dart';
import 'regulatory.dart';
import 'login.dart';
import 'regulatory.dart';
import 'firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    name: 'Health360',
    options: DefaultFirebaseOptions.currentPlatform,


  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Patientpage()
      
    );
  }
}
