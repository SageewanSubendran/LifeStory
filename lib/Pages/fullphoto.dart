import 'dart:io';

import 'package:flutter/material.dart';
import 'package:life_story/Provider/storyProvider.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:provider/provider.dart';

class FullPhoto extends StatefulWidget {
  // final String url;
  //
  // FullPhoto({Key key,@required this.url}) : super(key: key);
  @override State createState() => new _FullPhoto();
}

class _FullPhoto extends State<FullPhoto> {
  @override
  Widget build(BuildContext context) {
    final _data = Provider.of<StoryProvider>(context);

    return Scaffold(
      appBar: AppBar(),
      body: GestureDetector(
        child: Container(
            decoration: BoxDecoration(
              color: Colors.black,
            ),
            child: Stack(
              alignment: Alignment.bottomRight,
              children: <Widget>[
                PhotoViewGallery.builder(
                  scrollPhysics: const BouncingScrollPhysics(),
                  builder: (BuildContext context, int index) {
                    File file = File(_data.documents['mediaPath']);
                    return PhotoViewGalleryPageOptions(
                      imageProvider: FileImage(file),
                      initialScale: PhotoViewComputedScale.contained,
                      minScale: PhotoViewComputedScale.contained,
                      maxScale: PhotoViewComputedScale.covered * 1.5,
                    );
                  },
                  itemCount: 1,
                  loadingBuilder: (context, event) => Center(
                    child: Container(
                      width: 20.0,
                      height: 20.0,
                      child: CircularProgressIndicator(
                        value: event == null ? 0 : event.cumulativeBytesLoaded / event.expectedTotalBytes,
                      ),
                    ),
                  ),
                  backgroundDecoration: BoxDecoration(
                    color: Colors.black,
                  ),
                ),
              ],
            )
        ),
        onTap: () {
          Navigator.of(context).pop();
        },
      ),
    );
  }
}