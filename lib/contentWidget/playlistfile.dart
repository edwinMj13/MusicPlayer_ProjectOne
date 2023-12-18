import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:music_player_project_one/hive_db/db_functions.dart';
import 'package:music_player_project_one/screens/all_songs.dart';

import '../hive_db/db_playlist_names.dart';
import '../modal_class/playlistnames.dart';

class PlayNameWidget extends StatelessWidget {
  const PlayNameWidget({super.key});

  @override
  Widget build(BuildContext context) {
    getPlayNAMES();
    return ValueListenableBuilder(
        valueListenable: playListNamesNotifier,
        builder:(BuildContext context, List<PlayListName> itemData, Widget? child){
          return GridView.builder(
            padding: const EdgeInsets.only(top: 20.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2),
              itemBuilder: (context,index){
                return InkWell(
                  onTap: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (ctx) {
                      return AllSongsScreen(
                        fromPageName: 'playlist',
                        title: itemData[index].namess,
                      );
                    }));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
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
                  ),
                );
              },
            itemCount: itemData.length,
          );
        });
  }
}
