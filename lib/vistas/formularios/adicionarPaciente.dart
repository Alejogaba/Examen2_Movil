import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:libro_de_cobros/entidades/usuario.dart';
import 'package:libro_de_cobros/servicios/auth.dart';
import 'package:libro_de_cobros/servicios/database.dart';
import 'package:libro_de_cobros/servicios/imageStorage.dart';
import 'package:libro_de_cobros/vistas/generalWidgets/customTextFormField.dart';
import 'package:libro_de_cobros/vistas/inicio/principal.dart';

class AdicionarPaciente extends StatefulWidget {
  @override
  _AdicionarPacienteState createState() => _AdicionarPacienteState();
}

class _AdicionarPacienteState extends State<AdicionarPaciente> {
  TextEditingController controlNombre = TextEditingController();
  TextEditingController controlApellido = TextEditingController();
  TextEditingController controlIdentificacion = TextEditingController();
  TextEditingController controlTrabajando = TextEditingController();
  TextEditingController controlDireccion = TextEditingController();
  TextEditingController controlBarrio = TextEditingController();
  TextEditingController controlTelefono = TextEditingController();
  TextEditingController controladorimagenUrl = new TextEditingController();
  List<String> listaTipo = ["Medico", "Enfermero", "Fisioterapeuta"];
  String tipo = '';
  String trabajando;
  String urlImagen;
  File imageFile;
  
  DateTime fechaSeleccionada;
  DateTime fechaNacimiento;

  bool estaActivo = false;
  bool estaTrabajando = false;
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    if (fechaNacimiento != null) {
      fechaSeleccionada = fechaNacimiento;
    } else {
      fechaSeleccionada = DateTime.now();
    }
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
        title: Text("Adicionar Paciente"),
      ),
      body: Form(
        key: _formKey,
        child: Container(
          padding: EdgeInsets.all(10.0),
          child: Center(
            child: ListView(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 15),
                  child: Container(
                      width: 190,
                      height: 190,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: _decideImageView()),
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: ElevatedButton.icon(
                    icon: Icon(Icons.edit),
                    onPressed: () async {
                      await _showChoiceDialog(context);

                      setState(() {
                        this.controladorimagenUrl.text = null;
                      });
                    },
                    label:
                        Text("Editar imagen", style: TextStyle(fontSize: 15)),
                  ),
                ),
                CustomTextFormField(
                    customController: controlIdentificacion,
                    labelText: "Identificación"),
                CustomTextFormField(
                    customController: controlNombre, labelText: "Nombre"),
                CustomTextFormField(
                    customController: controlApellido, labelText: "Apellido"),
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
                      hintText: fechaSeleccionada.toLocal().toString().split(' ')[0],
                      labelText: "Fecha de nacimiento",
                      fillColor: Colors.white70),
                ),
              ),
                CustomTextFormField(
                    customController: controlDireccion,
                    labelText: "Dirección"),
                CustomTextFormField(
                    customController: controlBarrio,
                    labelText: "Barrio"),
                 CustomTextFormField(
                    customController: controlTelefono,
                    labelText: "Teléfono"),   
                SwitchListTile(
                  title: Text('¿Esta activo?'),
                  value: estaActivo,
                  onChanged: (bool value) {
                    setState(() {
                      estaActivo = value;
                    });
                  },
                ),
             
                ElevatedButton(
                  child: Text("Adicionar Paciente"),
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                        if (imageFile != null) {
                          await ImageStorage(
                                  file: imageFile, idPaciente: controlIdentificacion.text)
                              .subirImagenPaciente();
                        }
                        await DatabaseService()
                            .insertarDatosPaciente(
                                controlIdentificacion.text,
                                controlNombre.text,
                                controlApellido.text,
                                "https://firebasestorage.googleapis.com/v0/b/libro-de-cobros-flutter.appspot.com/o/Pacientes%2F" +
                                    controlIdentificacion.text +
                                    ".jpg?alt=media&token=25e31b9e-51ce-4027-a163-cb4418e81e41",
                                fechaSeleccionada,
                                calcularEdad(fechaSeleccionada),
                                estaActivo,
                                controlDireccion.text,
                                controlBarrio.text,
                                controlTelefono.text);
                        Navigator.pop(context);   
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void popupButtonSelected(String value) {
    print(value);
  }

  // ignore: missing_return
  String estadoTrabajando(bool trabaja) {
    // ignore: unnecessary_statements
    trabaja ? "En servicio" : "Libre";
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
      return Center(child: Text("No se ha seleccionado una imagen"));
    } else {
      return Image.file(imageFile, width: 400, height: 400);
    }
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

  
  calcularEdad(DateTime fechaNacimiento) {
    DateTime fechaActual = DateTime.now();
    int age = fechaActual.year - fechaNacimiento.year;
    int month1 = fechaActual.month;
    int month2 = fechaNacimiento.month;
    if (month2 > month1) {
      age--;
    } else if (month1 == month2) {
      int day1 = fechaActual.day;
      int day2 = fechaNacimiento.day;
      if (day2 > day1) {
        age--;
      }
    }
    return age;
  }
}
