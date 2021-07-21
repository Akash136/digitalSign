import 'package:digitalsignature/listviewdisplay.dart';
import 'package:digitalsignature/photoviewfile.dart';
import 'package:digitalsignature/shared_preference.dart';
import 'package:digitalsignature/signature.dart';
import 'package:digitalsignature/signature1.dart';
import 'package:digitalsignature/user.dart';
import 'package:digitalsignature/user_provider.dart';
import 'package:digitalsignature/welcome.dart';
import 'package:flutter/material.dart';
import 'package:digitalsignature/Display.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'constants.dart';
import 'login.dart';
import 'user_simple_preferences.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
// Widget build(BuildContext context) {
//   Future<User> getUserData() => UserPreferences().getUser();
//   //  user = Provider.of<UserProvider>(context).user;
//   return MultiProvider(
//     providers: [
//       //ChangeNotifierProvider(create: (_) => AuthProvider()),
//       ChangeNotifierProvider(create: (_) => UserProvider()),
//     ],
//     child: MaterialApp(
//         title: 'Flutter Demo',
//         theme: ThemeData(
//           primarySwatch: Colors.blue,
//           visualDensity: VisualDensity.adaptivePlatformDensity,
//         ),
//         home: FutureBuilder(
//             future: getUserData(),
//             builder: (context, snapshot) {
//               switch (snapshot.connectionState) {
//                 case ConnectionState.none:
//                 case ConnectionState.waiting:
//                   return CircularProgressIndicator();
//                 default:
//                   if (snapshot.hasError)
//                     return Text('Error: ${snapshot.error}');
//                   else if (snapshot.data.token == null)
//                     return LoginPage();
//                   else
//                     UserPreferences().removeUser();
//                   //return Welcome(user: snapshot.data);
//                   return ListViewDisplay(user: snapshot.data);
//               }
//               // if (snapshot.data)
//               //   return ListViewDisplay();
//               // else
//               //   UserPreferences().removeUser();
//               // //return Welcome(user: snapshot.data);
//               // return LoginPage();
//               // // }
//             }),
//         routes: {
//           '/nav': (context) => Signature(),
//           '/login': (context) => LoginPage(),
//           //'/list': (context) => ListViewDisplay(),
//         }),
//   );
// }
//}

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Constants.prefs = await SharedPreferences.getInstance();
  await UserSimplePreferences.init();
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Digital Signature',
      theme: ThemeData(primarySwatch: Colors.cyan),
      home: Constants.prefs.getBool("loggedin") == true
          ? ListViewDisplay()
          : LoginPage(),

      //home: Splashscreen(),

      routes: {
        '/nav': (BuildContext context) => Signature(),
        "/login": (context) => LoginPage(),
        '/list': (BuildContext context) => ListViewDisplay(),
        // "/list": (context) => ListViewDisplay(),
        //"/signin": (context) => SignupPage(),
      },
    ),
  );
}
