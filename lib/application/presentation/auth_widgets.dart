import 'package:flutter/material.dart';

import '../../constants/my_colors.dart';

class TextFormFieldWidget extends StatelessWidget {
  final TextEditingController? controller;
  final TextInputAction inputAction;
  final String? label;
  final bool obscure;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;

  const TextFormFieldWidget(
      {super.key,
      this.keyboardType,
      this.validator,
      this.controller,
      this.label,
      this.obscure = false,
      this.inputAction = TextInputAction.next});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: keyboardType,
      controller: controller,
      cursorHeight: 24,
      cursorColor: MyColors.colorFFFFFF,
      textInputAction: inputAction,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(color: MyColors.colorFB65BA),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(width: 1.5, color: MyColors.color9B9A9B),
        ),
      ),
      obscureText: obscure,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: validator,
    );
  }
}

class AuthButtonWidget extends StatelessWidget {
  final Color? backgroundColor;
  final VoidCallback? onPressed;
  final String label;
  const AuthButtonWidget({super.key, required this.label, this.onPressed, this.backgroundColor = MyColors.color772DFF});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor, padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 60)),
        onPressed: onPressed,
        child: Text(
          label,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
    );
  }
}
