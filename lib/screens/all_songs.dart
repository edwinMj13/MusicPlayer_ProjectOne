import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:music_player_project_one/contentWidget/show_dialog_playlist.dart';
import 'package:music_player_project_one/modal_class/songList.dart';
import 'package:on_audio_query/on_audio_query.dart';

import 'musicplayer_screen.dart';
import '../hive_db/db_favorite_list.dart';
import '../hive_db/db_playlist.dart';
import '../utils/controllers.dart';
import '../hive_db/db_functions.dart';

class AllSongsScreen extends StatefulWidget {
  final String fromPageName;
  final String title;
   const AllSongsScreen({super.key,required this.fromPageName,required this.title});

  @override
  State<AllSongsScreen> createState() => _AllSongsScreenState();
}

class _AllSongsScreenState extends State<AllSongsScreen> {
  late String fromPageName;
  late String title;
  late ValueListenableBuilder valueListenableBuilder;
  List<ModalClassAllSongs> selectedAlbumSongs = [];
  List<ModalClassAllSongs> selectedPlaylistSongs = [];
  late String albumName;
  List<String> checkPlaylistString=[];
  List<String> checkFavoriteString=[];
  PlayerControllers playerControllers = PlayerControllers();
  String toPlayerUri="";
  String toPlayerTitle="";
  String toPlayerArtistName="";
  int toPlayerIndex=0;
  int songImage=0;
  List<ModalClassAllSongs> toPlayerModal=[];
  bool isMusicLayoutVisible=false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fromPageName=widget.fromPageName;
    title=widget.title;
    valueListenableBuilder=whichNotifierBuilder();
    print(valueListenableBuilder);
  }

   whichNotifierBuilder(){
    if(fromPageName=="all") {
      return allSongSection();
    }else if(fromPageName=="album") {
      return albumSection();
    }else if(fromPageName=="playlist") {
    return playlistSection();
    }else if(fromPageName=="favorite") {
      return favoritesSection();
    }else if(fromPageName=="recent") {
      return recentSection();
    }
  }

  selectGETsection(){
    if(fromPageName=="all") {
      return getAllSongs();
    }else if(fromPageName=="album") {
      return getAllSongs();
    }else if(fromPageName=="playlist") {
      return getPlayList();
    }else if(fromPageName=="favorite") {
      return getFavoritesList();
    }else if(fromPageName=="recent") {
      return recentSection();
    }
  }

  @override
  Widget build(BuildContext context) {
    selectGETsection();
    // print("toPlayerUri $toPlayerUri\n"
    //     "toPlayerIndex $toPlayerIndex\n"
    //     "toPlayerModal $toPlayerModal\n"
    //     "songImage $songImage\n"
    //     "toPlayerTitle $toPlayerTitle\n");

    return Scaffold(
      appBar: AppBar(
        title:  Text(title),
      ),
      body:valueListenableBuilder,
    );
  }

  toCheckinPlayList(){
    List<ModalClassAllSongs> checkInPlayList=[];

    final playListDb=Hive.box<ModalClassAllSongs>("playlist");
    checkInPlayList.clear();
    for(var elem in playListDb.values) {
      checkInPlayList.add(elem);
    }
    return checkInPlayList.map((e) => e.display_name).toList();
  }


  toCheckinFavorites(){
    List<ModalClassAllSongs> checkInfavorites=[];

    final playListDb=Hive.box<ModalClassAllSongs>("favorites");
    checkInfavorites.clear();
    for(var elem in playListDb.values) {
      checkInfavorites.add(elem);
    }
    return checkInfavorites.map((e) => e.display_name).toList();
  }


  popupForAllSongs(List<ModalClassAllSongs> value, int index) {
    checkPlaylistString=toCheckinPlayList();
    checkFavoriteString=toCheckinFavorites();
    ModalClassAllSongs modalC= ModalClassAllSongs(uri: value[index].uri,
        songId: value[index].songId,
        allSongsId: value[index].allSongsId,
        artist: value[index].artist,
        title: value[index].title,
        display_name: value[index].display_name,
        album: value[index].album,
        id: value[index].id);
    print("modalC.display_name ${modalC.display_name}");
    return PopupMenuButton<int>(
      itemBuilder: (ctx) {
        return [
           PopupMenuItem(value: 1, child: !checkPlaylistString.contains(modalC.display_name)
              ? const Text("Add to playlist")
            :const Text("Added to playlist",style: TextStyle(color: Colors.green),)),
           PopupMenuItem(value: 2, child: !checkFavoriteString.contains(modalC.display_name)
               ? const Text("Add to favorites")
           :const Text("Added to favorites",style: TextStyle(color: Colors.green))),
          const PopupMenuItem(value: 3, child: Text("Edit")),
          const PopupMenuItem(value: 4, child: Text("Delete")),
        ];
      },
      onSelected: (val) {

        switch(val){
          case 1:

            if(!checkPlaylistString.contains(modalC.display_name)) {
              showDialog(context: context, builder: (context) =>
                  ShowDialogAdd(
                      playListNameModal: modalC, songId: value[index].songId!)
              );
            }else{
              playerControllers.scaffoldMessage(context, "Already Added To Playlist");
            }
            break;
          case 2:
            ModalClassAllSongs modalC= ModalClassAllSongs(uri: value[index].uri,
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
            addToFavorites(modalC,value[index].songId!);
            setState(() {

            });
            break;
          case 3:
            editNode(value[index].songId);
            break;
          case 4:
            deleteNode(value[index].songId);
            break;
        }
      },
    );
 }

  popupForPlaylist(List<ModalClassAllSongs> value, int index, int? allSongsId){
    print("allSongID  popupForPlaylist  $allSongsId");
    return PopupMenuButton<int>(
        itemBuilder: (ctx){
          return [
            const PopupMenuItem(
              value: 1,
                child: Text("Remove from playlist")),
          ];
        },
        onSelected: (val){
          if(val==1) {
            ModalClassAllSongs modalC = ModalClassAllSongs(
                uri: value[index].uri,
                songId: value[index].songId,
                allSongsId: value[index].allSongsId,
                playListName: "",
                playListStatus: 'no',
                artist: value[index].artist,
                title: value[index].title,
                display_name: value[index].display_name,
                album: value[index].album,
                id: value[index].id);
            removeFromPlaylist(value[index].songId!, allSongsId, modalC);
          }
        });
 }

  popupForFavorites(List<ModalClassAllSongs> value, int index) {}

  playlistSection() {
    return ValueListenableBuilder(
      valueListenable: playListNotifier,
      builder: ( context,  value, child) {
        if (value.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          print(" ELSE if PlayList$value");
          if(fromPageName=="playlist"){
            selectedPlaylistSongs.clear();
            for(var elem in value){
              if(title==elem.playListName) {
                selectedPlaylistSongs.add(elem);
              }
            }
          }
          return ListView.separated(
            itemBuilder: (context, index) {
               var snapshot = selectedPlaylistSongs[index];
              print("Name : ${snapshot.title} \n"
                  "SongsId :${snapshot.songId}\n"
                  "AllSongsId :${snapshot.allSongsId}\n"
                  "playListStatus :${snapshot.playListStatus}\n"
                  "playListName :${snapshot.playListName}\n");


              print("selectedPlaylistSongs    ${selectedPlaylistSongs}");
              return ListTile(
                leading: ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 50,maxWidth: 50,minHeight: 50,minWidth: 50),
                  child: QueryArtworkWidget(
                      id: selectedPlaylistSongs[index].id,
                      type: ArtworkType.AUDIO,
                      nullArtworkWidget: const Icon(
                        Icons.music_note,
                        color: Colors.black,
                      )),
                ),
                title: Text(selectedPlaylistSongs[index].display_name),
                subtitle: Text("${selectedPlaylistSongs[index].artist}"),
                trailing: popupForPlaylist(selectedPlaylistSongs,index,selectedPlaylistSongs[index].allSongsId),
                onTap: () {
                  playerScreen(selectedPlaylistSongs[index].uri!,
                      index,
                      selectedPlaylistSongs,
                      selectedPlaylistSongs[index].id,
                      selectedPlaylistSongs[index].display_name,
                      selectedPlaylistSongs[index].artist!);
                },
              );

            },
            itemCount: selectedPlaylistSongs.length,
            separatorBuilder: (context, index) {
              return const Divider();
            },
          );
        }
      },
    );
  }

  allSongSection() {
    return ValueListenableBuilder(
      valueListenable: db_AllSongsNotifier,
      builder: ( context,  value, child) {
        if (value.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          print(" ELSE if All Songs$value");
          return ListView.separated(
            itemBuilder: (context, index) {
               var snapshot = value[index];
              print("Name : ${snapshot.title} \n"
                  "SongsId :${snapshot.songId}\n"
                  "AllSongsId :${snapshot.allSongsId}\n"
                  "playListStatus :${snapshot.playListStatus}\n"
                  "playListName :${snapshot.playListName}\n");
              return ListTile(
                leading: ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 50,maxWidth: 50,minHeight: 50,minWidth: 50),
                  child: QueryArtworkWidget(
                      id: value[index].id,
                      type: ArtworkType.AUDIO,
                      nullArtworkWidget:  const Icon(
                        Icons.music_note,
                        color: Colors.black,
                      )),
                ),
                title: Text(value[index].display_name),
                subtitle: Text("${value[index].artist}"),
                trailing: popupForAllSongs(value,index),
                onTap: () {
                  playerScreen(value[index].uri!,
                      index,
                      value,
                      value[index].id,
                      value[index].display_name,
                      value[index].artist!);
                },
              );

            },
            itemCount: value.length,
            separatorBuilder: (context, index) {
              return const Divider();
            },
          );
        }
      },
    );
  }

  albumSection(){
      return
          ValueListenableBuilder(
          valueListenable: db_AllSongsNotifier,
          builder: (BuildContext context, List<ModalClassAllSongs> value,Widget? child) {
            if (value.isEmpty) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
                print(" ELSE if Album ${value.length}");

              if(fromPageName=='album') {
                selectedAlbumSongs.clear();
                for (var value1 in value) {
                  if ( title== value1.album) {
                    selectedAlbumSongs.add(value1);
                  }
                }
              }
              print("selecetedAlbumSongs $selectedAlbumSongs");
              return ListView.separated(
                itemBuilder: (context, index) {
                  // var snapshot = value[index];

                  return ListTile(
                    leading: ConstrainedBox(
                      constraints: const BoxConstraints(maxHeight: 50,maxWidth: 50,minHeight: 50,minWidth: 50),
                      child: QueryArtworkWidget(
                          id: selectedAlbumSongs[index].id,
                          type: ArtworkType.AUDIO,
                          nullArtworkWidget: const Icon(
                            Icons.music_note,
                            color: Colors.black,
                          )),
                    ),
                    title: Text(selectedAlbumSongs[index].display_name),
                    subtitle: Text("${selectedAlbumSongs[index].artist}"),
              //      trailing: whichWidget(selectedAlbumSongs,index),
                    onTap: () {
                      if(getPlayingStatus()==true){
                        print("get PLaying Status IF TRUE ${getPlayingStatus()}");

                          playerControllers.audioPlayer.dispose();

                        playerControllers.isPlaying=false;
                        putPlayingStatus(false);
                      }
                      playerScreen(selectedAlbumSongs[index].uri!,
                          index,
                          selectedAlbumSongs,
                          selectedAlbumSongs[index].id,
                          selectedAlbumSongs[index].display_name,
                          selectedAlbumSongs[index].artist!);

                    },
                  );

                },
                itemCount: selectedAlbumSongs.length,
                separatorBuilder: (context, index) {
                  return const Divider();
                },
              );
            }
          },
        );


  }

  favoritesSection(){
    return ValueListenableBuilder(
      valueListenable: favoritesNotifier,
      builder: ( context,  value, child) {
        if (value.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          print(" ELSE if Favorite $value");
          return ListView.separated(
            itemBuilder: (context, index) {
              // var snapshot = value[index];

              return ListTile(
                leading: ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 50,maxWidth: 50,minHeight: 50,minWidth: 50),
                  child: QueryArtworkWidget(
                      id: value[index].id,
                      type: ArtworkType.AUDIO,
                      nullArtworkWidget: const Icon(
                        Icons.music_note,
                        color: Colors.black,
                      )),
                ),
                title: Text(value[index].display_name),
                subtitle: Text("${value[index].artist}"),
                trailing: popupForFavorites(value,index),
                onTap: () {
                  playerScreen(value[index].uri!,
                      index,
                      value,
                      value[index].id,
                      value[index].display_name,
                      value[index].artist!);
                },
              );

            },
            itemCount: value.length,
            separatorBuilder: (context, index) {
              return const Divider();
            },
          );
        }
      },
    );
  }

  recentSection(){
    return ValueListenableBuilder(
      valueListenable: db_AllSongsNotifier,
      builder: ( context,  value, child) {
        if (value.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          print(" ELSE if $value");
          if(title=='recent') {
            selectedAlbumSongs.clear();
            for (var value1 in value) {
              if (albumName == value1.album) {
                selectedAlbumSongs.add(value1);
              }
            }
          }
          return ListView.separated(
            itemBuilder: (context, index) {
              // var snapshot = value[index];

              return ListTile(
                leading: ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 50,maxWidth: 50,minHeight: 50,minWidth: 50),
                  child: QueryArtworkWidget(
                      id: value[index].id,
                      type: ArtworkType.AUDIO,
                      nullArtworkWidget: const Icon(
                        Icons.music_note,
                        color: Colors.black,
                      )),
                ),
                title: Text(value[index].display_name),
                subtitle: Text("${value[index].artist}"),
             //   trailing: whichWidget(value,index),
                onTap: () {
                  playerScreen(selectedAlbumSongs[index].uri!,
                      index,
                      selectedAlbumSongs,
                      selectedAlbumSongs[index].id,
                      selectedAlbumSongs[index].display_name,
                      selectedAlbumSongs[index].artist!);
                },
              );

            },
            itemCount: value.length,
            separatorBuilder: (context, index) {
              return const Divider();
            },
          );
        }
      },
    );
  }

  playerScreen(String uri, int index, List<ModalClassAllSongs> modals, int id,
      String display_name, String artist) {
    return Navigator.of(context).push(MaterialPageRoute(builder: (cont){
      return BottomSheetPlayer(
        uri: uri,
        index: index,
        songList: modals,
        intImage: id,
        songTitle: display_name,
        artistName: artist,
      );
    }));
  }

}
