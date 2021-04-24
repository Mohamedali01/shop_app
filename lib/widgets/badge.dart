import 'package:flutter/material.dart';

class Badge extends StatelessWidget {
  final int value;
  final Widget child;

  Badge({this.value, this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        Positioned(
          top: 1,
          right: 5,
          child: Container(
            padding: EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(10)
            ),
            constraints: BoxConstraints(minWidth: 21,minHeight: 21),
            child: Center(
              child: Text(
                '$value',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12,color: Colors.white),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
