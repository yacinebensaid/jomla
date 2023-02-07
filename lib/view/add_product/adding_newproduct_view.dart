import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:jomla/services/crud/crud_exceptions.dart';
import 'package:jomla/services/crud/product_service.dart';

import '../../utilities/show_error_dialog.dart';

class MultiSelect extends StatefulWidget {
  final List<String> items;
  const MultiSelect({Key? key, required this.items}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MultiSelectState();
}

class _MultiSelectState extends State<MultiSelect> {
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

class AddProductPage extends StatefulWidget {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  AddProductPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _AddProductPageState createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _formKey = GlobalKey<FormState>();

  final _productNameController = TextEditingController();
  final _productRefrenceController = TextEditingController();
  final _availableQuantityController = TextEditingController();
  final _minQuantityController = TextEditingController();
  final _productPriceController = TextEditingController();
  final _productDescriptionController = TextEditingController();

  String _productName = '';
  String _productRefrence = '';
  String _availableQuantity = '';
  String _minQuantity = '';
  String _productPrice = '';
  String _productDescription = '';
  late String _mainCategory = '';
  final List<String> _availableColors = [];
  final List<String> _category = [];
  final List<String> _availableSizes = [];

  List<bool> _colorsChecked = [];
  List<bool> _checkedCategory = [];
  List<bool> _sizesChecked = [];

  final String _colorOption = 'red,blue,green,yellow,black,white';
  final String _categoryOption =
      'phones,tablets,computers,t-shirts,hoodies,shoes';
  final String _sizeOption = 'XS,S,M,L,XL,XXL';

  final ScrollController _scrollController = ScrollController();

  final List _productImages = [];
  File? image;
  Future pickImage() async {
    try {
      final XFile? image =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      setState(() => _productImages.add(image.path));
    } on PlatformException catch (e) {
      // ignore: avoid_print
      print('faild to upload photo:$e');
    }
  }

  @override
  void initState() {
    super.initState();
    _colorsChecked =
        List.generate(_colorOption.split(',').length, (_) => false);
    _checkedCategory =
        List.generate(_categoryOption.split(',').length, (_) => false);
    _sizesChecked = List.generate(_sizeOption.split(',').length, (_) => false);
  }

  void _showMainCategory() async {
    // a list of selectable items
    // these items can be hard-coded or dynamically fetched from a database/API
    final List<String> categories = _categoryOption.split(',');

    final String results = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return MultiSelect(items: categories);
      },
    );

