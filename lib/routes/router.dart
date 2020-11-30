
import 'package:flutter/material.dart';
import 'package:life_story/Model/homeModel.dart';
import 'package:life_story/Pages/fullphoto.dart';
import 'package:life_story/Pages/home.dart';
import 'package:life_story/Pages/splash_screen.dart';
import 'package:life_story/Pages/story.dart';
import 'package:life_story/Pages/videoPlayer.dart';
import 'package:life_story/auth/authentication.dart';
import 'package:life_story/auth/forget_password.dart';
import 'package:life_story/configuration/colors.dart';

class _Router {

  static const String _splash = '/';
  static const String _auth = 'auth';
  static const String _forgotPassword = 'forgotPassword';
  static const String _home = 'home';
  static const String _story = 'story';
  static const String _fullPhoto = 'fullPhoto';
  static const String _videoPlayer = 'videoPlayer';

  String get splash => _splash;
  String get auth => _auth;
  String get forgotPassword => _forgotPassword;
  String get home => _home;
  String get story => _story;
  String get fullPhoto => _fullPhoto;
  String get videoPlayer => _videoPlayer;

  Route<dynamic> generateRoute(RouteSettings settings) {
    // Getting arguments passed in while calling Navigator.pushNamed
    final args = settings.arguments;

    HomeModel arguments = args;

    switch (settings.name) {

      case _splash:
        return MaterialPageRoute(builder: (_) => SplashScreen());

      case _auth:
        return MaterialPageRoute(builder: (_) => Authentication());

      case _forgotPassword:
        return MaterialPageRoute(builder: (_) => ForgotPassword());

      case _home:
        return MaterialPageRoute(builder: (_) => Home());

      case _story:

        return MaterialPageRoute(builder: (_) => Story(date: arguments.date,check: arguments.check,));

      case _fullPhoto:
        return MaterialPageRoute(builder: (_) => FullPhoto());

      case _videoPlayer:
        return MaterialPageRoute(builder: (_) => VideoPlayer1());

      default:
      // If there is no such named route in the switch statement, e.g. /third
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        backgroundColor: primary,
        appBar: AppBar(
          title: Text('Error'),
          elevation: 0,
        ),
        body: Center(
          child: Text(
            'ERROR', style: TextStyle(color: Colors.white, fontSize: 30,),),
        ),
      );
    });
  }
}
  final _Router router = _Router();