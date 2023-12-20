
import 'package:hive_flutter/adapters.dart';

import '../modal_class/songList.dart';
import 'db_functions.dart';

addToFavorites(ModalClassAllSongs modal, int songId)  async {
  final favoritesDb=  Hive.box<ModalClassAllSongs>("favorites");
  final dbId=await favoritesDb.add(modal);

  final oneEntry=favoritesDb.get(dbId);
  print("OneEntry $oneEntry");
  if(oneEntry!=null){
    modal.songId=dbId;
    favoritesDb.put(dbId, oneEntry);
  }
  final allsongDb=Hive.box<ModalClassAllSongs>("allSongs2");
  final updateAllsong=allsongDb.get(songId);
  print("addToFavorites SongID $songId");
  if(updateAllsong!=null){
    modal.songId=songId;
    allsongDb.put(songId, modal);
  }
}

getFavoritesList(){
  final favoriteListDb=Hive.box<ModalClassAllSongs>("favorites");
  favoritesNotifier.value.clear();
  favoritesNotifier.value.addAll(favoriteListDb.values);
  print("favorites DbFunction List${favoriteListDb.values}");
  favoritesNotifier.notifyListeners();
}

removeFromFavorites(int index, int? allSongsId, ModalClassAllSongs modalC){
  print("removeFromFavorites \n"
      "songId $index\n"
      "allSongId $allSongsId");
  final favoriteListDb=Hive.box<ModalClassAllSongs>("favorites");
favoriteListDb.deleteAt(index);
getFavoritesList();
}
