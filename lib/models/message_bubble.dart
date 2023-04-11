import 'package:flutter/material.dart';
import 'package:roleplay_kit/api/openai.dart';

class MessageBubble extends StatefulWidget {
  MessageBubble({super.key, required this.message, required this.role}) {
    design = role == Roles.user
        ? const BubbleDesign(
            color: Colors.lightBlue,
            alignment: Alignment.topRight,
          )
        : const BubbleDesign(
            color: Colors.grey,
            alignment: Alignment.topLeft,
          );
  }
  final String message;
  final Roles role;
  late final BubbleDesign design;

  @override
  State<MessageBubble> createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 14, right: 14, top: 10, bottom: 10),
      child: Align(
        alignment: widget.design.alignment,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: widget.design.color,
          ),
          padding: const EdgeInsets.all(16),
          child: Text(
            widget.message,
            style: const TextStyle(fontSize: 15),
          ),
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
  });

  final Color color;
  final Alignment alignment;
  final Color shadowColor;
}
