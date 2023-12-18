import 'dart:io';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player_project_one/utils/controllers.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'dart:core';
//import 'package:audioplayers/audioplayers.dart';
import '../hive_db/db_functions.dart';
import '../modal_class/songList.dart';

class BottomSheetPlayer extends StatefulWidget {
  final String? uri;
  final int index;
  List<ModalClassAllSongs> songList = [];
  int intImage;
  final String? songTitle;
  final String? artistName;

  BottomSheetPlayer(
      {required this.uri,
      required this.index,
      super.key,
      required this.songList,
      required this.intImage,
      this.songTitle,
      this.artistName});

  @override
  State<BottomSheetPlayer> createState() => _BottomSheetPlayerState();
}

class _BottomSheetPlayerState extends State<BottomSheetPlayer> {
  String? uri = "";
  int index = 0;
  List<ModalClassAllSongs> songList = [];
  int intImage = 0;
  bool clickedArrow = true;
  String? songTitle;
  bool? isLayoutVisible;
  String? artistName;
  PlayerControllers playerControllers = PlayerControllers();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    playerControllers.audioPlayer.dispose();
  }
  String formatTime(int seconds) {
    return '${(Duration(seconds: seconds))}'.split('.')[0].padLeft(8, '0');
  }

@override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    uri = widget.uri;
    index = widget.index;
    songList = widget.songList;
    intImage = widget.intImage;
    songTitle = widget.songTitle;
    artistName = widget.artistName;
    //  isLayoutVisible=widget.isLayoutVisible;
    print("BottomSheetPlayer      toPlayerUri $uri\n"
        "BottomSheetPlayer        toPlayerIndex $index\n"
        "BottomSheetPlayer        toPlayerModal $songList\n"
        "BottomSheetPlayer        songImage $intImage\n"
        "BottomSheetPlayer        toPlayerTitle $songTitle\n");
    double heightSheet = MediaQuery.of(context).size.height;

    if(getPlayingStatus()!=true) {
      print("get PLaying Status IF FALSE ${getPlayingStatus()}");
      playerControllers.playSong(uri, index);
    }
    putPlayingStatus(true);

    return Scaffold(
      body: fullPlayer(heightSheet, context),
    );
  }

  fullPlayer(double heightSheet, BuildContext context) {
    return SafeArea(
      child: Container(
        constraints:
            BoxConstraints(minHeight: heightSheet, maxHeight: heightSheet),
        decoration: const BoxDecoration(color: Colors.blueGrey),
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.only(top: 5.0),
            child: GestureDetector(
              onTap: () {
                //        print("ctx    ${ctx.globalPosition}     ${ctx.localPosition}");
                setState(() {
                  clickedArrow = !clickedArrow;
                });
              },
              child: Icon(
                !clickedArrow
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down_sharp,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.only(top: 10.0, right: 10.0),
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                Text(
                  songTitle!,
                  style: TextStyle(color: Colors.white),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  artistName!,
                  style: TextStyle(color: Colors.white),
                ),
                const SizedBox(
                  height: 40,
                ),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50.0),
                      color: Colors.grey[100]),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                        maxHeight: 300,
                        maxWidth: 300,
                        minHeight: 300,
                        minWidth: 300),
                    child: QueryArtworkWidget(
                        id: intImage,
                        type: ArtworkType.AUDIO,
                        artworkHeight: 300,
                        artworkWidth: 300,
                        quality: 100,
                        nullArtworkWidget: const Icon(
                          Icons.music_note,
                          color: Colors.black,
                          size: 200,
                        )),
                  ),
                ),
              /*  ValueListenableBuilder(
                  valueListenable: null,
                  builder: (BuildContext context, value, Widget? child) {
                    return */
                      Column(
                      children: [

                        StreamBuilder<Duration>(
                          stream: playerControllers.audioPlayer.positionStream,
                          builder: (context, snapshot) {
                            var currentPosition = snapshot.data ?? Duration.zero;
                            var totalDuration = playerControllers.audioPlayer.duration ?? Duration.zero;
                            print("currentPosition   $currentPosition");
                            print("totalDuration   $totalDuration");
                            return Column(
                              children: [
                                Slider(
                                    inactiveColor: Colors.grey,
                                    thumbColor: Colors.white,
                                    activeColor: Colors.white,
                                    min: 0,
                                    max: totalDuration.inSeconds.toDouble(),
                                    value: currentPosition.inSeconds.toDouble(),
                                    onChanged: (value) {
                                      final position=Duration(seconds: value.toInt());
                                      playerControllers.audioPlayer.seek(position);
                                      //player.resume();
                                    }),
                                Padding(
                                  padding: const EdgeInsets.only(left:10.0,right: 10.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        formatTime(currentPosition.inSeconds.toInt()),
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      Text(
                                        formatTime((totalDuration.inSeconds.toInt())),
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 30,),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                        decoration:BoxDecoration(
                                          color: Colors.grey[100],
                                          borderRadius: BorderRadius.circular(100.0),
                                        ),
                                        child: IconButton(onPressed: () {
                                          setState(() {
                                            playerControllers.audioPlayer.seekToPrevious();
                                          });
                                        }, icon: Icon(Icons.skip_previous,))),
                                    SizedBox(width:30,),
                                    Container(
                                        decoration:BoxDecoration(
                                          color: Colors.grey[100],
                                          borderRadius: BorderRadius.circular(100.0),
                                        ),
                                        child: IconButton(onPressed: () {
                                              print("isplaying${playerControllers.isPlaying}");
                                              if(getPlayingStatus()==false) {
                                                playerControllers.playSong(
                                                    uri, index);
                                              }else{
                                                playerControllers.pauseSong();
                                              }
                                        }, icon: Icon(getPlayingStatus() && currentPosition <totalDuration
                                            ?Icons.pause
                                            :Icons.play_arrow))),
                                    SizedBox(width: 30,),
                                    Container(
                                        decoration:BoxDecoration(
                                          color: Colors.grey[100],
                                          borderRadius: BorderRadius.circular(100.0),
                                        ),
                                        child: IconButton(onPressed: () {
                                          setState(() {
                                            playerControllers.audioPlayer.seekToNext();
                                          });
                                        }, icon: Icon(Icons.skip_next))),
                                  ],
                                )
                              ],
                            );
                          }
                        ),


                      /*  LinearProgressIndicator(
                          color: Colors.black,
                          backgroundColor: Colors.grey,
                          value: currentProgress,
                        ),
*/

                      ],
                    ) ,
                /*  },
                ),*/

              ],
            ),
          ))
        ]),
      ),
    );
  }


}
