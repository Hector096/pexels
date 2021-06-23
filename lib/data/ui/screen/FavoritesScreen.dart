import 'package:flutter/material.dart';
import 'package:pexels/data/model/imageModel.dart';
import 'package:pexels/data/ui/screen/DetailScreen.dart';
import 'package:pexels/data/ui/widget/frostedGlassWidget.dart';
import 'package:pexels/data/util/sizeConfig.dart';

class FavoriteScreen extends StatefulWidget {
  List<Photo> photos;
  FavoriteScreen({Key? key, required this.photos}) : super(key: key);

  @override
  _FavoriteScreenState createState() => _FavoriteScreenState(photos);
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  late List<Photo> photos;
  _FavoriteScreenState(this.photos);

  @override
  void dispose() {
    super.dispose();
    widget.photos = [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text("Favorites"),
        centerTitle: true,
      ),
      body: photos.isNotEmpty
          ? Container(
              child: ListView.separated(
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 20),
                padding: EdgeInsets.all(5),
                itemCount: widget.photos.length,
                scrollDirection: Axis.vertical,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DetailScreen(photo: photos[index],)));
                      },
                      child: Card(
                        // semanticContainer: true,
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Container(
                          child: Stack(children: [
                            FadeInImage.assetNetwork(
                              image: widget.photos[index].src!.portrait!,
                              fit: BoxFit.cover,
                              placeholder: "assets/abstract.jpg",
                              imageScale: 1,
                            ),
                            Positioned(
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: FrostedGlassBox(
                                  height: SizeConfig.heightMultiplier! * 10,
                                  width: SizeConfig.widthMultiplier! * 30,
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "${widget.photos[index].photographer}",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 32,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Divider(
                                          color: Colors.white,
                                          endIndent: 40,
                                          indent: 40,
                                        ),
                                      ],
                                    ),
                                  ),
                                )),
                            Positioned(
                                top: 0,
                                right: 0,
                                child: IconButton(
                                  icon: Icon(
                                    Icons.star,
                                    color: Colors.yellow,
                                    size: SizeConfig.imageSizeMultiplier! * 7,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      photos.removeAt(index);
                                    });
                                  },
                                ))
                          ]),
                        ),
                      ));
                },
              ),
            )
          : Center(
              child: Text("No Favorites"),
            ),
    );
  }
}
