import 'package:hive_flutter/adapters.dart';

import '../modal_class/songList.dart';
import 'db_functions.dart';

saveAlbum(List<String> uniquelist) async {
  final albumDb = Hive.box<List<String>>("albumNames");
  albumDb.put("idAlbum", uniquelist);
}


getALbums() async {
  final albumDb= Hive.box<List<String>>("albumNames");
  db_Notifier.value.clear();
  if(albumDb.get("idAlbum") != null) {
    List<String> alb = albumDb.get("idAlbum")!;
    db_Notifier.value.addAll(alb);
  }
  db_Notifier.notifyListeners();
  print(db_Notifier.value);
}