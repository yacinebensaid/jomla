import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFields extends StatelessWidget {
  final String labelText;
  final String? errorText;
  final void Function(String?)? onSaved;
  final TextInputType keyboardType;
  final int? maxLines;
  final List<TextInputFormatter>? inputFormat;

  const TextFields({
    Key? key,
    required this.labelText,
    this.errorText,
    this.onSaved,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
    this.inputFormat,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        hintText: labelText,
        contentPadding: EdgeInsets.symmetric(vertical: 3.0, horizontal: 4.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Colors.grey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Colors.grey),
        ),
      ),
      inputFormatters: inputFormat,
      validator: (value) {
        if (value!.isEmpty) {
          return errorText;
        }
        return null;
      },
      onSaved: onSaved,
      keyboardType: keyboardType,
      maxLines: maxLines,
    );
  }
}
