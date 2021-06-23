import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pexels/data/ui/screen/HomeScreen.dart';
import 'package:pexels/data/util/connectivity.dart';
import 'package:pexels/data/util/connectivityStatus.dart';
import 'package:pexels/data/util/sizeConfig.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          StreamProvider<ConnectivityStatus>(
              initialData: ConnectivityStatus.none,
              create: (context) =>
                  ConnectivityService().connectionStatusController.stream)
        ],
        child: LayoutBuilder(builder: (context, constraints) {
          return OrientationBuilder(builder: (context, orientation) {
            SizeConfig().init(constraints, orientation);
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Pexels',
              theme: ThemeData(
                  brightness: Brightness.light,
                  cardColor: Colors.white38,
                  accentColor: Colors.black,
                  dialogBackgroundColor: Colors.white,
                  primaryColor: Colors.white),
              home: HomeScreen(),
            );
          });
        }));
  }
}
