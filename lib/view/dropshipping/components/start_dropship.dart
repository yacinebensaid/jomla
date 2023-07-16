import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:jomla/constants/constants.dart';
import 'package:jomla/services/auth/auth_service.dart';
import 'package:jomla/services/crud/userdata_service.dart';
import 'package:jomla/size_config.dart';
import 'package:jomla/utilities/show_error_dialog.dart';
import 'input_fields.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker/image_picker.dart';

class StratDropship extends StatefulWidget {
  StratDropship({
    Key? key,
  }) : super(key: key);

  @override
  State<StratDropship> createState() => _StratDropshipState();
}

class _StratDropshipState extends State<StratDropship> {
  late final TextEditingController _marketNameController;
  late final TextEditingController _descriptionController;
  File? logofilepath;
  String? _logoFileUrl;
  bool _isUploading = false;
  File? _selectedImage;
  String? _marketPhotoUrl;
  bool _isExploded = false;
  bool _congrats = false;
//this part is for the sign in informations when the app is functioning
  @override
  void initState() {
    _marketNameController = TextEditingController();
    _descriptionController = TextEditingController();

    super.initState();
  }

//this part is for the sign in informations when the app is closed
  @override
  void dispose() {
    _marketNameController.dispose();
    _descriptionController.dispose();
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

  void saveDropship() async {
    if (_marketNameController.text == '') {
      showErrorDialog(context, 'Please enter market name');
    } else {
      if (_selectedImage != null) {
        String imageUrl = '';
        String uniqueFileName =
            DateTime.now().millisecondsSinceEpoch.toString();
        Reference referenceRoot = FirebaseStorage.instance.ref();
        Reference referenceDirImages = referenceRoot.child('images');
        Reference referenceImageToUpload =
            referenceDirImages.child(uniqueFileName);
        try {
          await referenceImageToUpload.putFile(_selectedImage!);
          imageUrl = await referenceImageToUpload.getDownloadURL();
          setState(() {
            _marketPhotoUrl = imageUrl;
            _isUploading = false;
          });
        } catch (error) {}
      }
      if (logofilepath != null) {
        setState(() {
          _isUploading = true;
        });
        String? logoFileUrl;
        String uniqueFileName =
            DateTime.now().millisecondsSinceEpoch.toString();
        Reference referenceRoot = FirebaseStorage.instance.ref();
        Reference referenceDirDropshipID = referenceRoot
            .child('DROPSHIPID${AuthService.firebase().currentUser?.uid}')
            .child('logoFile');
        Reference referenceLogoFileToUpload =
            referenceDirDropshipID.child(uniqueFileName);
        try {
          await referenceLogoFileToUpload.putFile(logofilepath!);
          logoFileUrl = await referenceLogoFileToUpload.getDownloadURL();
          setState(() {
            _logoFileUrl = logoFileUrl;
            _isUploading = false;
          });
        } catch (error) {}
      }
      DataService _dataServInstance = DataService();
      _dataServInstance.createDropShipper(
          _marketPhotoUrl,
          _marketNameController.text,
          _descriptionController.text,
          _logoFileUrl);

      setState(() {
        _congrats = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                const SizedBox(height: 16),
                Column(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        ImagePicker imagePicker = ImagePicker();
                        XFile? file = await imagePicker.pickImage(
                            source: ImageSource.gallery);
                        if (file == null) return;
                        setState(() {
                          _selectedImage = File(file.path);
                        });
                      },
                      child: CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.grey,
                        child: _selectedImage == null
                            ? Icon(
                                Icons.storefront,
                                color: Colors.white,
                              )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(60),
                                child: Center(
                                  child: Image.file(
                                    _selectedImage!,
                                    fit: BoxFit.cover,
                                    width: 120,
                                    height: 120,
                                  ),
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Change the market picture',
                      style: TextStyle(
                        fontSize: getProportionateScreenWidth(18),
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Form(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    InputFieldArea(
                      controler: _marketNameController,
                      keyboardType: TextInputType.emailAddress,
                      inputFormat: null,
                      hint: "Market name",
                      icon: Icons.storefront,
                    ),
                    InputFieldArea(
                      controler: _descriptionController,
                      inputFormat: null,
                      keyboardType: TextInputType.multiline,
                      hint: "Market description",
                      icon: Icons.description_outlined,
                      maxlines: null,
                    ),
                  ],
                )),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    logofilepath != null
                        ? InkWell(
                            onTap: () {
                              setState(() {
                                logofilepath = null;
                              });
                            },
                            child: Row(
                              children: [
                                Icon(Icons.delete),
                                SizedBox(width: 10),
                              ],
                            ),
                          )
                        : Container(),
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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: const [
                            Text('Upload your packaging logo here'),
                            SizedBox(width: 16.0),
                            Icon(Icons.upload),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                _congrats == false
                    ? SizedBox(
                        width: 290,
                        height: 60,
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 500),
                          curve: Curves.easeInOut,
                          decoration: BoxDecoration(
                            color: _isExploded ? Colors.white : kPrimaryColor,
                            borderRadius:
                                BorderRadius.circular(_isExploded ? 60 : 20),
                            border: _isExploded
                                ? Border.all(color: kPrimaryColor, width: 4)
                                : null,
                          ),
                          child: TextButton(
                            style: TextButton.styleFrom(
                              foregroundColor:
                                  _isExploded ? kPrimaryColor : Colors.white,
                              padding: EdgeInsets.symmetric(horizontal: 30),
                            ),
                            onPressed: () {
                              setState(() {
                                _isExploded = true;
                              });
                              Future.delayed(Duration(milliseconds: 500), () {
                                setState(() {
                                  _isExploded = false;
                                });
                              });
                              saveDropship();
                              Future.delayed(Duration(milliseconds: 1500), () {
                                Navigator.pop(context);
                              });
                            },
                            child: Text(
                              'Start the journey',
                              style: TextStyle(
                                fontSize: getProportionateScreenWidth(18),
                              ),
                            ),
                          ),
                        ),
                      )
                    : Text(
                        'Congratulations!',
                        style: TextStyle(
                            fontSize: getProportionateScreenWidth(18),
                            fontWeight: FontWeight.w900,
                            color: Colors.green),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
