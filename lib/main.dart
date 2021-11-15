import 'package:flutter/material.dart';
import 'package:lx_mobility/screens/splash.dart';
import 'package:lx_mobility/screens/tutorial_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {

  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Init.instance.initialize(),
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting){
            return MaterialApp(
              home: Splash(),
            );
          }
          else {
            return const MaterialApp(
              title: 'Tutorial Screen',
              home: TutorialScreen()
            );
          }
        },
    );
  }
}

class Init{
  Init._();

  static final instance = Init._();

  Future initialize() async{
    await Future.delayed(const Duration(seconds: 2));
  }
}
