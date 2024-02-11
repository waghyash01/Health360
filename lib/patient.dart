import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'grid.dart';

class Patientpage extends StatelessWidget {
  const Patientpage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.greenAccent,
          title: Text("Patient's Dashboard", style: GoogleFonts.lato(
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
                print("hello");
              },
              child: Card(
                child: ListTile(
                  title: Text("About"),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                print("hello");
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
      body: Grids(),
    );
  }
}
