import 'dart:async';
import 'package:flutter/material.dart';
import 'package:roleplay_kit/api/openai.dart';

class MessageBubble extends StatefulWidget {
  MessageBubble(
      {super.key,
      required this.message,
      required this.role,
      this.doGenerate = false,
      this.history,
      this.openAIAPI}) {
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
  final String message;
  final Roles role;
  late final BubbleDesign design;
  late final bool doGenerate; // If true, listens to AI stream
  final ChatApi? openAIAPI;
  final List<MessageBubble>? history;

  @override
  State<MessageBubble> createState() => _MessageBubbleState();

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'MessageBubble{message: $message, role: $role, design: $design, doGenerate: $doGenerate, openAIAPI: $openAIAPI, history: $history}';
  }
}

class _MessageBubbleState extends State<MessageBubble> {
  var _generated = false;
  String generatedText = '';

  @override
  Widget build(BuildContext context) {
    Widget bubbleContent = BubbleText(
      text: generatedText,
    );
    if (widget.role == Roles.system) {
      return const SizedBox.shrink();
    }

    if (_generated) {
      bubbleContent = BubbleText(
        text: generatedText,
      );
    } else if (widget.doGenerate) {
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
              generatedText += snapshot.data!;
              // if (generatedText.length < 5) {
              //   print(snapshot.data!);
              // }
              return BubbleText(text: generatedText);
            } else {
              return const BubbleText(
                text: 'No Response :(',
              );
            }
          });
    } else {
      generatedText = widget.message;
      bubbleContent = BubbleText(text: generatedText);
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
      style: const TextStyle(fontSize: 15),
    );
  }
}
