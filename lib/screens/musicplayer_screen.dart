import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:just_audio/just_audio.dart';
import 'package:marquee/marquee.dart';
import 'package:music_player_project_one/hive_db/db_favorite_list.dart';
import 'package:music_player_project_one/hive_db/db_playlist.dart';
import 'package:music_player_project_one/utils/controllers.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'dart:core';

//import 'package:audioplayers/audioplayers.dart';
import '../contentWidget/player_screen_add_playlist.dart';
import '../hive_db/db_functions.dart';
import '../hive_db/db_playlist.dart';
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
      this.artistName,
      required this.setStateMethod()});

  @override
  State<BottomSheetPlayer> createState() => _BottomSheetPlayerState();
}

class _BottomSheetPlayerState extends State<BottomSheetPlayer> {
  String? uri = "",currentUri,currentAlbumName;
  int index = 0;
  List<ModalClassAllSongs> songList = [];
  int intImage = 0;
  bool nxtPrePlayerStatus = false;
  String? songTitle, display_Name;
  String? artistName;
  PlayerControllers playerControllers = PlayerControllers();

  ValueNotifier<bool> isShuffled = ValueNotifier(false);
  ValueNotifier<int> musicImage = ValueNotifier(0);
  int? songId = 0;
  late ConcatenatingAudioSource playlist;
  dynamic currentIndex;
  dynamic setStateMethod;
  dynamic setScaffoldRebuilds;
  dynamic setStateForImages;
  Map<String, dynamic> audiosMap = {};
  int playListIndex=0;

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
    songList = widget.songList;
  }

  getPlaylistAutomatic() {
    print("SONGLIST MUSIC PLAYER $songList");
    for (var elem in songList) {
      playlist.children.add(AudioSource.uri(Uri.parse(elem.uri!), tag: {
        "songId": elem.songId,
        "uri": elem.uri,
        "artist": elem.artist,
        "title": elem.title,
        "display_name": elem.display_name,
        "album": elem.album,
        "id": elem.id
      }));
    }
  }

  @override
  Widget build(BuildContext context) {
    playlist = ConcatenatingAudioSource(
        // Start loading next item just before reaching it
        useLazyPreparation: true,
        // Customise the shuffle algorithm
        shuffleOrder: DefaultShuffleOrder(),
        children: [] /*songList.map((filePath) {
          File audioFile = File(filePath.uri!);
          return AudioSource.uri(Uri.file(audioFile.path));
        }).toList()[    AudioSource.uri(Uri.parse("content://media/external/audio/media/1000074539")),
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
    AudioSource.uri(Uri.parse("content://media/external/audio/media/1000334292"))]*/
        );

    //  secStatus=false;
    uri = widget.uri;
    index = widget.index;
    currentIndex = index;
    setStateMethod = widget.setStateMethod;
    getPlaylistAutomatic();

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
    print("ELEMENT  ${playlist.children}");

    if (nxtPrePlayerStatus == false) {
      if (getPlayingStatus() != true) {
        print("Rebuilt currentIndex $currentIndex");
        // playerControllers.playSong(songList[currentIndex].uri,songList,index);
        dynamic e = playlist.children[currentIndex];
        if (e is UriAudioSource) {
          audiosMap = e.tag;
        }

        playerControllers.playSongconCat(
            uri, playlist, currentIndex, audiosMap,context);
        print("MusicPLayer URI $uri");
        putPlayingStatus(true);
      }
    }
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop();
        setStateMethod();
        return false;
      },
      child: StatefulBuilder(
        builder: (BuildContext context,
            void Function(void Function()) setScaffoldRebuild) {
          setScaffoldRebuilds = setScaffoldRebuild;
          return Scaffold(
            backgroundColor: Colors.blueGrey,
            body: fullPlayer(heightSheet, context),
          );
        },
      ),
    );
  }

  fullPlayer(double heightSheet, BuildContext context) {
    double controllerIconHeight=50,
        controllerIconWidth=50,iconSize=25;
    checkIfFavorite(songList[currentIndex].display_name);

    dynamic e = playlist.children[currentIndex];
    if (e is UriAudioSource) {
      audiosMap = e.tag;
    }
    intImage = audiosMap["id"];
    songTitle = audiosMap["title"];
    artistName = audiosMap["artist"];
    songId = audiosMap["songId"];
    display_Name = audiosMap["display_name"];
    currentUri=audiosMap["uri"];
    currentAlbumName=audiosMap["album"];

    List<ModalClassAllSongs> chkList=getReturnPlaylist();
    List<String> playNames=[];
    chkList.forEach((element) {playNames.add(element.display_name);});

    print("--------URIIIIIIIRIRIRIRI------       ${audiosMap}");
    return SafeArea(
      child: Container(
        constraints:
            BoxConstraints(minHeight: heightSheet, maxHeight: heightSheet),
        decoration: const BoxDecoration(color: Colors.blueGrey),
        child: Column(children: [
          const SizedBox(
            height: 30,
          ),
          ValueListenableBuilder(
            valueListenable: musicImage,
            builder: (BuildContext context, value, child) {
              return Container(
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
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0, right: 10.0,left: 10.0),
            child: StreamBuilder<Duration>(
              stream: playerControllers.audioPlayer.positionStream,
              builder:
                  (BuildContext context, AsyncSnapshot<Duration> snapshot) {
                var currentPosition = snapshot.data ?? Duration.zero;
                var totalDuration =
                    playerControllers.audioPlayer.duration ?? Duration.zero;

                //  print("   -------------      StreamBuilder is Running       ----------- ${playerControllers.audioPlayer.playerState.processingState.name}");
                String playerProcessingState = playerControllers
                    .audioPlayer.playerState.processingState.name;
                if (playerControllers.audioPlayer.playing == true &&
                    currentPosition >= totalDuration) {
                  putPlayingStatus(false);
                  /*if (currentIndex != songList.length - 1) {
                    if (playerProcessingState== "completed") {
                      currentIndex++;
                      musicImage.value=audiosMap["id"];
                      playerControllers.playSongconCat(
                          uri, playlist, currentIndex, audiosMap);
                    }
                  }else{
                    currentIndex=0;
                  }*/
                }

                checkIfFavorite(display_Name!);
                isInThePlaylist(display_Name!);
                return Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                      child: SizedBox(
                        height: 40,
                        child: songTitle!.length > 30
                            ? Marquee(
                                text: songTitle!,
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 15),
                                crossAxisAlignment: CrossAxisAlignment.start,
                                scrollAxis: Axis.horizontal,
                                blankSpace: 100,
                                fadingEdgeStartFraction: 0.1,
                                fadingEdgeEndFraction: 0.1,
                              )
                            : Text(
                                songTitle!,
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 15),
                              ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      height: 30,
                      child: Text(
                        artistName!,
                        style: const TextStyle(color: Colors.white),
                      ),
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
                            value: currentPosition.inSeconds.toDouble(),
                            onChanged: (value) {
                              final position = Duration(seconds: value.toInt());
                              playerControllers.audioPlayer.seek(position);
                              putPlayingStatus(true);
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
                                height: controllerIconHeight,
                                width: controllerIconWidth,
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(100.0),
                                ),
                                child: InkWell(
                                  onTap:(){
                                    if (currentIndex != 0) {
                                      currentIndex--;
                                      playerControllers.stopSong();
                                      putPlayingStatus(false);
                                      // playerControllers.playSong(uri, songList, currentIndex);
                                      playerControllers.playSongconCat(uri,
                                          playlist, currentIndex, audiosMap,context);
                                      nxtPrePlayerStatus == true;
                                      setScaffoldRebuilds(() {});
                                    } else {
                                      playerControllers.scaffoldMessage(
                                          context, "Last Song");
                                    }
                                  },
                                  child:  Icon(
                                        Icons.skip_previous,
                                        size: iconSize,
                                      )),
                                ),
                            const SizedBox(
                              width: 60,
                            ),
                            Container(
                                height: controllerIconHeight,
                                width: controllerIconWidth,
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(100.0),
                                ),
                                child: IconButton(
                                    onPressed: () {
                                      print(
                                          "getPlayingStatus() Before   ${getPlayingStatus()}");
                                      if (getPlayingStatus() == false) {
                                        //     playerControllers.playSong(uri,songList,currentIndex);
                                        playerControllers.playSongconCat(uri,
                                            playlist, currentIndex, audiosMap,context);
                                      } else {
                                        playerControllers.pauseSong();
                                      }

                                      print(
                                          "getPlayingStatus() after   ${getPlayingStatus()}");

                                      print(
                                          "ICON STATUS  ${getPlayingStatus() && currentPosition < totalDuration}\n"
                                          "currentPosition < totalDuration   ${currentPosition < totalDuration}\n"
                                          "currentPosition - $currentPosition    ------   totalDuration - $totalDuration");
                                    },
                                    icon: Icon(
                                      getPlayingStatus() &&
                                              currentPosition < totalDuration
                                          ? Icons.pause
                                          : Icons.play_arrow,
                                      size: iconSize,
                                    ))),
                            const SizedBox(
                              width: 60,
                            ),
                            Container(
                                height: controllerIconHeight,
                                width: controllerIconWidth,
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(100.0),
                                ),
                                child: InkWell(
                                  onTap:(){
                                    if (currentIndex != songList.length - 1) {
                                      currentIndex++;
                                      playerControllers.stopSong();
                                      putPlayingStatus(false);
                                      // playerControllers.playSong(uri, songList, currentIndex);
                                      playerControllers.playSongconCat(uri,
                                          playlist, currentIndex, audiosMap,context);
                                      nxtPrePlayerStatus == true;
                                      setScaffoldRebuilds(() {});
                                      print(
                                          "clicked song Index for next   $index\n"
                                              "clicked song LENGTH for next   ${songList.length - 1}\n");
                                    } else {
                                      playerControllers.scaffoldMessage(
                                          context, "Last Song");
                                    }
                                  },
                                  child: Icon(
                                        Icons.skip_next,
                                        size: iconSize,
                                      )),
                                ),
                          ],
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        Row(
                          mainAxisAlignment : MainAxisAlignment.center,
                          children: [
                            const Expanded(
                              flex:1,
                                child: Text("")),
                            Expanded(
                              flex:4,
                              child: Container(
                                decoration:BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: Colors.white,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 5.0,bottom: 5.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ValueListenableBuilder(
                                        valueListenable: isFavNotifier,
                                        builder:
                                            (BuildContext context, value, Widget? child) {
                                          return IconButton(
                                              onPressed: () {
                                                if (isFavNotifier.value == false) {
                                                  print("To Add");
                                                  addTOfavorites(audiosMap, currentIndex);
                                                } else {
                                                  print("To Remove");
                                                  List<ModalClassAllSongs> temp =
                                                      getFavoritesListTodelete();
                                                  List<String> tempList = temp
                                                      .map((e) => e.display_name)
                                                      .toList();
                                                  if (tempList
                                                      .contains(display_Name)) {
                                                    int ind = tempList
                                                        .indexOf(display_Name!);
                                                    removeFromFavorites(ind, songId);
                                                    playerControllers.scaffoldMessageForFav(context, "Removed",color: Colors.red);
                                                  }
                                                }
                                              },
                                              icon: !value
                                                  ?  Icon(
                                                      Icons.favorite_border,
                                                      size: iconSize,
                                                    )
                                                  :  Icon(
                                                      Icons.favorite,
                                                      color: Colors.redAccent,
                                                      size: iconSize,
                                                    ));
                                        },
                                      ),
                                      const SizedBox(width: 30),
                                      ValueListenableBuilder(
                                        valueListenable: isShuffled,
                                        builder:
                                            (BuildContext context, value, Widget? child) {
                                          return IconButton(
                                              onPressed: () {
                                                print("Value Shuffle $value");
                                                isShuffled.value = !isShuffled.value;
                                                //  secStatus=!secStatus;
                                                if (isShuffled.value == true) {
                                                  playlist.children.shuffle();
                                                  print("songList   ---   $songList");
                                                } else {
                                                  getPlaylistAutomatic();
                                                  print("songList   ---   $songList");
                                                }
                                              },
                                              icon: value
                                                  ?  Icon(Icons.shuffle,
                                                      size: iconSize,
                                                      color: Colors.redAccent)
                                                  :  Icon(
                                                      Icons.shuffle,
                                                      size: iconSize,
                                                    ));
                                        },
                                      ),
                                      const SizedBox(width: 30),
                                      ValueListenableBuilder(
                                        valueListenable: isAddedToPlayListNotifier,
                                        builder:
                                            (BuildContext context, value, Widget? child) {
                                          return IconButton(
                                              onPressed: () {
                                                print("Value Shuffle $value");
                                                if(playNames.contains(display_Name)){
                                                  playListIndex=playNames.indexOf(display_Name!);
                                                }
                                                print("SONG ID $songId");

                                                ModalClassAllSongs modalc = ModalClassAllSongs(
                                                    uri:currentUri,
                                                    artist: artistName,
                                                    title: songTitle,
                                                    display_name: display_Name!,
                                                    album: currentAlbumName,
                                                    id: songId!);
                                                //  secStatus=!secStatus;
                                                if (isAddedToPlayListNotifier.value == false) {
                                                  showDialog(context: context, builder: (ctx){

                                                    return MusicPlayerScreen_AddPlaylist(playListNameModal:modalc,callbackChangeValue: callbackChangeValue,songId:songId!);
                                                  });
                                                  print("songList   ---   $songList");
                                                } else if(isAddedToPlayListNotifier.value==true) {
                                                  removeFromPlaylist(playListIndex);
                                                  playerControllers.scaffoldMessageForFav(context, "Removed",color: Colors.red);
                                                  callbackChangeValue();
                                                  print("songList   ---   $songList");
                                                }
                                              },
                                              icon: value
                                                  ?  Icon(Icons.playlist_add_check,
                                                  size: iconSize,
                                                  color: Colors.redAccent)
                                                  :  Icon(
                                                Icons.playlist_add,
                                                size: iconSize,
                                              ));
                                        },
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                                flex:1,
                                child: Text("")),
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

  callbackChangeValue(){
    isAddedToPlayListNotifier.value = !isAddedToPlayListNotifier.value;
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

  addTOfavorites(Map<String, dynamic> audioMap, int index) {
    List<String> checkFavoriteString = [];
    ModalClassAllSongs modalAllSongs = ModalClassAllSongs(
        songId: audioMap["songId"],
        uri: audioMap["uri"],
        artist: audioMap["artist"],
        title: audioMap["title"],
        display_name: audioMap["display_name"],
        album: audioMap["album"],
        id: audioMap["id"]);
    checkFavoriteString = toCheckinFavorites();
    if (!checkFavoriteString.contains(modalAllSongs.display_name)) {
      addToFavorites(modalAllSongs, modalAllSongs.songId!);
      playerControllers.scaffoldMessageForFav(context, "Added",color: Colors.red);
      isFavNotifier.notifyListeners();
    }
  }

  toCheckinFavorites() {
    List<ModalClassAllSongs> checkInfavorites = [];

    final playListDb = Hive.box<ModalClassAllSongs>("favorites");
    checkInfavorites.clear();
    for (var elem in playListDb.values) {
      checkInfavorites.add(elem);
    }
    return checkInfavorites.map((e) => e.display_name).toList();
  }
}
