import 'dart:io';
import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import 'package:libro_de_cobros/servicios/auth.dart';
import 'package:libro_de_cobros/servicios/database.dart';
import 'package:libro_de_cobros/servicios/imageStorage.dart';
import 'package:libro_de_cobros/vistas/generalWidgets/customTextFormField.dart';

class AdicionarModificarPersonal extends StatefulWidget {
  final nombre;
  final apellido;
  final tipo;
  final trabajando;
  final email;
  final contrasena;
  final urlImagen;
  final estado;
  final uid;

  const AdicionarModificarPersonal(
      {Key key,
      this.nombre,
      this.apellido,
      this.tipo,
      this.trabajando,
      this.email,
      this.contrasena,
      this.urlImagen,
      this.estado,
      this.uid})
      : super(key: key);

  @override
  _AdicionarModificarPersonalState createState() =>
      _AdicionarModificarPersonalState(
          this.nombre,
          this.apellido,
          this.tipo,
          this.trabajando,
          this.email,
          this.contrasena,
          this.urlImagen,
          this.estado,
          this.uid);
}

class _AdicionarModificarPersonalState
    extends State<AdicionarModificarPersonal> {
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
  bool obscureTextPassword = true;
  bool loading = true;
  bool textFormVisible = true;

  bool estaActivo = false;
  bool estaTrabajando = false;
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  String nombre;
  String apellido;
  String tipoEdit;
  String trabajandoEdit;
  String email;
  String contrasena;
  bool estado;
  String uid;

  _AdicionarModificarPersonalState(
      this.nombre,
      this.apellido,
      this.tipoEdit,
      this.trabajandoEdit,
      this.email,
      this.contrasena,
      this.urlImagen,
      this.estado,
      this.uid);

  @override
  void initState() {
    if (uid != null) {
      textFormVisible = false;
    }
    if (nombre != null) {
      controlNombre.text = nombre;
    }
    if (apellido != null) {
      controlApellido.text = apellido;
    }
    if (tipoEdit != null) {
      controlTipo.text = tipoEdit;
    } else {
      controlTipo.text = "Medico";
    }
    if (email != null) {
      controlEmail.text = email;
    }
    if (contrasena != null) {
      controlContrasena.text = contrasena;
    }
    if (estado != null) {
      estaActivo = estado;
    }
    if (trabajandoEdit != null) {
      estaTrabajando = trabajandoEdit == 'En servicio' ? true : false;
      trabajando = trabajandoEdit;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var scafold = Scaffold(
      appBar: AppBar(
        title: uid == null
            ? Text("Adicionar personal Medico")
            : Text("Modificar personal medico"),
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
                    customController: controlNombre, labelText: "Nombre"),
                CustomTextFormField(
                    customController: controlApellido, labelText: "Apellido"),
                Padding(
                  padding: EdgeInsets.all(25.0),
                  child: DropdownButton(
                      value: controlTipo.text,
                      items: [
                        DropdownMenuItem(
                          child: Text("Medico"),
                          value: "Medico",
                        ),
                        DropdownMenuItem(
                          child: Text("Enfermero"),
                          value: "Enfermero",
                        ),
                        DropdownMenuItem(
                          child: Text("Fisioterapeuta"),
                          value: "Fisioterapeuta",
                        ),
                       
                      ],
                      onChanged: (value) {
                        setState(() {
                          controlTipo.text = value;
                        });
                      }),
                ),
                textFormVisible
                    ? CustomTextFormField(
                        customController: controlEmail,
                        labelText: "Correo electronico")
                    : Padding(
                        padding: EdgeInsets.all(0),
                      ),
                textFormVisible
                    ? Padding(
                        padding: EdgeInsets.all(25.0),
                        child: TextFormField(
                          style: TextStyle(fontSize: 20),
                          validator: (val) =>
                              val.isEmpty ? 'No deje campos vacios' : null,
                          obscureText: obscureTextPassword,
                          controller: controlContrasena,
                          decoration: InputDecoration(
                              labelText: "Contrase??a",
                              suffixIcon: IconButton(
                                icon: Icon(Icons.visibility),
                                onPressed: () {
                                  setState(() {
                                    obscureTextPassword
                                        ? obscureTextPassword = false
                                        : obscureTextPassword = true;
                                  });
                                },
                              )),
                        ),
                      )
                    : Padding(
                        padding: EdgeInsets.all(0),
                      ),
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
                  title: Text('??Esta activo?'),
                  value: estaActivo,
                  onChanged: (bool value) {
                    setState(() {
                      estaActivo = value;
                    });
                  },
                ),
                ElevatedButton.icon(
                  label: uid == null
                      ? Text("Adicionar Personal")
                      : Text('Modificar Personal'),
                  icon: uid == null ? Icon(Icons.add) : Icon(Icons.edit),
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      loading = false;
                      try {
                        if (uid == null) {
                          dynamic result =
                              await _auth.registroConUsuarioyContrasena(
                                  controlEmail.text.trim(),
                                  controlContrasena.text.trim());
                          if (result.toString().contains("Error")) {
                            await cajaAdvertencia(context, result.toString());
                            print("mostrar toast");
                          } else {
                            if (imageFile != null) {
                              await ImageStorage(
                                      file: imageFile,
                                      uid: result.uid.toString())
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
                        } else {
                          if (imageFile != null) {
                            await ImageStorage(file: imageFile, uid: uid)
                                .subirImagenPersonal();
                          }
                          await DatabaseService(uid: uid).insertarDatosPersonal(
                              controlEmail.text,
                              controlContrasena.text,
                              controlNombre.text,
                              controlApellido.text,
                              "https://firebasestorage.googleapis.com/v0/b/libro-de-cobros-flutter.appspot.com/o/Personal%2F" +
                                  uid +
                                  ".jpg?alt=media&token=25e31b9e-51ce-4027-a163-cb4418e81e41",
                              controlTipo.text,
                              estaActivo,
                              trabajando);
                          Navigator.pop(context);
                        }
                      } catch (e) {
                        print("Error al actualizar personal medico: " +
                            e.message);
                        cajaAdvertencia(
                            context,
                            "Error al actualizar personal medico: " +
                                e.message);

                        loading = true;
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

    return MaterialApp(
      title: 'Lista de clientes',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: scafold,
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

  cajaAdvertencia(BuildContext context, String msg) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(children: [
            Image.network(
              'https://www.lineex.es/wp-content/uploads/2018/06/alert-icon-red-11-1.png',
              width: 50,
              height: 50,
              fit: BoxFit.contain,
            ),
            Text('  Advertencia ')
          ]),
          content: Text(msg),
          actions: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(primary: Colors.grey),
              child: Text("Ok"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
