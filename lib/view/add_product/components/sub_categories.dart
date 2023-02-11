import 'package:flutter/material.dart';

class MultiSelectCategory extends StatefulWidget {
  final List<String> items;
  const MultiSelectCategory({Key? key, required this.items}) : super(key: key);

  @override
  State<MultiSelectCategory> createState() => _MultiSelectCategiryState();
}

class _MultiSelectCategiryState extends State<MultiSelectCategory> {
  String _selectedSubCategory = '';

  // This function is triggered when a radiobox is selected
  void _itemChange(String itemValue) {
    setState(() {
      _selectedSubCategory = itemValue;
    });
  }

  // this function is called when the Cancel button is pressed
  void _cancel() {
    Navigator.pop(context);
  }

  // this function is called when the Submit button is tapped
  void _submit() {
    Navigator.pop(context, _selectedSubCategory);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select The Sub categories Category'),
      content: SingleChildScrollView(
        child: ListBody(
          children: widget.items
              .map((category) => RadioListTile(
                    value: category,
                    groupValue: _selectedSubCategory,
                    title: Text(category),
                    controlAffinity: ListTileControlAffinity.leading,
                    onChanged: (value) => _itemChange(value!),
                  ))
              .toList(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _cancel,
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _submit,
          child: const Text('Submit'),
        ),
      ],
    );
  }
}
