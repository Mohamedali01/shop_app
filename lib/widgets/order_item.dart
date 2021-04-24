import 'package:flutter/material.dart';
import 'dart:math';
import '../provider/order.dart';
import 'package:intl/intl.dart';

class OrderItem extends StatefulWidget {
  final Order order;

  OrderItem({this.order});

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  bool _expanded = false;


  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8),
            child: ListTile(
              title: Text(
                '\$ ${widget.order.amount.toStringAsFixed(2)}',
              ),
              subtitle: Text(
                DateFormat('dd/MM/yyyy    hh:mm').format(widget.order.dateTime),
              ),
              trailing: IconButton(
                icon: Icon(_expanded ?Icons.expand_less : Icons.expand_more),
                onPressed: () {
                  setState(() {
                    _expanded = !_expanded;
                  });
                },
              ),
            ),
          ),
          if (_expanded)
            Container(
              padding: EdgeInsets.all(8),
              height: min(widget.order.list.length * 20.0 + 50.0, 100),
              color: Colors.white,
              child: ListView(
                children: [
                  ...widget.order.list
                      .map(
                        (e) => Padding(
                          padding: const EdgeInsets.all(4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${e.title}',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              Text(
                                'x${e.quantity}  ${e.price}',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
