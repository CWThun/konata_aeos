import 'package:freezed_annotation/freezed_annotation.dart';

part 'chats.freezed.dart';
part 'chats.g.dart';

enum MessageType {
  left,
  right,
}

///会話メッセージモデル
@freezed
class ChatMessage with _$ChatMessage {
  const factory ChatMessage({
    required String text,
    @Default('') String date,
    @Default('') String time,
    @Default(MessageType.left) MessageType type,
    @Default(false) bool isLoading,
  }) = _ChatMessage;

  factory ChatMessage.fromJson(Map<String, Object?> json) => _$ChatMessageFromJson(json);
}

///問診応答リクエスト
@freezed
class QnARequestModel with _$QnARequestModel {
  const factory QnARequestModel({
    required int aivo_id,
    required String timestamp,
    required String speech_txt,
  }) = _QnARequestModel;

  factory QnARequestModel.fromJson(Map<String, Object?> json) => _$QnARequestModelFromJson(json);
}

///問診応答レスポンス
@freezed
class QnAResponseModel with _$QnAResponseModel {
  const factory QnAResponseModel({
    required String message,
    required String answer_txt,
    @Default(false) bool isError,
  }) = _QnAResponseModel;

  factory QnAResponseModel.fromJson(Map<String, Object?> json) => _$QnAResponseModelFromJson(json);
}

@freezed
class HistoryModel with _$HistoryModel {
  const factory HistoryModel({
    required String timestamp,
    required String category,
    required String content,
  }) = _HistoryModel;

  factory HistoryModel.fromJson(Map<String, Object?> json) => _$HistoryModelFromJson(json);
}
