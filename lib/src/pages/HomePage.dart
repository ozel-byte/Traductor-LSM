import 'package:flutter/material.dart';
import 'package:redsocial/src/pages/Home.dart';
import 'package:redsocial/src/pages/PageBlue.dart';
import 'package:redsocial/src/pages/PageSelec.dart';
import 'package:redsocial/src/pages/SplashScreeen.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      initialRoute: "/",
      routes: {
        '/': (BuildContext context) => SplashScreen(),
        'lenguaje': (BuildContext context) => Home(),
        'guante': (BuildContext context) => PageBlue(),
        'pageselect': (BuildContext context) => PageSelec()
      },
    );
  }
}
