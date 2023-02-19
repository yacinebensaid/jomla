import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:jomla/services/crud/product_service.dart';
import '../../../constants/constants.dart';
import '../../../size_config.dart';
import '../../../utilities/show_error_dialog.dart';
import 'main_category.dart';
import 'offers.dart';
import 'sub_categories.dart';
import '../../var_lib.dart' as vars;

class AddProductPage extends StatefulWidget {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  AddProductPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _AddProductPageState createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _formKey = GlobalKey<FormState>();

  String _productName = '';
  String _productRefrence = '';
  String _availableQuantity = '';
  String _minQuantity = '';
  String _productPrice = '';
  String _productDescription = '';
  late String _mainCategory = '';
  final List<String> _availableColors = [];
  final List<String> _availableSizes = [];
  String _selectedOffers = '';

  List<bool> _colorsChecked = [];
  List<bool> _sizesChecked = [];
  final _colorOption = vars.get_colorOption();
  final _mainCategoryOption = vars.get_mainCategoryOptionAP();
  final _sizeOption = vars.get_sizeOption();
  final _subCategories = vars.get_subCategoriesOption();
  final _offerOption = vars.get_offerOption();

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

  String _productMainImage = '';
  File? mainImage;
  Future pickMainImage() async {
    try {
      final XFile? image =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      setState(() => _productMainImage = image.path);
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
    _sizesChecked = List.generate(_sizeOption.split(',').length, (_) => false);
  }

  void _showMainCategory() async {
    // a list of selectable items
    // these items can be hard-coded or dynamically fetched from a database/API
    final List<String> categories = _mainCategoryOption.split(',');

    final String results = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return MainCategorySelect(items: categories);
      },
    );

    // Update UI
    setState(() {
      _mainCategory = results;
    });
  }

