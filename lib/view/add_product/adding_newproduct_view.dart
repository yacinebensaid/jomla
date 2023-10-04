import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jomla/services/crud/product_service.dart';
import 'package:jomla/utilities/reusable.dart';
import 'package:jomla/view/add_product/components/pricing_entry.dart';
import '../../utilities/show_error_dialog.dart';
import 'components/add_variation.dart';
import 'components/sub_categories.dart';
import 'components/main_category.dart';
import '../var_lib.dart' as vars;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'components/text_fields.dart';

class AddProductPage extends StatefulWidget {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  AddProductPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _AddProductPageState createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage>
    with AutomaticKeepAliveClientMixin<AddProductPage> {
  @override
  bool get wantKeepAlive => true;
  final _formKey = GlobalKey<FormState>();

  String _productName = '';
  String _availableQuantity = '';
  String _productDescription = '';
  late String _mainCategory = '';

  final _mainCategoryOption = vars.get_mainCategoryOptionAP();
  final _subCategories = vars.get_subCategoriesOption();

  final ScrollController _scrollController = ScrollController();
  File? _selectedImage;
  String _productMainImage = '';
  final List<String> _productPhotos = [];
  final List<File> _selectedImages = [];

  List<Map<String, String>> _pricingDetails = [];
  void passpricingDetails(List<Map<String, String>> passedPricingDetails) {
    setState(() {
      _pricingDetails = passedPricingDetails;
    });
  }

  List<Map<String, Map<String, dynamic>?>> _variations = [];
  Map? first_variation;
  Map? color_details;
  Map? size_details;
  void addVariations(Map<String, Map<String, dynamic>?> passedVariation) {
    setState(() {
      _variations.add(passedVariation);
      if (_variations.isNotEmpty) {
        first_variation = _variations[0];
        color_details = first_variation!['color_details'];
        size_details = first_variation!['size_details'];
      }
    });
  }

  void updateVariations(
      Map<String, Map<String, dynamic>?> passedVariation, int index) {
    setState(() {
      _variations[index] = passedVariation;
      if (_variations.isNotEmpty) {
        first_variation = _variations[0];
        color_details = first_variation!['color_details'];
        size_details = first_variation!['size_details'];
      }
    });
  }

  @override
  void initState() {
    super.initState();
    if (_variations.isNotEmpty) {
      first_variation = _variations[0];
      color_details = first_variation!['color_details'];
      size_details = first_variation!['size_details'];
    }
  }

  void _showMainCategory() async {
    // a list of selectable items
    // these items can be hard-coded or dynamically fetched from a database/API
    final List<String> categories = _mainCategoryOption;

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

  //////////////////////////////////

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

  SingleChildScrollView _buildPhotoFields() {
    List<Widget> fields = [];

    for (int i = 0; i < _selectedImages.length; i++) {
      fields.add(
        Stack(children: [
          Container(
            width: 200,
            height: 200,
            margin: const EdgeInsets.only(right: 10),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(5),
              image: DecorationImage(
                image: FileImage(_selectedImages[i]),
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
                  _selectedImages.removeAt(i);
                });
              },
              color: Colors.white,
            ),
          ),
        ]),
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
          GestureDetector(
            onTap: _pickImage,
            child: addPhotoButton,
          ),
        ],
      ),
    );
  }

  bool _isUploading = false;
  List<Map<String, Map?>> saveVaries = [];
  void saveProduct() async {
    if (_selectedImage == null) {
      return showSucessDialog(context, 'NOTE:', ' you do not have main photo');
    }
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
    } catch (error) {}

    if (_selectedImages.isEmpty) {
      showSucessDialog(context, 'NOTE:', ' you have to add photos');
    }
    setState(() {
      _isUploading = true;
    });

    List<String> imageUrls = [];
    for (int i = 0; i < _selectedImages.length; i++) {
      String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();
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
    if (_variations.isNotEmpty) {
      for (Map<String, Map?> vari in _variations) {
        Map? color_details = vari['color_details'];
        Map? size_details = vari['size_details'];
        if ((color_details != null && size_details == null) ||
            (color_details != null && size_details != null)) {
          String uniqueFileName =
              DateTime.now().millisecondsSinceEpoch.toString();
          Reference referenceRoot = FirebaseStorage.instance.ref();
          Reference referenceDirImages = referenceRoot.child('images');
          Reference referenceImageToUpload =
              referenceDirImages.child(uniqueFileName);
          try {
            await referenceImageToUpload.putFile(color_details['image']);
            imageUrl = await referenceImageToUpload.getDownloadURL();
            Map<String, Map?> saveVari = {
              'size_details': vari['size_details'],
              'color_details': {
                'color': color_details['color'].toString(),
                'color_name': color_details['color_name'],
                'image': imageUrl,
                'quantity': color_details['quantity'],
              }
            };

            setState(() {
              _isUploading = false;
            });
            saveVaries.add(saveVari);
          } catch (error) {}
        } else if (color_details == null && size_details != null) {
          Map<String, Map?> saveVari = {
            'size_details': vari['size_details'],
            'color_details': vari['color_details']
          };
          setState(() {
            _isUploading = false;
          });
          saveVaries.add(saveVari);
        }
      }
    }

    if (_pricingDetails.isEmpty) {
      showSucessDialog(context, 'NOTE:', ' you have to enter the pricing');
    }

    await showSucessDialog(
        context,
        'NOTE:',
        await ProductService.productExists(
          mainCategory: _mainCategory,
          availableQuantity: _variations.isEmpty ? _availableQuantity : null,
          productName: _productName,
          variations: saveVaries,
          subCategory: _selectedSubCategories,
          price: _pricingDetails,
          mainPhoto: _productMainImage,
          photos: _productPhotos,
          description: _productDescription,
        )) as String;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: CustomAppBarSubPages(
        onBackButtonPressed: () => Navigator.of(context).pop(),
        title: 'Add product',
      ),

      /* */
      body: _isUploading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Form(
                      key: _formKey,
                      child: Column(children: [
                        TextFields(
                          labelText: AppLocalizations.of(context)!.productname,
                          errorText:
                              AppLocalizations.of(context)!.pleaseProductname,
                          onSaved: (value) => _productName = value!,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        TextFields(
                          labelText:
                              AppLocalizations.of(context)!.productdescription,
                          errorText: AppLocalizations.of(context)!
                              .pleaseproductdescription,
                          onSaved: (value) => _productDescription = value!,
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        if (_variations.isEmpty)
                          TextFields(
                            labelText: 'available quantity',
                            errorText: 'Please enter a value',
                            onSaved: (value) => _availableQuantity = value!,
                            keyboardType: TextInputType.number,
                            inputFormat: [
                              FilteringTextInputFormatter.digitsOnly,
                              // Add more input formatters as needed to format the phone number
                            ],
                          ),
                      ]),
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _mainCategory = '';
                            _selectedSubCategories =
                                ''; // Clear selected sub-categories
                          });
                          _showMainCategory();
                        },
                        child: const Row(
                          children: [
                            Text(
                              'Main-category',
                              style: TextStyle(fontSize: 18),
                            ),
                            Icon(
                              Icons.arrow_drop_down,
                              size: 27,
                            ),
                            Text(
                              ':',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      Wrap(
                        children: [
                          _mainCategory != ''
                              ? InkWell(
                                  onTap: () {
                                    setState(() {
                                      _mainCategory = '';
                                      _selectedSubCategories =
                                          ''; // Clear selected sub-categories
                                    });
                                  },
                                  child: Chip(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 6.0),
                                    label: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Text(
                                          _mainCategory,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: 13,
                                          ),
                                        ),
                                        const Icon(Icons.clear),
                                      ],
                                    ),
                                  ),
                                )
                              : const SizedBox.shrink(),
                        ],
                      ),
                    ],
                  ),
                  _mainCategory != ''
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  _selectedSubCategories =
                                      ''; // Clear selected sub-categories
                                });
                                _showSubCategories();
                              },
                              child: const Row(
                                children: [
                                  Text(
                                    'Sub-category',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  Icon(
                                    Icons.arrow_drop_down,
                                    size: 27,
                                  ),
                                  Text(
                                    ':',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Flexible(
                              child: Wrap(
                                children: [
                                  _selectedSubCategories.isNotEmpty
                                      ? InkWell(
                                          onTap: () {
                                            setState(() {
                                              _selectedSubCategories = '';
                                            });
                                          },
                                          child: Chip(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 6,
                                            ),
                                            label: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                Flexible(
                                                  child: Text(
                                                    _selectedSubCategories,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                      fontSize: 13,
                                                    ),
                                                  ),
                                                ),
                                                const Icon(Icons.clear),
                                              ],
                                            ),
                                          ),
                                        )
                                      : const SizedBox.shrink(),
                                ],
                              ),
                            ),
                          ],
                        )
                      : const SizedBox.shrink(),
                  Card(
                    elevation: 2, // Controls the depth of the shadow
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          10.0), // Adjust the value to change the roundness
                    ),
                    child: Column(
                      children: [
                        ListTile(
                          title:
                              Text(AppLocalizations.of(context)!.productprice),
                        ),
                        _pricingDetails.isNotEmpty
                            ? _buildPricingFields(
                                pricingDetails: _pricingDetails)
                            : const SizedBox.shrink(),
                        const SizedBox(height: 6),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: ((context) => PriceEntryForm(
                                      pricingFromAdd: _pricingDetails,
                                      passpricingDetails: passpricingDetails,
                                    ))));
                          },
                          child: const Text('set the pricing'),
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Card(
                    elevation: 2, // Controls the depth of the shadow
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          10.0), // Adjust the value to change the roundness
                    ),
                    child: Column(
                      children: [
                        const ListTile(
                          title: Text('add variation'),
                        ),
                        if (_variations.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: _variations.length,
                              itemBuilder: (context, index) {
                                Map variation = _variations[index];
                                Map? colorDetails = variation['color_details'];
                                Map? sizeDetails = variation['size_details'];
                                if (colorDetails != null &&
                                    sizeDetails == null) {
                                  File image =
                                      variation['color_details']['image'];
                                  Color color =
                                      variation['color_details']['color'];
                                  String colorName =
                                      variation['color_details']['color_name'];
                                  String? quantity =
                                      variation['color_details']['quantity'];
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                              builder: ((context) => Variation(
                                                    initialDetails:
                                                        _variations[index],
                                                    onVariationAdded: null,
                                                    onVariationUpdate:
                                                        updateVariations,
                                                    index: index,
                                                  ))));
                                    },
                                    child: Column(
                                      children: [
                                        Stack(
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.grey),
                                                borderRadius:
                                                    BorderRadius.circular(15.0),
                                              ),
                                              child: VariationColor(
                                                color: color,
                                                image: image,
                                                color_name: colorName,
                                                quantity: quantity,
                                              ),
                                            ),
                                            Positioned(
                                              top: 0,
                                              right: 0,
                                              child: IconButton(
                                                onPressed: () {
                                                  setState(() {
                                                    _variations.removeAt(index);
                                                    if (_variations
                                                        .isNotEmpty) {
                                                      first_variation =
                                                          _variations[0];
                                                      colorDetails =
                                                          first_variation![
                                                              'color_details'];
                                                      sizeDetails =
                                                          first_variation![
                                                              'size_details'];
                                                    } else {
                                                      first_variation = null;
                                                    }
                                                  });
                                                },
                                                icon: const Icon(
                                                  Icons.delete,
                                                  size: 18,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                      ],
                                    ),
                                  );
                                } else if (sizeDetails != null &&
                                    colorDetails == null) {
                                  Map sizeQuantity = variation['size_details']
                                      ['size_quantity'];
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                              builder: ((context) => Variation(
                                                    initialDetails:
                                                        _variations[index],
                                                    onVariationAdded: null,
                                                    onVariationUpdate:
                                                        updateVariations,
                                                    index: index,
                                                  ))));
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey),
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                      ),
                                      child: Column(
                                        children: [
                                          GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  _variations.removeAt(index);
                                                  if (_variations.isNotEmpty) {
                                                    first_variation =
                                                        _variations[0];
                                                    colorDetails =
                                                        first_variation![
                                                            'color_details'];
                                                    sizeDetails =
                                                        first_variation![
                                                            'size_details'];
                                                  } else {
                                                    first_variation = null;
                                                  }
                                                });
                                              },
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  const Text('Delete'),
                                                  IconButton(
                                                    iconSize: 18,
                                                    onPressed: () {
                                                      setState(() {
                                                        _variations
                                                            .removeAt(index);
                                                        if (_variations
                                                            .isNotEmpty) {
                                                          first_variation =
                                                              _variations[0];
                                                          colorDetails =
                                                              first_variation![
                                                                  'color_details'];
                                                          sizeDetails =
                                                              first_variation![
                                                                  'size_details'];
                                                        } else {
                                                          first_variation =
                                                              null;
                                                        }
                                                      });
                                                    },
                                                    icon: const Icon(
                                                      Icons.delete,
                                                    ),
                                                  ),
                                                ],
                                              )),
                                          VariationSizes(
                                              size_map: sizeQuantity),
                                        ],
                                      ),
                                    ),
                                  );
                                } else if (sizeDetails != null &&
                                    colorDetails != null) {
                                  File image =
                                      variation['color_details']['image'];
                                  Color color =
                                      variation['color_details']['color'];
                                  String colorName =
                                      variation['color_details']['color_name'];
                                  String? quantity =
                                      variation['color_details']['quantity'];
                                  Map sizeQuantity = variation['size_details']
                                      ['size_quantity'];

                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                              builder: ((context) => Variation(
                                                    initialDetails:
                                                        _variations[index],
                                                    onVariationAdded: null,
                                                    onVariationUpdate:
                                                        updateVariations,
                                                    index: index,
                                                  ))));
                                    },
                                    child: Stack(
                                      children: [
                                        Column(
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.grey),
                                                borderRadius:
                                                    BorderRadius.circular(15.0),
                                              ),
                                              child: Column(
                                                children: [
                                                  VariationColor(
                                                    color: color,
                                                    image: image,
                                                    color_name: colorName,
                                                    quantity: quantity,
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  VariationSizes(
                                                      size_map: sizeQuantity),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                          ],
                                        ),
                                        Positioned(
                                          top: 0,
                                          right: 0,
                                          child: IconButton(
                                            onPressed: () {
                                              setState(() {
                                                _variations.removeAt(index);
                                                if (_variations.isNotEmpty) {
                                                  first_variation =
                                                      _variations[0];
                                                  colorDetails =
                                                      first_variation![
                                                          'color_details'];
                                                  sizeDetails =
                                                      first_variation![
                                                          'size_details'];
                                                } else {
                                                  first_variation = null;
                                                }
                                              });
                                            },
                                            icon: const Icon(
                                              Icons.delete,
                                              size: 18,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                } else {
                                  return const SizedBox.shrink();
                                }
                              },
                            ),
                          ),
                        const SizedBox(height: 6),
                        first_variation == null
                            ? ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: ((context) => Variation(
                                            initialDetails: null,
                                            onVariationAdded: addVariations,
                                            onVariationUpdate: null,
                                          ))));
                                },
                                child: const Text('add variation'))
                            : color_details != null && size_details == null
                                ? ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                              builder: ((context) => Variation(
                                                    showAndHide: 'color',
                                                    initialDetails: null,
                                                    onVariationAdded:
                                                        addVariations,
                                                    onVariationUpdate: null,
                                                  ))));
                                    },
                                    child: const Text('add variation'))
                                : size_details != null && color_details == null
                                    ? const SizedBox.shrink()
                                    : color_details != null &&
                                            size_details != null
                                        ? ElevatedButton(
                                            onPressed: () {
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: ((context) =>
                                                          Variation(
                                                            showAndHide: 'both',
                                                            initialDetails:
                                                                null,
                                                            onVariationAdded:
                                                                addVariations,
                                                            onVariationUpdate:
                                                                null,
                                                          ))));
                                            },
                                            child: const Text('add variation'))
                                        : const SizedBox.shrink(),
                        const SizedBox(height: 10),
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
                  _buildPhotoFields(),
                  const SizedBox(height: 30.0),
                  ElevatedButton(
                    child: Text('save product'),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState?.save();

                        if (_mainCategory == '') {
                          showErrorDialog(context,
                              AppLocalizations.of(context)!.pleasemaincat);
                        } else if (_selectedSubCategories == '') {
                          showErrorDialog(context,
                              AppLocalizations.of(context)!.pleasesubcat);
                        } else if (_selectedImage == null) {
                          showErrorDialog(
                              context, 'please upload the main photo');
                        } else if (_selectedImages.isEmpty) {
                          showErrorDialog(context, 'please upload photos');
                        } else {
                          saveProduct();
                        }
                      }
                    },
                  ),
                  const SizedBox(height: 30.0),
                ],
              ),
            ),
    );
  }
}

