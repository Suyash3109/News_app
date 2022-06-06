import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_application_1/check.dart';
import 'package:flutter_application_1/drawer.dart';
import 'package:flutter_application_1/edit.dart';
import 'package:flutter_application_1/home.dart';
import 'package:flutter_application_1/image.dart';
import 'package:flutter_application_1/loggedin.dart';
import 'package:flutter_application_1/loggin.dart';
import 'package:flutter_application_1/reg.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      // home: // const homescr(),
      //     StreamBuilder(
      //   stream: FirebaseAuth.instance.authStateChanges(),
      //   builder: (context, snapshot) {
      //     if (snapshot.hasData) {
      //       return Scaffold(
      //           body: StreamBuilder(
      //               stream: FirebaseFirestore.instance
      //                   .collection('users')
      //                   .doc('uid')
      //                   .snapshots(),
      //               builder:
      //                   (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
      //                 if (snapshot.hasData) {
      //                   final user = snapshot.data!;
      //                   if (user['role'] == 'admin') {
      //                     return homescr();
      //                   } else if (user['role'] == 'not admin') {
      //                     return regscr();
      //                   }
      //                 } else if (snapshot.hasError) {
      //                   return const Text('No connection');
      //                 }
      //                 return Text('Text Return');
      //               }));
      //     }
      //     return loginpage();
      //   },
      // )

      // home: StreamBuilder<User?>(
      //     stream: FirebaseAuth.instance.authStateChanges(),
      //     builder: (context, snapshot) {
      //       if (snapshot.hasData) {
      //         return homescr();
      //       } else {
      //         return loginpage();
      //       }
      //     }),
      // home: const checkuser(),
      home: checkuser(),
      debugShowCheckedModeBanner: false,
    );

    // authorizeaccess(BuildContext context) {
    //   FirebaseAuth.instance.currentUser.then((user) {
    //     FirebaseFirestore.instance
    //         .collection('users')
    //         .where('uid', isEqualTo: user.uid)

    // }
  }
  // );
}
