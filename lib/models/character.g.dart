// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'character.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CharacterModel _$CharacterModelFromJson(Map<String, dynamic> json) =>
    CharacterModel(
      name: json['name'] as String,
      type: $enumDecode(_$CharacterTypeEnumMap, json['type']),
      age: json['age'] as int,
    );

Map<String, dynamic> _$CharacterModelToJson(CharacterModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'type': _$CharacterTypeEnumMap[instance.type]!,
      'age': instance.age,
    };

const _$CharacterTypeEnumMap = {
  CharacterType.warrior: 'warrior',
  CharacterType.mage: 'mage',
  CharacterType.rogue: 'rogue',
  CharacterType.bard: 'bard',
};
