import 'package:flutter/material.dart';
import 'package:keratoplastysurvey/api.dart' as my_api;
import 'package:keratoplastysurvey/configuration.dart';
import 'package:keratoplastysurvey/controller/local_store_interface.dart'
    as my_hive_interface;
import 'package:keratoplastysurvey/pages/home_page.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key, required this.hiveInterface});
  final my_hive_interface.LocalStoreInterface hiveInterface;

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  bool _passwordVisible = true;
  bool rememberme = true;
  bool signedin = true;

  @override
  void initState() {
    super.initState();
    _loadRememberMe;
    _passwordVisible = false;
    rememberme = false;
    signedin = false;
  }

  void _loadRememberMe() {
    my_api.API.fromFile.loadUser(widget.hiveInterface);
    setState(() {
      rememberme = user.rememberMe;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const SizedBox(
                height: 10.0,
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'LOGIN ID',
                  hintText: 'ENTER LOGIN ID',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the LOGIN ID';
                  }
                  if (!RegExp(r'^\d{10}$').hasMatch(value)) {
                    return 'Login Id must be exactly 9 numbers';
                  }
                  return null;
                },
                onSaved: (value) {
                  user.loginId = value!;
                },
                initialValue: user.loginId,
              ),
              const SizedBox(
                height: 10.0,
              ),
              TextFormField(
                initialValue: user.password,
                obscureText: !_passwordVisible,
                decoration: InputDecoration(
                  labelText: 'Password',
                  hintText: 'ENTER Password',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      // Based on passwordVisible state choose the icon
                      _passwordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Theme.of(context).primaryColorDark,
                    ),
                    onPressed: () {
                      // Update the state i.e. toogle the state of passwordVisible variable
                      setState(() {
                        _passwordVisible = !_passwordVisible;
                      });
                    },
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the Password';
                  }
                  if (!RegExp(
                          r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$')
                      .hasMatch(value)) {
                    return 'Login Id must be exactly 10 characters excluding country code';
                  }
                  return null;
                },
                onSaved: (value) {
                  user.password = value!;
                },
              ),
              const SizedBox(
                height: 10.0,
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();

                    final token = await my_api.API.auth.login();

                    if(token!="") {
                      user.rememberMe = rememberme;
                      user.signedIn = signedin;
                      my_api.API.toFile.storeUser(widget.hiveInterface);

                      //my_api.API.sync(hiveInterface: widget.hiveInterface);

                      navKey.currentState?.pushReplacement(
                        MaterialPageRoute(
                            settings: const RouteSettings(name: "/HomePage"),
                            builder: (context) =>
                                HomePage(
                                  hiveInterface: widget.hiveInterface,
                                )),
                      );
                    }
                  }
                },
                child: const Text('Login'),
              ),
              const SizedBox(
                height: 10.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Checkbox(
                      value: rememberme,
                      onChanged: (value) {
                        setState(() {
                          rememberme = value!;
                        });
                      }),
                  const Text("Remember me")
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Checkbox(
                      value: signedin,
                      onChanged: (value) {
                        setState(() {
                          signedin = value!;
                        });
                      }),

                  const Text("Keep me signed in")
                ],
              ),
            ]));
  }
}
