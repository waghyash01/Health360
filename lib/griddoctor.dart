import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'Doctor.dart';
import 'EncryptPatientData.dart';
import 'doctorPrescription.dart';
import 'newuser.dart';
class Griddoctor extends StatelessWidget {
  Griddoctor({Key? key});

  List img = ['Add Patients', 'View Patients', ];

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      padding: EdgeInsets.only(top: 55),
      //physics: NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      shrinkWrap: true,
      children: [

        for (int i = 0; i < img.length; i++)
          Container(
            child: Card(
              elevation: 5,
              child: Column(
                children: [

                  InkWell(
                    onTap: () {
                      if(i==0){
                        Navigator.push(context, MaterialPageRoute(builder: (context) {
                          return AESEncryptionPage();
                        }));
                      }
                      else
                        {
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>WritePrescriptionPage()));
                        }

                    },

                    child: Image.asset(
                      'assets/images/${img[i]}.png',
                      fit: BoxFit.contain,
                    ),

                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text('${img[i]}',style: GoogleFonts.pacifico(),)
                ],
              ),
            ),
          ),

        Container(

          child: Card(
            elevation: 5,
            child: Column(
              children: [

                InkWell(
                  onTap: () {
                    print("IN PROGRESS");
                  },

                  child: Image.asset(
                    'assets/images/Data Analytics.png',
                    fit: BoxFit.contain,
                  ),

                ),
                SizedBox(
                  height: 5,
                ),
                Text('Data Analytics',style: GoogleFonts.pacifico(),)
              ],
            ),
          ),
        ),
      ],
    );

  }
}
