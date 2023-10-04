// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jomla/services/crud/userdata_service.dart';
import 'package:jomla/utilities/reusable.dart';
import 'package:jomla/utilities/shimmers.dart';
import 'package:jomla/utilities/success_dialog.dart';
import 'package:permission_handler/permission_handler.dart';

class DropshipSettings extends StatefulWidget {
  final String dropshipID;
  const DropshipSettings({
    Key? key,
    required this.dropshipID,
  }) : super(key: key);

  @override
  State<DropshipSettings> createState() => _DropshipSettingssState();
}

class _DropshipSettingssState extends State<DropshipSettings> {
  late TextEditingController _nameController;
  late TextEditingController? _descriptionController;
  late TextEditingController _phoneNumberController;
  String? _logoUrl;
  File? _selectedImage;
  String? _image;
  File? logofilepath;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController?.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  void _uploadLogo() async {
    var status = await Permission.storage.status;
    if (status.isGranted) {
      // Permission is granted
      // Access the device storage here
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'pdf', 'png'],
      );
      if (result != null) {
        setState(() {
          logofilepath = File(result.files.single.path!);
        });

        // Do something with the selected file
      }
    } else {
      // Permission is not granted, ask for permission
      status = await Permission.storage.request();
      if (status.isGranted) {
        // Permission is granted
        // Access the device storage here
        FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['jpg', 'pdf', 'png'],
        );
        if (result != null) {
          setState(() {
            logofilepath = File(result.files.single.path!);
          });

          // Do something with the selected file
        }
      } else {
        // Permission is denied
        // Handle the case where the user denies permission
      }
    }
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

    if (logofilepath != null) {
      String? logoFileUrl;
      String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference referenceRoot = FirebaseStorage.instance.ref();
      Reference referenceDirDropshipID =
          referenceRoot.child(widget.dropshipID).child('logoFile');
      Reference referenceLogoFileToUpload =
          referenceDirDropshipID.child(uniqueFileName);
      try {
        await referenceLogoFileToUpload.putFile(logofilepath!);
        logoFileUrl = await referenceLogoFileToUpload.getDownloadURL();
        setState(() {
          _logoUrl = logoFileUrl;
        });
      } catch (error) {}
    }
    try {
      DataService inst = DataService();
      inst.updateDropshipData(
          logoURL: _logoUrl,
          dropshipperID: widget.dropshipID,
          description: _descriptionController?.text,
          phoneNumber: _phoneNumberController.text,
          dropshipName: _nameController.text,
          imageUrl: _imageURL);

      Navigator.of(context).pop();
      showSuccessDialog(
        context,
        'Dropship Market Informations Updated Successfully',
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
    return StreamBuilder(
      stream: DataService.getDropshipperData(widget.dropshipID),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          DropshipperData userData = snapshot.data!;
          _nameController = TextEditingController(text: userData.name);
          _descriptionController =
              TextEditingController(text: userData.description);
          _phoneNumberController =
              TextEditingController(text: userData.phoneNumber);
          _image = userData.picture;
          _logoUrl = userData.logo;

          return Scaffold(
            appBar: CustomAppBarSubPages(
              onBackButtonPressed: () => Navigator.of(context).pop(),
              title: 'FBA settings',
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        if (_image != null || _selectedImage != null) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Error'),
                                content:
                                    const Text('Could not update your infos.'),
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
                                      ImagePicker imagePicker = ImagePicker();
                                      XFile? file = await imagePicker.pickImage(
                                          source: ImageSource.gallery);
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
                                    borderRadius: BorderRadius.circular(60),
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
                                          loadingBuilder: (BuildContext context,
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
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: TextField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                            labelText: 'Name',
                            icon: Icon(Icons.storefront_outlined)),
                      ),
                    ),
                    Padding(
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
                    ),
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
                    GestureDetector(
                      onTap: () {
                        _uploadLogo();
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey.shade400,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text('Chnage your packaging logo here'),
                            SizedBox(width: 16.0),
                            Icon(Icons.upload),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}


/* */