import 'package:flutter/material.dart';
import 'package:music_player_project_one/utils/controllers.dart';

import '../hive_db/db_playlist_names.dart';
import '../modal_class/playlistnames.dart';

class EditDelPlaylistName extends StatelessWidget {
  int index;

  String playlistName;
  final playListNameController = TextEditingController();
  List<PlayListName> playNames = [];
  PlayerControllers playerControllers=PlayerControllers();

  EditDelPlaylistName(
      {super.key, required this.index, required this.playlistName});

  getvalues() async {
    playNames = getRETURNPlayNAMES();
    print("playNmaes  $playNames");
  }

  @override
  Widget build(BuildContext context) {
    getvalues();
    playListNameController.text=playlistName;
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
              child: const Text(
                "Update",
                style: TextStyle(color: Colors.blueGrey),
              )),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  void checkName(BuildContext context) {
    String names = playListNameController.text;
    print("playNames.asMap()     $names   ${playNames.contains(names)}");
    if (names.isEmpty) {
      playerControllers.scaffoldMessage(context, "Enter Valid Name");
    } else if (playNames.contains(names)) {
      print("CONTAINS ${playNames.contains(names)}");
      playerControllers.scaffoldMessage(context, "Playlist have the same name");
    } else {
      PlayListName val = PlayListName(namess: names);
      updatePlaylistData(index,val);
    }
  }
}
