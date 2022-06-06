import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_application_1/check.dart';
import 'package:flutter_application_1/drawer.dart';
import 'package:flutter_application_1/image.dart';
import 'package:flutter_application_1/loggin.dart';
import 'package:flutter_application_1/usermodel.dart';

import 'edit.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  usermodel loggedInUSer = usermodel();
  Stream<DocumentSnapshot> snapshot =
      FirebaseFirestore.instance.collection("users").doc().snapshots();
  var val;
  @override
  void initState() {
    setState(() {
      getData();
    });
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
      // drawer: drawer(),
      appBar: AppBar(
        actions: [
          PopupMenuButton(itemBuilder: (BuildContext context) {
            return myMenuItems.map((String choice) {
              return PopupMenuItem<String>(
                child: Text(choice),
                value: choice,
              );
            }).toList();
          }, onSelected: (item) {
            switch (item) {
              case 'Edit':
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => edit(
                              userindex: user!.uid,
                              email: loggedInUSer.email.toString(),
                              name: loggedInUSer.firstname.toString(),
                              secondname: loggedInUSer.secondname.toString(),
                              // user!.uid,
                              // loggedInUSer.firstname.toString(),
                              // loggedInUSer.secondname.toString(),
                              // loggedInUSer.email.toString(),
                              //  loggedInUSer.firstname.toString(),
                            )));
                break;
              // case 'Profile':
              //   print('Profile clicked');
              //   break;
              // case 'Setting':
              //   print('Setting clicked');
              //   break;
            }
          })
        ],
        title: const Text('Profile Details'),
      ),
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            getData();
          });
        },
        child: Column(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 20),
                  // child: const Text(
                  //   'Profile Details',
                  //   style: TextStyle(
                  //     fontSize: 20,
                  //     fontWeight: FontWeight.bold,
                  //     color: Colors.redAccent,
                  //   ),
                  // ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Stack(
                  children: [
                    Center(
                      child: FutureBuilder(
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
                                      radius: 80,
                                      child: Image.network(
                                          snapshot.data.toString()),
                                      backgroundColor: Colors.black12,
                                      // backgroundImage: NetworkImage(imageurl!),
                                    ),
                                    Positioned(
                                        right: 2,
                                        bottom: 10,
                                        child: SizedBox(
                                            height: 46,
                                            width: 46,
                                            child: IconButton(
                                              highlightColor: Colors.red,
                                              hoverColor: Colors.orangeAccent,
                                              // shape: RoundedRectangleBorder(
                                              //   borderRadius:
                                              //       BorderRadius.circular(50),
                                              //   side: const BorderSide(
                                              //       color: Color.fromARGB(
                                              //           255, 255, 255, 255)),
                                              // ),
                                              color: Color.fromARGB(
                                                  255, 188, 59, 4),
                                              onPressed: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (_) =>
                                                            const uploadimg()));
                                              },
                                              icon: Icon(
                                                  Icons.camera_alt_outlined),
                                              // TODO: Icon not centered.
                                              // child:
                                              //     Icon(Icons.camera_alt_outlined),
                                            )))
                                  ],
                                ),
                              );
                            }
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const ClipOval(
                                child: const CircleAvatar(radius: 80),
                              );
                            }
                            return const Center(
                              child: Text('something went wrong!!!'),
                            );
                          }),
                    ),
                    Card(
                      elevation: 9.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(9.0),
                      ),
                    ),
                  ],
                ),

                const SizedBox(
                  height: 20,
                ),
                Container(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            border: Border.all(
                              // width: 5,
                              color: Colors.black,
                            ),
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Name:  ${loggedInUSer.firstname} ${loggedInUSer.secondname}',
                            textAlign: TextAlign.left,
                            style: const TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.black,
                            ),
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Email: ${loggedInUSer.email}',
                            textAlign: TextAlign.start,
                            style: const TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 100,
                    ),
                    logoutbutton
                  ],
                ))

                // FutureBuilder(
                //     future: FirebaseFirestore.instance
                //         .collection('users')
                //         .doc(loggedInUSer.uid)
                //         .get(),
                //     builder: (BuildContext context, AsyncSnapshot snapshot) {
                //       if (snapshot.hasData) {
                //         CollectionReference _collectionRef =
                //             FirebaseFirestore.instance.collection('users');

                //       }

                //     })
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const loginpage()));
  }
}
