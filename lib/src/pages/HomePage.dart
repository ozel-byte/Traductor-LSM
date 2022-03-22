import 'package:flutter/material.dart';
import 'package:redsocial/src/pages/Home.dart';
import 'package:redsocial/src/pages/SplashScreeen.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Material App',
        home: SplashScreen());
  }
}
