import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:roleplay_kit/api/openai.dart';
import 'package:roleplay_kit/models/character.dart';
import 'package:roleplay_kit/models/message_bubble.dart';

class ChatWindow extends StatefulWidget {
  ChatWindow({
    super.key,
    required this.character,
  }) {
    List<BubbleData> save =
        saveBox.get(character.name, defaultValue: [])?.cast<BubbleData>() ?? [];
    if (save != []) {
      messages =
          save.map((data) => MessageBubble.fromBubbleData(data)).toList();
    } else {
      messages = ChatApi.initialPrompts;
    }
  }
  final userInputController = TextEditingController();
  final CharacterModel character;
  final Box<List<dynamic>> saveBox = Hive.box('save');
  late final List<MessageBubble> messages;

  @override
  State<ChatWindow> createState() => _ChatWindowState();
}

class _ChatWindowState extends State<ChatWindow> {
  var _showMenu = false;

  void save() {
    var bubbleDataList = widget.messages.map((msg) => msg.data).toList();
    widget.saveBox.put(widget.character.name, bubbleDataList);
    print(
        'saved ${bubbleDataList.length} items from ${bubbleDataList.first} to ${bubbleDataList.last}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        flexibleSpace: SafeArea(
            child: Container(
          padding: const EdgeInsets.only(right: 8),
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
                      widget.character.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    Row(
                      children: [
                        Text(
                          widget.character.typeString,
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 13,
                          ),
                        ),
                        SizedBox(
                          width: 12,
                        ),
                        Text(
                          widget.character.age.toString(),
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
              IconButton(
                  onPressed: save,
                  icon: Icon(
                    Icons.save,
                    color: Colors.grey.shade700,
                  )),
              IconButton(
                  onPressed: () {
                    setState(() {
                      _showMenu = true;
                    });
                  },
                  icon: Icon(
                    Icons.settings,
                    color: Colors.grey.shade700,
                  ))
            ],
          ),
        )),
        automaticallyImplyLeading: false,
      ),
      body: Stack(children: [
        Column(
          children: [
            Expanded(
              child: Messages(
                messageList: widget.messages,
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
        if (_showMenu)
          Container(
            color: Colors.black.withOpacity(0.5),
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _showMenu = false;
                        });
                      },
                      child: const Text('Close'),
                    ),
                    TextButton(
                      onPressed: () {
                        save();
                        Navigator.pop(context);
                      },
                      child: const Text('Save & Quit'),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ]),
    );
  }

  void _createTextWidget() {
    setState(() {
      widget.messages.add(
        MessageBubble(
          message: widget.userInputController.text,
          role: Roles.user,
        ),
      );
      widget.messages.add(_createTextWidgetFromAI());
    });
    widget.userInputController.clear();
  }

  MessageBubble _createTextWidgetFromAI() {
    // What if there are multiple messages?
    return MessageBubble(
      message: "",
      role: Roles.generator,
      doGenerate: true,
      history: widget.messages,
      openAIAPI: ChatApi(),
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
