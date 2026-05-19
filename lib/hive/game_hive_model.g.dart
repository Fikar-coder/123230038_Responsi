// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GameHiveModelAdapter extends TypeAdapter<GameHiveModel> {
  @override
  final int typeId = 0;

  @override
  GameHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GameHiveModel()
      ..id = fields[0] as int
      ..title = fields[1] as String
      ..thumbnail = fields[2] as String
      ..genre = fields[3] as String
      ..platform = fields[4] as String;
  }

  @override
  void write(BinaryWriter writer, GameHiveModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.thumbnail)
      ..writeByte(3)
      ..write(obj.genre)
      ..writeByte(4)
      ..write(obj.platform);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GameHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
