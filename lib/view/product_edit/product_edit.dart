import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jomla/services/crud/product_service.dart';
import 'package:jomla/view/add_product/components/main_category.dart';
import 'package:jomla/view/add_product/components/sub_categories.dart';
import '../../size_config.dart';
import '../../utilities/show_error_dialog.dart';
import '../var_lib.dart' as vars;

class EditProduct extends StatefulWidget {
  String ref;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  EditProduct({
    Key? key,
    required this.ref,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _AddProductPageState createState() => _AddProductPageState();
}

class _AddProductPageState extends State<EditProduct> {
  late TextEditingController _productNameController;
  late TextEditingController _priceController;
  late TextEditingController _mainCategoryController;
  late TextEditingController _subCategoryController;
  late TextEditingController _availableQuantityController;
  late TextEditingController _minimumQuantityController;
  late TextEditingController _descriptionController;
  late String _mainPhoto;
  late List _productPhotos;
  late List<String> _colorList;
  late List<String> _sizeList;
  bool _isLoading = false;

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  final _formKey = GlobalKey<FormState>();

  final List<String> _availableColors = [];
  final List<String> _availableSizes = [];

  List<bool> _colorsChecked = [];
  List<bool> _sizesChecked = [];
  final _colorOption = vars.get_colorOption();
  final _mainCategoryOption = vars.get_mainCategoryOptionAP();
  final _sizeOption = vars.get_sizeOption();
  final _subCategories = vars.get_subCategoriesOption();

  final ScrollController _scrollController = ScrollController();
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  @override
  void initState() {
    super.initState();
    _fetchProductData();
    _colorsChecked =
        List.generate(_colorOption.split(',').length, (_) => false);
    _sizesChecked = List.generate(_sizeOption.split(',').length, (_) => false);
  }

  Future<void> _fetchProductData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      DocumentSnapshot productData =
          await ProductService.getProductDataByReference(widget.ref);
      if (productData.exists) {
        Map<String, dynamic> product =
            productData.data() as Map<String, dynamic>;
        setState(() {
          _productNameController =
              TextEditingController(text: product['product_name']);
          _priceController = TextEditingController(text: product['price']);
          _availableQuantityController =
              TextEditingController(text: product['available_quantity']);
          _mainCategoryController =
              TextEditingController(text: product['main_category']);
          _subCategoryController =
              TextEditingController(text: product['sub_category']);
          _minimumQuantityController =
              TextEditingController(text: product['minimum_quantity']);
          _descriptionController =
              TextEditingController(text: product['description']);
          _colorList = List<String>.from(product['colors']);
          _sizeList = List<String>.from(product['sizes']);
          _mainPhoto = product['main_photo'];
          _productPhotos = List<String>.from(product['photos']);
        });
      }
    } catch (e) {
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
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
      _mainCategoryController.text = results;
    });
  }

