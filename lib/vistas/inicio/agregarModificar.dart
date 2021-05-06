import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:libro_de_cobros/servicios/imageStorage.dart';
import 'package:libro_de_cobros/vistas/generalWidgets/subirImagenButton.dart';
import '../../entidades/usuario.dart';

class AgregarModificar extends StatefulWidget {
  const AgregarModificar(
      {Key key,
      this.nombre,
      this.apellido,
      this.profesion,
      this.fechaNacimiento,
      this.index,
      this.urlImagen})
      : super(key: key);

  final nombre;
  final apellido;
  final profesion;
  final fechaNacimiento;
  final index;
  final urlImagen;

  @override
  _AgregarModificarState createState() => _AgregarModificarState(
      this.nombre,
      this.apellido,
      this.profesion,
      this.fechaNacimiento,
      this.index,
      this.urlImagen);
}

class _AgregarModificarState extends State<AgregarModificar> {
  TextEditingController controladorNombre;
  TextEditingController controladorApellido;
  TextEditingController controladorProfesion;
  TextEditingController controladorimagenUrl;

  String nombre;
  String apellido;
  String profesion;
  String urlImagen;
  DateTime fechaNacimiento;
  int index;

  File imageFile;

  DateTime fechaSeleccionada;

  _AgregarModificarState(this.nombre, this.apellido, this.profesion,
      this.fechaNacimiento, this.index, this.urlImagen);

  @override
  void initState() {
    if (fechaNacimiento != null) {
      fechaSeleccionada = fechaNacimiento;
    } else {
      fechaSeleccionada = DateTime.now();
    }
    controladorNombre = new TextEditingController();
    controladorApellido = new TextEditingController();
    controladorProfesion = new TextEditingController();
    controladorimagenUrl = new TextEditingController();
    controladorNombre.text = nombre;
    controladorApellido.text = apellido;
    controladorProfesion.text = profesion;

    if (urlImagen != null) {
      controladorimagenUrl.text = urlImagen;
    } else {
      controladorimagenUrl.text =
          "https://www.adl-logistica.org/wp-content/uploads/2019/07/imagen-perfil-sin-foto-300x300.png";
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Datos cliente"),
        ),
        body: Center(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 15),
                child: Container(
                  width: 190,
                  height: 190,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          fit: BoxFit.fill,
                          image: NetworkImage(this.controladorimagenUrl.text))),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: ElevatedButton.icon(
                  icon: Icon(Icons.edit),
                  onPressed: () async {
                    await _showChoiceDialog(context);
                    if(imageFile!=null){
                      await ImageStorage(file: imageFile).subirImagenPersonal();
                    }
                    setState(() {
                      this.controladorimagenUrl.text = null;
                    });
                  },
                  label: Text("Editar imagen", style: TextStyle(fontSize: 15)),
                ),
              ),
              _InputText(
                customController: controladorNombre,
                labelText: "Nombre",
              ),
              _InputText(
                customController: controladorApellido,
                labelText: "Apellido",
              ),
              _InputText(
                customController: controladorProfesion,
                labelText: "Profesión",
              ),
              Padding(
                padding: EdgeInsets.all(15.0),
                child: TextField(
                  readOnly: true,
                  style: TextStyle(fontSize: 20),
                  controller: null,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(30.0),
                        ),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.date_range),
                        onPressed: () {
                          _selectDate(context);
                        },
                      ),
                      filled: true,
                      hintStyle: TextStyle(fontSize: 20),
                      labelStyle: TextStyle(fontSize: 20),
                      hintText:
                          fechaSeleccionada.toLocal().toString().split(' ')[0],
                      labelText: "Fecha de nacimiento",
                      fillColor: Colors.white70),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(15),
                child: ElevatedButton.icon(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    setState(() {
                      enviarDatos(
                          context,
                          controladorNombre.text,
                          controladorApellido.text,
                          controladorProfesion.text,
                          fechaSeleccionada);
                    });
                  },
                  label:
                      Text("Añadir/Modificar", style: TextStyle(fontSize: 30)),
                ),
              )
            ],
          ),
        ));
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: fechaSeleccionada,
        firstDate: DateTime(1900),
        lastDate: DateTime.now());
    if (picked != null && picked != fechaSeleccionada)
      setState(() {
        fechaSeleccionada = picked;
      });
  }

  Future<dynamic> cajatextoUrl(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(
                'Aviso',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              content: Column(
                children: [
                  Text('Ingrese la url de la imagen'),
                  _InputText(customController: controladorimagenUrl)
                ],
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      setState(() {});
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Ok",
                      style: TextStyle(color: Colors.green),
                    ))
              ],
            ));
  }

  Future<dynamic> cajatexto(BuildContext context, String mensaje) {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(
                'Aviso',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              content: Text(
                '$mensaje',
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Ok",
                      style: TextStyle(color: Colors.grey),
                    ))
              ],
            ));
  }

  enviarDatos(BuildContext context, String nombre, String apellido,
      String profesion, fechaNacimiento) {
    if (controladorimagenUrl.text ==
        "https://www.adl-logistica.org/wp-content/uploads/2019/07/imagen-perfil-sin-foto-300x300.png") {
      controladorimagenUrl.text = null;
    }
    if (nombre.isEmpty ||
        apellido.isEmpty ||
        profesion.isEmpty ||
        fechaNacimiento == DateTime.now()) {
      cajatexto(context, "No deje campos vacios");
    } else {
      Usuario cliente = new Usuario(nombre, apellido,
          profesion: profesion,
          fechaNacimiento: fechaNacimiento,
          index: this.index,
          urlImagen: controladorimagenUrl.text);
      Navigator.pop(context, cliente);
    }
  }

  _openGallery(BuildContext context) async {
    final picker = ImagePicker();
    var picture = await picker.getImage(source: ImageSource.gallery);
    this.setState(() {
      if (picture != null) {
        imageFile = File(picture.path);
      } else {
        print('No image selected.');
      }
    });
    Navigator.of(context).pop();
  }

  _openCamera(BuildContext context) async {
    final picker = ImagePicker();
    var picture = await picker.getImage(source: ImageSource.camera);
    this.setState(() {
      if (picture != null) {
        imageFile = File(picture.path);
      } else {
        print('No image selected.');
      }
    });
    Navigator.of(context).pop();
  }

  Future<void> _showChoiceDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Seleccione"),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  GestureDetector(
                    child: Text("Galeria"),
                    onTap: () {
                      _openGallery(context);
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                  ),
                  GestureDetector(
                    child: Text("Camara"),
                    onTap: () {
                      _openCamera(context);
                    },
                  )
                ],
              ),
            ),
          );
        });
  }

  //retorna  texto si no se ha seleccionado alguna imagen
  Widget _decideImageView() {
    if (imageFile == null) {
      return Text("No se ha seleccionado una imagen");
    } else {
      return Image.file(imageFile, width: 400, height: 400);
    }
  }
}

class _InputText extends StatelessWidget {
  const _InputText({
    Key key,
    @required this.customController,
    this.labelText,
  }) : super(key: key);

  final TextEditingController customController;
  final String labelText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(25.0),
      child: TextField(
        style: TextStyle(fontSize: 20),
        controller: customController,
        decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(30.0),
              ),
            ),
            filled: true,
            hintStyle: TextStyle(fontSize: 20),
            labelStyle: TextStyle(fontSize: 20),
            labelText: this.labelText,
            fillColor: Colors.white70),
      ),
    );
  }
}
