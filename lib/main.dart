import 'package:flutter/material.dart';
import 'package:roleplay_kit/api/openai.dart';
import 'models/message_bubble.dart';

void main() {
  // var chatStream = OpenAI.instance.chat.createStream(
  //   model: "gpt-3.5-turbo",
  //   messages: [
  //     OpenAIChatCompletionChoiceMessageModel(
  //       content: "너는 판타지 소설을 다른 사람과 같이 작성하는 작가야. 주인공의 행동 이외의 모든 것을 작성하면 돼.",
  //       role: OpenAIChatMessageRole.system,
  //     )
  //   ],
  // );

  // chatStream.listen((chatStreamEvent) {
  //   print(chatStreamEvent); // ...
  // });
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: ChatWindow(),
    );
  }
}

class ChatWindow extends StatefulWidget {
  const ChatWindow({super.key});

  @override
  State<ChatWindow> createState() => _ChatWindowState();
}

class _ChatWindowState extends State<ChatWindow> {
  @override
  Widget build(BuildContext context) {
    var playerName = 'Mister Adventurer';
    const userBubbleDesign = BubbleDesign(
      color: Colors.lightBlue,
      alignment: Alignment.topRight,
    );
    var botBubbleDesign = BubbleDesign(
      color: Colors.grey.shade200,
      alignment: Alignment.topLeft,
    );
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        flexibleSpace: SafeArea(
            child: Container(
          padding: const EdgeInsets.only(right: 16),
          child: Row(
            children: [
              const SizedBox(
                width: 12,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      playerName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    Column(
                      children: [
                        Text(
                          'Online',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.settings,
                color: Colors.grey.shade700,
              ),
            ],
          ),
        )),
      ),
      body: Stack(
        children: [
          ListView.builder(
            itemCount: 10,
            shrinkWrap: true,
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return MessageBubble(
                message: "message",
                role: index % 2 == 0 ? Roles.generator : Roles.user,
              );
            },
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              padding: const EdgeInsets.only(left: 10, bottom: 10, top: 10),
              height: 60,
              width: double.infinity,
              color: Colors.white,
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        color: Colors.lightBlue,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  const Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Write message...',
                        hintStyle: TextStyle(color: Colors.black54),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  FloatingActionButton(
                    onPressed: () {},
                    backgroundColor: Colors.blue,
                    elevation: 0,
                    child: const Icon(
                      Icons.send,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
