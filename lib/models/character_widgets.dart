import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

class CharacterCreation extends StatefulWidget {
  const CharacterCreation({Key? key}) : super(key: key);

  @override
  State<CharacterCreation> createState() => _CharacterCreationState();
}

class _CharacterCreationState extends State<CharacterCreation> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  CharacterType _type = CharacterType.warrior;

  void _submitCharacter() {
    // Perform validation or save character data and navigate to next page
    print(Character(
        name: _nameController.text,
        type: _type,
        age: int.parse(_ageController.text)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Character Creation')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Name:'),
            TextField(
              controller: _nameController,
              decoration:
                  const InputDecoration(hintText: 'Enter character name'),
            ),
            const SizedBox(height: 8),
            const Text('Age:'),
            TextField(
              controller: _ageController,
              decoration:
                  const InputDecoration(hintText: 'Enter character age'),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: false,
                signed: false,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(
                    RegExp(r'^\d+$')), // Allow only numbers and a decimal point
              ],
            ),
            const SizedBox(height: 8),
            const Text('Gender:'),
            const SizedBox(height: 16),
            DropdownButton<String>(
              value: _type.korean,
              hint: const Text('Select Class'),
              items: CharacterType.values
                  .map<DropdownMenuItem<String>>((CharacterType value) {
                return DropdownMenuItem<String>(
                  value: value.korean,
                  child: Text(value.korean),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _type = CharacterType.warrior.fromKorean(newValue!);
                });
              },
            ),
            ElevatedButton(
              onPressed: _submitCharacter,
              child: const Text('Create Character'),
            ),
          ],
        ),
      ),
    );
  }
}
