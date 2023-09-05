import 'dart:io';

import 'package:flutter/material.dart';

class ErrorPage extends StatefulWidget {
  final String errorMessage;

  const ErrorPage({super.key, required this.errorMessage});

  @override
  State<ErrorPage> createState() => _ErrorPageState();
}

class _ErrorPageState extends State<ErrorPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Error'),
      ),
      body: Container(
        color: Colors.red, // Customize the error container color as needed
        child: Center(
            child: Column(children: [
          Text(
            widget.errorMessage,
            style: const TextStyle(
              color: Colors.white, // Customize the error text color as needed
              fontSize: 16.0, // Customize the error text size as needed
            ),
          ),
          ElevatedButton(onPressed: () => exit(0), child: const Text('EXIT'))
        ])),
      ),
    );
  }
}
