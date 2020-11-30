import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:life_story/configuration/colors.dart';

Widget text({String name, double fontSize, Color color, FontWeight fontWeight, String fontFamily}) {

  return Text(name, style: TextStyle(
      fontSize: fontSize, color: color, fontWeight: fontWeight,fontFamily: fontFamily),);
}

Widget textFromField(String name,bool check,Function onSaved, Function validator){
  return TextFormField(
    validator: validator,
    onSaved: onSaved,
    obscureText: (check)?true:false,
    decoration: InputDecoration(
        hintText: name,
    ),
  );
}

Widget textStory1FromField(String name,String initialValue ,Function onSaved,Function validator){
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 12.w,horizontal: 30.w),
    child: TextFormField(
      initialValue: initialValue,
      validator: validator,
      maxLength: 30,
      cursorColor: primary,
      onSaved: onSaved,
      decoration: InputDecoration(
        suffixIcon: Icon(Icons.create,color: Colors.black,),
          hintText: name,
          hintStyle: TextStyle(color: primary),
          // fillColor: Colors.white,
          // filled: true,
          border: OutlineInputBorder(
            borderRadius: const BorderRadius.all(const Radius.circular(30.0),),
            borderSide: BorderSide(color: primary, width: 3.0.w),),
          contentPadding: EdgeInsets.fromLTRB(30.0.w, 35.0.w, 30.0.w, 35.0.w),
          enabledBorder: OutlineInputBorder(
              borderRadius:BorderRadius.circular(30.0),
              borderSide: BorderSide(color: primary, width: 3.0.w)
          )
      ),
    ),
  );
}

Widget textStory2FromField(String name,String initialValue,Function onSaved,Function validator,){
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 12.w,horizontal: 30.w),
    child: TextFormField(
      initialValue: initialValue,
      validator: validator,
      keyboardType: TextInputType.multiline,
      maxLines: null,
      cursorColor: primary,
      onSaved: onSaved,
      decoration: InputDecoration(
          hintText: name,
          hintStyle: TextStyle(color: Colors.grey),
        border: InputBorder.none,
        focusedBorder: InputBorder.none,
        enabledBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        disabledBorder: InputBorder.none,

      ),
    ),
  );
}

Widget iconTextFromField(String name, Function onChange, Icon icon){
  return TextFormField(
    onChanged: onChange,
    cursorColor: primary,
    decoration: InputDecoration(
        prefixIcon: icon,
        hintText: name,
        fillColor: Colors.white,
        filled: true,
        // border: OutlineInputBorder(
        //   borderRadius: BorderRadius.all(Radius.circular(30.0),),
        //   borderSide: BorderSide(color: primary, width: 3.0.w),),
        contentPadding: EdgeInsets.fromLTRB(30.0.w, 35.0.w, 30.0.w, 35.0.w),
        enabledBorder: OutlineInputBorder(
            borderRadius:BorderRadius.circular(30.0),
            borderSide: BorderSide(color: primary, width: 3.0.w),
        ),
      focusedBorder:OutlineInputBorder(
        borderSide: BorderSide(color: primary, width: 3.0.w),
        borderRadius:BorderRadius.circular(30.0),
      ),
    ),
  );
}
