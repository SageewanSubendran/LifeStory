import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:life_story/configuration/colors.dart';
import 'package:life_story/routes/router.dart';
import 'package:life_story/widgets/text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';

FirebaseAuth _auth = FirebaseAuth.instance;

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  bool _showSpinner =false;
  String email,password;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: _showSpinner,
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal:70.0.w,vertical: 90.w),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                text(name: 'Email address'),
                textFromField('email',false,
                      (value){email = value;},
                      (val)=> !val.contains('@') ? 'Invalid email' : null,
                ),

                SizedBox(height: 70.h,),

                text(name: 'Password'),
                textFromField('password',true,
                      (value){password = value;},
                      (val)=> val.length < 6 ? 'Password is too short' : null,
                ),

                SizedBox(height: 50.h,),
                // Expanded(child: SizedBox()),

                SizedBox(height: 130.h,),
                GestureDetector(
                  onTap: ()async{
                    final form = _formKey.currentState;
                    if (form.validate()) {
                      form.save();
                      await signUp();
                    }
                  },
                  child: Container(
                    height: 110.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: primary,
                    ),
                    child: Center(
                      child: text(name: 'Sign-up',color: Colors.white,fontWeight: FontWeight.normal,fontSize: 17),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  signUp()async{
    setState(() {
      _showSpinner = true;
    });

    try {
      final newUser = await _auth
          .createUserWithEmailAndPassword(
          email: email, password: password);
      await loginUser();

      if (newUser != null) {
        print('asd');
        Navigator.of(context).pushNamedAndRemoveUntil(router.home, (route) => false);
      }

    } catch (error) {
      print(error.code);
      if (error.code ==
          'ERROR_EMAIL_ALREADY_IN_USE') {
        setState(() {
          _showSpinner = false;
        });
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Error'),
              content: Text(
                  'Email already in use'),
              actions: <Widget>[
                FlatButton(
                  child: Text('Ok',style: TextStyle(color: primary),),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
            ));
      } else if (error.code ==
          'user-not-found') {
        setState(() {
          _showSpinner = false;
        });
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Error'),
              content: Text('User not Found'),
              actions: <Widget>[
                FlatButton(
                  child: Text('Ok',style: TextStyle(color: primary),),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
            ));
      }

      throw error;
    }
  }

  Future<Null> loginUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('username', 'autoLogin');
  }
}
