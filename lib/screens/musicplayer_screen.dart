import 'dart:io';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player_project_one/hive_db/db_recent_list.dart';
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
  ValueNotifier<List<ModalClassAllSongs>> valueNotifierImage=ValueNotifier([]);

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

    if (getPlayingStatus() != true) {
      print("get PLaying Status IF FALSE ${getPlayingStatus()}");
      playerControllers.playSong(uri);
      List<String> songNameTitles=[];
      ModalClassAllSongs modalAllSongs = ModalClassAllSongs(uri: uri,
          artist: songList[index].artist,
          title: songList[index].title,
          display_name: songList[index].display_name,
          album: songList[index].album,
          id: songList[index].id);
      songNameTitles=getNameCheck();
      if(!songNameTitles.contains(modalAllSongs.display_name)){
        addRecentData(modalAllSongs);
        if(songNameTitles.length==10){
          removeLastSong();
        }
      }
    }

    putPlayingStatus(true);

    return Scaffold(
      body: fullPlayer(heightSheet, context),
    );
  }

  image(){
    int im=0;
    do{
      im=intImage;
    }while(0>0);
    return im;
  }

  fullPlayer(double heightSheet, BuildContext context) {
    int currentIndex=index;

    return SafeArea(
      child: Container(
        constraints:
            BoxConstraints(minHeight: heightSheet, maxHeight: heightSheet),
        decoration: const BoxDecoration(color: Colors.blueGrey),
        child: Column(children: [

          Expanded(
              child: Padding(
            padding: const EdgeInsets.only(top: 10.0, right: 10.0),
            child: StreamBuilder<Duration>(
              stream: playerControllers.audioPlayer.positionStream,
              builder:
                  (BuildContext context, AsyncSnapshot<Duration> snapshot) {
                var currentPosition = snapshot.data ?? Duration.zero;
                var totalDuration =
                    playerControllers.audioPlayer.duration ?? Duration.zero;
     //           print("currentPosition   $currentPosition");
     //           print("totalDuration   $totalDuration");
           //     valueNotifierImage.value.addAll(songList);
                return Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      songList[currentIndex].display_name,
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      songList[currentIndex].artist!,
                      style: const TextStyle(color: Colors.white),
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
                            id: songList[currentIndex].id,
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
                    Column(
                      children: [
                        Slider(
                            inactiveColor: Colors.grey,
                            thumbColor: Colors.white,
                            activeColor: Colors.white,
                            min: 0,
                            max: totalDuration.inSeconds.toDouble(),
                            value: currentPosition.inSeconds.toDouble(),
                            onChanged: (value) {
                              final position = Duration(seconds: value.toInt());
                              playerControllers.audioPlayer.seek(position);
                              //player.resume();
                            }),
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 10.0, right: 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                formatTime(currentPosition.inSeconds.toInt()),
                                style: const TextStyle(color: Colors.white),
                              ),
                              Text(
                                formatTime((totalDuration.inSeconds.toInt())),
                                style: const TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 50,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                                height:60,
                                width:60,
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(100.0),
                                ),
                                child: IconButton(
                                    onPressed: () {
                                      if (currentIndex == 0) {
                                        currentIndex = 0;
                                        playerControllers.scaffoldMessage(context, "No song ahead");
                                      } else if (currentIndex > 0) {
                                        currentIndex--;
                                        playerControllers.stopSong();
                                        playWithDelay(songList[currentIndex].uri, currentIndex);
                                      }
                                      print(
                                          "currentIndex PREVIOUS    $currentIndex");

                                    },
                                    icon: const Icon(
                                      Icons.skip_previous,size: 35,
                                    ))),
                            const SizedBox(
                              width: 60,
                            ),
                            Container(
                                height:60,
                                width:60,
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(100.0),
                                ),
                                child: IconButton(
                                    onPressed: () {
                                      print(
                                          "isplaying${playerControllers.isPlaying}");
                                      if (getPlayingStatus() == false) {
                                        playerControllers.playSong(songList[currentIndex].uri);
                                      } else {
                                        playerControllers.pauseSong();
                                      }
                                    },
                                    icon: Icon(getPlayingStatus() &&
                                            currentPosition < totalDuration
                                        ? Icons.pause
                                        : Icons.play_arrow,size: 35,))),
                            const SizedBox(
                              width: 60,
                            ),
                            Container(
                              height:60,
                                width:60,
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(100.0),
                                ),
                                child: IconButton(
                                    onPressed: () {
                                      if (currentIndex == songList.length-1) {
                                        currentIndex = songList.length-1;
                                        playerControllers.scaffoldMessage(context, "Last Song");
                                      } else if (currentIndex < songList.length-1) {
                                        currentIndex++;
                                        playerControllers.stopSong();
                                        putPlayingStatus(false);
                                        playWithDelay(songList[currentIndex].uri, currentIndex);
                                      }

                                      print(
                                          "currentIndex NEXT    $currentIndex");
                                    },
                                    icon: const Icon(Icons.skip_next,size: 35,))),
                          ],
                        ),
                        SizedBox(height: 40,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                          Container(
                              height:60,
                              width:60,
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(100.0),
                              ),
                              child: IconButton(
                                  onPressed: () {
                                    if (currentIndex == songList.length-1) {
                                      currentIndex = songList.length-1;
                                      playerControllers.scaffoldMessage(context, "Last Song");
                                    } else if (currentIndex < songList.length-1) {
                                      currentIndex++;
                                      playerControllers.stopSong();
                                      putPlayingStatus(false);
                                      playWithDelay(songList[currentIndex].uri, currentIndex);
                                    }

                                    print(
                                        "currentIndex NEXT    $currentIndex");
                                  },
                                  icon: const Icon(Icons.favorite_border,size: 35,))),
                          SizedBox(width:60),
                          Container(
                              height:60,
                              width:60,
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(100.0),
                              ),
                              child: IconButton(
                                  onPressed: () {
                                    if (currentIndex == songList.length-1) {
                                      currentIndex = songList.length-1;
                                      playerControllers.scaffoldMessage(context, "Last Song");
                                    } else if (currentIndex < songList.length-1) {
                                      currentIndex++;
                                      playerControllers.stopSong();
                                      putPlayingStatus(false);
                                      playWithDelay(songList[currentIndex].uri, currentIndex);
                                    }

                                    print(
                                        "currentIndex NEXT    $currentIndex");
                                  },
                                  icon: const Icon(Icons.shuffle,size: 35,)))
                        ],)
                      ],
                    ),
                  ],
                );
              },
            ),
          ))
        ]),
      ),
    );
  }

  playWithDelay(String? uri, int currentIndex) {
    //PlayerControllers playerControllers2=PlayerControllers();
    return Future.delayed(const Duration(milliseconds: 100), () {
      playerControllers.playSong(uri);
    });
  }
}