/////////////////////////////////////////////////////////////////
  String _selectedSubCategories = '';

  void _showSubCategories() async {
    final List<String> subCategoriesItems = _subCategories[_mainCategory]!;

    final String? results = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return MultiSelectCategory(items: subCategoriesItems);
      },
    );

    // Update UI
    if (results != null) {
      setState(() {
        _selectedSubCategories = results;
      });
    }
  }

  void _showOffers() async {
    final List<String> offers = _offerOption; ///////////////////

    final String? results = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return MultiSelectOffers(items: offers);
      },
    );

    // Update UI
    if (results != null) {
      setState(() {
        _selectedOffers = results;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text('Add Product'),
          actions: <Widget>[
            IconButton(
                icon: const Icon(Icons.save),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState?.save();

                    if (_mainCategory == '') {
                      showErrorDialog(
                          context, 'Please choose the main category');
                    } else if (_selectedSubCategories == '') {
                      showErrorDialog(
                          context, 'Please choose at least one sub category');
                    } else {
                      await showSucessDialog(
                          context,
                          'NOTE:',
                          await ProductService.productExists(
                              mainCategory: _mainCategory,
                              reference: _productRefrence,
                              productName: _productName,
                              subCategory: _selectedSubCategories,
                              availableQuantity: _availableQuantity,
                              minimumQuantity: _minQuantity,
                              sizes: _availableSizes,
                              offers: _selectedOffers,
                              price: _productPrice,
                              colors: _availableColors,
                              mainPhoto: _productMainImage,
                              photos: _productImages,
                              description: _productDescription)) as String;
                    }
                  }
                }),
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            controller: _scrollController,
            child: Form(
              key: _formKey,
              child: Column(children: [
                Container(
                  width: SizeConfig.screenWidth * 0.95,
                  decoration: BoxDecoration(
                    color: kSecondaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: TextFormField(
                    // ignore: avoid_print
                    onChanged: (value) => print(value),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: getProportionateScreenWidth(20),
                          vertical: getProportionateScreenWidth(12)),
                      labelText: 'Product Refrence',
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a product refrence';
                      }
                      return null;
                    },
                    onSaved: (value) => _productRefrence = value!,
                  ),
                ),
                const Divider(
                  height: 7,
                ),
                Container(
                  width: SizeConfig.screenWidth * 0.95,
                  decoration: BoxDecoration(
                    color: kSecondaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: TextFormField(
                    // ignore: avoid_print
                    onChanged: (value) => print(value),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: getProportionateScreenWidth(20),
                          vertical: getProportionateScreenWidth(12)),
                      labelText: 'Product Name',
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a product Name';
                      }
                      return null;
                    },
                    onSaved: (value) => _productName = value!,
                  ),
                ),
                const Divider(
                  height: 7,
                ),
                Container(
                  width: SizeConfig.screenWidth * 0.95,
                  decoration: BoxDecoration(
                    color: kSecondaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: TextFormField(
                    // ignore: avoid_print
                    onChanged: (value) => print(value),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: getProportionateScreenWidth(20),
                          vertical: getProportionateScreenWidth(12)),
                      labelText: 'Product Total Quantity',
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter the total quality';
                      }
                      return null;
                    },
                    onSaved: (value) => _availableQuantity = value!,
                  ),
                ),
                const Divider(
                  height: 7,
                ),
                Container(
                  width: SizeConfig.screenWidth * 0.95,
                  decoration: BoxDecoration(
                    color: kSecondaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: TextFormField(
                    // ignore: avoid_print
                    onChanged: (value) => print(value),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: getProportionateScreenWidth(20),
                          vertical: getProportionateScreenWidth(12)),
                      labelText: 'Product Minimum Quantity',
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter the minimum allowed quantity';
                      }
                      return null;
                    },
                    onSaved: (value) => _minQuantity = value!,
                  ),
                ),
                const Divider(
                  height: 7,
                ),
                Container(
                  width: SizeConfig.screenWidth * 0.95,
                  decoration: BoxDecoration(
                    color: kSecondaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: TextFormField(
                    // ignore: avoid_print
                    onChanged: (value) => print(value),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: getProportionateScreenWidth(20),
                          vertical: getProportionateScreenWidth(12)),
                      labelText: 'Product Price',
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a product price';
                      }
                      return null;
                    },
                    onSaved: (value) => _productPrice = value!,
                  ),
                ),
                const Divider(
                  height: 7,
                ),
                Container(
                  width: SizeConfig.screenWidth * 0.95,
                  decoration: BoxDecoration(
                    color: kSecondaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: TextFormField(
                    // ignore: avoid_print
                    onChanged: (value) => print(value),
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: getProportionateScreenWidth(20),
                          vertical: getProportionateScreenWidth(12)),
                      labelText: 'Product Description',
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a product description';
                      }
                      return null;
                    },
                    onSaved: (value) => _productDescription = value!,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // use this button to open the multi-select dialog
                      ElevatedButton(
                        onPressed: _showMainCategory,
                        child: const Text('Select the main category'),
                      ),
                      // display selected items
                      Wrap(children: [
                        _mainCategory != ''
                            ? InkWell(
                                onTap: () {
                                  setState(() {
                                    _mainCategory = '';
                                    _selectedSubCategories = '';
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
                ///////////////////////////////////////////////////////////////////////
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // use this button to open the multi-select dialog
                      ElevatedButton(
                        onPressed: _showSubCategories,
                        child: const Text('Select The sub categories'),
                      ),
                      // display selected items
                      _mainCategory != ''
                          ? Wrap(children: [
                              _selectedSubCategories != ''
                                  ? InkWell(
                                      onTap: () {
                                        setState(() {
                                          _selectedSubCategories = '';
                                        });
                                      },
                                      child: Chip(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16.0, vertical: 8.0),
                                        label: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            Text(_selectedSubCategories),
                                            const Icon(Icons.clear),
                                          ],
                                        ),
                                      ),
                                    )
                                  : Container()
                            ])
                          : Container()
                    ],
                  ),
                ),
                ///////////////////////////////
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // use this button to open the multi-select dialog
                      ElevatedButton(
                        onPressed: _showOffers,
                        child: const Text('Select The sub categories'),
                      ),
                      // display selected items
                      Wrap(children: [
                        _selectedOffers != ''
                            ? InkWell(
                                onTap: () {
                                  setState(() {
                                    _selectedOffers = '';
                                  });
                                },
                                child: Chip(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0, vertical: 8.0),
                                  label: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Text(_selectedOffers),
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
                ///////////////////////////////

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
                  onPressed: () async {
                    pickMainImage();
                  },
                  child: const Text('Add the main Image'),
                ),
                SizedBox(
                  width: getProportionateScreenWidth(0),
                  child: Card(
                    child: ListView(
                      shrinkWrap: true,
                      controller: _scrollController,
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              child: Image.file(
                                File(_productMainImage),
                                height: 160,
                                width: 160,
                                fit: BoxFit.contain,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _productMainImage = '';
                                });
                              },
                              child: const Icon(
                                Icons.remove_circle,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                ElevatedButton(
                  child: const Text('Add Images'),
                  onPressed: () async {
                    pickImage();
                  },
                ),
                SizedBox(
                  width: getProportionateScreenWidth(0),
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
              ]),
            ),
          ),
        ));
  }
}
