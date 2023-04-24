import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/character.dart';

class CharacterCreation extends StatefulWidget {
  const CharacterCreation({Key? key}) : super(key: key);

  @override
  State<CharacterCreation> createState() => CharacterCreationState();
}

class CharacterCreationState extends State<CharacterCreation> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  CharacterType _type = CharacterType.warrior;

  Character newCharacter() {
    // Perform validation or save character data and navigate to next page
    return Character(
        name: _nameController.text,
        type: _type,
        age: int.parse(_ageController.text));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Name:'),
        TextField(
          controller: _nameController,
          decoration: const InputDecoration(hintText: 'Enter character name'),
        ),
        const SizedBox(height: 8),
        const Text('Age:'),
        TextField(
          controller: _ageController,
          decoration: const InputDecoration(hintText: 'Enter character age'),
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
      ],
    );
  }
}
