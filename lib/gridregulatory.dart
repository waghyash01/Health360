import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
class Gridregulatory extends StatelessWidget {
  Gridregulatory({Key? key});

  List img = ['Educate', 'Patients', 'Doctors', 'Compliance Audit'];

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      padding: EdgeInsets.only(top: 55),
      physics: NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      shrinkWrap: true,
      children: [
        for (int i = 0; i < img.length; i++)
          Card(
            elevation: 5,
            child: Column(
              children: [

                InkWell(
                  onTap: () {
                    print("hello yash");
                  },

                  child: Image.asset(
                    'assets/images/${img[i]}.png',
                    fit: BoxFit.fitHeight,
                  ),

                ),
                SizedBox(
                  height: 10,
                ),
                Text('${img[i]}',style: GoogleFonts.pacifico(),)
              ],
            ),
          ),
      ],
    );
  }
}
