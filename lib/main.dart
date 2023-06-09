import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:roleplay_kit/models/character.dart';
import 'package:roleplay_kit/models/message_bubble.dart';
import 'package:roleplay_kit/views/chat_window.dart';
import 'package:roleplay_kit/views/character_widgets.dart';
import 'package:roleplay_kit/api/openai.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(BubbleDataAdapter());
  Hive.registerAdapter(RolesAdapter());
  await Hive.openBox<List<dynamic>>('save');
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
            FutureBuilder<CharacterModel?>(
                future: CharacterModel.load(),
                builder: (context, AsyncSnapshot<CharacterModel?> snapshot) {
                  if (snapshot.hasData && snapshot.data != null) {
                    return ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatWindow(
                              character: snapshot.data!,
                            ),
                          ),
                        );
                      },
                      child: const Text('Continue'),
                    );
                  } else {
                    return const ElevatedButton(
                      onPressed: null,
                      child: Text('Continue'),
                    );
                  }
                }),
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
  const NewGame({super.key});

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
                  var c = newCharacterView.character;
                  c.save();
                  print(c.toString());
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ChatWindow(
                              character: c,
                            )),
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
