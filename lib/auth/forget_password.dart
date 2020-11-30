import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:life_story/configuration/colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ForgotPassword> {

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String email;
  bool loader = false;

  @override
  void dispose() {
    super.dispose();
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(value),
      backgroundColor: Colors.black,
      duration: Duration(seconds: 2),
    ));
  }

  @override
  void initState() {
    super.initState();
  }

  sendEmail() {
    print(email);
    final FirebaseAuth _auth = FirebaseAuth.instance;
    if (email == null || email.isEmpty) {
      showInSnackBar("Kindly enter valid email");
    } else {
      setState(() {
        loader = true;
      });
      _auth.sendPasswordResetEmail(email: email).then((val) {
        setState(() {
          loader = false;
        });
        showInSnackBar("Link has been sent to your email");
      }).catchError((e) {
        setState(() {
          loader = false;
        });
        print(e);
        showInSnackBar(e.toString().substring(
            e.toString().indexOf(',') + 2, e.toString().lastIndexOf(',')));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // double height = MediaQuery.of(context).size.height;
    // double width = MediaQuery.of(context).size.width;
    return Scaffold(
      // backgroundColor: background,
      key: _scaffoldKey,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              height:1.sh,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.white,
                        background,
                      ]
                  )
              ),
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(40.0.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('Forgot Password',style: TextStyle(color: primary,fontSize: 45.sp,fontWeight: FontWeight.bold),),
                      SizedBox(
                        height: 30.h,
                      ),
                      Text(
                        "Kindly enter your email address. A link will be sent to your email.",
                        // style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(
                        height: 30.h,
                      ),
                      Material(
                        elevation: 5.0,
                        // shadowColor: Colors.black,
                        borderRadius: BorderRadius.circular(50.w),
                        child: TextFormField(
                          cursorColor: primary,
                          onChanged: (value){
                            email = value;
                          },
                          validator: (val) =>
                          !val.contains('@') ? 'Invalid email' : null,
                          decoration: InputDecoration(
                            hintText: 'email',
                            fillColor: Colors.white,
                            filled: true,
                            // border: OutlineInputBorder(
                            //   borderRadius: const BorderRadius.all(const Radius.circular(30.0),),
                            //   borderSide: BorderSide(color: primary, width: 3.0),),
                            contentPadding: EdgeInsets.fromLTRB(30.0.w, 35.0.w, 30.0.w, 35.0.w),
                            enabledBorder: OutlineInputBorder(
                              borderRadius:BorderRadius.circular(50.0.w),
                              borderSide: BorderSide(color: primary, width: 2.0.w),
                            ),
                            focusedBorder:OutlineInputBorder(
                              borderSide: BorderSide(color: primary, width: 5.0.w),
                              borderRadius:BorderRadius.circular(50.0.w),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 90.h,
                      ),
                      loader
                          ? Container(
                        width: MediaQuery.of(context).size.width * .5,
                        padding: EdgeInsets.all(10),
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      )
                          : FlatButton(
                        onPressed:  () => sendEmail(),
                        child: Container(
                          height: 100.h,
                          width: 300.w,
                          decoration: BoxDecoration(
                            color: primary,
                            borderRadius: BorderRadius.circular(50.w),
                          ),
                          child: Center(
                            child: Text(
                              "Send",
                              style: TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical:80.w,horizontal: 20.w),
              child: GestureDetector(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: Icon(Icons.arrow_back)),
            ),
          ],
        ),
      ),
    );
  }
}
