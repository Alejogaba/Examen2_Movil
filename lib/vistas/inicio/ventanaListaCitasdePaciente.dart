import 'package:flutter/material.dart';
import 'package:libro_de_cobros/entidades/cita.dart';
import 'package:libro_de_cobros/entidades/personal.dart';
import 'package:libro_de_cobros/servicios/auth.dart';
import 'package:libro_de_cobros/servicios/database.dart';
import 'package:libro_de_cobros/vistas/autenticar/iniciarSesion.dart';
import 'package:libro_de_cobros/vistas/inicio/listaCitas.dart';
import 'package:libro_de_cobros/vistas/inicio/listaPacientes.dart';
import 'package:provider/provider.dart';
import 'package:libro_de_cobros/vistas/inicio/listaPersonal.dart';

class VentanaListaCitasdePaciente extends StatefulWidget {
  final String uid;
  

  VentanaListaCitasdePaciente({Key key, this.uid}) : super(key: key);

  @override
  _VentanaListaCitasdePacienteState createState() =>
      _VentanaListaCitasdePacienteState(this.uid);
}

class _VentanaListaCitasdePacienteState
    extends State<VentanaListaCitasdePaciente>
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
  String _uid;
  String personaluid;

  _VentanaListaCitasdePacienteState(this.personaluid);

  @override
  void initState() {
    _tabController = new TabController(length: myTabs.length, vsync: this);
    if (personaluid != null) {
      uid = personaluid;
    } else {
      getUid();
    }
    //DatabaseService(uid: uid).usuarios;
    setState(() {});
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('UID personal medico: ' + uid);
    var streamProvider = StreamProvider<List<Cita>>.value(
      value: DatabaseService(uid: uid).citasPaciente,
      initialData: null,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Citas asignadas"),
          actions: [
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: () async {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (_) => IniciarSesion()));
                await authService.cerrarSesion();
              },
            ),
          ],
        ),
        body: ListaCitas(msgAtender: 'Lo atendera: ',citaArchivada: false,),
      ),
    );
    return streamProvider;
  }

  getUid() async {
    uid = await authService.getCurrentUid();
    print('Usuario actual: ' + uid);
    setState(() {
      _uid = uid;
    });
  }
}
