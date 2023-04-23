class Character {
  late String name;
  late CharacterType type;
  late int age;

  Character({required this.name, required this.type, required this.age});

  @override
  String toString() {
    return 'Character{name: $name, type: $type, age: $age}';
  }

  String toPrompt() {
    return '이름: $name, 직업: ${type.korean}, 나이: $age';
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
