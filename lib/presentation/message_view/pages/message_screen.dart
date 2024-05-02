import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../../core/reusable_widgets/reusable_textfield.dart';
import '../../login_view/bloc/login_bloc/login_bloc.dart';
import '../../login_view/pages/login_page.dart';
import '../bloc/messages_cubit/messages_cubit.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen({super.key});

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  final TextEditingController controller = TextEditingController();
  final Uri wsUrl = Uri.parse('wss://echo.websocket.org/');
  late final WebSocketChannel channel;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      // Load messages after the widget is fully built
      context.read<MessagesCubit>().loadMessages();

      initSocket();
    });
  }

  Future<void> initSocket() async {
    try {
      channel = WebSocketChannel.connect(wsUrl);
      channel.stream.listen((message) {
        context.read<MessagesCubit>().addNewMessage(message);
      });
    } catch (e) {
      // Handle WebSocket connection errors
      print('WebSocket connection error: $e');
    }
  }

  void sendMessage() {
    if (controller.text.isNotEmpty) {
      channel.sink.add(controller.text);

      controller.text = '';
    }
  }

  @override
  void dispose() {
    channel.sink.close();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state.status == LoginStatus.unauthenticated) {
          Navigator.of(context)
              .pushReplacement(MaterialPageRoute(builder: (context) {
            return const LoginPage();
          }));
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: const Color(0xFFF4F2FE),
        appBar: AppBar(
          backgroundColor: const Color(0XffD1CBF9),
          centerTitle: true,
          title: const Text('Messaging'),
          actions: [
            IconButton(
                onPressed: () {
                  context.read<LoginBloc>().add(const LogOut());
                },
                icon: Icon(Icons.logout))
          ],
        ),
        bottomSheet: Row(
          children: [
            Expanded(
              child: ReusableTextField(
                controller: controller,
                hintText: 'Type here...',
              ),
            ),
            const SizedBox(width: 15),
            Padding(
              padding: const EdgeInsets.only(right: 5),
              child: FloatingActionButton(
                onPressed: sendMessage,
                tooltip: 'Send message',
                child: const Icon(Icons.send),
              ),
            )
          ],
        ),
        body: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: getMessageList()),
                const SizedBox(height: 75),
              ],
            )),
      ),
    );
  }

  BlocBuilder getMessageList() {
    return BlocBuilder<MessagesCubit, MessagesState>(
      builder: (context, state) {
        if (state.status == MessagesStatus.initial) {
          return const Text('Initial');
        } else if (state.status == MessagesStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state.status == MessagesStatus.error) {
          return const Text('Something went wrong!');
        }

        return ListView.builder(
            itemCount: state.message?.messageCount ?? 0,
            reverse: true,
            itemBuilder: (context, index) {
              int idx = state.message!.messageCount - index - 1;
              return buildMessage(state.message!.message[idx]);
            });
      },
    );
  }

  Container buildMessage(String message) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: double.maxFinite,
            padding: const EdgeInsets.all(8),
            decoration: const ShapeDecoration(
              color: Color(0xFFE9E9E9),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
            ),
            child: Text(
              message,
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF212121)),
            ),
          ),
        ],
      ),
    );
  }
}