/////////////////////////////////////////////////////////////////
  String _selectedSubCategories = '';

  void _showSubCategories() async {
    final List<String> subCategoriesItems =
        _subCategories[_mainCategoryController.text]!;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('edit product'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState?.save();

                if (_mainCategoryController.text == '') {
                  showErrorDialog(
                      context, AppLocalizations.of(context)!.pleasemaincat);
                } else if (_selectedSubCategories == '') {
                  showErrorDialog(
                      context, AppLocalizations.of(context)!.pleasesubcat);
                } else {
                  try {
                    await showSucessDialog(
                        context,
                        'NOTE:',
                        await ProductService.updateProduct(
                          reference: widget.ref,
                          mainCategory: _mainCategoryController.text,
                          productName: _productNameController.text,
                          subCategory: _selectedSubCategories,
                          availableQuantity: _availableQuantityController.text,
                          minimumQuantity: _minimumQuantityController.text,
                          sizes: _availableSizes,
                          price: _priceController.text,
                          colors: _availableColors,
                          description: _descriptionController.text,
                        )) as String;
                  } catch (e) {}
                }
              }
            },
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SafeArea(
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Form(
                  key: _formKey,
                  child: Column(children: [
                    _buildTextField(
                      _productNameController,
                      AppLocalizations.of(context)!.productname,
                      AppLocalizations.of(context)!.pleaseProductname,
                      (value) => _productNameController.text = value!,
                    ),
                    _buildTextField(
                      _availableQuantityController,
                      AppLocalizations.of(context)!.producttotlaquantity,
                      AppLocalizations.of(context)!.pleaseproducttotlaquantity,
                      (value) => _availableQuantityController.text = value!,
                    ),
                    _buildTextField(
                      _minimumQuantityController,
                      AppLocalizations.of(context)!.productminimumquantity,
                      AppLocalizations.of(context)!
                          .pleaseproductminimumquantity,
                      (value) => _minimumQuantityController.text = value!,
                    ),
                    _buildTextField(
                      _priceController,
                      AppLocalizations.of(context)!.productprice,
                      AppLocalizations.of(context)!.pleaseproductprice,
                      (value) => _priceController.text = value!,
                    ),
                    _buildTextField(
                      _descriptionController,
                      AppLocalizations.of(context)!.productdescription,
                      AppLocalizations.of(context)!.pleaseproductdescription,
                      (value) => _descriptionController.text = value!,
                      TextInputType.multiline,
                      null,
                    ),
                    SizedBox(height: getProportionateScreenHeight(80)),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: _showMainCategory,
                            child: Text(AppLocalizations.of(context)!.maincat),
                          ),
                          Wrap(children: [
                            _mainCategoryController.text != ''
                                ? InkWell(
                                    onTap: () {
                                      setState(() {
                                        _mainCategoryController.text = '';
                                        _selectedSubCategories = '';
                                      });
                                    },
                                    child: Chip(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16.0, vertical: 8.0),
                                      label: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Text(_mainCategoryController.text),
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
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: _showSubCategories,
                            child: Text(AppLocalizations.of(context)!.subcat),
                          ),
                          _mainCategoryController.text != ''
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
                                                horizontal: 16.0,
                                                vertical: 8.0),
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
                    Card(
                      child: Column(
                        children: [
                          ListTile(
                            title: Text(AppLocalizations.of(context)!.colors),
                          ),
                          Wrap(
                            children: List.generate(
                                _colorOption.split(',').length, (int index) {
                              return ChoiceChip(
                                label: Text(_colorOption.split(',')[index]),
                                selected: _colorsChecked[index],
                                onSelected: (bool selected) {
                                  setState(() {
                                    _colorsChecked[index] = selected;
                                    if (selected) {
                                      _colorList
                                          .add(_colorOption.split(',')[index]);
                                    } else {
                                      _availableColors.remove(
                                          _colorOption.split(',')[index]);
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
                          ListTile(
                            title: Text(AppLocalizations.of(context)!.size),
                          ),
                          Wrap(
                            children: List.generate(
                                _sizeOption.split(',').length, (int index) {
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
                                      _availableSizes.remove(
                                          _sizeOption.split(',')[index]);
                                    }
                                  });
                                },
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ]),
                ),
              ),
            ),
    );
  }
}

Widget _buildTextField(
  TextEditingController controler,
  String labelText,
  String errorText,
  void Function(String?)? onSaved, [
  TextInputType keyboardType = TextInputType.text,
  int? maxLines = 1,
]) {
  return Column(
    children: [
      TextFormField(
        controller: controler,
        onChanged: (value) => print(value),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(
            horizontal: getProportionateScreenWidth(20),
            vertical: getProportionateScreenWidth(12),
          ),
          labelText: labelText,
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return errorText;
          }
          return null;
        },
        onSaved: onSaved,
        keyboardType: keyboardType,
        maxLines: maxLines,
      ),
      const Divider(height: 7),
    ],
  );
}
