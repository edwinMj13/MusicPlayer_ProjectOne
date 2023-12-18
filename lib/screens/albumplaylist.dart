import 'package:flutter/material.dart';
import 'package:music_player_project_one/utils/controllers.dart';
import 'package:music_player_project_one/hive_db/db_functions.dart';
import 'package:music_player_project_one/modal_class/songList.dart';

class AlbumPlayList extends StatefulWidget {
  String albumName;

  AlbumPlayList({super.key, required this.albumName});

  @override
  State<AlbumPlayList> createState() =>
      _AlbumPlayListState();
}

class _AlbumPlayListState extends State<AlbumPlayList> {
  List<ModalClassAllSongs> songss = [];
  late String albumName;
  PlayerControllers playerControllers = PlayerControllers();

 // _AlbumPlayListState(this.albumName);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    albumName=widget.albumName;
  }

  @override
  Widget build(BuildContext context) {
    getAllSongs();
    return Scaffold(
      appBar: AppBar(
        title: RichText(
            overflow: TextOverflow.ellipsis,
            strutStyle: const StrutStyle(fontSize: 20),
            text: TextSpan(
              text: albumName,
            )),
      ),
      body: ValueListenableBuilder(
          valueListenable: db_AllSongsNotifier,
          builder: (BuildContext context, List<ModalClassAllSongs> value,
              Widget? child) {
            songss.clear();
            for (var value1 in value) {
              if (albumName == value1.album) {
                songss.add(value1);
              }
            }
            return ListView.builder(
              itemBuilder: (ctx, index) {print("ID    ${value[index].id}");
                return ListTile(
                  leading: const Icon(
                    Icons.music_note,
                    color: Colors.black,
                    size: 32,
                  ),
                  title: Text("${songss[index].title}"),
                  subtitle: Text("${songss[index].artist}"),

                  onTap: () {
                //    playerControllers.playSong(songss[index].uri, index);
                    print(
                        "PlayerController().playIndex.value    ${playerControllers.isPlaying}");
                    setState(() {});
                  },
                );
              },
              itemCount: songss.length,
            );
          }),
    );
  }
}


