
import 'package:hive_flutter/adapters.dart';

import '../modal_class/songList.dart';
import 'db_functions.dart';

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
}

removeFromPlaylist(int id, int? allSongsId, ModalClassAllSongs modalC) async {
  final playListDb=Hive.box<ModalClassAllSongs>("playlist");
  playListDb.delete(id);
  print("playListDb.delete(id) ${allSongsId}");

  final allsongDb=Hive.box<ModalClassAllSongs>("allSongs2");
  final updateAllsong=allsongDb.get(allSongsId!);
  if(updateAllsong!=null) {
    allsongDb.put(allSongsId,modalC);
  }
  getPlayList();
}

getPlayList() async {
  final playListDb=Hive.box<ModalClassAllSongs>("playlist");
  playListNotifier.value.clear();
  playListNotifier.value.addAll(playListDb.values);
  print("playList Songs ${playListDb.values}");
  playListNotifier.notifyListeners();
}
