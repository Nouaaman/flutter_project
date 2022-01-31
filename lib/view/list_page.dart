import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'detail_page.dart';
import 'form_page.dart';

class CardAction {
  static const String Edit = 'Edit';
  static const String Delete = 'Delete';

  static const List<String> choice = <String>[Edit, Delete];
}

class ListFighters extends StatefulWidget {
  @override
  _ListFightersState createState() => _ListFightersState();
}

class _ListFightersState extends State<ListFighters> {
  FirebaseFirestore _db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Glory Kickboxing',
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            tooltip: 'About Glory',
            onPressed: () {
              //open about page
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MyCustomForm()),
          );
        },
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
      body: StreamBuilder(
        stream: _db.collection('fighters').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.data == null)
            return Center(child: CircularProgressIndicator());
          return ListView.builder(
              padding: EdgeInsets.only(bottom: 65),
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (BuildContext context, int index) {
                String id = snapshot.data!.docs.elementAt(index).id;
                String fullName =
                    snapshot.data!.docs.elementAt(index)['fullName'];
                String country =
                    snapshot.data!.docs.elementAt(index)['country'];
                String imageUrl =
                    snapshot.data!.docs.elementAt(index)['picture'];
                String? age =
                    snapshot.data!.docs.elementAt(index)['age'].toString();
                String? weightclass =
                    snapshot.data!.docs.elementAt(index)['weightclass'];
                String? record = snapshot.data!.docs.elementAt(index)['record'];

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: Container(
                      margin: EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          GestureDetector(
                            child: CachedNetworkImage(
                                imageUrl: imageUrl,
                                fit: BoxFit.fitWidth,
                                width: width / 0.5,
                                height: 400.0,
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),
                                placeholder: (context, url) =>
                                    // Icon(Icons.image_not_supported_outlined),
                                    Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.image_not_supported_outlined)),
                            onTap: () {
                              // Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => FighterDetails(
                                        fullName: fullName,
                                        country: country,
                                        id: id,
                                        imgUrl: imageUrl,
                                        weightclass: weightclass,
                                        record: record,
                                        age: age)),
                              );
                            },
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                width: width - 92,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      fullName,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    ),
                                    Text(country)
                                  ],
                                ),
                              ),
                              PopupMenuButton(
                                  color: Colors.black,
                                  itemBuilder: (BuildContext context) {
                                    return CardAction.choice
                                        .map((String choice) {
                                      if (choice == CardAction.Edit) {
                                        return PopupMenuItem<String>(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              TextButton.icon(
                                                  label: Text(choice),
                                                  icon: Icon(Icons.edit),
                                                  style: TextButton.styleFrom(
                                                    primary: Colors.white,
                                                    backgroundColor:
                                                        Colors.deepOrange,
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            20, 9, 20, 9),
                                                  ),
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              MyCustomForm(
                                                                  fullName:
                                                                      fullName,
                                                                  country:
                                                                      country,
                                                                  id: id,
                                                                  imgUrl:
                                                                      imageUrl,
                                                                  weightclass:
                                                                      weightclass,
                                                                  record:
                                                                      record,
                                                                  age: age)),
                                                    );
                                                  })
                                            ],
                                          ),
                                        );
                                      } else {
                                        return PopupMenuItem<String>(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              TextButton.icon(
                                                  label: Text(choice),
                                                  icon: Icon(Icons.delete),
                                                  style: TextButton.styleFrom(
                                                    primary: Colors.white,
                                                    backgroundColor:
                                                        Colors.deepOrange,
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            20, 9, 20, 9),
                                                  ),
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                    FirebaseFirestore.instance
                                                        .collection('fighters')
                                                        .doc(id)
                                                        .delete();
                                                    final snackBar = SnackBar(
                                                        content: const Text(
                                                            'Deleted successfully.'));
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(snackBar);
                                                  })
                                            ],
                                          ),
                                        );
                                      }
                                    }).toList();
                                  }),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              });
        },
      ),
    );
  }
}
