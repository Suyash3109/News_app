import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_application_1/api/controller.dart';
import 'package:flutter_application_1/check.dart';
import 'package:flutter_application_1/usermodel.dart';
import 'package:flutter_application_1/userpage.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'loggin.dart';
import 'newstile.dart';

class drawer extends StatefulWidget {
  const drawer({Key? key}) : super(key: key);

  @override
  State<drawer> createState() => _drawerState();
}

class _drawerState extends State<drawer> {
  var title = ['Title Here', 'TestTitle'];
  var desc = ['Description her', 'Test Description'];
  var content = ['Content Here', 'Here Content'];
  var url = 'Test Url';
  User? user = FirebaseAuth.instance.currentUser;
  usermodel loggedInUSer = usermodel();
  Stream<DocumentSnapshot> snapshot =
      FirebaseFirestore.instance.collection("users").doc().snapshots();

  final Controller _controller = Get.put(Controller());
  var val;
  @override
  void initState() {
    setState(() {
      getData();
    });
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
    super.initState();
  }

  String? imageurl;

  Future getData() async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      val = value;
      loggedInUSer = usermodel.fromMap(value.data());
      // print(value['email']);
      if (mounted) {
        setState(() {});
      }
    });
  }

  var myMenuItems = <String>[
    'Edit',
  ];
  @override
  Widget build(BuildContext context) {
    final logoutbutton = Material(
      elevation: 5,
      borderRadius: const BorderRadius.all(const Radius.circular(50)),
      color: Colors.redAccent,
      child: MaterialButton(
        padding: const EdgeInsets.fromLTRB(50, 15, 50, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () {
          logout(context);
        },
        child: const Text(
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
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
                decoration: const BoxDecoration(
                  color: Colors.redAccent,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FutureBuilder(
                        future: FirebaseStorage.instance
                            .ref('profilepic')
                            .child('userpic')
                            .child('${currentUser!.uid}userpic')
                            .getDownloadURL(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            return ClipOval(
                              child: Stack(
                                children: [
                                  CircleAvatar(
                                    radius: 50,
                                    child:
                                        Image.network(snapshot.data.toString()),
                                    backgroundColor: Colors.black12,
                                    // backgroundImage: NetworkImage(imageurl!),
                                  ),
                                ],
                              ),
                            );
                          }
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const ClipOval(
                              child: CircleAvatar(radius: 50),
                            );
                          }
                          return const Center(
                            child: Text('something went wrong!!!'),
                          );
                        }),
                    Text(
                      '${loggedInUSer.firstname} ${loggedInUSer.secondname}',
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                          fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                  ],
                )),
            ListTile(
              hoverColor: Colors.red,
              focusColor: Colors.redAccent,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: const [
                  Icon(
                    Icons.account_circle_outlined,
                    color: Colors.black,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'Profile',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      // fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              onTap: () {
                Get.to(() => const HomeScreen());
              },
            ),
            const Divider(
              thickness: 1,
              color: Colors.black38,
              indent: 10,
              endIndent: 10,
              height: 5,
            ),
            ListTile(
              hoverColor: Colors.red,
              focusColor: Colors.redAccent,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: const [
                  Icon(
                    Icons.logout,
                    color: Colors.black,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'Logout',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      // fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              onTap: () {
                logout(context);
              },
            ),
            const Divider(
              thickness: 1,
              color: Colors.black38,
              indent: 10,
              endIndent: 10,
              height: 5,
            ),
          ],
        ),
      ),
      appBar: AppBar(
        actions: <Widget>[
          PopupMenuButton(
              icon: const Icon(Icons.filter_alt),
              itemBuilder: (BuildContext context) {
                return myMenuItems.map((String choice) {
                  return PopupMenuItem<String>(
                    child: Text(choice),
                    value: choice,
                  );
                }).toList();
              },
              onSelected: (item) {
                switch (item) {
                  case 'Edit':
                }
              })
        ],
        title: const Text(
          'Home Page',
          textAlign: TextAlign.start,
          style: TextStyle(color: Colors.white),
        ),
      ),

      // body: Icon(Icons.filter_alt_rounded),

      body: Obx(() => _controller.isload.value
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.redAccent,
                backgroundColor: Colors.black,
              ),
            )
          : ListView.builder(
              itemCount: _controller.response[0].articles!.length,
              itemBuilder: (context, index) {
                return NewsTile(
                  _controller.response[0].articles![index].title.toString(),
                  _controller.response[0].articles![index].description
                      .toString(),
                  _controller.response[0].articles![index].description
                      .toString(),
                  _controller.response[0].articles![index].urlToImage
                      .toString(),
                  openUrl: () {
                    launchUrlString(
                        _controller.response[0].articles![index].url!,
                        mode: LaunchMode.inAppWebView);
                  },
                );
              }
              // : Column(
              //   children: [
              //     Image.network(
              //         _controller.response[0].articles![0].urlToImage.toString()),
              //     Text(
              //       _controller.response[0].articles![0].title.toString(),
              //       style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              //     ),
              //     Text(_controller.response[0].articles![0].content.toString()),
              //     Text(_controller.response.first.articles!.first.description
              //         .toString()),
              //   ],
              // ),
              )),
    );
  }

  // void _openUrl({required String urlToOpen}) {
  //   launchUrlString(urlToOpen, mode: LaunchMode.inAppWebView);
  // }

  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const loginpage()));
  }
}
