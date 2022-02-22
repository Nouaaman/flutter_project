import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/services.dart';
import 'package:image_downloader/image_downloader.dart';

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
  int _progress = 0;
  @override
  void initState() {
    super.initState();

    ImageDownloader.callback(onProgressUpdate: (String? imageId, int progress) {
      setState(() {
        _progress = progress;
      });
    });
  }

  void _downloadImage() async {
    final snackBar = SnackBar(content: const Text('Downloading...'));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    await ImageDownloader.downloadImage(widget.imgUrl!.toString());
  }

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            actions: [
              IconButton(
                icon: const Icon(Icons.download_for_offline_rounded),
                tooltip: 'Download Image',
                onPressed: () {
                  _downloadImage();
                },
              ),
            ],
            expandedHeight: MediaQuery.of(context).size.height,
            floating: true,
            pinned: true,
            backgroundColor: Colors.black,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.fullName!.toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 30,
                      shadows: [
                        Shadow(
                          blurRadius: 1,
                          color: Colors.indigo,
                          offset: Offset(1.5, 1.5),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.arrow_downward,
                    color: Colors.deepPurple.shade100,
                  )
                ],
              ),
              titlePadding: EdgeInsets.all(40),
              background: CachedNetworkImage(
                  imageUrl: widget.imgUrl.toString(),
                  fit: BoxFit.fitHeight,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  imageBuilder: (context, imageProvider) => Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
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
                padding: const EdgeInsets.fromLTRB(0, 18, 0, 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Age',
                      style: TextStyle(fontSize: 14, color: Colors.indigo),
                    ),
                    SizedBox(
                      width: 60,
                      child: Icon(
                        Icons.arrow_downward,
                        size: 16,
                        color: Colors.indigo.shade200,
                      ),
                    ),
                    Text(
                      widget.age!.toString(),
                      style: TextStyle(fontSize: 26.0),
                    ),
                  ],
                )),
            Padding(
                padding: const EdgeInsets.fromLTRB(0, 18, 0, 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Record',
                      style: TextStyle(fontSize: 14, color: Colors.indigo),
                    ),
                    Icon(
                      Icons.arrow_downward,
                      size: 16,
                      color: Colors.indigo.shade200,
                    ),
                    Text(
                      widget.record!.toString(),
                      style: TextStyle(fontSize: 26.0),
                    ),
                  ],
                )),
            Padding(
                padding: const EdgeInsets.fromLTRB(0, 18, 0, 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Weightclass',
                      style: TextStyle(fontSize: 14, color: Colors.indigo),
                    ),
                    Icon(
                      Icons.arrow_downward,
                      size: 16,
                      color: Colors.indigo.shade200,
                    ),
                    Text(
                      widget.weightclass!.toString(),
                      style: TextStyle(fontSize: 26.0),
                    ),
                  ],
                )),
            Padding(
                padding: const EdgeInsets.fromLTRB(0, 18, 0, 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Country',
                      style: TextStyle(fontSize: 14, color: Colors.indigo),
                    ),
                    Icon(
                      Icons.arrow_downward,
                      size: 16,
                      color: Colors.indigo.shade200,
                    ),
                    Text(
                      widget.country!.toString(),
                      style: TextStyle(fontSize: 26.0),
                    ),
                  ],
                )),
          ]))
        ],
      ),
    );
  }
}
