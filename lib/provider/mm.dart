import 'package:flutter/material.dart';

class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Scaffold(
          appBar: AppBar(
            actions: [
              
            ],
            title: Text('The widget'),
          ),
        ),
      ),
    );
  }
}
