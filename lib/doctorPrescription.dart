import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'aesAlgorithm.dart'; // Import the AESAlgorithm class

class WritePrescriptionPage extends StatefulWidget {
  @override
  _WritePrescriptionPageState createState() => _WritePrescriptionPageState();
}

class _WritePrescriptionPageState extends State<WritePrescriptionPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController patientIDController = TextEditingController();
  final TextEditingController prescriptionController = TextEditingController();
  final TextEditingController checkupDateController = TextEditingController();
  final TextEditingController doctorNameController = TextEditingController(); // Add doctorNameController

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.greenAccent,
        title: Text('Write Prescription'),
      ),
      body: Container(
        margin: EdgeInsets.only(top: 15),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'Your Email'),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: patientIDController,
                decoration: InputDecoration(labelText: 'Patient ID'),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: prescriptionController,
                decoration: InputDecoration(labelText: 'Prescription Details'),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: checkupDateController,
                decoration: InputDecoration(labelText: 'Checkup Date'),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: doctorNameController,
                decoration: InputDecoration(labelText: 'Doctor Name'), // Add doctor name field
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.lightBlueAccent)),
                onPressed: () {
                  validateAndWritePrescription(context);
                },
                child: Text('Submit Prescription', style: TextStyle(color: Colors.black)),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.lightBlueAccent)),
                onPressed: () {
                  // Check if the entered email and patient ID match before navigating
                  validatePatient(emailController.text, patientIDController.text).then((isValid) {
                    if (isValid) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PrescriptionHistoryPage(
                          email: emailController.text,
                          patientID: patientIDController.text,
                        )),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Invalid email or patient ID.'),
                        ),
                      );
                    }
                  });
                },
                child: Text('History', style: TextStyle(color: Colors.black)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void validateAndWritePrescription(BuildContext context) async {
    String enteredEmail = emailController.text;
    String enteredPatientID = patientIDController.text;

    // Check if the entered email and patient ID match a document in the Patients collection
    bool isValid = await validatePatient(enteredEmail, enteredPatientID);
    if (isValid) {
      String prescriptionDetails = prescriptionController.text;
      String checkupDate = checkupDateController.text;
      String doctorName = doctorNameController.text; // Retrieve doctor name

      // Encrypt prescription details, checkup date, doctor name, and patient ID before storing
      String encryptedPrescriptionDetails = AESAlgorithm.encryptData(prescriptionDetails);
      String encryptedCheckupDate = AESAlgorithm.encryptData(checkupDate);
      String encryptedDoctorName = AESAlgorithm.encryptData(doctorName);
      String encryptedPatientID = AESAlgorithm.encryptData(enteredPatientID); // Encrypt patient ID

      // Add encrypted prescription to a subcollection within the patient's document
      await FirebaseFirestore.instance
          .collection('Patients')
          .doc(enteredEmail)
          .collection('Prescriptions')
          .add({
        'patientID': encryptedPatientID, // Store encrypted patient ID
        'prescriptionDetails': encryptedPrescriptionDetails,
        'checkupDate': encryptedCheckupDate,
        'doctorName': encryptedDoctorName,
      });

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Prescription added successfully!'),
        ),
      );
    } else {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Invalid email or patient ID.'),
        ),
      );
    }
  }

  Future<bool> validatePatient(String email, String patientID) async {
    try {
      DocumentSnapshot patientSnapshot =
      await FirebaseFirestore.instance.collection('Patients').doc(email).get();
      print('Patient snapshot exists: ${patientSnapshot.exists}');
      if (patientSnapshot.exists) {
        Map<String, dynamic> patientData = patientSnapshot.data() as Map<String, dynamic>;
        String? storedPatientID = patientData['Patient ID']; // Adjusted field name
        print('Stored Patient ID: $storedPatientID');
        print('Entered Patient ID: $patientID');
        return storedPatientID != null && storedPatientID == patientID;
      } else {
        return false;
      }
    } catch (e) {
      print('Error validating patient: $e');
      return false;
    }
  }
}

class PrescriptionHistoryPage extends StatelessWidget {
  final String email;
  final String patientID;

  PrescriptionHistoryPage({required this.email, required this.patientID});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Prescription History'),
      ),
      body: PrescriptionList(
        patientEmail: email,
        patientID: patientID,
      ),
    );
  }
}

class PrescriptionList extends StatelessWidget {
  final String patientEmail;
  final String patientID;

  PrescriptionList({required this.patientEmail, required this.patientID});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('Patients')
          .doc(patientEmail)
          .collection('Prescriptions')
          .where('patientID', isEqualTo: AESAlgorithm.encryptData(patientID)) // Encrypt patient ID for query
          .orderBy('checkupDate', descending: true)
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (snapshot.data!.docs.isEmpty) {
          return Center(child: Text('No prescriptions available.'));
        }

        return ListView(
          children: snapshot.data!.docs.map((doc) {
            Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
            String encryptedPrescriptionDetails = data['prescriptionDetails'];
            String encryptedCheckupDate = data['checkupDate'];
            String encryptedDoctorName = data['doctorName']; // Retrieve encrypted doctor name

            // Decrypt all values before displaying
            String decryptedPrescriptionDetails = AESAlgorithm.decryptData(encryptedPrescriptionDetails) ?? 'Decryption Error';
            String decryptedCheckupDate = AESAlgorithm.decryptData(encryptedCheckupDate) ?? 'Decryption Error';
            String decryptedDoctorName = AESAlgorithm.decryptData(encryptedDoctorName) ?? 'Decryption Error'; // Decrypt doctor name

            return ListTile(
              title: Text(decryptedPrescriptionDetails),
              subtitle: Text('Checkup Date: $decryptedCheckupDate\nDoctor Name: $decryptedDoctorName'), // Adjusted field name
            );
          }).toList(),
        );
      },
    );
  }
}