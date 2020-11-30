import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:life_story/Pages/Search/view_story.dart';
import 'package:life_story/Provider/storyProvider.dart';
import 'package:life_story/configuration/colors.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


Firestore _fireStore = Firestore.instance;

class SearchStory extends SearchDelegate<String> {


  @override
  ThemeData appBarTheme(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return theme.copyWith(
      primaryColor: primary,
      primaryIconTheme: theme.primaryIconTheme.copyWith(color: Colors.white),
      primaryColorBrightness: Brightness.dark,
      textTheme: theme.textTheme.copyWith(
        title: TextStyle(fontWeight: FontWeight.normal,color: Colors.black),
      ),
      // these ↓ do not work ☹️
      appBarTheme: theme.appBarTheme.copyWith(color: Colors.black12, elevation: 0),
      inputDecorationTheme: theme.inputDecorationTheme.copyWith(border: UnderlineInputBorder()),
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return null;
  }

  @override
  Widget buildSuggestions(BuildContext context) {

    final _data = Provider.of<StoryProvider>(context).getId();
    final _idData = Provider.of<StoryProvider>(context);

    return Container(
      height: MediaQuery.of(context).size.height,
      color: background,
      child: FutureBuilder<QuerySnapshot>(
        future: _fireStore
            .collection('Story').document(_idData.id).collection('UserStory').
            where('title',isGreaterThanOrEqualTo: query,)
            .getDocuments(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          final List<String> empty = [];

          final List<String> title = [];
          final List<String> mood = [];
          final List<String> story = [];
          final List<String> date = [];
          final List<String> mediaPath=[];
          final List<String> mediaType=[];


          final message = snapshot.data.documents;
          message.map(
                (doc) {
              title.add(doc.data['title']);
              mood.add(doc.data['mood']);
              story.add(doc.data['story']);
              date.add(doc.data['date']);
              mediaPath.add(doc.data['mediaPath']);
              mediaType.add(doc.data['mediaType']);

            },
          ).toList();

          final title1 = query.isEmpty
              ? empty
              :
          title.where((p) => p.startsWith(query)).toList();

          return ListView.builder(
              itemCount: title1.length,
              itemBuilder: (context, index) {
                print('aas: ${date[index]}');

                return Padding(
                  padding: EdgeInsets.all(30.w),
                  child: GestureDetector(
                    onTap: ()async{
                      // print(date[index]);
                      await Navigator.push(context, MaterialPageRoute(builder: (context){
                        return ViewStory(
                          title: title[index],
                          mood: mood[index],
                          story: story[index],
                          date: date[index],
                          mediaPath: mediaPath[index],
                          mediaType: mediaType[index],
                        );
                      }));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: primary,width: 4.w)
                      ),
                      child: ListTile(
                        title: RichText(
                          text: TextSpan(
                            text: title[index].substring(0,query.length),
                            style: TextStyle(
                                color: Colors.black, fontWeight: FontWeight.bold,fontSize: 20),
                            children: [
                              TextSpan(
                                  text: title[index].substring(query.length),
                                  style: TextStyle(color: Colors.grey,fontSize: 18))
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              });
        },
      ),
    );
  }
}

// class ViewStory extends StatefulWidget {
//   final List title;
//   final List date;
//   final int index;
//   final String query;
//   ViewStory({this.title,this.date,this.index,this.query});
//   @override
//   _ViewStoryState createState() => _ViewStoryState();
// }
//
// class _ViewStoryState extends State<ViewStory> {
//   @override
//   Widget build(BuildContext context) {
//     return
//   }
// }

