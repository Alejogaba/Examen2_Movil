import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:libro_de_cobros/entidades/paciente.dart';
import 'package:libro_de_cobros/entidades/personal.dart';
import 'package:libro_de_cobros/servicios/auth.dart';
import 'package:libro_de_cobros/servicios/database.dart';
import 'package:libro_de_cobros/vistas/autenticar/iniciarSesion.dart';
import 'package:libro_de_cobros/vistas/formularios/agendarCita.dart';
import 'package:libro_de_cobros/vistas/generalWidgets/themeData.dart';
import 'package:libro_de_cobros/vistas/inicio/controladorPestanas.dart';
import 'package:libro_de_cobros/vistas/inicio/listaPacientes.dart';
import 'package:libro_de_cobros/vistas/inicio/ventanaListaPacientes.dart';
import 'package:libro_de_cobros/vistas/formularios/adicionarPaciente.dart';
import 'package:libro_de_cobros/vistas/formularios/adicionarPersonal.dart';
import '../../entidades/usuario.dart';
import 'package:provider/provider.dart';
import 'package:libro_de_cobros/vistas/inicio/listaPersonal.dart';

class BuscarPersonal2 extends StatefulWidget {
  BuscarPersonal2({Key key}) : super(key: key);

  @override
  _BuscarPersonal2State createState() => _BuscarPersonal2State();
}

class _BuscarPersonal2State extends State<BuscarPersonal2>
    with SingleTickerProviderStateMixin {
  List<Usuario> _clientes = [];
  AuthService authService = new AuthService();
  String uid = '';
  dynamic providerTipo = Personal;
  dynamic providerValue = DatabaseService().usuariosPersonal;
  String titulo = 'Lista personal de la salud';
  int tabIndex = 0;

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
    super.dispose();
  }

  _BuscarPersonal2State();

  @override
  Widget build(BuildContext context) {
    var streamProvider = StreamProvider<List<Personal>>.value(
      value: providerValue,
      initialData: null,
      child: Theme(
              data: MiTema().light(),
              child: Scaffold(
          appBar: AppBar(
            title: Text(titulo),
          ),
          body: ListaPersonal(
            modoSeleccionar: true,
            contextPadre: context,
          ),
        ),
      ),
    );
    return streamProvider;
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