Widget _buildPricingFields({
  required List<Map<String, dynamic>> pricingDetails,
}) {
  String oneItemPrice = pricingDetails[0]['price'];

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 10),
    child: Row(
      children: [
        Expanded(
          flex: 1,
          child: Container(
            height: 60,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Colors.grey,
                width: 1,
              ),
            ),
            child: Column(
              children: [
                const Text(
                  'One Item',
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  '$oneItemPrice da',
                  style: const TextStyle(fontSize: 16),
                )
              ],
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                // Existing code for the first container
                for (int i = 0; i < pricingDetails.length - 1; i++)
                  if (i < 3) // Limit to a maximum of 3 items
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Colors.grey,
                            width: 1,
                          ),
                        ),
                        child: Column(
                          children: [
                            Text(
                              '${pricingDetails[i + 1]['from']} - ${pricingDetails[i + 1]['to']} Items',
                              style: const TextStyle(fontSize: 16),
                            ),
                            Text(
                              '${pricingDetails[i + 1]['price']} da',
                              style: const TextStyle(fontSize: 16),
                            )
                          ],
                        ),
                      ),
                    ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

Widget VariationColor(
    {required File image,
    required Color color,
    required String color_name,
    required String? quantity}) {
  return Container(
      child: Row(
    children: [
      Container(
        height: 90,
        width: 90,
        decoration: BoxDecoration(
          border: Border.all(
            width: 1,
            color: Colors.grey,
          ),
        ),
        child: Image.file(
          image,
          fit: BoxFit.cover,
        ),
      ),
      const SizedBox(width: 20),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Color :',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                width: 5,
              ),
              Container(
                width: 80.0,
                height: 20.0,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  color: color,
                  borderRadius: BorderRadius.circular(15.0),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 7,
          ),
          Row(
            children: [
              const Text(
                'Color name:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                width: 5,
              ),
              Text(color_name,
                  style: const TextStyle(
                    fontSize: 17,
                  ))
            ],
          ),
          const SizedBox(
            height: 7,
          ),
          if (quantity != null)
            Row(
              children: [
                const Text(
                  'Quantity:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  width: 5,
                ),
                Text(
                  quantity,
                  style: const TextStyle(
                    fontSize: 17,
                  ),
                )
              ],
            )
        ],
      )
    ],
  ));
}

