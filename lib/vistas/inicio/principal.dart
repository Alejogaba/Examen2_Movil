import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:libro_de_cobros/entidades/paciente.dart';
import 'package:libro_de_cobros/entidades/personal.dart';
import 'package:libro_de_cobros/servicios/auth.dart';
import 'package:libro_de_cobros/servicios/database.dart';
import 'package:libro_de_cobros/vistas/autenticar/iniciarSesion.dart';
import 'package:libro_de_cobros/vistas/formularios/agendarCita.dart';
import 'package:libro_de_cobros/vistas/inicio/controladorPestanas.dart';
import 'package:libro_de_cobros/vistas/inicio/listaPacientes.dart';
import 'package:libro_de_cobros/vistas/inicio/ventanaListaCitas.dart';
import 'package:libro_de_cobros/vistas/inicio/ventanaListaPacientes.dart';
import 'package:libro_de_cobros/vistas/formularios/adicionarPaciente.dart';
import 'package:libro_de_cobros/vistas/formularios/adicionarPersonal.dart';
import 'agregarModificar.dart';
import '../../entidades/usuario.dart';
import 'package:provider/provider.dart';
import 'package:libro_de_cobros/vistas/inicio/listaPersonal.dart';

class Principal extends StatefulWidget {
  Principal({Key key}) : super(key: key);

  @override
  _PrincipalState createState() => _PrincipalState();
}

class _PrincipalState extends State<Principal>
    with SingleTickerProviderStateMixin {
  List<Usuario> _clientes = [];
  AuthService authService = new AuthService();
  String uid = '';
  dynamic providerTipo = Personal;
  dynamic providerValue = DatabaseService().usuariosPersonal;
  String titulo = 'Lista personal de la salud';
  int tabIndex = 0;
  final List<Tab> myTabs = <Tab>[
    new Tab(
      child: ListaPersonal(modoSeleccionar: false,),
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
                    titulo = 'Lista de personal';
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
            setState(() {
              switch (tabIndex) {
                case 0:
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => AdicionarPersonal()));
                  break;
                case 1:
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => AdicionarPaciente()));
                  break;
                case 2:
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => AgendarCita()));
                  break;
                default:
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => AdicionarPersonal()));
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