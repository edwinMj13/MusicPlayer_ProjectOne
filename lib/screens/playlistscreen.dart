import 'package:flutter/material.dart';
import 'package:music_player_project_one/hive_db/db_functions.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../hive_db/db_playlist.dart';
import '../modal_class/songList.dart';

class PlaylistScreen extends StatelessWidget {

   PlaylistScreen({super.key,});

  @override
  Widget build(BuildContext context) {
    getPlayList();
    return Scaffold(
      body: ValueListenableBuilder(
          valueListenable: playListNotifier,
          builder: (BuildContext context, List<ModalClassAllSongs> itemValue, Widget? child){
            return ListView.builder(
                itemBuilder: (ctx,index){
                  return ListTile(
                    leading: QueryArtworkWidget(
                        id: itemValue[index].id,
                        type: ArtworkType.AUDIO,
                        nullArtworkWidget: const Icon(
                          Icons.music_note,
                          color: Colors.black,
                          size: 32,
                        )),
                    title: Text(itemValue[index].display_name),
                    subtitle: Text("${itemValue[index].artist}"),
                    trailing: PopupMenuButton<int>(
                        itemBuilder: (ctx){
                          return [
                            const PopupMenuItem(
                              value: 1,
                                child: Text("Remove from playlist")),
                          ];
                        },
                    onSelected: (value){
                      ModalClassAllSongs modalC= ModalClassAllSongs(uri: itemValue[index].uri,
                          playListStatus: "no",
                          artist: itemValue[index].artist,
                          title: itemValue[index].title,
                          display_name: itemValue[index].display_name,
                          album: itemValue[index].album,
                          id: itemValue[index].id);
                     //     removeFromPlaylist(itemValue[index].songId!,itemValue[index].allSongsId);
                    }),
                  );
                });
          }),
    );
  }
}
