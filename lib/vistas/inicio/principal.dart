import 'dart:io';

import 'package:flutter/material.dart';
import 'package:libro_de_cobros/entidades/personal.dart';
import 'package:libro_de_cobros/servicios/auth.dart';
import 'package:libro_de_cobros/servicios/pdf_api.dart';
import 'package:libro_de_cobros/servicios/database.dart';
import 'package:libro_de_cobros/vistas/autenticar/iniciarSesion.dart';
import 'package:libro_de_cobros/vistas/formularios/agendarCita.dart';
import 'package:libro_de_cobros/vistas/inicio/ventanaListaCitas.dart';
import 'package:libro_de_cobros/vistas/inicio/ventanaListaPacientes.dart';
import 'package:libro_de_cobros/vistas/formularios/adicionarModificarPaciente.dart';
import 'package:libro_de_cobros/vistas/formularios/adicionarModificarPersonal.dart';
import 'package:provider/provider.dart';
import 'package:libro_de_cobros/vistas/inicio/listaPersonal.dart';

class Principal extends StatefulWidget {
  Principal({Key key}) : super(key: key);

  @override
  _PrincipalState createState() => _PrincipalState();
}

class _PrincipalState extends State<Principal>
    with SingleTickerProviderStateMixin {
  AuthService authService = new AuthService();
  String uid = '';
  dynamic providerTipo = Personal;
  dynamic providerValue = DatabaseService().usuariosPersonal;
  String titulo = 'Lista personal de la salud';
  int tabIndex = 0;
  dynamic abrirPdf = 0;
  final List<Tab> myTabs = <Tab>[
    new Tab(
      child: ListaPersonal(
        modoSeleccionar: false,
      ),
    ),
    new Tab(child: VentanaListaPacientes()),
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

  _PrincipalState();

  @override
  Widget build(BuildContext context) {
    var streamProvider = StreamProvider<List<Personal>>.value(
      value: providerValue,
      initialData: null,
      child: Scaffold(
        appBar: AppBar(
          title: Text(titulo),
          actions: [
            IconButton(
              icon: Icon(Icons.book),
              onPressed: () async {
                switch (tabIndex) {
                  case 0:
                    await PdfApi.openFilePersonal('personal.pdf');
                    break;
                  case 1:
                    await PdfApi.openFilePersonal('pacientes.pdf');
                  break;
                  case 2:
                    await PdfApi.openFilePersonal('citas.pdf');
                  break;
                  default:
                  await PdfApi.openFilePersonal('personal.pdf');
                }
                
                print('abrir pdf');
              },
            ),
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: () async {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (_) => IniciarSesion()));
                await authService.cerrarSesion();
              },
            ),
          ],
          bottom: TabBar(
            onTap: (index) {
              setState(() {
                tabIndex = index;
                print(index);
                switch (index) {
                  case 0:
                    titulo = 'Lista de personal de la salud';
                    break;
                  case 1:
                    titulo = 'Lista de pacientes';
                    break;
                  case 2:
                    titulo = 'Citas';
                    break;
                  default:
                    titulo = 'Lista personal de la salud';
                    break;
                }
              });
            },
            tabs: [
              Tab(icon: Icon(Icons.medical_services)),
              Tab(icon: Icon(Icons.person)),
              Tab(icon: Icon(Icons.view_agenda)),
            ],
            controller: _tabController,
          ),
        ),
        body: TabBarView(controller: _tabController, children: [
          ListaPersonal(),
          VentanaListaPacientes(),
          VentanaListaCitas(),
        ]),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            setState(() async {
              switch (tabIndex) {
                case 0:
                  await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => AdicionarModificarPersonal()));
                  setState(() {
                    abrirPdf = 0;
                  });
                  break;
                case 1:
                  await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => AdicionarModificarPaciente(
                                modoEditar: false,
                              )));
                  setState(() {
                    abrirPdf = 1;
                  });
                  break;
                case 2:
                  await Navigator.push(context,
                      MaterialPageRoute(builder: (_) => AgendarCita()));
                  setState(() {
                    abrirPdf = 2;
                  });
                  break;
                default:
                  await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => AdicionarModificarPersonal()));
                  setState(() {
                    abrirPdf = 0;
                  });
                  break;
              }
            });
          },
          child: Icon(Icons.add),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
    return MaterialApp(
      title: 'Lista de clientes',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: streamProvider,
    );
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
