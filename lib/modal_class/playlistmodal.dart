import 'package:hive_flutter/adapters.dart';
part 'playlistmodal.g.dart';

@HiveType(typeId: 101)
class PlayListModalClass{
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

  PlayListModalClass({
    this.songId,
    required this.uri,
    required this.artist,
    required this.title,
    required this.display_name,
    required this.album,
    required this.id});


}