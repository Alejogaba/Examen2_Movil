import 'package:flutter/material.dart';
import 'package:libro_de_cobros/entidades/paciente.dart';
import 'package:libro_de_cobros/entidades/personal.dart';
import 'package:libro_de_cobros/servicios/auth.dart';
import 'package:libro_de_cobros/servicios/database.dart';
import 'package:libro_de_cobros/vistas/inicio/listaPacientes.dart';
import 'package:provider/provider.dart';
import 'package:libro_de_cobros/vistas/inicio/listaPersonal.dart';

class VentanaListaPacientes extends StatefulWidget {
  VentanaListaPacientes({Key key}) : super(key: key);

  @override
  _VentanaListaPacientesState createState() => _VentanaListaPacientesState();
}

class _VentanaListaPacientesState extends State<VentanaListaPacientes>
    with SingleTickerProviderStateMixin {
  AuthService authService = new AuthService();
  String uid = '';
  dynamic providerTipo = Personal;
  dynamic providerValue = DatabaseService().usuariosPersonal;
  String titulo = 'Lista personal de la salud';
  int tabIndex = 0;
 
  final List<Tab> myTabs = <Tab>[
    new Tab(
      child: ListaPersonal(),
    ),
    new Tab(child: ListaPacientes()),
    new Tab(child: Icon(Icons.view_agenda)),
  ];

  TabController _tabController;

  @override
  void initState() {
    _tabController = new TabController(length: myTabs.length, vsync: this);
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

  _VentanaListaPacientesState();

  @override
  Widget build(BuildContext context) {
    var streamProvider = StreamProvider<List<Paciente>>.value(
      value: DatabaseService().usuariosPacientes,
      initialData: null,
      child: Scaffold(
        body: ListaPacientes(),
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


  getUid() async {
    uid = await authService.getCurrentUid();
    print('Usuario actual: ' + uid);
  }
}