    // Update UI
    setState(() {
      _mainCategory = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text('Add Product'),
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            controller: _scrollController,
            child: Column(children: [
              TextFormField(
                controller: _productRefrenceController,
                decoration:
                    const InputDecoration(labelText: 'Product Refrence'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a product refrence';
                  }
                  return null;
                },
                onSaved: (value) => _productRefrence = value!,
              ),
              TextFormField(
                controller: _productNameController,
                decoration: const InputDecoration(labelText: 'Product Name'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a product name';
                  }
                  return null;
                },
                onSaved: (value) => _productName = value!,
              ),
              TextFormField(
                controller: _availableQuantityController,
                decoration:
                    const InputDecoration(labelText: 'Product Total Quantity'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter the total quality';
                  }
                  return null;
                },
                onSaved: (value) => _availableQuantity = value!,
              ),
              TextFormField(
                controller: _minQuantityController,
                decoration: const InputDecoration(
                    labelText: 'Product Minimum Quantity'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter the minimum allowed quantity';
                  }
                  return null;
                },
                onSaved: (value) => _minQuantity = value!,
              ),
              TextFormField(
                controller: _productPriceController,
                decoration: const InputDecoration(labelText: 'Product Price'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a product price';
                  }
                  return null;
                },
                onSaved: (value) => _productPrice = value!,
              ),
              TextFormField(
                controller: _productDescriptionController,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration:
                    const InputDecoration(labelText: 'Product Description'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a product description';
                  }
                  return null;
                },
                onSaved: (value) => _productDescription = value!,
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // use this button to open the multi-select dialog
                    ElevatedButton(
                      onPressed: _showMainCategory,
                      child: const Text('Select available Sizes'),
                    ),
                    const Divider(
                      height: 30,
                    ),
                    // display selected items
                    Wrap(children: [
                      _mainCategory != ''
                          ? InkWell(
                              onTap: () {
                                setState(() {
                                  _mainCategory = '';
                                });
                              },
                              child: Chip(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 8.0),
                                label: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Text(_mainCategory),
                                    const Icon(Icons.clear),
                                  ],
                                ),
                              ),
                            )
                          : Container()
                    ])
                  ],
                ),
              ),
              Card(
                child: Column(
                  children: [
                    const ListTile(
                      title: Text("Category"),
                    ),
                    Wrap(
                      children: List.generate(_categoryOption.split(',').length,
                          (int index) {
                        return ChoiceChip(
                          label: Text(_categoryOption.split(',')[index]),
                          selected: _checkedCategory[index],
                          onSelected: (bool selected) {
                            setState(() {
                              _checkedCategory[index] = selected;
                              if (selected) {
                                _category
                                    .add(_categoryOption.split(',')[index]);
                              } else {
                                _category
                                    .remove(_categoryOption.split(',')[index]);
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              Card(
                child: Column(
                  children: [
                    const ListTile(
                      title: Text("Colors"),
                    ),
                    Wrap(
                      children: List.generate(_colorOption.split(',').length,
                          (int index) {
                        return ChoiceChip(
                          label: Text(_colorOption.split(',')[index]),
                          selected: _colorsChecked[index],
                          onSelected: (bool selected) {
                            setState(() {
                              _colorsChecked[index] = selected;
                              if (selected) {
                                _availableColors
                                    .add(_colorOption.split(',')[index]);
                              } else {
                                _availableColors
                                    .remove(_colorOption.split(',')[index]);
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              Card(
                child: Column(
                  children: [
                    const ListTile(
                      title: Text("Size"),
                    ),
                    Wrap(
                      children: List.generate(_sizeOption.split(',').length,
                          (int index) {
                        return ChoiceChip(
                          label: Text(_sizeOption.split(',')[index]),
                          selected: _sizesChecked[index],
                          onSelected: (bool selected) {
                            setState(() {
                              _sizesChecked[index] = selected;
                              if (selected) {
                                _availableSizes
                                    .add(_sizeOption.split(',')[index]);
                              } else {
                                _availableSizes
                                    .remove(_sizeOption.split(',')[index]);
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                child: const Text('Add Image'),
                onPressed: () async {
                  pickImage();
                },
              ),
              SizedBox(
                height: 400,
                child: Card(
                  child: ListView.builder(
                    shrinkWrap: true,
                    controller: _scrollController,
                    itemCount: _productImages.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Row(
                        children: [
                          SizedBox(
                            child: Image.file(
                              File(_productImages[index]),
                              height: 160,
                              width: 160,
                              fit: BoxFit.contain,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _productImages.removeAt(index);
                              });
                            },
                            child: const Icon(
                              Icons.remove_circle,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
              ElevatedButton(
                child: const Text('Save'),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState?.save();
                    try {
                      ProductService.addProduct(
                        mainCategory: _mainCategory,
                        reference: _productRefrence,
                        productName: _productName,
                        category: _category,
                        availableQuantity: _availableQuantity,
                        minimumQuantity: _minQuantity,
                        sizes: _availableSizes,
                        price: _productPrice,
                        colors: _availableColors,
                        photos: _productImages,
                        description: _productDescription,
                      );
                      showErrorDialog(context, 'product saved');
                    } on FaildToRegisterProduct {
                      await showErrorDialog(
                        context,
                        'Coud not register the product',
                      );
                    }
                    // Add the new product to the store here
                    // For example, you can use Firebase Firestore to store the new product
                    // using the _productName, _productPrice, _productDescription, _productImages, _availableColors and _availableSizes variables
                  }
                },
              ),
            ]),
          ),
        ));
  }
}
