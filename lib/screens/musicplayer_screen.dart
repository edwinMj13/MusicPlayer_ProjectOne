import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player_project_one/hive_db/db_favorite_list.dart';
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
  final VoidCallback setStateMethod;

  BottomSheetPlayer(
      {required this.uri,
      required this.index,
      super.key,
      required this.songList,
      required this.intImage,
      this.songTitle,
      this.artistName,required this.setStateMethod()});

  @override
  State<BottomSheetPlayer> createState() => _BottomSheetPlayerState();
}


class _BottomSheetPlayerState extends State<BottomSheetPlayer> {
  String? uri = "";
  int index = 0;
  List<ModalClassAllSongs> songListThisPage = [];
  List<ModalClassAllSongs> songList = [];
  int intImage = 0;
  bool clickedArrow = true;
  String? songTitle;
  bool? isLayoutVisible;
  String? artistName;
  PlayerControllers playerControllers = PlayerControllers();
  ValueNotifier<List<ModalClassAllSongs>> valueNotifierImage =
      ValueNotifier([]);


  ValueNotifier<bool> isShuffled = ValueNotifier(false);
  ValueNotifier<int> musicImage = ValueNotifier(0);
  int idImg = 0;
  bool imgState = false;
  bool shuffleStatus = false;
  dynamic setStateSetterDynamic;
  late ConcatenatingAudioSource playlist;
  dynamic currentIndex;
  bool secStatus=false;
  dynamic setStateMethod;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    playerControllers.audioPlayer.dispose();
    songList = widget.songList;
  }

  String formatTime(int seconds) {
    return '${(Duration(seconds: seconds))}'.split('.')[0].padLeft(8, '0');
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  getPlaylistAutomatic() {
    for (var elem in songList) {
      playlist.children.add(AudioSource.uri(Uri.parse(elem.uri!)));
     // print("ELEMENT  ${elem.uri}");
    }
  }

  @override
  Widget build(BuildContext context) {

    playlist=ConcatenatingAudioSource( // Start loading next item just before reaching it
        useLazyPreparation: true,
        // Customise the shuffle algorithm
        shuffleOrder: DefaultShuffleOrder( ),
        children: [    AudioSource.uri(Uri.parse("content://media/external/audio/media/1000074539")),
    AudioSource.uri(Uri.parse("content://media/external/audio/media/1000391070")),
    AudioSource.uri(Uri.parse("content://media/external/audio/media/497608")),
    AudioSource.uri(Uri.parse("content://media/external/audio/media/1000334290")),
    AudioSource.uri(Uri.parse("content://media/external/audio/media/333")),
    AudioSource.uri(Uri.parse("content://media/external/audio/media/1000372743")),
    AudioSource.uri(Uri.parse("content://media/external/audio/media/1000334291")),
    AudioSource.uri(Uri.parse("content://media/external/audio/media/1000374630")),
    AudioSource.uri(Uri.parse("content://media/external/audio/media/10095")),
    AudioSource.uri(Uri.parse("content://media/external/audio/media/1000347089")),
    AudioSource.uri(Uri.parse("content://media/external/audio/media/483933")),
    AudioSource.uri(Uri.parse("content://media/external/audio/media/368491")),
    AudioSource.uri(Uri.parse("content://media/external/audio/media/368492")),
    AudioSource.uri(Uri.parse("content://media/external/audio/media/368493")),
    AudioSource.uri(Uri.parse("content://media/external/audio/media/1000322041")),
    AudioSource.uri(Uri.parse("content://media/external/audio/media/276395")),
    AudioSource.uri(Uri.parse("content://media/external/audio/media/1000322045")),
    AudioSource.uri(Uri.parse("content://media/external/audio/media/1000209870")),
    AudioSource.uri(Uri.parse("content://media/external/audio/media/1000334292"))]);

    secStatus=false;
    uri = widget.uri;
    index = widget.index;
    songListThisPage = widget.songList;
    // Define the playlist

    songList = widget.songList;
    intImage = widget.intImage;
    songTitle = widget.songTitle;
    artistName = widget.artistName;
    currentIndex = index;
     setStateMethod=widget.setStateMethod;
   // getPlaylistAutomatic();

    //  isLayoutVisible=widget.isLayoutVisible;
    print("BottomSheetPlayer      toPlayerUri $uri\n"
        "BottomSheetPlayer        toPlayerIndex $index\n"
        "BottomSheetPlayer        toPlayerModal $songList\n"
        "BottomSheetPlayer        songImage $intImage\n"
        "BottomSheetPlayer        toPlayerTitle $songTitle\n");
    double heightSheet = MediaQuery.of(context).size.height;
    print("n\n"
        "n\n"
        "n\n"
        "Widget Rebuilt"
        "n\n"
        "n\n"
        "n");
    print("getPlayingStatus() ${getPlayingStatus()}");
    if (getPlayingStatus() != true) {
      print("Rebuilt currentIndex $currentIndex");
      playerControllers.playSong(songList[currentIndex].uri,songList,index);
  //    playerControllers.playSongconCat(uri, playlist, index);
      print("MusicPLayer URI $uri");
      List<String> songNameTitles = [];
      ModalClassAllSongs modalAllSongs = ModalClassAllSongs(
          uri: uri,
          artist: songList[currentIndex].artist,
          title: songList[currentIndex].title,
          display_name: songList[currentIndex].display_name,
          album: songList[currentIndex].album,
          id: songList[currentIndex].id);
      songNameTitles = getNameCheck();
      if (!songNameTitles.contains(modalAllSongs.display_name)) {
        addRecentData(modalAllSongs);
        if (songNameTitles.length == 10) {
          removeLastSong();
        }
      }
    }

    putPlayingStatus(true);

    return WillPopScope(
      onWillPop: () async{
        Navigator.of(context).pop();
         setStateMethod();
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.blueGrey,
        body: fullPlayer(heightSheet, context),
      ),
    );
  }


  fullPlayer(double heightSheet, BuildContext context) {
    checkIfFavorite(songList[currentIndex].display_name);
    // imageListenableBuilder();
    return SafeArea(
      child: Container(
        constraints:
            BoxConstraints(minHeight: heightSheet, maxHeight: heightSheet),
        decoration: const BoxDecoration(color: Colors.blueGrey),
        child: Column(children: [
          const SizedBox(
            height: 30,
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
                  id: idImg,
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
          Padding(
            padding: const EdgeInsets.only(top: 10.0, right: 10.0),
            child: StreamBuilder<Duration>(
              stream: playerControllers.audioPlayer.positionStream,
              builder:
                  (BuildContext context, AsyncSnapshot<Duration> snapshot) {
                var currentPosition = snapshot.data ?? Duration.zero;
                var totalDuration =
                    playerControllers.audioPlayer.duration ?? Duration.zero;
              //  var valueS=secStatus ?const Duration(seconds: 0).inSeconds.toDouble():snapshot.data?.inSeconds.toDouble();
         //       print("   -------------      StreamBuilder is Running       ----------- ");
/*
                if (secStatus == true) {
                  //   double timer=currentPosition >= totalDuration ? 0:totalDuration.inSeconds.toDouble();
                  //  print("After SONGGGGGGGGG");
                  //   if(currentPosition>=totalDuration) {
                  secStatus=false;
                  try {
                    setState(() {
                      if (getPlayingStatus() ==
                          true) {
                        print(
                            "get PLaying Status IF TRUE ${getPlayingStatus()}");
                        playerControllers
                            .audioPlayer.stop();
                        playerControllers
                            .isPlaying = false;
                        putPlayingStatus(false);
                      }
                      songList.shuffle();
                              currentIndex = 0;
                    });
                  } on Exception catch (e){
                    print("Exception On Shuffle ${e.toString()}");
                  }

                  /*  playerControllers.playSong(songList[currentIndex].uri);
                              putPlayingStatus(true);*/
                }*/
                return Column(
                  children: [
                    const SizedBox(
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
                      height: 30,
                    ),
                    Column(
                      children: [
                        Slider(
                            inactiveColor: Colors.grey,
                            thumbColor: Colors.white,
                            activeColor: Colors.white,
                            min: 0,
                            max: totalDuration.inSeconds.toDouble(),
                            value: currentPosition.inSeconds.toDouble() ,
                            onChanged: (value) {
                               final position = Duration(
                                   seconds: value.toInt());
                               playerControllers.audioPlayer.seek(position);
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
                                height: 60,
                                width: 60,
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(100.0),
                                ),
                                child: IconButton(
                                    onPressed: () {
                                    /*  if (currentIndex == 0) {
                                        currentIndex = 0;
                                        playerControllers.scaffoldMessage(
                                            context, "First Song");
                                      } else if (currentIndex > 0) {
                                        currentIndex--;
                                        playerControllers.stopSong();
                                        imgState = false;
                                        playWithDelay(
                                            songList[currentIndex].uri,
                                            currentIndex);
                                      }
                                      print(
                                          "currentIndex PREVIOUS    $currentIndex");*/
                                      if(currentIndex!=0) {
                                        currentIndex--;
                                        playerControllers.stopSong();
                                        putPlayingStatus(false);
                                       // playerControllers.playSong(uri, songList, currentIndex);
                                        playerControllers.playSong(
                                            uri, songList, currentIndex);
                                      }else{
                                        playerControllers.scaffoldMessage(context, "Last Song");
                                      }
                                    },
                                    icon: const Icon(
                                      Icons.skip_previous,
                                      size: 35,
                                    ))),
                            const SizedBox(
                              width: 60,
                            ),
                            Container(
                                height: 60,
                                width: 60,
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(100.0),
                                ),
                                child: IconButton(
                                    onPressed: () {
                                      print(
                                          "isplaying${playerControllers.isPlaying}");
                                      if (getPlayingStatus() == false) {
                                   //     playerControllers.playSong(uri,songList,currentIndex);
                                        playerControllers.playSong(
                                            uri, songList, currentIndex);
                                      } else {
                                        playerControllers.pauseSong();
                                      }
                                    },
                                    icon: Icon(
                                      getPlayingStatus() &&
                                              currentPosition < totalDuration
                                          ? Icons.pause
                                          : Icons.play_arrow,
                                      size: 35,
                                    ))),
                            const SizedBox(
                              width: 60,
                            ),
                            Container(
                                height: 60,
                                width: 60,
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(100.0),
                                ),
                                child: IconButton(
                                    onPressed: () {
                                   /*   if (currentIndex == songList.length - 1) {
                                        currentIndex = songList.length - 1;
                                        playerControllers.scaffoldMessage(
                                            context, "Last Song");
                                      } else if (currentIndex <
                                          songList.length - 1) {
                                        currentIndex++;
                                        playerControllers.stopSong();
                                        putPlayingStatus(false);
                                        imgState = false;
                                        playWithDelay(
                                            songList[currentIndex].uri,
                                            currentIndex);
                                      }

                                      print(
                                          "currentIndex NEXT    $currentIndex");*/

                                      if(currentIndex!=songList.length-1) {
                                        currentIndex++;
                                        playerControllers.stopSong();
                                      putPlayingStatus(false);
                                       // playerControllers.playSong(uri, songList, currentIndex);
                                        playerControllers.playSong(
                                            uri, songList, currentIndex);
                                        print("clicked song Index for next   $index\n"
                                            "clicked song LENGTH for next   ${songList.length-1}\n");
                                      }else{
                                        playerControllers.scaffoldMessage(context, "Last Song");
                                      }
                                    },
                                    icon: const Icon(
                                      Icons.skip_next,
                                      size: 35,
                                    ))),
                          ],
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ValueListenableBuilder(
                              valueListenable: isFavNotifier,
                              builder: (BuildContext context, value, Widget? child) {
                                return Container(
                                    height: 60,
                                    width: 60,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[100],
                                      borderRadius: BorderRadius.circular(100.0),
                                    ),
                                    child: IconButton(
                                        onPressed: () {

                                        },
                                        icon: !value
                                            ? Icon(
                                          Icons.favorite_border,
                                          size: 35,
                                        )
                                            : Icon(
                                          Icons.favorite_border,
                                          color: Colors.redAccent,
                                          size: 35,
                                        )));
                              },
                            ),
                            SizedBox(width: 60),
                            ValueListenableBuilder(
                              valueListenable: isShuffled,
                              builder: (BuildContext context, value, Widget? child) {
                                return Container(
                                    height: 60,
                                    width: 60,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[100],
                                      borderRadius: BorderRadius.circular(100.0),
                                    ),
                                    child: IconButton(
                                        onPressed: () {
                                          print("Value Shuffle $value");
                                          isShuffled.value = !isShuffled.value;
                                        //  secStatus=!secStatus;
                if (isShuffled.value == true) {
                  //   double timer=currentPosition >= totalDuration ? 0:totalDuration.inSeconds.toDouble();
                  //  print("After SONGGGGGGGGG");
                  //   if(currentPosition>=totalDuration) {
              //    isShuffled.value=false;
                  try {
                    setState(() {
                      if (getPlayingStatus() ==
                          true) {
                        print(
                            "get PLaying Status IF TRUE ${getPlayingStatus()}");
                        playerControllers
                            .audioPlayer.stop();
                        playerControllers
                            .isPlaying = false;
                        putPlayingStatus(false);
                      }
                      songList.shuffle();
                              currentIndex = 0;
                    });
                  } on Exception catch (e){
                    print("Exception On Shuffle ${e.toString()}");
                  }

                  /*  playerControllers.playSong(songList[currentIndex].uri);
                              putPlayingStatus(true);*/
                }
                                          print("songList   ---   $songList");
                                          /*
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
                                          "currentIndex NEXT    $currentIndex");*/
                                        },
                                        icon: value
                                            ? const Icon(Icons.shuffle,
                                            size: 35, color: Colors.redAccent)
                                            : const Icon(
                                          Icons.shuffle,
                                          size: 35,
                                        )));
                              },
                            )
                          ],
                        )
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        ]),
      ),
    );
  }

  playWithDelay(String? uri, int currentIndex) {
    //PlayerControllers playerControllers2=PlayerControllers();
    return Future.delayed(const Duration(milliseconds: 100), () {
   //   playerControllers.playSong(uri);
    });
  }

  void checkIfFavorite(String display_name) {
    isFavorite(display_name);
  }
}
