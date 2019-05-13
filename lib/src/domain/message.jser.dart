// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message.dart';

// **************************************************************************
// JaguarSerializerGenerator
// **************************************************************************

abstract class _$MessageSerializer implements Serializer<Message> {
  @override
  Map<String, dynamic> toMap(Message model) {
    if (model == null) return null;
    Map<String, dynamic> ret = <String, dynamic>{};
    setMapValue(ret, 'title', model.title);
    setMapValue(ret, 'content', model.content);
    setMapValue(ret, 'customContent', model.customContent);
    return ret;
  }

  @override
  Message fromMap(Map map) {
    if (map == null) return null;
    final obj = new Message(
        map['title'] as String ?? getJserDefault('title'),
        map['content'] as String ?? getJserDefault('content'),
        map['customContent'] as String ?? getJserDefault('customContent'));
    return obj;
  }
}
