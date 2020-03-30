import 'package:flutter/material.dart';
import 'package:kheabia/utils/const.dart';

class AnalysisData extends StatefulWidget {
  final String data;

  const AnalysisData({Key key, this.data}) : super(key: key);

  @override
  _AnalysisDataState createState() => _AnalysisDataState();
}

class _AnalysisDataState extends State<AnalysisData> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Const.mainColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          'تحليل الكود',
          style: TextStyle(
            fontFamily: 'Tajawal',
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 24,
          ),
        ),
      ),
      body: Container(
        child: Center(
          child: Text(
            '${widget.data}',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
            ),
          ),
        ),
      ),
    );
  }
}
