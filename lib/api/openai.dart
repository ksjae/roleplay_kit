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

  Stream<String> chatStream(
      List<OpenAIChatCompletionChoiceMessageModel> messages) {
    var stream = OpenAI.instance.chat.createStream(
      model: _model,
      messages: messages,
    );

    // No, I do NOT need to close the stream. It will close itself
    return stream.map((event) => event.choices.first.delta.content!);
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

// class GenerationStream extends Stream{
//   GenerationStream({
//     this.model="gpt-3.5-turbo"
//   });
//   final String model;

//   var chatStream = OpenAI.instance.chat.createStream(
//     model: "gpt-3.5-turbo",
//     messages: [
//       OpenAIChatCompletionChoiceMessageModel(
//         content: "너는 판타지 소설을 다른 사람과 같이 작성하는 작가야. 주인공의 행동 이외의 모든 것을 작성하면 돼.",
//         role: OpenAIChatMessageRole.system,
//       )
//     ],
//   );

//   this.chatStream.listen((chatStreamEvent) {
//     print(chatStreamEvent); // ...
//   });
// }