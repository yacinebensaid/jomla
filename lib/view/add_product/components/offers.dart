import 'package:flutter/material.dart';

class MultiSelectOffers extends StatefulWidget {
  final List<String> items;
  const MultiSelectOffers({Key? key, required this.items}) : super(key: key);

  @override
  State<MultiSelectOffers> createState() => _MultiSelectCategiryState();
}

class _MultiSelectCategiryState extends State<MultiSelectOffers> {
  final List<String> _selectedOffers = [];

// This function is triggered when a checkbox is checked or unchecked
  void _itemChange(String itemValue, bool isSelected) {
    setState(() {
      if (isSelected) {
        _selectedOffers.add(itemValue);
      } else {
        _selectedOffers.remove(itemValue);
      }
    });
  }

  // this function is called when the Cancel button is pressed
  void _cancel() {
    Navigator.pop(context);
  }

// this function is called when the Submit button is tapped

////////////////////////////////////////////add the selected sizes to the
  void _submit() {
    Navigator.pop(context, _selectedOffers);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select The Sub categories Category'),
      content: SingleChildScrollView(
        child: ListBody(
          children: widget.items
              .map((offer) => CheckboxListTile(
                    value: _selectedOffers.contains(offer),
                    title: Text(offer),
                    controlAffinity: ListTileControlAffinity.leading,
                    onChanged: (isChecked) => _itemChange(offer, isChecked!),
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
