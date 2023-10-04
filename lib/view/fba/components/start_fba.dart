import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:jomla/constants/constants.dart';
import 'package:jomla/services/auth/auth_service.dart';
import 'package:jomla/services/crud/userdata_service.dart';
import 'package:jomla/services/providers.dart';
import 'package:jomla/utilities/reusable.dart';
import 'package:jomla/utilities/show_error_dialog.dart';
import 'package:provider/provider.dart';
import 'input_fields.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker/image_picker.dart';

class StratOnlineMarket extends StatefulWidget {
  StratOnlineMarket({
    Key? key,
  }) : super(key: key);

  @override
  State<StratOnlineMarket> createState() => _StratOnlineMarketState();
}

class _StratOnlineMarketState extends State<StratOnlineMarket> {
  late final TextEditingController _marketNameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _cardController;
  late TextEditingController phoneNumberController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  File? logofilepath;
  String? _logoFileUrl;
  File? _selectedImage;
  String? _marketPhotoUrl;
  bool _isExploded = false;
  bool _congrats = false;
//this part is for the sign in informations when the app is functioning
  @override
  void initState() {
    _marketNameController = TextEditingController();
    _descriptionController = TextEditingController();
    _cardController = TextEditingController();
    phoneNumberController = TextEditingController(
        text: AuthService.firebase().currentUser != null &&
                Provider.of<UserDataInitializer>(context, listen: false)
                        .getUserData !=
                    null
            ? Provider.of<UserDataInitializer>(context, listen: false)
                .getUserData!
                .phoneNumber
            : null);
    super.initState();
  }

//this part is for the sign in informations when the app is closed
  @override
  void dispose() {
    _marketNameController.dispose();
    _descriptionController.dispose();
    phoneNumberController.dispose();
    _cardController.dispose();
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
        }
      } else {}
    }
  }

  bool _isFormValid() {
    final form = _formKey.currentState;
    return form != null && form.validate();
  }

  void saveFBA() async {
    if (_marketNameController.text == '') {
      showErrorDialog(context, 'Please enter market name');
    } else {
      if (phoneNumberController.text == '') {
        showErrorDialog(context, 'Please enter contact phone number');
      } else {
        if (_cardController == '') {
          showErrorDialog(context, 'Please enter payment card number');
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
              });
            } catch (error) {}
          }
          if (logofilepath != null) {
            setState(() {});
            String? logoFileUrl;
            String uniqueFileName =
                DateTime.now().millisecondsSinceEpoch.toString();
            Reference referenceRoot = FirebaseStorage.instance.ref();
            Reference referenceDirFBAID = referenceRoot
                .child('FBAID${AuthService.firebase().currentUser?.uid}')
                .child('logoFile');
            Reference referenceLogoFileToUpload =
                referenceDirFBAID.child(uniqueFileName);
            try {
              await referenceLogoFileToUpload.putFile(logofilepath!);
              logoFileUrl = await referenceLogoFileToUpload.getDownloadURL();
              setState(() {
                _logoFileUrl = logoFileUrl;
              });
            } catch (error) {}
          }
          DataService _dataServInstance = DataService();
          _dataServInstance.createOnlineMarket(
              _marketPhotoUrl,
              _marketNameController.text,
              _descriptionController.text,
              _logoFileUrl,
              false);

          setState(() {
            _congrats = true;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarSubPages(
        onBackButtonPressed: () => Navigator.of(context).pop(),
        title: 'Start Online market',
      ),
      body: Container(
        color: Color.fromARGB(255, 255, 255, 255),
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              const SizedBox(height: 40),
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
                      fontSize: (18),
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      InputFieldArea(
                        controler: _marketNameController,
                        keyboardType: TextInputType.emailAddress,
                        inputFormat: null,
                        hint: "Market name",
                        icon: Icons.storefront,
                        validationtext: 'Please enter market name',
                      ),
                      InputFieldArea(
                        controler: phoneNumberController,
                        inputFormat: null,
                        keyboardType: TextInputType.phone,
                        hint: "Phone number",
                        icon: Icons.phone,
                        maxlines: null,
                        validationtext: 'Please enter contact phone number',
                      ),
                      InputFieldArea(
                        controler: _cardController,
                        inputFormat: null,
                        keyboardType: TextInputType.number,
                        hint: "Card number",
                        icon: Icons.credit_card,
                        maxlines: null,
                        validationtext: 'Please enter payment card number',
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
                          color: _isExploded
                              ? Colors.white
                              : Color.fromARGB(255, 91, 199, 245),
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
                            if (_isFormValid()) {
                              setState(() {
                                _isExploded = true;
                              });
                              Future.delayed(Duration(milliseconds: 500), () {
                                setState(() {
                                  _isExploded = false;
                                });
                              });
                              saveFBA();
                              Future.delayed(Duration(milliseconds: 1500), () {
                                Navigator.pop(context);
                              });
                            }
                          },
                          child: Text(
                            'Start the journey',
                            style: TextStyle(
                              fontSize: (18),
                            ),
                          ),
                        ),
                      ),
                    )
                  : Text(
                      'Congratulations!',
                      style: TextStyle(
                          fontSize: (18),
                          fontWeight: FontWeight.w900,
                          color: Colors.green),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
