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
  TextEditingController emailController = TextEditingController();
  TextEditingController patientIdController = TextEditingController();

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
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'For Additional Security ReEnter Email'),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: patientIdController,
              decoration: InputDecoration(labelText: 'For Additional Security ReEnter Password'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                _decryptAndShowData();
              },
              child: Text('Tap to view Records'),
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
    String enteredEmail = emailController.text.trim();
    String enteredPatientId = patientIdController.text.trim();

    QuerySnapshot<Map<String, dynamic>> querySnapshot =
    await _encryptedDataCollection
        .where('Email', isEqualTo: enteredEmail)
        .where('Patient ID', isEqualTo: enteredPatientId)
        .limit(1)
        .get() as QuerySnapshot<Map<String, dynamic>>; // Specify the type

    if (querySnapshot.docs.isNotEmpty) {
      Map<String, dynamic>? encryptedData = querySnapshot.docs.first.data();
      decryptedDataList.clear();
      if (encryptedData != null) {
        decryptedDataList.addAll([
          AESAlgorithm.decryptData(encryptedData['Full Name'] ?? ''),
          _decryptAge(encryptedData['Age']),
          AESAlgorithm.decryptData(encryptedData['Gender'] ?? ''),
          AESAlgorithm.decryptData(encryptedData['Contact Number'] ?? ''),
          encryptedData['Patient ID'] ?? '',
          enteredEmail,
          AESAlgorithm.decryptData(encryptedData['Address'] ?? ''),
          AESAlgorithm.decryptData(encryptedData['Blood Group'] ?? ''),
          AESAlgorithm.decryptData(encryptedData['Medical History'] ?? ''),
        ]);
      } else {
        // Handle case when encryptedData is null
        // For example, show a snackbar or display a message to the user
      }

      setState(() {});
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No data found for the provided email and patient ID.'),
        ),
      );
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