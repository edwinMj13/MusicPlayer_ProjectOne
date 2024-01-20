import 'package:flutter/material.dart';
import 'package:music_player_project_one/hive_db/db_playlist_names.dart';

import '../modal_class/playlistnames.dart';
import '../utils/colors.dart';

class ShowDialogToAddPlaylist extends StatefulWidget {
  var playerController;
   ShowDialogToAddPlaylist({super.key,this.playerController});

  @override
  State<ShowDialogToAddPlaylist> createState() =>
      _ShowDialogToAddPlaylistState();
}

class _ShowDialogToAddPlaylistState extends State<ShowDialogToAddPlaylist> {
  var playerControllers;
  final playListNameController=TextEditingController();
  List<PlayListName> playNames=[];
  @override
   initState()  {
    // TODO: implement initState
    super.initState();
    playerControllers=widget.playerController;
    getvalues();
  }
  getvalues() async {
    playNames= getRETURNPlayNAMES();
    print("playNmaes  $playNames");
  }
  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.white,
                ),
                child: TextField(
                  maxLength: 10,
                  controller: playListNameController,
                  decoration: const InputDecoration(
                    hintText: "Enter Playlist Name",
                    contentPadding: EdgeInsets.all(5.0),
                    border: InputBorder.none,
                  ),
                ),
              )),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
              ),
              onPressed: () {
                checkName(context);
              },
              child:  Text(
                "Create",
                style: TextStyle(color: appThemeT),
              )),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
  void checkName(BuildContext context) {
    String names=playListNameController.text;
    print("playNames.asMap()     $names   ${playNames.contains(names)}");
    if(names.isEmpty){
      playerControllers.scaffoldMessage(context, "Enter Valid Name");
    }else if(playNames.contains(names)){
      print("CONTAINS ${playNames.contains(names)}");
      playerControllers.scaffoldMessage(context,"Playlist have the same name");
    }else{
      PlayListName val=PlayListName(namess: names);
      addPLaylistNAmes(val);
      Navigator.pop(context);
    }
  }
}
