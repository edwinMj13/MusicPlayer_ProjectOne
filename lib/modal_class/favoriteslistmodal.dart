import 'package:hive_flutter/adapters.dart';
part 'favoriteslistmodal.g.dart';


@HiveType(typeId: 102)
class FavoritesListModalClass{
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

  FavoritesListModalClass({
    this.songId,
    required this.uri,
    required this.artist,
    required this.title,
    required this.display_name,
    required this.album,
    required this.id});


}