
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player_project_one/hive_db/db_functions.dart';
import 'package:on_audio_query/on_audio_query.dart';

class PlayerControllers{


final audioQuery=OnAudioQuery();
final audioPlayer=AudioPlayer();
var isPlaying=false;
int playIndex=0;
var totalDura=0.0;
var position='';
var currentPosition=0.0;



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


playSong(String? uri,index){
  playIndex=index;
  print("IsPlaying OUTSIDE   ${getPlayingStatus()}");
  if(getPlayingStatus()!=true) {
    try {
      audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(uri!)));
      audioPlayer.play();
      isPlaying = true;
      putPlayingStatus(true);
    } on Exception catch (e) {
      print(e);
    }
  }
}

pauseSong(){
  if(getPlayingStatus()!=false) {
    try {
      audioPlayer.pause();
      putPlayingStatus(false);
    } on Exception catch (e) {
      print(e.toString());
    }
  }
}
void scaffoldMessage(BuildContext context,String msg){
  ScaffoldMessenger.of(context).showSnackBar(
       SnackBar(content: Text(msg),duration: const Duration(seconds: 2),));
}
}