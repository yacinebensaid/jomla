import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jomla/services/crud/product_service.dart';
import 'package:jomla/view/add_product/components/main_category.dart';
import 'package:jomla/view/add_product/components/sub_categories.dart';
import 'package:jomla/view/products_card/product.dart';
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
  late String? _mainPhotoController;
  late List _productPhotosController;
  late List<String> _colorList;
  late List<String> _sizeList;
  bool _isLoading = false;
  File? _selectedImage;

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  final _formKey = GlobalKey<FormState>();

  final List<String> _availableColors = [];
  final List<String> _availableSizes = [];

  List<bool> _colorsChecked = [];
  List<bool> _sizesChecked = [];
  final _mainCategoryOption = vars.get_mainCategoryOptionAP();
  final _subCategories = vars.get_subCategoriesOption();

  final ScrollController _scrollController = ScrollController();
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  @override
  void initState() {
    super.initState();
    _fetchProductData();
  }

  Future<void> _fetchProductData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      Product? product =
          await ProductService.getProductDataByReference(widget.ref);
      if (product != null) {
        setState(() {
          _productNameController =
              TextEditingController(text: product.product_name);
          _priceController = TextEditingController(text: '');
          _availableQuantityController =
              TextEditingController(text: '${product.available_quantity}');
          _mainCategoryController =
              TextEditingController(text: product.main_category);
          _subCategoryController =
              TextEditingController(text: product.sub_category);
          _minimumQuantityController =
              TextEditingController(text: product.main_category);
          _descriptionController =
              TextEditingController(text: product.description);
          _mainPhotoController = product.main_photo;
          _productPhotosController = List<String>.from(product.photos);
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
////////////////////////////////////////////////////////////////////////

  Widget mainPhotoUpdatePicker() {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () async {
            ImagePicker imagePicker = ImagePicker();
            XFile? file = await imagePicker.pickImage(
              source: ImageSource.gallery,
            );
            if (file == null) return;
            setState(() {
              _selectedImage = File(file.path);
              _mainPhotoController = null;
            });
          },
          child: const Text('Select an image'),
        ),
        const SizedBox(height: 20),
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
        if (_mainPhotoController != null)
          Container(
            height: 200,
            width: 200,
            decoration: BoxDecoration(
              border: Border.all(
                width: 1,
                color: Colors.grey,
              ),
            ),
            child: Image.network(
              _mainPhotoController!,
              fit: BoxFit.cover,
            ),
          ),
      ],
    );
  }

///////////////////////////////////////////////////////////////////////////
  List _addedPhotos = [];
  void _pickImage() async {
    ImagePicker imagePicker = ImagePicker();
    XFile? file = await imagePicker.pickImage(source: ImageSource.gallery);

    if (file == null) return;

    // Create a file object from the picked image
    File pickedImage = File(file.path);

    setState(() {
      _addedPhotos.add(pickedImage);
    });
  }

  SingleChildScrollView _buildAddedPhotosFields() {
    List<Widget> fields = [];

    for (int i = 0; i < _addedPhotos.length; i++) {
      fields.add(
        Stack(
          children: [
            Container(
              width: 200,
              height: 200,
              margin: const EdgeInsets.only(right: 10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(5),
                image: DecorationImage(
                  image: FileImage(_addedPhotos[i]),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              top: 5,
              right: 5,
              child: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  setState(() {
                    _addedPhotos.removeAt(i);
                  });
                },
              ),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: fields,
      ),
    );
  }

  SingleChildScrollView _buildPhotoFields() {
    List<Widget> fields = [];

    for (int i = 0; i < _productPhotosController.length; i++) {
      fields.add(
        Stack(
          children: [
            Container(
              width: 200,
              height: 200,
              margin: const EdgeInsets.only(right: 10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Image.network(
                _productPhotosController[i],
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              top: 5,
              right: 5,
              child: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  setState(() {
                    _productPhotosController.removeAt(i);
                  });
                },
              ),
            ),
          ],
        ),
      );
    }
    Widget addPhotoButton = Container(
      width: 200,
      height: 200,
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
    );

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          ...fields,
          _buildAddedPhotosFields(),
          GestureDetector(
            onTap: _pickImage,
            child: addPhotoButton,
          ),
        ],
      ),
    );
  }

  List _productPhotos = [];
  String mainPhoto = '';

  void _updateProduct() async {
    if (_selectedImage == null) {
      setState(() {
        mainPhoto = _mainPhotoController!;
      });
    } else {
      setState(() {
        _isLoading = true;
      });

      String imageUrl = '';
      String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference referenceRoot = FirebaseStorage.instance.ref();
      Reference referenceDirImages = referenceRoot.child('images');
      Reference referenceImageToUpload =
          referenceDirImages.child(uniqueFileName);
      try {
        await referenceImageToUpload.putFile(_selectedImage!);
        imageUrl = await referenceImageToUpload.getDownloadURL();
        setState(() {
          mainPhoto = imageUrl;
          _isLoading = false;
        });
      } catch (error) {}
    }

    if (_addedPhotos.isNotEmpty) {
      setState(() {
        _isLoading = true;
      });

      List<String> imageUrls = [];
      for (int i = 0; i < _addedPhotos.length; i++) {
        String uniqueFileName =
            DateTime.now().millisecondsSinceEpoch.toString();
        Reference referenceRoot = FirebaseStorage.instance.ref();
        Reference referenceDirImages = referenceRoot.child('images');
        Reference referenceImageToUpload =
            referenceDirImages.child(uniqueFileName);

        try {
          await referenceImageToUpload.putFile(_addedPhotos[i]);
          String imageUrl = await referenceImageToUpload.getDownloadURL();
          imageUrls.add(imageUrl);
          setState(() {
            _productPhotos.addAll(imageUrls);
            _isLoading = false;
          });
        } catch (error) {}
      }
    }
    _productPhotos.addAll(_productPhotosController);
    if (_productPhotos.isEmpty) {
      showErrorDialog(context, 'please upload photos');
    } else if (_productPhotos.isNotEmpty) {
      try {
        Navigator.pop(context);
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
              productPhotos: _productPhotos,
              main_photo: mainPhoto,
            )) as String;
      } catch (e) {}
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('edit product'),
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
                  _updateProduct();
                }
              }
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
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
                          Wrap(children: []),
                        ],
                      ),
                    ),
                    Card(
                      child: Column(
                        children: [
                          ListTile(
                            title: Text(AppLocalizations.of(context)!.size),
                          ),
                          Wrap(children: []),
                        ],
                      ),
                    ),
                    mainPhotoUpdatePicker(),
                    const ListTile(
                      title: Text('add product photos'),
                    ),
                    _buildPhotoFields(),
                    const SizedBox(height: 16.0),
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
