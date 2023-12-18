
import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:music_player_project_one/modal_class/songList.dart';

import '../modal_class/playlistnames.dart';


ValueNotifier<List<String>> db_Notifier=ValueNotifier([]);
ValueNotifier<List<ModalClassAllSongs>> db_AllSongsNotifier=ValueNotifier([]);
ValueNotifier<List<ModalClassAllSongs>> playListNotifier=ValueNotifier([]);
ValueNotifier<List<ModalClassAllSongs>> favoritesNotifier=ValueNotifier([]);
ValueNotifier<List<PlayListName>> playListNamesNotifier=ValueNotifier([]);


 addAllSongs(ModalClassAllSongs modalClassAllSongs) async {
  final allsongDb= Hive.box<ModalClassAllSongs>("allSongs2");
  final songId=await allsongDb.add(modalClassAllSongs);
print("Before  ${modalClassAllSongs.songId}");
  final oneStudent=allsongDb.get(songId);
  if(oneStudent!=null){
    oneStudent.songId=songId;
    oneStudent.allSongsId=songId;
    allsongDb.put(songId, oneStudent);
  }
  print("After  $oneStudent");
  print("allsong_db.length  ${allsongDb.values.length}");
  putLength(allsongDb.values.length);
}

getAllSongs() async {
  final allsongDb= Hive.box<ModalClassAllSongs>("allSongs2");
  db_AllSongsNotifier.value.clear();
  db_AllSongsNotifier.value.addAll(allsongDb.values);
  db_AllSongsNotifier.notifyListeners();
  print(allsongDb.values);
}


putLength(int num){
  final allsongDb= Hive.box("SongLength");
  allsongDb.put("totalSongs", num);
}

getLength()async{
  final allsongDb= Hive.box("SongLength");
   final num=allsongDb.get("totalSongs");
  return num;
}


clearAllSongsBox(String boxName)async{
  final allsongDb= Hive.box<ModalClassAllSongs>("allSongs2");
  await allsongDb.deleteAll(allsongDb.keys);
}




 editNode(int? songId)   {
   Hive.box("allSongs2");

}

 deleteNode(int? songId)  {
  final allsongDb=Hive.box<ModalClassAllSongs>("allSongs2");
  allsongDb.delete(songId);
  putLength(allsongDb.length);
  getAllSongs();
}



putPlayingStatus(bool stat){
  final opClDb= Hive.box("playing");
    opClDb.put("status",stat);
}

getPlayingStatus(){
  final opClDb= Hive.box("playing");
  return  opClDb.get("status");
}

putPlayingAudioInstance(var instance){
  final opClDb= Hive.box("playing");
  opClDb.put("inst",instance);
}

getPlayingAudioInstance(){
  final opClDb= Hive.box("playing");
  return opClDb.get("inst");
}
