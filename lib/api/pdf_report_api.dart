import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:new_pdf_report/api/pdf_api.dart';
import 'package:new_pdf_report/models/imagePdf.dart';
import 'package:new_pdf_report/models/pdf_date.dart';
import 'package:new_pdf_report/provider/db_provider.dart';
import 'package:pdf/pdf.dart' as pdfWid;
import 'package:pdf/widgets.dart' as pdfLib;

class PdfReportApi {
  static Future<File> generate(ImagePdf photos) async {
    final pdf = pdfLib.Document();
    List<ImagePdf> dataDB = await PdfDatabase.instance.readAllImages();
    //final data = photos.path.toString();
    final font = await rootBundle.load('assets/OpenSans-Light.ttf');
    final ttf = pdfLib.Font.ttf(font);
    // final Uint8List fontData =
    //   File('assets/OpenSans-Light.ttf').readAsBytesSync();
    // final ttf = pdfLib.Font.ttf(fontData.buffer.asByteData());

    pdf.addPage(pdfLib.MultiPage(
        build: (context) => [
              //buildHeader(report),
              pdfLib.SizedBox(height: 3 * pdfWid.PdfPageFormat.cm),
              pdfLib.ListView(
                children: dataDB.map((e) {
                  return pdfLib.Column(
                    children: [
                      pdfLib.Container(
                        height: 300,
                        width: 300,
                        child: pdfLib.Image(pdfLib.MemoryImage(
                            File(e.path!).readAsBytesSync())),
                      ),
                      pdfLib.Text(e.description!,
                          style: pdfLib.TextStyle(font: ttf, fontSize: 40)),
                      pdfLib.Text(e.createdTime.toIso8601String())
                    ],
                  );
                }).toList(),
              )
            ]));

    return PdfApi.saveDocument(name: 'my_invoice.pdf', pdf: pdf);
  }

  static buildPhotos(ImagePdf photos, context) async {
    //final data = photos.toJson();
    List<ImagePdf> dataDB = await PdfDatabase.instance.readAllImages();
    final data = photos.path.toString();

    /*final fotos = [];
    photos.toJson().forEach((key, value) {
      fotos.add(value);*
    });
    print(fotos);*/
    return ListView(
      children: dataDB.map((e) {
        return Column(
          children: [
            Container(
              height: 50,
              width: 100,
              child:
                  Image(image: MemoryImage(File('$e.path').readAsBytesSync())),
            ),
            Text('$e.description',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 50))
          ],
        );
      }).toList(),
    );
  }
}
