import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Newuser extends StatelessWidget {
  Newuser({super.key});
  List patientdetails = [
    'Full Name',
    'Age',
    'Gender',
    'Contact Number',
    'Patient Id',
    'Email',
    'Address',
    'Blood Group',
    'Medical History',
    'Insurance Provider'
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Material(
        child: Container(
          decoration: BoxDecoration(color: Colors.greenAccent.shade100),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 25),
                  child: Text("Enter Patient Details",
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                ),
                Container(
                  margin: EdgeInsets.only(top: 7),
                  height: 3,
                  width: 300,
                  decoration: BoxDecoration(color: Colors.black),
                ),
                SizedBox(
                  height: 10,
                ),
                for (int i = 0; i < patientdetails.length; i++)
                  Card(
                    elevation: 3,
                    child: Container(
                      width: 380,
                      margin: EdgeInsets.only(top: 20),
                      child: TextFormField(
                        decoration:
                            InputDecoration(labelText: "  ${patientdetails[i]}"),
                      ),
                    ),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
