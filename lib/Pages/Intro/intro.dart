import 'package:flutter/material.dart';
import 'package:gestioneprevendite/Pages/Utils/Animations/RouteAnimation.dart';
import 'package:gestioneprevendite/utils/AppLocalizations.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:intro_slider/slide_object.dart';
import 'package:gestioneprevendite/Pages/home.dart';

class IntroScreen extends StatefulWidget {
  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  List<Slide> slides = new List();

  @override
  void initState() {
    super.initState();
  }

  void onDonePress() {
    Navigator.pushReplacement(
      context,
      EnterExitRoute(exitPage: IntroScreen(), enterPage: MyHomePage())
    );
  }

  void onSkipPress() {
    Navigator.pushReplacement(
      context,
      EnterExitRoute(exitPage: IntroScreen(), enterPage: MyHomePage())
    );
  }

  @override
  Widget build(BuildContext context) {
    slides.add(
      new Slide(
        title: AppLocalizations.of(context).translate("app_name"),
        description: AppLocalizations.of(context).translate("slide1"),
        pathImage: "assets/images/icon.png",
        backgroundColor: Color(0xffee4949),
      ),
    );
    slides.add(
      new Slide(
        title: AppLocalizations.of(context).translate("app_name"),
        description: AppLocalizations.of(context).translate("slide2"),
        pathImage: "assets/images/graph.png",
        backgroundColor: Color(0xfffdb03f),
      ),
    );
    slides.add(
      new Slide(
        title: AppLocalizations.of(context).translate("app_name"),
        description: AppLocalizations.of(context).translate("slide3"),
        pathImage: "assets/images/disco.png",
        backgroundColor: Color(0xff009bde),
      ),
    );

    return new IntroSlider(
      slides: this.slides,
      onDonePress: this.onDonePress,
      onSkipPress: this.onSkipPress,
    );
  }
}