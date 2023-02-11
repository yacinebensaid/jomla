import 'package:flutter/material.dart';

class MainCategorySelect extends StatefulWidget {
  final List<String> items;
  const MainCategorySelect({Key? key, required this.items}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MainCategorySelecttState();
}

class _MainCategorySelecttState extends State<MainCategorySelect> {
  // this variable holds the selected items
  late String _selectedCategory = '';

// This function is triggered when a checkbox is checked or unchecked
  void _itemChange(String itemValue) {
    setState(() {
      _selectedCategory = itemValue;
    });
  }

  // this function is called when the Cancel button is pressed
  void _cancel() {
    Navigator.pop(context);
  }

// this function is called when the Submit button is tapped

////////////////////////////////////////////add the selected sizes to the
  void _submit() {
    Navigator.pop(context, _selectedCategory);
  }

// this function is called when the Submit button is tapped

////////////////////////////////////////////add the selected sizes to the
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select The main Category'),
      content: SingleChildScrollView(
        child: ListBody(
          children: widget.items
              .map((category) => RadioListTile(
                    value: category,
                    groupValue: _selectedCategory,
                    title: Text(category),
                    onChanged: (isSelected) => _itemChange(category),
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
