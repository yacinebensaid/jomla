import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:jomla/services/crud/product_service.dart';

import '../../size_config.dart';
import '../../utilities/show_error_dialog.dart';
import 'components/offers.dart';
import 'components/sub_categories.dart';
import 'components/main_category.dart';

import '../var_lib.dart' as vars;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
  File? _selectedImage;
  String _productMainImage = '';
  List<String> _productPhotos = [];
  List<File> _selectedImages = [];

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

  //////////////////////////////////
  void saveMainImage() async {}

  void _pickImage() async {
    ImagePicker imagePicker = ImagePicker();
    XFile? file = await imagePicker.pickImage(source: ImageSource.gallery);

    if (file == null) return;

    // Create a file object from the picked image
    File pickedImage = File(file.path);

    setState(() {
      _selectedImages.add(pickedImage);
    });
  }

  List<Widget> _buildPhotoFields() {
    List<Widget> fields = [];

    for (int i = 0; i < _selectedImages.length; i++) {
      fields.add(
        Row(
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(5),
                image: DecorationImage(
                  image: FileImage(_selectedImages[i]),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 10),
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                setState(() {
                  _selectedImages.removeAt(i);
                });
              },
            ),
          ],
        ),
      );
    }

    fields.add(
      ElevatedButton(
        child: const Text('Select more images'),
        onPressed: _pickImage,
      ),
    );

    return fields;
  }

  void saveProductImages() async {}

  bool _isUploading = false;
  void saveProduct() async {
    if (_selectedImage == null)
      return showSucessDialog(context, 'NOTE:', ' you do not have main photo');
    setState(() {
      _isUploading = true;
    });

    String imageUrl = '';
    String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirImages = referenceRoot.child('images');
    Reference referenceImageToUpload = referenceDirImages.child(uniqueFileName);
    try {
      await referenceImageToUpload.putFile(_selectedImage!);
      imageUrl = await referenceImageToUpload.getDownloadURL();
      setState(() {
        _productMainImage = imageUrl;
        _isUploading = false;
      });
    } catch (error) {
      print(error);
    }

    if (_selectedImages.isNotEmpty) {
      setState(() {
        _isUploading = true;
      });

      List<String> imageUrls = [];
      for (int i = 0; i < _selectedImages.length; i++) {
        String uniqueFileName =
            DateTime.now().millisecondsSinceEpoch.toString();
        Reference referenceRoot = FirebaseStorage.instance.ref();
        Reference referenceDirImages = referenceRoot.child('images');
        Reference referenceImageToUpload =
            referenceDirImages.child(uniqueFileName);

        try {
          await referenceImageToUpload.putFile(_selectedImages[i]);
          String imageUrl = await referenceImageToUpload.getDownloadURL();
          imageUrls.add(imageUrl);
          setState(() {
            _productPhotos.addAll(imageUrls);
            _isUploading = false;
          });
        } catch (error) {}
      }
    } else {
      print('there is no multiple photos');
    }

    await showSucessDialog(
        context,
        'NOTE:',
        await ProductService.productExists(
          mainCategory: _mainCategory,
          productName: _productName,
          subCategory: _selectedSubCategories,
          availableQuantity: _availableQuantity,
          minimumQuantity: _minQuantity,
          sizes: _availableSizes,
          offers: _selectedOffers,
          price: _productPrice,
          colors: _availableColors,
          mainPhoto: _productMainImage,
          photos: _productPhotos,
          description: _productDescription,
        )) as String;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.addproduct),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState?.save();

                if (_mainCategory == '') {
                  showErrorDialog(
                      context, AppLocalizations.of(context)!.pleasemaincat);
                } else if (_selectedSubCategories == '') {
                  showErrorDialog(
                      context, AppLocalizations.of(context)!.pleasesubcat);
                } else if (_selectedImage == null) {
                  showErrorDialog(context, 'please upload the main photo');
                } else if (_selectedImages.isEmpty) {
                  showErrorDialog(context, 'please upload photos');
                } else {
                  saveMainImage();
                  saveProductImages();
                  saveProduct();
                }
              }
            },
          ),
        ],
      ),
      body: _isUploading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Form(
                  key: _formKey,
                  child: Column(children: [
                    _buildTextField(
                      AppLocalizations.of(context)!.productname,
                      AppLocalizations.of(context)!.pleaseProductname,
                      (value) => _productName = value!,
                    ),
                    _buildTextField(
                      AppLocalizations.of(context)!.producttotlaquantity,
                      AppLocalizations.of(context)!.pleaseproducttotlaquantity,
                      (value) => _availableQuantity = value!,
                    ),
                    _buildTextField(
                      AppLocalizations.of(context)!.productminimumquantity,
                      AppLocalizations.of(context)!
                          .pleaseproductminimumquantity,
                      (value) => _minQuantity = value!,
                    ),
                    _buildTextField(
                      AppLocalizations.of(context)!.productprice,
                      AppLocalizations.of(context)!.pleaseproductprice,
                      (value) => _productPrice = value!,
                    ),
                    _buildTextField(
                      AppLocalizations.of(context)!.productdescription,
                      AppLocalizations.of(context)!.pleaseproductdescription,
                      (value) => _productDescription = value!,
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
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: _showSubCategories,
                            child: Text(AppLocalizations.of(context)!.subcat),
                          ),
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
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // use this button to open the multi-select dialog
                          ElevatedButton(
                            onPressed: _showOffers,
                            child: Text(
                                AppLocalizations.of(context)!.selectsubcat),
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
                                      _availableColors
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
                    const ListTile(
                      title: Text('add MAIN PHOTO'),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        ImagePicker imagePicker = ImagePicker();
                        XFile? file = await imagePicker.pickImage(
                            source: ImageSource.gallery);
                        if (file == null) return;
                        setState(() {
                          _selectedImage = File(file.path);
                        });
                      },
                      child: const Text('Select an image'),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    if (_selectedImage != null)
                      Container(
                        height: 200,
                        width: 200,
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 1,
                            color: Colors.grey,
                          ),
                        ),
                        child: Image.file(
                          _selectedImage!,
                          fit: BoxFit.cover,
                        ),
                      ),
                    const SizedBox(
                      height: 20,
                    ),
                    const ListTile(
                      title: Text('add product photos'),
                    ),
                    ..._buildPhotoFields(),
                    const SizedBox(height: 16.0),
                    const SizedBox(
                      height: 65,
                    )
                  ]),
                ),
              ),
            ),
    );
  }
}

Widget _buildTextField(
  String labelText,
  String errorText,
  void Function(String?)? onSaved, [
  TextInputType keyboardType = TextInputType.text,
  int? maxLines = 1,
]) {
  return Column(
    children: [
      TextFormField(
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
