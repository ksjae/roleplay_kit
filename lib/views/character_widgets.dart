import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:roleplay_kit/models/character.dart';

class CharacterCreation extends StatefulWidget {
  CharacterCreation({Key? key}) : super(key: key);
  final character =
      CharacterModel(name: "", type: CharacterType.warrior, age: 0);

  @override
  State<CharacterCreation> createState() => _CharacterCreationState();
}

class _CharacterCreationState extends State<CharacterCreation> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Name:'),
        TextField(
          controller: _nameController,
          decoration: const InputDecoration(hintText: 'Enter character name'),
          onChanged: (String value) async {
            widget.character.name = value;
          },
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
          onChanged: (String value) async {
            widget.character.age = int.parse(value);
          },
        ),
        const SizedBox(height: 8),
        const Text('Gender:'),
        const SizedBox(height: 16),
        DropdownButton<String>(
          value: widget.character.type.korean,
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
              widget.character.type =
                  CharacterType.warrior.fromKorean(newValue!);
            });
          },
        ),
      ],
    );
  }
}
