import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';

class edit extends StatefulWidget {
  // const edit({Key? key}) : super(key: key);

  var userindex;
  String name, email, secondname;
  edit(
    this.userindex,
    this.name,
    this.email,
    this.secondname,
  );

  @override
  State<edit> createState() => _editState();
}

class _editState extends State<edit> {
  var name = '';
  var email = '';
  var secondname = '';
  // var password = '';
  final _firstname = TextEditingController();
  final _secondname = TextEditingController();
  final _email = TextEditingController();
  final _formkey = GlobalKey<FormState>();

  var uploadImage;
  File? filepath;

  @override
  void initstate() {
    _firstname.text = widget.name;
    _secondname.text = widget.secondname;
    _email.text = widget.email;

    super.initState();
  }

  Future _image() async {
    final pick = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pick != null) {
      setState(() {
        File file = File(pick.path);
      });
      print(pick.path);
    }
  }

  Future updateuser({required String name, email, secondname}) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userindex)
        .update({'firstname': name, 'secondname': secondname, 'email': email});
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Edit details')),
        body: Form(
          key: _formkey,
          child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(children: [
                Container(
                  margin: EdgeInsets.all(10),
                  child: TextFormField(
                    controller: _firstname,
                    autofocus: false,
                    onChanged: (value) => {},
                    decoration: const InputDecoration(
                        labelText: 'Name:',
                        floatingLabelBehavior: FloatingLabelBehavior.auto,
                        border: OutlineInputBorder()),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "please enter a name";
                      }
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(10),
                  child: TextFormField(
                    controller: _secondname,
                    autofocus: false,
                    onChanged: (value) => {},
                    decoration: const InputDecoration(
                        labelText: 'Second_Name:',
                        floatingLabelBehavior: FloatingLabelBehavior.auto,
                        border: OutlineInputBorder()),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "please enter second name";
                      }
                    },
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: TextFormField(
                      controller: _email,
                      autofocus: false,
                      onChanged: (value) => {},
                      decoration: const InputDecoration(
                          labelText: 'Email:',
                          floatingLabelBehavior: FloatingLabelBehavior.auto,
                          border: OutlineInputBorder()),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter a email';
                        }
                      }),
                ),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      ElevatedButton(
                          onPressed: () {
                            if (_formkey.currentState!.validate()) {
                              setState(() {
                                name = _firstname.text;
                                secondname = _secondname.text;
                                email = _email.text;
                              });
                              updateuser(
                                  name: name,
                                  secondname: secondname,
                                  email: email);
                              Navigator.pop(context);
                            }
                          },
                          child: const Text('update')),
                      ElevatedButton(
                          onPressed: () => {print(widget.userindex)},
                          child: const Text('reset'))
                    ],
                  ),
                )
              ])),

          //  SizedBox(height: 50,

          // ),
        ));
  }
}
