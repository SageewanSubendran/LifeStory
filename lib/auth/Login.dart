import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:life_story/configuration/colors.dart';
import 'package:life_story/routes/router.dart';
import 'package:life_story/widgets/text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';

FirebaseAuth _auth = FirebaseAuth.instance;

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  final _formKey = GlobalKey<FormState>();
  String email,password;
  bool _showSpinner = false;

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

                GestureDetector(
                    onTap: (){
                      Navigator.pushNamed(context, router.forgotPassword);
                    },
                    child: text(name: 'Forgot password?',color: primary,fontWeight: FontWeight.bold)),

                // Expanded(child: SizedBox()),

                SizedBox(height: 130.h,),
                GestureDetector(
                  onTap: ()async{
                    final form = _formKey.currentState;
                    if (form.validate()) {
                      form.save();
                      await login();
                    }
                  },
                  child: Container(
                    height: 110.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: primary,
                    ),
                    child: Center(
                      child: text(name: 'Login',color: Colors.white,fontWeight: FontWeight.normal,fontSize: 17),
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

  login()async{
    setState(() {
      _showSpinner = true;
    });

    try {
      final user = await _auth.signInWithEmailAndPassword(email: email, password: password);
      await loginUser();
      // await getUid();
      if(user!=null){
        print('asd');
        Navigator.of(context).pushNamedAndRemoveUntil(router.home, (route) => false);
      }
    } catch (error) {
      print('uuper $error');
      print('lower $error');
      print(error.code);
      if(error.code == 'ERROR_WRONG_PASSWORD' ){
        print(error.code);
        setState(() {
          _showSpinner = false;
        });
        showDialog(context: context,builder: (context)=> AlertDialog(
          title: Text('Error'),
          content: Text('WRONG_PASSWORD'),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok',style: TextStyle(color: primary),),
              onPressed: (){
                Navigator.pop(context);
              },
            )
          ],
        ));
      }
      else if(error.code == 'ERROR_USER_NOT_FOUND'){
        setState(() {
          _showSpinner = false;
        });
        showDialog(context: context,builder: (context)=> AlertDialog(
          title: Text('Error'),
          content: Text('User not Found'),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok',style: TextStyle(color: primary),),
              onPressed: (){
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
