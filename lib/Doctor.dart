import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'about.dart';
import 'grid.dart';
import 'griddoctor.dart';
import 'gridregulatory.dart';
import 'helppage.dart';
import 'settings.dart';

class Doctorpage extends StatelessWidget {
  const Doctorpage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.greenAccent,
          title: Text("Doctor's Dashboard", style: GoogleFonts.lato(
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),

          )
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
                decoration: BoxDecoration(color: Colors.blueGrey),
                child: CircleAvatar(
                  backgroundImage: AssetImage("assets/images/patient1.jpg"),
                )),
            InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>AboutPage()));
              },
              child: Card(
                child: ListTile(
                  title: Text("About"),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>HelpPage()));
              },
              child: Card(
                child: ListTile(
                  title: Text("Helpline"),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                print("hello");
                Navigator.push(context, MaterialPageRoute(builder: (context)=>SettingsPage()));
              },
              child: Card(
                child: ListTile(
                  title: Text("Settings"),
                ),
              ),
            ),
          ],
        ),
      ),
      body: Griddoctor(),
    );
  }
}
