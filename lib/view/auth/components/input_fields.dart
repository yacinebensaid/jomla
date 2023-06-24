import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputFieldArea extends StatelessWidget {
  final String hint;
  final TextEditingController controler;
  final bool obscure;
  final IconData? icon;
  final int? maxlines;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormat;
  const InputFieldArea(
      {super.key,
      required this.keyboardType,
      required this.controler,
      required this.hint,
      required this.maxlines,
      required this.obscure,
      required this.inputFormat,
      required this.icon});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 0.5,
            color: Colors.white24,
          ),
        ),
      ),
      child: TextFormField(
        controller: controler,
        obscureText: obscure,
        keyboardType: keyboardType,
        maxLines: maxlines,
        autocorrect: false,
        inputFormatters: inputFormat,
        style: const TextStyle(
          color: Colors.black,
        ),
        decoration: InputDecoration(
          icon: Icon(
            icon,
            color: Colors.black,
          ),
          border: InputBorder.none,
          labelText: hint,
          hintStyle: const TextStyle(color: Colors.black, fontSize: 15.0),
          contentPadding: const EdgeInsets.only(
              top: 30.0, right: 30.0, bottom: 30.0, left: 5.0),
        ),
      ),
    );
  }
}
