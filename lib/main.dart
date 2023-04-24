import 'package:flutter/material.dart';
import 'views/chat_window.dart';
import 'views/character_widgets.dart';

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
  const MainMenu({super.key});

  // TODO: Add a new game/continue button

  @override
  Widget build(BuildContext context) {
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
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatWindow(),
                  ),
                );
              },
              child: const Text('Continue'),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NewGame()),
                );
              },
              child: const Text('New Game'),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CharacterCreation()),
                );
              },
              child: const Text('Create Character'),
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
  @override
  Widget build(BuildContext context) {
    const newCharacterView = CharacterCreation();
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
