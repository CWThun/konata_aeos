// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chats.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ChatMessage _$ChatMessageFromJson(Map<String, dynamic> json) {
  return _ChatMessage.fromJson(json);
}

/// @nodoc
mixin _$ChatMessage {
  String get text => throw _privateConstructorUsedError;
  String get date => throw _privateConstructorUsedError;
  String get time => throw _privateConstructorUsedError;
  MessageType get type => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ChatMessageCopyWith<ChatMessage> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChatMessageCopyWith<$Res> {
  factory $ChatMessageCopyWith(ChatMessage value, $Res Function(ChatMessage) then) = _$ChatMessageCopyWithImpl<$Res, ChatMessage>;
  @useResult
  $Res call({String text, String date, String time, MessageType type, bool isLoading});
}

/// @nodoc
class _$ChatMessageCopyWithImpl<$Res, $Val extends ChatMessage> implements $ChatMessageCopyWith<$Res> {
  _$ChatMessageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? text = null,
    Object? date = null,
    Object? time = null,
    Object? type = null,
    Object? isLoading = null,
  }) {
    return _then(_value.copyWith(
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as String,
      time: null == time
          ? _value.time
          : time // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as MessageType,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ChatMessageImplCopyWith<$Res> implements $ChatMessageCopyWith<$Res> {
  factory _$$ChatMessageImplCopyWith(_$ChatMessageImpl value, $Res Function(_$ChatMessageImpl) then) = __$$ChatMessageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String text, String date, String time, MessageType type, bool isLoading});
}

/// @nodoc
class __$$ChatMessageImplCopyWithImpl<$Res> extends _$ChatMessageCopyWithImpl<$Res, _$ChatMessageImpl> implements _$$ChatMessageImplCopyWith<$Res> {
  __$$ChatMessageImplCopyWithImpl(_$ChatMessageImpl _value, $Res Function(_$ChatMessageImpl) _then) : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? text = null,
    Object? date = null,
    Object? time = null,
    Object? type = null,
    Object? isLoading = null,
  }) {
    return _then(_$ChatMessageImpl(
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as String,
      time: null == time
          ? _value.time
          : time // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as MessageType,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ChatMessageImpl implements _ChatMessage {
  const _$ChatMessageImpl({required this.text, this.date = '', this.time = '', this.type = MessageType.left, this.isLoading = false});

  factory _$ChatMessageImpl.fromJson(Map<String, dynamic> json) => _$$ChatMessageImplFromJson(json);

  @override
  final String text;
  @override
  @JsonKey()
  final String date;
  @override
  @JsonKey()
  final String time;
  @override
  @JsonKey()
  final MessageType type;
  @override
  @JsonKey()
  final bool isLoading;

  @override
  String toString() {
    return 'ChatMessage(text: $text, date: $date, time: $time, type: $type, isLoading: $isLoading)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChatMessageImpl &&
            (identical(other.text, text) || other.text == text) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.time, time) || other.time == time) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.isLoading, isLoading) || other.isLoading == isLoading));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, text, date, time, type, isLoading);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ChatMessageImplCopyWith<_$ChatMessageImpl> get copyWith => __$$ChatMessageImplCopyWithImpl<_$ChatMessageImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ChatMessageImplToJson(
      this,
    );
  }
}

abstract class _ChatMessage implements ChatMessage {
  const factory _ChatMessage({required final String text, final String date, final String time, final MessageType type, final bool isLoading}) = _$ChatMessageImpl;

  factory _ChatMessage.fromJson(Map<String, dynamic> json) = _$ChatMessageImpl.fromJson;

  @override
  String get text;
  @override
  String get date;
  @override
  String get time;
  @override
  MessageType get type;
  @override
  bool get isLoading;
  @override
  @JsonKey(ignore: true)
  _$$ChatMessageImplCopyWith<_$ChatMessageImpl> get copyWith => throw _privateConstructorUsedError;
}

QnARequestModel _$QnARequestModelFromJson(Map<String, dynamic> json) {
  return _QnARequestModel.fromJson(json);
}

/// @nodoc
mixin _$QnARequestModel {
  int get aivo_id => throw _privateConstructorUsedError;
  String get timestamp => throw _privateConstructorUsedError;
  String get speech_txt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $QnARequestModelCopyWith<QnARequestModel> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QnARequestModelCopyWith<$Res> {
  factory $QnARequestModelCopyWith(QnARequestModel value, $Res Function(QnARequestModel) then) = _$QnARequestModelCopyWithImpl<$Res, QnARequestModel>;
  @useResult
  $Res call({int aivo_id, String timestamp, String speech_txt});
}

/// @nodoc
class _$QnARequestModelCopyWithImpl<$Res, $Val extends QnARequestModel> implements $QnARequestModelCopyWith<$Res> {
  _$QnARequestModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? aivo_id = null,
    Object? timestamp = null,
    Object? speech_txt = null,
  }) {
    return _then(_value.copyWith(
      aivo_id: null == aivo_id
          ? _value.aivo_id
          : aivo_id // ignore: cast_nullable_to_non_nullable
              as int,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as String,
      speech_txt: null == speech_txt
          ? _value.speech_txt
          : speech_txt // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$QnARequestModelImplCopyWith<$Res> implements $QnARequestModelCopyWith<$Res> {
  factory _$$QnARequestModelImplCopyWith(_$QnARequestModelImpl value, $Res Function(_$QnARequestModelImpl) then) = __$$QnARequestModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int aivo_id, String timestamp, String speech_txt});
}

