import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'aesAlgorithm.dart';

class AESEncryptionPage extends StatefulWidget {
  @override
  _AESEncryptionPageState createState() => _AESEncryptionPageState();
}

class _AESEncryptionPageState extends State<AESEncryptionPage> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _contactNumberController = TextEditingController();
  final TextEditingController _patientIdController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _bloodGroupController = TextEditingController();
  final TextEditingController _medicalHistoryController = TextEditingController();

  CollectionReference _encryptedDataCollection =
  FirebaseFirestore.instance.collection('Patients');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.greenAccent,
        title: Text('Enter Patient Details'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _fullNameController,
                decoration: InputDecoration(labelText: 'Full Name'),
              ),
              TextFormField(
                controller: _ageController,
                decoration: InputDecoration(labelText: 'Age'),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _genderController,
                decoration: InputDecoration(labelText: 'Gender'),
              ),
              TextFormField(
                controller: _contactNumberController,
                decoration: InputDecoration(labelText: 'Contact Number'),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _patientIdController,
                decoration: InputDecoration(labelText: 'Patient ID'),
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
              ),
              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(labelText: 'Address'),
              ),
              TextFormField(
                controller: _bloodGroupController,
                decoration: InputDecoration(labelText: 'Blood Group'),
              ),
              TextFormField(
                controller: _medicalHistoryController,
                decoration: InputDecoration(labelText: 'Medical History'),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.lightBlueAccent)),
                onPressed: () async {
                  await _encryptData();
                  await _createFirebaseUser();
                },
                child: Text('Encrypt and Save',style: TextStyle(color: Colors.black)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _encryptData() async {
    String fullName = _fullNameController.text;
    int age = int.tryParse(_ageController.text) ?? 0;
    String gender = _genderController.text;
    int contactNumber = int.tryParse(_contactNumberController.text) ?? 0;
    String patientId = _patientIdController.text;
    String email = _emailController.text;
    String address = _addressController.text;
    String bloodGroup = _bloodGroupController.text;
    String medicalHistory = _medicalHistoryController.text;

    // Encrypting data
    String encryptedFullName = AESAlgorithm.encryptData(fullName);
    String encryptedGender = AESAlgorithm.encryptData(gender);
    String encryptedAddress = AESAlgorithm.encryptData(address);
    String encryptedBloodGroup = AESAlgorithm.encryptData(bloodGroup);
    String encryptedMedicalHistory = AESAlgorithm.encryptData(medicalHistory);
    String encryptedContactNumber = AESAlgorithm.encryptData(contactNumber.toString());
    String encryptedAge = AESAlgorithm.encryptData(age.toString());

    // Storing encrypted data in Firestore
    await _storeEncryptedData(
      email,
      {
        'Full Name': encryptedFullName,
        'Age': encryptedAge,
        'Gender': encryptedGender,
        'Contact Number': encryptedContactNumber,
        'Patient ID': patientId,
        'Email': email,
        'Address': encryptedAddress,
        'Blood Group': encryptedBloodGroup,
        'Medical History': encryptedMedicalHistory,
      },
    );
  }

  Future<void> _storeEncryptedData(String email, Map<String, dynamic> encryptedData) async {
    await _encryptedDataCollection.doc(email).set(encryptedData);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Data encrypted and saved successfully!'),
    ));
  }

  Future<void> _createFirebaseUser() async {
    try {
      String email = _emailController.text;
      String password = _patientIdController.text;

      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      print('User created: ${userCredential.user!.uid}');
    } catch (e) {
      print('Error creating user: $e');
      // Handle the error as needed
    }
  }
}