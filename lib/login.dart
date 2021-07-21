import 'dart:convert';
import 'package:digitalsignature/listviewdisplay.dart';
import 'package:digitalsignature/shared_preference.dart';
import 'package:digitalsignature/user.dart';
import 'package:digitalsignature/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'Apiservices.dart';
import 'constants.dart';
import 'size_config.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'user_simple_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  bool _isLoading = false;
  User user;
  void initState() {
    super.initState();
  }

  // getItemAndNavigate(BuildContext context) {
  //   Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //           builder: (context) => ListViewDisplay(
  //                 nameHolder: emailController.text,
  //               )));
  // }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light
        .copyWith(statusBarColor: Colors.transparent));
    SizeConfig().init(context);
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              //colors: [Colors.white, Colors.teal],
              colors: [Colors.teal, Colors.white],
              //colors: [HexColor('#053d4a'), Colors.white],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter),
        ),
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : ListView(
                children: <Widget>[
                  headerSection(),
                  unm(),
                  buttonSection1(),
                  registersection(),
                  //    registersocialmedia(),
                ],
              ),
      ),
    );
  }

  String name;
  String email;
  String password;

  Container buttonSection1() {
    return Container(
      width: MediaQuery.of(context).size.width,
      //width: 30,
      //width: double.infinity,
      height: 40.0,
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      margin: EdgeInsets.only(top: 15.0),
      child: RaisedButton(
        onPressed: () {
          final body = {
            "username": emailController.text,
            "password": passwordController.text,
          };
          formkey.currentState.validate();
          ApiService.signin(emailController.text, passwordController.text)
              .then((success) async {
            if (success) {
              _isLoading = true;
              var data = new Map<String, dynamic>();
              data['username'] = emailController.text;
              Constants.prefs.setBool("loggedin", true);
              // UserPreferences().saveUser(User.fromJson(data["data"]));
              // user = User.fromJson(data["data"]);
              await UserSimplePreferences.setUsername(emailController.text);
              // User user = new User();
              // user.name = emailController.text;
              // UserPreferences().saveUser(user);
              // Provider.of<UserProvider>(context, listen: false).setUser(user);
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ListViewDisplay(),
                  ));
              //Navigator.pushReplacementNamed(context, '/list');
            } else {
              print('false state');
              String message = "Username & Password Invalid !";

              loginToast(message);
              _isLoading = false;
            }
          });
        },
        textColor: Colors.black,
        child: Text('Log in', style: TextStyle(fontSize: 20)),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
            side: BorderSide(color: Colors.red)),
      ),
    );
  }

  Container registersection() {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: 40.0,
        padding: EdgeInsets.symmetric(horizontal: 15.0),
        margin: EdgeInsets.only(top: 15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Does not have account?'),
            SizedBox(height: 10),
            FlatButton(
              textColor: Colors.blue,
              child: Text(
                'Sign in',
                style: TextStyle(fontSize: 20),
              ),
              onPressed: () {
                Navigator.pushReplacementNamed(context, "/signin");
              },
            ),
          ],
        ));
  }

  loginToast(String toast) {
    return Fluttertoast.showToast(
        msg: toast,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white);
  }

  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();

  Container headerSection() {
    return Container(
      margin: EdgeInsets.only(top: 50.0),
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
      child: Text("Sahiba Limited",
          style: TextStyle(
              color: Colors.black,
              fontSize: 40.0,
              fontWeight: FontWeight.bold)),
    );
  }

  // ignore: missing_return
  SingleChildScrollView unm() {
    return SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
        child: Form(
            autovalidate: true,
            key: formkey,
            child: Column(
              children: [
                TextFormField(
                    decoration: InputDecoration(
                      icon: Icon(Icons.email, color: Colors.black),
                      hintText: "Email",
                      border: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black)),
                      hintStyle: TextStyle(color: Colors.black),
                    ),
                    controller: emailController,
                    cursorColor: Colors.white,
                    validator: MultiValidator([
                      RequiredValidator(errorText: "* Required"),
                      //EmailValidator(errorText: "Enter valid email id"),
                    ])),
                SizedBox(),
                TextFormField(
                    obscureText: true,
                    decoration: InputDecoration(
                      icon: Icon(Icons.lock, color: Colors.black),
                      hintText: "Password",
                      border: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black)),
                      hintStyle: TextStyle(color: Colors.black),
                    ),
                    controller: passwordController,
                    cursorColor: Colors.white,
                    validator: MultiValidator([
                      RequiredValidator(errorText: "* Required"),
                      MinLengthValidator(6,
                          errorText: "Password should be atleast 6 characters"),
                      MaxLengthValidator(15,
                          errorText:
                              "Password should not be greater than 15 characters")
                    ])),
              ],
            )));
  }
}
