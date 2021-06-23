import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pexels/data/bloc/ImagesEvent.dart';
import 'package:pexels/data/bloc/imageBloc.dart';
import 'package:pexels/data/bloc/imageState.dart';
import 'package:pexels/data/model/imageModel.dart';
import 'package:pexels/data/ui/screen/DetailScreen.dart';
import 'package:pexels/data/ui/screen/FavoritesScreen.dart';
import 'package:pexels/data/ui/widget/frostedGlassWidget.dart';
import 'package:pexels/data/ui/widget/loadingWidget.dart';
import 'package:pexels/data/util/connectivityStatus.dart';
import 'package:pexels/data/util/sizeConfig.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Photo> list = [];
  List<Photo> photos = [];
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var connectionStatus = Provider.of<ConnectivityStatus>(context);
    print(connectionStatus);
    return BlocProvider(
        create: (context) => ImageBloc(LoadingState())..add(GetImages()),
        child: Scaffold(
          extendBody: true,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            title: Text("Pexels"),
            centerTitle: true,
            actions: [
              IconButton(
                  onPressed: () async {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                FavoriteScreen(photos: photos)));
                  },
                  icon: Icon(
                    Icons.star,
                    color: Colors.yellow,
                  ))
            ],
          ),
          body: connectionStatus == ConnectivityStatus.connected
              ? BlocConsumer<ImageBloc, ImageState>(
                  listener: (context, state) {
                    if (state is LoadingState) {
                      Scaffold.of(context)
                          .showSnackBar(SnackBar(content: Text("Loading")));
                    } else if (state is LoadSuccess &&
                        state.images!.photos!.isEmpty) {
                      Scaffold.of(context).showSnackBar(
                          SnackBar(content: Text('No more Images')));
                    } else if (state is LoadFailure) {
                      Scaffold.of(context).showSnackBar(
                          SnackBar(content: Text("Something Went Wrong..")));
                      BlocProvider.of<ImageBloc>(context).isFetching = false;
                    }
                    return;
                  },
                  builder: (context, state) {
                    if (state is LoadingState && list.isEmpty) {
                      return LoadingWidget();
                    } else if (state is LoadSuccess) {
                      print(state.images!.photos);
                      list.addAll(state.images!.photos!);
                      BlocProvider.of<ImageBloc>(context).isFetching = false;
                      Scaffold.of(context).hideCurrentSnackBar();
                    } else if (state is LoadFailure && list.isEmpty) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: () {
                              BlocProvider.of<ImageBloc>(context)
                                ..isFetching = true
                                ..add(GetImages());
                            },
                            icon: Icon(Icons.refresh),
                          ),
                          const SizedBox(height: 15),
                          Text("Something Went Wrong..",
                              textAlign: TextAlign.center),
                        ],
                      );
                    }
                    return ListView.separated(
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 20),
                      controller: _scrollController
                        ..addListener(() {
                          if (_scrollController.offset ==
                                  _scrollController.position.maxScrollExtent &&
                              !BlocProvider.of<ImageBloc>(context).isFetching) {
                            BlocProvider.of<ImageBloc>(context)
                              ..isFetching = true
                              ..add(GetImages());
                          }
                        }),
                      padding: EdgeInsets.all(5),
                      itemCount: list.length,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => DetailScreen(
                                          photo: list[index],
                                        )));
                          },
                          child: Card(
                            // semanticContainer: true,
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Stack(children: [
                              FadeInImage.assetNetwork(
                                image: list[index].src!.portrait!,
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
                                            "${list[index].photographer}",
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
                                  child: list[index].liked!
                                      ? IconButton(
                                          icon: Icon(
                                            Icons.star,
                                            color: Colors.yellow,
                                            size: SizeConfig
                                                    .imageSizeMultiplier! *
                                                7,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              list[index].liked = false;
                                            });
                                          },
                                        )
                                      : IconButton(
                                          icon: Icon(
                                            Icons.star_border_outlined,
                                            color: Colors.yellow,
                                            size: SizeConfig
                                                    .imageSizeMultiplier! *
                                                7,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              list[index].liked = true;
                                              photos.add(list[index]);
                                            });
                                          },
                                        ))
                            ]),
                          ),
                        );
                      },
                    );
                  },
                )
              : Center(
                  child: Text("No Internet.."),
                ),
        ));
  }

  Future<void> refreshList() async {
    await Future.delayed(Duration(seconds: 2));
    ImageBloc(LoadingState())..add(GetImages());
  }
}
