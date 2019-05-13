import 'package:jaguar_serializer/jaguar_serializer.dart';

part 'message.jser.dart';

@GenSerializer()
class MessageSerializer extends Serializer<Message> with _$MessageSerializer {}

class Message {
  Message(
    this.title,
    this.content,
    this.customContent,
  );

  final String title;
  final String content;
  final String customContent; // empty string or map
}
