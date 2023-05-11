import 'dart:async';
import 'package:hive/hive.dart';
import 'package:dart_openai/openai.dart';
import 'package:roleplay_kit/env/env.dart';
import 'package:roleplay_kit/models/message_bubble.dart';

part 'openai.g.dart';

class ChatApi {
  static const _model = 'gpt-3.5-turbo';
  static const loadingMessage = '스카이넷에게 물어보는 중...';
  static final initialPrompts = [
    MessageBubble(
      message:
          "던전 앤 드래곤 같은 TRPG의 진행자가 되어 게임을 진행해. 내가 하는 행동은 결정하지 않되 내 행동을 바탕으로 일어나는 모든 행동을 작가처럼 글을 써. 장소와 다른 등장인물의 이름은 너가 만들어.",
      role: Roles.system,
    ),
    MessageBubble(
      message: "TRPG 게임의 진행자로서 여러분의 이야기를 써드리겠습니다. 먼저 캐릭터의 이름과 직업을 알려주세요.",
      role: Roles.generator,
    ),
  ];

  ChatApi() {
    OpenAI.apiKey = Env.apiKey;
    //OpenAI.organization = Env.organization;
  }

  static Future<String> completeChat(List<MessageBubble> messages) async {
    final chatCompletion = await OpenAI.instance.chat.create(
      model: _model,
      messages: messages
          .map((e) => OpenAIChatCompletionChoiceMessageModel(
                role: e.data.role.openAI,
                content: e.data.text,
              ))
          .toList(),
    );
    return chatCompletion.choices.first.message.content;
  }

  static void streamChat(
    List<OpenAIChatCompletionChoiceMessageModel> messages,
    StreamController<String> streamController,
    Function callback,
  ) {
    OpenAI.instance.chat
        .createStream(
          model: _model,
          messages: messages,
        )
        .listen(
          (event) => {
            event.choices.first.delta.content == null
                ? null
                : streamController.add(event.choices.first.delta.content!)
          },
          onDone: () => {streamController.close(), callback()},
        );
  }

  static List<OpenAIChatCompletionChoiceMessageModel> parseMessages(
      List<MessageBubble> messages,
      {bool truncate = false}) {
    List<OpenAIChatCompletionChoiceMessageModel> parsedMessages = [];
    int maxChars = 4000;
    for (var i = messages.length - 1; i >= 0; i--) {
      if (maxChars <= 0) {
        break;
      }
      maxChars -= messages[i].data.text.length;
      if (truncate && maxChars <= 0) {
        parsedMessages.add(OpenAIChatCompletionChoiceMessageModel(
          role: messages[i].data.role.openAI,
          content: messages[i]
              .data
              .text
              .substring(0, maxChars + messages[i].data.text.length),
        ));
      } else {
        parsedMessages.add(OpenAIChatCompletionChoiceMessageModel(
          role: messages[i].data.role.openAI,
          content: messages[i].data.text,
        ));
      }
    }
    return parsedMessages.reversed.toList();
  }
}

@HiveType(typeId: 2)
enum Roles {
  @HiveField(0, defaultValue: true)
  user,
  @HiveField(1)
  generator,
  @HiveField(2)
  system
}

extension OpenAIRoles on Roles {
  OpenAIChatMessageRole get openAI {
    switch (this) {
      case Roles.user:
        return OpenAIChatMessageRole.user;
      case Roles.generator:
        return OpenAIChatMessageRole.assistant;
      case Roles.system:
        return OpenAIChatMessageRole.system;
    }
  }
}
