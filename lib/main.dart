import 'package:flutter/material.dart';
import 'package:life_story/Provider/storyProvider.dart';
import 'package:life_story/configuration/colors.dart';
import 'package:life_story/routes/router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var email = prefs.getString('username');
  runApp(
      MyApp(
          email:email
      ));
}

class MyApp extends StatelessWidget {

  final String email;
  MyApp({this.email});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: StoryProvider()),
      ],
      child: MaterialApp(
        title: 'Life Story',
        theme: ThemeData(
          primaryColor: primary,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        // home: Home(),
        initialRoute: (email!='autoLogin')?router.splash:router.home,
        onGenerateRoute: router.generateRoute,
      ),
    );
  }
}
