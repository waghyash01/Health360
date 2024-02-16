import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'DecryptPatientData.dart';
class Grids extends StatelessWidget {
  Grids({Key? key});

  List img = ['Checkups', 'Receipts', 'Prescriptions', 'Records'];

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      padding: EdgeInsets.fromLTRB(5, 55, 5, 0),
      physics: NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      shrinkWrap: true,
      children: [
        for (int i = 0; i < img.length; i++)
          Container(
            padding: EdgeInsets.fromLTRB(0, 0, 15, 0),
            child: Column(
              children: [

                InkWell(
                  onTap: () {
                    if(i==0)
                      {
                        print("IN PROGRESS");
                      }
                    else if(i==1)
                      {
                        print("IN PROGRESS");
                      }
                      else if(i==2)
                        {
                          print("IN PROGRESS");
                        }
                      else
                        {
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>AESDecryptionPage()));
                        }
                  },
                  child: Image.asset(
                    'assets/images/${img[i]}.png',
                    fit: BoxFit.contain,
                  ),

                ),
              SizedBox(
                height: 8,
              ),
            Text('${img[i]}',style: GoogleFonts.pacifico(),)
              ],
            ),
          ),
      ],
    );
  }
}
