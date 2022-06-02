import 'dart:developer';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_application_1/check.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class uploadimg extends StatefulWidget {
  const uploadimg({Key? key}) : super(key: key);

  @override
  State<uploadimg> createState() => _uploadimgState();
}

class _uploadimgState extends State<uploadimg> {
  var imageurl;
  @override
  void initState() {
    getImageURL();
    super.initState();
  }

  getImageURL() async {
    var _firebasestorage = FirebaseStorage.instance;
    await _firebasestorage
        .ref('profilepic')
        .child('userpic')
        .child('${currentUser!.uid}userpic')
        .getDownloadURL()
        .then((value) => imageurl = value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "upload your image",
          style: const TextStyle(
              color: Colors.black87, fontWeight: FontWeight.w900),
        ),
        centerTitle: true,
        elevation: 1.0,
        backgroundColor: Colors.redAccent,
      ),
      body: InkWell(
        onTap: () {
          imageupload();
        },
        child: Container(
          color: Colors.pink.shade400,
          child: Column(
            children: <Widget>[
              Container(
                  margin: const EdgeInsets.all(15),
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.amber.shade200,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(15),
                    ),
                    border: Border.all(color: Colors.black87),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black38,
                        offset: Offset(2, 2),
                        spreadRadius: 2,
                        blurRadius: 1,
                      ),
                    ],
                  ),
                  child: (imageurl != null)
                      ? Image.network(imageurl)
                      : Image.network(
                          'https://as1.ftcdn.net/v2/jpg/03/46/83/96/1000_F_346839683_6nAPzbhpSkIpb8pmAwufkC7c5eD7wYws.jpg')),
              const SizedBox(
                height: 20.0,
              ),
              ElevatedButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: Text(
                    "upload image",
                    style: TextStyle(
                        color: Colors.blueGrey.shade100,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                  style: ElevatedButton.styleFrom(
                    elevation: 10,
                    primary: Colors.black,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: const BorderSide(color: Colors.blue)),
                  ))
            ],
          ),
        ),
      ),
    );
  }

  imageupload() async {
    final _firebasestorage = FirebaseStorage.instance;
    final _imagepick = ImagePicker();
    File? image;

    await Permission.photos.request();
    // await Permission.camera.request();
    var permissionstatus = await Permission.photos.status;

    if (permissionstatus.isGranted) {
      final image = await _imagepick.pickImage(source: ImageSource.gallery);
      File file = File(image!.path);

      if (image != null) {
        log(image.path);

        UploadTask uplt = _firebasestorage
            .ref('profilepic')
            .child("userpic")
            .child('${currentUser!.uid}userpic')
            .putFile(file);

        if (mounted) {
          setState(() {});
        }
      } else {
        print('no image');
      }
    } else {
      print('permission not granted');
    }
  }
}
