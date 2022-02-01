import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

// form for edit and add fighter info (if data passed show edit else show add )
class AddAndUpdateForm extends StatefulWidget {
  final String? fullName;
  final String? country;
  final String? id;
  final String? imgUrl;
  final String? weightclass;
  final String? record;
  final String? age;

  AddAndUpdateForm(
      {this.fullName,
      this.country,
      this.id,
      this.imgUrl,
      this.weightclass,
      this.record,
      this.age});

  @override
  AddAndUpdateFormState createState() {
    return AddAndUpdateFormState();
  }

  static GlobalKey<FormState> _formKey = GlobalKey<FormState>();
}

class AddAndUpdateFormState extends State<AddAndUpdateForm> {
  TextEditingController _fullName = TextEditingController();
  TextEditingController _country = TextEditingController();
  TextEditingController _weightclass = TextEditingController();
  TextEditingController _record = TextEditingController();
  TextEditingController _age = TextEditingController();
  TextEditingController _imageUrl = TextEditingController();

  initState() {
    _fullName.text = widget.fullName != null ? widget.fullName! : "";
    _country.text = widget.country != null ? widget.country! : "";
    _record.text = widget.record != null ? widget.record! : "";
    _age.text = widget.age != null ? widget.age! : "";
    _imageUrl.text = widget.imgUrl != null ? widget.imgUrl! : "";
    _weightclass.text = widget.weightclass != null ? widget.weightclass! : "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.id != null ? "Update" : "Add"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: Form(
            key: AddAndUpdateForm._formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Insert fighter information",
                  style: TextStyle(color: Colors.black54),
                ),
                SizedBox(
                  height: 20.0,
                ),
                TextFormField(
                  textInputAction: TextInputAction.next,
                  controller: _fullName,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    icon: const Icon(Icons.person_outlined),
                    labelText: 'Full Name',
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  textInputAction: TextInputAction.next,
                  controller: _age,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    icon: const Icon(Icons.date_range_outlined),
                    labelText: 'Age',
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  textInputAction: TextInputAction.next,
                  controller: _record,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    icon: const Icon(Icons.sports_score_outlined),
                    hintText: 'Ex: 143-4-2 (82)',
                    labelText: 'Record: Wins-Losses-Draws (KOs)',
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  textInputAction: TextInputAction.next,
                  controller: _weightclass,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    icon: const Icon(Icons.monitor_weight_outlined),
                    hintText: 'Ex: Heavyweight, Middleweight, Lightweight...',
                    labelText: 'Weightclass',
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  textInputAction: TextInputAction.next,
                  controller: _country,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    icon: const Icon(Icons.flag_outlined),
                    labelText: 'Country',
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  textInputAction: TextInputAction.go,
                  controller: _imageUrl,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    icon: const Icon(Icons.image_outlined),
                    labelText: 'Image Url',
                  ),
                ),
                //update or add button
                Container(
                  padding: const EdgeInsets.only(top: 40.0),
                  child: FlatButton(
                    minWidth: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.all(14),
                    color: Colors.deepPurple,
                    child: Text(
                      widget.id != null ? "UPDATE" : "ADD",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () {
                      var data = {
                        'fullName': _fullName.text,
                        'age': _age.text,
                        'country': _country.text,
                        'record': _record.text,
                        'weightclass': _weightclass.text,
                        'picture': _imageUrl.text,
                      };
                      if (widget.id != null) {
                        FirebaseFirestore.instance
                            .collection('fighters')
                            .doc(widget.id)
                            .update(data);
                        final snackBar = SnackBar(
                            content:
                                const Text('The changes have been saved.'));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      } else {
                        FirebaseFirestore.instance
                            .collection('fighters')
                            .add(data);
                        final snackBar = SnackBar(
                            content: const Text('Added successfully.'));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                      // Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // uploadImage() async {
  //   final _storage = FirebaseStorage.instance;
  //   final _picker = ImagePicker();
  //   PickedFile? image;
  //   //Check Permissions
  //   await Permission.photos.request();

  //   var permissionStatus = await Permission.photos.status;

  //   if (permissionStatus.isGranted) {
  //     //Select Image
  //     image = await _picker.getImage(source: ImageSource.gallery);
  //     setState(() {
  //       image != null ? imageLoding = true : imageLoding = false;
  //     });
  //     var file = File(image!.path);
  //     //Upload to Firebase
  //     var imagename = Random().nextInt(10000).toString();
  //     var snapshot =
  //         await _storage.ref().child('folderName/$imagename').putFile(file);
  //     var downloadUrl = await snapshot.ref.getDownloadURL();
  //     //print(downloadUrl);
  //     setState(() {
  //       widget.imgUrl = downloadUrl;
  //       imageLoding = false;
  //     });
  //   } else {
  //     print('Grant Permissions and try again');
  //   }
  // }
}
