// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_bubble.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BubbleDataAdapter extends TypeAdapter<BubbleData> {
  @override
  final int typeId = 1;

  @override
  BubbleData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BubbleData(
      text: fields[0] as String,
      role: fields[1] as Roles,
    );
  }

  @override
  void write(BinaryWriter writer, BubbleData obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.text)
      ..writeByte(1)
      ..write(obj.role);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BubbleDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
