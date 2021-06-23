import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pexels/data/model/imageModel.dart';

class DetailScreen extends StatefulWidget {
  final Photo photo;

   DetailScreen({Key? key,required this.photo}) : super(key: key);

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children:[ Container(
              height: MediaQuery.of(context).size.height,
              child: Image.network(
                widget.photo.src!.portrait!,
                fit: BoxFit.cover,
              )),
              Positioned(
                 top: 0,
                 left: 0,
                child: BackButton())
          ]),
      ),
    );
  }
}
