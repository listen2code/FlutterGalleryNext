// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_info_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$UserInfoActions {
  BaseRequest? get request => throw _privateConstructorUsedError;
}

/// @nodoc

class _$GetUserListImpl implements GetUserList {
  const _$GetUserListImpl({this.request});

  @override
  final UserListRequest? request;

  @override
  String toString() {
    return 'UserInfoActions.getUserList(request: $request)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GetUserListImpl &&
            (identical(other.request, request) || other.request == request));
  }

  @override
  int get hashCode => Object.hash(runtimeType, request);
}

abstract class GetUserList implements UserInfoActions {
  const factory GetUserList({final UserListRequest? request}) =
      _$GetUserListImpl;

  @override
  UserListRequest? get request;
}

/// @nodoc

class _$UpdateUserImpl implements UpdateUser {
  const _$UpdateUserImpl({this.request});

  @override
  final UserUpdateRequest? request;

  @override
  String toString() {
    return 'UserInfoActions.updateUser(request: $request)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpdateUserImpl &&
            (identical(other.request, request) || other.request == request));
  }

  @override
  int get hashCode => Object.hash(runtimeType, request);
}

abstract class UpdateUser implements UserInfoActions {
  const factory UpdateUser({final UserUpdateRequest? request}) =
      _$UpdateUserImpl;

  @override
  UserUpdateRequest? get request;
}

/// @nodoc

class _$DeleteUserImpl implements DeleteUser {
  const _$DeleteUserImpl({this.request});

  @override
  final UserDeleteRequest? request;

  @override
  String toString() {
    return 'UserInfoActions.deleteUser(request: $request)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DeleteUserImpl &&
            (identical(other.request, request) || other.request == request));
  }

  @override
  int get hashCode => Object.hash(runtimeType, request);
}

abstract class DeleteUser implements UserInfoActions {
  const factory DeleteUser({final UserDeleteRequest? request}) =
      _$DeleteUserImpl;

  @override
  UserDeleteRequest? get request;
}
