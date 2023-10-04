import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jomla/utilities/success_dialog.dart';

class Variation extends StatefulWidget {
  final String? showAndHide;
  final int? index;
  final Map<String, Map?>? initialDetails;
  final void Function(Map<String, Map<String, dynamic>?> variationData)?
      onVariationAdded;
  final void Function(
          Map<String, Map<String, dynamic>?> variationData, int index)?
      onVariationUpdate;
  const Variation(
      {super.key,
      this.initialDetails,
      required this.onVariationAdded,
      required this.onVariationUpdate,
      this.index,
      this.showAndHide});

  @override
  State<Variation> createState() => _VariationState();
}

class _VariationState extends State<Variation> {
  final _formKeyColor = GlobalKey<FormState>();
  final _formKeySize = GlobalKey<FormState>();

  String? _selectedProductType;
  List<ShoeSize> _shoeSizes = [];
  List<ClothingSize> _selectedClothingSizes = [];
  final List<String> clothingSizes = ['S', 'M', 'L'];

  Color? chosenColor;
  bool isCheckedColor = false;
  bool isCheckedSizes = false;
  File? _selectedImage;
  String? _availableColorQuantity;
  String? _colorName;

/////////////////////////////////////////////////////////////////
  ///
  @override
  void initState() {
    super.initState();
    // TODO: implement initState
    if (widget.initialDetails != null) {
      Map variation = widget.initialDetails!;
      Map? color_details = variation['color_details'];
      Map? size_details = variation['size_details'];
      if (color_details != null && size_details == null) {
        File image = variation['color_details']['image'];
        Color color = variation['color_details']['color'];
        String color_name = variation['color_details']['color_name'];
        String? quantity = variation['color_details']['quantity'];
        setState(() {
          isCheckedColor = true;
          chosenColor = color;
          _colorName = color_name;
          _availableColorQuantity = quantity;
          _selectedImage = image;
          _selectedProductType = 'Shoes';
          _shoeSizes.add(ShoeSize(size: '', quantity: ''));
        });
      } else if (color_details == null && size_details != null) {
        String productType = variation['size_details']['product_type'];
        Map size_quantity = variation['size_details']['size_quantity'];
        setState(() {
          isCheckedSizes = true;
          _selectedProductType = productType;
          if (productType == 'Shoes') {
            size_quantity.forEach((key, value) {
              _shoeSizes.add(
                ShoeSize(
                  size: key,
                  quantity: value,
                ),
              );
            });
          } else if (productType == 'Clothing') {
            size_quantity.forEach((key, value) {
              _selectedClothingSizes
                  .add(ClothingSize(size: key, quantity: value));
            });
          }
        });
      } else if (color_details != null && size_details != null) {
        File image = variation['color_details']['image'];
        Color color = variation['color_details']['color'];
        String color_name = variation['color_details']['color_name'];
        String? quantity = variation['color_details']['quantity'];
        String productType = variation['size_details']['product_type'];
        Map size_quantity = variation['size_details']['size_quantity'];
        setState(() {
          isCheckedColor = true;
          isCheckedSizes = true;
          chosenColor = color;
          _colorName = color_name;
          _availableColorQuantity = quantity;
          _selectedImage = image;
          _selectedProductType = 'Shoes';
          _shoeSizes.add(ShoeSize(size: '', quantity: ''));
          _selectedProductType = productType;
          if (productType == 'Shoes') {
            size_quantity.forEach((key, value) {
              _shoeSizes.add(
                ShoeSize(
                  size: key,
                  quantity: value,
                ),
              );
            });
          }
        });
      }
    } else {
      _selectedProductType = 'Shoes';
      setState(() {
        _shoeSizes.add(ShoeSize(size: '', quantity: ''));
      });
    }
  }

