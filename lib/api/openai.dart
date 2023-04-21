import 'dart:async';

import 'package:dart_openai/openai.dart';
import '../env/env.dart';
import '../models/message_bubble.dart';

class ChatApi {
  static const _model = 'gpt-3.5-turbo';

  ChatApi() {
    OpenAI.apiKey = Env.apiKey;
    //OpenAI.organization = Env.organization;
  }

  Future<String> completeChat(List<MessageBubble> messages) async {
    final chatCompletion = await OpenAI.instance.chat.create(
      model: _model,
      messages: messages
          .map((e) => OpenAIChatCompletionChoiceMessageModel(
                role: e.role.openAI,
                content: e.message,
              ))
          .toList(),
    );
    return chatCompletion.choices.first.message.content;
  }

  void streamChat(
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

  List<OpenAIChatCompletionChoiceMessageModel> parseMessages(
      List<MessageBubble> messages) {
    return messages
        .map((e) => OpenAIChatCompletionChoiceMessageModel(
              role: e.role.openAI,
              content: e.message,
            ))
        .toList();
  }
}

enum Roles { user, generator, system }

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

const loadingMessage = '스카이넷에게 물어보는 중...';
