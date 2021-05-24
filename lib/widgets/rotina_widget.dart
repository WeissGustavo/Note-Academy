import 'package:flutter/material.dart';

class rotinaWidget extends StatefulWidget {
  static List materiaList = _rotinaWidgetState._materiaList;
  @override
  _rotinaWidgetState createState() => _rotinaWidgetState();
}

class _rotinaWidgetState extends State<rotinaWidget> {
  static List<String> _materiaList = ['teste', 'teste2'];
  @override
  Widget build(BuildContext context) {
    return Tab(
      child: Expanded(
        child: Column(
          children: [],
        ),
      ),
    );
  }
}
