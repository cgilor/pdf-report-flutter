import 'dart:io';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:new_pdf_report/api/pdf_api.dart';
import 'package:new_pdf_report/api/pdf_report_api.dart';
import 'package:new_pdf_report/models/imagePdf.dart';
import 'package:new_pdf_report/models/pdf_date.dart';
import 'package:new_pdf_report/provider/db_provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //int _page = 0;

  //GlobalKey _bottomNavigationKey = GlobalKey();
  late List<ImagePdf> photos = [];
  late ImagePdf fotos;
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
                  if (isLoading) return;
                  await Navigator.pushNamed(context, 'photo');
                  refreshPhotos();
                }),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 700, child: obtenerFotos(context)),
              _crearBoton()
            ],
          ),
        ));
  }

  Widget obtenerFotos(BuildContext context) {
    return ListView.builder(
      itemCount: photos.length,
      itemBuilder: (context, i) {
        return _buildRow(photos[i]);
      },
    );
  }

  Widget _buildRow(ImagePdf photo) {
    final foto = photo.path;
    final image = FileImage(
      File(foto!),
    );
    //print(image);
    return Column(
      children: [
        Container(
          height: 150,
          width: 300,
          child: Image(image: image),
        ),
        ListTile(
          title: new Text(
            photo.description!,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _crearBoton() {
    return ElevatedButton.icon(
      label: Text('PDF'),
      icon: Icon(Icons.save),
      onPressed: () async {
        await recorrerFotos();

        //final fotos = photos;
        //this.photos = await PdfDatabase.instance.readAllImages();
        // final pdfFile = await PdfReportApi.generate(fotos);

        //PdfApi.openFile(pdfFile);
        //print(report.imagePdf.description);
      },
      style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18.0),
      ))),
    );
  }

  recorrerFotos() async {
    final data = await PdfDatabase.instance.readAllImages();
    data.forEach((element) async {
      final report = ImagePdf(
        path: element.path,
        description: element.description,
        createdTime: element.createdTime,
      );
      final pdfFile = await PdfReportApi.generate(report);

      PdfApi.openFile(pdfFile);
    });
    eliminarFoto();
  }

  eliminarFoto() async {
    await PdfDatabase.instance.deleteAllScans();
    photos.forEach((element) {
      final dir = Directory(element.path.toString());
      dir.deleteSync(recursive: true);
      // print(element.path);
    });
    refreshPhotos();
  }

  // savePdf(PdfReport report) async {}
}
