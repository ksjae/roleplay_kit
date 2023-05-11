import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:roleplay_kit/api/openai.dart';

part 'message_bubble.g.dart';

class MessageBubble extends StatefulWidget {
  MessageBubble(
      {super.key,
      required message,
      required role,
      this.doGenerate = false,
      this.history,
      this.openAIAPI}) {
    data = BubbleData(
      text: message,
      role: role,
    );
    design = role == Roles.user
        ? const BubbleDesign(
            color: Colors.lightBlue,
            alignment: Alignment.topRight,
          )
        : const BubbleDesign(
            color: Colors.grey,
            alignment: Alignment.topLeft,
            padding: EdgeInsets.only(left: 15, right: 30, top: 10, bottom: 10),
          );
  }
  late final BubbleDesign design;
  late final BubbleData data;
  late final bool doGenerate; // If true, listens to AI stream
  final ChatApi? openAIAPI;
  final List<MessageBubble>? history;

  @override
  State<MessageBubble> createState() => _MessageBubbleState();

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'MessageBubble{message: ${data.text} role: ${data.role}, design: $design, doGenerate: $doGenerate, openAIAPI: $openAIAPI, history: $history}';
  }

  static MessageBubble fromBubbleData(BubbleData data) {
    return MessageBubble(
      message: data.text,
      role: data.role,
      doGenerate: false,
      history: null,
      openAIAPI: null,
    );
  }
}

class _MessageBubbleState extends State<MessageBubble> {
  var _generated = false;

  @override
  Widget build(BuildContext context) {
    Widget bubbleContent;
    if (widget.data.role == Roles.system) {
      return const SizedBox.shrink();
    }

    if (!_generated && widget.doGenerate) {
      var streamController = StreamController<String>();

      if (widget.history == null) {
        throw Exception('Chat history must be provided for generation');
      }
      if (widget.openAIAPI == null) {
        throw Exception('OpenAI API must be provided for generation');
      }
      ChatApi.streamChat(
          ChatApi.parseMessages(widget.history!), streamController, () {
        setState(() {
          _generated = true;
        });
      });
      bubbleContent = StreamBuilder(
          stream: streamController.stream,
          builder: (context, AsyncSnapshot<String> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const BubbleText(text: ChatApi.loadingMessage);
            } else if (snapshot.hasError) {
              return BubbleText(
                text: 'Error: ${snapshot.error}',
              );
            } else if (snapshot.hasData) {
              widget.data.text += snapshot.data!;
              // if (generatedText.length < 5) {
              //   print(snapshot.data!);
              // }
              return widget.data.bubbleText;
            } else {
              return const BubbleText(
                text: 'No Response :(',
              );
            }
          });
    } else {
      bubbleContent = widget.data.bubbleText;
    }

    return Container(
      padding: widget.design.padding,
      child: Align(
        alignment: widget.design.alignment,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: widget.design.color,
          ),
          padding: const EdgeInsets.all(16),
          child: bubbleContent,
        ),
      ),
    );
  }
}

class BubbleDesign {
  const BubbleDesign({
    this.color = Colors.blue,
    this.alignment = Alignment.topRight,
    this.shadowColor = Colors.grey,
    this.padding =
        const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
  });

  final Color color;
  final Alignment alignment;
  final Color shadowColor;
  final EdgeInsets padding;
}

class BubbleText extends StatelessWidget {
  final String text;
  const BubbleText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return SelectableText(
      text,
      style: const TextStyle(fontSize: 15, fontFamily: 'reading'),
    );
  }
}

@HiveType(typeId: 1)
class BubbleData {
  BubbleData({required this.text, required this.role});

  @HiveField(0)
  String text;

  @HiveField(1)
  final Roles role;

  @override
  String toString() {
    return 'BubbleData{text: $text, role: $role}';
  }

  BubbleText get bubbleText {
    return BubbleText(text: text);
  }
}
