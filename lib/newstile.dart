import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_application_1/open.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:webview_flutter/webview_flutter.dart';

class NewsTile extends StatelessWidget {
  String title, description, content, imageUrl;
  Function()? openUrl;
  NewsTile(this.title, this.description, this.content, this.imageUrl,
      {this.openUrl});

//  void initState() {

//     super.initState();
//     // Enable virtual display.
//     if (Platform.isAndroid) WebView.platform = AndroidWebView();
//   }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: openUrl,
      child: Container(
        //color: Colors.amber,
        margin: const EdgeInsets.only(bottom: 24),
        width: MediaQuery.of(context).size.width,
        child: Container(
          child: Container(
            //color: Colors.pink,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            alignment: Alignment.bottomCenter,
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(15),
                    bottomLeft: Radius.circular(6))),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Image.network(
                      imageUrl,
                      height: 200,
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Text(title,
                      maxLines: 2,
                      style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 20,
                          fontWeight: FontWeight.w500)),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    description,
                    maxLines: 2,
                    style: const TextStyle(color: Colors.black54, fontSize: 14),
                  ),
                  Row(
                    children: const <Widget>[
                      SizedBox(
                        width: 325,
                      ),
                      IconButton(onPressed: null, icon: Icon(Icons.star_border))
                    ],
                  )
                ]),
          ),
        ),
      ),
    );
  }
}
