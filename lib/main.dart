import 'package:flutter/material.dart';
import 'package:libro_de_cobros/entidades/usuario.dart';
import 'package:libro_de_cobros/servicios/auth.dart';
import 'package:libro_de_cobros/vistas/generalWidgets/themeData.dart';
import 'package:libro_de_cobros/vistas/wrapper.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<Usuario>.value(
      value: AuthService().usuario,
          initialData: null,
          child: MaterialApp(
            theme: MiTema().tema(),
         home: Wrapper(),
      ),
    );
  }
}
