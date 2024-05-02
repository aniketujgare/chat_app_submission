import 'dart:convert';
import 'dart:math';

import '../../../../models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../helper/user_operations.dart';

part 'login_bloc.freezed.dart';
part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(const LoginState()) {
    on<LoginEvent>((events, emit) async {
      await events.map(
        emailSignIn: (event) async => await _emailAuth(event, emit),
        logout: (event) async => await _logout(event, emit),
        error: (event) async => await _error(event, emit),
      );
    });
  }

  _emailAuth(EmailSignIn event, Emitter<LoginState> emit) async {
    debugPrint('inside pohone no auth ${event.email}');
    try {
      emit(state.copyWith(status: LoginStatus.loading));
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );
      if (credential.user != null) {
        //TODO: save to hive
        UserOperations().createUser(UserModel(
            userId: credential.user!.uid, email: credential.user!.email!));

        emit(state.copyWith(status: LoginStatus.success));
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        //then login
        await signIn(event.email, event.password);
        print('The account already exists for that email.');
      }
    } catch (e) {
      add(const LoginEvent.error(errorMessage: 'something went wrong'));
      print(e);
    }
  }

  Future<void> signIn(String email, String password) async {
    try {
      emit(state.copyWith(status: LoginStatus.success));
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      if (credential.user != null) {
        print(credential.user);
        UserOperations().createUser(UserModel(
            userId: credential.user!.uid, email: credential.user!.email!));
        //TODO: save to hive
        emit(state.copyWith(status: LoginStatus.success));
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        add(const LoginEvent.error(
            errorMessage: 'No user found for that email.'));
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
        add(const LoginEvent.error(
            errorMessage: 'Wrong password provided for that user.'));
      }
    }
  }

  _error(LoginError event, Emitter<LoginState> emit) {
    emit(state.copyWith(
        status: LoginStatus.error, errorMessage: event.errorMessage));
  }

  _logout(LogOut event, Emitter<LoginState> emit) async {
    emit(state.copyWith(status: LoginStatus.loading));

    await FirebaseAuth.instance.signOut();
    UserOperations().deleteUser();
    emit(state.copyWith(status: LoginStatus.unauthenticated));
  }
}
// twilio WRBBBFHUGALB7TTLQN39E2QC

