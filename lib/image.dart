import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class uploadimg extends StatefulWidget {
  const uploadimg({Key? key}) : super(key: key);

  @override
  State<uploadimg> createState() => _uploadimgState();
}

class _uploadimgState extends State<uploadimg> {
  String? imageurl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "upload your image",
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w900),
        ),
        centerTitle: true,
        elevation: 1.0,
        backgroundColor: Colors.redAccent,
      ),
      body: Container(
        color: Colors.pink.shade400,
        child: Column(
          children: <Widget>[
            Container(
                margin: EdgeInsets.all(15),
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.amber.shade200,
                  borderRadius: BorderRadius.all(
                    Radius.circular(15),
                  ),
                  border: Border.all(color: Colors.black87),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black38,
                      offset: Offset(2, 2),
                      spreadRadius: 2,
                      blurRadius: 1,
                    ),
                  ],
                ),
                child: (imageurl != null)
                    ? Image.network(imageurl!)
                    : Image.network(
                        'https://as1.ftcdn.net/v2/jpg/03/46/83/96/1000_F_346839683_6nAPzbhpSkIpb8pmAwufkC7c5eD7wYws.jpg')),
            SizedBox(
              height: 20.0,
            ),
            ElevatedButton(
                onPressed: () => imageupload(),
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
                      side: BorderSide(color: Colors.blue)),
                ))
          ],
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
        var snapshot = await _firebasestorage
            .ref('profilepic')
            .child('userpic')
            .putFile(file);
        var downloadurl = await _firebasestorage
            .ref('profilepic')
            .child('userpic')
            .getDownloadURL();
        setState(() {
          imageurl = downloadurl;
        });
      } else {
        print('no image');
      }
    } else {
      print('permission not granted');
    }
  }
}
