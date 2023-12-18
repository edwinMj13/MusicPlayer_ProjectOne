// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'songList.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ModalClassAllSongsAdapter extends TypeAdapter<ModalClassAllSongs> {
  @override
  final int typeId = 100;

  @override
  ModalClassAllSongs read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ModalClassAllSongs(
      songId: fields[0] as int?,
      playListStatus: fields[7] as String?,
      favoritesListStatus: fields[8] as String?,
      playListName: fields[9] as String?,
      favoriteListName: fields[10] as String?,
      uri: fields[1] as String?,
      artist: fields[2] as String?,
      title: fields[3] as String?,
      display_name: fields[4] as String,
      album: fields[5] as String?,
      id: fields[6] as int,
      allSongsId: fields[11] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, ModalClassAllSongs obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.songId)
      ..writeByte(1)
      ..write(obj.uri)
      ..writeByte(2)
      ..write(obj.artist)
      ..writeByte(3)
      ..write(obj.title)
      ..writeByte(4)
      ..write(obj.display_name)
      ..writeByte(5)
      ..write(obj.album)
      ..writeByte(6)
      ..write(obj.id)
      ..writeByte(7)
      ..write(obj.playListStatus)
      ..writeByte(8)
      ..write(obj.favoritesListStatus)
      ..writeByte(9)
      ..write(obj.playListName)
      ..writeByte(10)
      ..write(obj.favoriteListName)
      ..writeByte(11)
      ..write(obj.allSongsId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ModalClassAllSongsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
