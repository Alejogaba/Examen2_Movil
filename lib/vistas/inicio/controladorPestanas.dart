import 'package:flutter/material.dart';
import 'package:libro_de_cobros/entidades/usuario.dart';
import 'package:libro_de_cobros/servicios/auth.dart';
import 'package:libro_de_cobros/vistas/autenticar/iniciarSesion.dart';
import 'package:libro_de_cobros/vistas/inicio/listaPersonal.dart';
import 'package:libro_de_cobros/vistas/formularios/adicionarModificarPaciente.dart';
import 'package:libro_de_cobros/vistas/formularios/adicionarModificarPersonal.dart';

class ControladorPestanas extends StatefulWidget {
  ControladorPestanas({Key key}) : super(key: key);

  @override
  _ControladorPestanasState createState() => _ControladorPestanasState();
}

class _ControladorPestanasState extends State<ControladorPestanas> {
  List<Usuario> _clientes = [];
  AuthService authService = new AuthService();
  String uid = '';
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
       
        body: TabBarView(children: [
          ListaPersonal(),
          Icon(Icons.person),
          Icon(Icons.view_agenda),
        ]),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            final indextab = DefaultTabController.of(context).index;
            switch (indextab) {
              case 0:
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => AdicionarModificarPersonal()));
                break;
              case 1:
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => AdicionarModificarPaciente()));
                break;
              default:
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => AdicionarModificarPersonal()));
                break;
            }
          },
          child: Icon(Icons.add),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}
