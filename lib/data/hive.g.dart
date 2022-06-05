// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StoreIndexAdapter extends TypeAdapter<StoreIndex> {
  @override
  final int typeId = 0;

  @override
  StoreIndex read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StoreIndex(
      isLoggedIn: fields[1] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, StoreIndex obj) {
    writer
      ..writeByte(1)
      ..writeByte(1)
      ..write(obj.isLoggedIn);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StoreIndexAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
