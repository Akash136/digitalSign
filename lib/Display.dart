// import 'dart:html';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:digitalsignature/signature1.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Gallery extends StatefulWidget {
  Gallery({Key key}) : super(key: key);

  @override
  _GalleryState createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {
  String filename;
  void showToast() {
    print("tarjn solanki");
    Fluttertoast.showToast(
        msg: 'please first index sign',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.yellow);
  }

  Function toast(
      String msg, Toast toast, ToastGravity toastGravity, Color colors) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: toast,
        gravity: toastGravity,
        timeInSecForIosWeb: 1,
        backgroundColor: colors,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Image Gallery Example"),
        ),
        body: Center(
          child: FutureBuilder<List<String>>(
            future: fetchGalleryData(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return GridView.builder(
                    //   scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 8.0,
                      mainAxisSpacing: 8.0,
                    ),
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          print('1 was clicked');
                          print(snapshot.data[index]);
                          print('$index');

                          // ignore: unrelated_type_equality_checks
                          if ('$index' == "0") {
                            // ignore: unnecessary_statements
                            // snapshot.data[index]
                            filename = snapshot.data[index].substring(32);
                            // ignore: unnecessary_statements
                            //gotoNavigator;

                            Navigator.pushNamed(
                              context,
                              '/nav',
                              arguments: filename,
                            );
                            // ignore: unnecessary_statements
                          } else {
                            print('tms');
                            print('$index');
                            // ignore: unnecessary_statements
                            //showToast;
                            toast(
                                "Please Sign First PO",
                                Toast.LENGTH_LONG,
                                ToastGravity.BOTTOM,
                                Colors
                                    .green); // calling a function to show Toast message

                          }
                        },
                        child: Container(
                          decoration: new BoxDecoration(
                            //color: Colors.red,
                            image: new DecorationImage(
                                image: new NetworkImage(snapshot.data[index]),
                                fit: BoxFit.cover),
                            borderRadius: BorderRadius.all(
                              Radius.circular(20.0),
                            ),
                            border: Border.all(
                              color: Colors.blue,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 1.0, top: 150.0, bottom: 0.0),
                            child: Center(
                                child: Text(
                              snapshot.data[index].substring(32),
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold),
                            )),
                          ),
                        ),
                      );
                    });
              }
              return Center(child: CircularProgressIndicator());
            },
          ),
        ));
  }
}

Future<List<String>> fetchGalleryData() async {
  try {
    // final response =
    //     await http.post(Uri.parse("http://10.10.10.179:89/API/DMS/GetFiles"));

    final response =
        await http.get(Uri.parse("http://10.10.10.179:89/API/DMS/GetFiles"));
    // final response = await http
    //     .get(
    //         'https://kaleidosblog.s3-eu-west-1.amazonaws.com/flutter_gallery/data.json')
    //     .timeout(Duration(seconds: 5));

    if (response.statusCode == 200) {
      return compute(parseGalleryData, response.body);
    } else {
      throw Exception('Failed to load');
    }
  } on SocketException catch (e) {
    throw Exception('Failed to load');
  }
}

List<String> parseGalleryData(String responseBody) {
  final parsed = List<String>.from(json.decode(responseBody));
  return parsed;
}
