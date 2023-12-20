// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'db_modalclass.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DbModalClassAdapter extends TypeAdapter<Db_ModalClass> {
  @override
  final int typeId = 1;

  @override
  Db_ModalClass read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Db_ModalClass(
      albumName: fields[0] as String,
      albumdetails: fields[1] as AlbumDetails,
    );
  }

  @override
  void write(BinaryWriter writer, Db_ModalClass obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.albumName)
      ..writeByte(1)
      ..write(obj.albumdetails);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DbModalClassAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AlbumDetailsAdapter extends TypeAdapter<AlbumDetails> {
  @override
  final int typeId = 2;

  @override
  AlbumDetails read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AlbumDetails(
      songFullName: fields[0] as String?,
      songUri: fields[1] as String?,
      songTitle: fields[2] as String?,
      songArtist: fields[3] as String?,
      songGenre: fields[4] as String?,
      songAddedDate: fields[5] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, AlbumDetails obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.songFullName)
      ..writeByte(1)
      ..write(obj.songUri)
      ..writeByte(2)
      ..write(obj.songTitle)
      ..writeByte(3)
      ..write(obj.songArtist)
      ..writeByte(4)
      ..write(obj.songGenre)
      ..writeByte(5)
      ..write(obj.songAddedDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AlbumDetailsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}