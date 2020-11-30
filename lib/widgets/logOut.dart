import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:life_story/configuration/colors.dart';
import 'package:life_story/routes/router.dart';
import 'package:shared_preferences/shared_preferences.dart';

FirebaseAuth _auth = FirebaseAuth.instance;

logOut(BuildContext context)async{

  showDialog(
      context: (context),
      builder: (context)=>AlertDialog(
        title: Text('Log Out'),
        content:Text('Are you sure you want to Log Out?') ,
        actions: [
          FlatButton(onPressed: ()async{
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.clear();
            await _auth.signOut();
            await Navigator.of(context).pushNamedAndRemoveUntil(router.auth, (route) => false);
          }, child: Text('OK',style: TextStyle(color: primary),)),
          FlatButton(onPressed: (){
            Navigator.pop(context);
          }, child: Text('Cancel',style: TextStyle(color: primary),)),
        ],
      ));
}
