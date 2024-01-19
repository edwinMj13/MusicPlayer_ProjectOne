


import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player_project_one/hive_db/db_functions.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../hive_db/db_recent_list.dart';
import '../modal_class/songList.dart';
class PlayerControllers{
final audioQuery=OnAudioQuery();
final audioPlayer=AudioPlayer();
var isPlaying=false;
int playIndex=0;
var totalDura=0.0;
var position='';
var currentPosition=0.0;
List<ModalClassAllSongs> songList=[];
late BuildContext contextOutside;
/*ConcatenatingAudioSource playlist=ConcatenatingAudioSource( // Start loading next item just before reaching it
    useLazyPreparation: true,
    // Customise the shuffle algorithm
    shuffleOrder: DefaultShuffleOrder( ),
    children: []);
*/

updatePosition(){

    audioPlayer.positionStream.listen((d) {

    //  duration = d.toString().split(".")[0];
      currentPosition=d.inSeconds.toDouble();
      print("positionStream    DDDD $currentPosition");
    });
    audioPlayer.durationStream.listen((p) {

     // position = p.toString().split(".")[0];
      totalDura=p!.inSeconds.toDouble();
      print(" durationStream     PPPP $totalDura");
    });
}

changeDurationToSeconds(seconds){
  var duration=Duration(seconds: seconds);
  audioPlayer.seek(duration);
}

stopSong(){
    try {
      print("Stop Song BEFORE STOP${audioPlayer.playing}");
      audioPlayer.stop();
      putPlayingStatus(false);
      print("Stop Song AFTER STOP${audioPlayer.playing}");
    } on Exception catch (e) {
      print("Stop Song Exception ${e.toString()}");
    }
}
/*
getPlaylistAutomatic() {
  for (var elem in songList) {
    playlist.children.add(AudioSource.uri(Uri.parse(elem.uri!)));
    // print("ELEMENT  ${elem.uri}");
  }
}
playSong(String? uri, List<ModalClassAllSongs> songList, int index) async {
getPlaylistAutomatic();
  print("IsPlaying OUTSIDE   ${getPlayingStatus()}");
  if(getPlayingStatus()!=true) {
    try {
      print("Play URI   $uri");
      await audioPlayer.setAudioSource(playlist[index]);
      audioPlayer.play();
      audioPlayer.shuffle();
      isPlaying = true;
      putPlayingStatus(true);
    } on Exception catch (e) {
      print(e);
    }
  }
}*/

playSong(String? uri, List<ModalClassAllSongs> songList, int index) async {

  print("IsPlaying OUTSIDE   ${getPlayingStatus()}");
  if(getPlayingStatus()!=true) {
    try {
      print("Play URI   $uri");
     await audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(songList[index].uri!)));
      audioPlayer.play();
      isPlaying = true;
      putPlayingStatus(true);
    } on Exception catch (e) {
      print(e);
    }
  }
}

playSongconCat(String? uri, ConcatenatingAudioSource? playlist, int index,Map<String,dynamic> audiosMap,BuildContext context) async {
 // playlist.children.toSet();
  contextOutside=context;
  print(" Concateneting playlist -- ${playlist!.children}");

  print("IsPlaying OUTSIDE   ${getPlayingStatus()}");
  if(getPlayingStatus()==false) {
    try {
      print("Play URI   $uri");
      await audioPlayer.setAudioSource(playlist.children[index]);
       audioPlayer.play();
      isPlaying = true;
      putPlayingStatus(true);
      addToRecentList( playlist,  index,audiosMap);
    }  catch (excep) {
      print("Error on Try Catch Concatenation WHile Playing${excep.toString()}");
      callScaffoldMessenger();
      putPlayingStatus(false);
    }
  }
}
pauseSong(){
  if(getPlayingStatus()==true) {
    try {
      audioPlayer.stop();
      putPlayingStatus(false);
    } on Exception catch (e) {
      print(e.toString());
    }
  }
}
void scaffoldMessage(BuildContext context,String msg,{Color? color}){
  ScaffoldMessenger.of(context).showSnackBar(
       SnackBar(content: Text(msg),duration: const Duration(seconds: 2),backgroundColor: color,));
}
  void scaffoldMessageForFav(BuildContext context,String msg,{Color? color}){
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Center(child: Text(msg)),duration: const Duration(seconds: 2),backgroundColor: color,behavior: SnackBarBehavior.floating,width: 100,));
  }

  void addToRecentList(ConcatenatingAudioSource playlist, int index, Map<String, dynamic> audiosMap) {
    List<String> songNameTitles = [];
    ModalClassAllSongs modalAllSongs = ModalClassAllSongs(
      songId: audiosMap["songId"],
        uri: audiosMap["uri"],
        artist: audiosMap["artist"],
        title: audiosMap["title"],
        display_name: audiosMap["display_name"],
        album: audiosMap["album"],
        id: audiosMap["id"]);
    songNameTitles = getNameCheck();
    if (!songNameTitles.contains(modalAllSongs.display_name)) {
      addRecentData(modalAllSongs);
      if (songNameTitles.length == 10) {
        removeLastSong();
      }
    }else{
      int ind=songNameTitles.indexOf(modalAllSongs.display_name);
      removeContainedSong(ind);
      addRecentData(modalAllSongs);
    }
  }

  void callScaffoldMessenger() {
    scaffoldMessage(contextOutside, "File has been corrupted");
  }
}