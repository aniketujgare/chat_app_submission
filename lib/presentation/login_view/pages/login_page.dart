import '../../../core/reusable_widgets/reusable_button.dart';
import '../../../core/reusable_widgets/reusable_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../message_view/pages/message_screen.dart';
import '../bloc/login_bloc/login_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<LoginBloc, LoginState>(
        listener: (context, state) {
          print(state.status.name);
          if (state.status == LoginStatus.success) {
            Navigator.of(context)
                .pushReplacement(MaterialPageRoute(builder: (context) {
              return MessageScreen();
            }));
          }
          if (state.status == LoginStatus.error) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.errorMessage)));
          }
        },
        builder: (context, state) {
          if (state.status == LoginStatus.loading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Login',
                style: TextStyle(fontSize: 33),
              ),
              SizedBox(height: 35),
              ReusableTextField(
                controller: emailController,
                hintText: 'Enter emaili',
              ),
              ReusableTextField(
                controller: passwordController,
                hintText: 'Enter password',
              ),
              SizedBox(height: 15),
              ReusableButton(
                buttonColor: Colors.green,
                text: 'login',
                textColor: Colors.black,
                onPressed: () {
                  if (emailController.text.isNotEmpty &&
                      passwordController.text.isNotEmpty) {
                    print('login');
                    context.read<LoginBloc>().add(EmailSignIn(
                        email: emailController.text.trim(),
                        password: passwordController.text));
                  } else {
                    print(
                        'empty:${emailController.text}||${passwordController.text}');
                  }
                },
              )
            ],
          );
        },
      ),
    );
  }
}
