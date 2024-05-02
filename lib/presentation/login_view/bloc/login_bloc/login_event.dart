part of 'login_bloc.dart';

@freezed
class LoginEvent with _$LoginEvent {
  const factory LoginEvent.emailSignIn({
    @Default("") String email,
    @Default("") String password,
  }) = EmailSignIn;
  const factory LoginEvent.error({@Default('') String errorMessage}) =
      LoginError;
  const factory LoginEvent.logout() = LogOut;
}
