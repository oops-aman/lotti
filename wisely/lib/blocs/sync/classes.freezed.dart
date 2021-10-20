// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'classes.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

ImapConfig _$ImapConfigFromJson(Map<String, dynamic> json) {
  return _ImapConfig.fromJson(json);
}

/// @nodoc
class _$ImapConfigTearOff {
  const _$ImapConfigTearOff();

  _ImapConfig call(
      {required String host,
      required String userName,
      required String password,
      required int port}) {
    return _ImapConfig(
      host: host,
      userName: userName,
      password: password,
      port: port,
    );
  }

  ImapConfig fromJson(Map<String, Object?> json) {
    return ImapConfig.fromJson(json);
  }
}

/// @nodoc
const $ImapConfig = _$ImapConfigTearOff();

/// @nodoc
mixin _$ImapConfig {
  String get host => throw _privateConstructorUsedError;
  String get userName => throw _privateConstructorUsedError;
  String get password => throw _privateConstructorUsedError;
  int get port => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ImapConfigCopyWith<ImapConfig> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ImapConfigCopyWith<$Res> {
  factory $ImapConfigCopyWith(
          ImapConfig value, $Res Function(ImapConfig) then) =
      _$ImapConfigCopyWithImpl<$Res>;
  $Res call({String host, String userName, String password, int port});
}

/// @nodoc
class _$ImapConfigCopyWithImpl<$Res> implements $ImapConfigCopyWith<$Res> {
  _$ImapConfigCopyWithImpl(this._value, this._then);

  final ImapConfig _value;
  // ignore: unused_field
  final $Res Function(ImapConfig) _then;

  @override
  $Res call({
    Object? host = freezed,
    Object? userName = freezed,
    Object? password = freezed,
    Object? port = freezed,
  }) {
    return _then(_value.copyWith(
      host: host == freezed
          ? _value.host
          : host // ignore: cast_nullable_to_non_nullable
              as String,
      userName: userName == freezed
          ? _value.userName
          : userName // ignore: cast_nullable_to_non_nullable
              as String,
      password: password == freezed
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String,
      port: port == freezed
          ? _value.port
          : port // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
abstract class _$ImapConfigCopyWith<$Res> implements $ImapConfigCopyWith<$Res> {
  factory _$ImapConfigCopyWith(
          _ImapConfig value, $Res Function(_ImapConfig) then) =
      __$ImapConfigCopyWithImpl<$Res>;
  @override
  $Res call({String host, String userName, String password, int port});
}

/// @nodoc
class __$ImapConfigCopyWithImpl<$Res> extends _$ImapConfigCopyWithImpl<$Res>
    implements _$ImapConfigCopyWith<$Res> {
  __$ImapConfigCopyWithImpl(
      _ImapConfig _value, $Res Function(_ImapConfig) _then)
      : super(_value, (v) => _then(v as _ImapConfig));

  @override
  _ImapConfig get _value => super._value as _ImapConfig;

  @override
  $Res call({
    Object? host = freezed,
    Object? userName = freezed,
    Object? password = freezed,
    Object? port = freezed,
  }) {
    return _then(_ImapConfig(
      host: host == freezed
          ? _value.host
          : host // ignore: cast_nullable_to_non_nullable
              as String,
      userName: userName == freezed
          ? _value.userName
          : userName // ignore: cast_nullable_to_non_nullable
              as String,
      password: password == freezed
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String,
      port: port == freezed
          ? _value.port
          : port // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_ImapConfig implements _ImapConfig {
  _$_ImapConfig(
      {required this.host,
      required this.userName,
      required this.password,
      required this.port});

  factory _$_ImapConfig.fromJson(Map<String, dynamic> json) =>
      _$$_ImapConfigFromJson(json);

  @override
  final String host;
  @override
  final String userName;
  @override
  final String password;
  @override
  final int port;

  @override
  String toString() {
    return 'ImapConfig(host: $host, userName: $userName, password: $password, port: $port)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ImapConfig &&
            (identical(other.host, host) || other.host == host) &&
            (identical(other.userName, userName) ||
                other.userName == userName) &&
            (identical(other.password, password) ||
                other.password == password) &&
            (identical(other.port, port) || other.port == port));
  }

  @override
  int get hashCode => Object.hash(runtimeType, host, userName, password, port);

  @JsonKey(ignore: true)
  @override
  _$ImapConfigCopyWith<_ImapConfig> get copyWith =>
      __$ImapConfigCopyWithImpl<_ImapConfig>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_ImapConfigToJson(this);
  }
}

abstract class _ImapConfig implements ImapConfig {
  factory _ImapConfig(
      {required String host,
      required String userName,
      required String password,
      required int port}) = _$_ImapConfig;

  factory _ImapConfig.fromJson(Map<String, dynamic> json) =
      _$_ImapConfig.fromJson;

  @override
  String get host;
  @override
  String get userName;
  @override
  String get password;
  @override
  int get port;
  @override
  @JsonKey(ignore: true)
  _$ImapConfigCopyWith<_ImapConfig> get copyWith =>
      throw _privateConstructorUsedError;
}

SyncConfig _$SyncConfigFromJson(Map<String, dynamic> json) {
  return _SyncConfig.fromJson(json);
}

/// @nodoc
class _$SyncConfigTearOff {
  const _$SyncConfigTearOff();

  _SyncConfig call(
      {required ImapConfig imapConfig, required String sharedSecret}) {
    return _SyncConfig(
      imapConfig: imapConfig,
      sharedSecret: sharedSecret,
    );
  }

  SyncConfig fromJson(Map<String, Object?> json) {
    return SyncConfig.fromJson(json);
  }
}

/// @nodoc
const $SyncConfig = _$SyncConfigTearOff();

/// @nodoc
mixin _$SyncConfig {
  ImapConfig get imapConfig => throw _privateConstructorUsedError;
  String get sharedSecret => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SyncConfigCopyWith<SyncConfig> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SyncConfigCopyWith<$Res> {
  factory $SyncConfigCopyWith(
          SyncConfig value, $Res Function(SyncConfig) then) =
      _$SyncConfigCopyWithImpl<$Res>;
  $Res call({ImapConfig imapConfig, String sharedSecret});

  $ImapConfigCopyWith<$Res> get imapConfig;
}

/// @nodoc
class _$SyncConfigCopyWithImpl<$Res> implements $SyncConfigCopyWith<$Res> {
  _$SyncConfigCopyWithImpl(this._value, this._then);

  final SyncConfig _value;
  // ignore: unused_field
  final $Res Function(SyncConfig) _then;

  @override
  $Res call({
    Object? imapConfig = freezed,
    Object? sharedSecret = freezed,
  }) {
    return _then(_value.copyWith(
      imapConfig: imapConfig == freezed
          ? _value.imapConfig
          : imapConfig // ignore: cast_nullable_to_non_nullable
              as ImapConfig,
      sharedSecret: sharedSecret == freezed
          ? _value.sharedSecret
          : sharedSecret // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }

  @override
  $ImapConfigCopyWith<$Res> get imapConfig {
    return $ImapConfigCopyWith<$Res>(_value.imapConfig, (value) {
      return _then(_value.copyWith(imapConfig: value));
    });
  }
}

/// @nodoc
abstract class _$SyncConfigCopyWith<$Res> implements $SyncConfigCopyWith<$Res> {
  factory _$SyncConfigCopyWith(
          _SyncConfig value, $Res Function(_SyncConfig) then) =
      __$SyncConfigCopyWithImpl<$Res>;
  @override
  $Res call({ImapConfig imapConfig, String sharedSecret});

  @override
  $ImapConfigCopyWith<$Res> get imapConfig;
}

/// @nodoc
class __$SyncConfigCopyWithImpl<$Res> extends _$SyncConfigCopyWithImpl<$Res>
    implements _$SyncConfigCopyWith<$Res> {
  __$SyncConfigCopyWithImpl(
      _SyncConfig _value, $Res Function(_SyncConfig) _then)
      : super(_value, (v) => _then(v as _SyncConfig));

  @override
  _SyncConfig get _value => super._value as _SyncConfig;

  @override
  $Res call({
    Object? imapConfig = freezed,
    Object? sharedSecret = freezed,
  }) {
    return _then(_SyncConfig(
      imapConfig: imapConfig == freezed
          ? _value.imapConfig
          : imapConfig // ignore: cast_nullable_to_non_nullable
              as ImapConfig,
      sharedSecret: sharedSecret == freezed
          ? _value.sharedSecret
          : sharedSecret // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_SyncConfig implements _SyncConfig {
  _$_SyncConfig({required this.imapConfig, required this.sharedSecret});

  factory _$_SyncConfig.fromJson(Map<String, dynamic> json) =>
      _$$_SyncConfigFromJson(json);

  @override
  final ImapConfig imapConfig;
  @override
  final String sharedSecret;

  @override
  String toString() {
    return 'SyncConfig(imapConfig: $imapConfig, sharedSecret: $sharedSecret)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _SyncConfig &&
            (identical(other.imapConfig, imapConfig) ||
                other.imapConfig == imapConfig) &&
            (identical(other.sharedSecret, sharedSecret) ||
                other.sharedSecret == sharedSecret));
  }

  @override
  int get hashCode => Object.hash(runtimeType, imapConfig, sharedSecret);

  @JsonKey(ignore: true)
  @override
  _$SyncConfigCopyWith<_SyncConfig> get copyWith =>
      __$SyncConfigCopyWithImpl<_SyncConfig>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_SyncConfigToJson(this);
  }
}

abstract class _SyncConfig implements SyncConfig {
  factory _SyncConfig(
      {required ImapConfig imapConfig,
      required String sharedSecret}) = _$_SyncConfig;

  factory _SyncConfig.fromJson(Map<String, dynamic> json) =
      _$_SyncConfig.fromJson;

  @override
  ImapConfig get imapConfig;
  @override
  String get sharedSecret;
  @override
  @JsonKey(ignore: true)
  _$SyncConfigCopyWith<_SyncConfig> get copyWith =>
      throw _privateConstructorUsedError;
}