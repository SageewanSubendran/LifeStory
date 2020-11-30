import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:life_story/Provider/storyProvider.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class VideoPlayer1 extends StatefulWidget {
  

  @override
  _VideoPlayer1State createState() => _VideoPlayer1State();
}

class _VideoPlayer1State extends State<VideoPlayer1> {

  VideoPlayerController _videoPlayerController1;
  ChewieController _chewieController;

  Future<void> _future;

  Future<void> initVideoPlayer() async {
    await _videoPlayerController1.initialize();
    setState(() {
      print(_videoPlayerController1.value.aspectRatio);
      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController1,
        aspectRatio: _videoPlayerController1.value.aspectRatio,
        autoPlay: false,
        looping: false,
      );
    });
  }

  // @override
  // void initState() {
  //   super.initState();

//    _chewieController = ChewieController(
//      videoPlayerController: _videoPlayerController1,
//      aspectRatio: 3/2,
////      _videoPlayerController1.value.aspectRatio,
////      autoPlay: true,
//      looping: true,
//      materialProgressColors: ChewieProgressColors(
//        playedColor: Colors.red,
//        handleColor: Colors.blue,
//        backgroundColor: Colors.grey,
//        bufferedColor: Colors.lightGreen,
//      ),
//      placeholder: Container(
//        color: Colors.grey,
//      ),
//      autoInitialize: true,
//    );
//   }

  @override
  void didChangeDependencies() {
    final _data = Provider.of<StoryProvider>(context);
    File file = File(_data.documents['mediaPath']);
    _videoPlayerController1 = VideoPlayerController.file(file);
    _future = initVideoPlayer();
    super.didChangeDependencies();
  }


  @override
  void dispose() {
    _videoPlayerController1.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Color(0xFF282830),

      body: SafeArea(
        child: Stack(
          alignment: Alignment.topLeft,
          children: [

            FutureBuilder(
                future: _future,
                builder: (context, snapshot) {
                  return new Center(
                    child: _videoPlayerController1.value.initialized
                        ? AspectRatio(
                      aspectRatio: _videoPlayerController1.value.aspectRatio,
                      child: Chewie(
                        controller: _chewieController,
                      ),
                    )
                        : new CircularProgressIndicator(),
                  );
                }
            ),
            IconButton(
              icon: Icon(Icons.arrow_back,color: Colors.blue,),
              onPressed: (){
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