Widget VariationSizes({required Map size_map}) {
  return Center(
    child: Table(
      border: TableBorder.all(),
      columnWidths: {
        0: const FlexColumnWidth(1),
        1: const FlexColumnWidth(1),
      },
      children: [
        const TableRow(
          children: [
            TableCell(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Size',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            TableCell(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Quantity',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
        ...size_map.entries.map(
          (entry) => TableRow(
            children: [
              TableCell(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(entry.key),
                ),
              ),
              TableCell(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(entry.value.toString()),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}


/*
.
.
.
if (color_details != null &&
                                      size_details == null) {
                                    File image =
                                        variation['color_details']['image'];
                                    Color color =
                                        variation['color_details']['color'];
                                    String color_name =
                                        variation['color_details']
                                            ['color_name'];
                                    String? quantity =
                                        variation['color_details']['quantity'];
                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: ((context) =>
                                                    Variation(
                                                      initialDetails:
                                                          _variations[index],
                                                      onVariationAdded: null,
                                                      onVariationUpdate:
                                                          updateVariations,
                                                      index: index,
                                                    ))));
                                      },
                                      child: Column(
                                        children: [
                                          Stack(
                                            children: [
                                              Container(
                                                padding: EdgeInsets.all(8),
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Colors.grey),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15.0),
                                                ),
                                                child: VariationColor(
                                                  color: color,
                                                  image: image,
                                                  color_name: color_name,
                                                  quantity: quantity,
                                                ),
                                              ),
                                              Positioned(
                                                top: 0,
                                                right: 0,
                                                child: IconButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      _variations
                                                          .removeAt(index);
                                                      if (_variations
                                                          .isNotEmpty) {
                                                        first_variation =
                                                            _variations[0];
                                                        color_details =
                                                            first_variation![
                                                                'color_details'];
                                                        size_details =
                                                            first_variation![
                                                                'size_details'];
                                                      } else {
                                                        first_variation = null;
                                                      }
                                                    });
                                                  },
                                                  icon: Icon(
                                                    Icons.delete,
                                                    size: 18,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                        ],
                                      ),
                                    );
                                    
                                    .
                                    .
                                    .} */