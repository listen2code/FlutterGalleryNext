// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'login_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$LoginActions {
  BaseRequest? get request => throw _privateConstructorUsedError;
}

/// @nodoc

class _$DoLoginImpl implements DoLogin {
  const _$DoLoginImpl({this.request});

  @override
  final LoginRequest? request;

  @override
  String toString() {
    return 'LoginActions.doLogin(request: $request)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DoLoginImpl &&
            (identical(other.request, request) || other.request == request));
  }

  @override
  int get hashCode => Object.hash(runtimeType, request);
}

abstract class DoLogin implements LoginActions {
  const factory DoLogin({final LoginRequest? request}) = _$DoLoginImpl;

  @override
  LoginRequest? get request;
}

/// @nodoc

class _$DoLogoutImpl implements DoLogout {
  const _$DoLogoutImpl({this.request});

  @override
  final LogoutRequest? request;

  @override
  String toString() {
    return 'LoginActions.doLogout(request: $request)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DoLogoutImpl &&
            (identical(other.request, request) || other.request == request));
  }

  @override
  int get hashCode => Object.hash(runtimeType, request);
}

abstract class DoLogout implements LoginActions {
  const factory DoLogout({final LogoutRequest? request}) = _$DoLogoutImpl;

  @override
  LogoutRequest? get request;
}
