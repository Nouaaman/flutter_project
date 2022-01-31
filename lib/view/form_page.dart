import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

// form for edit and add fighter info (if data passed show edit else show add )
class MyCustomForm extends StatefulWidget {
  final String? fullName;
  final String? country;
  final String? id;
  final String? imgUrl;
  final String? weightclass;
  final String? record;
  final String? age;

  MyCustomForm(
      {this.fullName,
      this.country,
      this.id,
      this.imgUrl,
      this.weightclass,
      this.record,
      this.age});

  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

class MyCustomFormState extends State<MyCustomForm> {
  final _formKey = GlobalKey<FormState>();
  final _fullName = TextEditingController();
  final _country = TextEditingController();
  // final _weightclass = TextEditingController();
  final _record = TextEditingController();
  final _age = TextEditingController();
  final _imageUrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _fullName.text = widget.fullName != null ? widget.fullName! : "";
    _country.text = widget.country != null ? widget.country! : "";
    // _weightclass.text = widget.weightclass != null ? widget.weightclass! : "";
    _record.text = widget.record != null ? widget.record! : "";
    _age.text = widget.age != null ? widget.age! : "";
    _imageUrl.text = widget.imgUrl != null ? widget.imgUrl! : "";

    String _weightclass =
        widget.weightclass != null ? widget.weightclass! : "Heavyweight";
    //print(widget.imgUrl);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.id != null ? "Update" : "Add"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Insert fighter information",
                  style: TextStyle(color: Colors.black54),
                ),
                SizedBox(
                  height: 30.0,
                ),
                TextFormField(
                  controller: _fullName,
                  decoration: const InputDecoration(
                    icon: const Icon(Icons.person),
                    labelText: 'Full Name',
                  ),
                ),
                TextFormField(
                  controller: _age,
                  decoration: const InputDecoration(
                    icon: const Icon(Icons.date_range),
                    labelText: 'Age',
                  ),
                ),
                TextFormField(
                  controller: _record,
                  decoration: const InputDecoration(
                    icon: const Icon(Icons.sports_score),
                    hintText: 'Wins-Losses-Draws (KOs)',
                    labelText: 'Record',
                  ),
                ),

                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    icon: const Icon(Icons.monitor_weight),
                  ),
                  elevation: 16,
                  onChanged: (String? newValue) {
                    setState(() {
                      _weightclass = newValue!;
                    });
                  },
                  value: _weightclass,
                  items: <String>[
                    'Heavyweight',
                    'Light Heavyweight',
                    'Middleweight',
                    'Welterweight',
                    'Lightweight'
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                TextFormField(
                  controller: _country,
                  decoration: const InputDecoration(
                    icon: const Icon(Icons.flag),
                    labelText: 'Country',
                  ),
                ),
                TextFormField(
                  controller: _imageUrl,
                  decoration: const InputDecoration(
                    icon: const Icon(Icons.image),
                    labelText: 'Image Url',
                  ),
                ),
                //update or add button
                Container(
                  padding: const EdgeInsets.only(top: 40.0),
                  child: FlatButton(
                    padding: EdgeInsets.only(top: 12, bottom: 12),
                    color: Colors.deepOrange,
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
                        'weightclass': _weightclass.toString(),
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
                      Navigator.pop(context);
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
