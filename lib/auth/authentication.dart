import 'package:flutter/material.dart';
import 'package:life_story/auth/Login.dart';
import 'package:life_story/auth/signup.dart';
import 'package:life_story/configuration/colors.dart';
import 'package:life_story/configuration/images.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class Authentication extends StatefulWidget {
  @override
  _AuthenticationState createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> with TickerProviderStateMixin {

  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  TabController _tabController;

  @override
  void initState() {
    _tabController = new TabController(vsync: this, length: 2);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          backgroundColor:  Colors.grey[200],
          key: _scaffoldkey,
          appBar: PreferredSize(
              child: Container(
                margin: EdgeInsets.only(top: 20),
                child: Material(
                  elevation: 2,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                  child: Container(
                    height: .4.sh,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                      color: Colors.white,

                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Image.asset(appLogo,height: .25.sh,),
                        TabBar(
                          indicatorColor: primary,
                          indicatorSize: TabBarIndicatorSize.tab,
                          indicatorWeight: 4.5,
                          indicatorPadding: EdgeInsets.symmetric(horizontal: 50),
                          labelColor: Colors.black,
                          labelStyle: TextStyle(fontSize: 18,fontWeight: FontWeight.w500),
                          unselectedLabelColor: Colors.black,
                          unselectedLabelStyle: TextStyle(fontSize: 18,fontWeight: FontWeight.w500),
                          tabs: [
                            Tab(
                              text: "Login",
                            ),
                            Tab(
                              text: "Sign-up",
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              preferredSize: Size(100, 400)),
          body: TabBarView(
            children: [Login(), SignUp()],
          )),
    );
  }
}
