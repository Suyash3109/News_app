import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/home.dart';
import 'package:flutter_application_1/loggin.dart';
import 'package:flutter_application_1/usermodel.dart';

class loggedin extends StatefulWidget {
  const loggedin({Key? key}) : super(key: key);

  @override
  State<loggedin> createState() => _loggedinState();
}

class _loggedinState extends State<loggedin> {
  @override
  Widget build(BuildContext context) {
    if (User == null) {
      return loginpage();
    }
    return homescr();
  }
}
