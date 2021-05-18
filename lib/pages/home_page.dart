import 'dart:io';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:new_pdf_report/models/imagePdf.dart';
import 'package:new_pdf_report/provider/db_provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //int _page = 0;

  //GlobalKey _bottomNavigationKey = GlobalKey();
  late List<ImagePdf> photos;
  bool isLoading = false;
  @override
  void initState() {
    super.initState();

    refreshPhotos();
  }

  @override
  void dispose() {
    PdfDatabase.instance.close();

    super.dispose();
  }

  Future refreshPhotos() async {
    setState(() => isLoading = true);

    this.photos = await PdfDatabase.instance.readAllImages();

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Center(
              child:
                  Text('New Report', style: TextStyle(color: Colors.white70))),
          actions: [
            IconButton(
                icon: Icon(Icons.add_a_photo),
                onPressed: () async {
                  await Navigator.pushNamed(context, 'photo');
                  refreshPhotos();
                }),
          ],
        ),
        body: Padding(
          padding: EdgeInsets.all(20.0),
          child: obtenerFotos(context),
        ));
  }

  Widget obtenerFotos(BuildContext context) {
    return FutureBuilder<List<ImagePdf>>(
      future: PdfDatabase.instance.readAllImages(),
      builder: (BuildContext context, AsyncSnapshot<List<ImagePdf>> snapshot) {
        if (snapshot.hasData) {
          final photos = snapshot.data;
          // print(photos);
          return ListView.builder(
            itemCount: photos!.length,
            itemBuilder: (context, i) {
              return _buildRow(photos[i]);
            },
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _buildRow(ImagePdf photo) {
    final foto = photo.path;
    final image = FileImage(
      File(foto),
    );
    print(image);
    return Column(
      children: [
        Container(
          height: 150,
          width: 300,
          child: Image(image: image),
        ),
        ListTile(
          title: new Text(photo.description),
        ),
      ],
    );
  }
}
