import 'package:flutter/material.dart';
import 'package:job_me/_shared/widgets/primary_edit_text.dart';

class PasswordEditText extends StatefulWidget {
  final TextEditingController passwordController;
  final String hint;
  final String? Function(String?)? validator;

  const PasswordEditText({Key? key, required this.passwordController, required this.hint, this.validator}) : super(key: key);

  @override
  State<PasswordEditText> createState() => _PasswordEditTextState();
}

class _PasswordEditTextState extends State<PasswordEditText> {
  bool isSecure = true;

  @override
  Widget build(BuildContext context) {
    return PrimaryEditText(
      validator: widget.validator,
      obscureText: isSecure,
      controller: widget.passwordController,
      hint: widget.hint,
      suffixIcon: GestureDetector(
          onTap: () {
            setState(() {
              isSecure = !isSecure;
            });
          },
          child: Icon(isSecure ? Icons.remove_red_eye : Icons.remove_red_eye_outlined)),
    );
  }
}
