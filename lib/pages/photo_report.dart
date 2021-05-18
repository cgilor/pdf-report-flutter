import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:new_pdf_report/models/imagePdf.dart';
import 'package:new_pdf_report/provider/db_provider.dart';

class PhotoReport extends StatefulWidget {
  @override
  _PhotoReportState createState() => _PhotoReportState();
}

class _PhotoReportState extends State<PhotoReport> {
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController descriptionCtrl = new TextEditingController();
  final ImagePicker _picker = ImagePicker();
  File? _imageFile;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Images'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.photo_size_select_actual),
            onPressed: _seleccionarFoto,
          ),
          IconButton(
            icon: Icon(Icons.camera_alt),
            onPressed: _tomarFoto,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15.0),
          child: Form(
            key: formKey,
            child: Column(
              children: <Widget>[
                _mostrarFoto(),
                _crearNombre(),
                _crearBoton(context)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _crearNombre() {
    return TextFormField(
      controller: descriptionCtrl,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(labelText: 'Description'),
      validator: (value) {
        if (value!.length < 3) {
          return 'Ingrese el nombre del producto';
        } else {
          return null;
        }
      },
    );
  }

  Widget _crearBoton(BuildContext context) {
    return ElevatedButton.icon(
      label: Text('Save'),
      icon: Icon(Icons.save),
      onPressed: () {
        _submit(context);
      },
      style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18.0),
      ))),
    );
  }

  void _submit(BuildContext context) async {
    if (!formKey.currentState!.validate()) return;
    save();
    formKey.currentState!.save();

    Navigator.of(context).pop();
  }

  void save() async {
    final photos = new ImagePdf(
        path: _imageFile!.path.toString(),
        description: descriptionCtrl.text,
        createdTime: DateTime.now());
    await PdfDatabase.instance.create(photos);
    //print(descriptionCtrl.text);
    //print(photos);
    //keyForm.currentState.reset();
  }

  Widget _mostrarFoto() {
    // ignore: unnecessary_null_comparison
    if (_imageFile == null) {
      return Image(
        image: AssetImage('assets/no-image.png'),
        fit: BoxFit.cover,
        height: 300.0,
      );
    } else {
      return Image.file(
        _imageFile!,
        fit: BoxFit.cover,
        height: 200.0,
      );
    }
  }

  _seleccionarFoto() async {
    _procesarImagen(ImageSource.gallery);
  }

  _tomarFoto() async {
    _procesarImagen(ImageSource.camera);
  }

  _procesarImagen(ImageSource origen) async {
    final pickedFile = await _picker.getImage(source: origen);

    setState(() {
      _imageFile = File(pickedFile!.path);
    });
  }
}
