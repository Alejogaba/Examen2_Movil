import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:libro_de_cobros/entidades/usuario.dart';
import 'package:libro_de_cobros/servicios/auth.dart';
import 'package:libro_de_cobros/servicios/database.dart';
import 'package:libro_de_cobros/servicios/imageStorage.dart';
import 'package:libro_de_cobros/vistas/generalWidgets/customTextFormField.dart';
import 'package:libro_de_cobros/vistas/inicio/principal.dart';

class AdicionarModificarPaciente extends StatefulWidget {
  final nombre;
  final apellido;
  final urlImagen;
  final estado;
  final fechaNacimiento;
  final telefono;
  final ciudad;
  final barrio;
  final direccion;
  final idPaciente;
  final modoEditar;

  const AdicionarModificarPaciente(
      {Key key,
      this.nombre,
      this.apellido,
      this.fechaNacimiento,
      this.urlImagen,
      this.estado,
      this.telefono,
      this.ciudad,
      this.barrio,
      this.direccion,
      this.idPaciente,
      this.modoEditar})
      : super(key: key);
  @override
  _AdicionarModificarPacienteState createState() => _AdicionarModificarPacienteState(
      this.nombre,
      this.apellido,
      this.fechaNacimiento,
      this.urlImagen,
      this.estado,
      this.telefono,
      this.ciudad,
      this.barrio,
      this.direccion,
      this.idPaciente,
      this.modoEditar);
}

class _AdicionarModificarPacienteState extends State<AdicionarModificarPaciente> {
  TextEditingController controlNombre = TextEditingController();
  TextEditingController controlApellido = TextEditingController();
  TextEditingController controlIdentificacion = TextEditingController();
  TextEditingController controlTrabajando = TextEditingController();
  TextEditingController controlDireccion = TextEditingController();
  TextEditingController controlBarrio = TextEditingController();
  TextEditingController controlTelefono = TextEditingController();
  TextEditingController controlCiudad = TextEditingController();
  TextEditingController controlFecha = TextEditingController();
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

  String nombre;
  String apellido;
  DateTime fechaNacimientoEdit;
  bool estadoEdit;
  String telefono;
  String ciudad;
  String barrio;
  String direccion;
  String idPaciente;
  bool modoEditar = false;

  _AdicionarModificarPacienteState(
      this.nombre,
      this.apellido,
      this.fechaNacimientoEdit,
      this.urlImagen,
      this.estadoEdit,
      this.telefono,
      this.ciudad,
      this.barrio,
      this.direccion,
      this.idPaciente,
      this.modoEditar);

  @override
  void initState() {
    if (fechaNacimientoEdit != null) {
      fechaSeleccionada = fechaNacimientoEdit;
      controlFecha.text = fechaNacimientoEdit.toString().split(' ')[0];
    } else {
      fechaSeleccionada = DateTime.now();
    }
    if (nombre != null) {
      controlNombre.text = nombre;
    }
    if (apellido != null) {
      controlApellido.text = apellido;
    }
    if (idPaciente != null) {
      controlIdentificacion.text = idPaciente;
    }
    if (ciudad != null) {
      controlCiudad.text = ciudad;
    }
    if (barrio != null) {
      controlBarrio.text = barrio;
    }
    if (direccion != null) {
      controlDireccion.text = direccion;
    }
    if (telefono != null) {
      controlTelefono.text = telefono;
    }
    if (estadoEdit != null) {
      estaActivo = estadoEdit;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: !modoEditar
            ? Text("Adicionar Paciente")
            : Text("Modificar Paciente"),
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
                          image: urlImagen != null && imageFile == null
                              ? DecorationImage(
                                  fit: BoxFit.fill,
                                  image: NetworkImage(urlImagen))
                              : null),
                      child: urlImagen == null || imageFile != null
                          ? _decideImageView()
                          : null),
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
                    controller: controlFecha,
                    onTap: (){
                       _selectDate(context);
                    },
                    decoration: InputDecoration(
                        suffixIcon: IconButton(
                          icon: Icon(Icons.date_range),
                          onPressed: () {
                           
                          },
                        ),
                        filled: true,
                        hintStyle: TextStyle(fontSize: 20),
                        labelStyle: TextStyle(fontSize: 20),
                        hintText: fechaSeleccionada
                            .toLocal()
                            .toString()
                            .split(' ')[0],
                        labelText: "Fecha de nacimiento",
                        fillColor: Colors.transparent),
                  ),
                ),
                CustomTextFormField(
                    customController: controlDireccion, labelText: "Dirección"),
                CustomTextFormField(
                    customController: controlBarrio, labelText: "Barrio"),
                CustomTextFormField(
                    customController: controlCiudad, labelText: "Ciudad"),
                CustomTextFormField(
                    customController: controlTelefono, labelText: "Teléfono"),
                SwitchListTile(
                  title: Text('¿Esta activo?'),
                  value: estaActivo,
                  onChanged: (bool value) {
                    setState(() {
                      estaActivo = value;
                    });
                  },
                ),
                ElevatedButton.icon(
                  label: !modoEditar
                      ? Text("Adicionar Paciente")
                      : Text('Modificar Paciente'),
                  icon: !modoEditar ? Icon(Icons.add) : Icon(Icons.edit),
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      if (imageFile != null) {
                        await ImageStorage(
                                file: imageFile,
                                idPaciente: controlIdentificacion.text)
                            .subirImagenPaciente();
                      }
                      await DatabaseService().insertarDatosPaciente(
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
        controlFecha.text = picked.toString().split(' ')[0];
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
