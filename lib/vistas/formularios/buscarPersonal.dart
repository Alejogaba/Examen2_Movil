import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:libro_de_cobros/entidades/paciente.dart';
import 'package:libro_de_cobros/entidades/personal.dart';
import 'package:libro_de_cobros/servicios/auth.dart';
import 'package:libro_de_cobros/servicios/database.dart';
import 'package:libro_de_cobros/vistas/autenticar/iniciarSesion.dart';
import 'package:libro_de_cobros/vistas/generalWidgets/loading.dart';
import 'package:libro_de_cobros/vistas/inicio/controladorPestanas.dart';
import 'package:libro_de_cobros/vistas/inicio/listaPacientes.dart';
import 'package:libro_de_cobros/vistas/formularios/adicionarModificarPaciente.dart';
import 'package:libro_de_cobros/vistas/formularios/adicionarModificarPersonal.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:libro_de_cobros/vistas/perfil/perfilPersonal.dart';
import '../../entidades/usuario.dart';
import 'package:provider/provider.dart';
import 'package:libro_de_cobros/vistas/inicio/listaPersonal.dart';

class BuscarPersonal extends StatefulWidget {
  BuscarPersonal({Key key}) : super(key: key);

  @override
  _BuscarPersonalState createState() => _BuscarPersonalState();
}

class _BuscarPersonalState extends State<BuscarPersonal>
    with SingleTickerProviderStateMixin {
  List<Usuario> _clientes = [];
  AuthService authService = new AuthService();
  String uid = '';
  dynamic providerTipo = Personal;
  dynamic providerValue = DatabaseService().usuariosPersonal;
  String titulo = 'Lista personal de la salud';
  int tabIndex = 0;
  TextEditingController controlDatoBuscado = new TextEditingController();
  bool loading = false;
  List<Personal> _listaPersonal = [];

  TabController _tabController;

  @override
  void initState() {
    getUid();
    //DatabaseService(uid: uid).usuarios;
    setState(() {});
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _listaPersonal = Provider.of<List<Personal>>(context);
    super.dispose();
  }

  _BuscarPersonalState();

  @override
  Widget build(BuildContext context) {
    var streamProvider;
    try {
      streamProvider = StreamProvider<List<Personal>>.value(
        value: DatabaseService().usuariosPersonal,
        initialData: null,
        child: Scaffold(
          appBar: AppBar(
              title: TextField(
              style: TextStyle(fontSize: 20),
              controller: controlDatoBuscado,
              onChanged: (val) {
                _listaPersonal = _listaPersonal
                    .where((dato) =>
                        dato.nombre.toLowerCase().contains(val.toLowerCase()))
                    .toList();
              },
            ),
              ),
          body: ListView.builder(
              itemCount: _listaPersonal.length,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () {},
                  onLongPress: () {
                    setState(() {});
                  },
                  title: Row(
                    children: [
                      Text(_listaPersonal[index].nombre +
                          ' ' +
                          _listaPersonal[index].apellido),
                      Spacer(),
                      Text(
                        'Estado: ' +
                            esActivo(_listaPersonal[index].estadoActivo),
                        textAlign: TextAlign.right,
                      )
                    ],
                  ),
                  subtitle: Row(children: [
                    Text(_listaPersonal[index].tipo),
                    Spacer(),
                    Text(
                      _listaPersonal[index].trabajando,
                      textAlign: TextAlign.right,
                    ),
                  ]),
                  leading: CircleAvatar(
                    child: (_listaPersonal[index].urlImagen == null)
                        ? Text(_listaPersonal[index]
                            .nombre
                            .toUpperCase()
                            .substring(0, 1))
                        : null,
                    backgroundImage: (_listaPersonal[index].urlImagen != null)
                        ? NetworkImage(_listaPersonal[index].urlImagen)
                        : null,
                  ),
                );
              }),
        ),
      );
      loading = true;
    } catch (e) {
      streamProvider = null;
      loading = false;
      print(e);
    }
    return MaterialApp(
      title: 'Lista de clientes',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: streamProvider,
    );
  }

  String esActivo(bool estado) {
    if (estado == true) {
      return "Activo";
    } else {
      return "Inactivo";
    }
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

  _eliminarcliente(context, Usuario client) {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: Text('Eliminar cliente'),
              content: Text('¿Desea eliminar a ' +
                  client.nombre +
                  ' ' +
                  client.apellido +
                  '?'),
              actions: [
                TextButton(
                    onPressed: () {
                      setState(() {
                        _clientes.remove(client);
                        Navigator.of(context, rootNavigator: true)
                            .pop('dialog');
                      });
                    },
                    child: Text(
                      'Eliminar',
                      style: TextStyle(color: Colors.red),
                    )),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Cancelar',
                      style: TextStyle(color: Colors.blueGrey),
                    ))
              ],
            ));
  }

  getUid() async {
    uid = await authService.getCurrentUid();
    print('Usuario actual: ' + uid);
  }
}
