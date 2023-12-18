// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favoriteslistmodal.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FavoritesListModalClassAdapter
    extends TypeAdapter<FavoritesListModalClass> {
  @override
  final int typeId = 102;

  @override
  FavoritesListModalClass read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FavoritesListModalClass(
      songId: fields[0] as int?,
      uri: fields[1] as String?,
      artist: fields[2] as String?,
      title: fields[3] as String?,
      display_name: fields[4] as String,
      album: fields[5] as String?,
      id: fields[6] as int,
    );
  }

  @override
  void write(BinaryWriter writer, FavoritesListModalClass obj) {
    writer
      ..writeByte(7)
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
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FavoritesListModalClassAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
