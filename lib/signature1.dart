import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

import 'package:image_painter/image_painter.dart';
import 'package:photo_view/photo_view.dart';
import 'package:digitalsignature/UploadService.dart';
import 'package:photo_view/photo_view_gallery.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class Signature1 extends StatefulWidget {
  @override
  _Signature1State createState() => _Signature1State();
}

class _Signature1State extends State<Signature1> {
  PageController _pageController = PageController();
  final _imageKey = GlobalKey<ImagePainterState>();
  final _key = GlobalKey<ScaffoldState>();
  var _isclicked = false;
  static const routeName = '/nav';
  String _filename;
  String _deparment;
  List<String> parsed = [];

  void initState() {
    super.initState();
    // _deparment = ModalRoute.of(context).settings.arguments;
    fetchGalleryData();
    //_pageindex = 0;
  }

  void nextPage() {
    _pageController.animateToPage(_pageController.page.toInt() + 1,
        duration: Duration(milliseconds: 400), curve: Curves.easeIn);
  }

  Future<List<String>> fetchGalleryData() async {
    try {
      // _deparment = ModalRoute.of(context).settings.arguments;
      // final response =
      //   await http.get(Uri.parse("http://14.98.134.214:19/API/DMS/GetFiles"));
      // final response =
      //     await http.get(Uri.parse("http://14.98.134.214:19/API/DMS/Get_file"));
      print("TMSolanki");
      print(_deparment);
      final response = await http
          .post(Uri.parse("http://14.98.134.214:19/API/DMS/Get_file"), body: {
        "DEPARTMENTNAME": _deparment,
      });

      if (response.statusCode == 200) {
        parsed = List<String>.from(json.decode(response.body));
        //print(parsed);
      } else {
        throw Exception('Failed to load');
      }
    } on SocketException catch (e) {
      throw Exception('Failed to load');
    }
    setState(() {});
  }

  String _imgname = '';
  String _imgname1 = '';
  int _pageindex;
  void saveImage() async {
    final image = await _imageKey.currentState.exportImage();
    final directory = (await getApplicationDocumentsDirectory()).path;
    await Directory('$directory/sample').create(recursive: true);
    // final fullPath =
    //     '$directory/sample/${DateTime.now().millisecondsSinceEpoch}.png';
    final fullPath = '$directory/sample/' + _filename;
    final imgFile = File('$fullPath');

    imgFile.writeAsBytesSync(image);
    UploadService.upload(imgFile);
    _isclicked = false;
    _pageindex = _pageindex + 1;
    setState(() {
      parsed.removeAt(_pageindex); // deletes the item from the gridView
    });
    print("TMS");
    print(_pageindex);
    painter();

    setState(() {});

    //Navigator.of(context).pop();
    // nextPage();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.grey[700],
        padding: const EdgeInsets.only(left: 10),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Image Exported successfully.",
                style: TextStyle(color: Colors.white)),
            TextButton(
                onPressed: () => OpenFile.open("$fullPath"),
                child: Text("Open", style: TextStyle(color: Colors.blue[200])))
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    //_filename = 'sfsf';
    // _filename = ModalRoute.of(context).settings.arguments;

    _deparment = ModalRoute.of(context).settings.arguments;
    print("gayu");
    print(_deparment);
    return Scaffold(
        key: _key,
        //resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(_imgname1),
          actions: [
            IconButton(
              icon: Icon(Icons.save_alt),
              onPressed: saveImage,
            ),
            IconButton(
              icon: Icon(Icons.text_fields),
              onPressed: () {
                headerSection();
                setState(() {});
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          reverse: true,
          child: painter(),
        ));
  }

  Widget painter() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(Icons.text_fields),
          onPressed: () {
            print('button pressed');
            _isclicked = true;
            setState(() {});
          },
        ),
        _isclicked ? headerSection() : gallery()

        //Image.asset("assets/Saundh.jpg")
      ],
    );
  }

  //int firstPage = 1;
  //PageController _pageController = PageController(initialPage: _pageindex);
  Widget gallery() {
    return Container(
      height: MediaQuery.of(context).size.height / 1.20,
      margin: EdgeInsets.only(left: 15, right: 15),
      width: MediaQuery.of(context).size.height / 1.20,
      child: PhotoViewGallery.builder(
        itemCount: parsed.length,
        pageController: _pageController,
        builder: (context, index) {
          _imgname = parsed[index].toString();
          _filename = parsed[index].substring(32);
          print(_imgname);
          _pageindex = index;
          print(index);
          print('vishal');
          //  _imgname1 = _filename;
          return PhotoViewGalleryPageOptions(
              imageProvider: NetworkImage(
                parsed[index],
              ),
              minScale: PhotoViewComputedScale.contained * 0.8,
              maxScale: PhotoViewComputedScale.covered * 2);
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
                  : event.cumulativeBytesLoaded / event.expectedTotalBytes,
            ),
          ),
        ),
        onPageChanged: (int index) {
          _imgname1 = _filename;
          // setState(() {
          //   _imgname1 = _filename;
          // });
        },
      ),
    );
  }

  Widget headerSection() {
    return Container(
        height: MediaQuery.of(context).size.height / 1.20,
        child:
            //ImagePainter.network('http://10.10.10.179:89/pdfimage/' + _filename,
            ImagePainter.network(_imgname,
                // ImagePainter.asset("assets/sample.jpg",
                height: MediaQuery.of(context).size.height / 1.20,
                key: _imageKey,
                scalable: false));
  }

  Widget photoView1() {
    return Container(
        height: MediaQuery.of(context).size.height / 1.20,
        child: PhotoView(
          imageProvider: NetworkImage(
            'http://14.98.134.214:19/pdfimage/' + _filename,
          ),
        ));
  }
}
