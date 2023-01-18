// ignore: avoid_web_libraries_in_flutter
import 'dart:io' show File;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class MultiSelect extends StatefulWidget {
  final List<String> items;
  const MultiSelect({Key? key, required this.items}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MultiSelectState();
}

class _MultiSelectState extends State<MultiSelect> {
  // this variable holds the selected items
  final List<String> _selectedSizes = [];

// This function is triggered when a checkbox is checked or unchecked
  void _itemChange(String itemValue, bool isSelected) {
    setState(() {
      if (isSelected) {
        _selectedSizes.add(itemValue);
      } else {
        _selectedSizes.remove(itemValue);
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
    Navigator.pop(context, _selectedSizes);
  }

// this function is called when the Submit button is tapped

////////////////////////////////////////////add the selected sizes to the

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select sizes'),
      content: SingleChildScrollView(
        child: ListBody(
          children: widget.items
              .map((size) => CheckboxListTile(
                    value: _selectedSizes.contains(size),
                    title: Text(size),
                    controlAffinity: ListTileControlAffinity.leading,
                    onChanged: (isChecked) => _itemChange(size, isChecked!),
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

class AddingProductView extends StatefulWidget {
  const AddingProductView({super.key});

  @override
  State<AddingProductView> createState() => _AddingProductViewState();
}

class _AddingProductViewState extends State<AddingProductView> {
  late final TextEditingController refrence;
  late final TextEditingController productName;
  late final TextEditingController category;
  late final TextEditingController totalQuantity;
  late final TextEditingController minimumQuantity;
  late List<String> _selectedSizes = [];
  late final TextEditingController price;
  late final TextEditingController availableColors;
  late final TextEditingController newPrice;

  late final TextEditingController description;

  final List<XFile> photosList = [];
  File? image;
  void imagepicker() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final imgtemp = File(image.path);
      setState(() => this.image = imgtemp);
      photosList.add(image);
    } on PlatformException {
      return;
    }
  }

  void _showMultiSelect() async {
    // a list of selectable items
    // these items can be hard-coded or dynamically fetched from a database/API
    final List<String> sizes = [
      'xs',
      's',
      'm',
      'l',
      'xl',
      'xxl',
      '3xl',
      '4xl',
      '5xl',
    ];

    final List<String>? results = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return MultiSelect(items: sizes);
      },
    );

    // Update UI
    if (results != null) {
      setState(() {
        _selectedSizes = results;
      });
    }
  }

  @override
  void initState() {
    refrence = TextEditingController();
    productName = TextEditingController();
    category = TextEditingController();
    totalQuantity = TextEditingController();
    minimumQuantity = TextEditingController();
    price = TextEditingController();
    availableColors = TextEditingController();
    newPrice = TextEditingController();
    description = TextEditingController();
    super.initState();
  }

//this part is for the sign in informations when the app is closed
// dispo
  @override
  void dispose() {
    refrence.dispose();
    productName.dispose();
    category.dispose();
    totalQuantity.dispose();
    minimumQuantity.dispose();
    price.dispose();
    availableColors.dispose();
    newPrice.dispose();
    description.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Adding a new product'),
        ),
        body: ListView(
          controller: ScrollController(),
          children: [
            Column(children: [
              TextField(
                controller: refrence,
                decoration: const InputDecoration(
                    hintText: "Enter the product's refrence"),
              ),
              TextField(
                controller: productName,
                decoration:
                    const InputDecoration(hintText: "Enter the product's name"),
              ),
              TextField(
                controller: category,
                decoration: const InputDecoration(
                    hintText: "Enter the product's category"),
              ),
              TextField(
                controller: totalQuantity,
                decoration: const InputDecoration(
                    hintText: "Enter the total quantity available"),
              ),
              TextField(
                controller: minimumQuantity,
                decoration: const InputDecoration(
                    hintText: "Enter the minimum purchased quantity"),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // use this button to open the multi-select dialog
                    ElevatedButton(
                      onPressed: _showMultiSelect,
                      child: const Text('Select available Sizes'),
                    ),
                    const Divider(
                      height: 30,
                    ),
                    // display selected items
                    Wrap(
                      children: _selectedSizes
                          .map((e) => Chip(
                                label: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Text(e),
                                    InkWell(
                                      child: const Icon(Icons.clear),
                                      onTap: () {
                                        setState(() {
                                          _selectedSizes.remove(e);
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ))
                          .toList(),
                    )
                  ],
                ),
              ),
              TextField(
                controller: price,
                decoration: const InputDecoration(
                    hintText: "Enter the product's price"),
              ),
              TextField(
                controller: newPrice,
                decoration: const InputDecoration(
                    hintText: "Enter the product's new price (optional) "),
              ),
              TextField(
                controller: availableColors,
                decoration: const InputDecoration(
                    hintText: "Enter the product's new price (optional) "),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // use this button to open the multi-select dialog
                    ElevatedButton(
                      onPressed: imagepicker,
                      child: const Text('Select pictures'),
                    ),
                    const Divider(
                      height: 30,
                    ),
                    // display selected items
                    Wrap(
                      children: photosList
                          .map((e) => Chip(
                                label: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    const Text('photo added'),
                                    InkWell(
                                      child: const Icon(Icons.clear),
                                      onTap: () {
                                        setState(() {
                                          photosList.remove(e);
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ))
                          .toList(),
                    )
                  ],
                ),
              ),
              TextField(
                controller: description,
                decoration: const InputDecoration(
                    hintText: "Enter the product's description"),
              ),
            ])
          ],
        ));
  }
}
