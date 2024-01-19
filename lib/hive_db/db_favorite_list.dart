
import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/adapters.dart';

import '../modal_class/songList.dart';
import 'db_functions.dart';

ValueNotifier<bool> isFavNotifier=ValueNotifier(false);
ValueNotifier<List<ModalClassAllSongs>> favoritesNotifier=ValueNotifier([]);


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

getFavoritesListTodelete(){
  List<ModalClassAllSongs> mod=[];
  final favoriteListDb=Hive.box<ModalClassAllSongs>("favorites");
  mod.addAll(favoriteListDb.values);
  return mod;
}


getFavoritesList(){
  final favoriteListDb=Hive.box<ModalClassAllSongs>("favorites");
  favoritesNotifier.value.clear();
  favoritesNotifier.value.addAll(favoriteListDb.values);
  print("favorites DbFunction List${favoriteListDb.values}");
  favoritesNotifier.notifyListeners();
}

removeFromFavorites(int index, int? allSongsId){
  print("removeFromFavorites \n"
      "songId $index\n"
      "allSongId $allSongsId");
  final favoriteListDb=Hive.box<ModalClassAllSongs>("favorites");
favoriteListDb.deleteAt(index);
  isFavNotifier.notifyListeners();
getFavoritesList();
}

isFavorite(String display_name){
  List<String> nameList=[];
  final favoriteListDb=Hive.box<ModalClassAllSongs>("favorites");
  nameList.clear();
  favoriteListDb.values.forEach((element) {
    nameList.add(element.display_name);
  });
  if(nameList.contains(display_name)){
    isFavNotifier.value=true;
  }else{
    isFavNotifier.value=false;
  }
  isFavNotifier.notifyListeners();
 // favoritesNotifier.value.addAll(favoriteListDb.values);

//  print("favorites DbFunction List${favoriteListDb.values}");
}
