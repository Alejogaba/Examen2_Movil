import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:libro_de_cobros/entidades/usuario.dart';
import 'package:libro_de_cobros/servicios/auth.dart';
import 'package:libro_de_cobros/servicios/database.dart';
import 'package:libro_de_cobros/servicios/imageStorage.dart';
import 'package:libro_de_cobros/vistas/generalWidgets/customTextFormField.dart';
import 'package:libro_de_cobros/vistas/inicio/principal.dart';

class AdicionarPersonal extends StatefulWidget {
  @override
  _AdicionarPersonalState createState() => _AdicionarPersonalState();
}

class _AdicionarPersonalState extends State<AdicionarPersonal> {
  TextEditingController controlNombre = TextEditingController();
  TextEditingController controlApellido = TextEditingController();
  TextEditingController controlTipo = TextEditingController();
  TextEditingController controlTrabajando = TextEditingController();
  TextEditingController controlEmail = TextEditingController();
  TextEditingController controlContrasena = TextEditingController();
  TextEditingController controladorimagenUrl = new TextEditingController();
  List<String> listaTipo = ["Medico", "Enfermero", "Fisioterapeuta"];
  String tipo = '';
  String trabajando;
  String urlImagen;
  File imageFile;
  bool loading;

  bool estaActivo = false;
  bool estaTrabajando = false;
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
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
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Adicionar Personal"),
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
                        /* image: DecorationImage(
                            fit: BoxFit.fill,
                            image: NetworkImage(
                                "https://www.adl-logistica.org/wp-content/uploads/2019/07/imagen-perfil-sin-foto-300x300.png")
                                )*/
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
                    customController: controlNombre, labelText: "Nombre"),
                CustomTextFormField(
                    customController: controlApellido, labelText: "Apellido"),
                CustomTextFormField(
                    customController: controlTipo,
                    labelText: "Tipo (Medico,Enfermero,Fisioterapeuta"),
                CustomTextFormField(
                    customController: controlEmail,
                    labelText: "Correo electronico"),
                CustomTextFormField(
                    customController: controlContrasena,
                    labelText: "Contraseña"),
                /*Container(
                  padding: EdgeInsets.all(20.0),
                  child: DropdownButton(
                    value: tipo,
                    items: [
                      DropdownMenuItem(child: Text("Medico")),
                      DropdownMenuItem(child: Text("Enfermero")),
                      DropdownMenuItem(
                        child: Text("Fisioterapeuta"),
                      ),
                    ],
                    onChanged: (value) => {
                      setState(() {
                        tipo = value;
                        print(value);
                      })
                    },
                  ),
                ),
                */
                SwitchListTile(
                  title: Text('¿Esta activo?'),
                  value: estaActivo,
                  onChanged: (bool value) {
                    setState(() {
                      estaActivo = value;
                    });
                  },
                ),
                SwitchListTile(
                  title: Text('¿Esta trabajando?'),
                  value: estaTrabajando,
                  onChanged: (bool value) {
                    setState(() {
                      estaTrabajando = value;
                      trabajando =  value ? "En servicio" : "Libre";
                    });
                  },
                ),
                ElevatedButton(
                  child: Text("Adicionar Personal"),
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      dynamic result = await _auth.registerWithEmailAndPassword(
                          controlEmail.text.trim(),
                          controlContrasena.text.trim());
                      if (result == null) {
                        setState(() {
                          print('Please supply a valid email');
                        });
                      } else {
                        if (imageFile != null) {
                          await ImageStorage(
                                  file: imageFile, uid: result.uid.toString())
                              .subirImagenPersonal();
                        }
                        await DatabaseService(uid: result.uid.toString())
                            .insertarDatosPersonal(
                                controlEmail.text,
                                controlContrasena.text,
                                controlNombre.text,
                                controlApellido.text,
                                "https://firebasestorage.googleapis.com/v0/b/libro-de-cobros-flutter.appspot.com/o/Personal%2F" +
                                    result.uid.toString() +
                                    ".jpg?alt=media&token=25e31b9e-51ce-4027-a163-cb4418e81e41",
                                controlTipo.text,
                                estaActivo,
                                trabajando);
                        Navigator.pop(context);
                      }
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
}
