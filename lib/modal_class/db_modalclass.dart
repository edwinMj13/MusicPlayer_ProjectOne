import 'package:hive_flutter/adapters.dart';
part 'db_modalclass.g.dart';
@HiveType(typeId: 1)
class Db_ModalClass {
  @HiveField(0)
  String albumName;
  @HiveField(1)
  AlbumDetails albumdetails;

  Db_ModalClass({required this.albumName, required this.albumdetails});

/*  AlbumDetails (){
  String songFullName;
  String songUri;
  String songTitle;
  String songArtist;
  String songGenre;
  String songAddedDate;

  Db_ModalClass(
      {required this.albumName,
        required this.songFullName,
        required this.songUri,
        required this.songTitle,
        required this.songArtist,
        required this.songGenre,
        required this.songAddedDate});
}
*/
}

@HiveType(typeId: 2)
class AlbumDetails {
  @HiveField(0)
  String? songFullName;
  @HiveField(1)
  String? songUri;
  @HiveField(2)
  String? songTitle;
  @HiveField(3)
  String? songArtist;
  @HiveField(4)
  String? songGenre;
  @HiveField(5)
  int? songAddedDate;

  AlbumDetails(
      {required this.songFullName,
      required this.songUri,
      required this.songTitle,
      required this.songArtist,
      required this.songGenre,
      required this.songAddedDate});
}
