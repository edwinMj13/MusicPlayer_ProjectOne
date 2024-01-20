import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:music_player_project_one/contentWidget/show_dialog_playlist.dart';
import 'package:music_player_project_one/hive_db/db_recent_list.dart';
import 'package:music_player_project_one/utils/controllers.dart';

import '../hive_db/db_favorite_list.dart';
import '../hive_db/db_functions.dart';
import '../modal_class/songList.dart';
import '../utils/colors.dart';
import 'edit_dialog_widget.dart';

class Popup_Song_Options extends StatelessWidget {
  List<ModalClassAllSongs> value;
  int index;
  final VoidCallback setCallback;
  final String fromPage;
   Popup_Song_Options({super.key,required this.value,required this.index,required this.setCallback,required this.fromPage});

  List<String> checkPlaylistString = [];
  List<String> checkFavoriteString = [];
  PlayerControllers playerControllers=PlayerControllers();


  editOrNull(String display_name){
    if(fromPage=="allsongs"){
      return [
        PopupMenuItem(
            value: 1,
            child: !checkPlaylistString.contains(display_name)
                ? const Text("Add to playlist")
                : const Text(
              "Added to playlist",
              style: TextStyle(color: Colors.green),
            )),
        PopupMenuItem(
            value: 2,
            child: !checkFavoriteString.contains(display_name)
                ? const Text("Add to favorites")
                : const Text("Added to favorites",
                style: TextStyle(color: Colors.green))),
        const PopupMenuItem(value: 3, child: Text("Edit")),
        const PopupMenuItem(value: 4, child: Text("Delete")),
      ];
    }else{
      return [
        PopupMenuItem(
            value: 1,
            child: !checkPlaylistString.contains(display_name)
                ? const Text("Add to playlist")
                : const Text(
              "Added to playlist",
              style: TextStyle(color: Colors.green),
            )),
        PopupMenuItem(
            value: 2,
            child: !checkFavoriteString.contains(display_name)
                ? const Text("Add to favorites")
                : const Text("Added to favorites",
                style: TextStyle(color: Colors.green))),
        const PopupMenuItem(value: 4, child: Text("Delete")),
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    checkPlaylistString = toCheckinPlayList();
    checkFavoriteString = toCheckinFavorites();
    ModalClassAllSongs modalC = ModalClassAllSongs(
        uri: value[index].uri,
        songId: value[index].songId,
        allSongsId: value[index].allSongsId,
        artist: value[index].artist,
        title: value[index].title,
        display_name: value[index].display_name,
        album: value[index].album,
        id: value[index].id);
    return PopupMenuButton<int>(
      icon: const Icon(Icons.more_vert,color: Colors.white,),
      itemBuilder: (ctx) {
       return editOrNull(modalC.display_name);
      },
      onSelected: (val) {
        switch (val) {
          case 1:
            if (!checkPlaylistString.contains(modalC.display_name)) {
              showDialog(
                  context: context,
                  builder: (context) => ShowDialogAdd(
                      playListNameModal: modalC, songId: value[index].songId!,setCallback: setCallback));
            } else {
              playerControllers.scaffoldMessage(
                  context, "Already Added To Playlist");
            }
            break;
          case 2:
            ModalClassAllSongs modalC = ModalClassAllSongs(
                uri: value[index].uri,
                playListName: value[index].playListName,
                playListStatus: value[index].playListStatus,
                favoritesListStatus: "yes",
                songId: value[index].songId,
                allSongsId: value[index].allSongsId,
                artist: value[index].artist,
                title: value[index].title,
                display_name: value[index].display_name,
                album: value[index].album,
                id: value[index].id);
            if(!checkFavoriteString.contains(modalC.display_name)) {
              addToFavorites(modalC, value[index].songId!);
            }else{
              playerControllers.scaffoldMessage(
                  context, "Already Added To Favorites");
            }
            setCallback();
            break;
          case 3:
            ModalClassAllSongs modalEdit = ModalClassAllSongs(
                uri: value[index].uri,
                playListName: value[index].playListName,
                playListStatus: value[index].playListStatus,
                songId: value[index].songId,
                allSongsId: value[index].allSongsId,
                artist: value[index].artist,
                title: value[index].title,
                display_name: value[index].display_name,
                album: value[index].album,
                id: value[index].id);
            showDialog(context: context, builder: (ctx){
              return ShowEditDialog(modal:modalEdit,indexSong: index);
            });
            break;
          case 4:
            print("value[index].songId  ${value[index].songId}");
            fromPage=="allsongs" 
                ?deleteNode(value[index].songId)
            :deleteSong(value[index].songId);
            break;
        }
      },
    );
  }

 /* popupForAllSongs(List<ModalClassAllSongs> value, int index) {
    checkPlaylistString = toCheckinPlayList();
    checkFavoriteString = toCheckinFavorites();
    ModalClassAllSongs modalC = ModalClassAllSongs(
        uri: value[index].uri,
        songId: value[index].songId,
        allSongsId: value[index].allSongsId,
        artist: value[index].artist,
        title: value[index].title,
        display_name: value[index].display_name,
        album: value[index].album,
        id: value[index].id);
    //  print("modalC.display_name ${modalC.display_name}");
    return
      PopupMenuButton<int>(
      itemBuilder: (ctx) {
        return [
          PopupMenuItem(
              value: 1,
              child: !checkPlaylistString.contains(modalC.display_name)
                  ? const Text("Add to playlist")
                  : const Text(
                "Added to playlist",
                style: TextStyle(color: Colors.green),
              )),
          PopupMenuItem(
              value: 2,
              child: !checkFavoriteString.contains(modalC.display_name)
                  ? const Text("Add to favorites")
                  : const Text("Added to favorites",
                  style: TextStyle(color: Colors.green))),
          const PopupMenuItem(value: 3, child: Text("Edit")),
          const PopupMenuItem(value: 4, child: Text("Delete")),
        ];
      },
      onSelected: (val) {
        switch (val) {
          case 1:
            if (!checkPlaylistString.contains(modalC.display_name)) {
              showDialog(
                  context: context,
                  builder: (context) => ShowDialogAdd(
                      playListNameModal: modalC, songId: value[index].songId!));
            } else {
              playerControllers.scaffoldMessage(
                  context, "Already Added To Playlist");
            }
            break;
          case 2:
            ModalClassAllSongs modalC = ModalClassAllSongs(
                uri: value[index].uri,
                playListName: value[index].playListName,
                playListStatus: value[index].playListStatus,
                favoritesListStatus: "yes",
                songId: value[index].songId,
                allSongsId: value[index].allSongsId,
                artist: value[index].artist,
                title: value[index].title,
                display_name: value[index].display_name,
                album: value[index].album,
                id: value[index].id);
            addToFavorites(modalC, value[index].songId!);
            setState(() {});
            break;
          case 3:
            ModalClassAllSongs modalEdit = ModalClassAllSongs(
                uri: value[index].uri,
                playListName: value[index].playListName,
                playListStatus: value[index].playListStatus,
                songId: value[index].songId,
                allSongsId: value[index].allSongsId,
                artist: value[index].artist,
                title: value[index].title,
                display_name: value[index].display_name,
                album: value[index].album,
                id: value[index].id);
            showDialog(context: context, builder: (ctx){
              return ShowEditDialog(modal:modalEdit,indexSong: index);
            });
            break;
          case 4:
            deleteNode(value[index].songId);
            break;
        }
      },
    );
  }*/


  toCheckinPlayList() {
    List<ModalClassAllSongs> checkInPlayList = [];

    final playListDb = Hive.box<ModalClassAllSongs>("playlist");
    checkInPlayList.clear();
    for (var elem in playListDb.values) {
      checkInPlayList.add(elem);
    }
    return checkInPlayList.map((e) => e.display_name).toList();
  }

  toCheckinFavorites() {
    List<ModalClassAllSongs> checkInfavorites = [];

    final playListDb = Hive.box<ModalClassAllSongs>("favorites");
    checkInfavorites.clear();
    for (var elem in playListDb.values) {
      checkInfavorites.add(elem);
    }
    return checkInfavorites.map((e) => e.display_name).toList();
  }

}
