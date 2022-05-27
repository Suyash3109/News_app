import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/check.dart';
import 'package:flutter_application_1/home.dart';
import 'package:flutter_application_1/reg.dart';
import 'package:fluttertoast/fluttertoast.dart';

class loginpage extends StatefulWidget {
  const loginpage({Key? key}) : super(key: key);

  @override
  State<loginpage> createState() => _loginpageState();
}

class _loginpageState extends State<loginpage> {
  final _formkey = GlobalKey<FormState>();

  final _auth = FirebaseAuth.instance;

  //editing controller

  final TextEditingController emailcontroller = new TextEditingController();
  final TextEditingController passwordcontroller = new TextEditingController();

  @override
  Widget build(BuildContext context) {
//email field

    final emailfield = TextFormField(
      autofocus: false,
      decoration: InputDecoration(
          hintText: "email",
          prefixIcon: Icon(Icons.mail),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20))),
      controller: emailcontroller,
      keyboardType: TextInputType.emailAddress,
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
      textInputAction: TextInputAction.next,
    );

    ///password field

    final passwordfield = TextFormField(
      decoration: InputDecoration(
          hintText: "Password",
          prefixIcon: Icon(Icons.vpn_key),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20))),
      controller: passwordcontroller,
      //keyboardType: TextInputType.number,
      validator: (value) {
        if (value!.isEmpty) {
          return ("enter a pass");
        }
        RegExp regExp = new RegExp(r'^.{6,}$');

        if (!regExp.hasMatch(value)) {
          return ("Please enter valid password");
        }

        return null;
      },
      onSaved: (value) {
        passwordcontroller.text = value!;
      },
      textInputAction: TextInputAction.done,
    );

    //login button

    final loginbutton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.redAccent,
      child: MaterialButton(
        padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () {
          // StreamBuilder(
          //     stream: FirebaseFirestore.instance
          //         .collection('users')
          //         .doc('uid')
          //         .snapshots(),
          //     builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          //       final user = snapshot.data!;
          //       if (user['role'] == 'admin') {
          //         return homescr();
          //       } else {
          //         return regscr();
          //       }
          //     });

          signIn(emailcontroller.text, passwordcontroller.text);
          // Navigator.of(context).pushReplacement(
          //     MaterialPageRoute(builder: (context) => homescr()));

          //   signIn(emailcontroller.text, passwordcontroller.text);
        },
        child: Text(
          "Login",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );

    //signup button

    return Scaffold(
      appBar: AppBar(title: const Text('Please Login')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Form(
              key: _formkey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 100,
                  ),
                  emailfield,
                  // TextFormField(
                  //   decoration: InputDecoration(
                  //     hintText: "email",
                  //     border: OutlineInputBorder(
                  //         borderRadius: BorderRadius.circular(50)),
                  //   ),
                  // ),
                  //Text("data"),
                  SizedBox(
                    height: 50,
                  ),
                  passwordfield,

                  // TextFormField(
                  //   decoration: InputDecoration(
                  //     hintText: "password",
                  //     border: OutlineInputBorder(
                  //         borderRadius: BorderRadius.circular(50)),
                  //   ),
                  // ),
                  //Text("data"),
                  SizedBox(
                    height: 50,
                  ),
                  loginbutton,
                  // ElevatedButton(onPressed: () {}, child: Text("Login")),
                  // Row(
                  //   children: [
                  //     SizedBox(
                  //       height: 50,
                  //       width: 50,
                  //     ),
                  //     ElevatedButton(onPressed: () {}, child: Text("dd")),
                  //     SizedBox(
                  //       height: 50,
                  //       width: 200,
                  //     ),
                  //     ElevatedButton(onPressed: () {}, child: Text("aa"))
                  //   ],
                  // ),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Don't have an account?"),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => regscr()));
                        },
                        child: Text(
                          "SignUp",
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold,
                            color: Colors.redAccent,
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );

    //void signIn(String email, String password);
  }

  void signIn(String email, String password) async {
    if (_formkey.currentState!.validate()) {
      await _auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) => {
                Fluttertoast.showToast(msg: "login successful"),
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => checkuser()))
              })
          .catchError((e) {
        Fluttertoast.showToast(msg: e!.message);
      });
    }
  }
}
