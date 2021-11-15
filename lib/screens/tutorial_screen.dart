import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intro_slider/dot_animation_enum.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:intro_slider/scrollbar_behavior_enum.dart';
import 'package:intro_slider/slide_object.dart';
import 'package:lx_mobility/screens/native_kakao_map.dart';

class TutorialScreen extends StatefulWidget {

  const TutorialScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _TutorialScreenState();
  }
}

class _TutorialScreenState extends State<TutorialScreen> {
  List<Slide> slides = [];

  bool _dontSeeAgain = false;

  @override
  void initState() {
    super.initState();

    slides.add(Slide(
        title: 'Welcome To Smart Walk',
        backgroundImage: 'assets/images/city.jpg',
        maxLineTitle: 2,
        styleTitle: const TextStyle(
            color: Colors.green, fontSize: 32.0, fontWeight: FontWeight.bold),
        styleDescription: const TextStyle(
          color: Colors.white,
          fontSize: 20.0,
        ),
        description: 'PAGE 1',
        marginDescription: const EdgeInsets.only(top: 20.0, bottom: 20.0),
        directionColorBegin: Alignment.topLeft,
        directionColorEnd: Alignment.bottomRight,
        onCenterItemPress: () {}));

    slides.add(Slide(
        title: 'Welcome To Smart Walk',
        backgroundImage: 'assets/images/city_mountain.jpg',
        maxLineTitle: 2,
        styleTitle: const TextStyle(
            color: Colors.green, fontSize: 32.0, fontWeight: FontWeight.bold),
        styleDescription: const TextStyle(
          color: Colors.white,
          fontSize: 20.0,
        ),
        description: 'PAGE 2',
        marginDescription: const EdgeInsets.only(top: 20.0, bottom: 20.0),
        directionColorBegin: Alignment.topLeft,
        directionColorEnd: Alignment.bottomRight,
        onCenterItemPress: () {}));

    slides.add(Slide(
        title: 'Welcome To Smart Walk',
        backgroundImage: 'assets/images/smart_trans.png',
        maxLineTitle: 2,
        styleTitle: const TextStyle(
            color: Colors.green, fontSize: 32.0, fontWeight: FontWeight.bold),
        styleDescription: const TextStyle(
          color: Colors.white,
          fontSize: 20.0,
        ),
        description: 'PAGE 3',
        marginDescription: const EdgeInsets.only(top: 20.0, bottom: 20.0),
        directionColorBegin: Alignment.topLeft,
        directionColorEnd: Alignment.bottomRight,
        onCenterItemPress: () {}));
  }

  @override
  Widget build(BuildContext context) {
    var _size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
          child:SizedBox(
            height: _size.height,
            width: _size.width,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Flexible(
                  child: IntroSlider(
                    slides: slides,
                    colorDot: Colors.grey,
                    colorActiveDot: Colors.blue,
                    sizeDot: 14.0,
                    hideStatusBar: true,
                    backgroundColorAllSlides: Colors.grey,
                    verticalScrollbarBehavior: scrollbarBehavior.SHOW_ALWAYS,
                    onDonePress: onDonePress,
                    typeDotAnimation: dotSliderAnimation.DOT_MOVEMENT,
                  ),
                ),
                Container(
                  height: 50,
                  margin: const EdgeInsets.only(bottom: 16.0),
                  child: CheckboxListTile(
                    value: _dontSeeAgain,
                    title: const Text('다시 보지 않음'),
                    controlAffinity: ListTileControlAffinity.leading,
                    onChanged:(value) {
                        setState(() {
                          _dontSeeAgain = value!;
                        });
                    },
                  ),
                  alignment: Alignment.center,
                )

              ],
            ),
          )
      ),
    );
  }

  void onDonePress(){
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const NativeKakaoMap(),), (route) => false);
  }
}
