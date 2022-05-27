import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_application_1/usermodel.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'home.dart';
import 'loggin.dart';

class regscr extends StatefulWidget {
  @override
  State<regscr> createState() => _regscrState();
}

final _auth = FirebaseAuth.instance;
final _formkey = GlobalKey<FormState>();

class _regscrState extends State<regscr> {
  final TextEditingController firstnamecontroller = TextEditingController();
  final TextEditingController secondnamecontroller = TextEditingController();
  final TextEditingController emailcontroller = TextEditingController();
  final TextEditingController passwordcontroller = TextEditingController();
  final TextEditingController cnfpasswordcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
//first name field

    final namefield = TextFormField(
      decoration: InputDecoration(
          hintText: "First Name",
          prefixIcon: Icon(Icons.person),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
          )),
      controller: firstnamecontroller,
      validator: (value) {
        if (value!.isEmpty) {
          return ("enter a name");
        }
        RegExp regExp = RegExp(r'^.{3,}$');

        if (!regExp.hasMatch(value)) {
          return ("Please enter valid name");
        }

        return null;
      },
      onSaved: (value) {
        firstnamecontroller.text = value!;
      },
      keyboardType: TextInputType.name,
    );

    //second name field

    final snamefield = TextFormField(
      decoration: InputDecoration(
        hintText: "Second Name",
        prefixIcon: Icon(Icons.person),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
        ),
      ),
      controller: secondnamecontroller,
      validator: (value) {
        if (value!.isEmpty) {
          return ("enter a name");
        }
        RegExp regExp = RegExp(r'^.{3,}$');

        if (!regExp.hasMatch(value)) {
          return ("Please enter valid name");
        }

        return null;
      },
      onSaved: (value) {
        secondnamecontroller.text = value!;
      },
      keyboardType: TextInputType.name,
    );

    //email
    final emailfield = TextFormField(
      decoration: InputDecoration(
          hintText: "Email",
          prefixIcon: Icon(Icons.email),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(50))),
      controller: emailcontroller,
      validator: (value) {
        if (value!.isEmpty) {
          return ("enter a email");
        }

        if (!RegExp(
                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
            .hasMatch(value)) {
          return ("Please enter a Valid email");
        }

        return null;
      },
      onSaved: (value) {
        emailcontroller.text = value!;
      },
      keyboardType: TextInputType.emailAddress,
    );

// password
    final passfield = TextFormField(
      decoration: InputDecoration(
          hintText: "Password",
          prefixIcon: Icon(Icons.vpn_key),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(50))),
      // controller: passwordcontroller,
      validator: (value) {
        if (value!.isEmpty) {
          return ("enter a pass");
        }
        RegExp regExp = RegExp(r'^.{6,}$');

        if (!regExp.hasMatch(value)) {
          return ("Please enter valid password");
        }

        return null;
      },
      onChanged: (value) {
        passwordcontroller.text = value;
      },
      //  keyboardType: TextInputType.visiblePassword,
      autofocus: true,
      obscureText: false,
    );

    final signupbutton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.redAccent,
      child: MaterialButton(
        padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () {
          singup(emailcontroller.text, passwordcontroller.text);

          //   signIn(emailcontroller.text, passwordcontroller.text);
        },
        child: Text(
          "SignUp",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("hey there"),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            color: Colors.amber,
            padding: EdgeInsets.fromLTRB(50, 15, 50, 15),
            // minWidth: MediaQuery.of(context).size.width,
            onPressed: () {
              _signout();
              // Navigator.of(context).pushReplacement(
              //     MaterialPageRoute(builder: (context) => loginpage()));
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Form(
            key: _formkey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 90,
                ),
                namefield,
                SizedBox(
                  height: 25,
                ),
                snamefield,
                SizedBox(
                  height: 25,
                ),
                emailfield,
                SizedBox(
                  height: 25,
                ),
                passfield,
                SizedBox(
                  height: 25,
                ),
                signupbutton,
              ],
            ),
          ),
        ),
      ),
    );
  }

  void singup(String email, String password) async {
    if (_formkey.currentState!.validate()) {
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) => {post()})
          .catchError((e) {
        Fluttertoast.showToast(msg: e!.message);
      });
    }
  }

  post() async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;

    usermodel Usermodel = usermodel();
    Usermodel.email = user!.email;
    Usermodel.firstname = firstnamecontroller.text;
    Usermodel.secondname = secondnamecontroller.text;
    Usermodel.uid = user.uid;
    await firebaseFirestore
        .collection('users')
        .doc(user.uid)
        .set(Usermodel.toMap());
    Fluttertoast.showToast(msg: 'account created');
    Navigator.pushAndRemoveUntil((context),
        MaterialPageRoute(builder: (context) => homescr()), (route) => false);
  }

  Future _signout() async {
    await FirebaseAuth.instance.signOut();
    return Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => loginpage()));
  }
}
