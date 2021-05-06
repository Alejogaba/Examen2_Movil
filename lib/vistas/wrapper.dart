import 'package:flutter/material.dart';
import 'package:libro_de_cobros/entidades/usuario.dart';
import 'package:libro_de_cobros/vistas/autenticar/iniciarSesion.dart';
import 'package:libro_de_cobros/vistas/inicio/principal.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final usuario = Provider.of<Usuario>(context);

    //retorna ya sea el widget de autenticar o el de inicio
    if (usuario != null) {
      return Principal();
    } else {
      return IniciarSesion();
    }
  }
}
