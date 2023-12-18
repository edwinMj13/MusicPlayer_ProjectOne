import 'package:hive_flutter/adapters.dart';

import '../modal_class/playlistnames.dart';
import 'db_functions.dart';

addPLaylistNAmes(PlayListName val) async {
  final nameDb= Hive.box<PlayListName>("playlistNames");
  final id=await nameDb.add(val);

  final name=nameDb.get(id);
  // print(name);
  if(name!=null){
    nameDb.put(id, name);
  }
}

getPlayNAMES(){
  final nameDb= Hive.box<PlayListName>("playlistNames");
  playListNamesNotifier.value.clear();
  playListNamesNotifier.value.addAll(nameDb.values);
  print("getPlayNAMES ${nameDb.values}");
  playListNamesNotifier.notifyListeners();
}