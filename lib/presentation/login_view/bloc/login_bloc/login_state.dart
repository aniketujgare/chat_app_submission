part of 'login_bloc.dart';

enum LoginStatus { unauthenticated, loading, error, wrongCredentials, success }

@freezed
class LoginState with _$LoginState {
  const factory LoginState({
    @Default(LoginStatus.unauthenticated) LoginStatus status,
    @Default("") String email,
    @Default("") String password,
    @Default("") String errorMessage,
  }) = Initial;
}
