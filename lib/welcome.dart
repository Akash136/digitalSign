import 'package:digitalsignature/user.dart';
import 'package:digitalsignature/user_provider.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class Welcome extends StatelessWidget {
  final User user;

  Welcome({Key key, @required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Provider.of<UserProvider>(context).setUser(user);

    return Scaffold(
      body: Container(
        child: Center(
          child: Text(user.name),
        ),
      ),
    );
  }
}
