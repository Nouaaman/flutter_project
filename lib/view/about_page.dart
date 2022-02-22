import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/services.dart';

class AboutGlory extends StatefulWidget {
  AboutGlory();
  @override
  _AboutGloryState createState() => _AboutGloryState();
}

class _AboutGloryState extends State<AboutGlory> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
  }

  @override
  dispose() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: MediaQuery.of(context).size.height / 2.5,
            floating: true,
            pinned: true,
            backgroundColor: Colors.black,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              titlePadding: EdgeInsets.all(30),
              background: const Image(
                image: AssetImage('assets/badrHari.jpg'),
                fit: BoxFit.cover,
              ),
              title: Text(
                'Glory Kickboxing',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
              ),
            ),
          ),
          SliverList(
              delegate: SliverChildListDelegate([
            Padding(
              padding: const EdgeInsets.all(22.0),
              child: Text(
                'ABOUT US',
                style: TextStyle(
                  fontSize: 22.0,
                  color: Colors.indigo,
                ),
              ),
            ),
            Center(
                child: Container(
              constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width / 1.8),
              child: Text(
                "Founded in 2012, GLORY is the global leader in stand-up combat and home to the most talented stand-up fighters in the world.GLORY rules generate the most exciting form of combat, non-stop, can’t-blink action.GLORY organizes world class stand-up combat events reaching millions of fans around the world across multiple platforms.",
                style: TextStyle(fontSize: 18.0),
                textAlign: TextAlign.justify,
              ),
            )),
            SizedBox(
              height: 20,
            )
          ]))
        ],
      ),
    );
  }
}
