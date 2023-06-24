// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jomla/services/crud/userdata_service.dart';
import 'package:jomla/utilities/success_dialog.dart';

class GeneralSettings extends StatefulWidget {
  String name;
  String? description;
  String userType;
  String? image;
  String phoneNumber;
  GeneralSettings({
    Key? key,
    required this.name,
    required this.description,
    required this.userType,
    required this.phoneNumber,
    required this.image,
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
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.name);
    _descriptionController = TextEditingController(text: widget.description);
    _phoneNumberController = TextEditingController(text: widget.phoneNumber);
    _image = widget.image;
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
            title: Text('Error'),
            content: Text('Could not update your infos.'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
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
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.black,
        shadowColor: Colors.transparent.withOpacity(0),
        backgroundColor: Colors.transparent.withOpacity(0),
        title: Text(
          'General Settings',
        ),
        actions: <Widget>[
          TextButton(
            child: Text('save', style: TextStyle(fontSize: 18.w)),
            onPressed: updateMarketInfos,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(top: 10.h),
          child: Column(
            children: [
              widget.userType == 'market'
                  ? Column(
                      children: [
                        GestureDetector(
                          onTap: () async {
                            if (_image != null || _selectedImage != null) {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Error'),
                                    content:
                                        Text('Could not update your infos.'),
                                    actions: <Widget>[
                                      TextButton(
                                        child: Text('delete picture'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          setState(() {
                                            _image = null;
                                            _selectedImage = null;
                                          });
                                        },
                                      ),
                                      TextButton(
                                        child: Text('change picture'),
                                        onPressed: () async {
                                          Navigator.of(context).pop();
                                          ImagePicker imagePicker =
                                              ImagePicker();
                                          XFile? file =
                                              await imagePicker.pickImage(
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
                                          ? Icon(
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
                                          child: Image.network(
                                            _image!,
                                            fit: BoxFit.cover,
                                            width: 100,
                                            height: 100,
                                          ),
                                        ),
                                      ),
                                    ),
                              SizedBox(
                                height: 5.h,
                              ),
                              Text('Change Photo'),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                      ],
                    )
                  : SizedBox.shrink(),
              Padding(
                padding: EdgeInsets.all(16.w),
                child: TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                      labelText: 'Name',
                      icon: Icon(widget.userType == 'market'
                          ? Icons.storefront_outlined
                          : Icons.person_outlined)),
                ),
              ),
              widget.userType == 'market'
                  ? Padding(
                      padding: EdgeInsets.all(16.w),
                      child: TextField(
                        controller: _descriptionController,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        maxLength: 150,
                        decoration: InputDecoration(
                            labelText: 'Description',
                            icon: Icon(Icons.description_outlined)),
                      ),
                    )
                  : SizedBox.shrink(),
              Padding(
                padding: EdgeInsets.all(16.w),
                child: TextField(
                  controller: _phoneNumberController,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ],
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                      labelText: 'Phone Number',
                      icon: Icon(Icons.phone_outlined)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
