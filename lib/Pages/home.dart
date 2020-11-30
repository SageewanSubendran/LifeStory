import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:life_story/Model/homeModel.dart';
import 'package:life_story/Pages/Search/search_story.dart';
import 'package:life_story/Provider/storyProvider.dart';
import 'package:life_story/configuration/colors.dart';
import 'package:life_story/routes/router.dart';
import 'package:life_story/widgets/bottomNavigation.dart';
import 'package:life_story/widgets/text.dart';
import 'package:provider/provider.dart';


class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

 DateTime _currentDate    =  DateTime.now();

 DateTime _targetDateTime =  DateTime.now();

 String   _currentMonth   =  DateFormat.MMMM().format(DateTime.now());

 CalendarCarousel calendarCarousel;

 String _currentItemSelected = "2020";

 List<String> years=[];


 @override
  void initState() {
   for(int i = 2010 ; i<=2050;i++){
     setState(() {
       years.add(i.toString());
     });
   }
    super.initState();
  }

  @override
  void didChangeDependencies() {
    String formattedDate = DateFormat('yyyy-MM-dd').format(_currentDate);
    final _check = Provider.of<StoryProvider>(context).check;
    final _streakCheck = Provider.of<StoryProvider>(context).streakCheck;
    final _data = Provider.of<StoryProvider>(context);

    if(_check){
    _data.getStoryData(formattedDate);}
    if(_streakCheck){
      _data.getStreak();}
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
   final _data = Provider.of<StoryProvider>(context);
    ScreenUtil.init(context, designSize: Size(750, 1334), allowFontScaling: false);

    return Scaffold(
      bottomNavigationBar: bottomNav(context, background,false),
    body: SingleChildScrollView(
        child: Container(
          height: 1.0.sh,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white,
                background
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            )
          ),
          child: Padding(
            padding: EdgeInsets.only(left:30.0.w,right: 30.w,top: 80.w),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.arrow_back_ios_rounded),
                      onPressed: () {
                        setState(() {
                          if(_currentMonth != 'January') {
                            _targetDateTime = DateTime(_targetDateTime.year, _targetDateTime.month - 1);
                            _currentMonth = DateFormat.MMMM().format(_targetDateTime);
                            print(_targetDateTime);
                            print(_currentMonth);
                          }
                        });

                      },
                    ),
                    Text(
                      _currentMonth,
                      style: TextStyle(
                          fontSize: 34.0,
                          color: primary
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.arrow_forward_ios_rounded),
                      onPressed: () {
                        setState(() {
                          if(_currentMonth != 'December') {
                            _targetDateTime = DateTime(
                                _targetDateTime.year, _targetDateTime.month + 1);
                            _currentMonth =
                                DateFormat.MMMM().format(_targetDateTime);
                            print(_targetDateTime);
                          }
                        });
                      },
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding:EdgeInsets.only(left:25.0.w,bottom: 30.w,top: 10.w),
                    child: dropDown()
                  ),
                ),

                (_data.streak==1 ||  _data.streak==null)?Container():Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                        onTap: (){
                          DateTime en =DateTime.parse('2020-11-27');

                          int day = en.difference(DateTime(2020, 11, 26)).inDays;
                          print(day);
                        },
                        child: Icon(Icons.local_fire_department_sharp,color: background3,)),
                    SizedBox(width: 15.w,),
                    text(name: _data.streak.toString(),color: Colors.black,fontSize: 17),
                  ],
                ),

                SizedBox(
                  height: 50.h,
                ),
                calendar(),
                GestureDetector(
                  onTap: ()async{
                    if(_data.documents !=null){

                    }
                    String formattedDate = DateFormat('yyyy-MM-dd').format(_currentDate);

                    await Navigator.pushNamed(context, router.story,arguments: HomeModel(
                      date: formattedDate,
                      check: (_data.documents!=null)?true:false,
                    )).then((value){
                      _data.getStoryData(formattedDate);
                      _data.getStreak();
                    });
                  },
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 50.w,top: 20.w),
                    child: Container(
                      // height: 75.h,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: primary),
                        color: colorSelection()
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical:25.w),
                        child: Center(
                          child: text(name: (_data.documents==null)?'+ Add Story':_data.documents['title'],fontWeight: FontWeight.normal,fontSize: 17),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 80.w,),
                GestureDetector(
                  onTap: (){
                    // Navigator.pushNamed(context, router.story);
                  },
                  child: GestureDetector(
                    onTap: (){
                      String formattedDate = DateFormat('yyyy-MM-dd').format(_currentDate);
                      showSearch(context: context, delegate: SearchStory()).then((value) {
                        _data.getStoryData(formattedDate);
                      });
                    },
                    child: Container(
                      height: 95.h,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: primary,width: 3.w),
                          color: Colors.white,
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 35.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            text(name: 'Search a story...',color: Colors.grey[600],fontSize: 17),
                            Icon(Icons.search,color: primary,size: 50.w,)
                          ],
                        ),
                      )
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color colorSelection(){
    final _data = Provider.of<StoryProvider>(context);

    if(_data.documents !=null){
    String _mood=_data.documents['mood'];

    if(_mood == 'Happy'){
      return background1;
    }
    else if(_mood == 'Sad'){
      return background2;
    }
    else if(_mood == 'Angry'){
      return background3;
    }
    return story_mood;
    }
    else{
      return story_mood;
    }
  }

  Widget dropDown(){
   return Container(
     height: 70.0.h,
     width: 280.w,
     decoration: BoxDecoration(
       borderRadius: BorderRadius.circular(30),
       border: Border.all(color: background),
       color: Colors.white60,
     ),
     child: Padding(
       padding: EdgeInsets.only(left: 70.w,right: 15.w),
       child: DropdownButtonHideUnderline(
         child: Theme(
           data: Theme.of(context).copyWith(
             canvasColor: background,),
//                    alignedDropdown: true,
           child: new DropdownButton<String>(
               icon: Icon(Icons.arrow_drop_down_circle_outlined),
               focusColor: primary,
               iconDisabledColor: Colors.black,
               iconEnabledColor: Colors.black,
               items: years.map((String value) {
                 return new DropdownMenuItem<String>(
                   value: value,
                   child: new Text(value, style: TextStyle(color: Colors.black),),
                 );
               }).toList(),
               onChanged: (String newValueSelected) {
                 setState(() {
                   _currentItemSelected = newValueSelected;
                   print(int.parse(_currentItemSelected));
                   _targetDateTime = DateTime(int.parse(_currentItemSelected), _targetDateTime.month);
                   _currentMonth = DateFormat.MMMM().format(_targetDateTime);
                   print(_targetDateTime);
                 });
               },
               hint: Text("Gender"),
               value: _currentItemSelected
           ),
         ),
       ),
     ),
   );
  }

  Widget calendar(){
    final _data = Provider.of<StoryProvider>(context);

    return calendarCarousel = CalendarCarousel<Event>(
     onDayPressed: (DateTime date, List<Event> events) {
       this.setState(() {
         _currentDate = date;
         print(_currentDate);
         String formattedDate = DateFormat('yyyy-MM-dd').format(_currentDate);
         // slotDate = formattedDate;
         _data.getStoryData(formattedDate);
         print(formattedDate);
       });
     },
     weekDayPadding: EdgeInsets.all(0),
     customGridViewPhysics: NeverScrollableScrollPhysics(),
     headerMargin: EdgeInsets.all(0),
     weekDayMargin: EdgeInsets.all(0),
     markedDateIconMargin: 0,
     iconColor:Theme.of(context).primaryColor ,
     headerTextStyle: TextStyle(
         color: Theme.of(context).primaryColor,
         fontSize: 20,
         fontWeight: FontWeight.bold
     ),
     daysTextStyle: TextStyle(
       color: Colors.black,
       fontSize: 15,
     ),
     selectedDayBorderColor: primary,
     selectedDayTextStyle: TextStyle(
         color: primary,
         fontSize: 17,
         fontWeight: FontWeight.bold
     ),
     todayTextStyle: TextStyle(
         color: Colors.blue,
         fontSize: 15
     ),
     weekendTextStyle: TextStyle(
         color: Colors.grey,
         fontSize: 15
     ),
     weekdayTextStyle: TextStyle(color: Colors.black,fontSize: 16),
     thisMonthDayBorderColor: Colors.transparent,
     height: 500.h,
     showOnlyCurrentMonthDate: true,
     weekFormat: false,
     daysHaveCircularBorder: true,
     showHeader: false,
     selectedDateTime: _currentDate,
     selectedDayButtonColor: Colors.white,
     minSelectedDate: _currentDate.subtract(Duration(days: 18250)),
     maxSelectedDate: _currentDate.add(Duration(days: 18250)),
     todayButtonColor: Colors.transparent,
     todayBorderColor: Colors.transparent,
     targetDateTime: _targetDateTime,
     onCalendarChanged: (DateTime date) {
       this.setState(() {
         _targetDateTime = date;
         _currentMonth = DateFormat.MMMM().format(_targetDateTime);
       });
     },

   );
 }

}
