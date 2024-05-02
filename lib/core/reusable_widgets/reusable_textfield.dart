import 'package:flutter/material.dart';

class ReusableTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  const ReusableTextField({
    super.key,
    this.hintText = '',
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.shortestSide <= 600;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      height: isMobile ? 75 : 65,
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: controller,
              textAlignVertical: TextAlignVertical.center,
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle:
                    const TextStyle(color: Color.fromARGB(255, 171, 171, 171)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(color: Colors.purple)),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(color: Colors.purple)),
                contentPadding: EdgeInsets.only(
                    left: 15,
                    top: isMobile ? 15 : 5,
                    bottom: isMobile ? 15 : 5),
                filled: true,
                fillColor: Colors.white,
              ),
              style: const TextStyle(color: Colors.black),
            ),
          ),
          // SizedBox(width: 15),
          // FloatingActionButton(
          //   onPressed: messageSendButton,
          //   tooltip: 'Send message',
          //   child: const Icon(Icons.send),
          // )
        ],
      ),
    );
  }
}