  void pickColor() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        Color currentColor = chosenColor ?? Colors.white;
        return AlertDialog(
          title: const Text('Pick a color'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: currentColor,
              onColorChanged: (Color color) {
                currentColor = color;
              },
              showLabel: false,
              enableAlpha: false,
              pickerAreaHeightPercent: 0.8,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                setState(() {
                  chosenColor = currentColor;
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _handleProductTypeChange(String? newValue) {
    setState(() {
      _selectedProductType = newValue;
      _shoeSizes.clear();
      if (_selectedProductType == 'Shoes') {
        _shoeSizes.add(ShoeSize(size: '', quantity: ''));
      }
    });
  }

  void _addShoeSizeField() {
    setState(() {
      _shoeSizes.add(ShoeSize(size: '', quantity: ''));
    });
  }

  void _handleShoeSizeChange(int index, String newSize) {
    setState(() {
      _shoeSizes[index].size = newSize;
    });
  }

  void _handleShoeQuantityChange(int index, String newQuantity) {
    setState(() {
      _shoeSizes[index].quantity = newQuantity;
    });
  }

  void _deleteShoeSizeField(int index) {
    setState(() {
      _shoeSizes.removeAt(index);
    });
  }

  void _handleClothingSizeChange(String size, bool isChecked, String quantity) {
    setState(() {
      if (isChecked) {
        _selectedClothingSizes
            .add(ClothingSize(size: size, quantity: quantity));
      } else {
        _selectedClothingSizes.removeWhere((item) => item.size == size);
      }
    });
  }

  void saveVariationDetails() {
    Map<String, Map<String, dynamic>?> variationDetails = {};

    if (isCheckedColor) {
      if (chosenColor != null) {
        if (_formKeyColor.currentState!.validate()) {
          if (_selectedImage != null) {
            if (isCheckedSizes) {
              if (_formKeySize.currentState!.validate()) {
                if (_selectedProductType == 'Shoes') {
                  Map<String, String> sizeQuantityMap = {};
                  for (var shoeSize in _shoeSizes) {
                    sizeQuantityMap[shoeSize.size] = shoeSize.quantity;
                  }
                  variationDetails['size_details'] = {
                    'product_type': _selectedProductType,
                    'size_quantity': sizeQuantityMap,
                  };
                } else if (_selectedProductType == 'Clothing') {
                  Map<String, String> sizeQuantityMap = {};
                  for (var clothingSize in _selectedClothingSizes) {
                    sizeQuantityMap[clothingSize.size] =
                        clothingSize.quantityController.text;
                  }
                  variationDetails['size_details'] = {
                    'product_type': _selectedProductType,
                    'size_quantity': sizeQuantityMap,
                  };
                }
                variationDetails['color_details'] = {
                  'color': chosenColor,
                  'color_name': _colorName,
                  'quantity': null,
                  'image': _selectedImage,
                };
                if (widget.onVariationAdded != null) {
                  widget.onVariationAdded!(variationDetails);
                  Navigator.pop(context);
                } else if (widget.onVariationUpdate != null) {
                  widget.onVariationUpdate!(variationDetails, widget.index!);
                  Navigator.pop(context);
                }
              }
            } else {
              variationDetails['size_details'] = null;
              variationDetails['color_details'] = {
                'color': chosenColor,
                'color_name': _colorName,
                'quantity': _availableColorQuantity,
                'image': _selectedImage,
              };
              if (widget.onVariationAdded != null) {
                widget.onVariationAdded!(variationDetails);
                Navigator.pop(context);
              } else if (widget.onVariationUpdate != null) {
                widget.onVariationUpdate!(variationDetails, widget.index!);
                Navigator.pop(context);
              }
            }
          } else {
            showSuccessDialog(context, 'please choose an image');
          }
        }
      } else {
        showSuccessDialog(context, 'please choose a color');
      }
    } else if (isCheckedSizes) {
      if (_formKeySize.currentState!.validate()) {
        if (isCheckedColor) {
          if (chosenColor != null) {
            if (_formKeyColor.currentState!.validate()) {
              if (_selectedImage != null) {
                if (_selectedProductType == 'Shoes') {
                  Map<String, String> sizeQuantityMap = {};
                  for (var shoeSize in _shoeSizes) {
                    sizeQuantityMap[shoeSize.size] = shoeSize.quantity;
                  }
                  variationDetails['size_details'] = {
                    'product_type': _selectedProductType,
                    'size_quantity': sizeQuantityMap,
                  };
                } else if (_selectedProductType == 'Clothing') {
                  Map<String, String> sizeQuantityMap = {};
                  for (var clothingSize in _selectedClothingSizes) {
                    sizeQuantityMap[clothingSize.size] =
                        clothingSize.quantityController.text;
                  }
                  variationDetails['size_details'] = {
                    'product_type': _selectedProductType,
                    'size_quantity': sizeQuantityMap,
                  };
                }
                variationDetails['color_details'] = {
                  'color': chosenColor,
                  'color_name': _colorName,
                  'quantity': null,
                  'image': _selectedImage,
                };
                if (widget.onVariationAdded != null) {
                  widget.onVariationAdded!(variationDetails);
                  Navigator.pop(context);
                } else if (widget.onVariationUpdate != null) {
                  widget.onVariationUpdate!(variationDetails, widget.index!);
                  Navigator.pop(context);
                }
              } else {
                showSuccessDialog(context, 'please choose an image');
              }
            }
          } else {
            showSuccessDialog(context, 'please choose a color');
          }
        } else {
          variationDetails['color_details'] = null;

          if (_selectedProductType == 'Shoes') {
            Map<String, String> sizeQuantityMap = {};
            for (var shoeSize in _shoeSizes) {
              sizeQuantityMap[shoeSize.size] = shoeSize.quantity;
            }
            variationDetails['size_details'] = {
              'product_type': _selectedProductType,
              'size_quantity': sizeQuantityMap,
            };
          } else if (_selectedProductType == 'Clothing') {
            Map<String, String> sizeQuantityMap = {};
            for (var clothingSize in _selectedClothingSizes) {
              sizeQuantityMap[clothingSize.size] =
                  clothingSize.quantityController.text;
            }
            variationDetails['size_details'] = {
              'product_type': _selectedProductType,
              'size_quantity': sizeQuantityMap,
            };
          }
          if (widget.onVariationAdded != null) {
            widget.onVariationAdded!(variationDetails);
            Navigator.pop(context);
          } else if (widget.onVariationUpdate != null) {
            widget.onVariationUpdate!(variationDetails, widget.index!);
            Navigator.pop(context);
          }
        }
      }
    } else {
      showSuccessDialog(context, 'please add details');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add variation'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              saveVariationDetails();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 15,
            ),
            if (widget.showAndHide == 'color' ||
                widget.showAndHide == 'both' ||
                widget.showAndHide == null)
              Align(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 30,
                          child: CheckboxListTile(
                            value: isCheckedColor,
                            onChanged: (value) {
                              setState(() {
                                isCheckedColor = value!;
                              });
                            },
                          ),
                        ),
                        SizedBox(
                          width: 30,
                        ),
                        !isCheckedColor
                            ? AddTitle(
                                color: Colors.grey[300]!,
                                text_color: Colors.grey,
                                text: 'Add color')
                            : AddTitle(
                                color: Colors.blue,
                                text_color: Colors.white,
                                text: 'Add color'),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    if (isCheckedColor)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            Form(
                              key: _formKeyColor,
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          pickColor();
                                        },
                                        child: Container(
                                          width: 80.0,
                                          height: 40.0,
                                          decoration: BoxDecoration(
                                            border:
                                                Border.all(color: Colors.grey),
                                            color: chosenColor ?? Colors.grey,
                                            borderRadius:
                                                BorderRadius.circular(15.0),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 16.0),
                                      Expanded(
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 5),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            border: Border.all(
                                              color: Colors.grey,
                                              width: 1,
                                            ),
                                          ),
                                          child: TextFormField(
                                            onChanged: (value) {
                                              setState(() {
                                                _colorName = value;
                                              });
                                            },
                                            validator: ((value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Please enter a valid color name';
                                              }
                                              return null;
                                            }),
                                            decoration: InputDecoration(
                                              hintText: 'Enter color name',
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  if (!isCheckedSizes)
                                    Container(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 5),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          color: Colors.grey,
                                          width: 1,
                                        ),
                                      ),
                                      child: TextFormField(
                                        inputFormatters: [
                                          FilteringTextInputFormatter
                                              .digitsOnly,
                                          // Add more input formatters as needed to format the phone number
                                        ],
                                        keyboardType: TextInputType.number,
                                        onChanged: (value) {
                                          setState(() {
                                            _availableColorQuantity = value;
                                          });
                                        },
                                        validator: ((value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter a value';
                                          }
                                          return null;
                                        }),
                                        decoration: InputDecoration(
                                          hintText: 'available quantity',
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            ListTile(
                              title: Text('Add a photo for the color'),
                            ),
                            _selectedImage != null
                                ? Stack(children: [
                                    Container(
                                      width: 250,
                                      height: 250,
                                      margin: const EdgeInsets.only(right: 10),
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey),
                                        borderRadius: BorderRadius.circular(5),
                                        image: DecorationImage(
                                          image: FileImage(_selectedImage!),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 5,
                                      right: 5,
                                      child: Container(
                                        height: 30,
                                        decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(0.5),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Center(
                                          child: IconButton(
                                            icon: const Icon(
                                              Icons.close,
                                              size: 15,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                _selectedImage = null;
                                              });
                                            },
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    )
                                  ])
                                : GestureDetector(
                                    onTap: () async {
                                      ImagePicker imagePicker = ImagePicker();
                                      XFile? file = await imagePicker.pickImage(
                                          source: ImageSource.gallery);
                                      if (file == null) return;
                                      setState(() {
                                        _selectedImage = File(file.path);
                                      });
                                    },
                                    child: Container(
                                      width: 250,
                                      height: 250,
                                      margin: const EdgeInsets.only(right: 10),
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: const Icon(
                                        Icons.add,
                                        color: Colors.grey,
                                        size: 60,
                                      ),
                                    ),
                                  ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            SizedBox(
              height: 15,
            ),
            //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
            if (widget.showAndHide == 'size' ||
                widget.showAndHide == 'both' ||
                widget.showAndHide == null)
              Align(
                child: Column(children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 30,
                        child: CheckboxListTile(
                          value: isCheckedSizes,
                          onChanged: (value) {
                            setState(() {
                              isCheckedSizes = value!;
                            });
                          },
                        ),
                      ),
                      SizedBox(
                        width: 30,
                      ),
                      !isCheckedSizes
                          ? AddTitle(
                              color: Colors.grey[300]!,
                              text_color: Colors.grey,
                              text: 'Add sizes')
                          : AddTitle(
                              color: Colors.blue,
                              text_color: Colors.white,
                              text: 'Add sizes'),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  if (isCheckedSizes)
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Form(
                        key: _formKeySize,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Product Type:',
                              style: TextStyle(fontSize: 16.0),
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: DropdownButton<String>(
                                value: _selectedProductType,
                                onChanged: _handleProductTypeChange,
                                items: <String>[
                                  'Shoes',
                                  'Clothing'
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                            ),
                            if (_selectedProductType == 'Shoes') ...[
                              SizedBox(height: 16.0),
                              for (int i = 0; i < _shoeSizes.length; i++) ...[
                                Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 5),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              border: Border.all(
                                                color: Colors.grey,
                                                width: 1,
                                              ),
                                            ),
                                            child: TextFormField(
                                              controller:
                                                  _shoeSizes[i].sizeController,
                                              onChanged: (value) {
                                                _handleShoeSizeChange(i, value);
                                              },
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Please enter a shoe size.';
                                                }
                                                return null;
                                              },
                                              decoration: InputDecoration(
                                                hintText: 'Size ${i + 1}',
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 8.0),
                                        Expanded(
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 5),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              border: Border.all(
                                                color: Colors.grey,
                                                width: 1,
                                              ),
                                            ),
                                            child: TextFormField(
                                              controller: _shoeSizes[i]
                                                  .quantityController,
                                              inputFormatters: [
                                                FilteringTextInputFormatter
                                                    .digitsOnly,
                                                // Add more input formatters as needed to format the phone number
                                              ],
                                              keyboardType:
                                                  TextInputType.number,
                                              onChanged: (value) {
                                                _handleShoeQuantityChange(
                                                    i, value);
                                              },
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Please enter the available quantity.';
                                                }
                                                return null;
                                              },
                                              decoration: InputDecoration(
                                                hintText: 'Quantity ${i + 1}',
                                              ),
                                            ),
                                          ),
                                        ),
                                        i != 0
                                            ? IconButton(
                                                icon: Icon(Icons.clear),
                                                onPressed: () {
                                                  _deleteShoeSizeField(i);
                                                },
                                              )
                                            : SizedBox.shrink(),
                                      ],
                                    ),
                                    SizedBox(height: 16.0),
                                  ],
                                ),
                              ],
                              Align(
                                alignment: Alignment.center,
                                child: IconButton(
                                  onPressed: _addShoeSizeField,
                                  icon: Icon(Icons.add),
                                ),
                              ),
                            ],
                            if (_selectedProductType == 'Clothing')
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  for (var size in clothingSizes)
                                    Column(
                                      children: [
                                        Row(
                                          children: [
                                            Checkbox(
                                              value: _selectedClothingSizes.any(
                                                  (item) => item.size == size),
                                              onChanged: (bool? isChecked) {
                                                if (isChecked != null) {
                                                  _handleClothingSizeChange(
                                                      size, isChecked, '');
                                                }
                                              },
                                            ),
                                            SizedBox(width: 8.0),
                                            Text(
                                                size), // Add this line to display the clothing size
                                            SizedBox(
                                              width: 20,
                                            ),
                                            if (_selectedClothingSizes.any(
                                                (item) => item.size == size))
                                              Expanded(
                                                child: Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 5),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    border: Border.all(
                                                      color: Colors.grey,
                                                      width: 1,
                                                    ),
                                                  ),
                                                  child: TextFormField(
                                                    controller:
                                                        _selectedClothingSizes[
                                                                clothingSizes
                                                                    .indexOf(
                                                                        size)]
                                                            .quantityController,
                                                    keyboardType:
                                                        TextInputType.number,
                                                    inputFormatters: [
                                                      FilteringTextInputFormatter
                                                          .digitsOnly,
                                                      // Add more input formatters as needed to format the phone number
                                                    ],
                                                    onChanged: (value) {
                                                      _handleClothingSizeChange(
                                                          size, true, value);
                                                    },
                                                    validator: (value) {
                                                      if (value == null ||
                                                          value.isEmpty) {
                                                        return 'Please enter the available quantity.';
                                                      }
                                                      return null;
                                                    },
                                                    decoration: InputDecoration(
                                                      hintText:
                                                          'Enter available quantity',
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            SizedBox(height: 16.0),
                                          ],
                                        ),
                                        SizedBox(height: 8.0),
                                      ],
                                    ),
                                ],
                              ),
                            SizedBox(height: 16.0),
                          ],
                        ),
                      ),
                    ),
                ]),
              ),
          ],
        ),
      ),
    );
  }
}

Widget AddTitle(
    {required Color color, required String text, required Color text_color}) {
  return Container(
    width: 250, // Adjust the width as needed
    height: 50,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      color: color, // Change the color to your desired shade
      boxShadow: [
        BoxShadow(
          color: color, // Shadow color
          offset: Offset(0, 2), // Shadow position (x, y)
          blurRadius: 4, // Shadow blur radius
        ),
      ],
    ),
    child: Center(
      child: Text(
        text,
        style: TextStyle(
          color: text_color, // Text color
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );
}

class ShoeSize {
  String size;
  String quantity;
  TextEditingController sizeController;
  TextEditingController quantityController;

  ShoeSize({
    required this.size,
    required this.quantity,
  })  : sizeController = TextEditingController(text: size),
        quantityController = TextEditingController(text: quantity);
}

class ClothingSize {
  String size;
  String quantity;
  late TextEditingController quantityController;

  ClothingSize({required this.size, required this.quantity})
      : quantityController = TextEditingController(text: quantity);
}
