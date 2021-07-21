import 'dart:convert';
import 'dart:io';
import 'package:digitalsignature/user.dart';
import 'package:digitalsignature/user_provider.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

import 'package:image_painter/image_painter.dart';
import 'package:photo_view/photo_view.dart';
import 'package:digitalsignature/UploadService.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:provider/provider.dart';

import 'Apiservices.dart';
import 'constants.dart';
import 'size_config.dart';
import 'socalcard.dart';
import 'user_simple_preferences.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class Signature extends StatefulWidget {
  final String nameHolder;
  const Signature({Key key, this.nameHolder}) : super(key: key);
  @override
  _SignatureState createState() => _SignatureState();
}

class _SignatureState extends State<Signature> {
  String _username;
  PageController _pageController = PageController();
  final _imageKey = GlobalKey<ImagePainterState>();
  final _key = GlobalKey<ScaffoldState>();
  var _isclicked = false;
  static const routeName = '/nav';
  String _filename;
  String _deparment;
  bool _isLoading = false;
  List<String> parsed = [];
  User user;
  String name = '';
  var body;
  void initState() {
    super.initState();
    // _username = widget.nameHolder;
    // print(_username);
    name = UserSimplePreferences.getUsername() ?? '';
    //  print('signarure page');
    //print(name);
    final widgetsBinding = WidgetsBinding.instance;
    widgetsBinding.addPostFrameCallback((callback) {
      if (ModalRoute.of(context).settings.arguments != null) {
        _deparment = ModalRoute.of(context).settings.arguments;
      }
      print('init state' + _deparment);
      fetchGalleryData();
    });
    //WidgetsBinding.instance.addPostFrameCallback((_) => getdata());
//    fetchGalleryData();
    _pageindex = 0;
  }

