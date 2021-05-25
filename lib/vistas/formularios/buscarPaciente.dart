import 'package:flutter/material.dart';
import 'package:libro_de_cobros/entidades/paciente.dart';
import 'package:libro_de_cobros/entidades/personal.dart';
import 'package:libro_de_cobros/servicios/auth.dart';
import 'package:libro_de_cobros/servicios/database.dart';
import 'package:libro_de_cobros/vistas/generalWidgets/themeData.dart';
import 'package:libro_de_cobros/vistas/inicio/listaPacientes.dart';
import 'package:provider/provider.dart';

class BuscarPaciente extends StatefulWidget {
  BuscarPaciente({Key key}) : super(key: key);

  @override
  _BuscarPersonal2State createState() => _BuscarPersonal2State();
}

class _BuscarPersonal2State extends State<BuscarPaciente>
    with SingleTickerProviderStateMixin {
  AuthService authService = new AuthService();
  String uid = '';
  dynamic providerTipo = Personal;

  String titulo = 'Lista pacientes';
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
    var streamProvider = StreamProvider<List<Paciente>>.value(
      value: DatabaseService().usuariosPacientes,
      initialData: null,
      child: Theme(
              data: MiTema().light(),
              child: Scaffold(
          appBar: AppBar(
            title: Text(titulo),
          ),
          body: ListaPacientes(
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

  

  getUid() async {
    uid = await authService.getCurrentUid();
    print('Usuario actual: ' + uid);
  }
}
