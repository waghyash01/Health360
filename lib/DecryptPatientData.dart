import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'aesAlgorithm.dart';
import 'package:firebase_auth/firebase_auth.dart';

List<String> patientdetails = [
  'Full Name',
  'Age',
  'Gender',
  'Contact Number',
  'Patient Id',
  'Email',
  'Address',
  'Blood Group',
  'Medical History',
];

class AESDecryptionPage extends StatefulWidget {
  @override
  _AESDecryptionPageState createState() => _AESDecryptionPageState();
}

class _AESDecryptionPageState extends State<AESDecryptionPage> {
  CollectionReference _encryptedDataCollection =
  FirebaseFirestore.instance.collection('Patients');
  List<String> decryptedDataList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.greenAccent,
        title: Text('Your Records'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            InkWell(
              onTap: () {
                _decryptAndShowData();
              },
              child: Container(
                padding: EdgeInsets.all(16.0),
                color: Colors.lightBlueAccent,
                child: Text(
                  'Tap to view Records',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            Expanded(
              child: ListView.builder(
                itemCount: decryptedDataList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(patientdetails[index]),
                    subtitle: Text(decryptedDataList[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _decryptAndShowData() async {
    // Retrieve the currently authenticated user
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // Retrieve the email of the authenticated user
      String loggedInUserEmail = user.email ?? '';

      // Retrieve encrypted data from Firestore using the logged-in user's email as the document ID
      DocumentSnapshot<Map<String, dynamic>> snapshot =
      await _encryptedDataCollection.doc(loggedInUserEmail).get()
      as DocumentSnapshot<Map<String, dynamic>>; // Explicitly specify the type

      if (snapshot.exists) {
        // Decrypt the encrypted data
        Map<String, dynamic>? encryptedData = snapshot.data(); // Change type to nullable
        decryptedDataList.clear();
        if (encryptedData != null) {
          decryptedDataList.addAll([
            AESAlgorithm.decryptData(encryptedData['Full Name'] ?? ''),
            _decryptAge(encryptedData['Age']),
            AESAlgorithm.decryptData(encryptedData['Gender'] ?? ''),
            AESAlgorithm.decryptData(encryptedData['Contact Number'] ?? ''),
            encryptedData['Patient Id'] ?? '',
            loggedInUserEmail, // Display the logged-in user's email
            AESAlgorithm.decryptData(encryptedData['Address'] ?? ''),
            AESAlgorithm.decryptData(encryptedData['Blood Group'] ?? ''),
            AESAlgorithm.decryptData(encryptedData['Medical History'] ?? ''),
            // Add decryption for other fields here
          ]);
        } else {
          // Handle case when encryptedData is null
          // For example, show a snackbar or display a message to the user
        }

        setState(() {});
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'No encrypted data found for the logged-in user!'),
          ),
        );
      }
    }
  }

  String _decryptAge(dynamic ageData) {
    if (ageData is int) {
      // If age is already an integer, return it as a string
      return ageData.toString();
    } else {
      // If age is not an integer, decrypt it
      return AESAlgorithm.decryptData(ageData.toString());
    }
  }
}



// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'aesAlgorithm.dart';
//
// List<String> patientdetails = [
//   'Full Name',
//   'Age',
//   'Gender',
//   'Contact Number',
//   'Patient Id',
//   'Email',
//   'Address',
//   'Blood Group',
//   'Medical History',
// ];
//
// class AESDecryptionPage extends StatefulWidget {
//   @override
//   _AESDecryptionPageState createState() => _AESDecryptionPageState();
// }
//
// class _AESDecryptionPageState extends State<AESDecryptionPage> {
//   CollectionReference _encryptedDataCollection =
//   FirebaseFirestore.instance.collection('encrypted_data');
//   List<String> decryptedDataList = [];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('AES Encryption Demo'),
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             InkWell(
//               onTap: () {
//                 _decryptAndShowData();
//               },
//               child: Container(
//                 padding: EdgeInsets.all(16.0),
//                 color: Colors.blue,
//                 child: Text(
//                   'Tap here to view your encrypted data',
//                   style: TextStyle(color: Colors.white),
//                 ),
//               ),
//             ),
//             SizedBox(height: 16.0),
//             Expanded(
//               child: ListView.builder(
//                 itemCount: decryptedDataList.length,
//                 itemBuilder: (context, index) {
//                   return ListTile(
//                     title: Text(patientdetails[index]),
//                     subtitle: Text(decryptedDataList[index]),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Future<void> _decryptAndShowData() async {
//     // Retrieve the logged-in user's email
//     String loggedInUserEmail = 'kom@gmail.com';
//
//     // Retrieve encrypted data from Firestore using the logged-in user's email as the document ID
//     DocumentSnapshot<Map<String, dynamic>> snapshot =
//     await _encryptedDataCollection.doc(loggedInUserEmail).get()
//     as DocumentSnapshot<Map<String, dynamic>>; // Explicitly specify the type
//
//     if (snapshot.exists) {
//       // Decrypt the encrypted data
//       Map<String, dynamic>? encryptedData = snapshot.data(); // Change type to nullable
//       decryptedDataList.clear();
//       if (encryptedData != null) {
//         decryptedDataList.addAll([
//           AESAlgorithm.decryptData(encryptedData['Full Name'] ?? ''),
//           _decryptAge(encryptedData['Age']),
//           AESAlgorithm.decryptData(encryptedData['Gender'] ?? ''),
//           AESAlgorithm.decryptData(encryptedData['Contact Number'] ?? ''),
//           encryptedData['Patient Id'] ?? '',
//           loggedInUserEmail, // Display the logged-in user's email
//           AESAlgorithm.decryptData(encryptedData['Address'] ?? ''),
//           AESAlgorithm.decryptData(encryptedData['Blood Group'] ?? ''),
//           AESAlgorithm.decryptData(encryptedData['Medical History'] ?? ''),
//           // Add decryption for other fields here
//         ]);
//       } else {
//         // Handle case when encryptedData is null
//         // For example, show a snackbar or display a message to the user
//       }
//
//       setState(() {});
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('No encrypted data found for the logged-in user!'),
//         ),
//       );
//     }
//   }
//
//   String _decryptAge(dynamic ageData) {
//     if (ageData is int) {
//       // If age is already an integer, return it as a string
//       return ageData.toString();
//     } else {
//       // If age is not an integer, decrypt it
//       return AESAlgorithm.decryptData(ageData.toString());
//     }
//   }
// }
