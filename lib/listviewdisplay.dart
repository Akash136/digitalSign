import 'dart:async';
import 'dart:convert';
import 'package:digitalsignature/shared_preference.dart';
import 'package:digitalsignature/user.dart';
import 'package:digitalsignature/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:digitalsignature/user_simple_preferences.dart';

import 'constants.dart';

class Job {
  // final int id;
  final String departmentname;
  final double totaldoc;

  Job({this.departmentname, this.totaldoc});

  factory Job.fromJson(Map<String, dynamic> json) {
    return Job(
      departmentname: json['DEPARTMENTNAME'],
      totaldoc: json['TOTALDOC'],
    );
  }
}

class ListViewDisplay extends StatefulWidget {
  // final String nameHolder;
  // const ListViewDisplay({Key key, this.nameHolder}) : super(key: key);
  // final User user;

  // ListViewDisplay({Key key, @required this.user}) : super(key: key);

  @override
  _ListViewDisplayState createState() => _ListViewDisplayState();
}

class _ListViewDisplayState extends State<ListViewDisplay> {
  //BuildContext context;

  User user;
  String _username;
  String name = '';
  @override
  void initState() {
    name = UserSimplePreferences.getUsername() ?? '';
    //print('list view');
    //print(name);
    //user = Provider.of<User>(context, listen: false);
    super.initState();
    //getData();
    // _username = widget.nameHolder;
    //user = Provider.of<User>(context, listen: false);

    //print('init listview');
    //print(_username);
    //Home.signin()
  }

  @override
  Widget build(BuildContext context) {
    //Provider.of<UserProvider>(context).setUser(user);
    // user = Provider.of<UserProvider>(context).user;
    //  Provider.of<UserProvider>(context).setUser(user);
    return Scaffold(
      appBar: AppBar(
        title: Text('Department'),
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
      body: FutureBuilder<List<Job>>(
        future: _fetchJobs(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Job> data = snapshot.data;
            return _jobsListView(data);
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return CircularProgressIndicator();
        },
      ),
    );
  }

  // Future<List<Job>> _fetchJobs() async {
  //   //final jobsListAPIUrl = 'https://mock-json-service.glitch.me/';
  //   final jobsListAPIUrl =
  //       'http://14.98.134.214:19/API/DMS/GetDOCWISESIGNCOUNT';
  //   final response = await http.get(Uri.parse(jobsListAPIUrl));

  //   if (response.statusCode == 200) {
  //     var listData = json.decode(response.body);

  //     List jsonResponse = listData['CompanyData'];
  //     print(jsonResponse);
  //     // List jsonResponse = json.decode(response.body);
  //     // res = jsonResponse['dt'];
  //     return jsonResponse.map((job) => new Job.fromJson(job)).toList();
  //   } else {
  //     throw Exception('Failed to load jobs from API');
  //   }
  // }

  Future<List<Job>> _fetchJobs() async {
    //final jobsListAPIUrl = 'https://mock-json-service.glitch.me/';
    // final jobsListAPIUrl =
    //     'http://14.98.134.214:19/API/DMS/GetDOCWISESIGNCOUNT';
    // final response = await http.get(Uri.parse(jobsListAPIUrl));
    //print('fetch job');
    //print(name);
    // print(user.name);
    final response = await http.post(
        Uri.parse("http://14.98.134.214:19/API/DMS/GetDOCWISESIGNCOUNT"),
        body: {
          "USERNAME": name,
        });

    setState(() {});
    if (response.statusCode == 200) {
      var listData = json.decode(response.body);

      List jsonResponse = listData['CompanyData'];
      // print(jsonResponse);
      // List jsonResponse = json.decode(response.body);
      // res = jsonResponse['dt'];
      return jsonResponse.map((job) => new Job.fromJson(job)).toList();
    } else {
      throw Exception('Failed to load jobs from API');
    }
  }

  ListView _jobsListView(data) {
    return ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          return Card(
              color: Colors.transparent,
              elevation: 0.0,
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.indigo, width: 1.0),
                borderRadius: BorderRadius.circular(9.0),
              ),
              child: _tile(data[index].departmentname, data[index].totaldoc,
                  Icons.work));
          // return _tile(
          //     data[index].departmentname, data[index].totaldoc, Icons.list);
        });
  }

  ListTile _tile(String title, double subtitle, IconData icon) => ListTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
          side: BorderSide(color: Colors.red),
        ),
        title: Text(title,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 20,
            )),
        trailing: Hero(
          tag: subtitle.toStringAsFixed(0),
          child: CircleAvatar(
            backgroundColor: Colors.orange,
            child: Text(
              subtitle.toStringAsFixed(0),
              style: TextStyle(color: Colors.white, fontSize: 11),
            ),
          ),
        ),
        leading: Icon(
          icon,
          color: Colors.blue[500],
        ),
        onTap: () {
          // print(title);

          Navigator.pushNamed(
            context,
            '/nav',
            arguments: title,
          );
        },
      );
}
