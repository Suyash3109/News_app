import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/edit.dart';
import 'package:flutter_application_1/image.dart';
import 'package:flutter_application_1/loggin.dart';

class homescr extends StatefulWidget {
  const homescr({Key? key}) : super(key: key);

  @override
  State<homescr> createState() => _homescrState();
}

class _homescrState extends State<homescr> {
  Stream<DocumentSnapshot> snapshot =
      FirebaseFirestore.instance.collection("users").doc().snapshots();

  String? imageurl;
  @override
  void initState() {
    // TODO: implement initState
    getImageURL();
    super.initState();
  }

  getImageURL() async {
    var _firebasestorage = FirebaseStorage.instance;
    var downloadurl = await _firebasestorage
        .ref('profilepic')
        .child('userpic')
        .getDownloadURL();
    if (imageurl == null) {
      setState(() {
        imageurl = downloadurl;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final logoutbutton = Material(
      elevation: 5,
      borderRadius: BorderRadius.all(Radius.circular(50)),
      color: Colors.redAccent,
      child: MaterialButton(
        padding: EdgeInsets.fromLTRB(50, 15, 50, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => loginpage()));
        },
        child: Text(
          "logout",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            color: Colors.black38,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                _signout();
              },
              icon: Icon(Icons.login_outlined))
        ],
        title: Text("Home page"),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('users').snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
            if (streamSnapshot.hasData) {
              return ListView.builder(
                itemCount: streamSnapshot.data!.docs.length,
                itemBuilder: (ctx, index) {
                  return Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0)),
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          horizontalTitleGap: 50,
                          title: Text(
                            "${streamSnapshot.data!.docs[index]['firstname'].toString().toUpperCase()} " +
                                streamSnapshot.data!.docs[index]['secondname']
                                    .toString()
                                    .toUpperCase(),
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle:
                              Text(streamSnapshot.data!.docs[index]['email']),
                          leading: InkWell(
                            onTap: () => _showDialog(context),
                            // Navigator.of(context).restorablePush(_dialog),
                            child: CircleAvatar(
                              child: CircularProgressIndicator(),
                              // backgroundImage: NetworkImage(imageurl!),
                            ),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => edit(
                                                streamSnapshot.data!.docs[index]
                                                    ['uid'],
                                                streamSnapshot.data!.docs[index]
                                                    ['firstname'],
                                                streamSnapshot.data!.docs[index]
                                                    ['email'],
                                                streamSnapshot.data!.docs[index]
                                                    ['secondname'],
                                              )));
                                },
                              )
                            ],
                          ),
                        ),
                        // logoutbutton,
                      ],
                    ),
                  );
                },
              );
            } else if (streamSnapshot.connectionState ==
                ConnectionState.waiting) {
              CircularProgressIndicator();
            }
            return CircularProgressIndicator();
          }),
      //  floatingActionButtonLocation: FloatingActionButton.extended(onPressed: logoutbutton, label: 'log')
    );
  }

  _showDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: EdgeInsets.fromWindowPadding(
                WindowPadding.zero, MediaQuery.of(context).devicePixelRatio),
            // : const Text('Test'),
            child: Stack(
              // fit: StackFit.values[2],
              alignment: Alignment.center,
              children: <Widget>[
                const Text('Data'),
                // Column(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   crossAxisAlignment: CrossAxisAlignment.center,
                //   children: [
                Positioned(child: Image.network(imageurl!)),
                Stack(
                  children: [
                    Container(
                      padding: EdgeInsets.fromLTRB(20, 50, 20, 20),
                      // padding: EdgeInsets.symmetric(
                      //     horizontal: MediaQuery.of(context).size.width - 200,
                      //     vertical: MediaQuery.of(context).size.height - 585),
                      // decoration: BoxDecoration(
                      //   image: DecorationImage(image: NetworkImage(imageurl!)
                      //   ),
                      // ),
                      child: Text('Test'),
                    ),
                  ],
                ),
              ],
            ),
            // ]),
          );
        });
  }

  // showImage(BuildContext context, String name, IconData giveIcon) => showDialog(
  //     context: context,
  //     builder: (context) {
  //       return Dialog(
  //           child: Row(
  //         children: [Text(name), Icon(giveIcon)],
  //       ));
  //     });
  Future _signout() async {
    await FirebaseAuth.instance.signOut();
    return Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => loginpage()));
  }
}
