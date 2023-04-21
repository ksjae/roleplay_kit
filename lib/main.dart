import 'package:flutter/material.dart';
import 'package:roleplay_kit/api/openai.dart';
import 'models/message_bubble.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ChatWindow(),
    );
  }
}

class ChatWindow extends StatefulWidget {
  ChatWindow({super.key});
  final userInputController = TextEditingController();
  final openAIAPI = ChatApi();

  @override
  State<ChatWindow> createState() => _ChatWindowState();
}

class _ChatWindowState extends State<ChatWindow> {
  List<MessageBubble> messages = [
    MessageBubble(
      message:
          "던전 앤 드래곤 같은 TRPG의 진행자가 되어 게임을 진행해. 내가 하는 행동은 결정하지 않되 내 행동을 바탕으로 일어나는 모든 행동을 작가처럼 글을 써. 장소와 다른 등장인물의 이름은 너가 만들어.",
      role: Roles.system,
    ),
    MessageBubble(
      message: "좋습니다. TRPG 게임의 진행자로서 여러분의 이야기를 써드리겠습니다. 먼저 캐릭터의 이름과 직업을 알려주세요.",
      role: Roles.generator,
    ),
  ];
  @override
  Widget build(BuildContext context) {
    var playerName = 'Mister Adventurer';
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
      body: Column(
        children: [
          Expanded(
            child: Messages(
              messageList: messages,
            ),
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
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(
                        hintText: 'What do you do?',
                        hintStyle: TextStyle(color: Colors.black54),
                        border: InputBorder.none,
                      ),
                      maxLines: null,
                      controller: widget.userInputController,
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  FloatingActionButton(
                    onPressed: _createTextWidget,
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

  void _createTextWidget() {
    setState(() {
      messages.add(
        MessageBubble(
          message: widget.userInputController.text,
          role: Roles.user,
        ),
      );
      messages.add(_createTextWidgetFromAI());
    });
    widget.userInputController.clear();
  }

  MessageBubble _createTextWidgetFromAI() {
    // What if there are multiple messages?
    return MessageBubble(
      message: loadingMessage,
      role: Roles.generator,
      doGenerate: true,
      history: messages,
      openAIAPI: widget.openAIAPI,
    );
  }
}

class Messages extends StatelessWidget {
  final List<MessageBubble> messageList;
  const Messages({super.key, required this.messageList});
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      physics: const BouncingScrollPhysics(),
      shrinkWrap: true,
      itemCount: messageList.length,
      itemBuilder: (BuildContext context, int index) {
        return messageList[index];
      },
    );
  }
}
