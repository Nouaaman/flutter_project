import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class FighterDetails extends StatefulWidget {
  final String? fullName;
  final String? country;
  final String? id;
  final String? imgUrl;
  final String? weightclass;
  final String? record;
  final String? age;

  FighterDetails(
      {this.fullName,
      this.country,
      this.id,
      this.imgUrl,
      this.weightclass,
      this.record,
      this.age});
  @override
  _FighterDetailsState createState() => _FighterDetailsState();
}

class _FighterDetailsState extends State<FighterDetails> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: MediaQuery.of(context).size.height / 1.17,
            floating: true,
            pinned: true,
            backgroundColor: Colors.black,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              titlePadding: EdgeInsets.all(50),
              background: CachedNetworkImage(
                  imageUrl: widget.imgUrl.toString(),
                  fit: BoxFit.fitWidth,
                  width: width / 0.5,
                  height: 400.0,
                  imageBuilder: (context, imageProvider) => Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                      ),
                  placeholder: (context, url) => Center(
                        child: CircularProgressIndicator(),
                      ),
                  errorWidget: (context, url, error) =>
                      Icon(Icons.image_not_supported_outlined)),
            ),
          ),
          SliverList(
              delegate: SliverChildListDelegate([
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                widget.fullName!.toString(),
                style: TextStyle(fontSize: 35.0),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Age: ' + widget.age!.toString(),
                style: TextStyle(fontSize: 18.0),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Record: ' + widget.record!.toString(),
                style: TextStyle(fontSize: 18.0),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Weightclass: ' + widget.weightclass!.toString(),
                style: TextStyle(fontSize: 18.0),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Country: ' + widget.country!.toString(),
                style: TextStyle(fontSize: 18.0),
              ),
            ),
            SizedBox(
              height: 20,
            )
          ]))
        ],
      ),
    );
  }
}
