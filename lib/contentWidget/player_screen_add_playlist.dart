
import 'package:flutter/material.dart';
import 'package:music_player_project_one/hive_db/db_functions.dart';
import 'package:music_player_project_one/hive_db/db_playlist_names.dart';

import '../hive_db/db_playlist.dart';
import '../modal_class/playlistnames.dart';
import '../modal_class/songList.dart';

class MusicPlayerScreen_AddPlaylist extends StatelessWidget {
  ModalClassAllSongs playListNameModal;
  VoidCallback callbackChangeValue;
  int songId;
   MusicPlayerScreen_AddPlaylist({super.key,required this.playListNameModal,required this.callbackChangeValue,required this.songId});
  List<String> playNames=[];

  @override
  Widget build(BuildContext context) {
    getPlayNAMES();
    return Dialog(
        backgroundColor: Colors.blueGrey,
      child: firstSection(context)
    );
  }
  Widget firstSection(context) {
    print("playListNameModal${playListNameModal.songId}");
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
      const SizedBox(height: 10,),
      const Text("Select From the Playlist",style: TextStyle(fontSize: 20,color: Colors.white),),
      SizedBox(
          height:MediaQuery.of(context).size.height * 0.4,
          child: ValueListenableBuilder(
            valueListenable: playListNamesNotifier,
            builder: (BuildContext context, List<PlayListName> value, Widget? child) {

              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: ListView.separated(
                    padding: const EdgeInsets.only(left: 5.0,right: 5.0,top: 10.0,bottom: 10.0),
                    itemBuilder: (context,index){
                      var itemData=value[index];
                      //    print("firstSection BuilderValue $playNames");
                      playNames.clear();
                      playNames=value.map((e) => e.namess).toList();
                      return InkWell(
                          onTap: (){
                            playListNameModal.playListName=playNames[index];
                            playListNameModal.playListStatus='yes';
                            print("playListNameModal \n"
                                "Name ${playListNameModal.display_name}\n"
                                "title ${playListNameModal.title}\n"
                                "uri ${playListNameModal.uri}\n"
                              //  "songId ${playListNameModal.songId!}\n"
                                "");
                            addToPlaylist(playListNameModal,songId);
                            playerControllers.scaffoldMessageForFav(context, "Added",color: Colors.red);
                            callbackChangeValue();
                            Navigator.pop(context);
                          },
                          child: Text(itemData.namess,style: const TextStyle(fontSize: 19,color: Colors.blueGrey),));
                    },
                    separatorBuilder: (context,index){
                      return const Divider();
                    },
                    itemCount: value.length,
                  ),
                ),
              );
            },
          )),
    ],);
  }
}
