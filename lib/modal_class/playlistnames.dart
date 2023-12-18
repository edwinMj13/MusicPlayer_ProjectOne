import 'package:hive_flutter/adapters.dart';
part 'playlistnames.g.dart';

@HiveType(typeId: 103)
class PlayListName{
  @HiveField(0)
  String namess;
  PlayListName({required this.namess});
}