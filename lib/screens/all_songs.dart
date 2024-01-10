import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:music_player_project_one/contentWidget/show_dialog_playlist.dart';
import 'package:music_player_project_one/modal_class/songList.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../contentWidget/edit_dialog_widget.dart';
import '../contentWidget/song_popup_options.dart';
import '../hive_db/db_recent_list.dart';
import 'musicplayer_screen.dart';
import '../hive_db/db_favorite_list.dart';
import '../hive_db/db_playlist.dart';
import '../utils/controllers.dart';
import '../hive_db/db_functions.dart';

class AllSongsScreen extends StatefulWidget {
  final String fromPageName;
  final String title;

  const AllSongsScreen(
      {super.key, required this.fromPageName, required this.title});

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
  PlayerControllers playerControllers = PlayerControllers();
  bool searchStatus = false;
  final searchController=TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fromPageName = widget.fromPageName;
    title = widget.title;
    valueListenableBuilder = whichNotifierBuilder();
    print(valueListenableBuilder);
  }

  whichNotifierBuilder() {
    if (fromPageName == "all") {
      return allSongSection();
    } else if (fromPageName == "album") {
      return albumSection();
    } else if (fromPageName == "playlist") {
      return playlistSection();
    } else if (fromPageName == "favorite") {
      return favoritesSection();
    } else if (fromPageName == "recent") {
      return recentSection();
    }
  }

  selectGETsection() {
    if (fromPageName == "all") {
      return getAllSongs();
    } else if (fromPageName == "album") {
      return getAllSongs();
    } else if (fromPageName == "playlist") {
      return getPlayList();
    } else if (fromPageName == "favorite") {
      return getFavoritesList();
    } else if (fromPageName == "recent") {
      return getRecentData();
    }
  }

  @override
  Widget build(BuildContext context) {
    selectGETsection();
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: searchStatus
            ? Padding(
              padding: const EdgeInsets.only(left: 5.0,right: 5.0),
              child: Container(
                height: 40,
          padding: EdgeInsets.only(left: 4.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(5.0),
                  ),
          child: TextField(
              controller: searchController,
              onChanged: searchBar,
              decoration:  InputDecoration(
                border: InputBorder.none,
                hintText: "Search",
                prefixIcon: Icon(Icons.search),
                suffixIcon: IconButton(onPressed: (){
                  setState(() {
                    searchStatus=!searchStatus;
                    searchController.text="";
                  });
                }, icon: const Icon(Icons.close)),
              ),
          ),
                ),
            )
            : Text(title),
      ),
      body: valueListenableBuilder,
      floatingActionButton: fromPageName == "all"
          ? FloatingActionButton(
              onPressed: () {
                setState(() {
                  searchStatus=!searchStatus;
                });
              },
              child: const Icon(Icons.search),
            )
          : null,
    );
  }

  popupForPlaylist(List<ModalClassAllSongs> value, int? songID, int? allSongsId) {
    print("allSongID  popupForPlaylist  $allSongsId");
    return PopupMenuButton<int>(itemBuilder: (ctx) {
      return [
        const PopupMenuItem(value: 1, child: Text("Remove from playlist")),
      ];
    }, onSelected: (val) {
      if (val == 1) {
       // playerControllers.scaffoldMessage(context, "msg");
        print("object");
        removeFromPlaylist(songID!, allSongsId);
      }
    });
  }

  popupForFavorites(List<ModalClassAllSongs> value, int index) {
    return PopupMenuButton<int>(itemBuilder: (ctx){
      return [ const PopupMenuItem(
        value: 1,
          child: Text("Remove from favorites")),];
    },
    onSelected: (val){
      if(val==1){

        removeFromFavorites(index, value[index].allSongsId);
      }
    },);
  }

  playlistSection() {
    return ValueListenableBuilder(
      valueListenable: playListNotifier,
      builder: (context, value, child) {
        if (value.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          print(" ELSE if PlayList$value");

          if (fromPageName == "playlist") {
            selectedPlaylistSongs.clear();
            /*for (var elem in value) {
              if (title == elem.playListName) {
                selectedPlaylistSongs.add(elem);
              }
            }*/
            for(int i=0;i<value.length;i++){
              print("PlayList${value[i].display_name}");
              if (title == value[i].playListName) {
                ModalClassAllSongs modalClassAllSongs = ModalClassAllSongs(
                  songId: i,
                    playListName: value[i].playListName,
                    favoritesListStatus: value[i].favoritesListStatus,
                    playListStatus: value[i].playListStatus,
                    allSongsId: value[i].allSongsId,
                    favoriteListName: value[i].favoriteListName,
                    uri: value[i].uri,
                    artist: value[i].artist,
                    title: value[i].title,
                    display_name: value[i].display_name,
                    album: value[i].album,
                    id: value[i].id);
                selectedPlaylistSongs.add(modalClassAllSongs);
             //   selectedPlaylistSongs
              }
            }
          }
          print("selectedPlaylistSongs$selectedPlaylistSongs");
          if(selectedPlaylistSongs.isEmpty){
            print("selectedPlaylistSongs.isEmpty$selectedPlaylistSongs");
            return const Center(child: Text("No Data",style: TextStyle(color: Colors.blueGrey)),);
          }else if(selectedPlaylistSongs==null){
            print("selectedPlaylistSongs.isNULL$selectedPlaylistSongs");
            return const Center(child: Text("No Data",style: TextStyle(color: Colors.blueGrey)),);
          }else {
            print("selectedPlaylistSongs HAS DATA $selectedPlaylistSongs");
            return ListView.separated(
              itemBuilder: (context, index) {
                var snapshot = selectedPlaylistSongs[index];
                print("Playlist \n"
                    "Name : ${snapshot.title} \n"
                    "SongsId :${snapshot.songId}\n"
                    "AllSongsId :${snapshot.allSongsId}\n"
                    "playListStatus :${snapshot.playListStatus}\n"
                    "playListName :${snapshot.playListName}\n");

                print("selectedPlaylistSongs    ${selectedPlaylistSongs}");
                return ListTile(
                  leading: ConstrainedBox(
                    constraints: const BoxConstraints(
                        maxHeight: 50,
                        maxWidth: 50,
                        minHeight: 50,
                        minWidth: 50),
                    child: QueryArtworkWidget(
                        id: selectedPlaylistSongs[index].id,
                        type: ArtworkType.AUDIO,
                        nullArtworkWidget: const Icon(
                          Icons.music_note,
                          color: Colors.black,
                        )),
                  ),
                  title: RichText(
                      overflow: TextOverflow.ellipsis,
                      text: TextSpan(
                          text: selectedPlaylistSongs[index].display_name,
                          style: TextStyle(color: Colors.black, fontSize: 17))
                  ),
                  subtitle: Text("${selectedPlaylistSongs[index].artist}"),
                  trailing: popupForPlaylist(selectedPlaylistSongs,
                      selectedPlaylistSongs[index].songId,
                      selectedPlaylistSongs[index].allSongsId),
                  onTap: () {
                    playerScreen(
                        selectedPlaylistSongs[index].uri!,
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
        }
      },
    );
  }

  allSongSection() {
    return ValueListenableBuilder(
      valueListenable: db_AllSongsNotifier,
      builder: (context, value, child) {
        if (value.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          print(" ELSE if All Songs$value");
          return ListView.separated(
            itemBuilder: (context, index) {
              var snapshot = value[index];
              // print("Name : ${snapshot.title} \n"
              //     "SongsId :${snapshot.songId}\n"
              //     "AllSongsId :${snapshot.allSongsId}\n"
              //     "playListStatus :${snapshot.playListStatus}\n"
              //     "playListName :${snapshot.playListName}\n");
              return ListTile(
                leading: ConstrainedBox(
                  constraints: const BoxConstraints(
                      maxHeight: 50, maxWidth: 50, minHeight: 50, minWidth: 50),
                  child: QueryArtworkWidget(
                      id: value[index].id,
                      type: ArtworkType.AUDIO,
                      nullArtworkWidget: const Icon(
                        Icons.music_note,
                        color: Colors.black,
                      )),
                ),
                title: RichText(overflow: TextOverflow.ellipsis,
                    text: TextSpan(
                        text: value[index].display_name,
                        style: TextStyle(color: Colors.black,fontSize: 17))
                ),
                subtitle: Text("${value[index].artist}"),
                trailing: Popup_Song_Options(value:value, index:index,setCallback:setStateCallback,fromPage:"allsongs"),
                onTap: () {
                  playerScreen(value[index].uri!, index, value, value[index].id,
                      value[index].display_name, value[index].artist!);
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

  void setStateCallback(){
    //print("QWERTYUIOASDFGHJKLZXCVBNM");
    setState(() {

    });
  }

  setStateMethod(){
    setState(() {

    });
  }

  albumSection() {
    return ValueListenableBuilder(
      valueListenable: db_AllSongsNotifier,
      builder: (BuildContext context, List<ModalClassAllSongs> value,
          Widget? child) {
        if (value.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          print(" ELSE if Album ${value.length}");

          if (fromPageName == 'album') {
            selectedAlbumSongs.clear();
            for (var value1 in value) {
              if (title == value1.album) {
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
                  constraints: const BoxConstraints(
                      maxHeight: 50, maxWidth: 50, minHeight: 50, minWidth: 50),
                  child: QueryArtworkWidget(
                      id: selectedAlbumSongs[index].id,
                      type: ArtworkType.AUDIO,
                      nullArtworkWidget: const Icon(
                        Icons.music_note,
                        color: Colors.black,
                      )),
                ),
                title: RichText(
                    overflow: TextOverflow.ellipsis,
                    text: TextSpan(text: selectedAlbumSongs[index].display_name,
                    style: TextStyle(color: Colors.black,fontSize: 17))
                ),
                subtitle: Text("${selectedAlbumSongs[index].artist}"),
                //      trailing: whichWidget(selectedAlbumSongs,index),
                onTap: () {
                  playerScreen(
                      selectedAlbumSongs[index].uri!,
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

  favoritesSection() {
    return ValueListenableBuilder(
      valueListenable: favoritesNotifier,
      builder: (context, value, child) {
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
                  constraints: const BoxConstraints(
                      maxHeight: 50, maxWidth: 50, minHeight: 50, minWidth: 50),
                  child: QueryArtworkWidget(
                      id: value[index].id,
                      type: ArtworkType.AUDIO,
                      nullArtworkWidget: const Icon(
                        Icons.music_note,
                        color: Colors.black,
                      )),
                ),
                title:
                    RichText(overflow: TextOverflow.ellipsis,
                        text: TextSpan(
                            text: value[index].display_name,
                            style: TextStyle(color: Colors.black,fontSize: 17))
                    ),
                subtitle: Text("${value[index].artist}"),
                trailing: popupForFavorites(value, index),
                onTap: () {
                  playerScreen(value[index].uri!, index, value, value[index].id,
                      value[index].display_name, value[index].artist!);
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

  recentSection() {
    return ValueListenableBuilder(
      valueListenable: recentNotifier,
      builder: (context, value, child) {
        if (value.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          print(" ELSE if $value");

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
                  constraints: const BoxConstraints(
                      maxHeight: 50, maxWidth: 50, minHeight: 50, minWidth: 50),
                  child: QueryArtworkWidget(
                      id: value[index].id,
                      type: ArtworkType.AUDIO,
                      nullArtworkWidget: const Icon(
                        Icons.music_note,
                        color: Colors.black,
                      )),
                ),
                title: RichText(overflow: TextOverflow.ellipsis,
                    text: TextSpan(
                        text: value[index].display_name,
                        style: const TextStyle(color: Colors.black,fontSize: 17))
                ),
                subtitle: Text("${value[index].artist}"),
                   trailing: Popup_Song_Options(value:value, index:index,setCallback:setStateCallback,fromPage:"recent"),
                onTap: () {
                  playerScreen(
                      value[index].uri!,
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

  playerScreen(String uri, int index, List<ModalClassAllSongs> modals, int id,
      String display_name, String artist) {
    if (getPlayingStatus() == true) {
      print("get PLaying Status IF TRUE ${getPlayingStatus()}");

      playerControllers.audioPlayer.dispose();

      playerControllers.isPlaying = false;
      putPlayingStatus(false);
    }
    return Navigator.of(context).push(MaterialPageRoute(builder: (cont) {
      return BottomSheetPlayer(
        uri: uri,
        index: index,
        songList: modals,
        intImage: id,
        songTitle: display_name,
        artistName: artist,
        setStateMethod: setStateMethod,
      );
    }));
  }
}
