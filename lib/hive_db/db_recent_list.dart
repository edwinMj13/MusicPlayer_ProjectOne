import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

import '../modal_class/songList.dart';

 ValueNotifier<List<ModalClassAllSongs>> recentNotifier=ValueNotifier([]);

addRecentData(ModalClassAllSongs modal) async {
  final db_recent= Hive.box<ModalClassAllSongs>("recent");
  final db_id=await db_recent.add(modal);
  final student=db_recent.get(db_id);
  if(student!=null){
    modal.songId=db_id;
    db_recent.put(db_id, student);
  }
  recentNotifier.value.clear();
  recentNotifier.notifyListeners();
}

getRecentData(){
  final db_recent=Hive.box<ModalClassAllSongs>("recent");
  recentNotifier.value.clear();
  recentNotifier.value.addAll(db_recent.values);
  recentNotifier.notifyListeners();
}

getNameCheck(){
  List<String> names=[];
  final db_recent=Hive.box<ModalClassAllSongs>("recent");
  names.addAll(db_recent.values.map((e) => e.display_name).toList());
  print("Names Recent $names");
  return names;
}

removeLastSong(){
  final db_recent=Hive.box<ModalClassAllSongs>("recent");
  db_recent.deleteAt(0);
  getRecentData();
}