  Future<List<String>> fetchGalleryData() async {
    try {
      //print("fetchgallerydate ");
      //getdata();
      //print('after getdata in fetchdata');
      //print(name);
      final response = await http
          .post(Uri.parse("http://14.98.134.214:19/API/DMS/Get_file"), body: {
        "USERNAME": name,
        "DEPARTMENTNAME": _deparment,
      });
      if (response.statusCode == 200) {
        // _isLoading = true;
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
  String _Filenames = '';
  int _pageindex;
  void saveImage() async {
    //loading();
    final image = await _imageKey.currentState.exportImage();
    final directory = (await getApplicationDocumentsDirectory()).path;
    await Directory('$directory/sample/').create(recursive: false);

    final fullPath = '$directory/sample/' + _filename;
    //final fullPath = 'http://14.98.134.214:19/' + _deparment + "/" + _filename;

    final imgFile = File('$fullPath');
    // String dpname = _deparment + 'PDFIMAGES';
    imgFile.writeAsBytesSync(image);
    //UploadService.upload(imgFile, dpname);
    UploadService.upload(imgFile);
    _isclicked = false;

    //_filename = parsed[_pageindex + 1];
    _Filenames = "";
    _Filenames = _filename.substring(1, _filename.length - 4);
    print("without jpg" + _Filenames);
    body = {
      "DOCUMENTNAME": _Filenames,
      "DEPARTMENTNAME": _deparment,
    };
    ApiService.updatedocumentStatus(body).then((success) {});

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.grey[700],
        padding: const EdgeInsets.only(left: 10),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Sign successfully.",
                style: TextStyle(color: Colors.white)),
            // TextButton(
            //     onPressed: () => OpenFile.open("$fullPath"),
            //     child: Text("Open", style: TextStyle(color: Colors.blue[200])))
          ],
        ),
      ),
    );
    parsed.removeAt(_pageindex);
    _filename = "";
    _Filenames = "";
    _imgname = "";
    painter();
    setState(() {});
    imageCache.clear();
    imageCache.clearLiveImages();
  }

  @override
  Widget build(BuildContext context) {
    // user = Provider.of<UserProvider>(context).user;
    //_filename = 'sfsf';
    //  _filename = ModalRoute.of(context).settings.arguments;
    //print("deparment");
    //_deparment = ModalRoute.of(context).settings.arguments;
    // print(name);
    //print("TMSdeparment");
    SizeConfig().init(context);
    return Scaffold(
        key: _key,
        //resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(_imgname1),
          actions: [
            IconButton(
                icon: Icon(Icons.exit_to_app),
                onPressed: () {
                  UserSimplePreferences.removeusername();
                  Constants.prefs.setBool("loggedin", false);
                  Navigator.pushReplacementNamed(context, "/login");
                })
          ],
        ),
        body: Container(
            //SingleChildScrollView(
            //physics: NeverScrollableScrollPhysics(),
            // reverse: true,
            child: parsed.length < 0
                ? Center(child: CircularProgressIndicator())
                : ListView(
                    physics: NeverScrollableScrollPhysics(),
                    children: <Widget>[
                        actionmenu(),
                        painter(),
                      ])
            //)
            ));
  }

  Widget painter() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [_isclicked ? headerSection() : gallery()],
    );
  }

  //int firstPage = 1;
  //PageController _pageController = PageController(initialPage: _pageindex);
  Widget gallery() {
    return Container(
      height: MediaQuery.of(context).size.height / 1.20,
      //margin: EdgeInsets.only(left: 15, right: 15),
      width: MediaQuery.of(context).size.height / 1.20,
      child: PhotoViewGallery.builder(
        itemCount: parsed.length,
        //pageController: _pageController,
        builder: (context, index) {
          _filename = "";
          _imgname = "";
          _imgname = parsed[index].toString();
          _filename = parsed[index].substring(32);
          //print(_imgname);
          _pageindex = index;
          // print(index);
          //print('vishal');
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
          //setState(() {
          _imgname1 = _filename;
          //});
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
    //imageCache.clear();
    //imageCache.clearLiveImages();
    print(_deparment);
    return Container(
        height: MediaQuery.of(context).size.height / 1.20,
        // child: PhotoView(
        //   imageProvider: NetworkImage(
        //     'http://14.98.134.214:19/' + _deparment + '/' + _filename,
        //   ),
        // ));
        child: PhotoView(
          imageProvider: NetworkImage(
            'http://14.98.134.214:19/pdfimage/' + _filename,
          ),
        ));
  }

  Container actionmenu() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 40.0,
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      margin: EdgeInsets.only(top: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _isclicked == true
              ? SizedBox()
              : SocalCard(
                  icon: "assets/signature.svg",
                  press: () {
                    //onGoogleSignIn(context);
                    _isclicked = true;
                    painter();
                    setState(() {});
                  },
                ),
          _isclicked == false
              ? SizedBox()
              : SocalCard(
                  icon: "assets/reject.svg",
                  press: () {
                    _isclicked = false;
                    //  print("rejected_tarun");
                    //  mainAxisAlignment: MainAxisAlignment.center;,
                    //  rejected();
                    //saveImage();
                    // Container(
                    //     alignment: Alignment.center,
                    //     child: Text(
                    //       'Rejected',
                    //       style: TextStyle(
                    //           color: Colors.pink,
                    //           fontWeight: FontWeight.bold,
                    //           fontSize: 22.0),
                    //     ));

                    // Text(
                    //   'Rejected',
                    //   style: TextStyle(
                    //       color: Colors.green,
                    //       fontWeight: FontWeight.bold,
                    //       fontSize: 50.0),
                    // );
                    // painter();
                    // print("rejected_tarun END ");
                    setState(() {});
                  },
                ),
          _isclicked == false
              ? SizedBox()
              : SocalCard(
                  icon: "assets/back.svg",
                  press: () {
                    _isclicked = false;
                    painter();

                    setState(() {});
                  },
                ),
          _isclicked == false
              ? SizedBox()
              : SocalCard(
                  icon: "assets/approve.svg",
                  press: () {
                    _isclicked = false;
                    saveImage();

                    // setState(() {});
                  },
                ),
        ],
      ),
    );
  }
}
