import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:life_story/configuration/images.dart';
import 'package:life_story/routes/router.dart';

class SplashScreen extends StatefulWidget {
  static const routeName = '/SplashScreen';
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(Duration(seconds: 3),(){
      Navigator.pushNamedAndRemoveUntil(context, router.auth, (route) => false);
    });
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: Size(750, 1334), allowFontScaling: false);

    return Scaffold(
      body: Center(
        child: Image.asset(appLogo,height: 500.h,),
      ),
    );
  }
}
