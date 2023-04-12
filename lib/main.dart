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
    return MaterialApp(
      home: ChatWindow(),
    );
  }
}

class ChatWindow extends StatefulWidget {
  ChatWindow({super.key});
  final userInputController = TextEditingController();

  @override
  State<ChatWindow> createState() => _ChatWindowState();
}

class _ChatWindowState extends State<ChatWindow> {
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
            child: Messages(),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: InputField(
              userInputController: widget.userInputController,
            ),
          ),
        ],
      ),
    );
  }
}

class Messages extends StatelessWidget {
  const Messages({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      physics: const BouncingScrollPhysics(),
      shrinkWrap: true,
      children: [
        MessageBubble(
          message:
              "헤프 키루나는 의사로서 지난 10년간 전쟁이 벌어진 대륙의 작은 마을에서 일하며 환자들을 치료하고 있었다. 그러던 어느 날, 마을 근처에 있는 숲에서 이상한 소리가 들려왔다. 헤프는 궁금해져 그 소리가 어디서 나오는지 찾아나섰다. 길을 따라 걸어가다가 그는 갑자기 가지에 매여 있는 남자를 발견했다. 그 남자는 천천히 눈을 떴고, 헤프가 다가가자 입을 열었다. \"나는 마법사다. 그리고 네가 나를 구해준 것에 감사한다.\" 헤프는 깜짝 놀랐지만, 그는 이 마법사를 치료해주기로 결정했다. \n헤프는 이 마법사를 자신의 집으로 데려와 치료를 시작했다. 그러나 그는 마법사가 다치지 않은 것을 깨달았다. 그 대신 그는 마법사가 가지고 있던 마법책을 얻게 되었다. 그 책은 이 세상의 어떠한 마법도 담고 있었다. 이제부터 헤프는 그 마법책을 통해 새로운 세계를 발견하게 될 것이다.",
          role: Roles.generator,
        ),
        MessageBubble(
          message: "...",
          role: Roles.user,
        ),
        MessageBubble(
          message:
              "헤프는 마법책을 얻은 이후로 더욱 많은 이야기와 모험을 경험하게 되었다. 그는 새로운 마법을 배우고, 이를 환자들에게 적용시키며 더 많은 사람들을 치료할 수 있게 되었다. 그리고 어느 날, 마을에 신비한 생물들이 출현하기 시작했다. 그들은 마을 주변에서 출몰하며 주민들을 위협했다. 헤프는 이 생물들을 처치하기 위해 마법을 사용해야 했다. 하지만 그는 자신이 가진 마법이 충분하지 않다는 것을 깨달았다.\n헤프는 자신이 알고 있는 모든 지식과 경험을 활용하여 새로운 마법을 창조하기 시작했다. 그는 며칠 동안 밤을 지새며 연구를 하다가, 마침내 새로운 마법을 창조해냈다. 이 마법은 생물들을 물리칠 수 있는 강력한 힘을 지니고 있었다.\n헤프는 마을 주민들과 함께 생물들과 맞서 싸웠다. 그는 자신의 새로운 마법으로 그들을 물리치고, 마을을 안전하게 지키게 되었다. 이제부터 헤프는 새로운 마법을 창조하고, 이를 사용해 세상을 더욱 더 안전하게 만드는 여행을 이어나갈 것이다.",
          role: Roles.generator,
        ),
      ],
    );
  }
}

class InputField extends StatelessWidget {
  const InputField({
    Key? key,
    required this.userInputController,
  }) : super(key: key);
  final TextEditingController userInputController;

  @override
  Widget build(BuildContext context) {
    return Container(
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
              controller: userInputController,
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
    );
  }
}
