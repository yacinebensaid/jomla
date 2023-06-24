import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputFieldArea extends StatelessWidget {
  final String hint;
  final TextEditingController controler;
  final IconData? icon;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormat;
  int? maxlines = 1;
  InputFieldArea(
      {super.key,
      required this.keyboardType,
      required this.controler,
      required this.hint,
      required this.inputFormat,
      required this.icon,
      this.maxlines});
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
        keyboardType: keyboardType,
        autocorrect: false,
        maxLines: maxlines,
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
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.black, fontSize: 15.0),
          contentPadding: const EdgeInsets.only(
              top: 30.0, right: 30.0, bottom: 30.0, left: 5.0),
        ),
      ),
    );
  }
}
