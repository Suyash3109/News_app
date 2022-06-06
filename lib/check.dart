import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_application_1/drawer.dart';
import 'package:flutter_application_1/loggin.dart';
import 'package:flutter_application_1/reg.dart';
import 'package:flutter_application_1/userpage.dart';

import 'home.dart';

class checkuser extends StatefulWidget {
  const checkuser({Key? key}) : super(key: key);

  @override
  State<checkuser> createState() => _checkuserState();
}

var uid = FirebaseAuth.instance.currentUser?.uid;
User? currentUser = FirebaseAuth.instance.currentUser;

class _checkuserState extends State<checkuser> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      //Initialize FireBase
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text("Error: ${snapshot.error}"),
            ),
          );
        }
        //Checking snapshot connection of FutureBuilder Widget
        if (snapshot.connectionState == ConnectionState.done) {
          //Returning StreamBuilder for checking authentication
          return StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              //Checking Snapshot connection for StreamBuilder Widget
              if (snapshot.connectionState == ConnectionState.active) {
                User? user = snapshot.data;
                //creating class getValue to get the Value from Future Class authorizeAccess(context)
                getValue() async {
                  if (user != null) {
                    bool future = await authorizeAccess(context);
                    print("printing future " + future.toString());

                    if (future == true) {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => const homescr(),
                      ));
                    } else {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => drawer(),
                      ));
                    }
                  } else {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => const loginpage(),
                      ));
                    });
                  }
                }

                //calling getValue() function to get called if the connection get active in StreamBuilder Widget
                getValue();
              }

              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            },
          );
        } else {
          //If connection fails of StreamBuilder Widget it will return LoginScreen page
          return const Scaffold(
            body: Center(
              child: Text("Something went wrong try again!"),
            ),
          );
        }
      },
    );
  }
}

Future<bool> authorizeAccess(context) async {
  currentUser = null;
  currentUser = FirebaseAuth.instance.currentUser;
  // ignore: unnecessary_null_comparison
  if (currentUser!.uid == null) {
    return false;
  } else {
    bool checkadmin;
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser!.uid)
        .get();

    if (doc.data()!['role'] == 'admin') {
      print('Authorized!!');
      checkadmin = true;
    } else {
      print("Not Authorized");
      checkadmin = false;
    }
    print("checking admin " + checkadmin.toString());
    return checkadmin;
  }
}
