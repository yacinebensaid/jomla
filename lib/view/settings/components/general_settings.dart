// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jomla/services/crud/userdata_service.dart';
import 'package:jomla/services/providers.dart';
import 'package:jomla/utilities/reusable.dart';
import 'package:jomla/utilities/shimmers.dart';
import 'package:jomla/utilities/success_dialog.dart';
import 'package:provider/provider.dart';

class GeneralSettings extends StatefulWidget {
  const GeneralSettings({
    Key? key,
  }) : super(key: key);

  @override
  State<GeneralSettings> createState() => _GeneralSettingsState();
}

class _GeneralSettingsState extends State<GeneralSettings> {
  late TextEditingController _nameController;
  late TextEditingController? _descriptionController;
  late TextEditingController _phoneNumberController;
  File? _selectedImage;
  String? _image;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _nameController = TextEditingController(
        text: Provider.of<UserDataInitializer>(context).getUserData!.name);
    _descriptionController = TextEditingController(
        text:
            Provider.of<UserDataInitializer>(context).getUserData!.description);
    _phoneNumberController = TextEditingController(
        text:
            Provider.of<UserDataInitializer>(context).getUserData!.phoneNumber);
    _image = Provider.of<UserDataInitializer>(context).getUserData!.picture;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController?.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  String? _imageURL;
  void updateMarketInfos() async {
    if (_selectedImage != null) {
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
          _imageURL = imageUrl;
        });
      } catch (error) {}
    } else {
      _imageURL = _image;
    }
    try {
      DataService inst = DataService();
      inst.updateMarketData(
          description: _descriptionController?.text,
          phoneNumber: _phoneNumberController.text,
          marketName: _nameController.text,
          imageUrl: _imageURL);

      Navigator.of(context).pop();
      showSuccessDialog(
        context,
        'Your Informations Updated Successfully',
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('Could not update your infos.'),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserDataInitializer>(
        builder: (context, userDataInitializer, _) {
      return Scaffold(
        appBar: CustomAppBarSubPages(
          onBackButtonPressed: () => Navigator.of(context).pop(),
          title: 'General settings',
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Column(
              children: [
                userDataInitializer.getUserData!.user_type == 'market'
                    ? Column(
                        children: [
                          GestureDetector(
                            onTap: () async {
                              if (_image != null || _selectedImage != null) {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text('Error'),
                                      content: const Text(
                                          'Could not update your infos.'),
                                      actions: <Widget>[
                                        TextButton(
                                          child: const Text('delete picture'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                            setState(() {
                                              _image = null;
                                              _selectedImage = null;
                                            });
                                          },
                                        ),
                                        TextButton(
                                          child: const Text('change picture'),
                                          onPressed: () async {
                                            Navigator.of(context).pop();
                                            ImagePicker imagePicker =
                                                ImagePicker();
                                            XFile? file =
                                                await imagePicker.pickImage(
                                                    source:
                                                        ImageSource.gallery);
                                            if (file == null) return;
                                            setState(() {
                                              _image = null;
                                              _selectedImage = File(file.path);
                                            });
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              } else {
                                ImagePicker imagePicker = ImagePicker();
                                XFile? file = await imagePicker.pickImage(
                                    source: ImageSource.gallery);
                                if (file == null) return;
                                setState(() {
                                  _image = null;
                                  _selectedImage = File(file.path);
                                });
                              }
                            },
                            child: Column(
                              children: [
                                _image == null
                                    ? CircleAvatar(
                                        radius: 50,
                                        backgroundColor: Colors.grey,
                                        child: _selectedImage == null
                                            ? const Icon(
                                                Icons.storefront,
                                                color: Colors.white,
                                              )
                                            : ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(60),
                                                child: Center(
                                                  child: Image.file(
                                                    _selectedImage!,
                                                    fit: BoxFit.cover,
                                                    width: 100,
                                                    height: 100,
                                                  ),
                                                ),
                                              ),
                                      )
                                    : CircleAvatar(
                                        radius: 50,
                                        backgroundColor: Colors.grey,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(60),
                                          child: Center(
                                              child: CachedNetworkImage(
                                            key: UniqueKey(),
                                            height: 100,
                                            width: 100,
                                            imageUrl: _image!,
                                            maxWidthDiskCache: 250,
                                            fit: BoxFit.cover,
                                            placeholder: (context, url) {
                                              return const BuildShimmerEffect();
                                            },
                                            errorWidget: (context, url, error) {
                                              return Image.network(
                                                _image!,
                                                loadingBuilder:
                                                    (BuildContext context,
                                                        Widget child,
                                                        ImageChunkEvent?
                                                            loadingProgress) {
                                                  if (loadingProgress == null) {
                                                    return child;
                                                  }
                                                  return const BuildShimmerEffect();
                                                },
                                                errorBuilder: (_, __, ___) =>
                                                    const BuildShimmerEffect(),
                                              );
                                            },
                                          )),
                                        ),
                                      ),
                                const SizedBox(
                                  height: 5,
                                ),
                                const Text('Change Photo'),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                        ],
                      )
                    : const SizedBox.shrink(),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                        labelText: 'Name',
                        icon: Icon(userDataInitializer.getUserData!.user_type ==
                                'market'
                            ? Icons.storefront_outlined
                            : Icons.person_outlined)),
                  ),
                ),
                userDataInitializer.getUserData!.user_type == 'market'
                    ? Padding(
                        padding: const EdgeInsets.all(16),
                        child: TextField(
                          controller: _descriptionController,
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          maxLength: 150,
                          decoration: const InputDecoration(
                              labelText: 'Description',
                              icon: Icon(Icons.description_outlined)),
                        ),
                      )
                    : const SizedBox.shrink(),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextField(
                    controller: _phoneNumberController,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10),
                    ],
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                        labelText: 'Phone Number',
                        icon: Icon(Icons.phone_outlined)),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
