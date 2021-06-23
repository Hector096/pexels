import 'package:flutter/material.dart';
import 'package:pexels/data/util/sizeConfig.dart';

class RequestErrorWidget extends StatefulWidget {
  final String? error;
  RequestErrorWidget({required this.error});

  @override
  _RequestErrorWidgetState createState() => _RequestErrorWidgetState();
}

class _RequestErrorWidgetState extends State<RequestErrorWidget> {

  @override
  Widget build(BuildContext context) {
    return _buildErrorWidget(widget.error! , context);
  }

  Widget _buildErrorWidget(String error , BuildContext context) {
    return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.error_outline,
                color: Colors.red, size: SizeConfig.imageSizeMultiplier! * 18),
            SizedBox(
              height: SizeConfig.heightMultiplier! * 2,
            ),
            Text(
              "Something went Wrong",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                  fontSize: SizeConfig.textMultiplier! * 2),
            ),
          ],
        ));
  }
}
