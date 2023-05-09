import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'character.g.dart';

@JsonSerializable()
class CharacterModel extends ChangeNotifier {
  late String _name;
  late CharacterType _type;
  late int _age;

  CharacterModel(
      {required String name, required CharacterType type, required int age})
      : _age = age,
        _type = type,
        _name = name;

  factory CharacterModel.fromJson(Map<String, dynamic> json) =>
      _$CharacterModelFromJson(json);

  Map<String, dynamic> toJson() => _$CharacterModelToJson(this);

  Future save() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('character', jsonEncode(toJson()));
  }

  static Future<CharacterModel?> load() async {
    final prefs = await SharedPreferences.getInstance();
    final characterJson = prefs.getString('character');
    if (characterJson != null) {
      return CharacterModel.fromJson(jsonDecode(characterJson));
    }
    return null;
  }

  String get name => _name;
  CharacterType get type => _type;
  String get typeString => _type.korean;
  int get age => _age;

  set name(String name) {
    _name = name;
    notifyListeners();
  }

  set type(CharacterType type) {
    _type = type;
    notifyListeners();
  }

  set age(int age) {
    _age = age;
    notifyListeners();
  }

  void getOlder() {
    _age++;
    notifyListeners();
  }

  @override
  String toString() {
    return 'Character{name: $_name, type: $_type, age: $_age}';
  }

  String toPrompt() {
    return '이름: $_name, 직업: ${_type.korean}, 나이: $_age';
  }
}

enum CharacterType { warrior, mage, rogue, bard }

// This is getting slightly ugly, but i aint got time for multilingual
extension Korean on CharacterType {
  String get korean {
    switch (this) {
      case CharacterType.warrior:
        return '전사';
      case CharacterType.mage:
        return '마법사';
      case CharacterType.rogue:
        return '도적';
      case CharacterType.bard:
        return '음유시인';
    }
  }

  CharacterType fromKorean(String korean) {
    switch (korean) {
      case '전사':
        return CharacterType.warrior;
      case '마법사':
        return CharacterType.mage;
      case '도적':
        return CharacterType.rogue;
      case '음유시인':
        return CharacterType.bard;
      default:
        throw Exception('Invalid Korean character type');
    }
  }
}
