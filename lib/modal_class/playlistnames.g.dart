// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'playlistnames.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PlayListNameAdapter extends TypeAdapter<PlayListName> {
  @override
  final int typeId = 103;

  @override
  PlayListName read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PlayListName(
      namess: fields[0] as String,
    );
  }

  @override
  void write(BinaryWriter writer, PlayListName obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.namess);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlayListNameAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
