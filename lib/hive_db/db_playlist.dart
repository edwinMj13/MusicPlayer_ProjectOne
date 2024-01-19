
import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/adapters.dart';

import '../modal_class/songList.dart';
import 'db_functions.dart';

ValueNotifier<bool> isAddedToPlayListNotifier=ValueNotifier(false);

addToPlaylist(ModalClassAllSongs modal, int songId) async {
  final playlistDb=  Hive.box<ModalClassAllSongs>("playlist");
  final dbId=await playlistDb.add(modal);

  final oneEntry=playlistDb.get(dbId);
  print("OneEntry $oneEntry");
  if(oneEntry!=null){
    modal.songId=dbId;
    playlistDb.put(dbId, oneEntry);
  }
  final allsongDb=Hive.box<ModalClassAllSongs>("allSongs2");
  final updateAllsong=allsongDb.get(songId);
  print("addToPlaylist SongID $songId");
  if(updateAllsong!=null){
    modal.songId=songId;
    allsongDb.put(songId, modal);
  }
  print("SONGID ADDTO PLAYLIST$songId");
}

removeFromPlaylist(int id) async {
  final playListDb=Hive.box<ModalClassAllSongs>("playlist");
  playListDb.deleteAt(id);
  getPlayList();
}

getReturnPlaylist(){
  final playListDb=Hive.box<ModalClassAllSongs>("playlist");
  List<ModalClassAllSongs> allSongssss=[];
  allSongssss.addAll(playListDb.values);
  return allSongssss;
}

getPlayList()  async {
  final playListDb=Hive.box<ModalClassAllSongs>("playlist");
  //await playListDb.deleteAll(playListDb.keys);
  playListNotifier.value.clear();
  playListNotifier.value.addAll(playListDb.values);
  print("playList Songs ${playListDb.values}");
  playListNotifier.notifyListeners();
}

delAllWhenDelAPlaylist(List<int> indexes) {
  final playListDb = Hive.box<ModalClassAllSongs>("playlist");
  for (int i = 0; i < indexes.length; i++) {
    playListDb.deleteAt(indexes[i]);
  }
}

  isInThePlaylist(String display_name){
    List<String> nameList=[];
    final playListDb=Hive.box<ModalClassAllSongs>("playlist");
    nameList.clear();
    playListDb.values.forEach((element) {
      nameList.add(element.display_name);
    });
    if(nameList.contains(display_name)){
      isAddedToPlayListNotifier.value=true;
    }else{
      isAddedToPlayListNotifier.value=false;
    }
    isAddedToPlayListNotifier.notifyListeners();
}
