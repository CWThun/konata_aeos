// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chats.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ChatMessageImpl _$$ChatMessageImplFromJson(Map<String, dynamic> json) => _$ChatMessageImpl(
      text: json['text'] as String,
      date: json['date'] as String? ?? '',
      time: json['time'] as String? ?? '',
      type: $enumDecodeNullable(_$MessageTypeEnumMap, json['type']) ?? MessageType.left,
      isLoading: json['isLoading'] as bool? ?? false,
    );

Map<String, dynamic> _$$ChatMessageImplToJson(_$ChatMessageImpl instance) => <String, dynamic>{
      'text': instance.text,
      'date': instance.date,
      'time': instance.time,
      'type': _$MessageTypeEnumMap[instance.type]!,
      'isLoading': instance.isLoading,
    };

const _$MessageTypeEnumMap = {
  MessageType.left: 'left',
  MessageType.right: 'right',
};

_$QnARequestModelImpl _$$QnARequestModelImplFromJson(Map<String, dynamic> json) => _$QnARequestModelImpl(
      aivo_id: (json['aivo_id'] as num).toInt(),
      timestamp: json['timestamp'] as String,
      speech_txt: json['speech_txt'] as String,
    );

Map<String, dynamic> _$$QnARequestModelImplToJson(_$QnARequestModelImpl instance) => <String, dynamic>{
      'aivo_id': instance.aivo_id,
      'timestamp': instance.timestamp,
      'speech_txt': instance.speech_txt,
    };

_$QnAResponseModelImpl _$$QnAResponseModelImplFromJson(Map<String, dynamic> json) => _$QnAResponseModelImpl(
      message: json['message'] as String,
      answer_txt: json['answer_txt'] as String,
      isError: json['isError'] as bool? ?? false,
    );

Map<String, dynamic> _$$QnAResponseModelImplToJson(_$QnAResponseModelImpl instance) => <String, dynamic>{
      'message': instance.message,
      'answer_txt': instance.answer_txt,
      'isError': instance.isError,
    };

_$HistoryModelImpl _$$HistoryModelImplFromJson(Map<String, dynamic> json) => _$HistoryModelImpl(
      timestamp: json['timestamp'] as String,
      category: json['category'] as String,
      content: json['content'] as String,
    );

Map<String, dynamic> _$$HistoryModelImplToJson(_$HistoryModelImpl instance) => <String, dynamic>{
      'timestamp': instance.timestamp,
      'category': instance.category,
      'content': instance.content,
    };
