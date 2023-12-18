import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:music_player_project_one/screens/all_songs.dart';

import '../hive_db/db_functions.dart';
import '../screens/albumplaylist.dart';

class AlbumList extends StatelessWidget {
  const AlbumList({super.key});

  @override
  Widget build(BuildContext context) {
    return  ValueListenableBuilder(
        valueListenable: db_Notifier,
        builder: (BuildContext context, List<String> value,
            Widget? child) {
          print("Albums length ${value.length}");
          if (value.isEmpty) {
            return const Center(
              child: Text("No Data"),
            );
          } else if (value == null) {
            return const Center(
              child: Text("No Data"),
            );
          } else {
            return GridView.builder(
              padding: const EdgeInsets.only(top: 20.0),
              itemCount: value.length,
              gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2),
              itemBuilder: (context, index) {
                var itemAlbumName = value[index];

                return InkWell(
                  onTap: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (ctx) {
                      return AllSongsScreen(
                        fromPageName: 'album',
                        title: itemAlbumName,
                      );
                    }));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
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
                            text: itemAlbumName,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        });
  }
}
