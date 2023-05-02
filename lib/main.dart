import 'package:flutter/material.dart';
import 'package:roleplay_kit/models/character.dart';
import 'package:roleplay_kit/views/chat_window.dart';
import 'package:roleplay_kit/views/character_widgets.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainMenu(),
    );
  }
}

class MainMenu extends StatelessWidget {
  MainMenu({super.key});
  final character =
      CharacterModel(name: "", type: CharacterType.warrior, age: 0);

  // TODO: Add a continue button only if a new game is created

  @override
  Widget build(BuildContext context) {
    bool canContinue = false;
    // check save file
    return Scaffold(
      appBar: AppBar(
        title: const Text('Roleplay Kit'),
        flexibleSpace: SafeArea(
            child: Row(
          children: [
            const SizedBox(
              width: 12,
            ),
            const Expanded(
                child: SizedBox(
              height: 16,
            )),
            Center(
              child: Icon(
                Icons.settings,
                color: Colors.grey.shade700,
              ),
            ),
          ],
        )),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Welcome to Roleplay Kit',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(
              height: 20,
            ),
            canContinue
                ? ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatWindow(
                            character: character,
                          ),
                        ),
                      );
                    },
                    child: const Text('Continue'),
                  )
                : const SizedBox(
                    height: 0,
                  ),
            SizedBox(
              height: canContinue ? 20 : 0,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => NewGame(character: character)),
                );
              },
              child: const Text('New Game'),
            ),
            const SizedBox(
              height: 20,
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Other Button'),
            ),
          ],
        ),
      ),
    );
  }
}

class NewGame extends StatelessWidget {
  final CharacterModel character;

  const NewGame({super.key, required this.character});

  @override
  Widget build(BuildContext context) {
    var newCharacterView = CharacterCreation();
    return Scaffold(
        appBar: AppBar(
          title: Text('New Game'),
        ),
        body: Center(
          child: Column(
            children: [
              const Text(
                'Choose a game to start',
                style: TextStyle(fontSize: 24),
              ),
              const SizedBox(
                height: 20,
              ),
              newCharacterView,
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SecondPage()),
                  );
                },
                child: const Text('START'),
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ));
  }
}

class SecondPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Second Page'),
      ),
      body: Center(
        child: Text('Hello, world!'),
      ),
    );
  }
}
