import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_photo_view_demo/themes/device_size.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class PhotoViewDemo extends StatefulWidget {
  @override
  _PhotoViewDemoState createState() => _PhotoViewDemoState();
}

class _PhotoViewDemoState extends State<PhotoViewDemo> {
  //dynamic parsed=;
  List<String> parsed = [];
  void initState() {
    super.initState();
    fetchGalleryData();
  }

  Future<List<String>> fetchGalleryData() async {
    try {
      final response =
          await http.get(Uri.parse("http://10.10.10.179:89/API/DMS/GetFiles"));

      if (response.statusCode == 200) {
        parsed = List<String>.from(json.decode(response.body));
        print(parsed);
      } else {
        throw Exception('Failed to load');
      }
    } on SocketException catch (e) {
      throw Exception('Failed to load');
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("PhotoView Demo"),
      ),
      // add this body tag with container and photoview widget
      body: Container(
        height: MediaQuery.of(context).size.height / 1.20,
        margin: EdgeInsets.only(left: 15, right: 15),
        width: MediaQuery.of(context).size.height / 1.20,
        child: Column(
          children: [
            PhotoViewGallery.builder(
              itemCount: parsed.length,
              builder: (context, index) {
                return PhotoViewGalleryPageOptions(
                  imageProvider: NetworkImage(
                    parsed[index],
                  ),
                  minScale: PhotoViewComputedScale.contained * 0.8,
                  maxScale: PhotoViewComputedScale.covered * 2,
                );
              },
              scrollPhysics: BouncingScrollPhysics(),
              backgroundDecoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: Theme.of(context).canvasColor,
              ),
              enableRotation: false,
              loadingBuilder: (context, event) => Center(
                child: Container(
                  width: 30.0,
                  height: 30.0,
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.orange,
                    value: event == null
                        ? 0
                        : event.cumulativeBytesLoaded /
                            event.expectedTotalBytes,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
