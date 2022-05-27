import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_application_1/loggin.dart';
import 'package:flutter_application_1/reg.dart';

import 'home.dart';

class checkuser extends StatefulWidget {
  const checkuser({Key? key}) : super(key: key);

  @override
  State<checkuser> createState() => _checkuserState();
}

var uid = FirebaseAuth.instance.currentUser?.uid;
User? user;

class _checkuserState extends State<checkuser> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          user = snapshot.data;
          print(user);
          Future getValue() async {
            var isadmin = await FirebaseFirestore.instance
                .collection('users')
                .doc(uid)
                .get();
            if (user != null) {
              print(user);
              if (isadmin['role'] == 'admin') {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: ((context) => const homescr())));
              } else {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: ((context) => regscr())));
              }
            } else {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (ctx) => loginpage()));
              });
            }
          }

          getValue();

          return const Center(
            child: CircularProgressIndicator(
              color: Colors.black,
            ),
            // child: Text("Checking Authentication"),
          );
        });
  }
}
