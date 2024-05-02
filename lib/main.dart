import 'models/message_model.dart';
import 'models/user_model.dart';
import 'presentation/login_view/pages/login_page.dart';
import 'helper/user_operations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'firebase_options.dart';
import 'presentation/message_view/bloc/messages_cubit/messages_cubit.dart';
import 'presentation/message_view/pages/message_screen.dart';
import 'presentation/login_view/bloc/login_bloc/login_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Hive.initFlutter();

  // Registering the adapter
  Hive.registerAdapter(MessageModelAdapter());
  Hive.registerAdapter(UserModelAdapter());
  // open box
  await Hive.openBox<MessageModel>('messages');
  await Hive.openBox<UserModel>('user');

  UserModel? user = UserOperations().getUser();

  runApp(MyApp(user: user));
}

class MyApp extends StatelessWidget {
  final UserModel? user;
  const MyApp({super.key, this.user});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => MessagesCubit(),
        ),
        BlocProvider(
          create: (context) => LoginBloc(),
        ),
      ],
      child: MaterialApp(
          title: 'Chat App Submission',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: (user == null) ? const LoginPage() : const MessageScreen()),
    );
  }
}
