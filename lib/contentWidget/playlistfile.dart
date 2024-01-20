import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:music_player_project_one/hive_db/db_functions.dart';
import 'package:music_player_project_one/hive_db/db_playlist.dart';
import 'package:music_player_project_one/screens/all_songs.dart';
import 'package:music_player_project_one/utils/colors.dart';

import '../hive_db/db_playlist_names.dart';
import '../modal_class/playlistnames.dart';
import '../modal_class/songList.dart';
import 'editDeletePlaylistName.dart';

class PlayNameWidget extends StatelessWidget {
   PlayNameWidget({super.key});

  List<ModalClassAllSongs> playSongs=[];
   List<ModalClassAllSongs> finalPlaySongs=[];
   List<int> indexList=[];
   getPlaylistSongs(){
     playSongs=getReturnPlaylist();
   }

  @override
  Widget build(BuildContext context) {
    getPlayNAMES();
    getPlaylistSongs();
    return ValueListenableBuilder(
        valueListenable: playListNamesNotifier,
        builder:
            (BuildContext context, List<PlayListName> itemData, Widget? child) {
          if(itemData.isEmpty){
            print("PlaylistFile IsEmpty");
            return Center(child: Text("No Data",style: TextStyle(color: Colors.white)),);
          }else if(itemData==null){
            print("PlaylistFile Is NULL");
            return Center(child: Text("No Data",style: TextStyle(color: Colors.white)),);
          }else {
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2),
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (ctx) {
                          return AllSongsScreen(
                            fromPageName: 'playlist',
                            title: itemData[index].namess,
                          );
                        }));
                  },
                  onLongPress: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext ctx) {
                          return Dialog(
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Container(
                              height: 130,
                              width: 150,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Expanded(
                                    child: Center(
                                      child: InkWell(
                                          onTap: () {
                                            Navigator.pop(ctx);
                                            showDialog(context: context,
                                                builder: (ctx2) {
                                                  return EditDelPlaylistName(
                                                    index: index,
                                                    playlistName: itemData[index]
                                                        .namess,
                                                  );
                                                });
                                          },
                                          child: Text("Edit", style: TextStyle(
                                              fontSize: 20,
                                              color: appThemeT),)),
                                    ),
                                  ),
                                  Container(height: 1, width: 200,
                                    color: Colors.grey,),
                                  Expanded(
                                    child: Center(
                                      child: InkWell(onTap: () {
                                        getAllPlayListSongs(
                                            itemData[index].namess);
                                        deletePlaylistData(index);
                                        Navigator.pop(ctx);
                                      },
                                          child: Text("Delete",
                                            style: TextStyle(fontSize: 20,
                                                color: appThemeT),)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        });
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        "assets/album_icon.svg",
                        height: 140,
                        width: 140,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      RichText(
                        overflow: TextOverflow.ellipsis,
                        strutStyle: const StrutStyle(fontSize: 15.0),
                        text: TextSpan(
                          style: const TextStyle(color: Colors.white),
                          text: itemData[index].namess,
                        ),
                      ),
                    ],
                  ),
                );
              },
              itemCount: itemData.length,
            );
          }
        });
  }

  void getAllPlayListSongs(String namess) {
     indexList.clear();
    for(int i=0;i<playSongs.length;i++) {
      if (playSongs[i].playListName == namess) {
        indexList.add(i);
       /* ModalClassAllSongs modalClassAllSongs = ModalClassAllSongs(
          songId: i,
            playListName: playSongs[i].playListName,
            favoritesListStatus: playSongs[i].favoritesListStatus,
            playListStatus: playSongs[i].playListStatus,
            allSongsId: playSongs[i].allSongsId,
            favoriteListName: playSongs[i].favoriteListName,
            uri: playSongs[i].uri,
            artist: playSongs[i].artist,
            title: playSongs[i].title,
            display_name: playSongs[i].display_name,
            album: playSongs[i].album,
            id: playSongs[i].id);
        finalPlaySongs.add(modalClassAllSongs);*/
      }
    }
     delAllWhenDelAPlaylist(indexList);
  }

}
