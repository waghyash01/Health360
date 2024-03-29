import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sampleandro/Doctor.dart';
import 'package:sampleandro/patient.dart';

import 'Guidelines.dart';

class UserTypeSelectionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.greenAccent,
        title: Text('Select User'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                //print("hello");
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PatientLoginPage()),
                );
              },
              child: Column(
                children: [
                  Container(child: Image.asset('assets/images/user.jpg',fit: BoxFit.cover, height:100 , width:100)),// Add Patient image
                  SizedBox(height: 8.0),
                  Text('Patient'),
                ],
              ),
            ),
            SizedBox(height: 70.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DoctorLoginPage()),
                );
              },
              child: Column(
                children: [
                  Image.asset('assets/images/doctor.png', height: 100, width: 100), // Add Doctor image
                  SizedBox(height: 8.0),
                  Text('Doctor'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PatientLoginPage extends StatelessWidget {
  final TextEditingController loginEmailController = TextEditingController();
  final TextEditingController loginPatientIdController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.greenAccent,
        title: Text('Patient Login'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: loginEmailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            SizedBox(height: 8.0),
            TextField(
              controller: loginPatientIdController,
              decoration: InputDecoration(labelText: 'Password'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.greenAccent)),
              onPressed: () {
                login(context, 'Patients', loginEmailController.text, loginPatientIdController.text);
              },
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }

  void login(BuildContext context, String collection, String email, String patientId) async {
    try {
      var result = await FirebaseFirestore.instance.collection(collection).where('Email', isEqualTo: email).where('Patient ID', isEqualTo: patientId).get();

      if (result.docs.isNotEmpty) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Patientpage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Invalid login credentials. Patient not found.'),
        ));
      }
    } catch (e) {
      print('Error during login: $e');
    }
  }
}

class DoctorLoginPage extends StatelessWidget {
  final TextEditingController loginNameController = TextEditingController();
  final TextEditingController loginUidController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.greenAccent,
        title: Text('Doctor Login'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: loginNameController,
              decoration: InputDecoration(labelText: 'Doctor Name'),
            ),
            SizedBox(height: 8.0),
            TextField(
              controller: loginUidController,
              decoration: InputDecoration(labelText: 'Password'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.greenAccent)),
              onPressed: () {
                login(context, 'Doctors', loginNameController.text, loginUidController.text);
              },
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }

  void login(BuildContext context, String collection, String name, String uid) async {
    try {
      var result = await FirebaseFirestore.instance.collection(collection).where('Name', isEqualTo: name).where('UID', isEqualTo: uid).get();

      if (result.docs.isNotEmpty) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => GuidelinesPage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Invalid login credentials. Doctor not found.'),
        ));
      }
    } catch (e) {
      print('Error during login: $e');
    }
  }
}

class HomeScreen extends StatelessWidget {
  final String userType;

  HomeScreen({required this.userType});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Screen - $userType'),
      ),
      body: Center(
        child: Text('Welcome to the Home Screen, $userType!'),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: UserTypeSelectionPage(),
  ));
}




// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:sampleandro/Doctor.dart';
// import 'package:sampleandro/patient.dart';
//
// class UserTypeSelectionPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.greenAccent,
//         title: Text('Select User'),
//
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => PatientLoginPage()),
//                 );
//               },
//               child: Text('Patient'),
//
//             ),
//             SizedBox(height: 16.0),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => DoctorLoginPage()),
//                 );
//               },
//               child: Text('Doctor'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class PatientLoginPage extends StatelessWidget {
//   final TextEditingController loginEmailController = TextEditingController();
//   final TextEditingController loginPatientIdController = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.greenAccent,
//         title: Text('Patient Login'),
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             TextField(
//               controller: loginEmailController,
//               decoration: InputDecoration(labelText: 'Email'),
//             ),
//             SizedBox(height: 8.0),
//             TextField(
//               controller: loginPatientIdController,
//               decoration: InputDecoration(labelText: 'Patient ID'),
//             ),
//             SizedBox(height: 16.0),
//             ElevatedButton(
//               style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.greenAccent)),
//               onPressed: () {
//                 login(context, 'Patients', loginEmailController.text, loginPatientIdController.text);
//               },
//               child: Text('Login'),
//
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   void login(BuildContext context, String collection, String email, String patientId) async {
//     try {
//       var result = await FirebaseFirestore.instance.collection(collection).where('Email', isEqualTo: email).where('Patient ID', isEqualTo: patientId).get();
//
//       if (result.docs.isNotEmpty) {
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => Patientpage()),
//         );
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//           content: Text('Invalid login credentials. Patient not found.'),
//         ));
//       }
//     } catch (e) {
//       print('Error during login: $e');
//     }
//   }
// }
//
// class DoctorLoginPage extends StatelessWidget {
//   final TextEditingController loginNameController = TextEditingController();
//   final TextEditingController loginUidController = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.greenAccent,
//         title: Text('Doctor Login'),
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             TextField(
//               controller: loginNameController,
//               decoration: InputDecoration(labelText: 'Doctor Name'),
//             ),
//             SizedBox(height: 8.0),
//             TextField(
//               controller: loginUidController,
//               decoration: InputDecoration(labelText: 'Doctor UID'),
//             ),
//             SizedBox(height: 16.0),
//             ElevatedButton(
//               style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.greenAccent)),
//               onPressed: () {
//                 login(context, 'Doctors', loginNameController.text, loginUidController.text);
//               },
//               child: Text('Login'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   void login(BuildContext context, String collection, String name, String uid) async {
//     try {
//       var result = await FirebaseFirestore.instance.collection(collection).where('Name', isEqualTo: name).where('UID', isEqualTo: uid).get();
//
//       if (result.docs.isNotEmpty) {
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => Doctorpage()),
//         );
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//           content: Text('Invalid login credentials. Doctor not found.'),
//         ));
//       }
//     } catch (e) {
//       print('Error during login: $e');
//     }
//   }
// }
//
// class HomeScreen extends StatelessWidget {
//   final String userType;
//
//   HomeScreen({required this.userType});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Home Screen - $userType'),
//       ),
//       body: Center(
//         child: Text('Welcome to the Home Screen, $userType!'),
//       ),
//     );
//   }
// }
//
// void main() {
//   runApp(MaterialApp(
//     home: UserTypeSelectionPage(),
//   ));
// }