/// @nodoc
class __$$QnARequestModelImplCopyWithImpl<$Res> extends _$QnARequestModelCopyWithImpl<$Res, _$QnARequestModelImpl> implements _$$QnARequestModelImplCopyWith<$Res> {
  __$$QnARequestModelImplCopyWithImpl(_$QnARequestModelImpl _value, $Res Function(_$QnARequestModelImpl) _then) : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? aivo_id = null,
    Object? timestamp = null,
    Object? speech_txt = null,
  }) {
    return _then(_$QnARequestModelImpl(
      aivo_id: null == aivo_id
          ? _value.aivo_id
          : aivo_id // ignore: cast_nullable_to_non_nullable
              as int,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as String,
      speech_txt: null == speech_txt
          ? _value.speech_txt
          : speech_txt // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$QnARequestModelImpl implements _QnARequestModel {
  const _$QnARequestModelImpl({required this.aivo_id, required this.timestamp, required this.speech_txt});

  factory _$QnARequestModelImpl.fromJson(Map<String, dynamic> json) => _$$QnARequestModelImplFromJson(json);

  @override
  final int aivo_id;
  @override
  final String timestamp;
  @override
  final String speech_txt;

  @override
  String toString() {
    return 'QnARequestModel(aivo_id: $aivo_id, timestamp: $timestamp, speech_txt: $speech_txt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QnARequestModelImpl &&
            (identical(other.aivo_id, aivo_id) || other.aivo_id == aivo_id) &&
            (identical(other.timestamp, timestamp) || other.timestamp == timestamp) &&
            (identical(other.speech_txt, speech_txt) || other.speech_txt == speech_txt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, aivo_id, timestamp, speech_txt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$QnARequestModelImplCopyWith<_$QnARequestModelImpl> get copyWith => __$$QnARequestModelImplCopyWithImpl<_$QnARequestModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$QnARequestModelImplToJson(
      this,
    );
  }
}

abstract class _QnARequestModel implements QnARequestModel {
  const factory _QnARequestModel({required final int aivo_id, required final String timestamp, required final String speech_txt}) = _$QnARequestModelImpl;

  factory _QnARequestModel.fromJson(Map<String, dynamic> json) = _$QnARequestModelImpl.fromJson;

  @override
  int get aivo_id;
  @override
  String get timestamp;
  @override
  String get speech_txt;
  @override
  @JsonKey(ignore: true)
  _$$QnARequestModelImplCopyWith<_$QnARequestModelImpl> get copyWith => throw _privateConstructorUsedError;
}

QnAResponseModel _$QnAResponseModelFromJson(Map<String, dynamic> json) {
  return _QnAResponseModel.fromJson(json);
}

/// @nodoc
mixin _$QnAResponseModel {
  String get message => throw _privateConstructorUsedError;
  String get answer_txt => throw _privateConstructorUsedError;
  bool get isError => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $QnAResponseModelCopyWith<QnAResponseModel> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QnAResponseModelCopyWith<$Res> {
  factory $QnAResponseModelCopyWith(QnAResponseModel value, $Res Function(QnAResponseModel) then) = _$QnAResponseModelCopyWithImpl<$Res, QnAResponseModel>;
  @useResult
  $Res call({String message, String answer_txt, bool isError});
}

/// @nodoc
class _$QnAResponseModelCopyWithImpl<$Res, $Val extends QnAResponseModel> implements $QnAResponseModelCopyWith<$Res> {
  _$QnAResponseModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
    Object? answer_txt = null,
    Object? isError = null,
  }) {
    return _then(_value.copyWith(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      answer_txt: null == answer_txt
          ? _value.answer_txt
          : answer_txt // ignore: cast_nullable_to_non_nullable
              as String,
      isError: null == isError
          ? _value.isError
          : isError // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$QnAResponseModelImplCopyWith<$Res> implements $QnAResponseModelCopyWith<$Res> {
  factory _$$QnAResponseModelImplCopyWith(_$QnAResponseModelImpl value, $Res Function(_$QnAResponseModelImpl) then) = __$$QnAResponseModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String message, String answer_txt, bool isError});
}

/// @nodoc
class __$$QnAResponseModelImplCopyWithImpl<$Res> extends _$QnAResponseModelCopyWithImpl<$Res, _$QnAResponseModelImpl> implements _$$QnAResponseModelImplCopyWith<$Res> {
  __$$QnAResponseModelImplCopyWithImpl(_$QnAResponseModelImpl _value, $Res Function(_$QnAResponseModelImpl) _then) : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
    Object? answer_txt = null,
    Object? isError = null,
  }) {
    return _then(_$QnAResponseModelImpl(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      answer_txt: null == answer_txt
          ? _value.answer_txt
          : answer_txt // ignore: cast_nullable_to_non_nullable
              as String,
      isError: null == isError
          ? _value.isError
          : isError // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$QnAResponseModelImpl implements _QnAResponseModel {
  const _$QnAResponseModelImpl({required this.message, required this.answer_txt, this.isError = false});

  factory _$QnAResponseModelImpl.fromJson(Map<String, dynamic> json) => _$$QnAResponseModelImplFromJson(json);

  @override
  final String message;
  @override
  final String answer_txt;
  @override
  @JsonKey()
  final bool isError;

  @override
  String toString() {
    return 'QnAResponseModel(message: $message, answer_txt: $answer_txt, isError: $isError)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QnAResponseModelImpl &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.answer_txt, answer_txt) || other.answer_txt == answer_txt) &&
            (identical(other.isError, isError) || other.isError == isError));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, message, answer_txt, isError);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$QnAResponseModelImplCopyWith<_$QnAResponseModelImpl> get copyWith => __$$QnAResponseModelImplCopyWithImpl<_$QnAResponseModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$QnAResponseModelImplToJson(
      this,
    );
  }
}

abstract class _QnAResponseModel implements QnAResponseModel {
  const factory _QnAResponseModel({required final String message, required final String answer_txt, final bool isError}) = _$QnAResponseModelImpl;

  factory _QnAResponseModel.fromJson(Map<String, dynamic> json) = _$QnAResponseModelImpl.fromJson;

  @override
  String get message;
  @override
  String get answer_txt;
  @override
  bool get isError;
  @override
  @JsonKey(ignore: true)
  _$$QnAResponseModelImplCopyWith<_$QnAResponseModelImpl> get copyWith => throw _privateConstructorUsedError;
}

HistoryModel _$HistoryModelFromJson(Map<String, dynamic> json) {
  return _HistoryModel.fromJson(json);
}

/// @nodoc
mixin _$HistoryModel {
  String get timestamp => throw _privateConstructorUsedError;
  String get category => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $HistoryModelCopyWith<HistoryModel> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HistoryModelCopyWith<$Res> {
  factory $HistoryModelCopyWith(HistoryModel value, $Res Function(HistoryModel) then) = _$HistoryModelCopyWithImpl<$Res, HistoryModel>;
  @useResult
  $Res call({String timestamp, String category, String content});
}

/// @nodoc
class _$HistoryModelCopyWithImpl<$Res, $Val extends HistoryModel> implements $HistoryModelCopyWith<$Res> {
  _$HistoryModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? timestamp = null,
    Object? category = null,
    Object? content = null,
  }) {
    return _then(_value.copyWith(
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$HistoryModelImplCopyWith<$Res> implements $HistoryModelCopyWith<$Res> {
  factory _$$HistoryModelImplCopyWith(_$HistoryModelImpl value, $Res Function(_$HistoryModelImpl) then) = __$$HistoryModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String timestamp, String category, String content});
}

/// @nodoc
class __$$HistoryModelImplCopyWithImpl<$Res> extends _$HistoryModelCopyWithImpl<$Res, _$HistoryModelImpl> implements _$$HistoryModelImplCopyWith<$Res> {
  __$$HistoryModelImplCopyWithImpl(_$HistoryModelImpl _value, $Res Function(_$HistoryModelImpl) _then) : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? timestamp = null,
    Object? category = null,
    Object? content = null,
  }) {
    return _then(_$HistoryModelImpl(
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$HistoryModelImpl implements _HistoryModel {
  const _$HistoryModelImpl({required this.timestamp, required this.category, required this.content});

  factory _$HistoryModelImpl.fromJson(Map<String, dynamic> json) => _$$HistoryModelImplFromJson(json);

  @override
  final String timestamp;
  @override
  final String category;
  @override
  final String content;

  @override
  String toString() {
    return 'HistoryModel(timestamp: $timestamp, category: $category, content: $content)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HistoryModelImpl &&
            (identical(other.timestamp, timestamp) || other.timestamp == timestamp) &&
            (identical(other.category, category) || other.category == category) &&
            (identical(other.content, content) || other.content == content));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, timestamp, category, content);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$HistoryModelImplCopyWith<_$HistoryModelImpl> get copyWith => __$$HistoryModelImplCopyWithImpl<_$HistoryModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$HistoryModelImplToJson(
      this,
    );
  }
}

abstract class _HistoryModel implements HistoryModel {
  const factory _HistoryModel({required final String timestamp, required final String category, required final String content}) = _$HistoryModelImpl;

  factory _HistoryModel.fromJson(Map<String, dynamic> json) = _$HistoryModelImpl.fromJson;

  @override
  String get timestamp;
  @override
  String get category;
  @override
  String get content;
  @override
  @JsonKey(ignore: true)
  _$$HistoryModelImplCopyWith<_$HistoryModelImpl> get copyWith => throw _privateConstructorUsedError;
}
