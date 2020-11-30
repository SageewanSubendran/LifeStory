
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:life_story/Model/storyModel.dart';
import 'package:life_story/Provider/storyProvider.dart';
import 'package:life_story/configuration/colors.dart';
import 'package:life_story/routes/router.dart';
import 'package:life_story/widgets/bottomNavigation.dart';
import 'package:life_story/widgets/text.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';


class ViewStory extends StatefulWidget {

  final String title;
  final String mood;
  final String story;
  final String mediaPath;
  final String mediaType;
  final String date;
  ViewStory({this.title,this.mood,this.story,this.mediaPath,this.mediaType,this.date});

  @override
  _ViewStoryState createState() => _ViewStoryState();
}

class _ViewStoryState extends State<ViewStory> {

  String _currentItemSelected;
  String _title,_story,_mediaPath,_mediaType;
  bool _showSpinner = false;

  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }


  checkMoodValue(){
      _currentItemSelected = widget.mood;
  }

  @override
  void didChangeDependencies() {
    checkMoodValue();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final _data = Provider.of<StoryProvider>(context);

    return ModalProgressHUD(
      inAsyncCall: _showSpinner,
      child: Scaffold(
        key: _scaffoldKey,
        bottomNavigationBar: bottomNav(context, colorPicker(),true),
        body: Container(
          height: 1.sh,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.white,
                  colorPicker(),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              )
          ),
          child: Padding(
            padding: EdgeInsets.only(left:30.0.w,right: 30.w,top: 80.w),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    textStory1FromField('Add a title..',
                      widget.title,
                          (value){_title=value;},
                          (val)=> val.isEmpty ? 'enter title' : null,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        dropDown(),
                        GestureDetector(
                          onTap: ()async{
                            // final Email email = Email(
                            //   body: 'title: ${widget.title} \n mood: ${widget.mood} \n story: ${widget.story}',
                            //   subject: 'Story',
                            //   isHTML: false,
                            // );
                            //
                            // await FlutterEmailSender.send(email).catchError((error){
                            //   print(error);
                            // });
                            addRecipients();
                          },
                          child: Container(
                            width: 250.w,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(color: primary)
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(10.0.w),
                              child: Row(
                                // mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  text(name: 'E-Mail',color: primary,fontWeight: FontWeight.normal,fontSize: 17),
                                  Icon(Icons.send),
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),

                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 30.w),
                      child: text(name: widget.date,fontWeight: FontWeight.normal,fontSize: 35.sp),
                    ),

                    Container(
                      height: .45.sh,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: primary),
                        color: Colors.white,
                      ),
                      child: textStory2FromField('Click to write story...',
                        widget.story,
                            (value){_story=value;},
                            (val)=> val.isEmpty ? 'enter story' : null,
                      ),
                    ),

                    SizedBox(height: 20.w),

                    GestureDetector(
                      onTap: (){
                        if(widget.mediaPath!=null){
                          if(widget.mediaType=="picture"){
                            Navigator.pushNamed(context, router.fullPhoto);
                          }
                          else{
                            Navigator.pushNamed(context, router.videoPlayer);
                          }
                        }
                        else{
                          checkMediaValidation();
                        }
                      },
                      child: Container(
                        height: 75.h,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(color: primary,width: 3.w)
                        ),
                        child: Center(
                          child: text(
                            name: 'Show Media',
                            fontSize: 17,
                          ),
                        ),
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 35.w),
                      child: GestureDetector(
                        onTap: ()async{
                          checkMediaExtension();

                        },
                        child: Container(
                          height: 75.h,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(color: primary,width: 3.w)
                          ),
                          child: Center(
                            child: text(name: '+ Attach Media',fontWeight: FontWeight.normal,fontSize: 17),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: ()async{
                        final form = _formKey.currentState;
                        if (form.validate()) {
                          form.save();

                            setState(() {
                              _showSpinner = true;
                            });
                            _data.updateStory(context, StoryModel(
                              title: (_title!=null)?_title:widget.title,
                              mood: _currentItemSelected,
                              mediaPath: (_mediaPath!=null)?_mediaPath:widget.mediaPath,
                              mediaType: (_mediaType!=null)?_mediaType:widget.mediaType,
                              date: widget.date,
                              story: (_story!=null)?_story:widget.story,
                            ));
                          }
                      },
                      child: Container(
                        height: 75.h,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(color: primary,width: 3.w)
                        ),
                        child: Center(
                          child: text(name:'Save Changes',fontWeight: FontWeight.normal,fontSize: 17),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color colorPicker(){
    if(_currentItemSelected=='Happy'){
      return background1;
    }
    else if(_currentItemSelected=='Sad'){
      return background2;
    }
    else if(_currentItemSelected=='Angry'){
      return background3;
    }

    return background;
  }

  Widget dropDown(){
    return Container(
      height: 70.0.h,
      width: 350.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: primary),
        color: story_mood,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        child: DropdownButtonHideUnderline(
          child: Theme(
            data: Theme.of(context).copyWith(
              canvasColor: story_mood,),
//                    alignedDropdown: true,
            child: new DropdownButton<String>(
                icon: Icon(Icons.arrow_drop_down_circle_outlined),
                focusColor: primary,
                iconDisabledColor: Colors.black,
                iconEnabledColor: Colors.black,
                items: <String>[
                  'Pick a mood...',
                  'Happy',
                  'Sad',
                  'Angry',
                ].map((String value) {
                  return new DropdownMenuItem<String>(
                    value: value,
                    child: new Text(value, style: TextStyle(color: Colors.black),),
                  );
                }).toList(),
                onChanged: (String newValueSelected) {
                  setState(() {
                    _currentItemSelected = newValueSelected;
                  });
                },
                hint: Text("Pick a mood..."),
                value: _currentItemSelected
            ),
          ),
        ),
      ),
    );
  }

  checkMediaExtension(){
    showDialog(
        context: (context),
        builder: (context)=>AlertDialog(
          title: Text('Please select one of these:'),
          content:Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FlatButton(
                onPressed:()async{
                  FilePickerResult result = await FilePicker.platform.pickFiles(type: FileType.image);
                  if(result != null) {
                    print(result.files.single.path);
                    _mediaPath = result.files.single.path;
                    _mediaType ='picture';
                    Navigator.pop(context);
                  } else {}
                },
                child: Text('Picture'),
              ),
              FlatButton(
                onPressed:()async{
                  FilePickerResult result = await FilePicker.platform.pickFiles(type: FileType.video);
                  if(result != null) {
                    print(result.files.single.path);
                    _mediaPath = result.files.single.path;
                    _mediaType ='video';
                    Navigator.pop(context);
                  } else {}
                },
                child: Text('Video'),
              ),
            ],
          ),
          actions: [
            FlatButton(onPressed: (){
              Navigator.pop(context);
            }, child: Text('Cancel')),
          ],
        ));
  }

  checkValidation(){
    showDialog(
        context: (context),
        builder: (context)=>AlertDialog(
          title: Text('Warning!'),
          content:Text('Please select mood') ,
          actions: [
            FlatButton(onPressed: (){
              Navigator.pop(context);
            }, child: Text('Cancel',style: TextStyle(color: primary),)),
          ],
        ));
  }

  checkMediaValidation(){
    showDialog(
        context: (context),
        builder: (context)=>AlertDialog(
          title: Text('Warning!'),
          content:Text('Please attach media first') ,
          actions: [
            FlatButton(onPressed: (){
              Navigator.pop(context);
            }, child: Text('Cancel',style: TextStyle(color: primary),)),
          ],
        ));
  }

  addRecipients(){
    showDialog(
        context: (context),
        builder: (context)=>AlertDialog(
          title: Text('Enter recipients email:'),
          content: TextField(
            onChanged: (value){
              recipientsEmail=value;
            },
            decoration: InputDecoration(
              hintText: 'email',
            ),
          ),
          actions: [
            FlatButton(onPressed: (){
              Navigator.pop(context);
            }, child: Text('Cancel',style: TextStyle(color: primary),)),
            FlatButton(onPressed: (){
              if(recipientsEmail.length==0 || recipientsEmail!=null)
                sendEmail();
              Navigator.pop(context);

            }, child: Text('Ok',style: TextStyle(color: primary),)),
          ],
        ));
  }

  String recipientsEmail;

  sendEmail()async{
    final _data = Provider.of<StoryProvider>(context,listen: false);

    String adminEmail = 'noreply.lifestoryapp@gmail.com';
    String adminPassword = 'Password321';


    setState(() {
      _showSpinner=true;
    });
    final smtpServer = gmail(adminEmail, adminPassword);

    final message = Message()
      ..from = Address(adminEmail)
      ..recipients.add(recipientsEmail)
      ..subject = 'Story'
    // ..text ='title: ${_data.documents['title']} \n mood: ${_data.documents['mood']} \n story: ${_data.documents['story']}'
      ..html=

          '<a'
          'href="https://www.firebase.com/"> '
          '<img alt="Mosque" src="https://firebasestorage.googleapis.com/v0/b/life-story-d18d0.appspot.com/o/AppLogo.png?alt=media&token=4d7483fa-cf3e-4d43-a6fc-3dfe2124e9a1"width=100" height="100">'
          '</a>'

          '<h3 style="color:#B659FF; text-align:center; font-size:20px;">Story</h3>'
      //
      //     '<h4 style="text-align:center; font-size:18px; ">Details:</h4>'
      //
      //     '<ul>'
          '<li style= "font-size:18px;"><span style= "font-size:18px;">Title: </span><span style="color:#B659FF;font-size:18px;">${_data.documents['title']}</span></li>'
          '<li style= "font-size:18px;"><span style= "font-size:18px;">Mood: </span><span style="color:#B659FF;font-size:18px;">${_data.documents['mood']}</span></li>'
          '<li style= "font-size:18px;"><span style= "font-size:18px;">Story: </span><span style="color:#B659FF;font-size:18px;">${_data.documents['story']}</span></li>'
    //     '<li style= "font-size:18px;"><span style= "font-size:18px;">Phone Number: </span><span style="color:#B68747;font-size:18px;">$phoneNumber</span></li>'
    //     '<li style= "font-size:18px;"><span style= "font-size:18px;">Imaam Name: </span><span style="color:#B68747;font-size:18px;">$imaamName</span></li>'
    //     '</ul>'
        ;
    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ' + sendReport.toString());
      if(sendReport.toString()!=null){
        setState(() {
          _showSpinner=false;
        });
        showInSnackBar('Message Sent');
      }
    } on MailerException catch (e) {
      print('Message not sent.');
      setState(() {
        _showSpinner=false;
      });
      showInSnackBar('Message not sent. Please Try again');
      for (var p in e.problems) {
        print('Problem: ${p.code}: ${p.msg}');
      }
    }

  }
  void showInSnackBar(String text) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(text,style: TextStyle(color: Colors.white,fontSize: 18),),
    ));
  }
}
