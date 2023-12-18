
import 'package:hive_flutter/adapters.dart';
part 'songList.g.dart';

@HiveType(typeId: 100)
class ModalClassAllSongs{
  @HiveField(0)
  int? songId;
  @HiveField(1)
  String? uri;
  @HiveField(2)
  String? artist;
  @HiveField(3)
  String? title;
  @HiveField(4)
  String display_name;
  @HiveField(5)
  String? album;
  @HiveField(6)
  int id;
  @HiveField(7)
  String? playListStatus;
  @HiveField(8)
  String? favoritesListStatus;
  @HiveField(9)
  String? playListName;
  @HiveField(10)
  String? favoriteListName;
  @HiveField(11)
  int? allSongsId;

  ModalClassAllSongs({
    this.songId,
    this.playListStatus,
    this.favoritesListStatus,
    this.playListName,
    this.favoriteListName,
    required this.uri,
    required this.artist,
    required this.title,
    required this.display_name,
    required this.album,
    required this.id,
    this.allSongsId});
}


/*

{_uri: content://media/external/audio/media/1000210464,
 artist: <unknown>,
 year: null,
 is_music: false,
 title: നന്ദി,
 genre_id: null,
 _size: 3182883,
 duration: 193136,
 is_alarm: false,
 _display_name_wo_ext: നന്ദി,
 album_artist: null,
 genre: null,
 is_notification: false,
 track: 0,
 _data: /storage/emulated/0/Recordings/Voice Recorder/നന്ദി.m4a,
 _display_name: നന്ദി.m4a,
 album: Voice Recorder,
 composer: null,
 is_ringtone: false,
 artist_id: 4057462020091213480,
 is_podcast: false,
 bookmark: 0,
 date_added: 1683383891,
 is_audiobook: false,
 date_modified: 1683384093,
 album_id: 1279041188088292517,
 file_extension: m4a,
_id: 1000210464}

*/