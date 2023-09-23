import 'package:flutter/material.dart';
import 'package:keratoplastysurvey/controller/hive_interface.dart';
import 'package:keratoplastysurvey/widget/login_form.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.hiveInterface});
  final HiveInterface hiveInterface;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Login"),
        ),
        body: Container(
          padding: const EdgeInsets.all(8.0),
          child: LoginForm(
            hiveInterface: widget.hiveInterface,
          ),
        ));
  }
}
