
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:life_story/Model/storyModel.dart';

Firestore _fireStore = Firestore.instance;
FirebaseAuth _auth = FirebaseAuth.instance;

class StoryProvider with ChangeNotifier {

Map<String , dynamic> documents;
int streak;
String id;
bool check=true;
bool streakCheck=true;

addStory(BuildContext context,StoryModel story)async{

    final id = (await _auth.currentUser()).uid;

  await _fireStore.collection('Story').document(id).collection('UserStory').document(story.date).setData({
    'title':story.title,
    'mood':story.mood,
    'story':story.story,
    'mediaPath':story.mediaPath,
    'mediaType':story.mediaType,
    'time':DateTime.now(),
    'date':story.date,
    'uid':id,
  }).then((value) async{

    String date;
    int count;
  await _fireStore.collection('Story').document(id).get().then((value)async{


    String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

    if(value.data==null){
      await _fireStore.collection('Story').document(id).setData({
        'date':formattedDate,
        'count':1,
        'uid':id,
      });
    }
    else{
      date = value.data['date'];
      count=value.data['count'];

      DateTime previous =DateTime.parse(date);
      DateTime next =DateTime.parse(formattedDate);

      int day = next.difference(previous).inDays;

      if(day==1){
        await _fireStore.collection('Story').document(id).updateData({
          'date':formattedDate,
          'count': count + 1,
        });
      }
      else if(day>1){
        await _fireStore.collection('Story').document(id).updateData({
          'date':formattedDate,
          'count': 1,
        });
      }

        print(day);
    }

  });


    Navigator.pop(context);
  });
}

updateStory(BuildContext context,StoryModel story)async{

    final id = (await _auth.currentUser()).uid;

  await _fireStore.collection('Story').document(id).collection('UserStory').document(story.date).updateData({
    'title':story.title,
    'mood':story.mood,
    'story':story.story,
    'mediaPath':story.mediaPath,
    'mediaType':story.mediaType,
  }).then((value) => Navigator.pop(context));
}

getStoryData(String date)async{
  final id = (await _auth.currentUser()).uid;
  await _fireStore.collection('Story').document(id).collection('UserStory').document(date).get().then((value){
    documents = value.data;
   check=false;

   print('sadsaasdasd');
  });
  print(documents);
  notifyListeners();
}

getId()async{
  id = (await _auth.currentUser()).uid;
}

getStreak()async{
  final id = (await _auth.currentUser()).uid;

  await _fireStore.collection('Story').document(id).get().then((value) {
    streak = value.data['count'];
    streakCheck=false;

  });
  notifyListeners();
}

}