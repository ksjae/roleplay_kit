// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'openai.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RolesAdapter extends TypeAdapter<Roles> {
  @override
  final int typeId = 2;

  @override
  Roles read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return Roles.user;
      case 1:
        return Roles.generator;
      case 2:
        return Roles.system;
      default:
        return Roles.user;
    }
  }

  @override
  void write(BinaryWriter writer, Roles obj) {
    switch (obj) {
      case Roles.user:
        writer.writeByte(0);
        break;
      case Roles.generator:
        writer.writeByte(1);
        break;
      case Roles.system:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RolesAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
